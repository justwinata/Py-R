# import packages -- os and pandas
import os
import pandas as pd

# %% Loop through folder and combine
# input path
# escape sequences: \newline,\\,\',\",\a,\b,\f,\n,\N,\r,\t,\u,\U,\v,\[0-9],\x
inpath = r"C:\Users\######\Py-R\data\session4\exercise2"
# list of files
inpathfiles = os.listdir(inpath)

# empty list
dfs = []

# %% loop
for filename in inpathfiles:
    # condition/filter -- match with "WaferFlow"
    if "WaferFlow" in filename:
        # append path to filename
        filenamefull = inpath + "\\" + filename
        
        # get metadata
        df_head = pd.read_csv(filenamefull,header=None,nrows=4)
        metadata = {}
        for x in range(df_head.shape[0]):
            metadata[df_head.iloc[x,0]] = df_head.iloc[x,1]      
        
        # read body of file into dataframe
        df = pd.read_csv(filenamefull,skiprows=5)
        
        # delete units row
        df = df.drop([0])
        
        # EXTRA EXPLANATION: create stacked dataframe -- NEW
        stacked = pd.melt(df, id_vars=["sec"], var_name="Variable",value_name="Value")
        # remove nulls -- NEW
        stacked_clean = stacked[pd.to_numeric(stacked["Value"], errors='coerce').notnull()]
        
        # loop
        for key in metadata:
            stacked_clean.insert(0,key,metadata[key])
            
        # add filename
        stacked_clean.insert(0, 'FileName', filename)
        
        # add data to list
        dfs.append(stacked_clean)
#%% combine data
result = pd.concat(dfs)
# %% output file
# set output directory -- create if non-existent
outpath = inpath + "\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
# create full output path
outfile = outpath + "\\session4output2dict.csv"
# create ouput file
result.to_csv(outfile,index=False)