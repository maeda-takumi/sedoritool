#!/bin/bash

# Chromium をインストール（必要な場合）
apt-get update
apt-get install -y chromium-browser

# 必要な依存関係をインストール（もし必要なら）
apt-get install -y libxss1 libappindicator3-1 libindicator7
