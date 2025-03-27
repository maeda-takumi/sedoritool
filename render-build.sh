#!/usr/bin/env bash
set -eux  # エラーが発生したらスクリプトを停止し、デバッグ情報を表示する

# Google Chrome の GPG 鍵を取得
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Google Chrome のリポジトリを追加
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# パッケージリストを更新
sudo apt-get update

# Google Chrome をインストール
sudo apt-get install -y google-chrome-stable

# Chrome のパスを確認（デバッグ用）
which google-chrome-stable
google-chrome-stable --version
