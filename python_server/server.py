# ============================================================
# 🚀 SERVER.PY - Hand Detection API Server
# ============================================================
# This server uses your exact working Python script
# to detect hand landmarks and classify Alif
# ============================================================

from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import tensorflow as tf
import mediapipe as mp
import base64
import io
import os
import logging
from PIL import Image
from datetime import datetime
import sys

# ============================================================
# 📁 SETUP LOGGING
# ============================================================
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/server.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# ============================================================
# 🚀 INITIALIZE FLASK APP
# ============================================================
app = Flask(__name__)
CORS(app)  # Allow Flutter app to connect

# ============================================================
# 📦 LOAD YOUR TFLITE MODEL
# ============================================================
MODEL_PATH = os.path.join(os.path.dirname(__file__), 'models', 'alif_robust.tflite')

logger.info("=" * 60)
logger.info("🚀 STARTING HAND DETECTION SERVER")
logger.info("=" * 60)

try:
    # Check if model exists
    if not os.path.exists(MODEL_PATH):
        logger.error(f"❌ Model not found at: {MODEL_PATH}")
        logger.error("   Please copy your model to: python_server/models/alif_robust.tflite")
        exit(1)
    
    # Load model
    interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    logger.info("✅ Model loaded successfully!")
    logger.info(f"   Input shape: {input_details[0]['shape']}")
    logger.info(f"   Output shape: {output_details[0]['shape']}")
    logger.info(f"   Model path: {MODEL_PATH}")
    
except Exception as e:
    logger.error(f"❌ Failed to load model: {e}")
    exit(1)

# ============================================================
# 🖐️ INITIALIZE MEDIAPIPE HANDS
# ============================================================
try:
    mp_hands = mp.solutions.hands
    mp_drawing = mp.solutions.drawing_utils
    
    hands = mp_hands.Hands(
        static_image_mode=False,
        max_num_hands=1,
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5
    )
    logger.info("✅ MediaPipe Hands initialized successfully!")
    
except Exception as e:
    logger.error(f"❌ Failed to initialize MediaPipe: {e}")
    exit(1)

# ============================================================
# 📊 PREDICTION FUNCTION (Your exact working code)
# ============================================================
def predict_alif(image_cv):
    """
    This is your exact working script logic!
    Detects hand landmarks and classifies Alif
    """
    try:
        # Convert BGR to RGB (MediaPipe requires RGB)
        frame_rgb = cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB)
        results = hands.process(frame_rgb)
        
        # Check if hand detected
        if not results.multi_hand_landmarks:
            return {
                'isAlif': False,
                'confidence': 0.0,
                'hasHand': False,
                'landmarks': [],
                'message': 'No hand detected'
            }
        
        # Process first hand
        for hand_landmarks in results.multi_hand_landmarks:
            # Extract 21 landmarks (x, y) = 42 features
            features = []
            for lm in hand_landmarks.landmark:
                features.extend([lm.x, lm.y])
            
            # Convert to numpy array [1, 42]
            features = np.array(features, dtype=np.float32).reshape(1, -1)
            
            # Validate features count
            if features.shape[1] != 42:
                return {
                    'isAlif': False,
                    'confidence': 0.0,
                    'hasHand': False,
                    'landmarks': [],
                    'message': f'Invalid features: {features.shape[1]}'
                }
            
            # Run TFLite inference
            interpreter.set_tensor(input_details[0]['index'], features)
            interpreter.invoke()
            prediction = interpreter.get_tensor(output_details[0]['index'])
            
            # Get prediction
            if prediction.shape[1] == 1:
                # Binary classification
                score = float(prediction[0][0])
                is_alif = score > 0.5
            else:
                # Multi-class
                class_id = np.argmax(prediction[0])
                score = float(prediction[0][class_id])
                is_alif = class_id == 0
            
            # Return result with landmarks
            return {
                'isAlif': bool(is_alif),
                'confidence': score,
                'hasHand': True,
                'landmarks': features.tolist(),
                'message': 'Success'
            }
        
        return {
            'isAlif': False,
            'confidence': 0.0,
            'hasHand': False,
            'landmarks': [],
            'message': 'No hand detected'
        }
        
    except Exception as e:
        logger.error(f"Prediction error: {e}")
        return {
            'isAlif': False,
            'confidence': 0.0,
            'hasHand': False,
            'landmarks': [],
            'message': f'Error: {str(e)}'
        }

# ============================================================
# 🚀 API ENDPOINTS
# ============================================================

# 1. Health Check Endpoint
@app.route('/ping', methods=['GET'])
def ping():
    """Check if server is running"""
    return jsonify({
        'status': 'OK',
        'message': 'Server is running!',
        'model_loaded': True,
        'mediapipe_ready': True,
        'timestamp': datetime.now().isoformat()
    })

# 2. Main Detection Endpoint
@app.route('/detect', methods=['POST'])
def detect():
    """
    Detect hand and classify Alif
    Expects: JSON with 'image' field containing base64 encoded image
    Returns: JSON with prediction results
    """
    try:
        # Get image from request
        data = request.json
        if not data:
            return jsonify({'error': 'No data received'}), 400
        
        image_data = data.get('image')
        if not image_data:
            return jsonify({'error': 'No image data'}), 400
        
        # Decode base64 image
        try:
            image_bytes = base64.b64decode(image_data)
            image = Image.open(io.BytesIO(image_bytes))
            image_cv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
        except Exception as e:
            return jsonify({'error': f'Failed to decode image: {str(e)}'}), 400
        
        # Log image info
        logger.info(f"📷 Processing image: {image_cv.shape[1]}x{image_cv.shape[0]}")
        
        # Run prediction
        result = predict_alif(image_cv)
        
        # Log result
        if result['hasHand']:
            logger.info(f"✅ Hand detected! isAlif={result['isAlif']}, confidence={result['confidence']:.2f}")
        else:
            logger.info("❌ No hand detected")
        
        return jsonify(result)
        
    except Exception as e:
        logger.error(f"Server error: {e}")
        return jsonify({'error': str(e)}), 500

# 3. Version Info Endpoint
@app.route('/info', methods=['GET'])
def info():
    """Get server information"""
    return jsonify({
        'server': 'Hand Detection API',
        'version': '1.0.0',
        'model': {
            'path': MODEL_PATH,
            'input_shape': input_details[0]['shape'].tolist(),
            'output_shape': output_details[0]['shape'].tolist()
        },
        'mediapipe_version': mp.__version__,
        'tensorflow_version': tf.__version__,
        'python_version': sys.version
    })

# ============================================================
# 🏃 MAIN ENTRY POINT
# ============================================================
if __name__ == '__main__':
    logger.info("=" * 60)
    logger.info("✅ SERVER READY!")
    logger.info("=" * 60)
    logger.info("📍 Endpoints:")
    logger.info(f"   🧪 Health Check:  http://0.0.0.0:5000/ping")
    logger.info(f"   🔮 Detection:     http://0.0.0.0:5000/detect (POST)")
    logger.info(f"   📊 Info:          http://0.0.0.0:5000/info")
    logger.info("=" * 60)
    logger.info("🚀 Starting Flask server on port 5000...")
    logger.info("   Press CTRL+C to stop")
    logger.info("=" * 60)
    
    app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)