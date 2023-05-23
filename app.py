from flask import Flask
from flask import request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from classify import classify_image

app = Flask(__name__)
limiter = Limiter(get_remote_address, app=app)

@app.route('/predict', methods=['POST'])
@limiter.limit("10/minute")  # Limit to 10 requests per minute.
def predict():
    uploaded_image = request.form['image']
    result = classify_image(uploaded_image)
    return result

        
if __name__ == "__main__":
    app.run(debug=True, port=80)
    
