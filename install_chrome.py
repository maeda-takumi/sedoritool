import os
import urllib.request
import zipfile

# ChromeとChromeDriverをインストールするディレクトリ
install_dir = "/home/render/"

# ChromeとChromeDriverのURL
chrome_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chrome-linux64.zip"
chromedriver_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"

# ダウンロード先ファイルパス
chrome_zip_path = os.path.join(install_dir, "chrome.zip")
chromedriver_zip_path = os.path.join(install_dir, "chromedriver.zip")

# Chromeのダウンロード
urllib.request.urlretrieve(chrome_url, chrome_zip_path)
print("Chromeがダウンロードされました。")

# ChromeDriverのダウンロード
urllib.request.urlretrieve(chromedriver_url, chromedriver_zip_path)
print("ChromeDriverがダウンロードされました。")

# Chromeの解凍
with zipfile.ZipFile(chrome_zip_path, 'r') as zip_ref:
    zip_ref.extractall(os.path.join(install_dir, "chrome-linux64"))
print("Chromeが解凍されました。")

# ChromeDriverの解凍
with zipfile.ZipFile(chromedriver_zip_path, 'r') as zip_ref:
    zip_ref.extractall(os.path.join(install_dir, "chromedriver-linux64"))
print("ChromeDriverが解凍されました。")

# 不要なzipファイルを削除
os.remove(chrome_zip_path)
os.remove(chromedriver_zip_path)

# 実行権限を付与
os.chmod(os.path.join(install_dir, "chrome-linux64/chrome"), 0o755)
os.chmod(os.path.join(install_dir, "chromedriver-linux64/chromedriver"), 0o755)

print("ChromeとChromeDriverのインストールが完了しました。")

