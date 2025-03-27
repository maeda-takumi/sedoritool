#!/bin/bash

# 必要なライブラリをインストール (Chromiumに必要なライブラリ)
apt-get update
apt-get install -y \
    chromium \
    chromium-driver \
    libxss1 \
    libappindicator3-1 \
    libgdk-pixbuf2.0-0 \
    libnss3 \
    libasound2 \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libx11-xcb1 \
    libnspr4 \
    libnss3-dev \
    libxcomposite1 \
    libxrandr2 \
    xdg-utils \
    libgtk-3-0

# 他のインストール処理が必要なら追加
