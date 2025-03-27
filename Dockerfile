# Pythonのスリムなイメージをベースにする
FROM python:3.11-slim

# Google Chromeのダウンロードリンクを指定
RUN apt-get update && apt-get install -y wget curl unzip \
    # Google Chromeのインストール
    && wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm -rf /var/lib/apt/lists/*

# requirements.txt をコピーして依存関係をインストール
COPY requirements.txt .
RUN pip install -r requirements.txt

# 手動で chromedriver_autoinstaller をインストール（念のため）
RUN pip install chromedriver-autoinstaller

# アプリケーションのコードをコピー
COPY . /app

# 作業ディレクトリを指定
WORKDIR /app

# アプリケーションの実行コマンドを指定
CMD ["python", "app.py"]
