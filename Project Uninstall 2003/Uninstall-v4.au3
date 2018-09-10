#include <File.au3>

Local $strLogFileName = "Uninstall-Proj-Visio-2k3-2k7.Log"
Local $hFile = FileOpen("\\eisf\NETLOGON\VisioProject_Uninstall_Results\" & $strLogFileName, 1) ; Open the logfile in write mode.

_FileWriteLog($hFile, "Hello dudy dooo") ; Write to the logfile passing the filehandle returned by FileOpen.
FileClose($hFile) ; Close the filehandle to release the file.
