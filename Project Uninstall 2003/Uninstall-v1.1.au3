;MS Project 2003:
Run(@ComSpec & " /c " & 'taskkill /f /im winproj.exe /t');Kill MS Project 2003 if running any:
Run(@ComSpec & " /c " & 'MsiExec.Exe /x {903B0409-6000-11D3-8CFE-0150048383C9} /qn');execute the uninstall

