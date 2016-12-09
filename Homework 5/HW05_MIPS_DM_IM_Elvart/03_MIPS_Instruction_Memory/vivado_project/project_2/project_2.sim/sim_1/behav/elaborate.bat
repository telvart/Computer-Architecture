@echo off
set xv_path=E:\\Vivado\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 83dd8947be2f4bbaa53decf96b46ea36 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot im_tb_behav xil_defaultlib.im_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
