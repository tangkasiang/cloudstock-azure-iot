import azure.functions as func
import logging
import os
import uuid
import json
from azure.data.tables import TableClient

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="telemetry", methods=["POST"])
def ReceiveIoTData(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('CloudStock API: Menerima data baru.')

    try:
        req_body = req.get_json()
    except ValueError:
        return func.HttpResponse("Format JSON salah!", status_code=400)

    # Mengambil koneksi dari Key Vault (lewat Environment Variable)
    conn_str = os.environ.get("TABLE_STORAGE_CONNECTION")
    table_name = "StockDataTable"

    if not conn_str:
        return func.HttpResponse("Error: Koneksi Database tidak ditemukan!", status_code=500)

    try:
        # Hubungkan ke Azure Table Storage
        table_client = TableClient.from_connection_string(conn_str=conn_str, table_name=table_name)
        
        # Susun data untuk disimpan
        entity = {
            "PartitionKey": "IoTDevice-Palangkaraya",
            "RowKey": str(uuid.uuid4()),
            "Temperature": req_body.get("temperature", 0.0),
            "Humidity": req_body.get("humidity", 0.0),
            "StockLevel": req_body.get("stock_level", 0),
            "Status": req_body.get("status", "Normal")
        }

        # Simpan ke tabel
        table_client.create_entity(entity=entity)
        
        return func.HttpResponse(
            json.dumps({"status": "Sukses", "message": "Data tercatat di CloudStock"}),
            mimetype="application/json",
            status_code=201
        )
        
    except Exception as e:
        logging.error(f"Gagal simpan database: {str(e)}")
        return func.HttpResponse(f"Database Error: {str(e)}", status_code=500)