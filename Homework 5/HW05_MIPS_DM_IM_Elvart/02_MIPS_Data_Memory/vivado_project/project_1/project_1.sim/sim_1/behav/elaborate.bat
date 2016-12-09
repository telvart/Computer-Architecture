@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto a5a68b8ebde74facbbb18803624699d6 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot DM_tb_behav xil_defaultlib.DM_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
