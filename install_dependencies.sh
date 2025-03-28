#!/bin/bash
# 必要な依存関係をインストール
echo "必要な依存関係をインストール中..."
apt-get update && apt-get install -y \
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

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "requirements.txtからPython依存関係をインストール中..."
pip install -r requirements.txt

# ChromeDriverのインストール
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"
CHROMEDRIVER_DOWNLOAD_DIR="/tmp/chromedriver"  # ダウンロード先は/tmp
CHROMEDRIVER_INSTALL_DIR="/home/render/project/chromedriver"  # インストール先はproject

# ChromeDriverのダウンロード
echo "ChromeDriverをダウンロード中..."
curl -L "$CHROMEDRIVER_URL" -o "$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver.zip"

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "ChromeDriverのダウンロードに失敗しました。終了します..."
  exit 1
fi

# ダウンロードしたファイルを解凍
echo "ChromeDriverを解凍中..."
mkdir -p "$CHROMEDRIVER_INSTALL_DIR"
unzip "$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver.zip" -d "$CHROMEDRIVER_INSTALL_DIR"

# 解凍後のパスを確認
CHROMEDRIVER_PATH="$CHROMEDRIVER_INSTALL_DIR/chromedriver-linux64/chromedriver"
if [ ! -f "$CHROMEDRIVER_PATH" ]; then
  echo "解凍したChromeDriverが見つかりません。終了します..."
  exit 1
fi

# ChromeDriverに実行権限を付与
echo "ChromeDriverに実行権限を付与中..."
chmod +x "$CHROMEDRIVER_PATH"

# ChromeDriverのパスを環境変数PATHに追加
echo "ChromeDriverのパスを環境変数PATHに追加中..."
export PATH=$PATH:"$CHROMEDRIVER_INSTALL_DIR/chromedriver-linux64"

# Chromeのインストール
CHROME_URL="https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chrome-linux64.zip"
CHROME_DOWNLOAD_DIR="/tmp/chrome"  # ダウンロード先は/tmp
CHROME_INSTALL_DIR="/home/render/project/chrome"  # インストール先はproject

# Chromeのダウンロード
echo "Chromeをダウンロード中..."
curl -L "$CHROME_URL" -o "$CHROME_DOWNLOAD_DIR/chrome.zip"

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "Chromeのダウンロードに失敗しました。終了します..."
  exit 1
fi

# ダウンロードしたファイルを解凍
echo "Chromeを解凍中..."
mkdir -p "$CHROME_INSTALL_DIR"
unzip "$CHROME_DOWNLOAD_DIR/chrome.zip" -d "$CHROME_INSTALL_DIR"

# 解凍後のパスを確認
CHROME_PATH="$CHROME_INSTALL_DIR/chrome-linux64/chrome"
if [ ! -f "$CHROME_PATH" ]; then
  echo "解凍したChromeが見つかりません。終了します..."
  exit 1
fi

# Chromeに実行権限を付与
echo "Chromeに実行権限を付与中..."
chmod +x "$CHROME_PATH"

# Chromeのパスを環境変数に追加
echo "Chromeのパスを環境変数に追加中..."
export CHROME_BIN="$CHROME_PATH"
export PATH=$PATH:"$CHROME_INSTALL_DIR/chrome-linux64"

# インストール後のクリーンアップ
rm "$CHROME_DOWNLOAD_DIR/chrome.zip"
rm "$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver.zip"

# インストール完了メッセージ
echo "インストールが完了しました！"

# インストール先の確認
echo "ChromeDriverのパス: $(which chromedriver)"
echo "Chromeのパス: $(which chrome)"
