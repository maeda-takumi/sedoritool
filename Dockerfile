FROM python:3.9-slim

# アプリケーションのコピー
COPY . /app
WORKDIR /app

# 必要なパッケージをインストール
RUN pip install -r requirements.txt

# setup.shを実行
RUN bash render-build.sh

# アプリケーションを起動
CMD ["python", "app.py"]
