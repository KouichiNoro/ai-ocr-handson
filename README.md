# AI-OCR ハンズオン 起動用ファイル

AI-OCR 経費書類管理システム ハンズオン研修で使う起動用ファイルです。
アプリ本体と Claude Code は Docker イメージ（`ghcr.io/kouichinoro/ai-ocr-handson`）に入っており、
初回の起動時に自動でダウンロードされます。

手順の詳細は、講師から配布された「事前課題 環境の準備」をご覧ください。

## 使い方

1. [Docker Desktop](https://www.docker.com/products/docker-desktop/) を入れて起動します
2. このページの緑色の **Code** ボタン → **Download ZIP** でダウンロードし、展開します
3. 展開した `ai-ocr-handson-main` フォルダで起動します

| したいこと | Mac（ターミナルで実行） | Windows |
|---|---|---|
| 起動する | `sh start.sh` | `start.bat` をダブルクリック |
| Claude Code だけ開き直す | `sh claude.sh` | `claude.bat` をダブルクリック |
| 止める | `sh stop.sh` | `stop.bat` をダブルクリック |
| 最初の状態に戻す（変更と登録した書類が消えます） | `sh reset.sh` | `reset.bat` をダブルクリック |
| 設定を確かめる | `docker compose run --rm check` | 同じ |

起動すると http://localhost:3000 でアプリが開きます。

API キーは研修当日に講師からお知らせします。`start` でキーを聞かれたら、
事前課題のときは何も入力せずに Enter を押してください（画面は見られますが、AI の読み取りと Claude Code は使えません）。
当日キーを受け取ったら、もう一度 `start` を実行して貼り付けます。

## 入っているもの

| ファイル | 役割 |
|---|---|
| `start` / `claude` / `stop` / `reset` | 起動・停止などの操作 |
| `docker-compose.yml` | どのイメージを、どの設定で動かすか |
| `.env.example` | 設定のひな形。初回の `start` が API キーを入れた `.env` を作ります |

`.env` には API キーが入ります。ほかの人に渡したり、どこかへ公開したりしないでください。
