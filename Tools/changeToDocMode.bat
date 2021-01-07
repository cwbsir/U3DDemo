
@echo off
::ÇÐ»»³ÉDoc·¢²¼Ä£Ê½
cd /D %~dp0
set csPath=%cd%\..\Assets\Script\AppConst.cs
set wrapPath=%cd%\..\Assets\Source\Generate\AppConstWrap.cs

python changeMode.py %csPath% 1 %wrapPath% 1

::pause