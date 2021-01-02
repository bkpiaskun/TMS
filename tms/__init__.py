from flask import Flask, Response, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
@app.errorhandler(Exception)
def handle_exception(e):
    data_dict = [{"status": "Failure"}]
    response = jsonify(data_dict)
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

app.config['SECRET_KEY'] = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://USER:PASSWORD@IPADDRESS:5432/TMS'
db = SQLAlchemy(app)

from tms import routes

if __name__ == '__main__':
    app.run(host='0.0.0.0')
