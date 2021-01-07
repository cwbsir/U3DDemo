::切换到当前bat目录
cd /d %~dp0

set path=%cd%\

::生成模板表
db.exe -c sqlTableConfig.json -o %path%ky203 -n sqlTableConfig.json -l
pause