#!/usr/bin/env python3

import sys
from collections import namedtuple
import requests as rq
import io
from zipfile import ZipFile
from os import listdir
import pandas as pd

update_file = sys.argv[1]
temp_folder_location = "data-raw/.temp-data"


class PhmsaDownloader:
    """
    This downloader is used to download the raw data on pipelines and oil spills in the US. Run update_data after
    initializing to download data. Will overwrite existing files!
    :param temp_folder: Temporary folder which downloaded zip files get saved to.
    """

    def __init__(self, temp_folder):
        self.temp_folder = temp_folder

        source = namedtuple('source', 'address skiprows')
        self.sources = {
            'pipelines_2010': source(
                'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline/annual_hazardous_liquid_2010_present.zip',
                2)}

    def update_data(self, file):
        """
        Download up-to-date data and save to file system.
        :param file: Which file should be downloaded. Currently implemented are: "pipelines_2010".
        """
        self.download_data(file)
        temp_data = self.read_files(file)
        self.save_data(file, temp_data)

    def download_data(self, file):
        """
        Download the raw data from PHMSA and save as zip file to the temporary file location provided when the class was
        initialized.
        :param file: Which file should be downloaded. Currently implemented are: "pipelines_2010".
        """
        data_zipped = rq.get(self.sources[file].address)
        data = ZipFile(io.BytesIO(data_zipped.content))
        data.extractall(f"{self.temp_folder}/{file}")

    def read_files(self, file):
        """
        Read all .xlsx files that were downloaded into one dataframe.
        :param file: Which file should be downloaded. Currently implemented are: "pipelines_2010".
        :return: Pandas DataFrame with all downloaded data.
        """
        files = [_ for _ in listdir(f"{self.temp_folder}/{file}") if ".xlsx" in _]
        data = pd.concat(
            [pd.read_excel(f"{self.temp_folder}/{file}/{_}", skiprows=self.sources[file].skiprows) for _ in files])
        data = data.reset_index(drop=True)

        return data

    def save_data(self, file, data):
        """
        Save all downloaded data to the destination that was specified when the downloader was initiated.
        :param file: Name of the file stat was downloaded.
        :param data: The DataFrame with the downloaded data, as provided by the read_files method.
        """
        data.loc[:, data.dtypes == 'O'] = data.loc[:, data.dtypes == 'O'].astype(str)
        data.to_feather(f"{self.temp_folder}/{file}.feather")


if __name__ == "__main__":
    downloader = PhmsaDownloader(temp_folder=temp_folder_location)
    downloader.update_data(file=update_file)
