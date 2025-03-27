#!/bin/bash
apt-get update && apt-get install -y firefox-esr

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

# 最新のGeckodriverのバージョンを取得
# GECKODRIVER_VERSION=$(curl -sS https://github.com/mozilla/geckodriver/releases/latest | sed 's/.*\///')

# GeckodriverのURLを構築
GECKODRIVER_URL="https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz"

# Geckodriverをダウンロード
echo "Downloading Geckodriver version $GECKODRIVER_VERSION..."
curl -L $GECKODRIVER_URL -o /tmp/geckodriver.tar.gz

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

# Geckodriverを解凍してインストール（/tmpに解凍）
echo "Extracting Geckodriver..."
tar -xvzf /tmp/geckodriver.tar.gz -C /tmp/

# Geckodriverを適切なパスに移動（例: /tmpに移動し、PATHを設定）
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
fi

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "Installing Python dependencies from requirements.txt..."
pip install -r requirements.txt

echo "Installation complete!"
