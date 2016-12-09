@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 3e9f6699cff542b3b249737f01a69a5d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot main_control_unit_tb_behav xil_defaultlib.main_control_unit_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
