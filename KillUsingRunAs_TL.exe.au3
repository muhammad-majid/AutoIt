#include <AutoItConstants.au3>

Example()

Func Example()
    ; Change the username and password to the appropriate values for your system.
    Local $sDomain = "hsemining"
	Local $sUserName = "Baismanage"
    Local $sPassword = "GUPiC7Bo"

    ; Run Notepad with the window maximized. Notepad is run under the user previously specified.
    Local $iPID = RunAs($sUserName, $sDomain, $sPassword, $RUN_LOGON_NOPROFILE, "taskkill /f /im TL.exe", "", @SW_SHOWMAXIMIZED)

EndFunc   ;==>Example
