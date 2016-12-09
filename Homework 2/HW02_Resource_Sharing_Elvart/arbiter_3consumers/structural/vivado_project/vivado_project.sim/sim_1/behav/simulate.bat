@echo off
set xv_path=E:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim arbiter_struct_3consumers_tb_behav -key {Behavioral:sim_1:Functional:arbiter_struct_3consumers_tb} -tclbatch arbiter_struct_3consumers_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
