#include <File.au3>

Local $strLogFileName = "Uninstall-TeamViewer.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $strCallMsiPath = ""
Local $strUninstallPath1 = "xx"
Local $strUninstallPath2 = "xx"
Local $iPID


If DirGetSize($strLogFilePathClient) = -1 Then				;dir does not exist
   DirCreate($strLogFilePathClient)							;create directory
EndIf

Func _GetAppropriatePath($sPath, $iLevel = 0)

    Local $hSearch, $tPath, $File, $Item, $Path, $Ret, $Dir = '', $Suf = '', $Result = ''

    $tPath = DllStructCreate('wchar[1024]')
    $Ret = DllCall('kernel32.dll', 'dword', 'GetFullPathNameW', 'wstr', $sPath, 'dword', 1024, 'ptr', DllStructGetPtr($tPath), 'ptr', 0)
    If (@error) Or (Not $Ret[0]) Then
        Return ''
    EndIf
    $sPath = DllStructGetData($tPath, 1)
    If StringRight($sPath, 1) = '\' Then
        $Dir = '\'
    EndIf
    $Item = StringSplit(StringRegExpReplace($sPath, '\\\Z', ''), '\')
    Select
        Case $iLevel + 1 = $Item[0]
            If FileExists($sPath) Then
                Return $sPath
            Else
                Return ''
            EndIf
        Case $iLevel + 1 > $Item[0]
            Return ''
    EndSelect
    For $i = 1 To $iLevel + 1
        $Result &= $Item[$i] & '\'
    Next
    $Result = StringRegExpReplace($Result, '\\\Z', '')
    If Not FileExists($Result) Then
        Return ''
    EndIf
    $hSearch = FileFindFirstFile($Result & '\*')
    If $hSearch = -1 Then
        Return ''
    EndIf
    For $i = $iLevel + 3 To $Item[0]
        $Suf &= '\' & $Item[$i]
    Next
    While 1
        $File = FileFindNextFile($hSearch)
        If @error Then
            $Result = ''
            ExitLoop
        EndIf
        If (Not @extended) And ($Dir) And ($iLevel + 2 = $Item[0]) Then
            ContinueLoop
        EndIf
        $Ret = DllCall('shlwapi.dll', 'int', 'PathMatchSpecW', 'wstr', $File, 'wstr', $Item[$iLevel + 2])
        If (Not @error) And ($Ret[0]) Then
            $Path = _GetAppropriatePath($Result & '\' & $File & $Suf & $Dir, $iLevel + 1)
            If $Path Then
                $Result = $Path
                ExitLoop
            EndIf
        EndIf
    WEnd
    FileClose($hSearch)
    Return $Result
EndFunc   ;==>_GetAppropriatePath

Func CheckSuccess_ExitProcedure()
   _FileWriteLog($hFileClient, "Pausing script execution for 30 seconds...")
   Sleep(30000)																											;Pause this script for 20 secs (to let TV uninstall complete)
   $strUninstallPath1 = _GetAppropriatePath('C:\Program Files*\TeamViewer*\uninstall.exe')								;Check if uninstall was success or failure. If success, uninstall.exe will get deleted.
   $strUninstallPath2 = _GetAppropriatePath('C:\Program Files*\TeamViewer*\*\uninstall.exe')							;Check if uninstall was success or failure. If success, uninstall.exe will get deleted.
   _FileWriteLog($hFileClient, "Searching for uninstall.exe file in TeamViewer installation folder...")
   if $strUninstallPath1 = "" AND $strUninstallPath2 = "" Then
	  _FileWriteLog($hFileClient, "Uninstall.exe not found...")
	  _FileWriteLog($hFileClient, "TeamViewer Uninstalled Successfully...")
	  FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
	  Exit
   EndIf
EndFunc	;==>ExitProcedure

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 												;Open the logfile on Client in write mode.
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")		;Write to the logfile on Client.
_FileWriteLog($hFileClient, "Log file opened successfully on - " & @ComputerName)										;Write to the logfile passing the filehandle returned by FileOpen.
_FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
_FileWriteLog($hFileClient, "Uninstalling TeamViewer - Script v3.1")
_FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
_FileWriteLog($hFileClient, "Determining path of uninstall.exe")

$strCallMsiPath = _GetAppropriatePath('C:\Program Files*\TeamViewer*\*\uninstall.exe')									;uninstall.exe of TV v8 v9 are within a subdir of teamviewer installation folder.
if $strCallMsiPath = "" Then
   $strCallMsiPath = _GetAppropriatePath('C:\Program Files*\TeamViewer*\uninstall.exe')									;uninstall.exe of TV v10 and above are in teamviewer installation folder.
EndIf

if $strCallMsiPath = "" Then																					; still empty?
   _FileWriteLog($hFileClient, "uninstall.exe NOT found...")
   _FileWriteLog($hFileClient, "TeamViewer is probabily NOT installed on this System...")
   _FileWriteLog($hFileClient, "Quitting Script....")
   _FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
   FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
   Exit
EndIf

_FileWriteLog($hFileClient, "uninstall.exe found on path - " & $strCallMsiPath)
_FileWriteLog($hFileClient, "Executing TeamViewer Uninstallation...")
ShellExecute('taskkill.exe', '/im teamviewer.exe /f')	;Kill TeamViewer
$iPID = ShellExecute($strCallMsiPath, '/S')	;Uninstall TeamViewer

ProcessWaitClose($iPID)
_FileWriteLog($hFileClient, "Execution returned with code: " & @error)
CheckSuccess_ExitProcedure()

;Opt("WinTitleMatchMode", -1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
;Local $TvWindow = WinWait("Teamviewer", "", 10)
;WinActivate($TvWindow)

;If $TvWindow = 0 Then
 ;  _FileWriteLog($hFileClient, "Couldn't grab the TeamViewer window...")
  ; FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
;   Exit
;EndIf

;_FileWriteLog($hFileClient, "Got the Teamviewer window focus...")
;Sleep(2000)																										;Pause this script for 2 secs
;Send("{ALTDOWN}u{ALTUP}")
;Sleep(5000)																										;Pause this script for 5 secs
;Send("{CTRLDOWN}w{CTRLUP}")																						;close the browser windows that appears.
;$TvWindow = WinWait("Teamviewer", "", 10)
;WinActivate($TvWindow)
;Sleep(2000)																										;Pause this script for 2 secs
;Send("{ALTDOWN}c{ALTUP}")																						;close the TV uninstallation completed window.

_FileWriteLog($hFileClient, "Failed :( ...")
_FileWriteLog($hFileClient, "Uninstall.exe still exists...")
_FileWriteLog($hFileClient, "Unknown Exception, TeamViewer requires manual Uninstall...")
_FileWriteLog($hFileClient, "TeamViewer WAS NOT UNINSTALLED....")
_FileWriteLog($hFileClient, "Quitting Script....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
