@echo off
chcp 65001 >nul
cd /d "%~dp0"
docker compose stop
echo 止めました。再開するときは start.bat をダブルクリックしてください。
pause
