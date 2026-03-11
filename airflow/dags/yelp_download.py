from airflow.sdk import dag, task
from datetime import datetime
import requests
import zipfile
import tarfile
import os
from azure.storage.blob import BlobServiceClient
from azure.identity import ClientSecretCredential

data_dir = "/opt/airflow/yelp_data"
zip_path = f"{data_dir}/yelp.zip"

@dag(
    dag_id = "download_yelp_data",
    start_date = datetime(2024,1,1),
    schedule = None,
    catchup = False,
    tags = ["yelp"]
)
def get_yelp_files():
    @task
    def download_zip():
        os.makedirs(data_dir,exist_ok= True) # create folder if not exist 
        headers = {"User-Agent": "Mozilla/5.0"}
        url = "https://business.yelp.com/external-assets/files/Yelp-JSON.zip"

        with requests.get(url, headers=headers, stream=True) as r:
            with open(zip_path,"wb") as f:
                for chunk in r.iter_content(chunk_size= 8192): # each chunk is 8KB
                    f.write(chunk)
        return zip_path
    
    @task
    def unzip_file(file_path):
        with zipfile.ZipFile(file_path, "r") as zipr:
            zipr.extractall(data_dir)
        
        return f"{data_dir}/Yelp JSON/yelp_dataset.tar"
    
    @task
    def extract_tar(tar_path):
        extracted_files = []
        with tarfile.open(tar_path) as tar:
            tar.extractall(data_dir)

            for member in tar.getmembers():
                if member.name.endswith(".json"):
                    extracted_files.append(member.name)   
        return extracted_files
    
    @task
    def upload_file(file_name):
        account_name = "styelpaz01"
        container_name = "staging"
        file_path = f"{data_dir}/{file_name}"

        credential = ClientSecretCredential(
            tenant_id= os.environ["AZURE_TENANT_ID"],
            client_id= os.environ["AZURE_CLIENT_ID"],
            client_secret= os.environ["AZURE_CLIENT_SECRET"],
        )

        blob_service_client = BlobServiceClient(account_url=f"https://{account_name}.blob.core.windows.net",
                                credential=credential
                            )
        container_client = blob_service_client.get_container_client(container_name)
        
        with open(file_path, "rb") as data:
            container_client.upload_blob(
                name=file_name,
                data=data,
                overwrite=True
            )
    
    zip_file_path = download_zip()
    tar_file_path = unzip_file(zip_file_path)
    json_files =  extract_tar(tar_file_path)
    upload_file.expand(file_name=json_files)

get_yelp_files()