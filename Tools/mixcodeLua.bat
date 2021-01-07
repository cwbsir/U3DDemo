cd /D %~dp0
@echo off
set cmd=mixcodeLua.exe
set tools=%~dp0
set config=%tools%\pConfig.json
set luapath=%tools%\..\Assets\Lua
set log=out\relog.txt
::全并代码出来的文件 
set sourceLuaFile=out\sourceLuaFile.lua
::eval后的文件
set sourceLuaEvalFile=out\sourceLuaEvalFile.lua
::生成的最终文件
set targetLuaFile=%tools%..\Assets\Lua\targetLuaFile.txt

%cmd% -c %config% -s %sourceLuaFile% -e %sourceLuaEvalFile% -l %log% -t %targetLuaFile% %luapath% -p

pause