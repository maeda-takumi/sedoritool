import os
import urllib.request
import zipfile
import subprocess
import traceback
from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import logging
from selenium.webdriver.common.by import By
import uuid
import time  # time.sleep を使用するために追加
import shutil

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 200 * 1024 * 1024  # 最大200MB
logging.basicConfig(level=logging.INFO)
chrome_driver_path = "/tmp/chromedriver-linux64/chromedriver-linux64/chromedriver"  # 解凍先のパス
chrome_path  = "/tmp/chrome-linux64/chrome-linux64/chrome"  # 解凍先のパス
log_file = "/tmp/chromedriver.log"  # WebDriverのログファイル

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
        app.logger.info("Chromeがダウンロードされました。")

        # ChromeDriverのダウンロード
        chromedriver_zip_path = os.path.join(tmp_dir, "chromedriver.zip")
        urllib.request.urlretrieve(chromedriver_url, chromedriver_zip_path)
        app.logger.info("ChromeDriverがダウンロードされました。")

        # 解凍先ディレクトリ
        chrome_extract_dir = os.path.join(tmp_dir, "chrome-linux64")
        chromedriver_extract_dir = os.path.join(tmp_dir, "chromedriver-linux64")

        # Chromeの解凍
        with zipfile.ZipFile(chrome_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chrome_extract_dir)
        app.logger.info("Chromeが解凍されました。")

        # ChromeDriverの解凍
        with zipfile.ZipFile(chromedriver_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chromedriver_extract_dir)
        app.logger.info("ChromeDriverが解凍されました。")

        # 不要なZIPファイルを削除
        os.remove(chrome_zip_path)
        os.remove(chromedriver_zip_path)

        # ダウンロードしたファイルのリストを取得
        chrome_files = os.listdir(chrome_extract_dir)
        chromedriver_files = os.listdir(chromedriver_extract_dir)

        # ファイルが存在するか確認
        app.logger.info(f"Chromeの存在確認: {os.path.exists(chrome_path)}")
        app.logger.info(f"ChromeDriverの存在確認: {os.path.exists(chrome_driver_path)}")

        try:
            # 権限変更処理
            os.chmod(chrome_driver_path, 0o755)
            os.chmod(chrome_path, 0o755)
            app.logger.info("権限変更が成功しました。")
        except Exception as e:
            app.logger.error(f"権限変更に失敗しました: {e}")
        
        # 不要な古い user data dir を削除
        for f in os.listdir('/tmp'):
            if f.startswith("test_user_data_"):
                try:
                    shutil.rmtree(os.path.join("/tmp", f))
                except Exception as e:
                    app.logger.warning(f"{f} の削除に失敗: {e}")
        
        # WebDriverの作成関数
        def create_webdriver():
            driver = None  # driverをNoneで初期化
            try:
                # 一意なユーザーデータディレクトリを指定
                while True:
                    user_data_dir = f'/tmp/test_user_data_{uuid.uuid4()}'
                    if not os.path.exists(user_data_dir):  # 存在しない場合に作成
                        os.makedirs(user_data_dir)
                        if os.path.exists(user_data_dir):  # 作成後に確認
                            app.logger.info(f"ディレクトリ {user_data_dir} が作成されました。")
                            break  # 作成成功したらループを抜ける
                        else:
                            app.logger.error(f"ディレクトリ {user_data_dir} の作成に失敗しました。")
                            continue  # 作成失敗の場合は再試行
                    else:
                        app.logger.info(f"ディレクトリ {user_data_dir} はすでに存在します。再生成します。")
                
                if os.path.exists(user_data_dir):
                    # 念のためロックファイルを削除
                    lock_file = os.path.join(user_data_dir, 'SingletonLock')
                    if os.path.exists(lock_file):
                        os.remove(lock_file)
                        app.logger.info(f"{lock_file} を削除しました。")
                
                # Chromeプロセスを終了させる
                subprocess.run(["pkill", "chrome"])              
                chrome_options = Options()
                chrome_options.binary_location = chrome_path  # 修正点: binary_locationはchrome_pathを指定
                chrome_options.add_argument('--headless=new')
                chrome_options.add_argument('--disable-gpu')  # GPUを無効化
                chrome_options.add_argument('--no-sandbox')  # サンドボックスを無効化
                chrome_options.add_argument(f"--user-data-dir={user_data_dir}")  # 動的に作成したディレクトリを指定
                chrome_options.add_argument('--remote-debugging-port=9222')
                
                # Chromeドライバサービスを設定
                service = Service(executable_path=chrome_driver_path)
                
                # WebDriverの作成
                driver = webdriver.Chrome(service=service, options=chrome_options)
                app.logger.info("WebDriverが正常に作成されました。")
                # return driver
                return none
            except Exception as e:
                # WebDriver作成失敗時のエラー処理
                error_message = traceback.format_exc()
                app.logger.error(f"WebDriver作成エラー: {error_message}")
                
                # chromedriverの状態を調査
                app.logger.info(f"Chrome展開先: {chrome_extract_dir} 中身: {os.listdir(chrome_extract_dir)}")
                app.logger.info(f"ChromeDriver展開先: {chromedriver_extract_dir} 中身: {os.listdir(chromedriver_extract_dir)}")
                
                # chromedriver の依存関係をチェック
                try:
                    dependencies = subprocess.run(["ldd", chrome_driver_path], capture_output=True, text=True)
                    app.logger.info(f"chromedriverの依存関係: \n{dependencies.stdout}")
                except Exception as ldd_error:
                    app.logger.error(f"ldd実行エラー: {ldd_error}")
                
                # chromedriver のバージョン確認
                try:
                    version_info = subprocess.run([chrome_driver_path, "--version"], capture_output=True, text=True)
                    app.logger.info(f"ChromeDriverバージョン: {version_info.stdout.strip()}")
                except Exception as ver_error:
                    app.logger.error(f"ChromeDriverバージョン確認エラー: {ver_error}")
                
                return None
        
        # WebDriver作成の試行
        driver = create_webdriver()
        if driver is None:
            return jsonify({"error": "WebDriverの作成に失敗しました", "log_file": log_file}), 500

        # WebDriverが作成された場合のレスポンス
        return jsonify({
            "chrome_contents": os.listdir(chrome_extract_dir),
            "chromedriver_contents": os.listdir(chromedriver_extract_dir),
            "message": "ChromeとChromeDriverのZIPファイルの中身を展開し、WebDriverを作成しました。",
            "chromedriver_log": log_file
        })

    except Exception as e:
        # エラーハンドリング
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
