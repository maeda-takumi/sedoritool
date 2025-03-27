import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    return "Welcome to the Mercari search tool!"

@app.route("/search", methods=["GET"])
def search():
    # デプロイ用のダミー応答を返す
    result = {"message": "Mercari search is not active during deployment"}
    return jsonify(result)

if __name__ == "__main__":
    # 開発時にデバッグモードを無効にして、デプロイ用に修正
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)  # debug=False にしてデバッグモードを無効化
