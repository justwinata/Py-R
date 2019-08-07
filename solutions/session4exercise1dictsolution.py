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
        # empty dict
        metadata = {}
        # collect data into dictionary
        for x in range(6):
            metadata[df.iloc[x,0]] = df.iloc[x,1]
        
        # convert data to float
        metadata['Amount_num'] = float(metadata['Amount'])
        metadata['Phase_num'] = float(metadata['Phase'])

        # calculations
        metadata['RealAngle'] = 360 - metadata['Phase_num']
        metadata['x_offset'] = metadata['Amount_num'] * math.cos(metadata['RealAngle']*(math.pi/180))
        metadata['y_offset'] = metadata['Amount_num'] * math.sin(metadata['RealAngle']*(math.pi/180))
        
        # insert data into DataFrame
        df  = pd.DataFrame([metadata], columns=metadata.keys())

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
df.insert(0,"EqName",eqname)
df.insert(1,"TestName",testname)

# %% output file
# set output directory -- create if non-existent
outpath = inpath + r"\output"
if not os.path.exists(outpath):
    os.makedirs(outpath)
# create full output path
outfile = outpath + r"\session4output1dict.csv"

# create ouput file
result.to_csv(outfile,index=False)