::切换成开发模式
cd /D %~dp0
@echo off
set csPath=%cd%\..\Assets\Script\AppConst.cs
set wrapPath=%cd%\..\Assets\Source\Generate\AppConstWrap.cs

python changeMode.py %csPath% 2 %wrapPath% 2 

::pause