#include <File.au3>

Local $strLogFileName = "CommVault-Installation.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $strOutlookPath
Local $outlookIs32bit
Local $outlookIs64bit
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


Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 								;Open the logfile in write mode.

	  _FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
	  _FileWriteLog($hFileClient, "Log file opened successfully on -" & @TAB & @ComputerName)			;Write to the logfile passing the filehandle returned by FileOpen.
	  _FileWriteLog($hFileClient, "Checking OS Architecture (32 bit or 64 bit) ....")
	  _FileWriteLog($hFileClient, "OS Architecture is " & @OSArch)

	  If @OSArch = "X86" Then																			;os is 32 bit, so outlook can ONLY be 32bit;
		 _FileWriteLog($hFileClient, "Outlook can ONLY be 32bit in 32bit OS....")
		 _FileWriteLog($hFileClient, "Executing CommVault 32bit Addin...")
		 ;RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {903B0409-6000-11D3-8CFE-0150048383C9} /qn')		;execute the uninstall
		 ;Run ("msiexec.exe /i progA.msi TRANSFORMS=progA.mst /qr")
		 ;ShellExecuteWait('\\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi','/qn ExtraParameters="-skip"')
		 ;ShellExecute("msiexec", '/i \\server\setup.msi /qb /Lv* C:\RP_install.log PATHINI=\\server\application\Config.ini')
		 $iPID = ShellExecute("msiexec",'/i \\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi /qn ExtraParameters="-skip"')

	  ElseIf @OSArch = "X64" Then			  															;os is 64bit, check outlook.exe location;
		 _FileWriteLog($hFileClient, "Checking version of MS Office installed by location of Outlook.exe ....")

	  $strOutlookPath = _GetAppropriatePath('C:\Program File*\Microsoft Office\Offi*\Outlook.exe')		;find path of outlook.exe
			if $strOutlookPath = "" Then
			_FileWriteLog($hFileClient, "Outlook NOT found...")
			Else
			_FileWriteLog($hFileClient, "Outlook found on path -" & @TAB & $strOutlookPath)
			EndIf

			if StringInStr($strOutlookPath,"Program Files (x86)")<>0 Then										;outlook installed in x86 progfiles, i.e outlook is 32bit.
			_FileWriteLog($hFileClient, "Outlook is 32bit...")
			_FileWriteLog($hFileClient, "Executing CommVault 32bit Addin...")
			;RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {903B0409-6000-11D3-8CFE-0150048383C9} /qn')		;execute the uninstall
			;Run ("msiexec.exe /i progA.msi TRANSFORMS=progA.mst /qr")
			;ShellExecuteWait('\\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi','/qn ExtraParameters="-skip"')
			$iPID = ShellExecute("msiexec",'/i \\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi /qn ExtraParameters="-skip"')

			ElseIf StringInStr($strOutlookPath,"Program Files (x86)")=0 Then									;outlook installed in progfiles, i.e outlook is 64bit.
			_FileWriteLog($hFileClient, "Outlook is 64bit...")
			_FileWriteLog($hFileClient, "Executing CommVault 64bit Addin...")
			;ShellExecuteWait('\\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x64_10_12152014.msi','/qn ExtraParameters="-skip"')
			$iPID = ShellExecuteWait("msiexec",'/i \\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x64_10_12152014.msi /qn ExtraParameters="-skip"')
			EndIf
	  EndIf

	  ProcessWaitClose($iPID)
	  if @error <> 0 Then
		 _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
	  else
		 _FileWriteLog($hFileClient, "Installation Successful...")
	  EndIf

_FileWriteLog($hFileClient, "Quitting....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																						;Close the filehandle to release the file.
