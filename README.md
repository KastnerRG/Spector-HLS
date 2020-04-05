# Spector-HLS

## Organization

The benchmarks will be organized on the basis of directories showing various
benchmarks and each of these benchmarks will be divided into two separate 
project directories (for now) mainly vivado and catapult. 

This would help compare the various HLS tools and help in better organization.

Miscellaneous consist of the csv files and notebooks present in the results, the incomplete implementation of FIR filter, few of the vivado results for the pynq board and some script files. 

## Design Spaces
The algorithms design spaces are mainly in the <tool>_<algorithm>_<<latency/area optimized>>.csv files where <<>> is optional. The design space can be observed using files such as <algorithm>_postproc.ipynb which compares between two tools and <tool>_<algorithm>_latency_vs_area.ipynb which compares two different design optimizations from the same tool. Additional resources have been parsed in the results csv files. Later, a zip file will be included having the rtl files from which these results have been parsed. 
