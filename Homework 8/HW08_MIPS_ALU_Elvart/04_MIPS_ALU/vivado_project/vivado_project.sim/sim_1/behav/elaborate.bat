@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto fab0d723bce3434880c59d6854a45cee -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot alu_tb_behav xil_defaultlib.alu_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
