#!/bin/bash

# パッケージリストの更新
echo "Updating package lists..."
sudo apt-get update

# 必要なパッケージのインストール
echo "Installing necessary packages..."
sudo apt-get install -y \
  libgtk-4-1 \
  libgraphene-1.0-0 \
  libgstgl-1.0-0 \
  libgstcodecparsers-1.0-0 \
  libavif15 \
  libenchant-2-2 \
  libsecret-1-0 \
  libmanette-0.2-0 \
  libgles2

# Playwrightのインストール
echo "Installing Playwright dependencies..."
playwright install

echo "Installation completed!"
