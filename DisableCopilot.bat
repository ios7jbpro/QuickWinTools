powershell -command "Start-Process cmd -ArgumentList '/c cd /d %CD% && disable-copilot-elevated.bat' -Verb runas"