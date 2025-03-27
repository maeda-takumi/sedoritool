#!/bin/bash

# 必要な依存関係をインストール
apt-get update && apt-get install -y \
  firefox-esr \
  wget \
  curl \
  ca-certificates \
  unzip \
  libx11-dev \
  libx264-dev \
  libfontconfig1 \
  libxcomposite1 \
  libxrandr2 \
  libxi6 \
  libgdk-pixbuf2.0-0 \
  libnss3 \
  libnss3-dev \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libnspr4 \
  libxtst6 \
  libsecret-1-0 \
  libenchant-2-2 \
  && rm -rf /var/lib/apt/lists/*

# Geckodriverのインストール
GECKODRIVER_VERSION=$(curl -sS https://github.com/mozilla/geckodriver/releases/latest | sed 's/.*\///')
wget https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz -O /tmp/geckodriver.tar.gz
tar -xvzf /tmp/geckodriver.tar.gz -C /usr/local/bin/
rm /tmp/geckodriver.tar.gz

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
pip install -r requirements.txt

# Flaskアプリを起動
python3 app.py



