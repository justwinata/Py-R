# import packages -- os, pandas, and math
import os
import pandas as pd
import math

# %% Loop through folder and combine
# input path
inpath = r"C:\Users\######\Py-R\data\session4\exercise1"
# list of files
inpathfiles = os.listdir(inpath)

# empty list
dfs = []

# %% loop
for filename in inpathfiles:
    # condition/filter -- match with "ALGN"
    if "ALGN" in filename:
        # append path to filename
        filename = inpath + "\\" + filename
        # read header data of file into dataframe
        df = pd.read_csv(filename,header=None,nrows=6)
        
        # extract column names
        # transpose dataframe
        df = df.transpose()
        # set first row as column names
        df.columns = df.iloc[0]
        # drop first row
        df = df.drop([0])
        # reset index
        df = df.reset_index(drop=True)

        # calculations
        # convert Amount and Phase columns to numeric
        df['Amount_num'] = df['Amount'].astype(str).astype(float)
        df['Phase_num'] = df['Phase'].astype(str).astype(float)

        # calculate real angle and offsets
        df['RealAngle'] = 360 - df1['Phase_num']
        df['x_offset'] = df['Amount_num'] * math.cos(df1['RealAngle']*(math.pi/180))
        df['y_offset'] = df['Amount_num'] * math.sin(df1['RealAngle']*(math.pi/180))
       
        # add data to list
        dfs.append(df)

#%% combine data
result = pd.concat(dfs)

# %% Create metadata variables
# EqName: TNS
# TestName: Test
eqname = "TNS"
testname = "Test"

# insert metadata
result.insert(0,"EqName",eqname)
result.insert(1,"TestName",testname)

# %% output file
# set output directory -- create if non-existent
outpath = inpath + r"\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
# create full output path
outfile = outpath + r"\session4output1transpose.csv"
# create ouput file
result.to_csv(outfile,index=False)