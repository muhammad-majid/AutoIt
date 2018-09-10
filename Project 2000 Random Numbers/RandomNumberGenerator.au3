#include <File.au3>

Local $strLogFileName = "RandomNumber.Log"
Local $strLogFilePathClient = "C:\ScriptFlags\"
Local $intRandomNumber
Local $intCounter1
Local $intCounter2
Local $intOkToWrite
Local $intRandomNumberArray[2001]

If DirGetSize($strLogFilePathClient) = -1 Then				;dir does not exist
	DirCreate($strLogFilePathClient)						;create directory
EndIf

Local $hFileClient = FileOpen($strLogFilePathClient & $strLogFileName, 1) 												;Open the logfile on Client in write mode.
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")		;Write to the logfile on Client.
_FileWriteLog($hFileClient, "Log file opened successfully on - " & @ComputerName)										;Write to the logfile passing the filehandle returned by FileOpen.
_FileWriteLog($hFileClient, "Starting Log Output at C:\ScriptFlags\...")
_FileWriteLog($hFileClient, "20k Random Number Generator - Script v1")
_FileWriteLog($hFileClient, "Created by ES IT Department - Muhammad Majid")
_FileWriteLog($hFileClient, "-----------------------------------------------------------------------------------")

$intRandomNumberArray[1]=Random(100000, 999999, 1)
;_FileWriteLog($hFileClient, "Array[1]=" & $intRandomNumberArray[1])
_FileWriteLog($hFileClient, $intRandomNumberArray[1])

For $intCounter1=2 To 2001 Step 1
	$intOkToWrite = 1
	;_FileWriteLog($hFileClient, "Outer Counter: " & $intCounter1)
	$intRandomNumber=Random(100000, 999999, 1)
	;_FileWriteLog($hFileClient, "Random Number Generated: " & $intRandomNumber)
	For $intCounter2=$intCounter1-1 To 1 Step -1
		;_FileWriteLog($hFileClient, "Inner Counter: " & $intCounter2)
		If $intRandomNumber=$intRandomNumberArray[$intCounter2] Then
			$intCounter1=$intCounter1-1
			;_FileWriteLog($hFileClient, "number matched, exiting internal loop")
			$intOkToWrite = 0
			ExitLoop
		EndIf
	Next
	If $intOkToWrite=1 Then
		$intRandomNumberArray[$intCounter1]=$intRandomNumber
		;_FileWriteLog($hFileClient, "Array[" & $intCounter1 & "]=" & $intRandomNumber)
		_FileWriteLog($hFileClient, $intRandomNumber)
	EndIf
Next

FileClose($hFileClient)																							;Close the filehandle on Client to release the file.

