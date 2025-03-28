import os
import urllib.request
import zipfile
from flask import Flask, jsonify

app = Flask(__name__)

# 最大アップロードサイズを200MBに設定
app.config['MAX_CONTENT_LENGTH'] = 200 * 1024 * 1024  # 最大200MB


# ダウンロード先のディレクトリ
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

        # ZIPファイルの中身を確認する関数
        def get_zip_contents(zip_path):
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                return zip_ref.namelist()

        # ChromeのZIP内容確認
        chrome_contents = get_zip_contents(chrome_zip_path)
        # ChromeDriverのZIP内容確認
        chromedriver_contents = get_zip_contents(chromedriver_zip_path)

        # 中身を表示する
        print(f"Chrome ZIPの中身: {chrome_contents}")
        print(f"ChromeDriver ZIPの中身: {chromedriver_contents}")

        # 不要なzipファイルを削除
        os.remove(chrome_zip_path)
        os.remove(chromedriver_zip_path)

        # レスポンスとして中身を返す
        return jsonify({
            "message": "ChromeとChromeDriverのZIPファイルの中身確認が完了しました。",
            "chrome_contents": chrome_contents,
            "chromedriver_contents": chromedriver_contents
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
