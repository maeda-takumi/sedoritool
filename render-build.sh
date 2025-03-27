#!/bin/bash

# パッケージリストを更新して、必要なツールをインストール
apt-get update -y
apt-get install -y wget curl unzip python3-pip

# Playwrightのインストール
pip install playwright

# PlaywrightでChromiumをインストール
python3 -m playwright install

# Pythonパッケージのインストール（requirements.txtに依存関係が含まれている場合）
pip install -r requirements.txt

# もし別途chromium-browserが必要であれば、以下を追加してインストール
# apt-get install -y chromium-browser
