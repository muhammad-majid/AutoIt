#include <File.au3>

Local $strLogFileName = "Uninstall-ESET-Install-SymantecEndPoint.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $strCallMsiPath
Local $returnCode
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

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 														;Open the logfile on Client in write mode.
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")				;Write to the logfile on Client.
_FileWriteLog($hFileClient, "Log file opened successfully on -" & @TAB & @ComputerName)											;Write to the logfile passing the filehandle returned by FileOpen.
_FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
_FileWriteLog($hFileClient, "Uninstalling ESET and Installing Symantec End Point - Script 2.0")
_FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
_FileWriteLog($hFileClient, "Determining path of callmsi.exe")

$strCallMsiPath = _GetAppropriatePath('C:\Program Files\ESET\ESET*\callmsi.exe')												;find path of outlook.exe
if $strCallMsiPath = "" Then
_FileWriteLog($hFileClient, "callmsi.exe NOT found...")
Else
_FileWriteLog($hFileClient, "callmsi.exe found on path -" & @TAB & $strCallMsiPath)
EndIf

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4 WITHOUT password..")
$iPID = ShellExecuteWait($strCallMsiPath, '/x {36A3719F-8A06-451A-935A-B4A5BAE77C87} /qn /norestart')						;Uninstall ESET v4 without Password')
if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
EndIf

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4 WITH password..")
$iPID = ShellExecuteWait($strCallMsiPath, '/x {36A3719F-8A06-451A-935A-B4A5BAE77C87} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v4 with Password')
if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
EndIf

_FileWriteLog($hFileClient, "Determining Windows Version...")
_FileWriteLog($hFileClient, "Windwows Version detected is: " & @OSVersion)

If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then																			;XP mode
   _FileWriteLog($hFileClient, "Windwows XP detected.... Proceeding XP mode uninstall...")

   _FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5 WITHOUT password")
   $iPID = ShellExecuteWait($strCallMsiPath, '/x {950B1859-7F95-4CCF-8674-0F843B58CCAB} /qn /norestart')						;Uninstall ESET v5 without password
   if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
   EndIf

   _FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5 WITH password")
   $iPID = ShellExecuteWait($strCallMsiPath, '/x {950B1859-7F95-4CCF-8674-0F843B58CCAB} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5 with Password
   if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
   EndIf

Else																																;Win7, 8, 2008, 2012 mode
   _FileWriteLog($hFileClient, "Windwows XP NOT detected.... Proceeding Win7, Win8, Win2008, Win2012 mode Uninstall...")

   _FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5 WITHOUT password")
   $iPID = ShellExecuteWait($strCallMsiPath, '/x {4544542B-6BC5-4BA8-AA52-05C07A1D59F1} /qn /norestart')						;Uninstall ESET v5 without password
   if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
   EndIf

   _FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5 WITH password")
   $iPID = ShellExecuteWait($strCallMsiPath, '/x {4544542B-6BC5-4BA8-AA52-05C07A1D59F1} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5 with Password
   if @error <> 0 Then
	  _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
   else
	  _FileWriteLog($hFileClient, "UnInstall Successful...")
   EndIf
EndIf

_FileWriteLog($hFileClient, "Quitting....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																												;Close the filehandle on Client to release the file.



