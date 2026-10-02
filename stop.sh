#!/bin/sh
# 研修環境を止める（Mac / Linux）。書いたコードと登録した書類は残る
cd "$(dirname "$0")"
docker compose stop
echo "止めました。再開するときは sh start.sh を実行してください。"
