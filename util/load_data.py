#!/usr/bin/env python3

import sys
from collections import namedtuple

import requests as rq
import io
from zipfile import ZipFile

from os import listdir

import pandas as pd

update_file = sys.argv[1]

temp_folder_location = ".temp_data"

data_folder_location = "data"


class PhmsaDownloader:
    def __init__(self, temp_folder, data_folder):
        self.temp_folder = temp_folder
        self.data_folder = data_folder

        source = namedtuple('source', 'address skiprows')
        self.sources = {
            'pipelines_2010': source(
                'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline/annual_hazardous_liquid_2010_present.zip',
                2)}

    def update_data(self, file):
        self.download_data(file)
        temp_data = self.read_files(file)
        self.save_data(file, temp_data)

    def download_data(self, file):
        data_zipped = rq.get(self.sources[file].address)
        data = ZipFile(io.BytesIO(data_zipped.content))
        data.extractall(f"{self.temp_folder}/{file}")

    def read_files(self, file):
        files = [_ for _ in listdir(f"{self.temp_folder}/{file}") if ".xlsx" in _]
        data = pd.concat(
            [pd.read_excel(f"{self.temp_folder}/{file}/{_}", skiprows=self.sources[file].skiprows) for _ in files])
        data = data.reset_index(drop=True)

        return data

    def save_data(self, file, data):
        data.loc[:, data.dtypes == 'O'] = data.loc[:, data.dtypes == 'O'].astype(str)
        data.to_feather(f"{self.data_folder}/{file}.feather")


if __name__ == "__main__":
    downloader = PhmsaDownloader(temp_folder=temp_folder_location, data_folder=data_folder_location)
    downloader.update_data(file=update_file)
