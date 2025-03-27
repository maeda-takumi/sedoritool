# Pythonのスリムなイメージをベースにする
FROM python:3.11-slim

# システムのパッケージをアップデートし、必要なツールをインストール
RUN apt-get update && apt-get install -y wget curl unzip \
    # Google Chromeのダウンロードリンクを指定
    && wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    # Chromeをインストール
    && apt-get install -y /tmp/chrome.deb \
    # Chromiumドライバをインストール
    && apt-get install -y chromium-driver \
    # 不要なパッケージのキャッシュを削除
    && rm -rf /var/lib/apt/lists/*

# requirements.txt をコピーして依存関係をインストール
COPY requirements.txt .
RUN pip install -r requirements.txt

# アプリケーションのコードをコピー
COPY . /app

# 作業ディレクトリを指定
WORKDIR /app

# アプリケーションの実行コマンドを指定
CMD ["python", "app.py"]
