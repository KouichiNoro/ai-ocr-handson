@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Claude Code で変えた内容と、登録した書類をすべて消して最初の状態に戻します。
set /p ANSWER="よろしいですか？ [y/N] "
if /i "%ANSWER%"=="y" (
  docker compose down -v
  echo 戻しました。start.bat で起動し直してください。
) else (
  echo 中止しました。
)
pause
