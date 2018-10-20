# Cannonball Internal API
# IMPORTS
import os
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging
from flask_pymongo import PyMongo
# END IMPORTS

# Define App requirements
app = Flask(__name__, static_folder="../static", template_folder="../static")

# CONFIG
app.config["MONGO_URI"] = "TODO"
app.debug=True

@app.route("/test", methods=['GET'])
def test():
    app.logger.debug("Got Request from Flutter")
    return 'Nice! You Triggered it!'

# LAUNCH APP
if __name__ == "__main__":
        port = int(os.environ.get("PORT", 5000))
        app.logger.info("Getting Flask up and running...\n")
        app.run(host = '0.0.0.0' , port = port)
