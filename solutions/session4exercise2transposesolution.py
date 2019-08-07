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
        # read header data of file into dataframe
        df_head = pd.read_csv(filenamefull,header=None,nrows=4)
        
        # extract column names
        # transpose dataframe
        df_head = df_head.transpose()
        # set first row as column names
        df_head.columns = df_head.iloc[0]
        # drop first row
        df_head = df_head.drop([0])
        # reset index
        df_head = df_head.reset_index(drop=True)
        
        # read body of file into dataframe
        df = pd.read_csv(filenamefull,skiprows=5)
        
        # delete units row
        df = df.drop([0])
        
        # EXTRA EXPLANATION: create stacked dataframe -- NEW
        stacked = pd.melt(df, id_vars=["sec"], var_name="Variable",value_name="Value")
        # remove nulls -- NEW
        stacked_clean = stacked[pd.to_numeric(stacked["Value"], errors='coerce').notnull()]
        
        # loop
        # create list of df_head columns
        columns = list(df_head.columns)
        # loop through columns
        for x in range(len(columns)):
            stacked_clean.insert(x, columns[x],df_head.iloc[0][columns[x]])
            
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
outfile = outpath + "\\session4output2transpose.csv"
# create ouput file
result.to_csv(outfile,index=False)