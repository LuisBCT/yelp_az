from airflow.decorators import dag, task
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
        url = "https://business.yelp.com/external-assets/files/Yelp-JSON.zip"

        with requests.get(url,stream= True) as r:  # stream to download in chuncks 
            with open(zip_path,"wb") as f:
                for chunk in r.iter_content(chunk_size= 8192): # each chunk is 8KB
                    f.write(chunk)
            
        return zip_path
    
    @task
    def unzip_file(file_path):
        with zipfile.ZipFile(file_path, "r") as zipr:
            zipr.extractall(data_dir)
        
        return "OK"
    
    @task
    def extract_tar(tar_path):
        with tarfile.open(tar_path) as tar:
            tar.extractall(data_dir)
        
        return "OK"
    
    zip_file_path = download_zip()
    tar_file_path = unzip_file(zip_file_path)
    extract_tar(tar_file_path)

get_yelp_files()