PokerHandTemplateList = class("PokerHandTemplateList",BaseTemplateList);


function PokerHandTemplateList:ctor()
 	PokerHandTemplateList.super.ctor(self);
 	self._listByCount = {};
 	self.isAllParse2 = true;

 	self.ONE_CARD_TYPE = 1;
 	self.TWO_CARD_TYPE = 2;

end

function PokerHandTemplateList:initInfo1(info)
	info.type = 0;
	info.dataPos = 0;
	info.isParsed = false;
end

function PokerHandTemplateList:initInfo2(info)
	info.limitCount = 0;
	--其他小牌的数量
	info.otherCount = 0;
	--主牌列表
	info.pokerHandList = nil;
	--可以大得过的牌型
	info.handleTypeList = nil;
	--可以压得过当前牌的牌型
	info.pressTypeList = nil;
	--可以带其他牌型的条件({牌型，这种牌型的数量})
	info.otherPokerList = nil;
	--不可以带的牌，与pokerHandList一一对应
	info.exceptPokers = nil;
	info.descript = "";
end

function PokerHandTemplateList:parseKey(info)
	info.type = self._templateData:readShort();
	info.limitCount = self._templateData:readByte();
	self._list[info.type] = info;
	if self._listByCount[info.limitCount] == nil then
		self._listByCount[info.limitCount] = {};
	end

	table.insert(self._listByCount[info.limitCount],info);
end

function PokerHandTemplateList:parseOne2(info)
	function sortFunc(type1,type2)
		local size1 = globalConst.landTemplateList:getSizeByType(type1);
		local size2 = globalConst.landTemplateList:getSizeByType(type2);
		return size1 < size2;
	end

	info.pokerHandList = strSplitToInts(self._templateData:readString());
	info.handleTypeList = strSplitToInt(self._templateData:readString(),"|");
	info.pressTypeList = strSplitToInt(self._templateData:readString(),",");
	--可以带其他牌型的条件
	info.otherPokerList = strSplitToInt(self._templateData:readString(),",");
	info.otherCount = self._templateData:readShort();
	--不能带的小牌
	info.exceptPokers = strSplitToInts(self._templateData:readString());

	info.descript = self._templateData:readString();

	PokerHandTemplateList.super.parseOne2(self,info);
end

function PokerHandTemplateList:getInfo(type)
	return self:getInfo2(self._list[type]);
end

function PokerHandTemplateList:getListByCount(count)
 	return self._listByCount[count];
end

--返回handleType和主牌型
function PokerHandTemplateList:getHandTpye(typelist)
	function sortFunc(type1,type2)
		local size1 = globalConst.landTemplateList:getSizeByType(type1);
		local size2 = globalConst.landTemplateList:getSizeByType(type2);
		return size1 < size2;
	end
	table.sort(typelist,sortFunc);
	local count = #typelist;
	local list = self:getListByCount(count);
	-- print("count",count);
	if list == nil then return -1; end

	for i=1,#list do
		local temp = list[i];
		local pokerHandList = temp.pokerHandList;
		if temp.otherCount == 0 then
			for j=1,#pokerHandList do
				local cardTypes = pokerHandList[j];
				local isSame = true;
				for k=1,count do
					if typelist[k] ~= cardTypes[k] then
						isSame = false
						break;
					end
				end
				if isSame then
					return temp.type,cardTypes;
				end
			end
		else
			for j=1,#pokerHandList do
				local cardTypes = pokerHandList[j];

				local otherCardTypes = self:containArray(typelist,cardTypes);
				-- print("当前牌型:"..content,temp.type,otherCardTypes);
				local isSame = true;
				--有小牌则是主牌满足条件
				if otherCardTypes ~= nil then
					--剩余的小牌有牌型限制
					if #temp.otherPokerList > 0 then
						local handype = temp.otherPokerList[1];
						local handypeCount = temp.otherPokerList[2];
						--把剩余的牌按照条件拆分为handypeCount组牌
						local ret = arraySplitByCount(otherCardTypes,handypeCount);
						-- print("====",handype,handypeCount,#ret);
						for k=1,#ret do
							-- local ll = ret[k];
							-- local content = "";
							-- for l=1,#ll do
							-- 	content = content .. "," .. ll[l];
							-- end
							-- print("剩下小牌:"..content);

							local curHandype = self:getHandTpye(ret[k]);
							if curHandype ~= handype then
								isSame = false;
								break;
							end
						end
					end
					if isSame then
						local exceptPokers = temp.exceptPokers;
						--与pokerHandList是一一对应的
						if #exceptPokers > 0 then
							local exceptCardTypes = exceptPokers[j];
							local otherExceptCardTypes = self:containArray(otherCardTypes,exceptCardTypes);
							--含有不能带的小牌,可以排除掉该类型
							if otherExceptCardTypes ~= nil then
								isSame = false;
							end
						end
					end
					--小牌满足条件
					if isSame then
						return temp.type,cardTypes;
					end
				end
			end
			
		end
	end
	return -1;
end

--返回其他的小牌
function PokerHandTemplateList:containArray(array1,array2)
	local array = clone(array1);
	for i=1,#array2 do
		local index = arrayIndexOf(array,array2[i]);
		if index == -1 then
			return nil;
		else
			table.remove(array,index);
		end
	end
	return array;
end

function PokerHandTemplateList:isSameHandtype(typelist1,typelist2)
	local handType1 = self:getHandTpye(typelist1);
	local handType2 = self:getHandTpye(typelist2);
	return handType1 == handType2;
end

--返回：0不是同类型无法比较 1是typelist1牌大 2是typelist2牌大
function PokerHandTemplateList:compareCards(typelist1,typelist2)
	local handType1 = self:getHandTpye(typelist1);
	local handType2 = self:getHandTpye(typelist2);
	if handType1 == handType2 then
		--同类的牌型只需要比较主牌（因为大小只有主牌决定）
		for i=1,#typelist1 do
			local size1 = globalConst.landTemplateList:getSizeByType(typelist1[i]);
			local size2 = globalConst.landTemplateList:getSizeByType(typelist2[i]);
			if size1 > size2 then
				return 1;
			elseif size1 < size2 then
				return 2;
			end
		end
	else
		local temp1 = self:getInfo(handType1);
		local handleTypeList1 = temp1.handleTypeList;
		--拥有处理其他牌型的功能
		if #handleTypeList1 > 1 then
			local index = arrayIndexOf(handleTypeList1,handType2);
			--大得过handType2的牌型
			if index ~= -1 then
				return 1;
			end
		end

		local temp2 = self:getInfo(handType2);
		local handleTypeList2 = temp2.handleTypeList;
		--拥有处理其他牌型的功能
		if #handleTypeList2 > 1 then
			local index = arrayIndexOf(handleTypeList2,handType1);
			--大得过handType1的牌型
			if index ~= -1 then
				return 2;
			end
		end

		return 0;
	end
end
