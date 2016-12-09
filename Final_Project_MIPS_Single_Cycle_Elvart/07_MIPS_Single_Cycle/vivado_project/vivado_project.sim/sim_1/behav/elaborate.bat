@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 7f234ae6bf1c490b9a949a77f49b2d8c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot mips_single_cycle_tb_behav xil_defaultlib.mips_single_cycle_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0