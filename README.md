# CloudStock: Real-Time Warehouse Monitoring berbasis Azure

---

## Deskripsi Proyek

Proyek ini adalah simulasi sistem smart warehouse berbasis Internet of Things. Sistem menggunakan sensor berat untuk melacak pergerakan barang di rak. Setiap perubahan berat akan dihitung menjadi jumlah stok dan ditampilkan di dashboard secara real-time.

---

## Arsitektur Singkat

Proyek ini menggunakan arsitektur Azure Serverless:

* IoT Simulator Wokwi: Mengirim data telemetry melalui MQTT
* Azure IoT Hub: Menerima dan mengelola data dari device
* Azure Functions: Memproses data dan menghitung jumlah barang
* Azure Cosmos DB: Menyimpan data stok secara real-time
* Azure Blob Storage: Hosting dashboard web

---

## Alur Sistem

* Sensor mengirim data berat
* Data masuk ke IoT Hub
* Azure Functions memproses data
* Data disimpan ke Cosmos DB
* Dashboard menampilkan data

---

## Fitur Utama

* Monitoring stok real-time
* Perhitungan otomatis
* Tanpa input manual
* Berbasis event
* Biaya efisien

---

## Contoh Data

```json
{
  "deviceId": "sensor-01",
  "weight": 5000,
  "timestamp": "2026-04-28T10:00:00Z"
}
```

---

## Logika Perhitungan

jumlah_barang = berat_total / berat_satuan

---

## Estimasi Biaya

* Virtual Machine: $38.40
* Azure IoT Hub: $0.00
* Azure Functions: $0.00
* Azure Cosmos DB: $0.00
* Storage Account: $1.50

Total: $39.90 per bulan

---

## Anggota Kelompok

1. Adventus Tangkasiang Senas - Cloud Architect dan Manager
2. Satria Mikhael Ekklesianto - IoT dan Backend Developer
3. Syawal Hidayat - Frontend Developer
4. Athay Setya Dwi Putri - DevOps dan Security Engineer

---
