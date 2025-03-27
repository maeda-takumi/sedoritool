import os
from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

app = Flask(__name__)

def setup_driver():
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--headless")  # Render環境では必須
    options.add_argument("--disable-gpu")  # Render環境ではGPUを無効化

    # Chromiumのバイナリパスを指定
    options.binary_location = "/usr/bin/chromium"

    # chromedriverを明示的に指定
    driver = webdriver.Chrome(executable_path="/usr/bin/chromedriver", options=options)
    return driver


@app.route("/search", methods=["GET"])
def search():
    query = request.args.get("query")
    if not query:
        return jsonify({"error": "検索ワードを指定してください"}), 400

    driver = setup_driver()

    try:
        driver.get("https://jp.mercari.com/")

        # 検索ボックスが表示されるまで待機
        search_box = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "sc-55dc813e-2"))
        )
        
        # 検索ワードを入力
        search_box.send_keys(query)
        search_box.send_keys(Keys.RETURN)

        # 検索結果が表示されるまで待機
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CLASS_NAME, "sc-bcd1c877-2"))
        )
        items = driver.find_elements(By.CLASS_NAME, "sc-bcd1c877-2")

        # 最初の商品情報を取得
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
    # Render の環境変数 PORT を取得 (デフォルト: 5000)
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
