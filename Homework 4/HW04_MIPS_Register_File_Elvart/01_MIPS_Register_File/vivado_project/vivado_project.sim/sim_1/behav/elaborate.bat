@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 9d557fd9a19f41a79e80650f98ad9766 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot regfile_tb_behav xil_defaultlib.regfile_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
