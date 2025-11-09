import dlt
import pandas as pd
import os

# Define separate resources for each year
@dlt.resource(name="lfs_2019")
def lfs_2019():
    yield pd.read_csv("grp6_lfs_2019.csv").astype(str)

# @dlt.resource(name="lfs_2020")
# def lfs_2020():
#     yield pd.read_csv("grp6_lfs_2020.csv").astype(str)

# @dlt.resource(name="lfs_2021")
# def lfs_2021():
#     yield pd.read_csv("grp6_lfs_2021.csv").astype(str)

# @dlt.resource(name="lfs_2023")
# def lfs_2023():
#     yield pd.read_csv("grp6_lfs_2023.csv").astype(str)


def run():
    # Initialize DLT pipeline
    p = dlt.pipeline(
        pipeline_name="lfs",
        destination="clickhouse",
        dataset_name="lfs_data",
    )

    print("Fetching and loading yearly CSVs...")

    # Run each resource (year)
    info_2019 = p.run(lfs_2019())
    print("2019 records loaded:", info_2019)

    # info_2020 = p.run(lfs_2020())
    # print("2020 records loaded:", info_2020)

    # info_2021 = p.run(lfs_2021())
    # print("2021 records loaded:", info_2021)

    # info_2023 = p.run(lfs_2023())
    # print("2023 records loaded:", info_2023)


if __name__ == "__main__":
    run()
