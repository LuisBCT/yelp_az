FROM apache/airflow:3.1.7

USER root

RUN apt-get update && apt-get install -y wget tar \
    && wget https://aka.ms/downloadazcopy-v10-linux \
    && tar -xvf downloadazcopy-v10-linux \
    && cp ./azcopy_linux_amd64_*/azcopy /usr/local/bin/ \
    && chmod +x /usr/local/bin/azcopy \
    && rm -rf azcopy_linux_amd64_* downloadazcopy-v10-linux

USER airflow