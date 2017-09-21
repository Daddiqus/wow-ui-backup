


--> check unloaded files:
if (
	-- version 1.21.0
	not _G._detalhes.atributo_custom.damagedoneTooltip or
	not _G._detalhes.atributo_custom.healdoneTooltip
	) then
	
	local f = CreateFrame ("frame", "DetaisCorruptInstall", UIParent)
	f:SetSize (370, 70)
	f:SetPoint ("center", UIParent, "center", 0, 0)
	f:SetPoint ("top", UIParent, "top", 0, -20)
	local bg = f:CreateTexture (nil, "background")
	bg:SetAllPoints (f)
	bg:SetTexture ([[Interface\AddOns\Details\images\welcome]])
	
	local image = f:CreateTexture (nil, "overlay")
	image:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
	image:SetSize (32, 32)
	
	local label = f:CreateFontString (nil, "overlay", "GameFontNormal")
	label:SetText ("Restart game client in order to finish addons updates.")
	label:SetWidth (300)
	label:SetJustifyH ("left")
	
	local close = CreateFrame ("button", "DetaisCorruptInstall", f, "UIPanelCloseButton")
	close:SetSize (32, 32)
	close:SetPoint ("topright", f, "topright", 0, 0)
	
	image:SetPoint ("topleft", f, "topleft", 10, -20)	
	label:SetPoint ("left", image, "right", 4, 0)

	_G._detalhes.FILEBROKEN = true
end

function _G._detalhes:InstallOkey()
	if (_G._detalhes.FILEBROKEN) then
		return false
	end
	return true
end

--> start funtion
function _G._detalhes:Start()

	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> row single click

	--> single click row function replace
		--damage, dps, damage taken, friendly fire
			self.row_singleclick_overwrite [1] = {true, true, true, true, self.atributo_damage.ReportSingleFragsLine, self.atributo_damage.ReportEnemyDamageTaken, self.atributo_damage.ReportSingleVoidZoneLine, self.atributo_damage.ReportSingleDTBSLine}
		--healing, hps, overheal, healing taken
			self.row_singleclick_overwrite [2] = {true, true, true, true, false, self.atributo_heal.ReportSingleDamagePreventedLine} 
		--mana, rage, energy, runepower
			self.row_singleclick_overwrite [3] = {true, true, true, true} 
		--cc breaks, ress, interrupts, dispells, deaths
			self.row_singleclick_overwrite [4] = {true, true, true, true, self.atributo_misc.ReportSingleDeadLine, self.atributo_misc.ReportSingleCooldownLine, self.atributo_misc.ReportSingleBuffUptimeLine, self.atributo_misc.ReportSingleDebuffUptimeLine} 
		
		function self:ReplaceRowSingleClickFunction (attribute, sub_attribute, func)
			assert (type (attribute) == "number" and attribute >= 1 and attribute <= 4, "ReplaceRowSingleClickFunction expects a attribute index on #1 argument.")
			assert (type (sub_attribute) == "number" and sub_attribute >= 1 and sub_attribute <= 10, "ReplaceRowSingleClickFunction expects a sub attribute index on #2 argument.")
			assert (type (func) == "function", "ReplaceRowSingleClickFunction expects a function on #3 argument.")
			
			self.row_singleclick_overwrite [attribute] [sub_attribute] = func
			return true
		end
		
		self.click_to_report_color = {1, 0.8, 0, 1}
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialize

	--> build frames

		--> bookmarks
			if (self.switch.InitSwitch) then
				--self.switch:InitSwitch()
			end
			
		--> custom window
			self.custom = self.custom or {}
			
		--> micro button alert
			self.MicroButtonAlert = CreateFrame ("frame", "DetailsMicroButtonAlert", UIParent, "MicroButtonAlertTemplate")
			self.MicroButtonAlert:Hide()
			
		--> actor details window
			self.janela_info = self.gump:CriaJanelaInfo()
			self.gump:Fade (self.janela_info, 1)
			
		--> copy and paste window
			self:CreateCopyPasteWindow()
			self.CreateCopyPasteWindow = nil
			
	--> start instances
		if (self:GetNumInstancesAmount() == 0) then
			self:CriarInstancia()
		end
		self:GetLowerInstanceNumber()
		
	--> start time machine
		self.timeMachine:Ligar()
	
	--> update abbreviation shortcut
	
		self.atributo_damage:UpdateSelectedToKFunction()
		self.atributo_heal:UpdateSelectedToKFunction()
		self.atributo_energy:UpdateSelectedToKFunction()
		self.atributo_misc:UpdateSelectedToKFunction()
		self.atributo_custom:UpdateSelectedToKFunction()
		
	--> start instances updater
	
		self:CheckSwitchOnLogon()
	
		function _detalhes:ScheduledWindowUpdate (forced)
			if (not forced and _detalhes.in_combat) then
				return
			end
			_detalhes.scheduled_window_update = nil
			_detalhes:AtualizaGumpPrincipal (-1, true)
		end
		function _detalhes:ScheduleWindowUpdate (time, forced)
			if (_detalhes.scheduled_window_update) then
				_detalhes:CancelTimer (_detalhes.scheduled_window_update)
				_detalhes.scheduled_window_update = nil
			end
			_detalhes.scheduled_window_update = _detalhes:ScheduleTimer ("ScheduledWindowUpdate", time or 1, forced)
		end
	
		self:AtualizaGumpPrincipal (-1, true)
		self.atualizador = self:ScheduleRepeatingTimer ("AtualizaGumpPrincipal", _detalhes.update_speed, -1)
		
		for index = 1, #self.tabela_instancias do
			local instance = self.tabela_instancias [index]
			if (instance:IsAtiva()) then
				self:ScheduleTimer ("RefreshBars", 1, instance)
				self:ScheduleTimer ("InstanceReset", 1, instance)
				self:ScheduleTimer ("InstanceRefreshRows", 1, instance)
			end
		end

		function self:RefreshAfterStartup()
		
			self:AtualizaGumpPrincipal (-1, true)
			
			local lower_instance = _detalhes:GetLowerInstanceNumber()

			for index = 1, #self.tabela_instancias do
				local instance = self.tabela_instancias [index]
				if (instance:IsAtiva()) then
					--> refresh wallpaper
					if (instance.wallpaper.enabled) then
						instance:InstanceWallpaper (true)
					else
						instance:InstanceWallpaper (false)
					end
					
					--> refresh desaturated icons if is lower instance
					if (index == lower_instance) then
						instance:DesaturateMenu()

						instance:SetAutoHideMenu (nil, nil, true)
					end
					
				end
			end
			
			--> refresh lower instance plugin icons and skin
			_detalhes.ToolBar:ReorganizeIcons() 
			--> refresh skin for other windows
			if (lower_instance) then
				for i = lower_instance+1, #self.tabela_instancias do
					local instance = self:GetInstance (i)
					if (instance and instance.baseframe and instance.ativa) then
						instance:ChangeSkin()
					end
				end
			end
		
			self.RefreshAfterStartup = nil
			
			function _detalhes:CheckWallpaperAfterStartup()
			
				if (not _detalhes.profile_loaded) then
					return _detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 2)
				end
				
				for i = 1, self.instances_amount do
					local instance = self:GetInstance (i)
					if (instance and instance:IsEnabled()) then
						if (not instance.wallpaper.enabled) then
							instance:InstanceWallpaper (false)
						end
					
						instance.do_not_snap = true
						self.move_janela_func (instance.baseframe, true, instance, true)
						self.move_janela_func (instance.baseframe, false, instance, true)
						instance.do_not_snap = false
					end
				end
				self.CheckWallpaperAfterStartup = nil
				_detalhes.profile_loaded = nil

			end
			
			_detalhes:ScheduleTimer ("CheckWallpaperAfterStartup", 5)
			
		end
		self:ScheduleTimer ("RefreshAfterStartup", 5)

		
	--> start garbage collector
	
		self.ultima_coleta = 0
		self.intervalo_coleta = 720
		--self.intervalo_coleta = 10
		self.intervalo_memoria = 180
		--self.intervalo_memoria = 20
		self.garbagecollect = self:ScheduleRepeatingTimer ("IniciarColetaDeLixo", self.intervalo_coleta)
		
		--desativado, algo bugou no 7.2.5
		--self.memorycleanup = self:ScheduleRepeatingTimer ("CheckMemoryPeriodically", self.intervalo_memoria)
		
		self.next_memory_check = time()+self.intervalo_memoria

	--> role
		self.last_assigned_role = UnitGroupRolesAssigned ("player")
		
	--> start parser
		
		--> load parser capture options
			self:CaptureRefresh()
		--> register parser events
			
			self.listener:RegisterEvent ("PLAYER_REGEN_DISABLED")
			self.listener:RegisterEvent ("PLAYER_REGEN_ENABLED")
			self.listener:RegisterEvent ("SPELL_SUMMON")
			self.listener:RegisterEvent ("UNIT_PET")

			self.listener:RegisterEvent ("PARTY_MEMBERS_CHANGED")
			self.listener:RegisterEvent ("GROUP_ROSTER_UPDATE")
			self.listener:RegisterEvent ("PARTY_CONVERTED_TO_RAID")
			
			self.listener:RegisterEvent ("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
			
			self.listener:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
			self.listener:RegisterEvent ("PLAYER_ENTERING_WORLD")
		
			self.listener:RegisterEvent ("ENCOUNTER_START")
			self.listener:RegisterEvent ("ENCOUNTER_END")
			
			self.listener:RegisterEvent ("START_TIMER")
			self.listener:RegisterEvent ("UNIT_NAME_UPDATE")

			self.listener:RegisterEvent ("PET_BATTLE_OPENING_START")
			self.listener:RegisterEvent ("PET_BATTLE_CLOSE")
			
			self.listener:RegisterEvent ("PLAYER_ROLES_ASSIGNED")
			self.listener:RegisterEvent ("ROLE_CHANGED_INFORM")
			
			self.listener:RegisterEvent ("PLAYER_SPECIALIZATION_CHANGED")
			
			--test immersion stuff
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
			
			local immersionFrame = CreateFrame ("frame", "DetailsImmersionFrame", UIParent)
			immersionFrame:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
			immersionFrame.DevelopmentDebug = false
			
			--> check if can enabled the immersino stuff
			
			function immersionFrame.CheckIfCanEnableImmersion()
				local mapFileName = GetMapInfo()	
				if (mapFileName and mapFileName:find ("InvasionPoint")) then
					self.immersion_enabled = true
					if (immersionFrame.DevelopmentDebug) then
						print ("Details!", "CheckIfCanEnableImmersion() > immersion enabled.")
					end
				else
					if (self.immersion_enabled) then
						if (immersionFrame.DevelopmentDebug) then
							print ("Details!", "CheckIfCanEnableImmersion() > immersion disabled.")
						end
						self.immersion_enabled = nil
					end
				end
			end

			--> check events
			immersionFrame:SetScript ("OnEvent", function (_, event, ...)
				if (event == "ZONE_CHANGED_NEW_AREA") then
					C_Timer.After (3, immersionFrame.CheckIfCanEnableImmersion)
				end
			end)
			
			
			--test mythic + stuff
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			--> data for the current mythic + dungeon
			self.MythicPlus = {
				RunID = 0,
			}
			
			-- ~mythic ~dungeon
			local newFrame = CreateFrame ("frame", "DetailsMythicPlusFrame", UIParent)
			newFrame.DevelopmentDebug = false
			
			--[
				newFrame:RegisterEvent ("CHALLENGE_MODE_START")
				newFrame:RegisterEvent ("CHALLENGE_MODE_COMPLETED")
				newFrame:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
				newFrame:RegisterEvent ("ENCOUNTER_END")
			--]]
			
			--[[
				all mythic segments have:
					.is_mythic_dungeon_segment = true
					.is_mythic_dungeon_run_id = run id from details.profile.mythic_dungeon_id
				boss, 'trash overall' and 'dungeon overall' segments have:
					.is_mythic_dungeon 
				boss segments have:
					.is_boss
				'trash overall' segments have:
					.is_mythic_dungeon with .SegmentID = "trashoverall"
				'dungeon overall' segment have:
					.is_mythic_dungeon with .SegmentID = "overall"
				
			--]]
			
			--precisa converter um wipe em um trash segment? provavel que sim
			
			-- at the end of a mythic run, if enable on settings, merge all the segments from the mythic run into only one
			function newFrame.MergeSegmentsOnEnd()
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MythicDungeonFinished() > starting to merge mythic segments.", "InCombatLockdown():", InCombatLockdown())
				end
				
				--> create a new combat to be the overall for the mythic run
				self:EntrarEmCombate()
				
				--> get the current combat just created and the table with all past segments
				local newCombat = self:GetCurrentCombat()
				local segmentHistory = self:GetCombatSegments()

				local totalTime = 0
				local startDate, endDate = "", ""
				local lastSegment

				--> add all boss segments from this run to this new segment
				for i = 1, 25 do --> from the newer combat to the oldest
					local pastCombat = segmentHistory [i]
					if (pastCombat and pastCombat.is_mythic_dungeon and pastCombat.is_mythic_dungeon.RunID == self.mythic_dungeon_id) then
						local canAddThisSegment = true
						if (_detalhes.mythic_plus.make_overall_boss_only) then
							if (not pastCombat.is_boss) then
								canAddThisSegment = false
							end
						end
						
						if (canAddThisSegment) then
							newCombat = newCombat + pastCombat
							totalTime = totalTime + pastCombat:GetCombatTime()
							
							if (newFrame.DevelopmentDebug) then
								print ("MythicDungeonFinished() > adding time:", pastCombat:GetCombatTime(), pastCombat.is_boss and pastCombat.is_boss.name)
							end
							
							if (endDate == "") then
								local _, whenEnded = pastCombat:GetDate()
								endDate =whenEnded
							end
							lastSegment = pastCombat
						end
					end
				end
				
				--> get the date where the first segment started
				if (lastSegment) then
					startDate = lastSegment:GetDate()
				end
				
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MythicDungeonFinished() > totalTime:", totalTime, "startDate:", startDate)
				end
				
				local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
				
				--> tag the segment as mythic overall segment
				newCombat.is_mythic_dungeon = {
					StartedAt = self.MythicPlus.StartedAt, --the start of the run
					EndedAt = self.MythicPlus.EndedAt, --the end of the run
					SegmentID = "overall", --segment number within the dungeon
					RunID = self.mythic_dungeon_id,
					OverallSegment = true,
					ZoneName = self.MythicPlus.DungeonName,
					MapID = instanceMapID,
					Level = self.MythicPlus.Level,
					EJID = self.MythicPlus.ejID,
				}
				
				newCombat.is_mythic_dungeon_segment = true
				newCombat.is_mythic_dungeon_run_id = self.mythic_dungeon_id
				
				--> set the segment time and date
				newCombat:SetStartTime (GetTime() - totalTime)
				newCombat:SetEndTime (GetTime())
				newCombat:SetDate (startDate, endDate)

				--> immediatly finishes the segment just started
				self:SairDoCombate()
				
				--> update all windows
				self:InstanciaCallFunction (self.gump.Fade, "in", nil, "barras")
				self:InstanciaCallFunction (self.AtualizaSegmentos)
				self:InstanciaCallFunction (self.AtualizaSoloMode_AfertReset)
				self:InstanciaCallFunction (self.ResetaGump)
				self:AtualizaGumpPrincipal (-1, true)
				
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MythicDungeonFinished() > finished merging segments.")
					print ("Details!", "MythicDungeonFinished() > all done, check in the segments list if everything is correct, if something is weird: '/details feedback' thanks in advance!")
				end			
			
			end
			
			--> after each boss fight, if enalbed on settings, create an extra segment with all trash segments from the boss just killed
			function newFrame.MergeTrashCleanup()
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MergeTrashCleanup() > running", newFrame.TrashMergeScheduled and #newFrame.TrashMergeScheduled)
				end
				
				local segmentsToMerge = newFrame.TrashMergeScheduled
				
				--> table exists and there's at least one segment
				if (segmentsToMerge and segmentsToMerge[1]) then
					--> do the merge
					
					--> leave combat if still tagged as combat
					if (self.in_combat) then
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "MergeTrashCleanup() > was in combat, calling SairDoCombate()", _detalhes.tabela_vigente, _detalhes.tabela_vigente.is_boss)
						end
						self:SairDoCombate()
					end
					
					--> create a new combat to be the overall for the mythic run
					self:EntrarEmCombate()
					
					--> get the current combat just created and the table with all past segments
					local newCombat = self:GetCurrentCombat()
					local totalTime = 0
					local startDate, endDate = "", ""
					local lastSegment
					
					--> add segments
					for _, pastCombat in ipairs (segmentsToMerge) do
						newCombat = newCombat + pastCombat
						totalTime = totalTime + pastCombat:GetCombatTime()
						
						--> tag this combat as already added to a boss trash overall
						pastCombat._trashoverallalreadyadded = true
						
						if (endDate == "") then
							local _, whenEnded = pastCombat:GetDate()
							endDate = whenEnded
						end
						lastSegment = pastCombat
					end
					
					--> get the date where the first segment started
					if (lastSegment) then
						startDate = lastSegment:GetDate()
					end
					
					local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
	
					--> tag the segment as mythic overall segment
					newCombat.is_mythic_dungeon = {
						StartedAt = segmentsToMerge.PreviousBossKilledAt, --start of the mythic run or when the previous boss got killed
						EndedAt = segmentsToMerge.LastBossKilledAt, --the time() when encounter_end got triggered
						SegmentID = "trashoverall",
						RunID = self.mythic_dungeon_id,
						TrashOverallSegment = true,
						ZoneName = self.MythicPlus.DungeonName,
						MapID = instanceMapID,
						Level = self.MythicPlus.Level,
						EJID = self.MythicPlus.ejID,
						EncounterID = segmentsToMerge.EncounterID,
						EncounterName = segmentsToMerge.EncounterName or Loc ["STRING_UNKNOW"],
					}
					
					newCombat.is_mythic_dungeon_segment = true
					newCombat.is_mythic_dungeon_run_id = self.mythic_dungeon_id
					
					--> set the segment time / using a sum of combat times, this combat time is reliable
					newCombat:SetStartTime (GetTime() - totalTime)
					newCombat:SetEndTime (GetTime())
					--> set the segment date
					newCombat:SetDate (startDate, endDate)
					
					--> immediatly finishes the segment just started
					self:SairDoCombate()

					--o combate agora � _tabela_vigente e [1] na tabela de overall
					--seria necessario passar essa tabela para [2] na overall
					local segmentHistory = self:GetCombatSegments()
					local bossSegment = segmentHistory [2]
					if (bossSegment) then
						--set the boss as the current combat
						_detalhes.tabela_vigente = bossSegment
						--swap tables
						segmentHistory [1] = bossSegment --as the boss combat is done, it is also the first combat in the past combats table
						segmentHistory [2] = newCombat --se the overall trash as the second segment on the past table (the semgnet 2 was occupy by the boss segment)
					end
					
					--> update all windows
					self:InstanciaCallFunction (self.gump.Fade, "in", nil, "barras")
					self:InstanciaCallFunction (self.AtualizaSegmentos)
					self:InstanciaCallFunction (self.AtualizaSoloMode_AfertReset)
					self:InstanciaCallFunction (self.ResetaGump)
					self:AtualizaGumpPrincipal (-1, true)
					
					if (newFrame.DevelopmentDebug) then
						print ("Details!", "MergeTrashCleanup() > finished merging trash segments.", _detalhes.tabela_vigente, _detalhes.tabela_vigente.is_boss)
					end	
					
					--> should delete the trash segments after the merge?
					if (_detalhes.mythic_plus.delete_trash_after_merge) then
						local segmentHistory = self:GetCombatSegments()
						for _, pastCombat in ipairs (segmentsToMerge) do
							for i = #segmentHistory, 1, -1 do
								local segment = segmentHistory [i]
								if (segment == pastCombat) then
									wipe (segment)
									tremove (segmentHistory, i)
									break
								end
							end
						end
						wipe (segmentsToMerge)
						self:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
					else
						--> clear the segments to merge table
						for i = #segmentsToMerge, 1, -1 do
							tremove (segmentsToMerge, i)
							--> notify plugins about a segment deleted
							self:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
						end
						
						--> clear encounter name and id
						segmentsToMerge.EncounterID = nil
						segmentsToMerge.EncounterName = nil
					end
				end
			end
			
			--> this function merges trash segments after all bosses of the mythic dungeon are defeated
			--> happens when the group finishes all bosses but don't complete the trash requirement
			function newFrame.MergeRemainingTrashAfterAllBossesDone()
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MergeRemainingTrashAfterAllBossesDone() > running, #segments: ", #newFrame.TrashMergeScheduled2, "trash overall table:", newFrame.TrashMergeScheduled2_OverallCombat)
				end
				
				local segmentsToMerge = newFrame.TrashMergeScheduled2
				local overallCombat = newFrame.TrashMergeScheduled2_OverallCombat
				
				--> needs to merge, add the total combat time, set the date end to the date of the first segment
				local totalTime = 0
				local startDate, endDate = "", ""
				local lastSegment
				
				--> add segments
				for _, pastCombat in ipairs (segmentsToMerge) do
					overallCombat = overallCombat + pastCombat
					if (newFrame.DevelopmentDebug) then
						print ("MergeRemainingTrashAfterAllBossesDone() >  segment added")
					end
					totalTime = totalTime + pastCombat:GetCombatTime()
					
					--> tag this combat as already added to a boss trash overall
					pastCombat._trashoverallalreadyadded = true
					
					if (endDate == "") then --get the end date of the first index only
						local _, whenEnded = pastCombat:GetDate()
						endDate = whenEnded
					end
					lastSegment = pastCombat
				end
				
				--> set the segment time / using a sum of combat times, this combat time is reliable
				local startTime = overallCombat:GetStartTime()
				overallCombat:SetStartTime (startTime - totalTime)
				if (newFrame.DevelopmentDebug) then
					print ("MergeRemainingTrashAfterAllBossesDone() > total combat time:", totalTime)
				end
				--> set the segment date
				local startDate = overallCombat:GetDate()
				overallCombat:SetDate (startDate, endDate)
				if (newFrame.DevelopmentDebug) then
					print ("MergeRemainingTrashAfterAllBossesDone() > new end date:", endDate)
				end
				
				local mythicDungeonInfo = overallCombat:GetMythicDungeonInfo()
				
				if (newFrame.DevelopmentDebug) then
					print ("MergeRemainingTrashAfterAllBossesDone() > elapsed time before:", mythicDungeonInfo.EndedAt - mythicDungeonInfo.StartedAt)
				end
				mythicDungeonInfo.StartedAt = mythicDungeonInfo.StartedAt - (self.MythicPlus.EndedAt - self.MythicPlus.PreviousBossKilledAt)
				if (newFrame.DevelopmentDebug) then
					print ("MergeRemainingTrashAfterAllBossesDone() > elapsed time after:", mythicDungeonInfo.EndedAt - mythicDungeonInfo.StartedAt)
				end
				
				--> should delete the trash segments after the merge?
				if (_detalhes.mythic_plus.delete_trash_after_merge) then
					local segmentHistory = self:GetCombatSegments()
					for _, pastCombat in ipairs (segmentsToMerge) do
						for i = #segmentHistory, 1, -1 do
							local segment = segmentHistory [i]
							if (segment == pastCombat) then
								wipe (segment)
								tremove (segmentHistory, i)
								break
							end
						end
					end
					wipe (segmentsToMerge)
					self:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
				else
					--> clear the segments to merge table
					for i = #segmentsToMerge, 1, -1 do
						tremove (segmentsToMerge, i)
						
						--> notify plugins about a segment deleted
						self:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
					end
				end

				newFrame.TrashMergeScheduled2 = nil
				newFrame.TrashMergeScheduled2_OverallCombat = nil

				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MergeRemainingTrashAfterAllBossesDone() > done merging")
				end
			end
			
			--this function is called right after defeat a boss inside a mythic dungeon
			function newFrame.BossDefeated (this_is_end_end, encounterID, encounterName, difficultyID, raidSize, endStatus) --hold your breath and count to ten
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "BossDefeated() > boss defeated | SegmentID:", self.MythicPlus.SegmentID, " | mapID:", self.MythicPlus.DungeonID)
				end
				
				local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
				
				--> addon the mythic dungeon info to the combat
				_detalhes.tabela_vigente.is_mythic_dungeon = {
					StartedAt = self.MythicPlus.StartedAt, --the start of the run
					EndedAt = time(), --when the boss got killed
					SegmentID = self.MythicPlus.SegmentID, --segment number within the dungeon
					EncounterID = encounterID,
					EncounterName = encounterName or Loc ["STRING_UNKNOW"],
					RunID = self.mythic_dungeon_id,
					ZoneName = self.MythicPlus.DungeonName,
					MapID = self.MythicPlus.DungeonID,
					OverallSegment = false,
					Level = self.MythicPlus.Level,
					EJID = self.MythicPlus.ejID,
				}
				
				if (not this_is_end_end) then
					--> parser doesn't handle ENCOUNTER_END to party instances, so we close the combat from here
					self:SairDoCombate (true, {encounterID, encounterName, difficultyID, raidSize, endStatus})
					if (newFrame.DevelopmentDebug) then
						print ("Details!", "BossDefeated() > closing the combat with SairDoCombate()", _detalhes.tabela_vigente, _detalhes.tabela_vigente.is_boss)
					end
				end
				
				--> check if need to merge the trash for this boss
				if (_detalhes.mythic_plus.merge_boss_trash) then
					--> store on an table all segments which should be merged
					local segmentsToMerge = newFrame.TrashMergeScheduled or {}
					--> table with all past semgnets
					local segmentHistory = self:GetCombatSegments()
					
					--> iterate among segments
					for i = 1, 25 do --> from the newer combat to the oldest
						local pastCombat = segmentHistory [i]
						--> does the combat exists
						if (pastCombat and not pastCombat._trashoverallalreadyadded) then
							--> is the combat a mythic segment from this run?
							local isMythicSegment, SegmentID = pastCombat:IsMythicDungeon()
							if (isMythicSegment and SegmentID == self.mythic_dungeon_id and not pastCombat.is_boss) then
							
								local mythicDungeonInfo = pastCombat:GetMythicDungeonInfo() -- .is_mythic_dungeon only boss, trash overall and run overall have it
								if (not mythicDungeonInfo or not mythicDungeonInfo.TrashOverallSegment) then
									--> trash segment found, schedule to merge
									tinsert (segmentsToMerge, pastCombat)
								end
							end
						end
					end
					
					--> add encounter information
					segmentsToMerge.EncounterID = encounterID
					segmentsToMerge.EncounterName = encounterName
					segmentsToMerge.PreviousBossKilledAt = self.MythicPlus.PreviousBossKilledAt
					
					--> reduce this boss encounter time from the trash lenght time, since the boss doesn't count towards the time spent cleaning trash
					segmentsToMerge.LastBossKilledAt = time() - _detalhes.tabela_vigente:GetCombatTime()
					
					newFrame.TrashMergeScheduled = segmentsToMerge
					
					if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "BossDefeated() > not in combat, merging trash now")
						end
						newFrame.MergeTrashCleanup()
					else
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "BossDefeated() > player in combatlockdown, scheduling trash merge")
						end
						_detalhes.schedule_mythicdungeon_trash_merge = true
					end
				end

				--> close the combat
				if (this_is_end_end) then
					--> player left the dungeon
					if (in_combat and _detalhes.mythic_plus.always_in_combat) then
						self:SairDoCombate()
					end
				else
					--> re-enter in combat if details! is set to always be in combat during mythic plus
					if (self.mythic_plus.always_in_combat) then
						self:EntrarEmCombate()
					end
					
					--> increase the segment number for the mythic run
					self.MythicPlus.SegmentID = self.MythicPlus.SegmentID + 1
					
					--> register the time when the last boss has been killed (started a clean up for the next trash)
					self.MythicPlus.PreviousBossKilledAt = time()
				end
			end
			
			function newFrame.MythicDungeonFinished()
				if (newFrame.IsDoingMythicDungeon) then
					if (newFrame.DevelopmentDebug) then
						print ("Details!", "MythicDungeonFinished() > the dungeon was a Mythic+ and just ended.")
					end
					
					newFrame.IsDoingMythicDungeon = false
					self.MythicPlus.Started = false
					self.MythicPlus.EndedAt = time()-1.9
					
					--> at this point, details! should not be in combat, but if something triggered a combat start, just close the combat right away
					if (self.in_combat) then
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "MythicDungeonFinished() > was in combat, calling SairDoCombate():", InCombatLockdown())
						end
						self:SairDoCombate()
					end
					
					local segmentsToMerge = {}
					
					--> check if there is trash segments after the last boss. need to merge these segments with the trash segment of the last boss
					if (_detalhes.mythic_plus.merge_boss_trash) then
						--> is the current combat not a boss fight? this means a combat was opened after the mythic run completed
						if (not self.tabela_vigente.is_boss and self.tabela_vigente:GetCombatTime() > 5) then
							if (newFrame.DevelopmentDebug) then
								print ("Details!", "MythicDungeonFinished() > the last combat isn't a boss fight, might have trash after bosses done.")
							end
							
							--> table with all past semgnets
							local segmentHistory = self:GetCombatSegments()
							
							for i = 1, #segmentHistory do
								local pastCombat = segmentHistory [i]
								--> does the combat exists
							
								if (pastCombat and not pastCombat._trashoverallalreadyadded and pastCombat:GetCombatTime() > 5) then
									--> is the last boss?
									if (pastCombat.is_boss) then
										break
									end
									--> is the combat a mythic segment from this run?
									local isMythicSegment, SegmentID = pastCombat:IsMythicDungeon()
									if (isMythicSegment and SegmentID == self.mythic_dungeon_id) then
										--> if have mythic dungeon info, cancel the loop
										local mythicDungeonInfo = pastCombat:GetMythicDungeonInfo()
										if (mythicDungeonInfo) then
											break
										end
										--> merge this segment
										tinsert (segmentsToMerge, pastCombat)
										if (newFrame.DevelopmentDebug) then
											print ("MythicDungeonFinished() > found after last boss combat")
										end
									end
								end
							end
						end
					end
					
					if (#segmentsToMerge > 0) then
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "MythicDungeonFinished() > found ", #segmentsToMerge, "segments after the last boss")
						end
						
						--> find the latest trash overall
						local segmentHistory = self:GetCombatSegments()
						local latestTrashOverall
						for i = 1, #segmentHistory do
							local pastCombat = segmentHistory [i]
							if (pastCombat and pastCombat.is_mythic_dungeon and pastCombat.is_mythic_dungeon.SegmentID == "trashoverall") then
								latestTrashOverall = pastCombat
								break
							end
						end
						
						if (latestTrashOverall) then
							--> stores the segment table and the trash overall segment to use on the merge
							newFrame.TrashMergeScheduled2 = segmentsToMerge
							newFrame.TrashMergeScheduled2_OverallCombat = latestTrashOverall
							
							if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
								if (newFrame.DevelopmentDebug) then
									print ("Details!", "MythicDungeonFinished() > not in combat, merging last pack of trash now")
								end
								newFrame.MergeRemainingTrashAfterAllBossesDone()
							else
								if (newFrame.DevelopmentDebug) then
									print ("Details!", "MythicDungeonFinished() > player in combatlockdown, scheduling the merge for last trash packs")
								end
								_detalhes.schedule_mythicdungeon_endtrash_merge = true
							end
						end
					end
					
					--> merge segments
					if (_detalhes.mythic_plus.make_overall_when_done) then
						if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
							if (newFrame.DevelopmentDebug) then
								print ("Details!", "MythicDungeonFinished() > not in combat, creating overall segment now")
							end
							newFrame.MergeSegmentsOnEnd()
						else
							if (newFrame.DevelopmentDebug) then
								print ("Details!", "MythicDungeonFinished() > player in combatlockdown, scheduling the creation of the overall segment")
							end
							_detalhes.schedule_mythicdungeon_overallrun_merge = true
						end
					end
				end
			end

			function newFrame.MythicDungeonStarted()
				--> flag as a mythic dungeon
				newFrame.IsDoingMythicDungeon = true
				
				if (newFrame.DevelopmentDebug) then
					print ("=========")
					print ("Details!", "Thanks for using an alpha version of Details!, please don't mind all these debug lines.")
					print ("Details!", "We are developing new stuff.")
					print ("=========")
					print ("Details!", "MythicDungeonStarted() > CHALLENGE_MODE_START triggered, setting up details!")
				end
				
				local mythicLevel = C_ChallengeMode.GetActiveKeystoneInfo()
				local zoneName, _, _, _, _, _, _, currentZoneID = GetInstanceInfo()
				local ejID = EJ_GetCurrentInstance()
				
				--> setup the mythic run info
				self.MythicPlus.Started = true
				self.MythicPlus.DungeonName = zoneName
				self.MythicPlus.DungeonID = currentZoneID
				self.MythicPlus.StartedAt = time()+9.7 --> there's the countdown timer of 10 seconds
				self.MythicPlus.SegmentID = 1
				self.MythicPlus.Level = mythicLevel
				self.MythicPlus.ejID = ejID
				self.MythicPlus.PreviousBossKilledAt = time()
				
				--> this counter is individual for each character
				self.mythic_dungeon_id = self.mythic_dungeon_id + 1 --14 --15 
				
				--> start a new combat segment after 10 seconds
				if (_detalhes.mythic_plus.always_in_combat) then
					C_Timer.After (9.7, function()
						if (newFrame.DevelopmentDebug) then
							print ("Details!", "New segment for mythic dungeon created.")
						end
						_detalhes:EntrarEmCombate()
					end)
				end
				
				local name, groupType, difficultyID, difficult = GetInstanceInfo()
				if (groupType == "party" and self.overall_clear_newchallenge) then
					self.historico:resetar_overall()
					if (self.debug) then
						self:Msg ("(debug) timer is for a mythic+ dungeon, overall has been reseted.")
					end
				end
				
				if (newFrame.DevelopmentDebug) then
					print ("Details!", "MythicDungeonStarted() > State set to Mythic Dungeon, new combat starting in 10 seconds.")
				end
			end
			
			newFrame:SetScript ("OnEvent", function (_, event, ...)
				
				if (event == "CHALLENGE_MODE_START") then
					--> CHALLENGE_MODE_START does trigger every time the player enters a mythic dungeon already in progress
				
					if (newFrame.DevelopmentDebug) then
						print ("Details!", event, ...)
					end
					
					--> is this a mythic dungeon?
					local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo()
					
					if (newFrame.DevelopmentDebug) then
						print ("Details!", "Dungeon Dificulty:", difficulty, currentZoneID)
					end
					
					if (difficulty == 8) then
						--> start the dungeon on Details!
						newFrame.MythicDungeonStarted()
					end
					
				elseif (event == "CHALLENGE_MODE_COMPLETED") then
					if (newFrame.DevelopmentDebug) then
						print ("Details!", event, ...)
					end
					
					--> delay to wait the encounter_end trigger first
					--> assuming here the party cleaned the mobs kill objective before going to kill the last boss
					C_Timer.After (2, newFrame.MythicDungeonFinished)
					
				elseif (event == "ENCOUNTER_END") then
					if (newFrame.DevelopmentDebug) then
						print ("Details!", event, ...)
					end
					
					if (newFrame.IsDoingMythicDungeon) then
						local encounterID, encounterName, difficultyID, raidSize, endStatus = ...
						if (endStatus == 1) then
							newFrame.BossDefeated (false, encounterID, encounterName, difficultyID, raidSize, endStatus)
						else
							--> remove the boss table, so it will be considered trash
							if (self.tabela_vigente.is_boss) then
								--> check if is still in combat
								if (newFrame.DevelopmentDebug) then
									print ("Details!", "Boss Wipe, removing the boss table from the segment.")
								end
								if (self.in_combat) then
									if (newFrame.DevelopmentDebug) then
										print ("Details!", "Boss Wipe, was in combat, calling SairDoCombate().")
									end
									self:SairDoCombate()
								end
								self.tabela_vigente.is_boss = nil
							end
						end
					end
					
				elseif (event == "ZONE_CHANGED_NEW_AREA") then
					if (newFrame.IsDoingMythicDungeon) then
						if (newFrame.DevelopmentDebug) then
							print ("Details!", event, ...)
							print ("Zone changed and is Doing Mythic Dungeon")
						end
						local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo()
						if (currentZoneID ~= self.MythicPlus.DungeonID) then
							if (newFrame.DevelopmentDebug) then
								print ("Zone changed and the zone is different than the dungeon")
							end
							--> finish the segment
							newFrame.BossDefeated (true)
							
							--> finish the mythic run
							newFrame.MythicDungeonFinished()
						end
					end
					
				end
				
			end)
			

			--fazer a captura de dados para o gr�fico ao iniciar a corrida e parar ao sair da dungeon ou terminar a run.
			
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			self.parser_frame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")

	--> group
		self.details_users = {}
		self.in_group = IsInGroup() or IsInRaid()
		
	--> done
		self.initializing = nil
	
	--> scan pets
		_detalhes:SchedulePetUpdate (1)
	
	--> send messages gathered on initialization
		self:ScheduleTimer ("ShowDelayMsg", 10) 
	
	--> send instance open signal
		for index, instancia in _detalhes:ListInstances() do
			if (instancia.ativa) then
				self:SendEvent ("DETAILS_INSTANCE_OPEN", nil, instancia)
			end
		end

	--> send details startup done signal
		function self:AnnounceStartup()
			
			self:SendEvent ("DETAILS_STARTED", "SEND_TO_ALL")
			
			if (_detalhes.in_group) then
				_detalhes:SendEvent ("GROUP_ONENTER")
			else
				_detalhes:SendEvent ("GROUP_ONLEAVE")
			end
			
			_detalhes.last_zone_type = "INIT"
			_detalhes.parser_functions:ZONE_CHANGED_NEW_AREA()
			
			_detalhes.AnnounceStartup = nil

		end
		self:ScheduleTimer ("AnnounceStartup", 5)
		
		if (_detalhes.failed_to_load) then
			_detalhes:CancelTimer (_detalhes.failed_to_load)
			_detalhes.failed_to_load = nil
		end
		
		--function self:RunAutoHideMenu()
		--	local lower_instance = _detalhes:GetLowerInstanceNumber()
		--	local instance = self:GetInstance (lower_instance)
		--	instance:SetAutoHideMenu (nil, nil, true)
		--end
		--self:ScheduleTimer ("RunAutoHideMenu", 15)
		
	--> announce alpha version
		function self:AnnounceVersion()
			for index, instancia in _detalhes:ListInstances() do
				if (instancia.ativa) then
					self.gump:Fade (instancia._version, "in", 0.1)
				end
			end
		end
		
	--> check version
		_detalhes:CheckVersion (true)
		
	--> restore cooltip anchor position
		DetailsTooltipAnchor:Restore()
	
	--> check is this is the first run
		if (self.is_first_run) then
			if (#self.custom == 0) then
				_detalhes:AddDefaultCustomDisplays()
			end
			
			_detalhes:FillUserCustomSpells()
		end
		
	--> send feedback panel if the user got 100 or more logons with details
		if (self.tutorial.logons > 100) then --  and self.tutorial.logons < 104
			if (not self.tutorial.feedback_window1) then
				--> check if isn't inside an instance
				if (_detalhes:IsInCity()) then
					self.tutorial.feedback_window1 = true
					_detalhes:ShowFeedbackRequestWindow()
				end
			end
		end
	
	--> check is this is the first run of this version
		if (self.is_version_first_run) then

			local enable_reset_warning = true
		
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _detalhes:GetInstance (lower_instance)
				if (lower_instance and _detalhes.latest_news_saw ~= _detalhes.userversion) then
					lower_instance:InstanceAlert (Loc ["STRING_VERSION_UPDATE"], {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, 60, {_detalhes.OpenNewsWindow})
				end
			end
			
			_detalhes:FillUserCustomSpells()
			_detalhes:AddDefaultCustomDisplays()
			
			--> erase the custom for damage taken by spell
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 75 and enable_reset_warning) then
				if (_detalhes.global_plugin_database and _detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"]) then
					wipe (_detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"].encounter_timers_dbm)
					wipe (_detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"].encounter_timers_bw)
				end
			end
			
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 74 and enable_reset_warning) then
				function _detalhes:FixMonkSpecIcons()
					local m269 = _detalhes.class_specs_coords [269]
					local m270 = _detalhes.class_specs_coords [270]
					
					m269[1], m269[2], m269[3], m269[4] = 448/512, 512/512, 64/512, 128/512
					m270[1], m270[2], m270[3], m270[4] = 384/512, 448/512, 64/512, 128/512
				end
				_detalhes:ScheduleTimer ("FixMonkSpecIcons", 1)
			end
			
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 73 and enable_reset_warning) then
			
				local secure_func = function()
					for i = #_detalhes.custom, 1, -1 do
						local index = i
						local CustomObject = _detalhes.custom [index]
						
						if (CustomObject:GetName() == Loc ["STRING_CUSTOM_DTBS"]) then
							for o = 1, _detalhes.switch.slots do
								local options = _detalhes.switch.table [o]
								if (options and options.atributo == 5 and options.sub_atributo == index) then 
									options.atributo = 1
									options.sub_atributo = 8
									_detalhes.switch:Update()
								end
							end
						
							_detalhes.atributo_custom:RemoveCustom (index)
						end
					end
				end
				pcall (secure_func)
				
			end
			
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 70 and enable_reset_warning) then
				local bg = _detalhes.tooltip.background
				bg [1] = 0.1960
				bg [2] = 0.1960
				bg [3] = 0.1960
				bg [4] = 0.8697
				
				local border = _detalhes.tooltip.border_color
				border [1] = 1
				border [2] = 1
				border [3] = 1
				border [4] = 0
				
				--> refresh
				_detalhes:SetTooltipBackdrop()
			end
			
			--> check elvui for the new player detail skin
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 71 and enable_reset_warning) then
				function _detalhes:PDWElvuiCheck()
					_detalhes:ApplyPDWSkin ("ElvUI")
					
					_detalhes.class_specs_coords[62][1] = (128/512) + 0.001953125
					_detalhes.class_specs_coords[70][1] = (128/512) + 0.001953125
					_detalhes.class_specs_coords[258][1] = (320/512) + 0.001953125
				end
				_detalhes:ScheduleTimer ("PDWElvuiCheck", 2)
			end
			
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 69 and enable_reset_warning) then
				function _detalhes:PDWElvuiCheck()
					local ElvUI = _G.ElvUI
					if (ElvUI) then
						_detalhes:ApplyPDWSkin ("ElvUI")
					end
				end
				_detalhes:ScheduleTimer ("PDWElvuiCheck", 1)
			end
			
			--> Reset for the new structure
			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 66 and enable_reset_warning) then
				function _detalhes:ResetDataStorage()
					if (not IsAddOnLoaded ("Details_DataStorage")) then
						local loaded, reason = LoadAddOn ("Details_DataStorage")
						if (not loaded) then
							return
						end
					end
					
					local db = DetailsDataStorage
					if (db) then
						table.wipe (db)
					end
					
					DetailsDataStorage = _detalhes:CreateStorageDB()
				end
				_detalhes:ScheduleTimer ("ResetDataStorage", 1)
				
				_detalhes.segments_panic_mode = false
				
			end

			if (_detalhes_database.last_realversion and _detalhes_database.last_realversion < 47 and enable_reset_warning) then
				for i = #_detalhes.custom, 1, -1  do
					_detalhes.atributo_custom:RemoveCustom (i)
				end
				_detalhes:AddDefaultCustomDisplays()
			end

		end
	
	local lower = _detalhes:GetLowerInstanceNumber()
	if (lower) then
		local instance = _detalhes:GetInstance (lower)
		if (instance) then

			--in development
			local dev_icon = instance.bgdisplay:CreateTexture (nil, "overlay")
			dev_icon:SetWidth (40)
			dev_icon:SetHeight (40)
			dev_icon:SetPoint ("bottomleft", instance.baseframe, "bottomleft", 4, 8)
			dev_icon:SetAlpha (.3)
			
			local dev_text = instance.bgdisplay:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			dev_text:SetHeight (64)
			dev_text:SetPoint ("left", dev_icon, "right", 5, 0)
			dev_text:SetTextColor (1, 1, 1)
			dev_text:SetAlpha (.3)
			
			if (self.tutorial.logons < 50) then
				--dev_text:SetText ("Details is Under\nDevelopment")
				--dev_icon:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]])
			end
		
			--version
			self.gump:Fade (instance._version, 0)
			instance._version:SetText ("Details! " .. _detalhes.userversion .. " (core " .. self.realversion .. ")")
			instance._version:SetTextColor (1, 1, 1, .35)
			instance._version:SetPoint ("bottomleft", instance.baseframe, "bottomleft", 5, 1)

			if (instance.auto_switch_to_old) then
				instance:SwitchBack()
			end

			function _detalhes:FadeStartVersion()
				_detalhes.gump:Fade (dev_icon, "in", 2)
				_detalhes.gump:Fade (dev_text, "in", 2)
				self.gump:Fade (instance._version, "in", 2)
				
				if (_detalhes.switch.table) then
				
					local have_bookmark
					
					for index, t in ipairs (_detalhes.switch.table) do
						if (t.atributo) then
							have_bookmark = true
							break
						end
					end
					
					if (not have_bookmark) then
						function _detalhes:WarningAddBookmark()
							instance._version:SetText ("right click to set bookmarks.")
							self.gump:Fade (instance._version, "out", 1)
							function _detalhes:FadeBookmarkWarning()
								self.gump:Fade (instance._version, "in", 2)
							end
							_detalhes:ScheduleTimer ("FadeBookmarkWarning", 5)
						end
						_detalhes:ScheduleTimer ("WarningAddBookmark", 2)
					end
				end
				
			end
			
			_detalhes:ScheduleTimer ("FadeStartVersion", 12)
			
		end
	end
	
	function _detalhes:OpenOptionsWindowAtStart()
		--_detalhes:OpenOptionsWindow (_detalhes.tabela_instancias[1])
		--print (_G ["DetailsClearSegmentsButton1"]:GetSize())
		--_detalhes:OpenCustomDisplayWindow()
		--_detalhes:OpenWelcomeWindow()
	end
	_detalhes:ScheduleTimer ("OpenOptionsWindowAtStart", 2)
	--_detalhes:OpenCustomDisplayWindow()
	
	--> minimap
	pcall (_detalhes.RegisterMinimap, _detalhes)
	
	--> hot corner
	function _detalhes:RegisterHotCorner()
		_detalhes:DoRegisterHotCorner()
	end
	_detalhes:ScheduleTimer ("RegisterHotCorner", 5)
	
	--> get in the realm chat channel
	if (not _detalhes.schedule_chat_enter and not _detalhes.schedule_chat_leave) then
		_detalhes:ScheduleTimer ("CheckChatOnZoneChange", 60)
	end

	--> open profiler 
	_detalhes:OpenProfiler()
	
	--> start announcers
	_detalhes:StartAnnouncers()
	
	--> start aura
	_detalhes:CreateAuraListener()
	
	--> open welcome
	if (self.is_first_run) then
		_detalhes:OpenWelcomeWindow()
	end
	
	--_detalhes:OpenWelcomeWindow() --debug
	-- /run _detalhes:OpenWelcomeWindow()
	
	_detalhes:BrokerTick()
	
	--boss mobs callbacks
	_detalhes:ScheduleTimer ("BossModsLink", 5)
	
	--> limit item level life for 24Hs
	local now = time()
	for guid, t in pairs (_detalhes.item_level_pool) do
		if (t.time+86400 < now) then
			_detalhes.item_level_pool [guid] = nil
		end
	end
	
	--> dailly reset of the cache for talents and specs.
	local today = date ("%d")
	if (_detalhes.last_day ~= today) then
		wipe (_detalhes.cached_specs)
		wipe (_detalhes.cached_talents)
	end

	--> get the player spec
	C_Timer.After (2, _detalhes.parser_functions.PLAYER_SPECIALIZATION_CHANGED)

	_detalhes.chat_embed:CheckChatEmbed (true)
	
	--_detalhes:SetTutorialCVar ("MEMORY_USAGE_ALERT1", false)
	if (not _detalhes:GetTutorialCVar ("MEMORY_USAGE_ALERT1")) then
		function _detalhes:AlertAboutMemoryUsage()
			if (DetailsWelcomeWindow and DetailsWelcomeWindow:IsShown()) then
				return _detalhes:ScheduleTimer ("AlertAboutMemoryUsage", 30)
			end
			
			local f = _detalhes.gump:CreateSimplePanel (UIParent, 500, 290, Loc ["STRING_MEMORY_ALERT_TITLE"], "AlertAboutMemoryUsagePanel", {NoTUISpecialFrame = true, DontRightClickClose = true})
			f:SetPoint ("center", UIParent, "center", -200, 100)
			f.Close:Hide()
			_detalhes:SetFontColor (f.Title, "yellow")
			
			local gnoma = _detalhes.gump:CreateImage (f.TitleBar, [[Interface\AddOns\Details\images\icons2]], 104, 107, "overlay", {104/512, 0, 405/512, 1})
			gnoma:SetPoint ("topright", 0, 14)
			
			local logo = _detalhes.gump:CreateImage (f, [[Interface\AddOns\Details\images\logotipo]])
			logo:SetPoint ("topleft", -5, 15)
			logo:SetSize (512*0.4, 256*0.4)
			
			local text1 = Loc ["STRING_MEMORY_ALERT_TEXT1"]
			local text2 = Loc ["STRING_MEMORY_ALERT_TEXT2"]
			local text3 = Loc ["STRING_MEMORY_ALERT_TEXT3"]
			
			local str1 = _detalhes.gump:CreateLabel (f, text1)
			str1.width = 480
			str1.fontsize = 12
			str1:SetPoint ("topleft", 10, -100)
			
			local str2 = _detalhes.gump:CreateLabel (f, text2)
			str2.width = 480
			str2.fontsize = 12
			str2:SetPoint ("topleft", 10, -150)
			
			local str3 = _detalhes.gump:CreateLabel (f, text3)
			str3.width = 480
			str3.fontsize = 12
			str3:SetPoint ("topleft", 10, -200)
			
			local textbox = _detalhes.gump:CreateTextEntry (f, function()end, 350, 20, nil, nil, nil, _detalhes.gump:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			textbox:SetPoint ("topleft", 10, -250)
			textbox:SetText ([[www.curse.com/addons/wow/addons-cpu-usage]])
			textbox:SetHook ("OnEditFocusGained", function() textbox:HighlightText() end)
			
			local close_func = function()
				_detalhes:SetTutorialCVar ("MEMORY_USAGE_ALERT1", true)
				f:Hide()
			end
			local close = _detalhes.gump:CreateButton (f, close_func, 127, 20, Loc ["STRING_MEMORY_ALERT_BUTTON"], nil, nil, nil, nil, nil, nil, _detalhes.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
			close:SetPoint ("left", textbox, "right", 2, 0)
			
		end
		_detalhes:ScheduleTimer ("AlertAboutMemoryUsage", 30) --30
	end
	
	_detalhes.AddOnStartTime = GetTime()
	
	--_detalhes.player_details_window.skin = "ElvUI"
	if (_detalhes.player_details_window.skin ~= "ElvUI") then
		local reset_player_detail_window = function()
			_detalhes:ApplyPDWSkin ("ElvUI")
		end
		C_Timer.After (2, reset_player_detail_window)
	end
	
	_detalhes.tooltip.tooltip_max_abilities = 5
end

_detalhes.AddOnLoadFilesTime = GetTime()