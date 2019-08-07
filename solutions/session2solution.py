#%% imports -- need os, pandas, and datetime
import os
import pandas as pd
from datetime import datetime

#%% get input file
infile = r"C:\Users\######\Py-R\data\session2\session2data.csv"
#%% convert file to DataFrame
df0 = pd.read_csv(infile)

#%% metadata to insert -- tool name, current time, file name
tool = "ET101"
time = str(datetime.now())
filename = os.path.basename(infile)

#%% add Time, MyName, Time, and FileName columns
df0 = df0.assign(Tool = tool)
df0["Time"] = time
df0["MyName"] = "Justin Winata"
df0.insert(0,"FileName",filename)

#%% re-order columns
df1 = df0[["MyName","Tool","Time","FileName","DateTime",
           "Recipe","Step","Interval","Pressure","GasFlow",
           "ElectricalPower","Temperature"]]

#%% specify output path and file
outpath = os.path.dirname(infile) + r"\output"
#%% if path does not exist, create path
if not os.path.exists(outpath):
    os.makedirs(outpath)
#%% create full output path
outfile = outpath + r"\session2output.csv"

#%% convert DataFrame to file
df1.to_csv(outfile,index=False)