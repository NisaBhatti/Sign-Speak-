"""
🧪 TEST SCRIPT - Test the server with a sample image
"""

import requests
import base64
import json
import os
import sys
from PIL import Image
import cv2
import numpy as np

# ============================================================
# CONFIGURATION
# ============================================================
SERVER_URL = 'http://localhost:5000/detect'

def test_ping():
    """Test if server is running"""
    try:
        response = requests.get('http://localhost:5000/ping')
        if response.status_code == 200:
            print("✅ Server is running!")
            print(json.dumps(response.json(), indent=2))
            return True
        else:
            print(f"❌ Server returned: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Cannot connect to server: {e}")
        print("   Make sure the server is running: python server.py")
        return False

def test_with_image(image_path):
    """Test detection with an image file"""
    if not os.path.exists(image_path):
        print(f"❌ Image not found: {image_path}")
        return
    
    # Read image
    with open(image_path, 'rb') as f:
        image_bytes = f.read()
    
    # Encode to base64
    base64_image = base64.b64encode(image_bytes).decode('utf-8')
    
    # Send to server
    print(f"📷 Sending image: {image_path}")
    response = requests.post(
        SERVER_URL,
        json={'image': base64_image},
        headers={'Content-Type': 'application/json'}
    )
    
    if response.status_code == 200:
        result = response.json()
        print("=" * 50)
        print("📊 RESULT:")
        print(f"   Has Hand: {result.get('hasHand', False)}")
        if result.get('hasHand'):
            print(f"   Is Alif: {result.get('isAlif', False)}")
            print(f"   Confidence: {result.get('confidence', 0):.2f}")
            print(f"   Landmarks: {len(result.get('landmarks', []))} points")
        print(f"   Message: {result.get('message', '')}")
        print("=" * 50)
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text)

def test_with_camera():
    """Test with live camera"""
    print("📷 Opening camera... (Press 'q' to quit)")
    cap = cv2.VideoCapture(0)
    
    if not cap.isOpened():
        print("❌ Cannot open camera")
        return
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        # Resize for faster processing
        frame_resized = cv2.resize(frame, (320, 240))
        
        # Convert to JPEG
        _, buffer = cv2.imencode('.jpg', frame_resized)
        base64_image = base64.b64encode(buffer).decode('utf-8')
        
        # Send to server
        try:
            response = requests.post(
                SERVER_URL,
                json={'image': base64_image},
                headers={'Content-Type': 'application/json'},
                timeout=0.5
            )
            
            if response.status_code == 200:
                result = response.json()
                if result.get('hasHand'):
                    label = "ALIF" if result.get('isAlif') else "Not Alif"
                    confidence = result.get('confidence', 0)
                    cv2.putText(frame, f"{label} ({confidence:.2f})", 
                               (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 
                               1, (0, 255, 0) if result.get('isAlif') else (0, 0, 255), 2)
                else:
                    cv2.putText(frame, "No Hand", (10, 30), 
                               cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        except:
            pass
        
        cv2.imshow('Hand Detection Test', frame)
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    print("=" * 60)
    print("🧪 TESTING HAND DETECTION SERVER")
    print("=" * 60)
    
    # Test 1: Ping server
    if not test_ping():
        sys.exit(1)
    
    print("\n" + "=" * 60)
    print("SELECT TEST:")
    print("1. Test with image file")
    print("2. Test with camera")
    choice = input("Enter choice (1 or 2): ")
    
    if choice == '1':
        image_path = input("Enter image path (e.g., test.jpg): ")
        test_with_image(image_path)
    elif choice == '2':
        test_with_camera()
    else:
        print("Invalid choice")