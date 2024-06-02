import cv2
import cvzone
from cvzone.HandTrackingModule import HandDetector
from cvzone.FaceDetectionModule import FaceDetector
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
hand_detector = HandDetector(maxHands=10, detectionCon=0.8)

# Face Detector
face_detector = FaceDetector(minDetectionCon=0.6)

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
    # Face
    img, faces = face_detector.findFaces(img, draw=False)

    data = []

    data.extend([int(width)])  # 0
    data.extend([int(height)])  # 1

    data.extend([len(hands)])  # 3

    if hands:
        for hand in hands:

            centerPoint = hand['center']  # center of the hand cx,cy
            data.extend([centerPoint[0], height - centerPoint[1]])  # 4 - 5

            bbox = hand["bbox"]  # Bounding box info x,y,w,h
            data.extend([bbox[0], height - bbox[1], bbox[2], bbox[3]])  # 6 - 9

            handType = hand["type"]  # Hand Type "Left" or "Right"
            data.extend([handType])  # 10

    data.extend([len(faces)])  # 11

    if faces:
        # Loop through each bounding box
        # face contains 'id', 'bbox', 'score', 'center'
        for face in faces:
            # ---- Get Data  ---- #
            center = face["center"]
            data.extend([center[0], height - center[1]])  # 12 - 13
            x, y, w, h = face['bbox']
            data.extend([x, y, w, h])  # 14 - 17

            # ---- Draw Data  ---- #
            cvzone.cornerRect(img, (x, y, w, h))

    sock.sendto(str.encode(str(data) + '\n'), server_address)

    cv2.imshow("image", img)

    cv2.waitKey(2)
