@echo off
rem 日本語版 Windows の cmd は UTF-8 のバッチを正しく扱えないため、このファイルは Shift_JIS（CP932）で保存している
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
rem Claude Code は日本語を UTF-8 で出すので、ここで切り替える。これより後ろの行は英数字だけにする
chcp 65001 >nul
docker compose exec app claude %*
pause
