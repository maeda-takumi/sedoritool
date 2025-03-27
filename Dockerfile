# Pythonの公式イメージをベースにする
FROM python:3.11-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    libx11-dev \
    libxext6 \
    libxrender-dev \
    libgtk-3-0 \
    libgbm-dev \
    libnss3 \
    libasound2 \
    libxtst6 \
    libxi6 \
    libappindicator3-1 \
    libgdk-pixbuf2.0-0 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libdbus-1-3 \
    && rm -rf /var/lib/apt/lists/*

# Chromiumをインストール
RUN apt-get update && apt-get install -y chromium

# Seleniumをインストール
RUN pip install selenium

# 作業ディレクトリを設定
WORKDIR /app

# Flaskやその他の必要なパッケージをインストール
COPY requirements.txt .
RUN pip install -r requirements.txt

# アプリケーションファイルをコピー
COPY . /app

# Flaskアプリケーションのポートを開放
EXPOSE 5000

# Flaskアプリケーションを起動
CMD ["python", "app.py"]
