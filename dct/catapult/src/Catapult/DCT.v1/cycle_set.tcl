
# Loop constraints
directive set /DCT/core/core:rlp CSTEPS_FROM {{. == 0}}
directive set /DCT/core/core:rlp/main CSTEPS_FROM {{. == 1} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_lmm CSTEPS_FROM {{. == 2} {.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1 CSTEPS_FROM {{. == 1} {.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2 CSTEPS_FROM {{. == 1} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3 CSTEPS_FROM {{. == 1} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4 CSTEPS_FROM {{. == 2} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5 CSTEPS_FROM {{. == 2} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6 CSTEPS_FROM {{. == 3} {.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_7 CSTEPS_FROM {{. == 2} {.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9 CSTEPS_FROM {{. == 1} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10 CSTEPS_FROM {{. == 2} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11 CSTEPS_FROM {{. == 2} {.. == 0}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12 CSTEPS_FROM {{. == 3} {.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_13 CSTEPS_FROM {{. == 2} {.. == 2}}
directive set /DCT/core/core:rlp/main/loop_out CSTEPS_FROM {{. == 3} {.. == 1}}

# IO operation constraints
directive set /DCT/core/core:rlp/main/loop_lmm/loop_lmm:io_read(src) CSTEPS_FROM {{.. == 0}}
directive set /DCT/core/core:rlp/main/loop_out/loop_out:io_write(dst) CSTEPS_FROM {{.. == 2}}

# Sync operation constraints

# Real operation constraints
directive set /DCT/core/core:rlp/main/loop_lmm/loop_lmm:write_mem(msrc.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_lmm/loop_lmm:acc#1 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#12 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#13 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#14 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#15 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#16 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#17 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#18 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:and#19 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#8 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:read_mem(msrc.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mul#1 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:acc#9 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#9 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mul#4 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mul#2 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:acc#10 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/operator*<40,16,true,AC_TRN,AC_WRAP>:mul CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:loop_6:acc#1 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#1 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#3 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#4 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#5 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#6 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:mux#7 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_6/loop_6:acc#7 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_5/loop_5:acc#1 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_4:mul#1 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_4:write_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_7/loop_7:loop_7:mux CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_7/loop_7:write_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_4/loop_7/loop_7:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_3/loop_3:acc#2 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#12 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#13 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#14 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#15 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#16 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#17 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#18 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:and#19 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#8 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:read_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mul#2 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:acc#10 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#9 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mul#5 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mul#3 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:acc#12 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/operator*<40,16,true,AC_TRN,AC_WRAP>#1:mul CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:loop_12:acc#1 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#1 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#2 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#3 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#4 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#5 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#6 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:mux#7 CSTEPS_FROM {{.. == 3}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_12/loop_12:acc#7 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_11/loop_11:acc#1 CSTEPS_FROM {{.. == 2}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_10:mul#1 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_10:write_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_13/loop_13:loop_13:mux CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_13/loop_13:write_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_10/loop_13/loop_13:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_9/loop_9:acc#2 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_2/loop_2:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_1/loop_1:acc#5 CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_out/loop_out:read_mem(mdst.data:rsc.@) CSTEPS_FROM {{.. == 1}}
directive set /DCT/core/core:rlp/main/loop_out/loop_out:acc#1 CSTEPS_FROM {{.. == 1}}

# Probe constraints
