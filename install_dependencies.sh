#!/bin/bash

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

# 必要な依存関係をインストール
echo "Installing necessary dependencies..."
# 必要なライブラリのURLを定義
BASE_URL="http://ftp.us.debian.org/debian/pool/main"

# インストール対象のパッケージ一覧
PACKAGES=(
  "wget/wget_1.21.3-1_amd64.deb"
  "c/curl/curl_7.74.0-1.3+deb11u7_amd64.deb"
  "c/ca-certificates/ca-certificates_20211016_all.deb"
  "u/unzip/unzip_6.0-26_amd64.deb"
  "libx/libx11/libx11-dev_1.7.2-1_amd64.deb"
  "x/x264/libx264-dev_0.160.3011+gitcde9a93-2.1_amd64.deb"
  "f/fontconfig/libfontconfig1_2.13.1-4.2_amd64.deb"
  "libx/libxcomposite/libxcomposite1_0.4.5-1_amd64.deb"
  "libx/libxrandr/libxrandr2_1.5.1-1_amd64.deb"
  "libx/libxi/libxi6_1.7.10-1_amd64.deb"
  "n/nss/libnss3_3.61-1_amd64.deb"
  "n/nss/libnss3-dev_3.61-1_amd64.deb"
  "a/atk/libatk-bridge2.0-0_2.38.0-1_amd64.deb"
  "a/atk/libatk1.0-0_2.38.0-1_amd64.deb"
  "c/cups/libcups2_2.3.3op2-3+deb11u1_amd64.deb"
  "n/nspr/libnspr4_4.29-1_amd64.deb"
  "x/xtst/libxtst6_1.2.3-1_amd64.deb"
  "libs/libsecret/libsecret-1-0_0.20.4-2_amd64.deb"
  "e/enchant/libenchant-2-2_2.2.15-1_amd64.deb"
)

# ダウンロードディレクトリ
DOWNLOAD_DIR="/tmp/deb-packages"
mkdir -p "$DOWNLOAD_DIR"

# 各パッケージをダウンロードしてインストール
for PACKAGE in "${PACKAGES[@]}"; do
  PACKAGE_NAME=$(basename "$PACKAGE")
  PACKAGE_PATH="$DOWNLOAD_DIR/$PACKAGE_NAME"

  # すでにインストール済みかチェック
  if dpkg -l | grep -q "^ii  ${PACKAGE_NAME%%_*} "; then
    echo "$PACKAGE_NAME is already installed."
    continue
  fi

  # パッケージをダウンロード
  echo "Downloading $PACKAGE_NAME..."
  curl -L "$BASE_URL/$PACKAGE" -o "$PACKAGE_PATH"

  # ダウンロード成功したか確認
  if [ $? -ne 0 ]; then
    echo "Error downloading $PACKAGE_NAME. Exiting..."
    exit 1
  fi

  # dpkgでインストール
  echo "Installing $PACKAGE_NAME..."
  dpkg -i "$PACKAGE_PATH"

  # インストール成功したか確認
  if [ $? -ne 0 ]; then
    echo "Failed to install $PACKAGE_NAME. Exiting..."
    exit 1
  fi
done

# 依存関係の修正
apt-get install -f -y

# ダウンロードした .deb ファイルを削除
rm -rf "$DOWNLOAD_DIR"

# キャッシュを削除
rm -rf /var/lib/apt/lists/*

echo "All packages installed successfully."

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
