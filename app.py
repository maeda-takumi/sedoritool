from playwright.sync_api import sync_playwright

def check_chromium():
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto("https://www.google.com")
            print("Chromium is installed and working!")
            browser.close()
    except Exception as e:
        print("Error:", e)

# 実行
check_chromium()
