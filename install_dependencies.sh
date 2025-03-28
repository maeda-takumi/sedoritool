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
  chromium-browser \
  && rm -rf /var/lib/apt/lists/*

# Chromiumのインストール確認
if ! command -v chromium-browser &> /dev/null; then
  echo "Chromium installation failed. Exiting..."
  exit 1
else
  echo "Chromium installed successfully."
  echo "Chromium installed at: $(which chromium-browser)"
fi

# ChromeDriverのインストール
CHROMEDRIVER_VERSION="113.0.5672.63"  # 例としてバージョンを指定
CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
CHROMEDRIVER_DOWNLOAD_DIR="/tmp/chromedriver"
CHROMEDRIVER_PATH="$CHROMEDRIVER_DOWNLOAD_DIR/chromedriver"

# ChromeDriverのダウンロード
echo "Downloading ChromeDriver..."
curl -L "$CHROMEDRIVER_URL" -o /tmp/chromedriver.zip

# ダウンロードしたファイルが正常かを確認
if [ $? -ne 0 ]; then
  echo "Error downloading ChromeDriver. Exiting..."
  exit 1
fi

# ダウンロードしたファイルを解凍
echo "Extracting ChromeDriver..."
mkdir -p "$CHROMEDRIVER_DOWNLOAD_DIR"
unzip /tmp/chromedriver.zip -d "$CHROMEDRIVER_DOWNLOAD_DIR"

# ChromeDriverに実行権限を付与
echo "Granting execute permissions to ChromeDriver..."
chmod +x "$CHROMEDRIVER_PATH"

# ChromeDriverのパスを環境変数PATHに追加
echo "Adding /tmp to PATH..."
export PATH=$PATH:/tmp

# インストール後のクリーンアップ
rm /tmp/chromedriver.zip

# ChromeDriverのインストールが成功したか確認
if ! command -v chromedriver &> /dev/null; then
  echo "ChromeDriver installation failed. Exiting..."
  exit 1
else
  echo "ChromeDriver installed successfully."
  echo "ChromeDriver installed at: $(which chromedriver)"
fi

# Chromiumのインストール先を確認
echo "Chromium installed at: $(which chromium-browser)"

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "Installing Python dependencies from requirements.txt..."
pip install -r requirements.txt

# Pythonのインストール先を確認
echo "Python installed at: $(which python)"
echo "Pip installed at: $(which pip)"

# インストールが完了したことを確認
echo "Installation complete!"
