import os
import urllib.request
import zipfile
from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import traceback

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 200 * 1024 * 1024  # 最大200MB

chrome_driver_path = "/tmp/chromedriver-linux64/chromedriver"  # 解凍先のパス
chrome_path = "/tmp/chrome-linux64/chrome"  # 解凍先のパス

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

        # WebDriverの作成関数
        def create_webdriver():
            try:
                # Chromeのオプション設定
                chrome_options = Options()
                chrome_options.binary_location = chrome_path  # Chromeのバイナリ位置を設定
                chrome_options.add_argument('--headless')  # ヘッドレスモードで起動
                chrome_options.add_argument('--no-sandbox')  # セキュリティ回避
                chrome_options.add_argument('--disable-dev-shm-usage')  # システムリソース回避
        
                # Chromeドライバサービスを設定
                service = Service(executable_path=chrome_driver_path)
        
                # WebDriverの作成
                driver = webdriver.Chrome(service=service, options=chrome_options)
                print("driverを取得しました")  # ここでメッセージを表示
                return driver
            except Exception as e:
                # WebDriver作成失敗時のエラー処理
                print(f"Error creating WebDriver: {e}")
                print("WebDriver作成中にエラーが発生しました:")
                print(traceback.format_exc())  # 詳細なエラーメッセージを表示

                # chromeとdriverの展開先のリストを表示
                print(f"Chrome展開先: {chrome_extract_dir} 中身: {os.listdir(chrome_extract_dir)}")
                print(f"ChromeDriver展開先: {chromedriver_extract_dir} 中身: {os.listdir(chromedriver_extract_dir)}")
                
                return None

        # WebDriverを作成
        driver = create_webdriver()
        if driver is None:
            return jsonify({"error": "WebDriverの作成に失敗しました"}), 500

        # WebDriverが作成された場合のレスポンス
        return jsonify({
            "chrome_contents": chrome_files,
            "chromedriver_contents": chromedriver_files,
            "message": "ChromeとChromeDriverのZIPファイルの中身を展開し、WebDriverを作成しました。"
        })
    
    except Exception as e:
        # エラーハンドリング
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # Renderの要件に合わせて0.0.0.0でバインド
    app.run(debug=True, host="0.0.0.0", port=5000)
