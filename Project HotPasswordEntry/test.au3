#include <AutoItConstants.au3>

; ^ = ctrl, ! = alt, + = shift

; Press Esc to terminate script, Pause/Break to "pause"

Global $g_bPaused = False
$passwd="Beer{^}Clock{&}99"
HotKeySet("{PAUSE}", "TogglePause")
;HotKeySet("{ESC}", "Terminate")
HotKeySet("^+x", "Terminate")
;HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d
HotKeySet("^+z", "ShowMessage") ; ctrl-shift-z

While 1
    Sleep(100)
WEnd

Func TogglePause()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
    Exit
EndFunc   ;==>Terminate

Func ShowMessage()
    ;MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
    ;HotKeySet("^+")    ;untoggle key
    Send ($passwd,$SEND_DEFAULT)
	HotKeySet ("^+z") ;untoggle key
	Send ("^")
	Send ("+")
	;HotKeySet("^+z", "ShowMessage")
EndFunc   ;==>ShowMessage
