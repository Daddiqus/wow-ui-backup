local ADDON_NAME, NAMESPACE = ...

---------------------------------------------------------------------------------------------------
-- Define table that contains all addon-global variables and functions
---------------------------------------------------------------------------------------------------
NAMESPACE.ThreatPlates = {}
local ThreatPlates = NAMESPACE.ThreatPlates

---------------------------------------------------------------------------------------------------
-- Imported functions and constants
---------------------------------------------------------------------------------------------------

local UnitPlayerControlled = UnitPlayerControlled

---------------------------------------------------------------------------------------------------
-- Libraries
---------------------------------------------------------------------------------------------------
local LibStub = LibStub

local LibStub = LibStub
ThreatPlates.L = LibStub("AceLocale-3.0"):GetLocale("TidyPlatesThreat")
ThreatPlates.Media = LibStub("LibSharedMedia-3.0")

---------------------------------------------------------------------------------------------------
-- Define AceAddon TidyPlatesThreat
-- TODO: There's a collision with the addon TidyPlates: Threat because of the same Ace3 addon name
---------------------------------------------------------------------------------------------------

TidyPlatesThreat = LibStub("AceAddon-3.0"):NewAddon("TidyPlatesThreat", "AceConsole-3.0", "AceEvent-3.0")

--------------------------------------------------------------------------------------------------
-- General Functions
---------------------------------------------------------------------------------------------------

-- Create a percentage-based WoW color based on integer values from 0 to 255 with optional alpha value
ThreatPlates.RGB = function(red, green, blue, alpha)
	local color = { r = red/255, g = green/255, b = blue/255 }
	if alpha then color.a = alpha end
	return color
end

ThreatPlates.RGB_P = function(red, green, blue, alpha)
	return { r = red, g = green, b = blue, a = alpha}
end

ThreatPlates.RGB_UNPACK = function(color)
	return color.r, color.g, color.b, color.a or 1
end

-- thanks to https://github.com/Perkovec/colorise-lua
ThreatPlates.HEX2RGB = function (hex)
  hex = hex:gsub("#","")
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

ThreatPlates.Update = function()
	-- ForceUpdate() is called in SetTheme()
	if (TidyPlatesOptions.ActiveTheme == ThreatPlates.THEME_NAME) then
		TidyPlates:SetTheme(ThreatPlates.THEME_NAME)
	end
	-- TidyPlates:ForceUpdate()
end

ThreatPlates.Meta = function(value)
	local meta
	if strlower(value) == "titleshort" then
		meta = "TP|cff89F559TP|r"
	else
		meta = GetAddOnMetadata("TidyPlates_ThreatPlates",value)
	end
	return meta or ""
end

ThreatPlates.Class = function()
	local _,class = UnitClass("Player")
	return class
end

ThreatPlates.Active = function()
	local val = GetSpecialization()
	return val
end

ThreatPlates.TotemNameBySpellID = function(number)
	local name = GetSpellInfo(number)
	if not name then
		return ""
	end
	return name
end

do
	ThreatPlates.HCC = {}
	for i=1,#CLASS_SORT_ORDER do
		local str = RAID_CLASS_COLORS[CLASS_SORT_ORDER[i]].colorStr;
		local str = gsub(str,"(ff)","",1)
		ThreatPlates.HCC[CLASS_SORT_ORDER[i]] = str;
	end
end

-- Helper Functions
ThreatPlates.STT = function(...)
	local s = {}
	local i, l
	for i = 1, select("#", ...) do
		l = select(i, ...)
		if l ~= "" then
			s[l] = true
		end
	end
	return s
end

ThreatPlates.TTS = function(s)
	local list
	for i=1,#s do
		if not list then
			list = tostring(s[i]).."\n"
		else
			local nL = s[i]
			if nL ~= "" then
				list = list..tostring(nL).."\n"
			else
				list = list..tostring(nL)
			end
		end
	end
	return list
end

ThreatPlates.CopyTable = function(input)
	local output = {}
	for k,v in pairs(input) do
		if type(v) == "table" then
			output[k] = ThreatPlates.CopyTable(v)
		else
			output[k] = v
		end
	end
	return output
end

--------------------------------------------------------------------------------------------------
-- Some functions to fix TidyPlates bugs
---------------------------------------------------------------------------------------------------

local function FixUpdateUnitCondition(unit)
	local unitid = unit.unitid

	-- Enemy players turn to neutral, e.g., when mounting a flight path mount, so fix reaction in that situations
	if unit.reaction == "NEUTRAL" and (unit.type == "PLAYER" or UnitPlayerControlled(unitid)) then
		unit.reaction = "HOSTILE"
	end
end

--------------------------------------------------------------------------------------------------
-- Debug Functions
---------------------------------------------------------------------------------------------------

local function DEBUG(...)
  print ("DEBUG: ", ...)
end

-- Function from: https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
local function DEBUG_PRINT_TABLE(data)
  local print_r_cache={}
  local function sub_print_r(data,indent)
    if (print_r_cache[tostring(data)]) then
      ThreatPlates.DEBUG (indent.."*"..tostring(data))
    else
      print_r_cache[tostring(data)]=true
      if (type(data)=="table") then
        for pos,val in pairs(data) do
          if (type(val)=="table") then
            ThreatPlates.DEBUG (indent.."["..pos.."] => "..tostring(data).." {")
            sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
            ThreatPlates.DEBUG (indent..string.rep(" ",string.len(pos)+6).."}")
          elseif (type(val)=="string") then
            ThreatPlates.DEBUG (indent.."["..pos..'] => "'..val..'"')
          else
            ThreatPlates.DEBUG (indent.."["..pos.."] => "..tostring(val))
          end
        end
      else
        ThreatPlates.DEBUG (indent..tostring(data))
      end
    end
  end
  if (type(data)=="table") then
    ThreatPlates.DEBUG (tostring(data).." {")
    sub_print_r(data,"  ")
    ThreatPlates.DEBUG ("}")
  else
    sub_print_r(data,"  ")
  end
end

local function DEBUG_PRINT_UNIT(unit)
	DEBUG("Unit:", unit.name)
	DEBUG("  -------------------------------------------------------------")
	DEBUG_PRINT_TABLE(unit)
	if unit.unitid then
		DEBUG("  isPet = ", UnitIsOtherPlayersPet(unit))
		DEBUG("  isControlled = ", UnitPlayerControlled(unit.unitid))
		DEBUG("  isBattlePet = ", UnitIsBattlePet(unit.unitid))
		DEBUG("  canAttack = ", UnitCanAttack("player", unit.unitid))
		DEBUG("  isFriend = ", TidyPlatesUtility.IsFriend(unit.name))
		DEBUG("  isGuildmate = ", TidyPlatesUtility.IsGuildmate(unit.name))
		DEBUG("  --------------------------------------------------------------")
	else
		DEBUG("  <no unit id>")
		DEBUG("  --------------------------------------------------------------")
	end
end

local function DEBUG_PRINT_TARGET(unit)
  if unit.isTarget then
		DEBUG_PRINT_UNIT(unit)
  end
end

local function DEBUG_AURA_LIST(data)
	local res = ""
	for pos,val in pairs(data) do
		local a = data[pos]
		if not a then
			res = res .. " nil"
		elseif not a.priority then
			res = res .. " nil(" .. a.name .. ")"
		else
			res = res .. a.name
		end
		if pos ~= #data then
			res = res .. " - "
		end
	end
	ThreatPlates.DEBUG("Aura List = [ " .. res .. " ]")
end

---------------------------------------------------------------------------------------------------
-- Expoerted local functions
---------------------------------------------------------------------------------------------------

ThreatPlates.FixUpdateUnitCondition = FixUpdateUnitCondition

--ThreatPlates.DEBUG = DEBUG
--ThreatPlates.DEBUG_PRINT_TABLE = DEBUG_PRINT_TABLE
--ThreatPlates.DEBUG_PRINT_UNIT = DEBUG_PRINT_UNIT
--ThreatPlates.DEBUG_PRINT_TARGET = DEBUG_PRINT_TARGET
--ThreatPlates.DEBUG_AURA_LIST = DEBUG_AURA_LIST
ThreatPlates.DEBUG = function(...) end
ThreatPlates.DEBUG_PRINT_TABLE = function(...) end
ThreatPlates.DEBUG_PRINT_TARGET = function(...) end
ThreatPlates.DEBUG_AURA_LIST = function(...) end


