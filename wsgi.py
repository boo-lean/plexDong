from os import environ

from app import app

# Gets the app from app.py and runs it
if __name__ == "__main__":
    port = int(environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
