import os
import urllib.request
import zipfile
from flask import Flask, jsonify

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024  # 最大100MB

# ダウンロードと解凍先のディレクトリ
tmp_dir = "/tmp"
chrome_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chrome-linux64.zip"
chromedriver_url = "https://storage.googleapis.com/chrome-for-testing-public/134.0.6998.165/linux64/chromedriver-linux64.zip"

@app.route('/install', methods=['GET'])
def install_chrome():
    chrome_extract_dir = ""
    chromedriver_extract_dir = ""

    try:
        # Chromeのダウンロード
        chrome_zip_path = os.path.join(tmp_dir, "chrome.zip")
        urllib.request.urlretrieve(chrome_url, chrome_zip_path)
        print("Chromeがダウンロードされました。")

        # ChromeDriverのダウンロード
        chromedriver_zip_path = os.path.join(tmp_dir, "chromedriver.zip")
        urllib.request.urlretrieve(chromedriver_url, chromedriver_zip_path)
        print("ChromeDriverがダウンロードされました。")

        # Chromeの解凍先ディレクトリ
        chrome_extract_dir = os.path.join(tmp_dir, "chrome-linux64")
        if not os.path.exists(chrome_extract_dir):
            os.makedirs(chrome_extract_dir)
        
        # Chromeの解凍
        with zipfile.ZipFile(chrome_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chrome_extract_dir)
        print("Chromeが解凍されました。")

        # 解凍後のChromeファイル確認
        chrome_files = os.listdir(chrome_extract_dir)
        print(f"解凍されたChromeファイル: {chrome_files}")  # chrome-linux64 フォルダ内のファイルをリスト出力
        if "chrome" not in chrome_files:
            raise FileNotFoundError("解凍されたChrome実行ファイルが見つかりません。")

        # ChromeDriverの解凍先ディレクトリ
        chromedriver_extract_dir = os.path.join(tmp_dir, "chromedriver-linux64")
        if not os.path.exists(chromedriver_extract_dir):
            os.makedirs(chromedriver_extract_dir)
        
        # ChromeDriverの解凍
        with zipfile.ZipFile(chromedriver_zip_path, 'r') as zip_ref:
            zip_ref.extractall(chromedriver_extract_dir)
        print("ChromeDriverが解凍されました。")

        # 解凍後のChromeDriverファイル確認
        extracted_chromedriver_files = os.listdir(chromedriver_extract_dir)
        print(f"解凍されたChromeDriverファイル: {extracted_chromedriver_files}")  # 解凍されたChromeDriverのファイルを出力
        if "chromedriver" not in extracted_chromedriver_files:
            raise FileNotFoundError("解凍されたChromeDriver実行ファイルが見つかりません。")

        # 不要なzipファイルを削除
        os.remove(chrome_zip_path)
        os.remove(chromedriver_zip_path)

        # 実行権限を付与
        os.chmod(os.path.join(chrome_extract_dir, "chrome"), 0o755)
        os.chmod(os.path.join(chromedriver_extract_dir, "chromedriver"), 0o755)

        return jsonify({"message": "ChromeとChromeDriverのインストールが完了しました!"})

    except Exception as e:
        # エラーメッセージに解凍されたファイルのリストを追加
        error_message = str(e)
        extracted_files = os.listdir(chrome_extract_dir) if chrome_extract_dir else []
        extracted_chromedriver_files = os.listdir(chromedriver_extract_dir) if chromedriver_extract_dir else []
        error_message += f"\n解凍されたChromeファイル: {extracted_files}\n解凍されたChromeDriverファイル: {extracted_chromedriver_files}"
        return jsonify({"error": error_message}), 500

if __name__ == '__main__':
    # Renderで自動的に指定されたポートを使用
    port = int(os.getenv("PORT", 10000))
    app.run(debug=True, host="0.0.0.0", port=port)
