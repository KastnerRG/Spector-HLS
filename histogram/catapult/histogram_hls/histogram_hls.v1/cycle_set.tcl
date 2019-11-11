
# Loop constraints
directive set /histogram_hls/core/core:rlp CSTEPS_FROM {{. == 1}}
directive set /histogram_hls/core/core:rlp/main CSTEPS_FROM {{. == 3} {.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit CSTEPS_FROM {{. == 2} {.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist_loop CSTEPS_FROM {{. == 11} {.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop CSTEPS_FROM {{. == 3} {.. == 2}}

# IO operation constraints

# Sync operation constraints

# Real operation constraints
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist8:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist7:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist6:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist5:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist4:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist3:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist2:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:write_mem(hist1:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#2 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#3 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#4 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#6 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#7 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist8:vinit/INIT_LOOP_HLS:acc#8 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@) CSTEPS_FROM {{.. == 8}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist1:rsc.@) CSTEPS_FROM {{.. == 9}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#1 CSTEPS_FROM {{.. == 10}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist1:rsc.@) CSTEPS_FROM {{.. == 10}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#1 CSTEPS_FROM {{.. == 7}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist2:rsc.@) CSTEPS_FROM {{.. == 8}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#3 CSTEPS_FROM {{.. == 9}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist2:rsc.@) CSTEPS_FROM {{.. == 9}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#2 CSTEPS_FROM {{.. == 6}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist3:rsc.@) CSTEPS_FROM {{.. == 7}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#5 CSTEPS_FROM {{.. == 8}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist3:rsc.@) CSTEPS_FROM {{.. == 8}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#3 CSTEPS_FROM {{.. == 5}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist4:rsc.@) CSTEPS_FROM {{.. == 6}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#7 CSTEPS_FROM {{.. == 7}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist4:rsc.@) CSTEPS_FROM {{.. == 7}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#4 CSTEPS_FROM {{.. == 4}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist5:rsc.@) CSTEPS_FROM {{.. == 5}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#9 CSTEPS_FROM {{.. == 6}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist5:rsc.@) CSTEPS_FROM {{.. == 6}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#5 CSTEPS_FROM {{.. == 3}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist6:rsc.@) CSTEPS_FROM {{.. == 4}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#11 CSTEPS_FROM {{.. == 5}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist6:rsc.@) CSTEPS_FROM {{.. == 5}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#6 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist7:rsc.@) CSTEPS_FROM {{.. == 3}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#13 CSTEPS_FROM {{.. == 4}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist7:rsc.@) CSTEPS_FROM {{.. == 4}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(data_in:rsc.@)#7 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:read_mem(hist8:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:hist_loop:acc#15 CSTEPS_FROM {{.. == 3}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:write_mem(hist8:rsc.@) CSTEPS_FROM {{.. == 3}}
directive set /histogram_hls/core/core:rlp/main/hist_loop/hist_loop:acc#8 CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist7:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist8:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#13 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/operator+=<8,false>:read_mem(hist_out:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#15 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist1:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist2:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#12 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist3:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist4:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#11 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist5:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:read_mem(hist6:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#10 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#14 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/operator+=<8,false>:operator+=<8,false>:acc#1 CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/operator+=<8,false>:write_mem(hist_out:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /histogram_hls/core/core:rlp/main/accum_loop/accum_loop:acc#9 CSTEPS_FROM {{.. == 1}}

# Probe constraints
