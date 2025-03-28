import os
import urllib.request
import zipfile
from flask import Flask, jsonify
import traceback

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 200 * 1024 * 1024  # 最大200MB

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

        # 解凍先ディレクトリ
        chrome_extract_dir = os.path.join(tmp_dir, "chrome-linux64")
        chromedriver_extract_dir = os.path.join(tmp_dir, "chromedriver-linux64")

        # Chromeの解凍
        with zipfile.ZipFile(chrome_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chrome_extract_dir)
        print("Chromeが解凍されました。")

        # ChromeDriverの解凍
        with zipfile.ZipFile(chromedriver_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chromedriver_extract_dir)
        print("ChromeDriverが解凍されました。")

        # ダウンロードしたZIPファイルの中身をリスト表示
        chrome_files = os.listdir(chrome_extract_dir)
        chromedriver_files = os.listdir(chromedriver_extract_dir)

        # 不要なzipファイルを削除
        os.remove(chrome_zip_path)
        os.remove(chromedriver_zip_path)

        # 返すJSONの内容
        return jsonify({
            "chrome_contents": chrome_files,
            "chromedriver_contents": chromedriver_files,
            "message": "ChromeとChromeDriverのZIPファイルの中身を展開しました。"
        })
    
    except Exception as e:
        # エラーハンドリング
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Renderの要件に合わせて0.0.0.0でバインド
    app.run(debug=True, host="0.0.0.0", port=5000)
