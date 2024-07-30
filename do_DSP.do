vlib work
vlog -f file_DSP.txt
vsim -voptargs=+acc work.DSP48A1_TB
add wave -position insertpoint sim:/DSP48A1_TB/*
add wave -position insertpoint  \
sim:/DSP48A1_TB/DUV/Z_OUT \
sim:/DSP48A1_TB/DUV/X_OUT \
sim:/DSP48A1_TB/DUV/P_IN \
sim:/DSP48A1_TB/DUV/OPMODE_OUT \
sim:/DSP48A1_TB/DUV/opmode5_out \
sim:/DSP48A1_TB/DUV/Multiplier_OUT \
sim:/DSP48A1_TB/DUV/B1_IN \
sim:/DSP48A1_TB/DUV/Add_sub_OUT \
sim:/DSP48A1_TB/DUV/A1_OUT \
sim:/DSP48A1_TB/DUV/D_OUT \
sim:/DSP48A1_TB/DUV/B0_OUT
run -all