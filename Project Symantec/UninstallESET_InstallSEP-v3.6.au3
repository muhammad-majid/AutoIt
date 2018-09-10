#include <File.au3>

Local $strLogFileName = "Uninstall-ESET-Install-SymantecEndPoint-2.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $strCallMsiPath
Local $iPID
Local $iCopyResult


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
   Sleep(20000)																										;Pause this script for 20 secs (to let ESET uninstall complete)
   $strCallMsiPath = _GetAppropriatePath('C:\Program Files\ESET\ESET*\callmsi.exe')									;Check if uninstall was success or failure. If success, callmsi.exe will get deleted.
   if $strCallMsiPath = "" Then
	  _FileWriteLog($hFileClient, "ESET Uninstalled Successfully...")
	  InstallSymantecEndPoint()
   Else
	  _FileWriteLog($hFileClient, "ESET Uninstallation failed, proceeding with next try...")
   EndIf
EndFunc	;==>ExitProcedure

Func InstallSymantecEndPoint()


   _FileWriteLog($hFileClient, "Preparing to Install Symantec End Point Protection ....")

    ;FileCopy(@TempDir & "\*.au3", @TempDir & "\Au3Files\", $FC_OVERWRITE + $FC_CREATEPATH)
	;FileCopy ( "source", "dest" [, flag = 0] )

   _FileWriteLog($hFileClient, "Checking OS Architecture (32 bit or 64 bit) ....")
   _FileWriteLog($hFileClient, "OS Architecture is " & @OSArch)
   _FileWriteLog($hFileClient, "Copying file from Source to temp folder...")
   If @OSArch = "X86" Then
	  $iCopyResult = FileCopy("\\192.168.41.249\ES_Softwares\SymantecEndPoint\SEP_32bit_v12.1.6867.6400.exe", @TempDir & "\SEP32\", $FC_OVERWRITE + $FC_CREATEPATH)
	  if $iCopyResult <> 0 Then
		 _FileWriteLog($hFileClient, "Copying successful...")
		 _FileWriteLog($hFileClient, "Executing Symantec End Point Client 32bit...")
		 $iPID = ShellExecute(@TempDir & "\SEP32\SEP_32bit_v12.1.6867.6400.exe")				;41.249 = eisf082
	  EndIf
   ElseIf @OSArch = "X64" Then
	  $iCopyResult = FileCopy("\\192.168.41.249\ES_Softwares\SymantecEndPoint\SEP_64bit_v12.1.6867.6400.exe", @TempDir & "\SEP64\", $FC_OVERWRITE + $FC_CREATEPATH)
	  if $iCopyResult <> 0 Then
		 _FileWriteLog($hFileClient, "Copying successful...")
		 _FileWriteLog($hFileClient, "Executing Symantec End Point Client 64bit...")
		 $iPID = ShellExecute(@TempDir & "\SEP64\SEP_64bit_v12.1.6867.6400.exe")				;41.249 = eisf082
	  EndIf
   EndIf

   ProcessWaitClose($iPID)
   if @error <> 0 Then
	  _FileWriteLog($hFileClient, "Execution returned failure with error code: " & @error)
   else
	  _FileWriteLog($hFileClient, "Symantec Installed Successfully...")
   EndIf

   _FileWriteLog($hFileClient, "Quitting Script...")
   FileClose($hFileClient)																						;Close the filehandle on Client to release the file.
   Exit
EndFunc	;==>InstallSymantecEndPoint

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 												;Open the logfile on Client in write mode.
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")		;Write to the logfile on Client.
_FileWriteLog($hFileClient, "Log file opened successfully on - " & @ComputerName)										;Write to the logfile passing the filehandle returned by FileOpen.
_FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
_FileWriteLog($hFileClient, "Installing Symantec End Point - Script v3.6")
_FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
_FileWriteLog($hFileClient, "Determining path of callmsi.exe")

$strCallMsiPath = _GetAppropriatePath('C:\Program Files\ESET\ESET*\callmsi.exe')										;find path of callmsi.exe
if $strCallMsiPath = "" Then
   _FileWriteLog($hFileClient, "callmsi.exe NOT found...")
   _FileWriteLog($hFileClient, "ESET is probabily NOT installed on this System...")
   InstallSymantecEndPoint()
Else
   _FileWriteLog($hFileClient, "callmsi.exe found on path - " & $strCallMsiPath)
EndIf

_FileWriteLog($hFileClient, "Determining Windows Version...")
_FileWriteLog($hFileClient, "Windwows Version detected is: " & @OSVersion)

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5a WITHOUT password with string {950B1859-7F95-4CCF-8674-0F843B58CCAB}..")
ShellExecute($strCallMsiPath, '/x {950B1859-7F95-4CCF-8674-0F843B58CCAB} /qn /norestart')						;Uninstall ESET v5a without password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5b WITHOUT password with string {24B89EC5-9058-463A-A86E-9E45A347124E}..")
ShellExecute($strCallMsiPath, '/x {24B89EC5-9058-463A-A86E-9E45A347124E} /qn /norestart')						;Uninstall ESET v5b without password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5a WITHOUT password with string {4544542B-6BC5-4BA8-AA52-05C07A1D59F1}..")
ShellExecute($strCallMsiPath, '/x {4544542B-6BC5-4BA8-AA52-05C07A1D59F1} /qn /norestart')						;Uninstall ESET v5a without password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5b WITHOUT password with string {D8AB89CA-2CDD-4D0A-95C1-7E9F80E96695}..")
ShellExecute($strCallMsiPath, '/x {D8AB89CA-2CDD-4D0A-95C1-7E9F80E96695} /qn /norestart')						;Uninstall ESET v5b without password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4a WITHOUT password with string {36A3719F-8A06-451A-935A-B4A5BAE77C87}..")
ShellExecute($strCallMsiPath, '/x {36A3719F-8A06-451A-935A-B4A5BAE77C87} /qn /norestart')						;Uninstall ESET v4a without Password')
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4b WITH password with string {2EEBAC31-3EEF-4118-91CB-1A286A507DB2}..")
ShellExecute($strCallMsiPath, '/x {2EEBAC31-3EEF-4118-91CB-1A286A507DB2} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v4b with Password')
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5a WITH password with string {950B1859-7F95-4CCF-8674-0F843B58CCAB}..")
ShellExecute($strCallMsiPath, '/x {950B1859-7F95-4CCF-8674-0F843B58CCAB} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5a with Password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5b WITH password with string {24B89EC5-9058-463A-A86E-9E45A347124E}..")
ShellExecute($strCallMsiPath, '/x {24B89EC5-9058-463A-A86E-9E45A347124E} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5b with Password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5a WITH password with string {4544542B-6BC5-4BA8-AA52-05C07A1D59F1}..")
ShellExecute($strCallMsiPath, '/x {4544542B-6BC5-4BA8-AA52-05C07A1D59F1} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5a with Password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v5b WITH password with string {D8AB89CA-2CDD-4D0A-95C1-7E9F80E96695}..")
ShellExecute($strCallMsiPath, '/x {D8AB89CA-2CDD-4D0A-95C1-7E9F80E96695} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v5b with Password
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4b WITHOUT password with string {2EEBAC31-3EEF-4118-91CB-1A286A507DB2}..")
ShellExecute($strCallMsiPath, '/x {2EEBAC31-3EEF-4118-91CB-1A286A507DB2} /qn /norestart')						;Uninstall ESET v4b without Password')
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "Attempting to Uninstall ESET v4a WITH password with string {36A3719F-8A06-451A-935A-B4A5BAE77C87}..")
ShellExecute($strCallMsiPath, '/x {36A3719F-8A06-451A-935A-B4A5BAE77C87} /qn /norestart PASSWORD=admin12345')	;Uninstall ESET v4a with Password')
CheckSuccess_ExitProcedure()

_FileWriteLog($hFileClient, "All tries failed :( ...")
_FileWriteLog($hFileClient, "Unknown Exception, ESET requires manual Uninstall...")
_FileWriteLog($hFileClient, "ESET WAS NOT UNINSTALLED....")
_FileWriteLog($hFileClient, "Symantec End Point was NOT INSTALLED....")
_FileWriteLog($hFileClient, "Quitting Script....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																							;Close the filehandle on Client to release the file.


