Set WshShell = CreateObject("WScript.Shell")
Dim strPath, strTaskCommand

' 1. Get the current folder path where launcher.vbs is located
strPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
strLauncher = strPath & "\launcher.vbs"

' 2. The command to create a hidden, high-privilege task
' /sc onlogon: Runs when the user logs in
' /rl highest: Runs with Admin rights but NO UAC prompt after the first time
' /delay 0001:00: Waits 1 minute for internet to connect
strTaskCommand = "schtasks /create /tn ""ForexForgeSync"" /tr ""wscript.exe \""" & strLauncher & "\"" "" /sc onlogon /rl highest /delay 0001:00 /f"

' 3. Run the command hidden (0) and wait for it to finish
WshShell.Run "cmd.exe /c " & strTaskCommand, 0, True

MsgBox "Setup Complete", 64, "System"