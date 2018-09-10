#include <File.au3>

Local $strLogFileName = "Uninstall-Secunia.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $strCallMsiPath = ""
Local $strUninstallPath = "xx"
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
   _FileWriteLog($hFileClient, "Pausing script execution for 45 seconds...")
   Sleep(45000)																											;Pause this script for 20 secs (to let TV uninstall complete)
   $strUninstallPath = _GetAppropriatePath('C:\Program Files*\Secunia\CSI Agent\csia.exe')								;Check if uninstall was success or failure. If success, csia.exe will get deleted.
   _FileWriteLog($hFileClient, "Searching for csia.exe file in Secunia installation folder...")
   if $strUninstallPath = "" Then
	  _FileWriteLog($hFileClient, "csia.exe not found...")
	  _FileWriteLog($hFileClient, "Secunia Uninstalled Successfully...")
	  FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
	  Exit
   EndIf
EndFunc	;==>ExitProcedure

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 												;Open the logfile on Client in write mode.
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")		;Write to the logfile on Client.
_FileWriteLog($hFileClient, "Log file opened successfully on - " & @ComputerName)										;Write to the logfile passing the filehandle returned by FileOpen.
_FileWriteLog($hFileClient, "OS Architecture is " & @OSArch)
_FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
_FileWriteLog($hFileClient, "Uninstalling Secunia - Script v1")
_FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
_FileWriteLog($hFileClient, "Determining path of uninstall.exe")

$strCallMsiPath = _GetAppropriatePath('C:\Program Files*\Secunia\CSI Agent\Uninstall.exe')								;uninstall.exe of TV v8 v9 are within a subdir of teamviewer installation folder.
if $strCallMsiPath = "" Then
   _FileWriteLog($hFileClient, "uninstall.exe NOT found...")
   _FileWriteLog($hFileClient, "Secunia CSI Agent is probably NOT installed on this System...")
   _FileWriteLog($hFileClient, "Quitting Script....")
   _FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
   FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
   Exit
EndIf

_FileWriteLog($hFileClient, "Uninstall.exe found on path - " & $strCallMsiPath)
_FileWriteLog($hFileClient, "Executing Secunia Agent Uninstallation...")
;ShellExecute('taskkill.exe', '/im teamviewer.exe /f')	;Kill TeamViewer
$iPID = ShellExecute($strCallMsiPath, '/S')	;Uninstall Secunia Agent

ProcessWaitClose($iPID)
_FileWriteLog($hFileClient, "Execution returned with code: " & @error)
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Failed :( ...")
_FileWriteLog($hFileClient, "csia.exe still exists...")
_FileWriteLog($hFileClient, "Unknown Exception, Secunia Agent requires manual Uninstall...")
_FileWriteLog($hFileClient, "Secunia Agent WAS NOT UNINSTALLED....")
_FileWriteLog($hFileClient, "Quitting Script....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																							;Close the filehandle on Client to release the file.
