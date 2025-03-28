#!/bin/bash
pip install -r requirements.txt
# 必要な依存関係をインストール
echo "必要な依存関係をインストール中..."

# aptのキャッシュディレクトリを/tmpに設定
export APT_LISTCHACHE_DIR=/tmp/apt-lists

# 必要な依存パッケージをインストール
echo "依存パッケージをインストール中..."
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

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "requirements.txtからPython依存関係をインストール中..."
pip install -r requirements.txt

# Pythonのインストール先を確認
echo "Pythonがインストールされている場所: $(which python)"
echo "Pipがインストールされている場所: $(which pip)"

# ChromeDriverのインストール
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"
CHROMEDRIVER_DOWNLOAD_DIR="/tmp/chromedriver"
CHROMEDRIVER_PATH="$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver-linux64/chromedriver"

# ChromeDriverのダウンロード
echo "ChromeDriverをダウンロード中..."
curl -L "$CHROMEDRIVER_URL" -o /tmp/chromedriver.zip

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "ChromeDriverのダウンロードに失敗しました。終了します..."
  exit 1
fi

# ダウンロードしたファイルを解凍
echo "ChromeDriverを解凍中..."
mkdir -p "$CHROMEDRIVER_DOWNLOAD_DIR"
unzip /tmp/chromedriver.zip -d "$CHROMEDRIVER_DOWNLOAD_DIR"

# 解凍後のパスを確認
if [ ! -f "$CHROMEDRIVER_PATH" ]; then
  echo "解凍したChromeDriverが見つかりません。終了します..."
  exit 1
fi

# ChromeDriverに実行権限を付与
echo "ChromeDriverに実行権限を付与中..."
chmod +x "$CHROMEDRIVER_PATH"

# ChromeDriverのパスを環境変数PATHに追加
echo "ChromeDriverのパスを環境変数PATHに追加中..."
export PATH=$PATH:/tmp/chromedriver/chromedriver-linux64

# ChromeDriverが正常にインストールされたか確認
if ! command -v chromedriver &> /dev/null; then
  echo "ChromeDriverのインストールに失敗しました。終了します..."
  exit 1
else
  echo "ChromeDriverが正常にインストールされました。"
  echo "ChromeDriverのパス: $(which chromedriver)"
fi

# Chromeのインストール
CHROME_URL="https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chrome-linux64.zip"
CHROME_DOWNLOAD_DIR="/tmp/chrome"
CHROME_PATH="$CHROME_DOWNLOAD_DIR/chrome-linux64/chrome"

# Chromeのダウンロード
echo "Chromeをダウンロード中..."
curl -L "$CHROME_URL" -o /tmp/chrome.zip

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "Chromeのダウンロードに失敗しました。終了します..."
  exit 1
fi

# ダウンロードしたファイルを解凍
echo "Chromeを解凍中..."
mkdir -p "$CHROME_DOWNLOAD_DIR"
unzip /tmp/chrome.zip -d "$CHROME_DOWNLOAD_DIR"

# 解凍後のパスを確認
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
export PATH=$PATH:"$CHROME_DOWNLOAD_DIR/chrome-linux64"

# ChromeとChromeDriverのファイル存在確認
echo "Chromeの存在確認..."
if [ ! -f "$CHROME_PATH" ]; then
  echo "Chromeが正しくインストールされていません。終了します..."
  exit 1
else
  echo "Chromeが正常にインストールされました。"
  echo "Chromeのパス: $CHROME_BIN"
fi

# インストール後のクリーンアップ
rm /tmp/chrome.zip

# インストール完了メッセージ
echo "インストールが完了しました！"
