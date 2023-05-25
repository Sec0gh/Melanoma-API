from flask import Flask, jsonify
from flask import request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from werkzeug.utils import secure_filename
from classify import classify_image
import os

app = Flask(__name__)
limiter = Limiter(get_remote_address, app=app)

UPLOAD_DIRECTORY = "./uploads"
ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg']

app.config["MAX_CONTENT_LENGTH"] = 0.4 * 1024 * 1024    # The max image size is 0.4 MB.

def allowed_file(file_name):
    return '.' in file_name and file_name.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def welcome():
    html = '''
    <html>
        <head>
            <title>Welcome</title>
        </head>
        <body>
            <h1>Hello Friend</h1>
            <p>Go to access this endpoint /predict with POST request method to start testing your image through submit it in "img" parameter.</p>
        </body>
    </html>
    '''
    return html

@app.route('/predict', methods=['POST'])
@limiter.limit("10/minute")  # Limit to 10 requests per minute.
def predict():
    uploaded_image = request.files['img']
    if uploaded_image.filename == '':
        return jsonify({"error": "No image selected"}), 400
    
    if uploaded_image and allowed_file(uploaded_image.filename):
        file_name = secure_filename(uploaded_image.filename)
        file_path = os.path.join(UPLOAD_DIRECTORY, file_name)
        uploaded_image.save(file_path)
        result = classify_image(uploaded_image.filename)
        return jsonify(result)
    else:
        return jsonify({'error': 'Invalid file, We can only accept JPG,JPEG or PNG images'}), 400  

      
if __name__ == "__main__":
    app.run(debug=True, port=80)
