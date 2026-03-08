
from datetime import datetime
import subprocess
import zipfile
import tarfile
import requests
import os


data_dir = "airflow/yelp_data"
zip_path = f"{data_dir}/yelp.zip"
os.makedirs(data_dir,exist_ok= True) # create folder if not exist 
url = "https://business.yelp.com/external-assets/files/Yelp-JSON.zip"
headers = {
    "User-Agent": "Mozilla/5.0"
}

with requests.get(url, headers=headers, stream=True) as r:  # stream to download in chuncks 
    total_size = int(r.headers.get("content-length", 0))
    downloaded = 0
    with open(zip_path,"wb") as f:
        for chunk in r.iter_content(chunk_size= 8192): # each chunk is 8KB
            f.write(chunk)
            downloaded += len(chunk)
            print(f"\rDownloaded {downloaded/1024/1024:.2f} MB / {total_size/1024/1024:.2f} MB",end="")
# subprocess.run(
#         [
#             "wget",
#             "--user-agent=Mozilla/5.0",
#             "-O",
#             f"{data_dir}/yelp.zip",
#             url
#         ],
#         check=True
#     )