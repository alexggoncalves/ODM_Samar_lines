import cv2
import cvzone
from cvzone.HandTrackingModule import HandDetector
import socket

# Parameters
width, height = 1280, 720

# Webcam
cap = cv2.VideoCapture(0)
cap.set(3, width)
cap.set(4, height)
width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)

# Hand Detector
hand_detector = HandDetector(maxHands=10, detectionCon=0.5)

# Communication
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ("127.0.0.1", 50007)

# Connect to server
try:
    sock.connect(server_address)
    print("Connected to Processing")
    data = "Hello from Python"
    sock.sendall(data.encode())
except Exception as e:
    print("Error:", e)

while True:
    # Get the frame from the webcam
    success, img = cap.read()
    # Hands
    hands, img = hand_detector.findHands(img, flipType=True)

    data = []

    data.extend([int(width)])  # 0
    data.extend([int(height)])  # 1
    data.extend([len(hands)])  # 2

    if hands:
        for hand in hands:
            centerPoint = hand['center']  # center of the hand cx,cy
            data.extend([centerPoint[0], height - centerPoint[1]])  # 3 - 4

            bbox = hand["bbox"]  # Bounding box info x,y,w,h
            hand_width = bbox[2]
            hand_height = bbox[3]
            data.extend([hand_width,hand_height])   # 5 - 6
            # data.extend([bbox[0], height - bbox[1], bbox[2], bbox[3]])  # 6 - 9

            # handType = hand["type"]  # Hand Type "Left" or "Right"
            # data.extend([handType])  # 10

    sock.sendto(str.encode(str(data) + '\n'), server_address)

    # Uncomment next line to view webcam capture
    cv2.imshow("image", img)

    # If it gets to laggy change wait key to 2
    cv2.waitKey(1)
