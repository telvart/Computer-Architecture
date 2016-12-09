@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xsim mips_single_cycle_tb_behav -key {Behavioral:sim_1:Functional:mips_single_cycle_tb} -tclbatch mips_single_cycle_tb.tcl -view C:/Users/Tim/Google Drive/EECS_645/HW10_MIPS_Single_Cycle_Solution/06_MIPS_Single_Cycle/simulation_sources/mips_single_cycle_wave.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
