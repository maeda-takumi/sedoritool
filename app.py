import os
from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

app = Flask(__name__)

def setup_driver():
    # Chromeの実行ファイルのパス
    chrome_binary_path = "/tmp/chrome/chrome-linux64/chrome"
    
    # 実行ファイルが存在するか確認
    if not os.path.exists(chrome_binary_path):
        raise FileNotFoundError(f"Chrome実行ファイルが見つかりません: {chrome_binary_path}")
    
    # ChromeOptionsの設定
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument("--headless")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.binary_location = chrome_binary_path

    # ChromeDriverのパスを指定（ログのパスを使用）
    chromedriver_path = "/tmp/chromedriver/chromedriver-linux64/chromedriver"  # インストールされたパス
    
    # ChromeDriverが存在するか確認
    if not os.path.exists(chromedriver_path):
        raise FileNotFoundError(f"ChromeDriverが見つかりません: {chromedriver_path}")
    
    service = Service(executable_path=chromedriver_path, log_path="/tmp/chromedriver.log")

    # WebDriverのインスタンスを作成
    driver = webdriver.Chrome(service=service, options=options)  # 新しい方法で driver を作成
    return driver


@app.route("/", methods=["GET"])
def home():
    return "Welcome to the Mercari search tool!"

@app.route("/search", methods=["GET"])
def search():
    query = request.args.get("keyword")
    if not query:
        return jsonify({"error": "検索ワードを指定してください"}), 400

    driver = setup_driver()

    try:
        driver.get("https://jp.mercari.com/")

        # 検索ボックスが表示されるまで待機
        search_box = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "input[type='search']"))
        )
        
        # 検索ワードを入力
        search_box.send_keys(query)
        search_box.send_keys(Keys.RETURN)

        # 検索結果が表示されるまで待機
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "sc-bcd1c877-2"))
        )
        items = driver.find_elements(By.CLASS_NAME, "sc-bcd1c877-2")

        if items:
            first_item = items[0]
            item_price = first_item.find_element(By.CLASS_NAME, "number__6b270ca7").text
            item_url = first_item.find_element(By.TAG_NAME, "a").get_attribute("href")
            result = {
                "name": query,
                "price": item_price,
                "url": item_url
            }
        else:
            result = {"name": "取得できませんでした", "price": "取得できませんでした", "url": "取得できませんでした"}

    except Exception as e:
        result = {"error": str(e)}
    finally:
        driver.quit()

    return jsonify(result)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
