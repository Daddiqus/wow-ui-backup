
--[[
	Little description to this 3 in 1 module.
	it register 4 modules. the first (name0) is only for shared configuration.
]]

----------------------------------
-- module independent variables --
----------------------------------
local addon, ns = ...
local C, L, I = ns.LC.color, ns.L, ns.I
local _

-----------------------------------------------------------
-- module own local variables and local cached functions --
-----------------------------------------------------------
local name0 = "GPS / Location / ZoneText"; L[name0] = ("%s / %s / %s"):format(L["GPS"],L["Location"],L["ZoneText"]);
local name1 = "GPS"; -- L["GPS"]
local name2 = "Location"; -- L["Location"]
local name3 = "ZoneText"; -- L["ZoneText"]
local ttName1, ttName2, ttName3, ttName4 = name1.."TT", name2.."TT", name3.."TT", "TransportMenuTT";
local ttColumns,ttColumns4,onleave,createTooltip2,createMenu = 3,5;
local tt1, tt2, tt3, tt4, items;
local tt5positions = {
	["LEFT"]   = {edgeSelf = "RIGHT",  edgeParent = "LEFT",   x = -2, y =  0},
	["RIGHT"]  = {edgeSelf = "LEFT",   edgeParent = "RIGHT",  x =  2, y =  0},
}
local iStr16,iStr32 = "|T%s:16:16:0:0|t","|T%s:32:32:0:0|t";
local gpsLoc = {zone=" ",color="white",pvp="contested",pos=""}
local zoneDisplayValues = {
	["1"] = ZONE,
	["2"] = L["Subzone"],
	["3"] = ZONE..": "..L["Subzone"],
	["4"] = ("%s (%s)"):format(ZONE,L["Subzone"]),
	["5"] = ("%s (%s)"):format(L["Subzone"],ZONE),
}
local foundItems, foundToys, teleports, portals, spells = {},{},{},{},{};
local _classSpecialSpellIds,_teleportIds,_portalIds,_itemIds,_itemReplacementIds,_itemMustBeEquipped,_itemFactions = {},{},{},{},{},{},{};
local sharedClickOptions = {
	["1_open_world_map"] = {
		cfg_label = "Open world map",
		cfg_desc = "open the world map",
		cfg_default = "_LEFT",
		hint = "Open World map",
		func = function(self,button)
			local _mod=name;
			securecall("ToggleFrame",WorldMapFrame)
		end
	},
	["2_open_transport_menu"] = {
		cfg_label = "Open transport menu",
		cfg_desc = "open the transport menu",
		cfg_default = "_RIGHT",
		hint = "Open transport menu",
		func = function(self,button)
			local _mod=name;
			if InCombatLockdown() then return; end
			createTooltip2(self);
		end
	},
	["3_open_menu"] = {
		cfg_label = "Open option menu",
		cfg_desc = "open the option menu",
		cfg_default = "__NONE",
		hint = "Open option menu",
		func = function(self,button)
			local _mod=name;
			createMenu(self)
		end
	}
}

-- ------------------------------------- --
-- register icon names and default files --
-- ------------------------------------- --
I[name1] = {iconfile="Interface\\Addons\\"..addon.."\\media\\gps"}		--IconName::GPS--
I[name2] = {iconfile="Interface\\Addons\\"..addon.."\\media\\gps"}		--IconName::Location--
I[name3] = {iconfile=134269,coords={0.05,0.95,0.05,0.95}}				--IconName::ZoneText--


---------------------------------------
-- module variables for registration --
---------------------------------------
ns.modules[name0] = {
	noBroker = true,
	desc = L["Some shared options for the modules GPS, Location and ZoneText"],
	events = {
		"PLAYER_ENTERING_WORLD"
	},
	updateinterval = 0.12,
	config_defaults = {
		precision = 0,
		coordsFormat = "%s, %s",
		shortMenu = false
	},
	config_allowed = {
		coordsFormat = {
			["%s, %s"] = true,
			["%s / %s"] = true,
			["%s/%s"] = true,
			["%s | %s"] = true,
			["%s||%s"] = true
		}
	},
	config_header = {type="header", label=L[name0], align="left", icon=I[name1]},
	config_broker = false, -- do not use minimap button option
	config_tooltip = nil,
	config_misc = {
		{ type="toggle", name="shortMenu", label=L["Short transport menu"], tooltip=L["Display the transport menu without names of spells and items behind the icons."]},
		{ type="select",
			name	= "coordsFormat",
			label	= L["Coordination format"],
			tooltip	= L["How would you like to view coordinations."],
			values	= {
				["%s, %s"]     = "10.3, 25.4",
				["%s / %s"]    = "10.3 / 25.4",
				["%s/%s"]      = "10.3/25.4",
				["%s | %s"]    = "10.3 | 25.4",
				["%s||%s"]     = "10.3||25.4"
			},
			default = "%s, %s",
		},
		{ type="slider",
			name		= "precision",
			label		= L["Precision"],
			tooltip		= L["Change how much digits display after the dot."],
			min			= 0,
			max			= 3,
			default		= 0,
			format		= "%d"
		}
	},
}

ns.modules[name1] = {
	desc = L["Broker to show the name of the current zone and the coordinates"],
	events = {},
	updateinterval = nil,
	config_defaults = {
		bothZones = "2"
	},
	config_prepend = name0,
	config_header = {type="header", label=L[name1], align="left", icon=I[name1]},
	config_broker = {
		"minimapButton",
		{ type="select", name="bothZones", label=L["Display zone names"], tooltip=L["Display in broker zone and subzone if exists or one of it."], default="2", values=zoneDisplayValues }
	},
	config_tooltip = nil,
	config_misc = nil,
	clickOptions = sharedClickOptions
}

ns.modules[name2] = {
	desc = L["Broker to show your current coordinates"],
	enabled = false,
	events = {},
	updateinterval = nil,
	config_defaults = {},
	config_prepend = name0,
	config_header = {type="header", label=L[name2], align="left", icon=I[name2]},
	config_broker = nil,
	config_tooltip = nil,
	config_misc = nil,
	clickOptions = sharedClickOptions
}

ns.modules[name3] = {
	desc = L["Broker to show the name of the current zone"],
	enabled = false,
	events = {},
	updateinterval = nil,
	config_defaults = {
		bothZones = "2"
	},
	config_prepend = name0,
	config_header = {type="header", label=L[name3], align="left", icon=I[name3]},
	config_broker = {
		"minimapButton",
		{ type="select", name="bothZones", label=L["Display zone names"], tooltip=L["Display in broker zone and subzone if exists or one of it."], default="2", values=zoneDisplayValues }
	},
	config_tooltip = nil,
	config_misc = nil,
	clickOptions = sharedClickOptions
}


--------------------------
-- some local functions --
--------------------------
local function initData()
	_classSpecialSpellIds = {50977,18960,556,126892,147420,193753};
	_teleportIds = {3561,3562,3563,3565,3566,3567,32271,32272,33690,35715,49358,49359,53140,88342,88344,120145,132621,132627,176248,176242,193759,224869};
	_portalIds = {10059,11416,11417,11418,11419,11420,32266,32267,33691,35717,49360,49361,53142,88345,88346,120146,132620,132626,176246,176244,224871};
	_itemIds = {18984,18986,21711,22589,22630,22631,22632,24335,29796,30542,30544,32757,33637,33774,34420,35230,36747,37863,38685,40585,40586,43824,44934,44935,45688,45689,45690,45691,45705,46874,48933,48954,48955,48956,48957,51557,51558,51559,51560,52251,52576,58487,58964,60273,60374,60407,60498,61379,63206,63207,63352,63353,63378,63379,64457,65274,65360,66061,68808,68809,82470,87215,87548,91850,91860,91861,91862,91863,91864,91865,91866,92056,92057,92058,92430,92431,92432,95050,95051,95567,95568,103678,104110,104113,107441,110560,112059,116413,117389,118662,118663,118907,118908,119183,128353,128502,128503,129276,132119,132120,132122,132517,133755,134058,136849,138448,139541,139590,139599,140192,140319,140493,141013,141014,141015,141016,141017,141605};
	_itemReplacementIds = {64488,28585,6948,44315,44314,37118,142542};
	_itemMustBeEquipped = {[32757]=1,[40585]=1};
end

function createMenu(self,nameX)
	if (tt1~=nil) then tt1=ns.hideTooltip(tt1); end
	if (tt2~=nil) then tt2=ns.hideTooltip(tt2); end
	if (tt3~=nil) then tt3=ns.hideTooltip(tt3); end
	if (tt4~=nil) then tt4=ns.hideTooltip(tt4); end
	ns.EasyMenu.InitializeMenu();
	ns.EasyMenu.addConfigElements(name0);
	if (nameX) then
		ns.EasyMenu.addConfigElements(nameX,true);
	end
	ns.EasyMenu.ShowMenu(self);
end

local function setSpell(tb,id)
	if IsSpellKnown(id) then
		local sName, _, icon, _, _, _, _, _, _ = GetSpellInfo(id);
		table.insert(tb,{id=id,icon=icon,name=sName,name2=sName});
	end
end

local function updateSpells()
	wipe(teleports); wipe(portals); wipe(spells);
	if (ns.player.class=="MAGE") then
		for i=1, #_teleportIds do setSpell(teleports,_teleportIds[i]) end
		for i=1, #_portalIds do setSpell(portals,_portalIds[i]) end
	end
	for i=1, #_classSpecialSpellIds do setSpell(spells,_classSpecialSpellIds[i]) end
end

local function addItem(id,loc)
	local toyName,toyIcon,_;
	if PlayerHasToy(id) then
		_, toyName, toyIcon = C_ToyBox.GetToyInfo(id);
	end
	if toyName and toyIcon then
		if C_ToyBox.IsToyUsable(id) then
			table.insert(foundToys,{id=id,icon=toyIcon,name=toyName,name2=loc~=nil and toyName..loc or nil});
		end
	elseif items[id] and items[id][1] then
		local v=items[id][1];
		if type(v)=="table" and v.name then
			table.insert(foundItems,{id=id,icon=v.icon,name=v.name,name2=v.name,mustBeEquipped=_itemMustBeEquipped[id]==1,equipped=v.type=="inventory"});
		end
	end
end

local function updateItems()
	wipe(foundItems); wipe(foundToys);
	items = ns.items.GetItemlist();
	for i=1, #_itemIds do
		addItem(_itemIds[i]);
	end
	local loc = " "..C("ltblue","("..GetBindLocation()..")");
	for i=1, #_itemReplacementIds do
		addItem(_itemReplacementIds[i],loc);
	end
	items = nil;
end

local function position()
	local p, f, pf = ns.profile[name0].precision or 0, ns.profile[name0].coordsFormat or "%s, %s";
	local x, y = GetPlayerMapPosition("player");
	if not x or (x==0 and y==0) then
		local pX = p==0 and "?" or "?."..strrep("?",p);
		return f:format(pX,pX);
	else
		return f:format("%."..p.."f","%."..p.."f"):format(x*100, y*100);
	end
end

local function zone(byName)
	local subZone = GetSubZoneText() or "";
	local zone = GetRealZoneText() or "";
	local types = {"%s: %s","%s (%s)"};
	local mode = "2";

	if ns.profile[byName]==nil then
		ns.profile[byName]={};
	end
	if ns.profile[byName].bothZones==nil then
		ns.profile[byName].bothZones = mode;
	else
		mode = ns.profile[byName].bothZones;
	end

	if mode=="2" and subZone~="" then
		return subZone
	elseif mode=="3" and subZone~="" then
		return subZone and types[1]:format(zone,subZone or "")
	elseif mode=="4" and subZone~="" then
		return subZone and types[2]:format(zone,subZone)
	elseif mode=="5" and subZone~="" then
		return subZone and types[2]:format(subZone,zone)
	end

	return zone
end

local function zoneColor()
	local p, _, f = GetZonePVPInfo()
	local color = "white"

	if p == "combat" or p == "arena" or p == "hostile" then
		color = "red"
	elseif p == "contested" or p == nil then
		color = "dkyellow"
		p = "contested"
	elseif p == "friendly" then
		color = "ltgreen"
	elseif p == "sanctuary" then
		color = "ltblue"
	end
	return p, color
end

-- shared tooltip for modules Location, GPS and ZoneText
local function createTooltip(tt,ttName,modName)
	if (tt) and (tt.key) and (tt.key~=ttName) then return end -- don't override other LibQTip tooltips...

	local pvp, color = zoneColor()
	local line, column
	pvp = gsub(pvp,"^%l", string.upper)

	if buttonFrame then buttonFrame:ClearAllPoints() buttonFrame:Hide() end

	if tt.lines~=nil then tt:Clear(); end

	tt:AddHeader(C("dkyellow",L[modName]))

	tt:AddSeparator()

	local lst = {
		{C("ltyellow",ZONE .. ":"),GetRealZoneText()},
		{C("ltyellow",L["Subzone"] .. ":"),GetSubZoneText()},
		{C("ltyellow",L["Zone status"] .. ":"),C(color,L[pvp])},
		{C("ltyellow",L["Coordinates"] .. ":"),position() or C(gpsLoc.posColor or gpsLoc.color,gpsLoc.pos)}
	}

	for _, d in pairs(lst) do
		line, column = tt:AddLine()
		tt:SetCell(line,1,d[1],nil,nil,2)
		tt:SetCell(line,3,d[2],nil,nil,1)
	end

	if gpsLoc.posColor then
		line,column = tt:AddLine()
		tt:SetCell(line,1,C(gpsLoc.posColor,gpsLoc.posInfo),nil,"CENTER",3)
	end

	tt:AddSeparator()

	line, column = tt:AddLine()
	tt:SetCell(line,1,C("ltyellow",L["Inn"]..":"),nil,nil,1)
	tt:SetCell(line,2,GetBindLocation(),nil,nil,2)

	if ns.profile.GeneralOptions.showHints then
		tt:AddSeparator(4,0,0,0,0)
		ns.clickOptions.ttAddHints(tt,modName);
	end
	ns.roundupTooltip(tt);
end

local function createTooltip3(_,data)
	if not (data.tooltip and data.tooltip.parent and data.tooltip.parent:IsShown()) then return end
	GameTooltip:SetOwner(data.tooltip.parent,"ANCHOR_NONE");
	GameTooltip:SetPoint(ns.GetTipAnchor(data.tooltip.parent,"horizontal"));
	GameTooltip:SetHyperlink(data.tooltip.type..":"..data.tooltip.id);
	GameTooltip:Show();
end

local function hideTooltip3()
	GameTooltip:Hide();
end

-- tooltip as transport menu
local function tpmOnEnter(self,info)
	local parent, v, t = unpack(info);
	local data = {
		attributes={type=t,[t]=v.name},
		tooltip={parent=tt4,type=t,id=v.id},
		OnEnter=createTooltip3,
		OnLeave=hideTooltip3
	};
	ns.secureButton(self,data);
end

local function tpmAddObject(tt,p,l,c,v,t)
	if ns.profile[name0].shortMenu then
		if c<ttColumns4 and l~=nil then
			c=c+1;
		else
			c=1;
			l=tt:AddLine();
		end
		tt:SetCell(l, c, iStr32:format(v.icon), nil, nil, 1);
		tt:SetCellScript(l,c,"OnEnter",tpmOnEnter, {p,v,t});
		return l,c;
	else
		local info,doUpdate = "";
		if v.mustBeEquipped==true and v.equipped==false then
			info = " "..C("orange","(click to equip)");
			doUpdate=true
		end
		l = tt:AddLine(iStr16:format(v.icon)..(v.name2 or v.name)..info, "1","2","3");
		tt:SetLineScript(l,"OnEnter",tpmOnEnter,{p,v,t});
	end
end

function createTooltip2(self)
	if InCombatLockdown() then return; end
	if (tt1~=nil) then tt1=ns.hideTooltip(tt1); end
	if (tt2~=nil) then tt2=ns.hideTooltip(tt2); end
	if (tt3~=nil) then tt3=ns.hideTooltip(tt3); end

	updateItems();
	updateSpells();

	local columns = 5;
	ttColumns4 = ns.profile[name0].shortMenu and columns or 1;
	tt4 = ns.acquireTooltip({ttName4, ttColumns4, "LEFT","LEFT","LEFT","LEFT","LEFT"},{false},{self});

	local pts,ipts,tls,itls = {},{},{},{}
	local line, column,cellcount = nil,nil,5

	tt4:Clear()

	-- title
	if not ns.profile[name0].shortMenu then
		tt4:AddHeader(C("dkyellow","Choose your transport"))
	end

	local counter = 0
	local l,c=nil,ttColumns4;

	if #teleports>0 or #portals>0 or #spells>0 then
		-- class title
		if not ns.profile[name0].shortMenu then
			tt4:AddSeparator(4,0,0,0,0)
			tt4:AddLine(C("ltyellow",ns.player.classLocale))
			tt4:AddSeparator()
		end
		-- class spells
		local t = "spell";
		if ns.player.class=="MAGE" then
			for i,v in ns.pairsByKeys(teleports) do
				l,c = tpmAddObject(tt4,self,l,c,v,t);
				counter = counter+1;
			end
			if not ns.profile[name0].shortMenu then
				tt4:AddSeparator()
			end
			for i,v in ns.pairsByKeys(portals) do
				l,c = tpmAddObject(tt4,self,l,c,v,t);
				counter = counter+1;
			end
		else
			for i,v in ns.pairsByKeys(spells) do
				l,c = tpmAddObject(tt4,self,l,c,v,t);
				counter = counter+1;
			end
		end
	end

	local t = "item";
	if #foundItems>0 then
		-- item title
		if not ns.profile[name0].shortMenu then
			tt4:AddSeparator(4,0,0,0,0);
			tt4:AddLine(C("ltyellow",ITEMS));
			tt4:AddSeparator();
		end
		-- items
		for i,v in ns.pairsByKeys(foundItems) do
			l,c = tpmAddObject(tt4,self,l,c,v,t);
			counter = counter + 1
		end
	end

	if #foundToys>0 then
		-- toy title
		if not ns.profile[name0].shortMenu then
			tt4:AddSeparator(4,0,0,0,0);
			tt4:AddLine(C("ltyellow",TOY_BOX));
			tt4:AddSeparator();
		end
		-- toys
		for i,v in ns.pairsByKeys(foundToys) do
			l,c = tpmAddObject(tt4,self,l,c,v,t);
			counter = counter + 1;
		end
	end

	if counter==0 then
		tt4:AddSeparator(4,0,0,0,0)
		tt4:AddHeader(C("ltred",L["Sorry"].."!"))
		tt4:AddSeparator(1,1,.4,.4,1)
		tt4:AddLine(C("ltred",L["No spells, items or toys found"].."."))
	end
	ns.roundupTooltip(tt4);
end

local function updater()
	if not (ns.profile[name1].enabled or ns.profile[name2].enabled or ns.profile[name3].enabled) then return end
	gpsLoc.zone1 = zone(name1)
	gpsLoc.zone3 = zone(name3)
	gpsLoc.pvp, gpsLoc.color = zoneColor()
	local pos = position()
	if pos then
		gpsLoc.pos = pos
		gpsLoc.posColor = nil
		gpsLoc.posInfo = nil
	else
		if gpsLoc.posLast==nil then
			gpsLoc.posLast=time()
		elseif time()-gpsLoc.posLast>5 then
			gpsLoc.posColor = "orange"
			gpsLoc.posInfo = L["Coordinates indeterminable"]
		end
	end

	if ns.profile[name1].enabled then
		ns.LDB:GetDataObjectByName(ns.modules[name1].ldbName).text = C(gpsLoc.color,gpsLoc.zone1.." (")..C(gpsLoc.posColor or gpsLoc.color,gpsLoc.pos)..C(gpsLoc.color,")");
	end

	if ns.profile[name2].enabled then
		ns.LDB:GetDataObjectByName(ns.modules[name2].ldbName).text = C(gpsLoc.posColor or gpsLoc.color,gpsLoc.pos);
	end

	if ns.profile[name3].enabled then
		ns.LDB:GetDataObjectByName(ns.modules[name3].ldbName).text = C(gpsLoc.color,gpsLoc.zone3);
	end
end


------------------------------------
-- module (BE internal) functions --
------------------------------------
-- ns.modules[name0].init = function(self) end

ns.modules[name1].init = function(self)
	if initData then
		initData();
		initData=nil;
	end
end
ns.modules[name2].init = function(self)
	if initData then
		initData();
		initData=nil;
	end
end
ns.modules[name3].init = function(self)
	if initData then
		initData();
		initData=nil;
	end
end

ns.modules[name0].onevent = function(self,event,msg)
	if event=="PLAYER_ENTERING_WORLD" and self.PEW~=true then
		self.PEW=true;
		C_Timer.NewTicker(ns.modules[name0].updateinterval,updater);
		updateItems();
		updateSpells();
	end
end

ns.modules[name1].onevent = function(self,event,msg)
	if (event=="BE_UPDATE_CLICKOPTIONS") then
		ns.clickOptions.update(ns.modules[name1],ns.profile[name1]);
	end
end

ns.modules[name2].onevent = function(self,event,msg)
	if (event=="BE_UPDATE_CLICKOPTIONS") then
		ns.clickOptions.update(ns.modules[name2],ns.profile[name2]);
	end
end

ns.modules[name3].onevent = function(self,event,msg)
	if (event=="BE_UPDATE_CLICKOPTIONS") then
		ns.clickOptions.update(ns.modules[name3],ns.profile[name3]);
	end
end
-- ns.modules[name0].onmousewheel = function(self,direction) end
-- ns.modules[name1].onmousewheel = function(self,direction) end
-- ns.modules[name2].onmousewheel = function(self,direction) end
-- ns.modules[name3].onmousewheel = function(self,direction) end
-- ns.modules[name0].optionspanel = function(panel) end
-- ns.modules[name1].optionspanel = function(panel) end
-- ns.modules[name2].optionspanel = function(panel) end
-- ns.modules[name3].optionspanel = function(panel) end


-------------------------------------------
-- module functions for LDB registration --
-------------------------------------------
ns.modules[name1].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt1 = ns.acquireTooltip({ttName1, ttColumns, "LEFT", "RIGHT", "RIGHT"},{true},{self});
	createTooltip(tt1,ttName1,name1);
end

ns.modules[name2].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt2 = ns.acquireTooltip({ttName2, ttColumns, "LEFT", "RIGHT", "RIGHT"},{true},{self});
	createTooltip(tt2,ttName2,name2);
end

ns.modules[name3].onenter = function(self)
	if (ns.tooltipChkOnShowModifier(false)) then return; end
	tt3 = ns.acquireTooltip({ttName3, ttColumns, "LEFT", "RIGHT", "RIGHT"},{true},{self});
	createTooltip(tt3,ttName3,name3);
end

-- ns.modules[name1].onleave = function(self) end
-- ns.modules[name2].onleave = function(self) end
-- ns.modules[name3].onleave = function(self) end

-- ns.modules[name1].onclick = function(self,button) end
-- ns.modules[name2].onclick = function(self,button) end
-- ns.modules[name3].onclick = function(self,button) end

-- ns.modules[name1].ondblclick = function(self,button) end
-- ns.modules[name2].ondblclick = function(self,button) end
-- ns.modules[name3].ondblclick = function(self,button) end
