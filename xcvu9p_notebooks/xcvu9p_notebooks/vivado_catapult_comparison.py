import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
# read the catapult and vivado csv files first and then 
# process data and make comparisons

catHistdf = pd.read_csv("./catapult_histogram.csv", index_col=0)
vivHistdf = pd.read_csv("./final_result_impl_histogram.csv", index_col=0)
# get common columns 
cmn_col = np.intersect1d(catHistdf.columns, vivHistdf.columns)
print("common columns: ", cmn_col)
catHistdf1 = catHistdf[cmn_col]
vivHistdf1 = vivHistdf[cmn_col]

s1 = pd.merge(catHistdf1, vivHistdf1, how='inner', on=['knob_HIST_SIZE', 'knob_NUM_HIST'])

print(s1)
