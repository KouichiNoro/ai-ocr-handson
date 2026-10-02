@echo off
chcp 65001 >nul
cd /d "%~dp0"
set "KEY_NOW="
if exist .env for /f "tokens=1,* delims==" %%A in ('findstr /b "ANTHROPIC_API_KEY=" .env') do set "KEY_NOW=%%B"
if not defined KEY_NOW (
  echo API キーがまだ設定されていません。start.bat をダブルクリックして、講師から受け取ったキーを貼り付けてください。
  pause
  exit /b 1
)
rem アプリが止まっていれば先に起動する
docker compose up -d app >nul
docker compose exec app claude %*
pause
