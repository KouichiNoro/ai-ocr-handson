#!/bin/sh
# Claude Code を開く（Mac / Linux）。アプリが止まっていれば先に起動する
set -e
cd "$(dirname "$0")"
if [ -z "$(sed -n 's/^ANTHROPIC_API_KEY=//p' .env 2>/dev/null | head -1)" ]; then
  echo "API キーがまだ設定されていません。sh start.sh を実行して、講師から受け取ったキーを貼り付けてください。"
  exit 1
fi
if [ -z "$(docker compose ps -q --status running app 2>/dev/null)" ]; then
  echo "アプリを起動しています…"
  docker compose up -d app
  sleep 5
fi
exec docker compose exec app claude "$@"
