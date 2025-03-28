#!/bin/bash
pip install -r requirements.txt
# 必要な依存関係をインストール
echo "必要な依存関係をインストール中..."

ls -ld /home/render
df -h
sudo chmod u+w /home/render

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
FINAL_CHROMEDRIVER_DIR="/home/render/chromedriver"

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

# ChromeDriverのコピー先ディレクトリ作成
mkdir -p "$FINAL_CHROMEDRIVER_DIR"

# ChromeDriverを最終ディレクトリにコピー
echo "ChromeDriverを最終ディレクトリにコピー中..."
cp -r "$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver-linux64" "$FINAL_CHROMEDRIVER_DIR"

# ChromeDriverのパスを環境変数PATHに追加
echo "ChromeDriverのパスを環境変数PATHに追加中..."
export PATH=$PATH:$FINAL_CHROMEDRIVER_DIR/chromedriver-linux64

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
FINAL_CHROME_DIR="/home/render/chrome"

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

# Chromeのコピー先ディレクトリ作成
mkdir -p "$FINAL_CHROME_DIR"

# Chromeを最終ディレクトリにコピー
echo "Chromeを最終ディレクトリにコピー中..."
cp -r "$CHROME_DOWNLOAD_DIR/chrome-linux64" "$FINAL_CHROME_DIR"

# Chromeのパスを環境変数に追加
echo "Chromeのパスを環境変数に追加中..."
export CHROME_BIN="$FINAL_CHROME_DIR/chrome-linux64/chrome"
export PATH=$PATH:"$FINAL_CHROME_DIR/chrome-linux64"

# ChromeとChromeDriverのファイル存在確認
echo "Chromeの存在確認..."
if [ ! -f "$CHROME_BIN" ]; then
  echo "Chromeが正しくインストールされていません。終了します..."
  exit 1
else
  echo "Chromeが正常にインストールされました。"
  echo "Chromeのパス: $CHROME_BIN"
fi

# インストール後のクリーンアップ
rm /tmp/chrome.zip
rm /tmp/chromedriver.zip

# インストール完了メッセージ
echo "インストールが完了しました！"
