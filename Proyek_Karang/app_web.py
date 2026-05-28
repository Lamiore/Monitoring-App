from flask import Flask, render_template, request, jsonify, Response
from flask_cors import CORS
from ultralytics import YOLO
import cv2
import numpy as np
import base64
import csv
import threading
import time
from io import StringIO

app = Flask(__name__)
CORS(app)

# ==============================
# LOAD MODEL YOLO
# ==============================
model = YOLO("best.pt")

# ==============================
# STORAGE HISTORY
# ==============================
history_data = []


# ==============================
# PREDIKSI KESEHATAN KARANG
# ==============================
def predict_health(roi):

    # Hindari error jika area kosong
    if roi.size == 0:
        return "Tidak Diketahui"

    # Hitung rata-rata warna
    avg_color = roi.mean(axis=(0,1))

    blue = avg_color[0]
    green = avg_color[1]
    red = avg_color[2]

    # Hitung brightness
    brightness = (red + green + blue) / 3

    # RULE BASED HEALTH PREDICTION

    if brightness > 180:
        return "Mengalami Pemutihan"

    elif brightness > 120:
        return "Kurang Sehat"

    else:
        return "Sehat"


# ==============================
# LIVE CAMERA (untuk MJPEG stream)
# ==============================
_camera = None
_camera_lock = threading.Lock()


def get_camera():
    global _camera
    with _camera_lock:
        if _camera is None or not _camera.isOpened():
            _camera = cv2.VideoCapture(0)
            _camera.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
            _camera.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        return _camera


def annotate_frame(frame):
    """Jalankan YOLO + prediksi kesehatan, gambar bounding box ke frame."""
    results = model.predict(frame, conf=0.5, imgsz=320, verbose=False)

    detections = []
    for box in results[0].boxes:
        cls_id = int(box.cls[0])
        label = model.names[cls_id]
        x1, y1, x2, y2 = map(int, box.xyxy[0])

        roi = frame[y1:y2, x1:x2]
        health = predict_health(roi)

        detections.append({"jenis": label, "kesehatan": health})

        if health == "Sehat":
            color = (0, 255, 0)
        elif health == "Kurang Sehat":
            color = (0, 255, 255)
        else:
            color = (0, 0, 255)

        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        cv2.putText(
            frame,
            f"{label} | {health}",
            (x1, max(y1 - 10, 20)),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.6,
            color,
            2,
        )
    return frame, detections


def generate_mjpeg():
    """Generator MJPEG: baca kamera, annotate, encode JPEG, yield multipart."""
    cap = get_camera()
    while True:
        success, frame = cap.read()
        if not success:
            time.sleep(0.05)
            continue

        frame, _ = annotate_frame(frame)

        ok, buffer = cv2.imencode(
            '.jpg', frame, [int(cv2.IMWRITE_JPEG_QUALITY), 70]
        )
        if not ok:
            continue

        yield (
            b'--frame\r\n'
            b'Content-Type: image/jpeg\r\n\r\n' + buffer.tobytes() + b'\r\n'
        )


# ==============================
# HALAMAN UTAMA
# ==============================
@app.route('/')
def index():
    return render_template('index.html')


# ==============================
# MJPEG STREAM ENDPOINT (untuk Flutter)
# ==============================
@app.route('/video_feed')
def video_feed():
    return Response(
        generate_mjpeg(),
        mimetype='multipart/x-mixed-replace; boundary=frame',
    )


# ==============================
# DETEKSI REALTIME KAMERA
# ==============================
@app.route('/predict_camera', methods=['POST'])
def predict_camera():

    data = request.json['image']

    # Decode base64 image
    encoded = data.split(',')[1]

    img_bytes = base64.b64decode(encoded)

    np_arr = np.frombuffer(img_bytes, np.uint8)

    frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    # YOLO Prediction
    results = model.predict(
        frame,
        conf=0.5,
        imgsz=320
    )

    counts = []

    # ==============================
    # LOOP DETEKSI
    # ==============================
    for box in results[0].boxes:

        cls_id = int(box.cls[0])

        conf = float(box.conf[0])

        label = model.names[cls_id]

        # Bounding Box
        x1, y1, x2, y2 = map(int, box.xyxy[0])

        # Ambil area ROI karang
        roi = frame[y1:y2, x1:x2]

        # Prediksi kesehatan
        health = predict_health(roi)

        # Simpan data realtime
        detection_data = {
            "jenis": label,
            "kesehatan": health
        }

        counts.append(detection_data)

        # ==============================
        # SIMPAN HISTORY
        # ==============================
        history_data.append(detection_data)

        # Batasi history maksimal 1000 data
        if len(history_data) > 1000:
            history_data.pop(0)

        # ==============================
        # WARNA BOX BERDASARKAN STATUS
        # ==============================

        if health == "Sehat":
            color = (0,255,0)

        elif health == "Kurang Sehat":
            color = (0,255,255)

        else:
            color = (0,0,255)

        # Bounding box
        cv2.rectangle(
            frame,
            (x1, y1),
            (x2, y2),
            color,
            2
        )

        # Text label
        text = f"{label} | {health}"

        cv2.putText(
            frame,
            text,
            (x1, y1 - 10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            color,
            2
        )

    # ==============================
    # HASIL SUMMARY
    # ==============================
    summary = counts

    # Encode kembali hasil gambar
    _, buffer = cv2.imencode('.jpg', frame)

    processed_image = base64.b64encode(buffer).decode('utf-8')

    return jsonify({
        'image': processed_image,
        'total': len(counts),
        'populasi': summary
    })


# ==============================
# DETEKSI FILE GAMBAR
# ==============================
@app.route('/predict', methods=['POST'])
def predict():

    file = request.files['file']

    img_bytes = file.read()

    nparr = np.frombuffer(img_bytes, np.uint8)

    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model.predict(
        img,
        conf=0.5,
        imgsz=320
    )

    counts = []

    for box in results[0].boxes:

        cls_id = int(box.cls[0])

        label = model.names[cls_id]

        # Bounding box
        x1, y1, x2, y2 = map(int, box.xyxy[0])

        # ROI
        roi = img[y1:y2, x1:x2]

        # Prediksi kesehatan
        health = predict_health(roi)

        detection_data = {
            "jenis": label,
            "kesehatan": health
        }

        counts.append(detection_data)

        # Simpan history upload
        history_data.append(detection_data)

        # Batasi history
        if len(history_data) > 1000:
            history_data.pop(0)

    return jsonify({
        'total': len(counts),
        'populasi': counts
    })


# ==============================
# EXPORT HISTORY CSV
# ==============================
@app.route('/export_csv')
def export_csv():

    si = StringIO()

    writer = csv.writer(si)

    # Header CSV
    writer.writerow([
        'No',
        'Jenis Karang',
        'Status Kesehatan'
    ])

    # Isi Data
    for idx, item in enumerate(history_data, start=1):

        writer.writerow([
            idx,
            item['jenis'],
            item['kesehatan']
        ])

    output = si.getvalue()

    return Response(
        output,
        mimetype="text/csv",
        headers={
            "Content-Disposition":
            "attachment; filename=history_deteksi_karang.csv"
        }
    )


# ==============================
# RUN FLASK
# ==============================
if __name__ == '__main__':

    app.run(
        host='0.0.0.0',
        port=5001,
        debug=True
    )