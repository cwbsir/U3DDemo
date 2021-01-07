@echo off
call basePath.bat
set py=Psd2UI
set t_path=PSDOutput/

echo python %py% %%s -o %t_path%
echo python %py% PSDfiles -o %t_path% -s -vcd /d %~dp0

%py% %s_psd% -o %t_path% -s -v
echo ---------------------------------------------

pause