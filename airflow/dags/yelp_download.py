from airflow.sdk import dag, task
from datetime import datetime
import requests
import zipfile
import tarfile
import os

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
        print(f"cargando {file_name}")
    
    zip_file_path = download_zip()
    tar_file_path = unzip_file(zip_file_path)
    json_files =  extract_tar(tar_file_path)
    upload_file.expand(file_name=json_files)

get_yelp_files()