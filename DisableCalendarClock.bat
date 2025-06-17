powershell -command "Start-Process cmd -ArgumentList '/c cd /d %CD% && disable-calendarclock-elevated.bat' -Verb runas"
