local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;
	local functionsConfiguration = addonTable.functionsConfiguration;

	do
		local name = "shmoodude_druid_feral";
		local desc = "ShmooDude: Feral Druid";

		-- Store the information for the script
		addonTable.scriptInfo[name] = {
			SpecializationID = addonTable.DRUID_FERAL,
			ScriptAuthor = "ShmooDude",
			ScriptCredits = "Dhol",
			GuideLink = "http://fluiddruid.net/forum/viewtopic.php?f=3&t=5709",
			WoWVersion = 70205,
		};

		-- Set the preset builds for the script.
		addonTable.presetBuilds[name] = {
		};

		local code = [[
			# ShmooDude Feral and Guardian script
			###
			### Options:
			# Interrupt - Suggests use of interuptting abilities, including stuns/knockbacks on non-boss targets.
			#
			#
			# Not in Melee Range - Suggests movement abilities if available or a forward arrow if you're out of range.
			#
			#
			# Multiple-targets rotation - If this is disabled, the AoE icon is removed
			#
			#
			# Ashamane's Frenzy as main action - Puts the Ashamane's Frenzy suggestion in the main action box.
			#       Requires TimeToDie of 20 seconds or more
			#       If this is off, Ovale will suggest 2 CP Regrowths in the Short CD box.
			# Shadowmeld as main action - Puts the Shadowmeld suggestion in the main action box.
			#       Requires TimeToDie of 15 seconds or more
			#       Suggested off except on (raid) bosses.
			# Tiger's Fury multiplier prediction - Applies the Tiger's Fury multiplier if Tiger's Fury is ready.
			#       e.g. If TF is being suggested, any Rip suggestions will assume you use TF first.
			#
			# Prevent capping BrS charges - Will suggest Brutal Slash if you are about to reach max charges.
			#       Advantage: Helps not waste charges.  
			#       Disadvantage: Will probably not have 3 charges when AoE for the encounter shows up.
			# BrS at X targets - Minimum number of targets to suggest using Brutal Slash.
			#       This will use all available Brutal Slash charges.
			#       
			# Only suggest BrS when TF is up
			#       Good for Mythic+ to get the most out of your Brutal Slash charges
			#       Too much haste makes this sub-optimal
			# Try to sync Ashamane's Frenzy with Tiger's Fury
			#       Restricts Ashamane's Frenzy to only if Tiger's Fury is up or has more than 10 seconds remaining on the cooldown
			#       
			# Pooling Value - How high you will pool energy (in seconds to max energy)
			#       Lower will pool more agressively (higher energy)
			#       Adds 7 seconds with chatoyant_signet to whatever value
			# Rip - At how many seconds to overwrite a Rip
			#       Default 8
			#
			# Rake - At how many seconds to overwrite a Rake
			#       Default 7 or
			#               3 with Ailuro Pouncers Legendary, Soul of the Forest Talent, or you are not speced into Bloodtalons
			# Savage Roar - At how many seconds to overwrite Savage Roar
			#       Default 11 or
			#               7.2 without Jagged Wounds talent

			Include(ovale_common)
			Include(ovale_trinkets_mop)
			Include(ovale_trinkets_wod)
			Include(ovale_druid_spells)

			# Temporary Define until Ovale updated
			Define(brutal_slash_talent 21)
			Define(sephuzs_secret 132452)
			Define(kiljaedens_burning_wish 144259)

			AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=feral)
			AddCheckBox(opt_interrupt L(interrupt) default specialization=feral)
			AddCheckBox(opt_use_consumables "Suggest Potion" default specialization=feral)

			AddCheckBox(opt_ashamanes_frenzy_main_action "Ashamane's Frenzy as a main action" default specialization=feral)
			AddCheckBox(opt_shadowmeld_main_action "Shadowmeld as a main action" specialization=feral)

			AddCheckBox(opt_tigers_fury_multiplier_predict "Tiger's Fury multiplier prediction" default specialization=feral)
			AddCheckBox(opt_brutal_slash_use_at_three_always "Prevent capping BrS charges" specialization=feral)
			AddCheckBox(opt_brutal_slash_use_with_tigers_fury "Only suggest BrS when TF is up" specialization=feral)
			AddCheckBox(opt_sync_af_tf "Try to sync Ashamane's with TF" specialization=feral)

			AddListItem(opt_10_rake_refresh rake_00_default "Rake: Default (7; 3 w/ AP, SotF, !BT)" specialization=feral default)
			AddListItem(opt_10_rake_refresh rake_01_pandemic "Rake at Pandemic (3; 4.5 w/ !JW)" specialization=feral)
			AddListItem(opt_10_rake_refresh rake_05 "Rake at 5 seconds" specialization=feral)
			AddListItem(opt_10_rake_refresh rake_06 "Rake at 6 seconds" specialization=feral)
			AddListItem(opt_10_rake_refresh rake_07 "Rake at 7 seconds" specialization=feral)
			AddListItem(opt_10_rake_refresh rake_08 "Rake at 8 seconds" specialization=feral)
			AddListItem(opt_10_rake_refresh rake_09 "Rake at 9 seconds" specialization=feral)

			AddListItem(opt_11_rip_refresh rip_00_default "Rip: Default (8)" specialization=feral default)
			AddListItem(opt_11_rip_refresh rip_01_pandemic "Rip at Pandemic (4.8; 7.2 w/ !JW)" specialization=feral)
			AddListItem(opt_11_rip_refresh rip_05 "Rip at 5 seconds" specialization=feral)
			AddListItem(opt_11_rip_refresh rip_06 "Rip at 6 seconds" specialization=feral)
			AddListItem(opt_11_rip_refresh rip_07 "Rip at 7 seconds" specialization=feral)
			AddListItem(opt_11_rip_refresh rip_08 "Rip at 8 seconds" specialization=feral)
			AddListItem(opt_11_rip_refresh rip_09 "Rip at 9 seconds" specialization=feral)

			AddListItem(opt_12_savage_roar_refresh savage_roar_00_default "Savage Roar: Default (11; 7.2 w/ !JW)" specialization=feral default)
			AddListItem(opt_12_savage_roar_refresh savage_roar_01_pandemic "Savage Roar Pandemic (7.2)" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_08 "Savage Roar at 8 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_09 "Savage Roar at 9 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_10 "Savage Roar at 10 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_11 "Savage Roar at 11 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_12 "Savage Roar at 12 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_13 "Savage Roar at 13 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_14 "Savage Roar at 14 seconds" specialization=feral)
			AddListItem(opt_12_savage_roar_refresh savage_roar_15 "Savage Roar at 15 seconds" specialization=feral)

			AddListItem(opt_13_pooling_value pooling_value_00_default "Pooling: Default (75 energy)" specialization=feral default)
			AddListItem(opt_13_pooling_value pooling_value_65 "Pool to 65 energy" specialization=feral)
			AddListItem(opt_13_pooling_value pooling_value_70 "Pool to 70 energy" specialization=feral)
			AddListItem(opt_13_pooling_value pooling_value_75 "Pool to 75 energy" specialization=feral)
			AddListItem(opt_13_pooling_value pooling_value_80 "Pool to 80 energy" specialization=feral)
			AddListItem(opt_13_pooling_value pooling_value_85 "Pool to 85 energy" specialization=feral)

			AddListItem(opt_09_desired_targets desired_targets_02 "BrS at 2 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_03 "BrS at 3 targets" specialization=feral default)
			AddListItem(opt_09_desired_targets desired_targets_04 "BrS at 4 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_05 "BrS at 5 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_06 "BrS at 6 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_07 "BrS at 7 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_08 "BrS at 8 targets" specialization=feral)
			AddListItem(opt_09_desired_targets desired_targets_09 "BrS at 9 targets" specialization=feral)

			########################################
			### Helper Variables (Functions)     ###
			########################################

			#variable,name=RakePandemic,value=(15-0.33*15*talent.jagged_wounds.enabled)*0.3
			AddFunction RakePandemic
			{
				{ 15 - 0.33 * 15 * TalentPoints(jagged_wounds_talent) } * 0.3
			}
			#variable,name=RipPandemic,value=(24-0.33*24*talent.jagged_wounds.enabled)*0.3
			AddFunction RipPandemic
			{
				{ 24 - 0.33 * 24 * TalentPoints(jagged_wounds_talent) } * 0.3
			}
			#variable,name=ThrashCatPandemic,value=(15-0.33*15*talent.jagged_wounds.enabled)*0.3
			AddFunction ThrashCatPandemic
			{
				{ 15 - 0.33 * 15 * TalentPoints(jagged_wounds_talent) } * 0.3
			}
			#variable,name=RakeRefresh,value=7
			#variable,name=RakeRefresh,value=variable.RakePandemic,if=equipped.ailuro_pouncers|talent.soul_of_the_forest.enabled|!talent.bloodtalons.enabled
			AddFunction RakeRefresh
			{
				unless List(opt_10_rake_refresh rake_00_default)
				{
					if List(opt_10_rake_refresh rake_01_pandemic) RakePandemic()
					if List(opt_10_rake_refresh rake_05) 5
					if List(opt_10_rake_refresh rake_06) 6
					if List(opt_10_rake_refresh rake_07) 7
					if List(opt_10_rake_refresh rake_08) 8
					if List(opt_10_rake_refresh rake_09) 9
				}
				if HasEquippedItem(ailuro_pouncers) or Talent(soul_of_the_forest_talent) or not Talent(bloodtalons_talent) RakePandemic()
				7
			}
			#variable,name=RipRefresh,value=8
			AddFunction RipRefresh
			{
				unless List(opt_11_rip_refresh rip_00_default)
				{
					if List(opt_11_rip_refresh rip_01_pandemic) RipPandemic()
					if List(opt_11_rip_refresh rip_05) 5
					if List(opt_11_rip_refresh rip_06) 6
					if List(opt_11_rip_refresh rip_07) 7
					if List(opt_11_rip_refresh rip_08) 8
					if List(opt_11_rip_refresh rip_09) 9
				}
				8
			}
			#variable,name=SavageRoarRefresh,value=7.2
			#variable,name=SavageRoarRefresh,value=11,if=talent.jagged_wounds.enabled
			AddFunction SavageRoarRefresh
			{
				unless List(opt_12_savage_roar_refresh savage_roar_00_default)
				{
					if List(opt_12_savage_roar_refresh savage_roar_01_pandemic) RipPandemic()
					if List(opt_12_savage_roar_refresh savage_roar_08) 8
					if List(opt_12_savage_roar_refresh savage_roar_09) 9
					if List(opt_12_savage_roar_refresh savage_roar_10) 10
					if List(opt_12_savage_roar_refresh savage_roar_11) 11
					if List(opt_12_savage_roar_refresh savage_roar_12) 12
					if List(opt_12_savage_roar_refresh savage_roar_13) 13
					if List(opt_12_savage_roar_refresh savage_roar_14) 14
					if List(opt_12_savage_roar_refresh savage_roar_15) 15
				}
				if Talent(jagged_wounds_talent) 11
				7.2
			}
			#variable,name=PoolingValue,value=3
			#variable,name=PoolingValue,value=10,if=equipped.chatoyant_signet
			AddFunction PoolingValue
			{
				unless List(opt_13_pooling_value pooling_value_00_default)
				{
					if List(opt_13_pooling_value pooling_value_65) 65
					if List(opt_13_pooling_value pooling_value_70) 70
					if List(opt_13_pooling_value pooling_value_75) 75
					if List(opt_13_pooling_value pooling_value_80) 80
					if List(opt_13_pooling_value pooling_value_85) 85
				}
				75
			}
			#variable,name=ExecuteRange,value=25
			#variable,name=ExecuteRange,value=100,if=talent.sabertooth.enabled
			AddFunction ExecuteRange
			{
				if Talent(sabertooth_talent) 100
				25
			}
			#variable,name=BloodtalonsOverwriteStacks,value=2
			#variable,name=BloodtalonsOverwriteStacks,value=1,if=equipped.ailuro_pouncers
			AddFunction BloodtalonsOverwriteStacks
			{
				if HasEquippedItem(ailuro_pouncers) 1
				2
			}
			#variable,name=LotsOfEnergy,value=buff.berserk.up|buff.incarnation.up|cooldown.tigers_fury.remains<3|talent.soul_of_the_forest.enabled
			AddFunction LotsOfEnergy
			{
				BuffPresent(berserk_cat_buff) 
					or BuffPresent(incarnation_king_of_the_jungle_buff) 
					or SpellCooldown(tigers_fury) < 3 
					or Talent(soul_of_the_forest_talent)
			}
			#variable,name=ClearcastingLotsOfEnergy,value=variable.LotsOfEnergy|buff.clearcasting.react
			AddFunction ClearcastingLotsOfEnergy
			{
				LotsOfEnergy() 
					or BuffPresent(clearcasting_buff)
			}
			#variable,name=PoolEnergy,value=energy.time_to_max<variable.PoolingValue|variable.LotsOfEnergy
			AddFunction PoolEnergy
			{
				Energy() > PoolingValue() 
					or LotsOfEnergy()
			}
			#variable,name=ClearcastingPoolEnergy,value=variable.PoolEnergy|buff.clearcasting.react
			AddFunction ClearcastingPoolEnergy
			{
				PoolEnergy() 
					or BuffPresent(clearcasting_buff)
			}
			#variable,name=FinisherConditions,value=combo_points=5&(variable.PoolEnergy|buff.elunes_guidance.up|cooldown.ashamanes_frenzy.remains<1|!dot.rip.ticking|(dot.rake.remains<1.5&spell_targets.swipe_cat<6)|(spell_targets.brutal_slash>desired_targets&talent.brutal_slash.enabled))
			AddFunction FinisherConditions
			{
				ComboPoints() == 5 
					and { PoolEnergy() 
						or BuffPresent(elunes_guidance_buff) 
						or SpellCooldown(ashamanes_frenzy) < 1 
						or target.DebuffExpires(rip_debuff) 
						or target.DebuffRemaining(rake_debuff) < 1.5 and Enemies() < 6 
						or Enemies() > Enemies(tagged=1) and Talent(brutal_slash_talent) }
			}
			#variable,name=ThrashCatEnergyPooling,value=!dot.thrash_cat.ticking|variable.ClearcastingPoolEnergy
			AddFunction ThrashCatEnergyPooling
			{
				target.DebuffExpires(thrash_cat_debuff) 
					or ClearcastingPoolEnergy()
			}

			#variable,name=SwipeCatEnergyPooling,value=buff.scent_of_blood.up|variable.ClearcastingPoolEnergy
			AddFunction SwipeCatEnergyPooling
			{
				BuffPresent(scent_of_blood_buff) 
					or ClearcastingPoolEnergy()
			}
			#variable,name=BuffSavageRoarUp,value=buff.savage_roar.up|!talent.savage_roar.enabled
			AddFunction BuffSavageRoarUp
			{
				BuffPresent(savage_roar_buff) 
					or not Talent(savage_roar_talent)
			}
			#variable,name=BuffBloodtalonsUp,value=buff.bloodtalons.up|!talent.bloodtalons.enabled
			AddFunction BuffBloodtalonsUp
			{
				BuffPresent(bloodtalons_buff) or not Talent(bloodtalons_talent)
			}
			#desired_targets
			AddFunction BrutalSlashDesiredTargets asvalue=1
			{
				if List(opt_09_desired_targets desired_targets_02) 2
				if List(opt_09_desired_targets desired_targets_03) 3
				if List(opt_09_desired_targets desired_targets_04) 4
				if List(opt_09_desired_targets desired_targets_05) 5
				if List(opt_09_desired_targets desired_targets_06) 6
				if List(opt_09_desired_targets desired_targets_07) 7
				if List(opt_09_desired_targets desired_targets_08) 8
				if List(opt_09_desired_targets desired_targets_09) 9
			}
			#trinket
			AddFunction FeralUseItemActions
			{
				Item(Trinket0Slot text=13 usable=1)
				Item(Trinket1Slot text=14 usable=1)
			}
			#potion
			AddFunction FeralPotionActions
			{
				Item(old_war_potion usable=1)
				Item(prolonged_power_potion usable=1)
			}
			#melee_range
			AddFunction FeralGetInMeleeRange
			{
				if CheckBoxOn(opt_melee_range) and target.InRange(shred no)
				{
					#wild_charge
					if target.InRange(wild_charge) Spell(wild_charge)
					#displacer_beast,if=movement.distance>25
					if target.distance() > 25 Spell(displacer_beast)
					#dash,if=movement.distance>25&buff.displacer_beast.down&buff.wild_charge_movement.down
					if target.distance() > 25 and BuffExpires(displacer_beast_buff) Spell(dash)
					Texture(misc_arrowlup help=L(not_in_melee_range))
				}
			}
			#interrupt
			AddFunction FeralInterruptActions
			{
				if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
				{
					if target.InRange(skull_bash) Spell(skull_bash)
					if not target.Classification(worldboss)
					{
						if target.InRange(mighty_bash) Spell(mighty_bash)
						if target.distance() < 20 Spell(typhoon)
						if target.InRange(maim) Spell(maim)
						if target.distance() < 8 Spell(war_stomp)
					}
				}
			}
			#Tiger's Fury multiplier prediction 
			AddFunction TFMultPred asvalue=1
			{
				if CheckBoxOn(opt_tigers_fury_multiplier_predict) 
					and BuffExpires(tigers_fury_buff)
					and SpellCooldown(tigers_fury) <= 0
					and { TigersFury_Main() or TigersFury_Sabertooth() } 1.15
				1
			}


			########################################
			### Main Action List                 ###
			########################################

			#dash,if=!buff.cat_form.up
			#cat_form
			#variable,name=Rake_Prowl,value=buff.prowl.up|buff.shadowmeld.up
			#rake,if=variable.Rake_Prowl
			AddFunction Rake_Prowl
			{
				BuffPresent(prowl_buff) 
					or BuffPresent(shadowmeld_buff)
			}
			#auto_attack
			#variable,name=Berserk_Main,value=buff.ashamanes_energy.up|(equipped.convergence_of_fates&energy>=35)
			#berserk,if=variable.Berserk_Main
			# MODIFICATION: SpellCooldown(tigers_fury) <= 0 and { TigersFury_Main() or TigersFury_Sabertooth() }
			# REASON: Make Berserk show up if Tiger's Fury conditions are met
			AddFunction Berserk_Main
			{
				BuffPresent(ashamanes_energy_buff) 
					or HasEquippedItem(convergence_of_fates) and Energy() >= 35
					or SpellCooldown(tigers_fury) <= 0 
						and { TigersFury_Main() or TigersFury_Sabertooth() }
			}
			#variable,name=Incarnation_Main,value=buff.ashamanes_energy.up|energy>=35
			#incarnation,if=variable.Incarnation_Main
			# MODIFICATION: SpellCooldown(tigers_fury) <= 0 and { TigersFury_Main() or TigersFury_Sabertooth() }
			# REASON: Make Incarnation show up if Tiger's Fury conditions are met
			AddFunction Incarnation_Main
			{
				BuffPresent(ashamanes_energy_buff) 
					or Energy() >= 35
					or SpellCooldown(tigers_fury) <= 0 
						and { TigersFury_Main() or TigersFury_Sabertooth() }
			}
			#variable,name=Trinket_Main,value=(buff.tigers_fury.up&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|buff.incarnation.remains>20
			#use_item,slot=trinket1,if=variable.Trinket_Main
			AddFunction Trinket_Main
			{
				HasEquippedItem(kiljaedens_burning_wish)
					or { BuffPresent(tigers_fury_buff) 
						and { target.TimeToDie() > BuffCooldownDuration(trinket_stat_any_buff) or target.TimeToDie() < 45 } 
							or BuffRemaining(incarnation_king_of_the_jungle_buff) > 20 }
			}
			#variable,name=Potion_Main,value=((buff.berserk.remains>10|buff.incarnation.remains>20)&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
			#potion,name=old_war,if=variable.Potion_Main
			AddFunction Potion_Main
			{
				{ BuffRemaining(berserk_cat_buff) > 10 or BuffRemaining(incarnation_king_of_the_jungle_buff) > 20 } 
					and { target.TimeToDie() < 180 or BuffPresent(trinket_proc_any_buff) and target.HealthPercent() < 25 } 
					or target.TimeToDie() <= 40
			}
			#variable,name=TigersFury_Main,value=(!buff.clearcasting.react&energy.deficit>=60)|energy.deficit>=80
			#tigers_fury,if=variable.TigersFury_Main
			AddFunction TigersFury_Main
			{
				BuffExpires(clearcasting_buff) and EnergyDeficit() >= 60 
					or EnergyDeficit() >= 80
					or TimeInCombat() < 8 and BuffPresent(savage_roar_buff) and target.Classification(worldboss)
			}
			# MODIFICATION: Predator TF
			# REASON: Suggest TF anytime its ready if TF is already up to maximize buff uptime.
			AddFunction TigersFury_Predator
			{
				UnitInRaid() 
					and Talent(predator_talent) 
					and BuffPresent(tigers_fury_buff)
			}
			#variable,name=FerociousBite_3SecondRefresh,value=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>3&target.health.pct<variable.ExecuteRange
			#ferocious_bite,cycle_targets=1,if=variable.FerociousBite_3SecondRefresh
			AddFunction FerociousBite_3SecondRefresh
			{
				target.DebuffPresent(rip_debuff) 
					and target.DebuffRemaining(rip_debuff) < 3 
					and target.TimeToDie() > 3 
					and target.HealthPercent() < ExecuteRange()
			}
			#variable,name=RegrowthConditions,value=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.stack<variable.BloodtalonsOverwriteStacks
			#variable,name=Regrowth_PredatorySwiftness_Expires,value=buff.predatory_swiftness.remains<1.5
			#variable,name=Regrowth_AshamanesFrenzy,value=combo_points=2&buff.bloodtalons.down&cooldown.ashamanes_frenzy.remains<gcd&(buff.savage_roar.remains>(3+gcd)|!talent.savage_roar.enabled)
			#regrowth,if=variable.RegrowthConditions&(variable.Regrowth_PredatorySwiftness_Expires|variable.Regrowth_AshamanesFrenzy)
			AddFunction RegrowthConditions
			{
				Talent(bloodtalons_talent) 
					and BuffPresent(predatory_swiftness_buff) 
					and BuffStacks(bloodtalons_buff) < BloodtalonsOverwriteStacks()
			}

			AddFunction Regrowth_PredatorySwiftness_Expires
			{
				BuffRemaining(predatory_swiftness_buff) < 1.5
			}
			# MODIFICATION: CheckBoxOn(opt_ashamanes_frenzy_main_action) in Regrowth_AshamanesFrenzy
			# MODIFICATION: Regrowth_AshamanesFrenzy_ShortCd for CheckBoxOff(opt_ashamanes_frenzy_main_action)
			# REASON: Allows player to choose via checkbox whether to add Ashamane's Frenzy to the Main Icon
			# MODIFICATION: target.TimeToDie() > 21
			# REASON: Does not use Regrowth for Ashamane's Frenzy on targets with less than 21 seconds to live
			AddFunction Regrowth_AshamanesFrenzy
			{
				CheckBoxOn(opt_ashamanes_frenzy_main_action)
					and ComboPoints() == 2 
					and BuffExpires(bloodtalons_buff) 
					and SpellCooldown(ashamanes_frenzy) < GCD()
					and { BuffRemaining(savage_roar_buff) > 3 + GCD() or not Talent(savage_roar_talent) }
					and target.TimeToDie() > 21
					and { CheckBoxOff(opt_sync_af_tf) 
						or CheckBoxOn(opt_sync_af_tf)
							and { BuffRemaining(tigers_fury_buff) > 5 or SpellCooldown(tigers_fury) >= 11 } }
			}
			AddFunction Regrowth_AshamanesFrenzy_ShortCd
			{
				CheckBoxOff(opt_ashamanes_frenzy_main_action)
					and ComboPoints() == 2 
					and BuffExpires(bloodtalons_buff) 
					and SpellCooldown(ashamanes_frenzy) < GCD()
					and { BuffRemaining(savage_roar_buff) > 3 + GCD() or not Talent(savage_roar_talent) }
					and target.TimeToDie() > 21
					and { CheckBoxOff(opt_sync_af_tf) 
						or CheckBoxOn(opt_sync_af_tf)
							and { BuffRemaining(tigers_fury_buff) > 5 or SpellCooldown(tigers_fury) >= 11 } }
			}
			#variable,name=AshamanesFrenzy_Main,value=combo_points<=2&buff.elunes_guidance.down&variable.BuffBloodtalonsUp&variable.BuffSavageRoarUp
			#ashamanes_frenzy,if=variable.AshamanesFrenzy_Main
			# MODIFICATION: CheckBoxOn(opt_ashamanes_frenzy_main_action) in AshamanesFrenzy_Main
			# MODIFICATION: Regrowth_AshamanesFrenzy_ShortCd for CheckBoxOff(opt_ashamanes_frenzy_main_action)
			# REASON: Allows player to choose via checkbox whether to add Ashamane's Frenzy to the Main Icon
			# MODIFICATION: target.TimeToDie() > 20
			# REASON: Does not use Ashamane's Frenzy on targets with less than 20 seconds to live
			AddFunction AshamanesFrenzy_Main
			{
				CheckBoxOn(opt_ashamanes_frenzy_main_action)
					and ComboPoints() <= 2 
					and BuffExpires(elunes_guidance_buff) 
					and BuffBloodtalonsUp() 
					and BuffSavageRoarUp()
					and target.TimeToDie() > 20
					and { CheckBoxOff(opt_sync_af_tf) 
						or CheckBoxOn(opt_sync_af_tf)
							and { BuffRemaining(tigers_fury_buff) > 4 or SpellCooldown(tigers_fury) >= 10 } }
			}
			AddFunction AshamanesFrenzy_ShortCd
			{
				CheckBoxOff(opt_ashamanes_frenzy_main_action)
					and ComboPoints() <= 2 
					and BuffExpires(elunes_guidance_buff) 
					and BuffBloodtalonsUp() 
					and BuffSavageRoarUp()
					and target.TimeToDie() > 20
					and { CheckBoxOff(opt_sync_af_tf) 
						or CheckBoxOn(opt_sync_af_tf)
							and { BuffRemaining(tigers_fury_buff) > 4 or SpellCooldown(tigers_fury) >= 10 } }
			}
			#call_action_list,name=ElunesGuidance,if=talent.elunes_guidance.enabled
			###
			### ElunesGuidance Action List defined after Main Action List
			###
			#variable,name=Regrowth_SavageRoar_Down,value=variable.RegrowthConditions&talent.savage_roar.enabled&buff.savage_roar.down&combo_points=5
			#regrowth,if=variable.Regrowth_SavageRoar_Down
			AddFunction Regrowth_SavageRoar_Down
			{
				RegrowthConditions() 
					and Talent(savage_roar_talent) 
					and BuffExpires(savage_roar_buff) 
					and ComboPoints() == 5
			}
			#variable,name=SavageRoar_Down,value=buff.savage_roar.down&(variable.FinisherConditions|time<8)
			#savage_roar,if=variable.SavageRoar_Down
			AddFunction SavageRoar_Down
			{
				BuffExpires(savage_roar_buff) 
					and { FinisherConditions() or TimeInCombat() < 8 }
			}
			#variable,name=Regrowth_Pouncers,value=equipped.ailuro_pouncers&talent.bloodtalons.enabled&(buff.predatory_swiftness.stack>2|(buff.predatory_swiftness.stack>1&dot.rake.remains<3))&buff.bloodtalons.down
			#regrowth,if=variable.Regrowth_Pouncers
			AddFunction Regrowth_Pouncers
			{
				HasEquippedItem(ailuro_pouncers) 
					and Talent(bloodtalons_talent) 
					and { BuffStacks(predatory_swiftness_buff) > 2 
						or BuffStacks(predatory_swiftness_buff) > 1 and target.DebuffRemaining(rake_debuff) < 3 } 
					and BuffExpires(bloodtalons_buff)
			}
			#call_action_list,name=AoeFinishers,if=active_enemies>1
			########################################
			### BEGIN AoeFinishers Action List   ###
			########################################
			#variable,name=SavageRoar_BrutalSlash,value=talent.brutal_slash.enabled&buff.savage_roar.down&spell_targets.brutal_slash>desired_targets&action.brutal_slash.charges>=1
			#savage_roar,if=variable.SavageRoar_BrutalSlash
			AddFunction SavageRoar_BrutalSlash
			{
				Talent(brutal_slash_talent) 
					and BuffExpires(savage_roar_buff) 
					and Enemies() > Enemies() 
					and Charges(brutal_slash) >= 1
					and { BuffPresent(tigers_fury_buff) or CheckBoxOff(opt_brutal_slash_use_with_tigers_fury) }
			}
			#variable,name=ThrashCat_5Targets,value=spell_targets.thrash_cat>=5&dot.thrash_cat.remains<=variable.ThrashCatPandemic&variable.ThrashCatEnergyPooling
			#thrash_cat,cycle_targets=1,if=variable.ThrashCat_5Targets
			AddFunction ThrashCat_5Targets
			{
				Enemies() >= 5 
					and target.DebuffRemaining(thrash_cat_debuff) <= ThrashCatPandemic() 
					and ThrashCatEnergyPooling()
			}
			#variable,name=SwipeCat_8Targets,value=spell_targets.swipe_cat>=8&variable.SwipeCatEnergyPooling
			#swipe_cat,if=variable.SwipeCat_8Targets
			AddFunction SwipeCat_8Targets
			{
				Enemies() >= 8 
					and SwipeCatEnergyPooling()
			}
			########################################
			### END AoeFinishers Action List     ###
			########################################
			#variable,name=Regrowth_5CPs,value=variable.RegrowthConditions&combo_points=5
			#regrowth,if=variable.Regrowth_5CPs
			AddFunction Regrowth_5CPs
			{
				RegrowthConditions() 
					and ComboPoints() == 5
			}
			########################################
			### BEGIN Finishers Action List      ###
			########################################
			#call_action_list,name=Finishers,if=variable.FinisherConditions
			#variable,name=Maim_3Targets,value=spell_targets.maim>=3&buff.fiery_red_maimers.up&variable.BuffSavageRoarUp&variable.BuffBloodtalonsUp
			#maim,if=variable.Maim_3Targets
			AddFunction Maim_3Targets
			{
				Enemies() >= 3 
					and BuffPresent(fiery_red_maimers_buff) 
					and BuffSavageRoarUp() 
					and BuffBloodtalonsUp()
			}
			#variable,name=TigersFury_Sabertooth,value=talent.sabertooth.enabled&time<20&!dot.rip.ticking&combo_points=5
			#tigers_fury,if=variable.TigersFury_Sabertooth
			AddFunction TigersFury_Sabertooth
			{
				Talent(sabertooth_talent) 
					and TimeInCombat() < 20 
					and target.DebuffExpires(rip_debuff) 
					and ComboPoints() == 5
			}
			#variable,name=Rip_Main,value=(!dot.rip.ticking|(dot.rip.remains<variable.RipRefresh&target.health.pct>variable.ExecuteRange)|action.rip.persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die-dot.rip.remains>action.rip.tick_time*4
			#rip,cycle_targets=1,if=variable.Rip_Main
			# MODIFICATION: TFMultPred when CheckBoxOn(opt_tigers_fury_multiplier_predict)
			# REASON: When Tiger's Fury is suggested, treat Rip as if it is already up even if it hasn't been cast yet.
			AddFunction Rip_Main
			{
				{ target.DebuffExpires(rip_debuff) 
						or target.DebuffRemaining(rip_debuff) < RipRefresh() and target.HealthPercent() > ExecuteRange() 
						or TFMultPred() * PersistentMultiplier(rip_debuff) > target.DebuffPersistentMultiplier(rip_debuff) } 
					and target.TimeToDie() - target.DebuffRemaining(rip_debuff) > target.TickTime(rip_debuff) * 4
			}
			#variable,name=FerociousBite_9SecondRefresh,value=dot.rip.remains<variable.RipRefresh&target.health.pct<variable.ExecuteRange
			#ferocious_bite,max_energy=1,cycle_targets=1,if=variable.FerociousBite_9SecondRefresh
			AddFunction FerociousBite_9SecondRefresh
			{
				target.DebuffPresent(rip_debuff) 
					and target.DebuffRemaining(rip_debuff) < RipRefresh() 
					and target.HealthPercent() < ExecuteRange()
			}
			#variable,name=SavageRoar_Main,value=(buff.savage_roar.remains<=7.2|(buff.savage_roar.remains<variable.SavageRoarRefresh&target.health.pct>=variable.ExecuteRange))
			#savage_roar,if=variable.SavageRoar_Main
			AddFunction SavageRoar_Main
			{
				BuffRemaining(savage_roar_buff) <= 7.2 
					or BuffRemaining(savage_roar_buff) < SavageRoarRefresh() and target.HealthPercent() >= ExecuteRange()
			}
			#variable,name=Maim_Main,value=buff.fiery_red_maimers.up&variable.BuffSavageRoarUp&variable.BuffBloodtalonsUp
			#maim,if=variable.Maim_Main
			AddFunction Maim_Main
			{
				BuffPresent(fiery_red_maimers_buff) 
					and BuffSavageRoarUp() 
					and BuffBloodtalonsUp()
			}
			#ferocious_bite,max_energy=1
			#
			# No Function Required
			#
			########################################
			### END Finishers Action List        ###
			########################################
			#call_action_list,name=Generators,if=combo_points<5
			########################################
			### BEGIN Generators Action List     ###
			########################################
			#variable,name=BrutalSlash_Main,value=spell_targets.brutal_slash>desired_targets
			#brutal_slash,if=variable.BrutalSlash_Main
			AddFunction BrutalSlash_Main
			{
				Enemies() >= BrutalSlashDesiredTargets()
					and { BuffPresent(tigers_fury_buff) or CheckBoxOff(opt_brutal_slash_use_with_tigers_fury) }
			}
			#variable,name=ThrashCat_Spam,value=talent.brutal_slash.enabled&spell_targets.thrash_cat>=9
			#thrash_cat,if=variable.ThrashCat_Spam
			AddFunction ThrashCat_Spam
			{
				Talent(brutal_slash_talent) and Enemies() >= 9
			}
			#variable,name=SwipeCat_6Targets,value=spell_targets.swipe_cat>=6&variable.SwipeCatEnergyPooling
			#swipe_cat,if=variable.SwipeCat_6Targets
			AddFunction SwipeCat_6Targets
			{
				Enemies() >= 6 and SwipeCatEnergyPooling()
			}
			#variable,name=Shadowmeld_Main,value=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<1.9&buff.tigers_fury.up&variable.BuffSavageRoarUp&variable.BuffBloodtalonsUp&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
			#shadowmeld,if=variable.Shadowmeld_Main
			# MODIFICATION: target.TimeToDie() > BaseDuration(rake_debuff) + 5
			# REASON: Does not use Shadowmeld on targets with less than 15/20 seconds to live
			# MODIFICATION: target.InRange(rake)
			# REASON: Cannot move after Shadowmeld so add range check before suggesting
			# MODIFICATION: CheckBoxOn(opt_shadowmeld_main_action) in Shadowmeld_Main
			# MODIFICATION: Shadowmeld_Cd for CheckBoxOff(opt_shadowmeld_main_action)
			# REASON: Allows player to choose via checkbox whether to add Shadowmeld to the Main Icon
			# MODIFICATION: TFMultPred() > 1 in addition to BuffPresent(tigers_fury_buff) for CheckBoxOn(opt_tigers_fury_multiplier_predict)
			# REASON: When Tiger's Fury is suggested, treat Shadowmeld as if it is already up even if it hasn't been cast yet.
			AddFunction Shadowmeld_Main
			{
				CheckBoxOn(opt_shadowmeld_main_action)
					and ComboPoints() < 5
					and Energy() >= PowerCost(rake) 
					and target.DebuffPersistentMultiplier(rake_debuff) < 1.9 
					and { BuffPresent(tigers_fury_buff) or TFMultPred() > 1 }
					and BuffSavageRoarUp() 
					and BuffBloodtalonsUp() 
					and { not Talent(incarnation_talent) or SpellCooldown(incarnation_king_of_the_jungle) > 18 } 
					and BuffExpires(incarnation_king_of_the_jungle_buff)
					and target.TimeToDie() > BaseDuration(rake_debuff) + 5
					and target.InRange(rake)
			}
			AddFunction Shadowmeld_Cd
			{
				CheckBoxOff(opt_shadowmeld_main_action) 
					and ComboPoints() < 5
					and Energy() >= PowerCost(rake) 
					and target.DebuffPersistentMultiplier(rake_debuff) < 1.9 
					and BuffPresent(tigers_fury_buff) 
					and BuffSavageRoarUp() 
					and BuffBloodtalonsUp() 
					and { not Talent(incarnation_talent) or SpellCooldown(incarnation_king_of_the_jungle) > 18 } 
					and BuffExpires(incarnation_king_of_the_jungle_buff)
					and target.TimeToDie() > BaseDuration(rake_debuff) + 5
					and target.InRange(rake)
			}
			#variable,name=Rake_Main,value=(!dot.rake.ticking|(variable.BuffBloodtalonsUp&dot.rake.remains<=variable.RakeRefresh&action.rake.persistent_multiplier>dot.rake.pmultiplier*0.80))&target.time_to_die-dot.rake.remains>action.rake.tick_time
			#rake,cycle_targets=1,if=variable.Rake_Main
			# MODIFICATION: TFMultPred when CheckBoxOn(opt_tigers_fury_multiplier_predict)
			# REASON: When Tiger's Fury is suggested, treat Rip as if it is already up even if it hasn't been cast yet.
			AddFunction Rake_Main
			{
				{ target.DebuffExpires(rake_debuff) 
						or BuffBloodtalonsUp() and target.DebuffRemaining(rake_debuff) <= RakeRefresh() and TFMultPred() * PersistentMultiplier(rake_debuff) > target.DebuffPersistentMultiplier(rake_debuff) * 0.8 } 
					and target.TimeToDie() - target.DebuffRemaining(rake_debuff) > target.TickTime(rake_debuff)
			}
			#variable,name=MoonfireCat_Main,value=dot.moonfire_cat.remains<=4.2&target.time_to_die-dot.moonfire_cat.remains>action.moonfire_cat.tick_time*2
			#moonfire_cat,cycle_targets=1,if=variable.MoonfireCat_Main
			AddFunction MoonfireCat_Main
			{
				target.DebuffRemaining(moonfire_cat_debuff) <= 4.2 
					and target.TimeToDie() - target.DebuffRemaining(moonfire_cat_debuff) > target.TickTime(moonfire_cat_debuff) * 2
			}
			#variable,name=ThrashCat_Tier19_4pc,value=set_bonus.tier19_4pc&dot.thrash_cat.remains<=variable.ThrashCatPandemic&((buff.clearcasting.react&buff.bloodtalons.down)|(variable.ClearcastingLotsOfEnergy&equipped.luffa_wrappings))
			#thrash_cat,cycle_targets=1,if=variable.ThrashCat_Tier19_4pc
			AddFunction ThrashCat_Tier19_4pc
			{
				ArmorSetBonus(T19 4) 
					and target.DebuffRemaining(thrash_cat_debuff) <= ThrashCatPandemic() 
					and { BuffPresent(clearcasting_buff) and { HasEquippedItem(ailuro_pouncers) or BuffExpires(bloodtalons_buff) } 
						or ClearcastingLotsOfEnergy() and HasEquippedItem(luffa_wrappings) }
			}
			#variable,name=ThrashCat_NoTier19_4pc,value=!set_bonus.tier19_4pc&dot.thrash_cat.remains<=variable.ThrashCatPandemic&(buff.clearcasting.react&equipped.luffa_wrappings&(equipped.ailuro_pouncers|buff.bloodtalons.down))
			#thrash_cat,cycle_targets=1,if=variable.ThrashCat_NoTier19_4pc
			AddFunction ThrashCat_NoTier19_4pc
			{
				not ArmorSetBonus(T19 4) 
					and target.DebuffRemaining(thrash_cat_debuff) <= ThrashCatPandemic() 
					and BuffPresent(clearcasting_buff) 
					and HasEquippedItem(luffa_wrappings) 
					and { HasEquippedItem(ailuro_pouncers) or BuffExpires(bloodtalons_buff) }
			}
			#variable,name=ThrashCat_2Targets,value=dot.thrash_cat.remains<=variable.ThrashCatPandemic&spell_targets.thrash_cat>=2&variable.ThrashCatEnergyPooling
			#thrash_cat,cycle_targets=1,if=variable.ThrashCat_2Targets
			AddFunction ThrashCat_2Targets
			{
				target.DebuffRemaining(thrash_cat_debuff) <= ThrashCatPandemic() 
					and Enemies() >= 2 
					and ThrashCatEnergyPooling()
			}
			#variable,name=BrutalSlash_3Charges,value=charges_fractional>2.66
			#brutal_slash,if=variable.BrutalSlash_3Charges
			# MODIFICATION: CheckBoxOn(opt_brutal_slash_use_at_three_always)
			# REASON: Allows a player to pool to full charges
			AddFunction BrutalSlash_3Charges
			{
				CheckBoxOn(opt_brutal_slash_use_at_three_always)
					and Charges(brutal_slash count=0) > 2.66 
			}
			#variable,name=SwipeCat_Main,value=spell_targets.swipe_cat>=3&variable.SwipeCatEnergyPooling
			#swipe_cat,if=variable.SwipeCat_Main
			AddFunction SwipeCat_Main
			{
				Enemies() >= 3 and SwipeCatEnergyPooling()
			}
			#variable,name=Shred_Main,value=(spell_targets.swipe_cat<3|talent.brutal_slash.enabled)&((dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen&combo_points<3)|variable.ClearcastingPoolEnergy)
			#shred,if=variable.Shred_Main
			AddFunction Shred_Main
			{
				{ Enemies() < 3 or Talent(brutal_slash_talent) } 
					and { target.DebuffRemaining(rake_debuff) > { PowerCost(shred) + PowerCost(rake) - Energy() } / EnergyRegenRate() and ComboPoints() < 3 
						or ClearcastingPoolEnergy() }
			}
			########################################
			### END Generators Action List       ###
			########################################
			########################################
			### END Main Action List             ###
			########################################



			########################################
			### BEGIN ElunesGuidance Action List ###
			########################################
			#variable,name=ElunesGuidance_Regrowth,value=talent.elunes_guidance.enabled&variable.RegrowthConditions&((cooldown.elunes_guidance.remains<gcd&combo_points=0)|(buff.elunes_guidance.up&combo_points>=4))
			#regrowth,if=variable.ElunesGuidance_Regrowth
			# MODIFICATION: Split into main and short cd action lists
			# REASON: Regrowth for EG should be in cooldown box similar to Ashamane's Frenzy
			AddFunction ElunesGuidance_Regrowth_Main
			{
				Talent(elunes_guidance_talent) 
					and RegrowthConditions() 
					and BuffPresent(elunes_guidance_buff) and ComboPoints() >= 4
			}
			AddFunction ElunesGuidance_Regrowth_ShortCd
			{
				Talent(elunes_guidance_talent) 
					and RegrowthConditions() 
					and SpellCooldown(elunes_guidance) < GCD() and ComboPoints() == 0 
			}
			#variable,name=ElunesGuidance_Pooling,value=talent.elunes_guidance.enabled&combo_points=0&energy<action.ferocious_bite.cost+25-energy.regen*cooldown.elunes_guidance.remains
			#pool_resource,if=variable.ElunesGuidance_Pooling
			# MODIFICATION: PowerCost(ferocious_bite) + 25 to EnergyCost(ferocious_bite max=1)
			# REASON: Ovale Calculates this automatically
			AddFunction ElunesGuidance_Pooling
			{
				Talent(elunes_guidance_talent) 
					and ComboPoints() == 0 
					and Energy() < EnergyCost(ferocious_bite max=1) - EnergyRegenRate() * SpellCooldown(elunes_guidance)
			}
			#variable,name=ElunesGuidance_Main,value=talent.elunes_guidance.enabled&combo_points=0&energy>=action.ferocious_bite.cost+25
			#elunes_guidance,if=variable.ElunesGuidance_Main
			# MODIFICATION: PowerCost(ferocious_bite) + 25 to EnergyCost(ferocious_bite max=1)
			# REASON: Ovale Calculates this automatically
			AddFunction ElunesGuidance_Main
			{
				Talent(elunes_guidance_talent) 
					and ComboPoints() == 0 
					and Energy() >= EnergyCost(ferocious_bite max=1)
			}
			########################################
			### END ElunesGuidance Action List   ###
			########################################

			### actions.AoeFinishers

			AddFunction FeralAoeFinishersMainActions
			{
				#variable,name=SavageRoar_BrutalSlash,value=talent.brutal_slash.enabled&buff.savage_roar.down&spell_targets.brutal_slash>desired_targets&action.brutal_slash.charges>=1
				#pool_resource,for_next=1
				#savage_roar,if=variable.SavageRoar_BrutalSlash
				if SavageRoar_BrutalSlash() Spell(savage_roar)
				unless SavageRoar_BrutalSlash() and SpellUsable(savage_roar) and SpellCooldown(savage_roar) < TimeToEnergyFor(savage_roar)
				{
					#variable,name=ThrashCat_5Targets,value=spell_targets.thrash_cat>=5&dot.thrash_cat.remains<=variable.ThrashCatPandemic&variable.ThrashCatEnergyPooling
					#pool_resource,for_next=1
					#thrash_cat,cycle_targets=1,if=variable.ThrashCat_5Targets
					if ThrashCat_5Targets() Spell(thrash_cat)
					unless ThrashCat_5Targets() and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
					{
						#variable,name=SwipeCat_8Targets,value=spell_targets.swipe_cat>=8&variable.SwipeCatEnergyPooling
						#pool_resource,for_next=1
						#swipe_cat,if=variable.SwipeCat_8Targets
						if SwipeCat_8Targets() Spell(swipe_cat)
					}
				}
			}

			AddFunction FeralAoeFinishersMainPostConditions
			{
			}

			### actions.Finishers

			AddFunction FeralFinishersMainActions
			{
				#variable,name=Maim_3Targets,value=spell_targets.maim>=3&buff.fiery_red_maimers.up&variable.BuffBloodtalonsUp
				#pool_resource,for_next=1
				#maim,if=variable.Maim_3Targets
				if Maim_3Targets() Spell(maim)
				unless Maim_3Targets() and SpellUsable(maim) and SpellCooldown(maim) < TimeToEnergyFor(maim)
				{
					#variable,name=Rip_Main,value=(!dot.rip.ticking|(dot.rip.remains<variable.RipRefresh&target.health.pct>variable.ExecuteRange)|action.rip.persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die-dot.rip.remains>action.rip.tick_time*4
					#pool_resource,for_next=1
					#rip,cycle_targets=1,if=variable.Rip_Main
					if Rip_Main() Spell(rip)
					unless Rip_Main() and SpellUsable(rip) and SpellCooldown(rip) < TimeToEnergyFor(rip)
					{
						#variable,name=FerociousBite_9SecondRefresh,value=dot.rip.ticking&dot.rip.remains<variable.RipRefresh&target.health.pct<variable.ExecuteRange
						#pool_resource,for_next=1
						#ferocious_bite,max_energy=1,cycle_targets=1,if=variable.FerociousBite_9SecondRefresh
						if Energy() >= EnergyCost(ferocious_bite max=1) and FerociousBite_9SecondRefresh() Spell(ferocious_bite text=Refresh)
						unless Energy() >= EnergyCost(ferocious_bite max=1) and FerociousBite_9SecondRefresh() and SpellUsable(ferocious_bite) and SpellCooldown(ferocious_bite) < TimeToEnergyFor(ferocious_bite)
						{
							#variable,name=SavageRoar_Main,value=(buff.savage_roar.remains<=7.2|(buff.savage_roar.remains<variable.SavageRoarRefresh&target.health.pct>=variable.ExecuteRange))
							#pool_resource,for_next=1
							#savage_roar,if=variable.SavageRoar_Main
							if SavageRoar_Main() Spell(savage_roar)
							unless SavageRoar_Main() and SpellUsable(savage_roar) and SpellCooldown(savage_roar) < TimeToEnergyFor(savage_roar)
							{
								#variable,name=Maim_Main,value=buff.fiery_red_maimers.up&variable.BuffBloodtalonsUp
								#pool_resource,for_next=1
								#maim,if=variable.Maim_Main
								if Maim_Main() Spell(maim)
								unless Maim_Main() and SpellUsable(maim) and SpellCooldown(maim) < TimeToEnergyFor(maim)
								{
									#pool_resource,for_next=1
									#ferocious_bite,max_energy=1
									if Energy() >= EnergyCost(ferocious_bite max=1) Spell(ferocious_bite)
								}
							}
						}
					}
				}
			}

			AddFunction FeralFinishersMainPostConditions
			{
			}

			### actions.Generators

			AddFunction FeralGeneratorsMainActions
			{
				#variable,name=BrutalSlash_Main,value=spell_targets.brutal_slash>desired_targets
				#brutal_slash,if=variable.BrutalSlash_Main
				if BrutalSlash_Main() Spell(brutal_slash)
				#variable,name=ThrashCat_Spam,value=talent.brutal_slash.enabled&spell_targets.thrash_cat>=9
				#pool_resource,for_next=1
				#thrash_cat,if=variable.ThrashCat_Spam
				if ThrashCat_Spam() Spell(thrash_cat)
				unless ThrashCat_Spam() and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
				{
					#variable,name=SwipeCat_6Targets,value=spell_targets.swipe_cat>=6&variable.SwipeCatEnergyPooling
					#pool_resource,for_next=1
					#swipe_cat,if=variable.SwipeCat_6Targets
					if SwipeCat_6Targets() Spell(swipe_cat)
					unless SwipeCat_6Targets() and SpellUsable(swipe_cat) and SpellCooldown(swipe_cat) < TimeToEnergyFor(swipe_cat)
					{
						#variable,name=Rake_Main,value=(!dot.rake.ticking|(variable.BuffBloodtalonsUp&dot.rake.remains<=variable.RakeRefresh&action.rake.persistent_multiplier>dot.rake.pmultiplier*0.80))&target.time_to_die-dot.rake.remains>action.rake.tick_time
						#pool_resource,for_next=1
						#rake,cycle_targets=1,if=variable.Rake_Main
						if Rake_Main() Spell(rake)
						unless Rake_Main() and SpellUsable(rake) and SpellCooldown(rake) < TimeToEnergyFor(rake)
						{
							#variable,name=MoonfireCat_Main,value=dot.moonfire_cat.remains<=4.2&target.time_to_die-dot.moonfire_cat.remains>action.moonfire_cat.tick_time*2
							#moonfire_cat,cycle_targets=1,if=variable.MoonfireCat_Main
							if MoonfireCat_Main() Spell(moonfire_cat)
							#variable,name=ThrashCat_Tier19_4pc,value=set_bonus.tier19_4pc&dot.thrash_cat.remains<=variable.ThrashCatPandemic&((buff.clearcasting.react&(equipped.ailuro_pouncers|buff.bloodtalons.down))|(variable.ClearcastingLotsOfEnergy&equipped.luffa_wrappings))
							#thrash_cat,cycle_targets=1,if=variable.ThrashCat_Tier19_4pc
							if ThrashCat_Tier19_4pc() Spell(thrash_cat)
							#variable,name=ThrashCat_NoTier19_4pc,value=!set_bonus.tier19_4pc&dot.thrash_cat.remains<=variable.ThrashCatPandemic&(buff.clearcasting.react&equipped.luffa_wrappings&(equipped.ailuro_pouncers|buff.bloodtalons.down))
							#thrash_cat,cycle_targets=1,if=variable.ThrashCat_NoTier19_4pc
							if ThrashCat_NoTier19_4pc() Spell(thrash_cat)
							#variable,name=ThrashCat_2Targets,value=dot.thrash_cat.remains<=variable.ThrashCatPandemic&spell_targets.thrash_cat>=2&variable.ThrashCatEnergyPooling
							#pool_resource,for_next=1
							#thrash_cat,cycle_targets=1,if=variable.ThrashCat_2Targets
							if ThrashCat_2Targets() Spell(thrash_cat)
							unless ThrashCat_2Targets() and SpellUsable(thrash_cat) and SpellCooldown(thrash_cat) < TimeToEnergyFor(thrash_cat)
							{
								#variable,name=SwipeCat_Main,value=spell_targets.swipe_cat>=3&variable.SwipeCatEnergyPooling
								#swipe_cat,if=variable.SwipeCat_Main
								if SwipeCat_Main() Spell(swipe_cat)
								#variable,name=BrutalSlash_3Charges,value=action.brutal_slash.charges_fractional>2.66&time>10
								#brutal_slash,if=variable.BrutalSlash_3Charges
								if BrutalSlash_3Charges() Spell(brutal_slash)
								#variable,name=Shred_Main,value=(spell_targets.swipe_cat<3|talent.brutal_slash.enabled)&((dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen&combo_points<3)|variable.ClearcastingPoolEnergy)
								#shred,if=variable.Shred_Main
								if Shred_Main() Spell(shred)
							}
						}
					}
				}
			}

			### actions.default

			AddFunction FeralDefaultMainActions
			{
				# MODIFICATION: Dash to get to cat form moved from Cd to Main
				# REASON: So it doesn't show up out of combat and to remind you to use dash to regain Cat Form when an option
				#dash,if=!buff.cat_form.up
				if BuffExpires(cat_form_buff) Spell(dash)
    
				#cat_form
				Spell(cat_form)

				#variable,name=Rake_Prowl,value=buff.prowl.up|buff.shadowmeld.up
				#rake,if=variable.Rake_Prowl
				if Rake_Prowl() Spell(rake)
				#variable,name=FerociousBite_3SecondRefresh,value=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>3&target.health.pct<variable.ExecuteRange
				#ferocious_bite,cycle_targets=1,if=variable.FerociousBite_3SecondRefresh
				if FerociousBite_3SecondRefresh() Spell(ferocious_bite text=Refresh)
				#variable,name=RegrowthConditions,value=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.stack<variable.BloodtalonsOverwriteStacks
				#variable,name=Regrowth_PredatorySwiftness_Expires,value=buff.predatory_swiftness.remains<1.5
				#variable,name=Regrowth_AshamanesFrenzy,value=combo_points=2&buff.bloodtalons.down&cooldown.ashamanes_frenzy.remains<1+gcd&(buff.savage_roar.remains>(3+gcd)|!talent.savage_roar.enabled)
				#regrowth,if=variable.RegrowthConditions&(variable.Regrowth_PredatorySwiftness_Expires|variable.Regrowth_AshamanesFrenzy)
				if RegrowthConditions() and { Regrowth_PredatorySwiftness_Expires() or Regrowth_AshamanesFrenzy() } Spell(regrowth)
				#variable,name=AshamanesFrenzy_Main,value=combo_points<=2&buff.elunes_guidance.down&variable.BuffBloodtalonsUp&variable.BuffSavageRoarUp
				#ashamanes_frenzy,if=variable.AshamanesFrenzy_Main
				# MODIFICATION: AshamanesFrenzy_Main for CheckBoxOn(opt_ashamanes_frenzy_main_action)
				# REASON: Allows player to choose via checkbox whether to add Azshamane's Frenzy to the Main Icon
				if AshamanesFrenzy_Main() Spell(ashamanes_frenzy)
				#variable,name=Shadowmeld_Main,value=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<1.9&buff.tigers_fury.up&variable.BuffSavageRoarUp&variable.BuffBloodtalonsUp&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
				#shadowmeld,if=variable.Shadowmeld_Main
				# MODIFICATION: Shadowmeld_Cd for CheckBoxOff(opt_shadowmeld_main_action)
				# REASON: Allows player to choose via checkbox whether to add Shadowmeld to the Main Icon
				if Shadowmeld_Main() Spell(shadowmeld)
				#call_action_list,name=ElunesGuidance,if=talent.elunes_guidance.enabled
				if Talent(elunes_guidance_talent) FeralElunesGuidanceMainActions()

				unless Talent(elunes_guidance_talent) and FeralElunesGuidanceMainPostConditions()
				{
					#variable,name=Regrowth_SavageRoar_Down,value=variable.RegrowthConditions&talent.savage_roar.enabled&buff.savage_roar.down&combo_points=5
					#regrowth,if=variable.Regrowth_SavageRoar_Down
					if Regrowth_SavageRoar_Down() Spell(regrowth)
					#variable,name=SavageRoar_Down,value=buff.savage_roar.down&(variable.FinisherConditions|time<8)
					#pool_resource,for_next=1
					#savage_roar,if=variable.SavageRoar_Down
					if SavageRoar_Down() Spell(savage_roar)
					unless SavageRoar_Down() and SpellUsable(savage_roar) and SpellCooldown(savage_roar) < TimeToEnergyFor(savage_roar)
					{
						#variable,name=Regrowth_Pouncers,value=equipped.ailuro_pouncers&talent.bloodtalons.enabled&(buff.predatory_swiftness.stack>2|(buff.predatory_swiftness.stack>1&dot.rake.remains<3))&buff.bloodtalons.down
						#regrowth,if=variable.Regrowth_Pouncers
						if Regrowth_Pouncers() Spell(regrowth)
						#call_action_list,name=AoeFinishers,if=active_enemies>1
						if Enemies() > 1 FeralAoeFinishersMainActions()

						unless Enemies() > 1 and FeralAoeFinishersMainPostConditions()
						{
							#variable,name=Regrowth_5CPs,value=variable.RegrowthConditions&combo_points=5
							#regrowth,if=variable.Regrowth_5CPs
							if Regrowth_5CPs() Spell(regrowth)
							#call_action_list,name=Finishers,if=variable.FinisherConditions&variable.BuffSavageRoarUp
							if FinisherConditions() and BuffSavageRoarUp() FeralFinishersMainActions()
							unless FinisherConditions() and BuffSavageRoarUp() and FeralFinishersMainPostConditions()
							{
								#call_action_list,name=Generators,if=combo_points<5
								if ComboPoints() < 5 FeralGeneratorsMainActions()
							}
						}
					}
				}
			}


			AddFunction FeralDefaultShortCdActions
			{
				unless Spell(cat_form)
				{
					#wild_charge
					FeralGetInMeleeRange()

					unless Rake_Prowl() and Spell(rake)
					{
						#auto_attack
						#variable,name=TigersFury_Main,value=(!buff.clearcasting.react&energy.deficit>=60)|energy.deficit>=80
						#tigers_fury,if=variable.TigersFury_Main
						if TigersFury_Main() Spell(tigers_fury)
						#tigers_fury,if=variable.TigersFury_Sabertooth
						if TigersFury_Sabertooth() Spell(tigers_fury)

						unless FerociousBite_3SecondRefresh() and Spell(ferocious_bite) or RegrowthConditions() and { Regrowth_PredatorySwiftness_Expires() or Regrowth_AshamanesFrenzy() } and Spell(regrowth)
						{
							#variable,name=Regrowth_AshamanesFrenzy,value=combo_points=2&buff.bloodtalons.down&cooldown.ashamanes_frenzy.remains<1+gcd&(buff.savage_roar.remains>(3+gcd)|!talent.savage_roar.enabled)
							#regrowth,if=variable.RegrowthConditions&(variable.Regrowth_PredatorySwiftness_Expires|variable.Regrowth_AshamanesFrenzy)
							# MODIFICATION: Regrowth_AshamanesFrenzy_ShortCd for CheckBoxOff(opt_ashamanes_frenzy_main_action)
							# REASON: Allows player to choose via checkbox whether to add Ashamane's Frenzy to the Main Icon
							if RegrowthConditions() and Regrowth_AshamanesFrenzy_ShortCd() Spell(regrowth text=AF)
							#variable,name=AshamanesFrenzy_Main,value=combo_points<=2&buff.elunes_guidance.down&variable.BuffBloodtalonsUp&variable.BuffSavageRoarUp
							#ashamanes_frenzy,if=variable.AshamanesFrenzy_Main
							# MODIFICATION: AshamanesFrenzy_ShortCd for CheckBoxOff(opt_ashamanes_frenzy_main_action)
							# REASON: Allows player to choose via checkbox whether to add Ashamane's Frenzy to the Main Icon
							if AshamanesFrenzy_ShortCd() Spell(ashamanes_frenzy)
							# MODIFICATION: TigersFury_Predator
							# REASON: Spam Tiger's Fury with predator in raid to maximize raid uptime of versatility buff
							if TigersFury_Predator() Spell(tigers_fury text=Pred)
							#call_action_list,name=ElunesGuidance,if=talent.elunes_guidance.enabled
							if Talent(elunes_guidance_talent) FeralElunesGuidanceShortCdActions()
						}
					}
				}
			}

			AddFunction FeralDefaultCdActions
			{

				unless Spell(cat_form)
				{
					#skull_bash
					FeralInterruptActions()

					#variable,name=Berserk_Main,value=buff.ashamanes_energy.up|(equipped.convergence_of_fates&energy>=35)
					#berserk,if=variable.Berserk_Main
					if Berserk_Main() Spell(berserk_cat)
					#variable,name=Incarnation_Main,value=buff.ashamanes_energy.up|energy>=35
					#incarnation,if=variable.Incarnation_Main
					if Incarnation_Main() Spell(incarnation_king_of_the_jungle)
					#variable,name=Trinket_Main,value=(buff.tigers_fury.up&(target.time_to_die>trinket.stat.any.cooldown|target.time_to_die<45))|buff.incarnation.remains>20
					#use_item,slot=trinket1,if=variable.Trinket_Main
					if Trinket_Main() FeralUseItemActions()
					#variable,name=Potion_Main,value=((buff.berserk.remains>10|buff.incarnation.remains>20)&(target.time_to_die<180|(trinket.proc.all.react&target.health.pct<25)))|target.time_to_die<=40
					#potion,name=old_war,if=variable.Potion_Main
					if Potion_Main() and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) FeralPotionActions()

					unless FerociousBite_3SecondRefresh() and Spell(ferocious_bite) or RegrowthConditions() and { Regrowth_PredatorySwiftness_Expires() or Regrowth_AshamanesFrenzy() } and Spell(regrowth) or AshamanesFrenzy_Main() and Spell(ashamanes_frenzy)
					{
						#variable,name=Shadowmeld_Main,value=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<1.9&buff.tigers_fury.up&variable.BuffSavageRoarUp&variable.BuffBloodtalonsUp&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
						#shadowmeld,if=variable.Shadowmeld_Main
						# MODIFICATION: Shadowmeld_Cd for CheckBoxOff(opt_shadowmeld_main_action)
						# REASON: Allows player to choose via checkbox whether to add Shadowmeld to the Main Icon
						if Shadowmeld_Cd() Spell(shadowmeld)
					}
				}
			}

			### actions.ElunesGuidance

			AddFunction FeralElunesGuidanceMainActions
			{
				#variable,name=ElunesGuidance_Regrowth,value=talent.elunes_guidance.enabled&variable.RegrowthConditions&((cooldown.elunes_guidance.remains<gcd&combo_points=0)|(buff.elunes_guidance.up&combo_points>=4))
				#regrowth,if=variable.ElunesGuidance_Regrowth
				# MODIFICATION: ElunesGuidance_Regrowth_Main
				# REASON: Only do 4 CP regrowth in main action list
				if ElunesGuidance_Regrowth_Main() Spell(regrowth)
			}

			AddFunction FeralElunesGuidanceMainPostConditions
			{
			}

			AddFunction FeralElunesGuidanceShortCdActions
			{
				#variable,name=ElunesGuidance_Regrowth,value=talent.elunes_guidance.enabled&variable.RegrowthConditions&((cooldown.elunes_guidance.remains<gcd&combo_points=0)|(buff.elunes_guidance.up&combo_points>=4))
				#regrowth,if=variable.ElunesGuidance_Regrowth
				# MODIFICATION: ElunesGuidance_Regrowth_Main
				# REASON: Only do 4 CP regrowth in main action list
				if ElunesGuidance_Regrowth_ShortCd() Spell(regrowth text=EG)
    
				#variable,name=ElunesGuidance_Pooling,value=talent.elunes_guidance.enabled&combo_points=0&energy<action.ferocious_bite.cost+25-energy.regen*cooldown.elunes_guidance.remains
				#pool_resource,if=variable.ElunesGuidance_Pooling
				unless ElunesGuidance_Pooling()
				{

					#variable,name=ElunesGuidance_Main,value=talent.elunes_guidance.enabled&combo_points=0&energy>=action.ferocious_bite.cost+25
					#elunes_guidance,if=variable.ElunesGuidance_Main
					if ElunesGuidance_Main() Spell(elunes_guidance)

				}
			}


			### actions.precombat

			AddFunction FeralPrecombatMainActions
			{
				#flask,type=flask_of_the_seventh_demon
				#food,type=nightborne_delicacy_platter
				#augmentation,type=defiled
				#regrowth,if=talent.bloodtalons.enabled
				# MODIFICATION: Talent(bloodtalons_talent) to Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff)
				# REASON: Only suggest Regrowth out of stealth and if there's <15 seconds remaining
				if Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff) Spell(regrowth)
				#cat_form
				Spell(cat_form)
				#savage_roar
				if BuffRemaining(savage_roar_buff) < 4 + 4 * ComboPoints() Spell(savage_roar)
			}

			AddFunction FeralPrecombatMainPostConditions
			{
			}

			AddFunction FeralPrecombatShortCdActions
			{
				# MODIFICATION: Talent(bloodtalons_talent) to Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff)
				# REASON: Only suggest Regrowth out of stealth and if there's <15 seconds remaining
				# MODIFICATION: Remove `or Spell(cat_form)`
				# REASON: Blocks Prowl from showing up
				unless Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff) and Spell(regrowth)
				{
					#prowl
					Spell(prowl)
				}
			}

			AddFunction FeralPrecombatShortCdPostConditions
			{
				# MODIFICATION: Talent(bloodtalons_talent) to Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff)
				# REASON: Only suggest Regrowth out of stealth and if there's <15 seconds remaining
				# MODIFICATION: Remove `or Spell(cat_form)`
				# REASON: Blocks Prowl from showing up
				Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff) and Spell(regrowth)
			}

			AddFunction FeralPrecombatCdActions
			{
			}

			AddFunction FeralPrecombatCdPostConditions
			{
				# MODIFICATION: Talent(bloodtalons_talent) to Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff)
				# REASON: Only suggest Regrowth out of stealth and if there's <15 seconds remaining
				# MODIFICATION: Remove `or Spell(cat_form)`
				# REASON: Blocks Prowl from showing up
				Talent(bloodtalons_talent) and BuffRemaining(bloodtalons_buff) < 15 and BuffExpires(prowl_buff) and Spell(regrowth)
			}

			### Feral icons.

			AddCheckBox(opt_druid_feral_aoe L(AOE) default specialization=feral)

			AddIcon checkbox=!opt_druid_feral_aoe enemies=1 help=shortcd specialization=feral
			{
				if not InCombat() FeralPrecombatShortCdActions()
				unless not InCombat() and FeralPrecombatShortCdPostConditions()
				{
					FeralDefaultShortCdActions()
				}
			}

			AddIcon checkbox=opt_druid_feral_aoe help=shortcd specialization=feral
			{
				if not InCombat() FeralPrecombatShortCdActions()
				unless not InCombat() and FeralPrecombatShortCdPostConditions()
				{
					FeralDefaultShortCdActions()
				}
			}

			AddIcon enemies=1 help=main specialization=feral
			{
				if not InCombat() FeralPrecombatMainActions()
				unless not InCombat() and FeralPrecombatMainPostConditions()
				{
					FeralDefaultMainActions()
				}
			}

			AddIcon checkbox=opt_druid_feral_aoe help=aoe specialization=feral
			{
				if not InCombat() FeralPrecombatMainActions()
				unless not InCombat() and FeralPrecombatMainPostConditions()
				{
					FeralDefaultMainActions()
				}
			}

			AddIcon checkbox=!opt_druid_feral_aoe enemies=1 help=cd specialization=feral
			{
				if not InCombat() FeralPrecombatCdActions()
				unless not InCombat() and FeralPrecombatCdPostConditions()
				{
					FeralDefaultCdActions()
				}
			}

			AddIcon checkbox=opt_druid_feral_aoe help=cd specialization=feral
			{
				if not InCombat() FeralPrecombatCdActions()
				unless not InCombat() and FeralPrecombatCdPostConditions()
				{
					FeralDefaultCdActions()
				}
			}

			### Required symbols
			# ailuro_pouncers
			# ashamanes_energy_buff
			# ashamanes_frenzy
			# augmentation
			# berserk_cat
			# berserk_cat_buff
			# bloodtalons_buff
			# bloodtalons_talent
			# brutal_slash
			# brutal_slash_talent
			# cat_form
			# cat_form_buff
			# chatoyant_signet
			# clearcasting_buff
			# convergence_of_fates
			# dash
			# draught_of_souls
			# elunes_guidance
			# elunes_guidance_buff
			# elunes_guidance_talent
			# ferocious_bite
			# fiery_red_maimers_buff
			# incarnation_king_of_the_jungle
			# incarnation_king_of_the_jungle_buff
			# incarnation_talent
			# jagged_wounds_talent
			# luffa_wrappings
			# maim
			# mangle
			# moonfire_cat
			# moonfire_cat_debuff
			# predatory_swiftness_buff
			# prowl
			# prowl_buff
			# rake
			# rake_debuff
			# regrowth
			# rip
			# rip_debuff
			# sabertooth_talent
			# savage_roar
			# savage_roar_buff
			# savage_roar_talent
			# scent_of_blood_buff
			# shadowmeld
			# shadowmeld_buff
			# shred
			# soul_of_the_forest_talent
			# swipe_cat
			# thrash_cat
			# thrash_cat_debuff
			# tigers_fury
			# tigers_fury_buff
			# wild_charge
			# wild_charge_bear
			# wild_charge_cat
		]];
	
		OvaleScripts:RegisterScript("DRUID", "feral",  name, desc, code, "script");
	end
end