from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import mediapipe as mp
import numpy as np
import base64
import io
from PIL import Image
import tensorflow as tf
import os

app = Flask(__name__)
CORS(app)  # This allows your Flutter app to talk to the server

# 1. Load Your Trained Alif Model
# Make sure your model file is in the same folder as this script
MODEL_PATH = "alif_robust.tflite"
if not os.path.exists(MODEL_PATH):
    print(f"❌ ERROR: Model file '{MODEL_PATH}' not found!")
    print("Please copy your 'alif_robust.tflite' into the 'python_server' folder.")
    exit()

interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
print("✅ Alif model loaded successfully!")

# 2. Initialize MediaPipe (Same as your working script)
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)
print("✅ MediaPipe Hands initialized!")

@app.route('/ping', methods=['GET'])
def ping():
    """Health check endpoint for Flutter"""
    return jsonify({'status': 'OK'})

@app.route('/detect', methods=['POST'])
def detect():
    """Main detection endpoint"""
    try:
        # 1. Get image from request
        data = request.json
        image_data = data.get('image')
        if not image_data:
            return jsonify({'error': 'No image data'}), 400

        # 2. Decode the base64 image
        image_bytes = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_bytes))
        image_cv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

        # 3. Process with MediaPipe (YOUR WORKING CODE)
        rgb = cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB)
        results = hands.process(rgb)

        # 4. If no hand, return immediately
        if not results.multi_hand_landmarks:
            return jsonify({
                'hasHand': False,
                'isAlif': False,
                'confidence': 0.0,
                'landmarks': []
            })

        # 5. Extract landmarks (21 points = 42 values)
        landmarks = []
        for hand_landmarks in results.multi_hand_landmarks:
            for lm in hand_landmarks.landmark:
                landmarks.extend([lm.x, lm.y])

        # 6. Run Alif model
        features = np.array(landmarks, dtype=np.float32).reshape(1, -1)
        interpreter.set_tensor(input_details[0]['index'], features)
        interpreter.invoke()
        prediction = interpreter.get_tensor(output_details[0]['index'])

        score = float(prediction[0][0])
        is_alif = score > 0.5

        # 7. Send result back
        return jsonify({
            'hasHand': True,
            'isAlif': is_alif,
            'confidence': score,
            'landmarks': landmarks  # Send the list of 42 values
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print("=" * 60)
    print("🚀 REAL-TIME HAND DETECTION SERVER")
    print("=" * 60)
    print("✅ Server is ready!")
    print("📡 Flutter app should connect to: http://YOUR_IP:5000")
    print("=" * 60)
    # Make sure to use host='0.0.0.0' so other devices on the network can connect
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)