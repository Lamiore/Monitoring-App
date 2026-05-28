import cv2
from ultralytics import YOLO

# 1. Load model hasil training terbaik Anda
model = YOLO('runs/detect/train-2/weights/best.pt')

# 2. Buka Kamera Laptop (0 adalah kamera bawaan)
# Jika ingin pakai video file, ganti 0 menjadi 'nama_video.mp4'
cap = cv2.VideoCapture(0)

print("Tekan 'q' untuk keluar dari aplikasi")

while cap.isOpened():
    success, frame = cap.read()
    if not success:
        break

    # 3. Jalankan Prediksi YOLO
    results = model.predict(source=frame, conf=0.5, show=False)

    # 4. Ambil informasi untuk penghitungan populasi
    annotated_frame = results[0].plot()
    detections = results[0].boxes.cls.tolist() # Daftar ID kelas yang terdeteksi
    
    # Hitung jumlah per jenis
    counts = {}
    for class_id in detections:
        name = model.names[int(class_id)]
        counts[name] = counts.get(name, 0) + 1

    # 5. Tampilkan Statistik di Layar
    y_pos = 30
    cv2.putText(annotated_frame, "Statistik Populasi:", (10, y_pos), 
                cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)
    
    for name, count in counts.items():
        y_pos += 30
        text = f"- {name}: {count}"
        cv2.putText(annotated_frame, text, (10, y_pos), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

    # 6. Tampilkan Hasil Video
    cv2.imshow("Aplikasi Deteksi & Penghitung Karang Polimdo", annotated_frame)

    # Berhenti jika menekan tombol 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()