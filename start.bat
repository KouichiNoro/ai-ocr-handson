@echo off
rem 日本語版 Windows の cmd は UTF-8 のバッチを正しく扱えないため、このファイルは Shift_JIS（CP932）で保存している
setlocal
cd /d "%~dp0"

echo.
echo ==============================================
echo   AI-OCR ハンズオン
echo ==============================================
echo.

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker Desktop が起動していません。
  echo Docker Desktop を起動して、クジラのアイコンが動き終わるまで待ってから、
  echo もう一度このファイルをダブルクリックしてください。
  echo.
  pause
  exit /b 1
)

rem キーが未設定なら聞く。キーは研修当日に配るため、事前課題では空のまま進められるようにしてある
set "KEY_NOW="
if exist .env for /f "tokens=1,* delims==" %%A in ('findstr /b "ANTHROPIC_API_KEY=" .env') do set "KEY_NOW=%%B"
if not defined KEY_NOW (
  echo API キーを設定します。
  echo 講師から受け取ったキー（sk-ant- で始まる文字列）を貼り付けて、Enter を押してください。
  echo （貼り付けても画面には表示されません。右クリックで貼り付けられます）
  echo まだ受け取っていない場合（事前課題のとき）は、何も入力せずに Enter を押してください。
  set "KEY="
  for /f "usebackq delims=" %%K in (`powershell -NoProfile -Command "$s = Read-Host -AsSecureString '>'; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))"`) do set "KEY=%%K"
  rem 講師が CLAUDE_MODEL などを書き換えていても残るよう、既存の .env があればそれを元にする
  if exist .env (findstr /v /b "ANTHROPIC_API_KEY=" .env > .env.tmp) else (findstr /v /b "ANTHROPIC_API_KEY=" .env.example > .env.tmp)
  call echo ANTHROPIC_API_KEY=%%KEY%%>> .env.tmp
  move /y .env.tmp .env >nul
  call set "KEY_NOW=%%KEY%%"
  echo.
)

echo 最新のイメージを確認しています（初回は 5～10 分かかります）…
rem 取得に失敗しても、手元にイメージがあればそのまま起動する
docker compose pull app
docker compose up -d app
if errorlevel 1 (
  echo 起動できませんでした。画面をそのまま撮影して講師にお送りください。
  pause
  exit /b 1
)

echo アプリの起動を待っています…
set /a TRIES=0
:wait
curl -s -o NUL http://localhost:3000/
if not errorlevel 1 goto ready
set /a TRIES+=1
if %TRIES% gtr 90 (
  echo 起動に時間がかかっています。講師にご連絡ください。
  pause
  exit /b 1
)
timeout /t 2 /nobreak >nul
goto wait

:ready
echo.
echo アプリが起動しました: http://localhost:3000
start "" http://localhost:3000
echo.
if not defined KEY_NOW (
  echo API キーがまだ設定されていないため、Claude Code は開きません。
  echo 研修当日、講師からキーを受け取ったら、もう一度 start.bat をダブルクリックしてください。
  echo.
  pause
  exit /b 0
)
echo 続けて Claude Code を開きます。日本語で指示を書いて Enter を押してください。
echo 終わるときは /exit と入力します。もう一度開くときは claude.bat をダブルクリックします。
echo.
rem Claude Code は日本語を UTF-8 で出すので、ここで切り替える。これより後ろの行は英数字だけにする
chcp 65001 >nul
docker compose exec app claude
pause
