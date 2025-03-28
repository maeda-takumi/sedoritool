#!/bin/bash
# 必要な依存関係をインストール
echo "Installing necessary dependencies..."

# set -e  # エラー発生時にスクリプトを停止

apt-get update && \
apt-get install -y \
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
  libnss3 \
  libnss3-dev \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libnspr4 \
  libxtst6 \
  libsecret-1-0 \
  libenchant-2-2 || { echo "Installation failed"; exit 1; }

rm -rf /var/lib/apt/lists/*

# Firefox ESRのダウンロードURL（最新バージョンのURLを指定）
FIREFOX_ESR_URL="https://ftp.mozilla.org/pub/firefox/releases/102.9.0esr/linux-x86_64/en-US/firefox-102.9.0esr.tar.bz2"
FIREFOX_ESR_DOWNLOAD_DIR="/tmp/firefox-esr"
FIREFOX_ESR_PATH="$FIREFOX_ESR_DOWNLOAD_DIR/firefox"

# Firefox ESRがすでにインストールされているかチェック
if [ ! -d "$FIREFOX_ESR_PATH" ]; then
  # Firefox ESRをダウンロード
  echo "Downloading Firefox ESR from $FIREFOX_ESR_URL..."
  curl -L "$FIREFOX_ESR_URL" -o /tmp/firefox-esr.tar.bz2

  # ダウンロードが成功したか確認
  if [ $? -ne 0 ]; then
    echo "Error downloading Firefox ESR. Exiting..."
    exit 1
  fi

  # ダウンロードしたファイルの形式を確認
  FILE_TYPE=$(file -b /tmp/firefox-esr.tar.bz2)
  if [[ "$FILE_TYPE" != "bzip2 compressed data"* ]]; then
    echo "Downloaded file is not in bzip2 format. File Type: $FILE_TYPE. Exiting..."
    exit 1
  fi

  # ダウンロードしたファイルを解凍
  echo "Extracting Firefox ESR..."
  mkdir -p "$FIREFOX_ESR_DOWNLOAD_DIR"
  tar -xvjf /tmp/firefox-esr.tar.bz2 -C "$FIREFOX_ESR_DOWNLOAD_DIR"

  # 解凍後にFirefox ESRが正しくインストールされたか確認
  if [ ! -d "$FIREFOX_ESR_PATH" ]; then
    echo "Failed to extract Firefox ESR. Exiting..."
    exit 1
  fi

  echo "Firefox ESR installed at $FIREFOX_ESR_PATH"
else
  echo "Firefox ESR is already installed at $FIREFOX_ESR_PATH"
fi


# GeckodriverのURLを構築
GECKODRIVER_URL="https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz"

# Geckodriverをダウンロード
echo "Downloading Geckodriver..."
curl -L "$GECKODRIVER_URL" -o /tmp/geckodriver.tar.gz

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "Error downloading Geckodriver. Exiting..."
  exit 1
fi

# ダウンロードしたファイルの形式を確認
FILE_TYPE=$(file -b /tmp/geckodriver.tar.gz)
if [[ "$FILE_TYPE" != "gzip compressed data"* ]]; then
  echo "Downloaded file is not in gzip format. File Type: $FILE_TYPE. Exiting..."
  exit 1
fi

# Geckodriverを解凍してインストール
echo "Extracting Geckodriver..."
tar -xvzf /tmp/geckodriver.tar.gz -C /tmp/

# Geckodriverを適切なパスに移動
echo "Moving Geckodriver to /tmp..."
mv /tmp/geckodriver /tmp/

# Geckodriverのパスを環境変数PATHに追加
echo "Adding /tmp to PATH..."
export PATH=$PATH:/tmp

# インストール後のクリーンアップ
rm /tmp/geckodriver.tar.gz

# Geckodriverのインストールが成功したか確認
if ! command -v geckodriver &> /dev/null; then
  echo "Geckodriver installation failed. Exiting..."
  exit 1
else
  echo "Geckodriver installed successfully."
  echo "Geckodriver installed at: $(which geckodriver)"
fi

# Firefox ESRのインストール先を確認
echo "Firefox ESR installed at: $(which firefox)"

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "Installing Python dependencies from requirements.txt..."
pip install -r requirements.txt

# Pythonのインストール先を確認
echo "Python installed at: $(which python)"
echo "Pip installed at: $(which pip)"

# インストールが完了したことを確認
echo "Installation complete!"
