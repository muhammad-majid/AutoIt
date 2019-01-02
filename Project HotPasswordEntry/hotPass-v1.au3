#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Muhammad Majid

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;HotKeySet("+!p", "Main");, "HotKeyPressed") ; Shift-Alt-p
While 1 ;loop forever to wait for the keypress
HotKeySet("+!d", "Main") ;wait for Shift-ALT-d keystroke, then go to Main()
Sleep(100) ;no need to kill the CPU
WEnd

Func Main()
  ;Send ("HelloCharlie")
  Send ("Beer{^}Clock{&}99")
  ;HotKeySet("!a") ;remove the hotkey so we don't jump around once we have started
  ;Send ("Beer")
  ;Send ("{^}")
  ;Send ("Clock")
  ;Send ("{&}")
  ;Send ("99")
EndFunc

