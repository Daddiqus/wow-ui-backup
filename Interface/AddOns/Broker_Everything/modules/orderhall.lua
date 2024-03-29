
----------------------------------
-- module independent variables --
----------------------------------
local addon, ns = ...
if ns.build<70000000 then return end
local C, L, I = ns.LC.color, ns.L, ns.I


-----------------------------------------------------------
-- module own local variables and local cached functions --
-----------------------------------------------------------
local name = "Order hall" -- GARRISON_LOCATION_TOOLTIP
local ldbName,ttName,ttColumns,tt,createMenu = name, name.."TT",3;
local now = 0;
local TalentUnavailableReasons = {
	[LE_GARRISON_TALENT_AVAILABILITY_UNAVAILABLE_ANOTHER_IS_RESEARCHING] = ORDER_HALL_TALENT_UNAVAILABLE_ANOTHER_IS_RESEARCHING,
	[LE_GARRISON_TALENT_AVAILABILITY_UNAVAILABLE_NOT_ENOUGH_RESOURCES] = ORDER_HALL_TALENT_UNAVAILABLE_NOT_ENOUGH_RESOURCES,
	[LE_GARRISON_TALENT_AVAILABILITY_UNAVAILABLE_NOT_ENOUGH_GOLD] = ORDER_HALL_TALENT_UNAVAILABLE_NOT_ENOUGH_GOLD,
	[LE_GARRISON_TALENT_AVAILABILITY_UNAVAILABLE_TIER_UNAVAILABLE] = ORDER_HALL_TALENT_UNAVAILABLE_TIER_UNAVAILABLE,
};


-------------------------------------------
-- register icon names and default files --
-------------------------------------------
I[name] = {iconfile="Interface\\Icons\\inv_garrison_resource", coords={0.05,0.95,0.05,0.95}}; --IconName::Order hall--


---------------------------------------
-- module variables for registration --
---------------------------------------
ns.modules[name] = {
	desc = L["Display order hall upgrade tree and work orders from order hall and kitchen"],
	events = {},
	updateinterval = nil, -- 10
	config_defaults = {},
	config_allowed = {},
	config_header = { type="header", label=L[name], align="left", icon=I[name] },
	config_broker = nil,
	config_tooltip = {},
	config_misc = {},
	clickOptions = {
		["1_open_garrison_report"] = {
			cfg_label = "Open garrison report", -- L["Open garrison report"]
			cfg_desc = "open the garrison report",
			cfg_default = "_LEFT",
			hint = "Open garrison report",
			func = function(self,button)
				local _mod=name;
				securecall("GarrisonLandingPage_Toggle");
			end
		},
		["2_open_menu"] = {
			cfg_label = "Open option menu",
			cfg_desc = "open the option menu",
			cfg_default = "_RIGHT",
			hint = "Open option menu",
			func = function(self,button)
				local _mod=name;
				createMenu(self)
			end
		}
	}
}


--------------------------
-- some local functions --
--------------------------

function createMenu(self)
	if (tt~=nil) then ns.hideTooltip(tt); end
	ns.EasyMenu.InitializeMenu();
	ns.EasyMenu.addConfigElements(name);
	ns.EasyMenu.ShowMenu(self);
end

local function updateBroker()
	local obj = ns.LDB:GetDataObjectByName(ns.modules[name].ldbName);
	local title = {};
	tinsert(title, C("ltblue",ready) .."/".. C("orange",progress - ready) );

	obj.text = table.concat(title,", ");
end

local function createTooltip2(tt)
end

local function createTalentTooltip(self,talent)
	GameTooltip:SetOwner(tt, "ANCHOR_NONE");
	GameTooltip:SetPoint(ns.GetTipAnchor(tt,"horizontal"));

	GameTooltip:AddLine(talent.name, 1, 1, 1);
	GameTooltip:AddLine(talent.description, nil, nil, nil, true);

	if talent.isBeingResearched then
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(NORMAL_FONT_COLOR_CODE..TIME_REMAINING..FONT_COLOR_CODE_CLOSE.." "..SecondsToTime(talent.researchTimeRemaining), 1, 1, 1);
	elseif not talent.selected then
		GameTooltip:AddLine(" ");

		GameTooltip:AddLine(RESEARCH_TIME_LABEL.." "..HIGHLIGHT_FONT_COLOR_CODE..SecondsToTime(talent.researchDuration)..FONT_COLOR_CODE_CLOSE);
		if ((talent.researchCost and talent.researchCurrency) or talent.researchGoldCost) then
			local str = NORMAL_FONT_COLOR_CODE..COSTS_LABEL..FONT_COLOR_CODE_CLOSE;

			if (talent.researchCost and talent.researchCurrency) then
				local _, _, currencyTexture = GetCurrencyInfo(talent.researchCurrency);
				str = str.." "..BreakUpLargeNumbers(talent.researchCost).."|T"..currencyTexture..":0:0:2:0|t";
			end
			if (talent.researchGoldCost ~= 0) then
				str = str.." "..talent.researchGoldCost.."|TINTERFACE\\MONEYFRAME\\UI-MoneyIcons.blp:16:16:2:0:64:16:0:16:0:16|t";
			end
			GameTooltip:AddLine(str, 1, 1, 1);
		end

		if talent.talentAvailability ~= LE_GARRISON_TALENT_AVAILABILITY_AVAILABLE then
			if (talent.talentAvailability == LE_GARRISON_TALENT_AVAILABILITY_UNAVAILABLE_PLAYER_CONDITION and talent.playerConditionReason) then
				GameTooltip:AddLine(talent.playerConditionReason, 1, 0, 0);
			elseif (TalentUnavailableReasons[talent.talentAvailability]) then
				GameTooltip:AddLine(TalentUnavailableReasons[talent.talentAvailability], 1, 0, 0);
			end
		end
	end
	GameTooltip:Show();
end

local function hideTalentTooltip()
	GameTooltip:Hide();
end

local function addShipment(tt,...)
	local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString = ...;
	if name then
		tt:SetCell(tt:AddLine(),1,"  |T"..texture..":14:14:0:0:64:64:4:58:4:58|t "..C("ltyellow",name),nil,"LEFT",0);
		if shipmentCapacity>0 then
			local delim,line,remain = C("gray"," \| "),{},(creationTime+duration)-now;
			tinsert(line,C("green",shipmentsReady).."/"..C("yellow",shipmentsTotal));
			if remain>0 then
				tinsert(line,SecondsToTime((creationTime+duration)-now));
				local nextShipments = shipmentsTotal-shipmentsReady-1;
				if nextShipments>0 then
					tinsert(line,SecondsToTime((creationTime+(duration+(nextShipments*duration)))-now));
				end
			else
				tinsert(line,"("..L["Completed"]..")");
				delim = " ";
			end
			tt:SetCell(tt:AddLine(),1,table.concat(line,delim),nil,"CENTER",0);
		end
	end
end

local function createTooltip(tt)
	if (tt) and (tt.key) and (tt.key~=ttName) then return end -- don't override other LibQTip tooltips...

	if tt.lines~=nil then tt:Clear(); end
	tt:AddHeader(C("dkyellow",L[name]));

	tt:AddSeparator(4,0,0,0,0);

	local ohLevel = C_Garrison.GetGarrisonInfo(LE_GARRISON_TYPE_7_0) or 0;
	if ohLevel>0 then
		now = time();

		-- create order hall talent tree
		local garrTalentTreeID = 0
		local treeIDs = C_Garrison.GetTalentTreeIDsByClassID(LE_GARRISON_TYPE_7_0, select(3, UnitClass("player")));
		if (treeIDs and #treeIDs > 0) then
			garrTalentTreeID = treeIDs[1];
		end
		local _, _, tree = C_Garrison.GetTalentTreeInfoForID(garrTalentTreeID);
		if tree and #tree>0 then
			local t,l={},tt:AddLine(C("ltblue",ORDER_HALL_TALENT_TITLE));
			tt:AddSeparator();
			local tiers = {};
			for i,v in ipairs(tree)do
				if tiers[v.tier]==nil then
					tiers[v.tier] = 0;
					tt:AddLine("","|","");
				end
				tiers[v.tier] = tiers[v.tier]+1;
			end
			tt:AddLine();

			local activeResearch = false;

			for i,v in ipairs(tree)do
				if v.researchStartTime>0 then
					activeResearch = v;
				end

				local line,cell,align = l+v.tier+2,1,"RIGHT";
				if tiers[v.tier]==2 then
					if v.uiOrder==1 then
						cell,align = 3,"LEFT";
					end
					tt:SetCell(line,cell,C( (v.researched and "green") or (activeResearch and activeResearch.name==v.name and "dkyellow") or "gray",v.name),nil,align);
					if cell==3 and activeResearch then
						activeResearch.show=true;
					end
				else
					tt:SetCell(line,1,C(v.researched and "green" or "gray",v.name),nil,"CENTER",0);
					if activeResearch then
						activeResearch.show=true;
					end
				end

				tt:SetCellScript(line,cell,"OnEnter",createTalentTooltip, v);
				tt:SetCellScript(line,cell,"OnLeave",hideTalentTooltip);
			end

			if activeResearch and activeResearch.show then
				tt:AddSeparator(2,1,1,1,1);
				local l=tt:AddLine();
				local line = C("ltyellow",activeResearch.name..":");
				if activeResearch.researchTimeRemaining>0 then
					line = line .." ("..SecondsToTime(activeResearch.researchTimeRemaining)..")";
				end
				tt:SetCell(l,1,line,nil,"CENTER",0);
				tt:SetLineColor(l,1,1,1,.3);
				activeResearch=false;
			end
		end

		-- create shipment list
		tt:AddSeparator(4,0,0,0,0);
		tt:AddLine(C("ltblue",L["Shipments"]));
		tt:AddSeparator();
		local buildings = C_Garrison.GetBuildings(LE_GARRISON_TYPE_7_0);
		local followerShipments = C_Garrison.GetFollowerShipments(LE_GARRISON_TYPE_7_0);
		local looseShipments = C_Garrison.GetLooseShipments(LE_GARRISON_TYPE_7_0);
		if (#looseShipments+#followerShipments+#buildings)>0 then
			if #buildings>0 then
				tt:AddLine(C("gray","Buildings"));
				for i = 1, #buildings do
					if buildings[i].buildingID then
						addShipment(tt,C_Garrison.GetLandingPageShipmentInfo(buildings[i].buildingID));
					end
				end
			end
			if #followerShipments>0 then
				tt:AddLine(C("gray","Troops"));
				for i = 1, #followerShipments do
					addShipment(tt,C_Garrison.GetLandingPageShipmentInfoByContainerID(followerShipments[i]));
				end
			end
			if #looseShipments>0 then
				tt:AddLine(C("gray","Misc"));
				for i = 1, #looseShipments do
					addShipment(tt,C_Garrison.GetLandingPageShipmentInfoByContainerID(looseShipments[i]));
				end
			end
		else
			tt:SetCell(tt:AddLine(),1,C("gray",L["No active shipments found..."]),nil,"CENTER",0);
		end
	else
		tt:AddLine(L["You have not unlocked your order hall"]);
	end

	if (ns.profile.GeneralOptions.showHints) then
		tt:AddSeparator(4,0,0,0,0);
		ns.clickOptions.ttAddHints(tt,name);
	end
	ns.roundupTooltip(tt);
end


------------------------------------
-- module (BE internal) functions --
------------------------------------
ns.modules[name].init = function()
	ldbName = (ns.profile.GeneralOptions.usePrefix and "BE.." or "")..name;
end

ns.modules[name].onevent = function(self,event,...)
	if (event=="BE_UPDATE_CLICKOPTIONS") then
		ns.clickOptions.update(ns.modules[name],ns.profile[name]);
	end
end

-- ns.modules[name].optionspanel = function(panel) end
-- ns.modules[name].onmousewheel = function(self,direction) end
-- ns.modules[name].ontooltip = function(self) end


-------------------------------------------
-- module functions for LDB registration --
-------------------------------------------
ns.modules[name].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt = ns.acquireTooltip({ttName,ttColumns, "LEFT","LEFT", "CENTER", "CENTER", "CENTER", "RIGHT","RIGHT"},{false},{self});
	createTooltip(tt);
end

-- ns.modules[name].onleave = function(self) end
-- ns.modules[name].onclick = function(self,button) end
-- ns.modules[name].ondblclick = function(self,button) end

