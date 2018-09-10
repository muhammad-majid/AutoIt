#include <File.au3>

Local $strLogFileName = "SymantecEndPoint-Installation.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $iPID

If DirGetSize($strLogFilePathClient) = -1 Then				;dir does not exist
   DirCreate($strLogFilePathClient)							;create directory
EndIf

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 								;Open the logfile in write mode.

	  _FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
	  _FileWriteLog($hFileClient, "Log file opened successfully on -" & @TAB & @ComputerName)			;Write to the logfile passing the filehandle returned by FileOpen.
	  _FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
	  _FileWriteLog($hFileClient, "Installing Symantec End Point - Script v1.0")
	  _FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
	  _FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
	  _FileWriteLog($hFileClient, "Checking OS Architecture (32 bit or 64 bit) ....")
	  _FileWriteLog($hFileClient, "OS Architecture is " & @OSArch)

	  If @OSArch = "X86" Then
		 _FileWriteLog($hFileClient, "Executing SymantecEndPoint Client 32bit...")
		 ;$iPID = ShellExecute("msiexec",'/i \\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi /qn ExtraParameters="-skip"')
		 $iPID = ShellExecute("\\eisf082\ES_Softwares\SymantecEndPoint\SEP_32bit_v12.1.6608.6300.exe")
	  ElseIf @OSArch = "X64" Then
		 _FileWriteLog($hFileClient, "Executing SymantecEndPoint Client 64bit...")
		 ;$iPID = ShellExecute("msiexec",'/i \\eisf082\ES_Softwares\CommVault\OutlookAddinClient_x32_10_12152014.msi /qn ExtraParameters="-skip"')
		 $iPID = ShellExecute("\\eisf082\ES_Softwares\SymantecEndPoint\SEP_64bit_v12.1.6608.6300.exe")
	  EndIf

	  ProcessWaitClose($iPID)
	  if @error <> 0 Then
		 _FileWriteLog($hFileClient, "execution returned failure with error code - " & @error)
	  else
		 _FileWriteLog($hFileClient, "Installation Successful...")
	  EndIf

_FileWriteLog($hFileClient, "Quitting Script....")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")
FileClose($hFileClient)																						;Close the filehandle to release the file.
