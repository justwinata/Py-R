#%% imports -- os and pandas
import os
import pandas as pd

#%% input folder and list of files
inpath = r"C:\Users\######\Py-R\data\session3\exercise2"
inpathfiles = os.listdir(inpath)

#%% metadata -- PM6 module and Lehi site
module = "PM6"
site = "Lehi"

#%% empty list to collect Dataframes
dfs = []

#%% iterate through file list, read data, and add to list
for filename in inpathfiles:
    filename = inpath + "\\" + filename
    df = pd.read_csv(filename)
    dfs.append(df)
    
#%% combine list of Dataframes into one DataFrame
result = pd.concat(dfs)

#%% insert metadata
result.insert(0,"Module",module)
result.insert(0,"Site",site)

#%%%% output folder and file path
outpath = inpath + r"\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
outfile = outpath + r"\session3output2.csv"

#%% write DataFrame to file
result.to_csv(outfile,index=False)