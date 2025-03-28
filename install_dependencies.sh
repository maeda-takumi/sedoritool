#!/bin/bash
pip install -r requirements.txt
# 必要な依存関係をインストール
echo "必要な依存関係をインストール中..."

#!/bin/bash

# チェックするディレクトリリスト
directories=("/var/www" "/usr/local" "/mnt/data" "/data")

# 各ディレクトリに対して存在確認と書き込み権限チェック
for dir in "${directories[@]}"
do
  if [ -d "$dir" ]; then
    echo "$dir は存在します。"

    # 書き込み権限があるか確認
    if [ -w "$dir" ]; then
      echo "$dir に書き込み権限があります。"
    else
      echo "$dir に書き込み権限はありません。"
    fi
  else
    echo "$dir は存在しません。"
  fi
done

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

#!/bin/bash

# requirements.txtからPythonパッケージをインストール
pip install -r requirements.txt

# PythonスクリプトでChromeとChromeDriverをインストール
python3 install_chrome.py

echo "インストールが完了しました！"
