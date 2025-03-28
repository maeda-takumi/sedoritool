#!/bin/bash
pip install -r requirements.txt
# 必要な依存関係をインストール
echo "必要な依存関係をインストール中..."

#!/bin/bash

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

#!/bin/bash

# 確認したいパッケージ一覧
packages=(
  curl
  ca-certificates
  libx11-dev
  libx264-dev
  libfontconfig1
  libxcomposite1
  libxrandr2
  libxi6
  libnss3
  libnss3-dev
  libatk-bridge2.0-0
  libatk1.0-0
  libcups2
  libnspr4
  libxtst6
  libsecret-1-0
  libenchant-2-2
)

# 確認したいパッケージ一覧
packages=(
  curl
  ca-certificates
  libx11-dev
  libx264-dev
  libfontconfig1
  libxcomposite1
  libxrandr2
  libxi6
  libnss3
  libnss3-dev
  libatk-bridge2.0-0
  libatk1.0-0
  libcups2
  libnspr4
  libxtst6
  libsecret-1-0
  libenchant-2-2
)

# インストールされていないパッケージをリストアップ
missing_packages=()

for pkg in "${packages[@]}"; do
  if ! dpkg -l | grep -qw "$pkg"; then
    missing_packages+=("$pkg")
  fi
done

# 結果を出力
if [ ${#missing_packages[@]} -eq 0 ]; then
  echo "すべてのパッケージがインストールされています。"
else
  echo "以下のパッケージが不足しています:"
  for pkg in "${missing_packages[@]}"; do
    echo "  - $pkg"
  done
fi


# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
echo "requirements.txtからPython依存関係をインストール中..."
pip install -r requirements.txt

# Pythonのインストール先を確認
echo "Pythonがインストールされている場所: $(which python)"
echo "Pipがインストールされている場所: $(which pip)"

#!/bin/bash

# requirements.txtからPythonパッケージをインストール
pip install -r requirements.txt


echo "インストールが完了しました！"
