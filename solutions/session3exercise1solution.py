#%% imports -- os and pandas
import os
import pandas as pd

#%% input folder
inpath = r"C:\Users\######\Py-R\data\session3\exercise1"
#%% list of files
inpathfiles = os.listdir(inpath)

#%% metadata -- PM6 module, Lehi site
module = "PM6"
site = "Lehi"

#%% empty list to collect DataFrames
dfs = []

#%% iterate through file list, read data, and add to list
for filename in inpathfiles:
    filename = inpath + "\\" + filename
    df = pd.read_csv(filename)
    dfs.append(df)

#%% combine list of DataFrames into one DataFrame
result = pd.concat(dfs)

#%% insert metadata
result.insert(0,"Module",module)
result.insert(0,"Site",site)

#%% output folder and file path
outpath = inpath + r"\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
outfile = outpath + r"\session3output1.csv"

#%% write DataFrame to file
result.to_csv(outfile,index=False)