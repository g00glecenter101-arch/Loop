Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 1. Get the folder where THIS task.vbs is currently sitting
strPath = fso.GetParentFolderName(WScript.ScriptFullName)
strLauncher = strPath & "\launcher.vbs"

' 2. Create the task using the path we just found
' We call wscript.exe directly to ensure it stays 100% invisible
strTask = "schtasks /create /tn ""ForexForgeSync"" /tr ""wscript.exe \""" & strLauncher & "\"" "" /sc onlogon /rl highest /delay 0001:00 /f"

' 3. Run the command hidden (0) and exit
WshShell.Run "cmd.exe /c " & strTask, 0, True
