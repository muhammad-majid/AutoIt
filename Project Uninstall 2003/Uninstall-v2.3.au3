
Local $ComputerNamesProject2003[17]
Local $ComputerNamesProject2007[3]
Local $ComputerNamesVisio2003[34]
Local $ComputerNamesVisio2007[9]

$ComputerNamesProject2003[0]="wse034"
$ComputerNamesProject2003[1]="wse114"
$ComputerNamesProject2003[2]="wse134"
$ComputerNamesProject2003[3]="wse143"
$ComputerNamesProject2003[4]="wse149"
$ComputerNamesProject2003[5]="wse155"
$ComputerNamesProject2003[6]="wse163"
$ComputerNamesProject2003[7]="wse167"
$ComputerNamesProject2003[8]="wse174"
;$ComputerNamesProject2003[9]="wse183"
$ComputerNamesProject2003[9]="mywse001"
$ComputerNamesProject2003[10]="wse190"
$ComputerNamesProject2003[11]="wse197"
$ComputerNamesProject2003[12]="wse202"
$ComputerNamesProject2003[13]="wse211"
$ComputerNamesProject2003[14]="wse222"
;$ComputerNamesProject2003[15]="wse233"
$ComputerNamesProject2003[15]="mywse002"
$ComputerNamesProject2003[16]="wse334"

$ComputerNamesVisio2003[0]="eisf-lap065"
$ComputerNamesVisio2003[1]="eisf-lap083"
$ComputerNamesVisio2003[2]="wse034"
$ComputerNamesVisio2003[3]="wse046"
$ComputerNamesVisio2003[4]="wse090"
$ComputerNamesVisio2003[5]="wse102"
$ComputerNamesVisio2003[6]="wse114"
$ComputerNamesVisio2003[7]="wse134"
$ComputerNamesVisio2003[8]="wse143"
$ComputerNamesVisio2003[9]="wse149"
$ComputerNamesVisio2003[10]="wse155"
$ComputerNamesVisio2003[11]="wse163"
$ComputerNamesVisio2003[12]="wse164"
$ComputerNamesVisio2003[13]="wse167"
$ComputerNamesVisio2003[14]="wse174"
$ComputerNamesVisio2003[15]="wse183"
$ComputerNamesVisio2003[16]="wse190"
$ComputerNamesVisio2003[17]="wse192"
$ComputerNamesVisio2003[18]="wse197"
$ComputerNamesVisio2003[19]="wse200"
$ComputerNamesVisio2003[20]="wse202"
$ComputerNamesVisio2003[21]="wse211"
$ComputerNamesVisio2003[22]="wse222"
$ComputerNamesVisio2003[23]="wse233"
$ComputerNamesVisio2003[24]="wse306"
$ComputerNamesVisio2003[25]="eisf-lap034"
$ComputerNamesVisio2003[26]="wse045"
$ComputerNamesVisio2003[27]="wse208"
$ComputerNamesVisio2003[28]="wse217"
$ComputerNamesVisio2003[29]="wse226"
$ComputerNamesVisio2003[30]="wse334"
$ComputerNamesVisio2003[31]="wse345"
$ComputerNamesVisio2003[32]="wse545"
$ComputerNamesVisio2003[33]="wse641"

$ComputerNamesProject2007[0]="wse213"
$ComputerNamesProject2007[1]="wse306"
$ComputerNamesProject2007[2]="wse036"

$ComputerNamesVisio2007[0]="wse119"
$ComputerNamesVisio2007[1]="wse213"
$ComputerNamesVisio2007[2]="eisf-lap081"
$ComputerNamesVisio2007[3]="eisf-lap082"
$ComputerNamesVisio2007[4]="eisf-lap191"
$ComputerNamesVisio2007[5]="wse036"
$ComputerNamesVisio2007[6]="wse071"
$ComputerNamesVisio2007[7]="wse094"
$ComputerNamesVisio2007[8]="wse170"

;MS Project 2003:
For $element In $ComputerNamesProject2003
   If StringCompare(@ComputerName, $element)==0 Then
	  MsgBox(4096,"Match", "Your Computer: "& @ComputerName & " matched current element: "& $element & " and MS Project 2003 will be Uninstalled")
	  RunWait(@ComSpec & " /c " & 'taskkill /f /im winproj.exe /t')										;Kill MS Project 2003 if running any:
	  RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {903B0409-6000-11D3-8CFE-0150048383C9} /qn')			;execute the uninstall
	  MsgBox(4096,"Uninstalled", "MS Project 2003 has been Uninstalled")
   Else
	  MsgBox(4096,"Mismatch", "Your Computer: "& @ComputerName & " does not match current element: "& $element)
   EndIf
Next


;MS Visio 2003:
For $element In $ComputerNamesVisio2003
   If StringCompare(@ComputerName, $element)==0 Then
	  MsgBox(4096,"Match", "Your Computer: "& @ComputerName & " matched current element: "& $element & " and MS Visio 2003 will be Uninstalled")
	  RunWait(@ComSpec & " /c " & 'taskkill /f /im visio.exe /t');										Kill MS Visio 2003 if running any:
	  RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {90510409-6000-11D3-8CFE-0150048383C9} /qn')			;execute the uninstall
	  MsgBox(4096,"Uninstalled", "MS Visio 2003 has been Uninstalled")
   Else
	  MsgBox(4096,"Mismatch", "Your Computer: "& @ComputerName & " does not match current element: "& $element)
   EndIf
Next



