#!/bin/bash

# パッケージリストを更新して、必要なツールをインストール
apt-get update -y
apt-get install -y wget curl unzip

apt-get update
apt-get install chromium-browser

# Chromiumおよび依存ライブラリのインストール
apt-get install -y \
    chromium-browser \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libu2f-udev \
    libnss3-tools

# ChromiumDriverのインストール
apt-get install -y chromium-driver

# ※ 必要であれば、Google Chromeのインストールも行う場合（Chromiumを使うなら不要）
# CHROMIUM_VERSION=112.0.5615.138-1
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -f

# Pythonパッケージのインストール
pip install -r requirements.txt
