#!/bin/bash
# 必要な依存関係をインストール
echo "Installing necessary dependencies..."

# aptのキャッシュディレクトリを/tmpに設定
export APT_LISTCHACHE_DIR=/tmp/apt-lists

# 必要な依存パッケージをインストール（ChromiumとChromeDriverの依存関係を含む）
echo "Installing dependencies..."
apt-get update -o Dir::Cache=$APT_LISTCHACHE_DIR && apt-get install -y \
  curl \
  ca-certificates \
  libx11-dev \
  libx264-dev \
  libfontconfig1 \
  libxcomposite1 \
  libxrandr2 \
  libxi6 \
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

echo "Dependencies installed successfully."
