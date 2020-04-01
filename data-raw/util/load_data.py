#!/usr/bin/env python3

import sys
import requests as rq
import io
from zipfile import ZipFile
from os import listdir
import pandas as pd
from functools import partial, reduce

update_files = sys.argv[1:]
temp_folder_location = "data-raw/.temp-data"


class PhmsaDownloader:
    """
    This downloader is used to download the raw data on pipelines and oil spills in the US. Run update_data after
    initializing to download data. Will overwrite existing files!
    :param temp_folder: Temporary folder which downloaded zip files get saved to.
    """

    def __init__(self, temp_folder):
        self.temp_folder = temp_folder

        self.parsing = {
            'pipelines_2010': {
                # This report has multiple sheets, fortunately we only need the first one.
                # Other sheets are additional information on interstate pipelines etc.
                # Format of those: one additional row for every two-state combination with a pipelines between.
                'source': 'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline'
                          '/annual_hazardous_liquid_2010_present.zip',
                'extension': '.xlsx',
                # 'multisheet' = True,
                # 'id_col' = 'REPORT_NUMBER',
                'parsing_function': partial(pd.read_excel, skiprows=2)
            },
            'incidents_2010': {
                'source': 'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline'
                          '/PHMSA_Pipeline_Safety_Flagged_Incidents.zip',
                'extension': 'hl2010toPresent.xlsx',
                'parsing_function': partial(pd.read_excel, sheet_name=1)
            },
            'pipelines_2004': {
                'source': 'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline'
                          '/annual_hazardous_liquid_2004_2009.zip',
                'extension': '.xlsx',
                'parsing_function': partial(pd.read_excel)
            },
            'incidents_2002': {
                'source': 'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline'
                          '/PHMSA_Pipeline_Safety_Flagged_Incidents.zip',
                'extension': 'hl2002to2009.xlsx',
                'parsing_function': partial(pd.read_excel, sheet_name=1)
            },
            'incidents_1986': {
                'source': 'https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/data_statistics/pipeline'
                          '/PHMSA_Pipeline_Safety_Flagged_Incidents.zip',
                'extension': 'hl1986to2001.xlsx',
                'parsing_function': partial(pd.read_excel, sheet_name=1)
            }
        }

    def download_data(self, file):
        """
        Download the raw data from PHMSA and save as zip file to the temporary file location provided when the class
        was initialized.
        :param file: Which file should be downloaded. Currently implemented are: "incidents_2004",
        "incidents_2010", "pipelines_2004" and "pipelines_2010".
        """
        data_zipped = rq.get(self.parsing[file]['source'])
        data = ZipFile(io.BytesIO(data_zipped.content))
        data.extractall(f"{self.temp_folder}/{file}")

    def read_files(self, file):
        """
        Read all files that were downloaded into one dataframe.
        :param file: Which file should be downloaded. Currently implemented are: "incidents_2004",
        "incidents_2010", "pipelines_2004" and "pipelines_2010".
        :return: Pandas DataFrame with all downloaded data.
        """
        if 'multisheet' in self.parsing[file] and self.parsing[file] is True:
            return self.read_multisheet(file=file)

        docs = [doc for doc in listdir(f"{self.temp_folder}/{file}") if self.parsing[file]['extension'] in doc]

        if len(docs) == 1:
            data = self.parsing[file]['parsing_function'](f"{self.temp_folder}/{file}/{docs[0]}")
        elif len(docs) > 1:
            data = pd.concat(
                [self.parsing[file]['parsing_function'](f"{self.temp_folder}/{file}/{doc}") for doc in docs])
            data = data.reset_index(drop=True)
        else:
            raise FileNotFoundError("No file selected.")

        return data

    def read_multisheet(self, file):
        """
        Separate parsing function for multisheet excel files.
        :param file: Which file should be downloaded. Currently implemented are: "incidents_2004",
        "incidents_2010", "pipelines_2004" and "pipelines_2010".
        :return: Pandas DataFrame with all downloaded data.
        """
        docs = [doc for doc in listdir(f"{self.temp_folder}/{file}") if self.parsing[file]['extension'] in doc]
        reports = pd.DataFrame()
        for doc in docs:
            sheets = pd.read_excel(doc,
                                   skiprows=2,
                                   sheet_name=None,
                                   comment="*****")
            sheets = list(sheets.values())
            report = reduce(lambda x, y: pd.DataFrame.join(x, y, on=self.parsing[file]['id_col'], rsuffix="_right"),
                            sheets)
            duplicate_cols = [c for c in report.columns if "_right" in c]
            report = report.drop(columns=duplicate_cols)
            reports = pd.concat([reports, report]).reset_index(drop=True)

    def save_data(self, file, data):
        """
        Save all downloaded data to the destination that was specified when the downloader was initiated.
        :param file: Name of the file that was downloaded.
        :param data: The DataFrame with the downloaded data, as provided by the read_files method.
        """
        data.loc[:, data.dtypes == 'O'] = data.loc[:, data.dtypes == 'O'].astype(str)
        data.to_feather(f"{self.temp_folder}/{file}.feather")

    def update_data(self, file):
        """
        Download up-to-date data and save to file system.
        :param file: Which file should be downloaded. Currently implemented are: "incidents_2004",
        "incidents_2010", "pipelines_2004" and "pipelines_2010
        """
        self.download_data(file=file)
        temp_data = self.read_files(file=file)
        self.save_data(file=file, data=temp_data)


if __name__ == "__main__":
    downloader = PhmsaDownloader(temp_folder=temp_folder_location)
    for file in update_files:
        if file in downloader.parsing.keys():
            downloader.update_data(file=file)
