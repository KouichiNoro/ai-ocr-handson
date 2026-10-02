#!/bin/sh
# 配布時の状態に戻す（Mac / Linux）。書いたコードと登録した書類はすべて消える
cd "$(dirname "$0")"
printf "Claude Code で変えた内容と、登録した書類をすべて消して最初の状態に戻します。よろしいですか？ [y/N] "
read -r ANSWER
case "$ANSWER" in
  y|Y) docker compose down -v && echo "戻しました。sh start.sh で起動し直してください。" ;;
  *) echo "中止しました。" ;;
esac
