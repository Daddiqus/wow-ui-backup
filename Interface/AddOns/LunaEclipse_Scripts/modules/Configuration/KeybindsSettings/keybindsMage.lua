local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() then
    local moduleName = "keybindsMage";
    local keybindsMage = LunaEclipse_Scripts:NewModule(moduleName, "AceEvent-3.0");
	local functionsConfiguration = addonTable.functionsConfiguration;
	local functionsTables = addonTable.functionsTables;

	if LunaEclipse_Scripts:GetClass() == addonTable.CLASS_MAGE then
		--<private-static-methods>
		local function buildConfiguration()
			-- Get the players current specialization.
			local currentSpec = LunaEclipse_Scripts:GetSpecialization();

			-- Reset the configuration table
			addonTable.keybindOptions.args = {};

			if currentSpec == addonTable.MAGE_ARCANE then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMage = addonTable.commonMage,
					arcaneMage = addonTable.arcaneMage,
				};
			elseif currentSpec == addonTable.MAGE_FIRE then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMage = addonTable.commonMage,
					fireMage = addonTable.fireMage,
				};
			elseif currentSpec == addonTable.MAGE_FROST then
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMage = addonTable.commonMage,
					frostMage = addonTable.frostMage,
				};
			else
				addonTable.keybindOptions.args = {
					commonRacial = addonTable.commonRacial,
					commonMage = addonTable.commonMage,
				};
			end
		end
		--</private-static-methods>

		--<public-static-methods>
		function keybindsMage:PLAYER_LOGIN(event, ...)
			buildConfiguration();
		end

		function keybindsMage:PLAYER_SPECIALIZATION_CHANGED(event, ...)
			local eventUnit = select(1, ...);

			-- Check to make sure its the player whose specialization changed
			if eventUnit == "player" then
				buildConfiguration();
			end
		end

		function keybindsMage:OnEnable()
			-- Create the override table for Mages.
			addonTable.replacementSpells = functionsTables:MergeTables(addonTable.replacementRacial, addonTable.replacementMage);

			-- Register Events
			self:RegisterEvent("PLAYER_LOGIN");
			self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end

		function keybindsMage:OnDisable()
			-- Unregister Events
			self:UnregisterEvent("PLAYER_LOGIN");
			self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		end
		--</public-static-methods>
	end
end