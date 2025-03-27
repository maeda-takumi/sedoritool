#!/bin/bash

# Chromium用の依存パッケージをインストール
apt-get update
apt-get install -y libgtk-4-1 libgraphene-1.0-0 libgstgl-1.0-0 libgstcodecparsers-1.0-0 libavif15 libenchant-2-2 libsecret-1-0 libmanette-0-2 libglesv2-2

# Seleniumをインストール
pip install selenium

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
pip install -r requirements.txt
