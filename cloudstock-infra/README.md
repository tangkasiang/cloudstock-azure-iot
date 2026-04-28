# CloudStock: Real-Time Warehouse Monitoring berbasis AWS

## Deskripsi Proyek
Proyek ini adalah simulasi sistem *smart warehouse* berbasis Internet of Things (IoT). Kami menggunakan sensor berat (simulasi Load Cell) untuk melacak pergerakan barang di rak penyimpanan. Setiap kali barang diambil atau diletakkan, sistem akan secara otomatis menghitung sisa stok berdasarkan perubahan berat dan memperbaruinya di *dashboard* admin toko secara *real-time*.

## Arsitektur Singkat
Proyek ini mengadopsi arsitektur **AWS Serverless 100%**:
- **IoT Simulator (Wokwi):** Mengirim data *telemetry* perubahan berat barang via protokol MQTT.
- **AWS IoT Core:** Berfungsi sebagai *message broker* yang menerima dan mem-filter aliran data.
- **AWS Lambda:** Mengeksekusi kalkulasi konversi berat menjadi jumlah barang (*business logic*).
- **Amazon DynamoDB:** Menyimpan status persediaan barang secara aktual dan berkinerja tinggi.
- **Amazon API Gateway & S3:** Menyediakan *endpoint* REST API dan *hosting* untuk antarmuka *Web Dashboard* admin.

## Anggota Kelompok
1. **Adventus Tangkasiang Senas** - Cloud Architect & Manager
2. **Satria Mikhael Ekklesianto** - IoT & Backend Developer
3. **Syawal Hidayat** - Frontend Web Developer
4. **Athay Setya Dwi Putri** - DevOps & Security Engineer
