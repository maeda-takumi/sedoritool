#!/bin/bash
# 必要な依存関係をインストール
echo "Installing necessary dependencies..."

# aptのキャッシュディレクトリを/tmpに設定
export APT_LISTCHACHE_DIR=/tmp/apt-lists

# aptキャッシュディレクトリを作成
mkdir -p $APT_LISTCHACHE_DIR

# 必要な依存パッケージをインストール
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

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "Installing Python dependencies from requirements.txt..."
pip install -r requirements.txt

# Pythonのインストール先を確認
echo "Python installed at: $(which python)"
echo "Pip installed at: $(which pip)"


# ChromeDriverのインストール
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"
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
echo "Adding /tmp/chromedriver to PATH..."
export PATH=$PATH:$CHROMEDRIVER_DOWNLOAD_DIR

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

# インストールが完了したことを確認
echo "Installation complete!"
