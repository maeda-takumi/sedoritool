#!/bin/bash

# Google Chrome を手動でインストール
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# 必要な依存関係をインストール（もし必要なら）
apt-get update
apt-get install -y libxss1 libappindicator3-1 libindicator7

# ダウンロードした Chrome をインストール
dpkg -i google-chrome-stable_current_amd64.deb
apt-get -f install  # 依存関係を解決
