@echo off
rem 日本語版 Windows の cmd は UTF-8 のバッチを正しく扱えないため、このファイルは Shift_JIS（CP932）で保存している
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
