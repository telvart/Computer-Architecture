@echo off
set xv_path=E:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 714b30add5774cd0938a6583c695b7da -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot arbiter_struct_3consumers_tb_behav xil_defaultlib.arbiter_struct_3consumers_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
