@echo off
::切换到当前bat目录
cd /d %~dp0
set py=LuaRequires.exe
set tools=%cd%
set assets=%tools%\..\Assets\Lua
set lua=%assets%
set tar=%lua%\ImportClient.lua
set config=%tools%\pConfig.json
set formater="require ""%%s"""


%py% -s %assets% -t %tar% -c %config% -f %formater% %lua% -e

::pause