import os
import urllib.request
import zipfile
from flask import Flask, jsonify

app = Flask(__name__)

# ダウンロードと解凍先のディレクトリ
tmp_dir = "/tmp"
chrome_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chrome-linux64.zip"
chromedriver_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"

@app.route('/install', methods=['GET'])
def install_chrome():
    try:
        # Chromeのダウンロード
        chrome_zip_path = os.path.join(tmp_dir, "chrome.zip")
        urllib.request.urlretrieve(chrome_url, chrome_zip_path)
        print("Chromeがダウンロードされました。")

        # ChromeDriverのダウンロード
        chromedriver_zip_path = os.path.join(tmp_dir, "chromedriver.zip")
        urllib.request.urlretrieve(chromedriver_url, chromedriver_zip_path)
        print("ChromeDriverがダウンロードされました。")

        # Chromeの解凍
        chrome_extract_dir = os.path.join(tmp_dir, "chrome-linux64")
        with zipfile.ZipFile(chrome_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chrome_extract_dir)
        print("Chromeが解凍されました。")

        # ChromeDriverの解凍
        chromedriver_extract_dir = os.path.join(tmp_dir, "chromedriver-linux64")
        with zipfile.ZipFile(chromedriver_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chromedriver_extract_dir)
        print("ChromeDriverが解凍されました。")

        # 不要なzipファイルを削除
        os.remove(chrome_zip_path)
        os.remove(chromedriver_zip_path)

        # 実行権限を付与
        os.chmod(os.path.join(chrome_extract_dir, "chrome"), 0o755)
        os.chmod(os.path.join(chromedriver_extract_dir, "chromedriver"), 0o755)

        # インストール後に /tmp にある解凍されたファイルを削除
        os.remove(os.path.join(chrome_extract_dir, "chrome"))
        os.remove(os.path.join(chromedriver_extract_dir, "chromedriver"))

        return jsonify({"message": "ChromeとChromeDriverのインストールが完了しました!"})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Renderで自動的に指定されたポートを使用
    port = int(os.getenv("PORT", 10000))
    app.run(debug=True, host="0.0.0.0", port=port)
