import os
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

def setup_driver():
    options = Options()
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--headless")
    options.add_argument("--disable-gpu")

    # 環境変数からchromiumのパスを取得
    options.binary_location = os.getenv("CHROMIUM_PATH", "/usr/bin/chromium")

    # ドライバーのパスを指定
    service = Service(executable_path=os.getenv("CHROMEDRIVER_PATH", "/usr/bin/chromedriver"))
    
    driver = webdriver.Chrome(service=service, options=options)
    return driver
