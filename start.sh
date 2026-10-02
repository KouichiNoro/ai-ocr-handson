#!/bin/sh
# 研修環境を起動し、そのまま Claude Code を開く（Mac / Linux）
#
#   sh start.sh
#
set -e
cd "$(dirname "$0")"

echo ""
echo "=============================================="
echo "  AI-OCR ハンズオン"
echo "=============================================="
echo ""

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker が見つかりません。"
  echo "Docker Desktop をインストールしてから、もう一度実行してください。"
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "Docker Desktop が起動していません。"
  echo "Docker Desktop を起動して、クジラのアイコンが動き終わるまで待ってから、"
  echo "もう一度このコマンドを実行してください。"
  exit 1
fi

# キーが未設定なら聞く。キーは研修当日に配るため、事前課題では空のまま進められるようにしてある
KEY_NOW="$(sed -n 's/^ANTHROPIC_API_KEY=//p' .env 2>/dev/null | head -1)"
if [ -z "$KEY_NOW" ]; then
  echo "API キーを設定します。"
  echo "講師から受け取ったキー（sk-ant- で始まる文字列）を貼り付けて、Enter を押してください。"
  echo "（貼り付けても画面には表示されません）"
  echo "まだ受け取っていない場合（事前課題のとき）は、何も入力せずに Enter を押してください。"
  printf "> "
  stty -echo 2>/dev/null || true
  read -r KEY
  stty echo 2>/dev/null || true
  echo ""
  # 講師が CLAUDE_MODEL などを書き換えていても残るよう、既存の .env があればそれを元にする
  BASE=.env.example
  [ -f .env ] && BASE=.env
  grep -v '^ANTHROPIC_API_KEY=' "$BASE" > .env.tmp
  echo "ANTHROPIC_API_KEY=$KEY" >> .env.tmp
  mv .env.tmp .env
  chmod 600 .env
  KEY_NOW="$KEY"
  if [ -n "$KEY_NOW" ]; then echo "キーを保存しました。"; else echo "キーは研修当日に設定します。"; fi
  echo ""
fi

echo "最新のイメージを確認しています（初回は 5〜10 分かかります）…"
# 取得に失敗しても、手元にイメージがあればそれで起動する（会場のネットワークが不安定なとき・公開前の試験用）
if ! docker compose pull app; then
  OWNER="$(sed -n 's/^GHCR_OWNER=//p' .env | head -1)"
  TAG="$(sed -n 's/^IMAGE_TAG=//p' .env | head -1)"
  if docker image inspect "ghcr.io/${OWNER:-kouichinoro}/ai-ocr-handson:${TAG:-latest}" >/dev/null 2>&1; then
    echo "取得できなかったため、手元にあるイメージで起動します。"
  else
    echo "イメージを取得できませんでした。インターネットにつながっているか確認してください。"
    exit 1
  fi
fi

docker compose up -d app

printf "アプリの起動を待っています"
i=0
until curl -s -o /dev/null http://localhost:3000/; do
  i=$((i + 1))
  if [ "$i" -gt 90 ]; then
    echo ""
    echo "起動に時間がかかっています。docker compose logs app で状況を確認し、講師にご連絡ください。"
    exit 1
  fi
  printf "."
  sleep 2
done
echo ""
echo ""
echo "アプリが起動しました: http://localhost:3000"
command -v open >/dev/null 2>&1 && open http://localhost:3000 || true

echo ""
if [ -z "$KEY_NOW" ]; then
  echo "API キーがまだ設定されていないため、Claude Code は開きません。"
  echo "研修当日、講師からキーを受け取ったら、もう一度 sh start.sh を実行してください。"
  exit 0
fi
echo "続けて Claude Code を開きます。日本語で指示を書いて Enter を押してください。"
echo "終わるときは /exit と入力します。もう一度開くときは sh claude.sh を実行します。"
echo ""
exec docker compose exec app claude
