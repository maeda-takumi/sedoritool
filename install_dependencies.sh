#!/bin/bash

# パッケージリストを更新
apt-get update

# 必要なパッケージをインストール
apt-get install -y libgtk-4-1 libgraphene-1.0-0 libgstgl-1.0-0 libgstcodecparsers-1.0-0 libavif15 libenchant-2-2 libsecret-1-0 libmanette-0-2 libglesv2-2

# Playwrightをインストール
pip install playwright
playwright install
