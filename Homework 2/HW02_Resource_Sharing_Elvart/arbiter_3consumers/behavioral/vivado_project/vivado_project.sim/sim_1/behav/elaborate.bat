@echo off
set xv_path=E:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto cf94b2b7fff3436ca4fc66eb6626caa3 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot arbiter_behav_3consumers_tb_behav xil_defaultlib.arbiter_behav_3consumers_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
