create_project project_4 /home/siva/project_4 -part xc7vx485tffg1157-1
set_property  ip_repo_paths  /home/siva/logic_new/ip [current_project]
update_ip_catalog
add_files -norecurse {/home/siva/Siva/RA/Mentor_Graphics_10_4/Mgc_home/bin/Catapult_12/histogram_hls.v1/concat_rtl.v /home/siva/Siva/RA/Mentor_Graphics_10_4/Mgc_home/bin/Catapult_12/histogram_hls.v1/rtl.v}
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1
