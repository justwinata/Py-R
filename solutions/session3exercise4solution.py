#%% imports -- os and pandas
import os
import pandas as pd

#%% input folder and list of files
inpath = r"C:\Users\######\Py-R\data\session3\exercise3"
inpathfiles = os.listdir(inpath)

#%% metadata -- PM6 module and Lehi site
module = "PM6"
site = "Lehi"

#%% empty lists to collect DataFrames from each type
dfs_trd = []
dfs_et = []

#%% iterate through file list, read data, and add to list
for filename in inpathfiles:
    # check file name for TMP01_TRD.CSV
    if "TMP01_TRD.CSV" in filename:
        filename = inpath + "\\" + filename
        df = pd.read_csv(filename)
        dfs_trd.append(df)
    # check file name for ET101
    elif filename.startswith("ET101"):
    	filename = inpath + "\\" + filename
        df = pd.read_csv(filename)
        dfs_et.append(df)
    
#%% combine list of Dataframes into one DataFrame
result_trd = pd.concat(dfs_trd)
result_et = pd.concat(dfs_et)

#%% insert metadata
result_trd.insert(0,"Module",module)
result_trd.insert(0,"Site",site)

result_et.insert(0,"Module",module)
result_et.insert(0,"Site",site)

#%% output folder and file path
outpath = inpath + r"\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
outfile_trd = outpath + "\\session3output4_trd.csv"
outfile_et = outpath + "\\session3output4_et.csv"

#%% write DataFrame to file
result_trd.to_csv(outfile_trd,index=False)
result_et.to_csv(outfile_et,index=False)