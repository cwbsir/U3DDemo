function newObject(name)
	return UnityEngine.GameObject(name);
end

function screen2LocalPos(screenPos,parentTransform)
	local result,transPos = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(parentTransform.transform, screenPos, globalManager.cameraManager.uiCamera, nil);
	return transPos;
end

function parseABContent(abContent)
	local prefabList = abContent:LoadAllAssets(typeof(UnityEngine.GameObject));
	local destList = {};
	if(prefabList == nil)then return destList; end;
	local len = prefabList.Length - 1;
	for i = 0,len,1 do
		local prefab = prefabList[i];
		destList[prefab.name] = prefab;
	end
	return destList;
end

--c#判断是否为空地址--
function isNil(cObj)
	return cObj == nil or cObj:Equals(nil);
end
--字符串分割成int数组,返回一维数组
function strSplitToInt(str,token)
	if (str == "" or str == nil) then return {}; end
	token = token or ","; 
	local ret = {};
	local strList = string.split(str,token);
	for i=1,#strList do
		local num = tonumber(strList[i]);
		table.insert(ret,num);
	end
	return ret;
end

--字符串分割成int数组,返回二维数组
function strSplitToInts(str,tokens)
	if (str == "" or str == nil) then return {}; end
	local token_first = "|";
	local token_sec = ",";
	if tokens ~= nil then 
		token_first = tokens[1];
		token_sec = tokens[2];
	end
	local ret = {};
	local listFirst = string.split(str,token_first);
	for i=1,#listFirst do
		local listSec = string.split(listFirst[i],token_sec);
		for j=1,#listSec do
			listSec[j] = tonumber(listSec[j]);
		end
		table.insert(ret,listSec);
	end
	return ret;
end

function table.getLength(t)
	local length = 0;
	for k, v in pairs(t) do
		length = length + 1;
	end
	return length;
end

--合并两个table
function table.merge(...)
    local tableList = {...};
    if #tableList <= 0 then
        return {};
    end
    local origin = {};
    for i=1,#tableList do
    	if tableList[i] ~= nil then
            for _,data in ipairs(tableList[i]) do
            	if data ~= nil then
	            	table.insert(origin,data);
            	end
            end
    	end
    end
    return origin;
end

function arrayIndexOf(table,t)
	local len = #table;
	for i = 1,len do
		if(table[i] == t)then
			return i;
		end
	end
	return -1;
end

function math.round(num, numDecimalPlaces)
    local mult = 10 ^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- 1.无参调用，产生[0, 1)之间的浮点随机数。
-- 2.一个参数n，产生[1, n]之间的整数。
-- 3.两个参数，产生[n, m]之间的整数。
-- randomCount:随机数数量,大于0的时候返回随机数列表randomNumList(要在设置随机种子之后循环n次，出来的才是n个不一样的数)
function mathRandom(n, m, randomCount)
	local randomFunc = function()
		if m ~= nil and type(m) == "number" then
			return math.random(n, m);
		elseif n ~= nil and type(n) == "number" then
			return math.random(n);
		else
			return math.random();
		end
	end
	if randomCount == nil or type(randomCount) ~= "number" or randomCount <= 0 then
		return randomFunc();
	end
	local randomNumList = {};
	for i=1,randomCount do
		table.insert(randomNumList, randomFunc())
	end
	return randomNumList;
end

function arraySplitByCount(array,count)
	if count == 1 then return {array} end;

	local ret = {};
	local len = #array;
	--每組牌的數量
	local amount = math.ceil(len/count);
	--要有多少組牌
	for i=1,count do
		local temp = {};
		for j=1,amount do
			local index = (i-1)*amount+j;
			-- print("arraySplitByCount",i,j,index,array[index]);
			if array[index] ~= nil then
				table.insert(temp,array[index]);
			end
		end
		table.insert(ret,temp);
	end
	return ret;
end

function printArray(array,preStr)
	for i=1,#array do
		print(preStr,i,array[i]);
	end
end

--把数据变成一维数组
function mergeTable(data)
	--非数组
	if type(data) ~= "table" or (type(data) == "table" and data.__cname ) ~= nil then
		return {data};
	--一维数组
	elseif #data == 0 or type(data[1]) ~= "table" then
		return data;
	else
		local ret = {};
		for i=1,#data do
			ret = table.merge(ret,mergeTable(data[i]));
		end
		return ret;
	end
end
