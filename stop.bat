@echo off
rem 日本語版 Windows の cmd は UTF-8 のバッチを正しく扱えないため、このファイルは Shift_JIS（CP932）で保存している
cd /d "%~dp0"
docker compose stop
echo 止めました。再開するときは start.bat をダブルクリックしてください。
pause
