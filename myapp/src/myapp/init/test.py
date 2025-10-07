import cv2
import os
from datetime import datetime
from google.cloud import storage

# Google Cloud Storage Configuration
GCS_BUCKET = 'adam20240618_test'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.path.join(os.path.dirname(__file__), 'adam-426508-8ab1c7900d56.json')
storage_client = storage.Client()

class RecordWidget:

    def __init__(self, cam0_index, cam1_index):
        self.customer_cam_index = cam0_index
        self.staff_cam_index = cam1_index
        self.recording = False
        self.video_filenames = []

        # 檢查並建立資料夾
        os.makedirs('video', exist_ok=True)

    def record_video(self):
        """使用指定的方式錄製影片"""
        service_id = 'S' + datetime.now().strftime('%Y%m%d%H%M%S')
        output_filename0 = f'video/{service_id}_cam0.avi'
        output_filename1 = f'video/{service_id}_cam1.avi'

        # 開啟攝像頭，分別為顧客和員工的攝像頭
        cap0 = cv2.VideoCapture(self.customer_cam_index)
        cap1 = cv2.VideoCapture(self.staff_cam_index)

        # 設置影像的寬和高
        cap0.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        cap0.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
        cap1.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
        cap1.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

        # 定義視頻編碼器（使用 XVID 編碼器）和輸出視頻的參數
        fourcc = cv2.VideoWriter_fourcc(*'XVID')
        out0 = cv2.VideoWriter(output_filename0, fourcc, 30, (640, 480))
        out1 = cv2.VideoWriter(output_filename1, fourcc, 30, (640, 480))

        self.video_filenames.append(output_filename0)
        self.video_filenames.append(output_filename1)

        print("開始錄影，按 'q' 結束錄影")
        
        while True:
            # 從兩個攝像頭分別讀取影像
            ret0, frame0 = cap0.read()
            ret1, frame1 = cap1.read()

            if ret0:
                cv2.imshow('Customer Camera', frame0)
                out0.write(frame0)
            if ret1:
                cv2.imshow('Staff Camera', frame1)
                out1.write(frame1)
            
            # 按下 'q' 結束錄影
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

        # 釋放攝像頭和文件
        cap0.release()
        cap1.release()
        out0.release()
        out1.release()
        cv2.destroyAllWindows()

        print(f"Video saved to {output_filename0} and {output_filename1}")

    def start_recording(self):
        """開始錄影"""
        self.recording = True
        self.record_video()
        self.recording = False
        print("Recording stopped.")
        self.upload_files_to_gcs()

    def upload_files_to_gcs(self):
        """上傳影片到 GCS"""
        print("Uploading files to GCS...")

        # 上傳影片文件
        for video_file in self.video_filenames:
            self.upload_to_gcs(video_file)

    def upload_to_gcs(self, filename):
        """上傳單個文件到 GCS"""
        try:
            bucket = storage_client.bucket(GCS_BUCKET)
            blob = bucket.blob(filename)
            blob.upload_from_filename(filename)
            gcs_url = f"gs://{GCS_BUCKET}/{filename}"
            print(f"Uploaded {filename} to {gcs_url}")
            return gcs_url
        except Exception as e:
            print(f"Error uploading {filename} to GCS: {e}")
            return ""

# Example usage
if __name__ == "__main__":
    widget = RecordWidget(cam0_index=0, cam1_index=1)  # 假設兩個攝影機的索引
    widget.start_recording()
