# ============================================================
# SIGNSPEAK SERVER
# Loads all *_robust.tflite models at startup
# Works locally (Wi-Fi) AND on Railway/Render
# ============================================================

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
import glob

# Reduce TF logging noise
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

app = Flask(__name__)
CORS(app)

# ============================================
# LOAD ALL MODELS AT STARTUP
# ============================================
MODELS = {}

model_files = glob.glob("*_robust.tflite")
print(f"📁 Found {len(model_files)} model files")

for model_file in model_files:
    # Skip files with spaces (breaks JSON / lookups)
    if " " in model_file:
        print(f"⚠️ Skipping file with space: {model_file}")
        continue

    name = model_file.replace("_robust.tflite", "")
    try:
        interpreter = tf.lite.Interpreter(model_path=model_file)
        interpreter.allocate_tensors()
        MODELS[name] = {
            'interpreter': interpreter,
            'input_details': interpreter.get_input_details(),
            'output_details': interpreter.get_output_details(),
        }
        print(f"✅ Loaded: {name}")
    except Exception as e:
        print(f"❌ Failed to load {name}: {e}")

print("=" * 60)
print(f"✅ TOTAL MODELS LOADED: {len(MODELS)}")
print(f"📚 Available: {sorted(MODELS.keys())}")
print("=" * 60)

# ============================================
# MEDIAPIPE HANDS
# ============================================
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5,
)
print("✅ MediaPipe Hands initialized!")

# ============================================
# ARABIC DISPLAY MAPPING (full Urdu alphabet order)
# ============================================
ALPHABET_DISPLAY = {
    'alif': 'ا',
    'bay': 'ب',
    'pay': 'پ',
    'tay': 'ت',
    'tey': 'ٹ',
    'thay': 'ث',
    'jeem': 'ج',
    'chay': 'چ',
    'khay': 'خ',
    'dal': 'د',
    'daal': 'ڈ',
    'zal': 'ذ',
    'ray': 'ر',
    'rray': 'ڑ',
    'zay': 'ز',
    'seen': 'س',
    'sheen': 'ش',
    'suaad': 'ص',
    'zvad': 'ض',
    'toayn': 'ط',
    'zoyn': 'ظ',
    'ain': 'ع',
    'ghain': 'غ',
    'fe': 'ف',
    'quaaf': 'ق',
    'kaf': 'ك',
    'gaf': 'گ',
    'lam': 'ل',
    'mim': 'م',
    'noon': 'ن',
    'vao': 'و',
    'hamza': 'ء',
    'choti_ye': 'ی',
    'bari_ye': 'ے',
}

# ============================================
# ROUTES
# ============================================
@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'status': 'running',
        'message': 'SignSpeak Server',
        'models_loaded': len(MODELS),
        'endpoints': ['/ping', '/models', '/warmup/<alphabet>', '/detect'],
    })


@app.route('/ping', methods=['GET'])
def ping():
    return jsonify({
        'status': 'OK',
        'models': list(MODELS.keys()),
    })


@app.route('/models', methods=['GET'])
def get_models():
    return jsonify({
        'models': [
            {
                'name': n,
                'display': ALPHABET_DISPLAY.get(n, n),
                'arabic': ALPHABET_DISPLAY.get(n, '?'),
            }
            for n in MODELS.keys()
        ],
        'count': len(MODELS),
    })


@app.route('/warmup/<alphabet>', methods=['GET'])
def warmup(alphabet):
    """Models are already loaded at startup — just confirm."""
    available = alphabet in MODELS
    return jsonify({
        'alphabet': alphabet,
        'status': 'ready' if available else 'missing',
        'time': 0,
    })


@app.route('/detect', methods=['POST'])
def detect():
    """
    Expects: { "image": "<base64 jpeg>", "alphabet": "alif" }
    Returns: { hasHand, isAlphabet, confidence, landmarks, ... }
    """
    try:
        data = request.json
        image_data = data.get('image')
        alphabet = data.get('alphabet', 'alif')

        if not image_data:
            return jsonify({'error': 'No image data'}), 400

        # ---- decode image ----
        image_bytes = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        image_cv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

        print(f"📷 Image: {image.size}, alphabet={alphabet}")

        # ---- MediaPipe ----
        rgb = cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB)
        results = hands.process(rgb)

        if not results.multi_hand_landmarks:
            print("❌ No hand detected")
            return jsonify({
                'hasHand': False,
                'isAlphabet': False,
                'confidence': 0.0,
                'landmarks': [],
                'alphabet': alphabet,
                'display': ALPHABET_DISPLAY.get(alphabet, alphabet),
                'message': 'No hand detected',
            })

        # ---- extract 21 landmarks (42 floats) ----
        landmarks = []
        for hl in results.multi_hand_landmarks:
            for lm in hl.landmark:
                landmarks.extend([lm.x, lm.y])

        print(f"✅ Hand detected — {len(landmarks)} values")

        # ---- model check ----
        if alphabet not in MODELS:
            return jsonify({
                'hasHand': True,
                'isAlphabet': False,
                'confidence': 0.0,
                'landmarks': landmarks,
                'alphabet': alphabet,
                'display': ALPHABET_DISPLAY.get(alphabet, alphabet),
                'message': f'Model {alphabet} not loaded',
            })

        # ---- run inference ----
        features = np.array(landmarks, dtype=np.float32).reshape(1, -1)
        model = MODELS[alphabet]
        interpreter = model['interpreter']
        interpreter.set_tensor(model['input_details'][0]['index'], features)
        interpreter.invoke()
        pred = interpreter.get_tensor(model['output_details'][0]['index'])
        score = float(pred[0][0])

        print(f"🎯 Score: {score:.3f}")

        return jsonify({
            'hasHand': True,
            'isAlphabet': score > 0.5,
            'confidence': score,
            'landmarks': landmarks,
            'alphabet': alphabet,
            'display': ALPHABET_DISPLAY.get(alphabet, alphabet),
            'message': 'Success',
        })

    except Exception as e:
        print(f"❌ Detect error: {e}")
        return jsonify({'error': str(e)}), 500


# ============================================
# ENTRYPOINT
# ============================================
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print("=" * 60)
    print("🚀 SIGNSPEAK SERVER")
    print("=" * 60)
    print(f"📚 {len(MODELS)} models ready")
    print(f"📡 Listening on 0.0.0.0:{port}")
    print(f"🔎 Local test: http://YOUR_WIFI_IP:{port}/ping")
    print("=" * 60)
    app.run(host='0.0.0.0', port=port, debug=False, threaded=True)