CloudStock: Real-Time Warehouse Monitoring berbasis Azure

Deskripsi Proyek
Proyek ini adalah simulasi sistem smart warehouse berbasis Internet of Things. Sistem menggunakan sensor berat untuk melacak pergerakan barang di rak. Setiap perubahan berat akan dihitung menjadi jumlah stok secara otomatis dan ditampilkan di dashboard secara real-time.

Arsitektur Sistem
Proyek ini menggunakan arsitektur Azure serverless.

Alur sistem:

IoT Simulator Wokwi mengirim data berat melalui MQTT
Azure IoT Hub menerima data telemetry
Azure Functions memproses data dan menghitung jumlah barang
Azure Cosmos DB menyimpan data stok terbaru
Frontend dashboard mengambil data dan menampilkan grafik

Komponen utama:

IoT Simulator Wokwi sebagai pengirim data
Azure IoT Hub sebagai message broker
Azure Functions sebagai pemroses logika
Azure Cosmos DB sebagai database NoSQL
Azure Blob Storage untuk hosting frontend

Fitur Utama

Monitoring stok secara real-time
Perhitungan otomatis tanpa input manual
Sistem berbasis event
Dashboard untuk visualisasi data
Infrastruktur hemat biaya

Contoh Data
{
"deviceId": "sensor-01",
"weight": 5000,
"timestamp": "2026-04-28T10:00:00Z"
}

Logika Sistem
jumlah_barang = berat_total / berat_satuan

Estimasi Biaya

Virtual Machine: $38.40
IoT Hub: $0.00
Functions: $0.00
Cosmos DB: $0.00
Storage: $1.50

Total sekitar $39.90 per bulan

Anggota Kelompok

Adventus Tangkasiang Senas sebagai Cloud Architect
Satria Mikhael Ekklesianto sebagai IoT dan Backend Developer
Syawal Hidayat sebagai Frontend Developer
Athay Setya Dwi Putri sebagai DevOps dan Security

Perubahan utama dari versi lama

AWS diganti ke Azure
DynamoDB diganti Cosmos DB
Lambda diganti Azure Functions
IoT Core diganti IoT Hub
S3 diganti Blob Storage
