;MS Project 2003:
RunWait(@ComSpec & " /c " & 'taskkill /f /im winproj.exe /t');Kill MS Project 2003 if running any:
RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {903B0409-6000-11D3-8CFE-0150048383C9} /qn');execute the uninstall

;MS Visio 2003:
RunWait(@ComSpec & " /c " & 'taskkill /f /im visio.exe /t');Kill MS Visio 2003 if running any:
RunWait(@ComSpec & " /c " & 'MsiExec.Exe /x {90510409-6000-11D3-8CFE-0150048383C9} /qn');execute the uninstall
