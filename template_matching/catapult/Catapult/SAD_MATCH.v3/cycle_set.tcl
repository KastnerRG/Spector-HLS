
# Loop constraints
directive set /SAD_MATCH/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /SAD_MATCH/core/core:rlp/main CSTEPS_FROM {{. == 1} {.. == 0}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm CSTEPS_FROM {{. == 5} {.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2 CSTEPS_FROM {{. == 1} {.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3 CSTEPS_FROM {{. == 3} {.. == 0}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4 CSTEPS_FROM {{. == 3} {.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5 CSTEPS_FROM {{. == 1} {.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6 CSTEPS_FROM {{. == 2} {.. == 0}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7 CSTEPS_FROM {{. == 1} {.. == 3}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8 CSTEPS_FROM {{. == 3} {.. == 0}}

# IO operation constraints
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_lmm:io_read(INPUT) CSTEPS_FROM {{.. == 0}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_op:io_write(OUTPUT) CSTEPS_FROM {{.. == 4}}

# Sync operation constraints

# Real operation constraints
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_lmm:acc#1 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:write_mem(row_buf:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#11 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#9 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:read_mem(win_buf:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#12 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#10 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:write_mem(win_buf:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc#6 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_3/loop_3:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_2:acc#1 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_2/loop_2:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:acc#9 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:acc#8 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:read_mem(row_buf:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:write_mem(win_buf:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:acc#4 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_4/loop_4:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc#11 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc#8 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:read_mem(win_buf:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc#10 CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:loop_6:and CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc#4 CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_6/loop_6:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_5:acc#1 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_5/loop_5:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:acc#3 CSTEPS_FROM {{.. == 3}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#11 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#12 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#9 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:read_mem(row_buf:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#13 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#10 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:write_mem(row_buf:rsc.@) CSTEPS_FROM {{.. == 2}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc#6 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_8/loop_8:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_7:acc#1 CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_7/loop_7:acc CSTEPS_FROM {{.. == 1}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:acc#4 CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:acc#2 CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_op:acc#1 CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_lmm:acc CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:acc CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_op:acc CSTEPS_FROM {{.. == 4}}
directive set /SAD_MATCH/core/core:rlp/main/loop_lmm/loop_1:loop_1:and CSTEPS_FROM {{.. == 3}}

# Probe constraints
