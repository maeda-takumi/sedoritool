#!/bin/bash

# Google Chrome のリポジトリを追加
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update

# Google Chrome をインストール
apt-get install -y google-chrome-stable

# 必要な他の依存関係があればインストール
apt-get install -y chromium-driver

# 以下はその他のインストールステップ（例）
# apt-get install -y python3-pip
# pip3 install -r requirements.txt
