Local $sFldr3 = "C:\Test1\Folder1\Folder2\"
If DirGetSize($sFldr3) = -1 Then
   MsgBox(48, $sFldr3, "Directory dees not exist!")
   DirCreate($sFldr3)
   MsgBox(48, $sFldr3, "Directory created!")
EndIf
MsgBox(48, $sFldr3, "Directory already exists!")

