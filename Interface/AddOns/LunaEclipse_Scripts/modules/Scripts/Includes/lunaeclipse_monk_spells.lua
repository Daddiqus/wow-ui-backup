local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;

	do
		local name = "lunaeclipse_monk_spells";
		local desc = "[7.1] LunaEclipse: Monk spells";
		local code = [[
			# Monk spells and functions.

			# Talents
			Define(chi_burst_talent 1)
			Define(eye_of_the_tiger_talent 2)
			Define(chi_wave_talent 3)
			Define(chi_torpedo_talent 4)
			Define(tigers_lust_talent 5)
			Define(celerity_talent 6)
			Define(energizing_elixir_talent 7)
			Define(ascension_talent 8)
			Define(power_strikes_talent 9)
			Define(ring_of_peace_talent 10)
			Define(dizzying_kicks_talent 11)
			Define(leg_sweep_talent 12)
			Define(healing_elixir_talent 13)
			Define(diffuse_magic_talent 14)
			Define(dampen_harm_talent 15)
			Define(rushing_jade_wind_talent 16)
			Define(invoke_xuen_talent 17)
			Define(hit_combo_talent 18)
			Define(chi_orbit_talent 19)
			Define(whirling_dragon_punch_talent 20)
			Define(serenity_talent 21)
			
			# Spells
			Define(blackout_kick 100784)
				SpellInfo(blackout_kick chi=1 cd=3)
				SpellRequire(blackout_kick chi 0=buff,combo_breaker_bok_buff)
				SpellRequire(blackout_kick refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(blackout_kick combo_breaker_bok_buff=0)
				SpellAddBuff(blackout_kick cranes_zeal_buff=1)
				SpellAddBuff(blackout_kick shuffle_buff=1)
				SpellAddBuff(blackout_kick teachings_of_the_monastery_buff=-1)
			Define(breath_of_fire 115181)
				SpellInfo(breath_of_fire chi=2)
				SpellRequire(breath_of_fire refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddTargetBuff(breath_of_fire breath_of_fire_debuff=1 if_spell=improved_breath_of_fire)
			Define(chi_brew 115399)
				SpellInfo(chi_brew chi=-2 gcd=0 offgcd=1)
				SpellAddBuff(chi_brew elusive_brew_stacks_buff=5 if_spell=elusive_brew)
				SpellAddBuff(chi_brew mana_tea_buff=1 if_spell=mana_tea glyph=!glyph_of_mana_tea)
				SpellAddBuff(chi_brew mana_tea_buff=1 if_spell=mana_tea_glyphed glyph=glyph_of_mana_tea)
				SpellAddBuff(chi_brew tigereye_brew_buff=2 if_spell=tigereye_brew)
			Define(chi_burst 123986)
				SpellInfo(chi_burst cd=30 travel_time=1)
			Define(chi_explosion_heal 157675)
				SpellInfo(chi_explosion_heal chi=finisher max_chi=4)
			Define(chi_explosion_melee 152174)
				SpellInfo(chi_explosion_melee chi=finisher max_chi=4)
				SpellInfo(chi_explosion_melee buff_chi=combo_breaker_ce_buff buff_chi_amount=-2)
			Define(chi_explosion_tank 157676)
				SpellInfo(chi_explosion_tank chi=finisher max_chi=4)
			Define(chi_torpedo 115008)
			Define(chi_wave 115098)
				SpellInfo(chi_wave cd=15)
			Define(combo_breaker 137384)
			Define(crackling_jade_lightning 117952)
				SpellInfo(crackling_jade_lightning channel=4 gcd=1.5)
				SpellAddBuff(crackling_jade_lightning power_strikes_buff=0 talent=power_strikes_talent)
			Define(dampen_harm 122278)
				SpellInfo(dampen_harm cd=90 gcd=0 offgcd=1)
				SpellAddBuff(dampen_harm dampen_harm_buff=3)
			Define(detonate_chi 115460)
				SpellInfo(detonate_chi cd=10)
			Define(diffuse_magic 122783)
				SpellInfo(diffuse_magic cd=90 gcd=0 offgcd=1)
			Define(elusive_brew 115308)
				SpellInfo(elusive_brew cd=9 gcd=0 offgcd=1)
				SpellAddBuff(elusive_brew elusive_brew_activated_buff=1 elusive_brew_stacks_buff=0)
			Define(energizing_brew 115288)
				SpellInfo(energizing_brew cd=60 gcd=0)
				SpellInfo(energizing_brew buff_cdr=cooldown_reduction_agility_buff)
				SpellAddBuff(energizing_brew energizing_brew_buff=1)
			Define(energizing_elixir 115288)
				SpellInfo(energizing_elixir chi=refill energy=refill)
			Define(enveloping_mist 124682)
				SpellInfo(enveloping_mist chi=3)
				SpellAddTargetBuff(enveloping_mist enveloping_mist_buff=1)
			Define(expel_harm 115072)
				SpellInfo(expel_harm cd=15 chi=-1)
				SpellInfo(expel_harm energy=40 specialization=!mistweaver)
				SpellInfo(expel_harm replace=expel_harm_glyphed unusable=1 glyph=glyph_of_targeted_explusion)
				SpellRequire(expel_harm energy 35=health_pct,35 glyph=glyph_of_expel_harm)
				SpellAddBuff(expel_harm power_strikes_buff=0 talent=power_strikes_talent)
			Define(expel_harm_glyphed 147489)
				SpellInfo(expel_harm_glyphed cd=15 chi=-1)
				SpellInfo(expel_harm_glyphed energy=40 specialization=!mistweaver)
				SpellInfo(expel_harm_glyphed unusable=1 glyph=!glyph_of_targeted_explusion)
				SpellRequire(expel_harm_glyphed energy 35=health_pct,35 glyph=glyph_of_expel_harm)
				SpellAddBuff(expel_harm_glyphed power_strikes_buff=0 talent=power_strikes_talent)
			Define(fists_of_fury 113656)
				SpellInfo(fists_of_fury channel=4 cd=25 chi=3)
				SpellInfo(fists_of_fury addcd=-5 itemset=T14_melee itemcount=2)
				SpellInfo(fists_of_fury buff_chi=focus_of_xuen_buff buff_chi_amount=-1 itemset=T16_melee itemcount=4)
				SpellInfo(fists_of_fury buff_cdr=cooldown_reduction_agility_buff)
				SpellRequire(fists_of_fury refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(fists_of_fury tigereye_brew_buff=1 if_spell=tigereye_brew itemset=T17 itemcount=2 specialization=windwalker)
			Define(flying_serpent_kick 101545)
				SpellInfo(flying_serpent_kick cd=25 gcd=1)
			Define(focus_and_harmony 154555)
			Define(fortifying_brew 115203)
				SpellInfo(fortifying_brew cd=180 gcd=0 offgcd=1)
				SpellInfo(fortifying_brew buff_cdr=cooldown_reduction_agility_buff specialization=windwalker)
				SpellInfo(fortifying_brew buff_cdr=cooldown_reduction_tank_buff specialization=brewmaster)
				SpellAddBuff(fortifying_brew fortifying_brew_buff=1)
			Define(gale_burst 195399)
				SpellAddBuff(gale_burst gale_burst_buff=1)
			Define(guard 115295)
				SpellInfo(guard cd=30 chi=2 gcd=0 offgcd=1)
				SpellInfo(guard buff_cdr=cooldown_reduction_tank_buff)
				SpellInfo(guard replace=guard_glyphed unusable=1 glyph=glyph_of_guard)
				SpellRequire(guard refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(guard guard_buff=1)
			Define(guard_glyphed 123402)
				SpellInfo(guard_glyphed cd=30 chi=2 gcd=0 offgcd=1)
				SpellInfo(guard_glyphed buff_cdr=cooldown_reduction_tank_buff)
				SpellInfo(guard_glyphed unusable=1 glyph=!glyph_of_guard)
				SpellRequire(guard_glyphed refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(guard_glyphed guard_glyphed_buff=1)
			Define(healing_elixir 122281)
				SpellInfo(healing_elixir charges=2 cd=30 talent=healing_elixir_talent)
			Define(hurricane_strike 152175)
				SpellInfo(hurricane_strike channel=2 cd=45 chi=3)
			Define(improved_breath_of_fire 157362)
			Define(improved_renewing_mist 157398)
			Define(invoke_xuen 123904)
				SpellInfo(invoke_xuen cd=180 talent=invoke_xuen_talent)
			Define(jab 100780)
				SpellInfo(jab chi=-1)
				SpellInfo(jab buff_chi=power_strikes_buff talent=power_strikes_talent)
				SpellAddBuff(jab power_strikes_buff=0 talent=power_strikes_talent)
			Define(keg_smash 121253)
				SpellInfo(keg_smash cd=8 chi=-2)
				SpellInfo(keg_smash energy=40 specialization=!mistweaver)
			Define(legacy_of_the_emperor 115921)
				SpellAddBuff(legacy_of_the_emperor legacy_of_the_emperor_buff=1)
			Define(legacy_of_the_white_tiger 116781)
				SpellAddBuff(legacy_of_the_white_tiger legacy_of_the_white_tiger_buff=1)
			Define(leg_sweep 119381)
				SpellAddDebuff(leg_sweep leg_sweep_debuff duration=5)
			Define(mana_tea 115294)
				SpellInfo(mana_tea channel=6 texture=inv_misc_herb_jadetealeaf)
				SpellInfo(mana_tea replace=mana_tea_glyphed unusable=1 glyph=glyph_of_mana_tea)
			Define(mana_tea_glyphed 123761)
				SpellInfo(mana_tea_glyphed cd=10 texture=inv_misc_herb_jadetealeaf)
				SpellInfo(mana_tea_glyphed unusable=1 glyph=glyph_of_mana_tea)
				SpellAddBuff(mana_tea_glyphed mana_tea_buff=-2)
			Define(nimble_brew 137562)
				SpellInfo(nimble_brew cd=120 gcd=0 offgcd=1)
			Define(paralysis 115078)
				SpellInfo(paralysis cd=15 interrupt=1)
			Define(purifying_brew 119582)
				SpellInfo(purifying_brew cd=1 chi=1 gcd=0 offgcd=1)
				SpellRequire(purifying_brew chi 0=buff,purifier_buff itemset=T15_tank itemcount=4)
				SpellRequire(purifying_brew refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(purifying_brew elusive_brew_stacks_buff=1 if_spell=elusive_brew itemset=T17 itemcount=4 specialization=brewmaster)
				SpellAddDebuff(purifying_brew heavy_stagger_debuff=0 light_stagger_debuff=0 moderate_stagger_debuff=0)
			Define(refreshing_jade_wind 196725)
				SpellInfo(refreshing_jade_wind cd=6 mana=5)
			Define(renewing_mist 115151)
				SpellInfo(renewing_mist cd=8 chi=-1)
				SpellAddBuff(renewing_mist thunder_focus_tea_buff=0 if_spell=thunder_focus_tea)
				SpellAddTargetBuff(renewing_mist renewing_mist_buff=1)
				SpellAddTargetBuff(renewing_mist extend_life_buff=1 itemset=T18 itemcount=2)
			Define(revival 115310)
				SpellInfo(revival cd=180)
			Define(rising_sun_kick 107428)
				SpellInfo(rising_sun_kick cd=8 chi=2)
				SpellRequire(rising_sun_kick refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddTargetDebuff(rising_sun_kick rising_sun_kick_debuff=1)
			Define(rushing_jade_wind 116847)
				SpellInfo(rushing_jade_wind chi=1 cd=6 cd_haste=melee)
			Define(serenity 152173)
				SpellInfo(serenity cd=90 gcd=0)
				SpellAddBuff(serenity serenity_buff=1)
			Define(soothing_mist 115175)
				SpellInfo(soothing_mist cd=1 channel=8)
				SpellInfo(soothing_mist soothing_mist_buff=1)
			Define(spear_hand_strike 116705)
				SpellInfo(spear_hand_strike cd=15 gcd=0 interrupt=1 offgcd=1)
			Define(spinning_crane_kick 101546)
				SpellInfo(spinning_crane_kick duration=1.5 tick=0.5)
				SpellInfo(spinning_crane_kick chi=3 specialization=windwalker)
			Define(storm_earth_and_fire 137639)
				SpellAddBuff(storm_earth_and_fire storm_earth_and_fire_buff=1)
				SpellAddTargetDebuff(storm_earth_and_fire storm_earth_and_fire_target_debuff=1)
			Define(strike_of_the_windlord 205320)
				SpellInfo(strike_of_the_windlord cd=40 chi=2)
			Define(summon_black_ox_statue 115315)
				SpellInfo(summon_black_ox_statue cd=10 duration=900 totem=1)
			Define(summon_jade_serpent_statue 115313)
				SpellInfo(summon_jade_serpent_statue cd=10 duration=900 totem=1)
			Define(surging_mist 116694)
				SpellInfo(surging_mist chi=-1 specialization=mistweaver)
				SpellInfo(surging_mist replace=surging_mist_glyphed unusable=1 glyph=glyph_of_surging_mist)
				SpellRequire(surging_mist chi -2=buff,vital_mists_buff,5 itemset=T17 itemset=2 specialization=mistweaver)
				SpellAddBuff(surging_mist thunder_focus_tea_buff=0 if_spell=thunder_focus_tea)
			Define(surging_mist_glyphed 123273)
				SpellInfo(surging_mist_glyphed chi=-1 specialization=mistweaver)
				SpellInfo(surging_mist_glyphed unusable=1 glyph=!glyph_of_surging_mist)
				SpellRequire(surging_mist_glyphed chi -2=buff,vital_mists_buff,5 itemset=T17 itemset=2 specialization=mistweaver)
				SpellAddBuff(surging_mist_glyphed thunder_focus_tea_buff=0 if_spell=thunder_focus_tea)
			Define(touch_of_death 115080)
				SpellInfo(touch_of_death cd=120 gcd=1.5)
			Define(touch_of_karma 122470)
				SpellInfo(touch_of_karma cd=90 gcd=0 offgcd=1)
				SpellAddBuff(touch_of_karma touch_of_karma_buff=1)
			Define(thunder_focus_tea 116680)
				SpellInfo(thunder_focus_tea cd=45 gcd=0)
				SpellInfo(thunder_focus_tea addcd=-5 itemset=T15_heal itemcount=4)
				SpellRequire(thunder_focus_tea chi 1=buff,chi_jis_guidance_buff itemset=T17 itemcount=4 specialization=mistweaver)
				SpellAddBuff(thunder_focus_tea chi_jis_guidance_buff=-1 itemset=T17 itemcount=4 specialization=mistweaver)
				SpellAddBuff(thunder_focus_tea thunder_focus_tea_buff=1)
			Define(tiger_palm 100780)
				SpellInfo(tiger_palm energy=50)
				SpellInfo(tiger_palm chi=-1 specialization=windwalker)
				SpellRequire(tiger_palm refund_chi cost=buff,serenity_buff if_spell=serenity)
				SpellAddBuff(tiger_palm tiger_power_buff=1)
			Define(tigereye_brew 116740)
				SpellInfo(tigereye_brew cd=5 gcd=0)
				SpellAddBuff(tigereye_brew tigereye_brew_buff=-10 tigereye_brew_use_buff=1)
			Define(uplift 116670)
				SpellInfo(uplift chi=2)
			Define(whirling_dragon_punch 152175)
				SpellInfo(whirling_dragon_punch cd=24 unusable=1)
				SpellRequire(whirling_dragon_punch unusable 0=oncooldown,rising_sun_kick)
				SpellRequire(whirling_dragon_punch unusable 0=oncooldown,fists_of_fury)
			Define(zen_meditation 115176)
				SpellInfo(zen_meditation cd=180 gcd=0 offgcd=1)
				SpellInfo(zen_meditation buff_cdr=cooldown_reduction_agility_buff specialization=windwalker)
				SpellInfo(zen_meditation buff_cdr=cooldown_reduction_tank_buff specialization=brewmaster)
			Define(zen_sphere 124081)
				SpellInfo(zen_sphere cd=10)
				SpellAddTargetBuff(zen_sphere zen_sphere_buff=1)

			# Buffs
			Define(bok_proc_buff 116768) # Alias for combo_breaker_bok_buff
			Define(cranes_zeal_buff 127722)
				SpellInfo(cranes_zeal_buff duration=20)
			Define(chi_jis_guidance_buff 167717)
				SpellInfo(chi_jis_guidance_buff duration=60 max_stacks=2)
			Define(combo_breaker_bok_buff 116768)
				SpellInfo(combo_breaker_bok_buff duration=15)
			Define(combo_breaker_ce_buff 159407)
				SpellInfo(combo_breaker_ce_buff duration=15)
			Define(combo_breaker_tp_buff 118864)
				SpellInfo(combo_breaker_tp_buff duration=15)
			Define(dampen_harm_buff 122278)
				SpellInfo(dampen_harm_buff duration=45)
			Define(death_note_buff 121125)
			Define(diffuse_magic_buff 122783)
				SpellInfo(diffuse_magic_buff duration=6)
			Define(elusive_brew_activated_buff 115308)
				SpellInfo(elusive_brew_activated_buff duration=1)
			Define(elusive_brew_stacks_buff 128939)
				SpellInfo(elusive_brew_stacks_buff duration=30 max_stacks=15)
			Define(energizing_brew_buff 115288)
				SpellInfo(energizing_brew_buff duration=6 tick=1)
				SpellInfo(energizing_brew_buff addduration=5 itemset=T14_melee itemcount=4)
			Define(enveloping_mist_buff 132120)
				SpellInfo(enveloping_mist_buff duration=6 tick=1)
			Define(extend_life_buff 185158)
				SpellInfo(extend_life_buff duration=12)
			Define(focus_of_xuen_buff 145024)
				SpellInfo(focus_of_xuen_buff duration=10)
			Define(fortifying_brew_buff 120954)
				SpellInfo(fortifying_brew_buff duration=15)
			Define(gale_burst_buff 195403)
			Define(guard_buff 115295)
				SpellInfo(guard_buff duration=30)
			Define(guard_glyphed_buff 123402)
				SpellInfo(guard_glyphed duration=30)
			Define(legacy_of_the_emperor_buff 115921)
				SpellInfo(legacy_of_the_emperor_buff duration=10)
			Define(legacy_of_the_white_tiger_buff 116781)
				SpellInfo(legacy_of_the_white_tiger_buff duration=10)
			Define(mana_tea_buff 115867)
				SpellInfo(mana_tea_buff duration=120 max_stacks=20)
			Define(power_strikes_buff 129914)
			Define(purifier_buff 138237) # tier15_4pc_tank bonus
				SpellInfo(purifier_buff duration=15)
			Define(renewing_mist_buff 119611)
				SpellInfo(renewing_mist_buff duration=18 haste=spell tick=2)
				SpellInfo(renewing_mist_buff addduration=2 if_spell=improved_renewing_mist)
			Define(serenity_buff 152173)
				SpellInfo(serenity_buff duration=10)
				SpellInfo(serenity_buff duration=5 specialization=brewmaster)
			Define(shuffle_buff 115307)
				SpellInfo(shuffle_buff duration=6)
			Define(soothing_mist_buff 115175)
				SpellInfo(soothing_mist_buff duration=8 haste=spell tick=1)
			Define(storm_earth_and_fire_buff 137639)
				SpellInfo(storm_earth_and_fire_buff max_stacks=2)
			Define(teachings_of_the_monastery_buff 202090)
				SpellInfo(teachings_of_the_monastery_buff duration=12 max_stacks=3)
			Define(thunder_focus_tea_buff 116680)
				SpellInfo(thunder_focus_tea_buff duration=30)
			Define(tiger_power_buff 125359)
				SpellInfo(tiger_power_buff duration=20 tick=1)
			Define(tigereye_brew_use_buff 116740)
				SpellInfo(tigereye_brew_use_buff duration=15)
			Define(tigereye_brew_buff 125195)
				SpellInfo(tigereye_brew_buff duration=120 max_stacks=20)
			Define(touch_of_karma_buff 122470)
				SpellInfo(touch_of_karma_buff duration=10)
			Define(vital_mists_buff 118674)
				SpellInfo(vital_mists_buff duration=30)
			Define(zen_sphere_buff 124081)
				SpellInfo(zen_sphere_buff duration=16 haste=spell tick=2)

			# Debuffs
			Define(breath_of_fire_debuff 123725)
				SpellInfo(breath_of_fire_debuff duration=8 tick=2)
			Define(dizzying_haze_debuff 116330)
				SpellInfo(dizzying_haze_debuff duration=15)
			Define(heavy_stagger_debuff 124273)
				SpellInfo(heavy_stagger_debuff duration=10 tick=1)
			Define(leg_sweep_debuff 119381)
			Define(light_stagger_debuff 124275)
				SpellInfo(light_stagger_debuff duration=10 tick=1)
			Define(moderate_stagger_debuff 124274)
				SpellInfo(moderate_stagger_debuff duration=10 tick=1)
			Define(rising_sun_kick_debuff 107428)
				SpellInfo(rising_sun_kick_debuff duration=10)
			Define(storm_earth_and_fire_target_debuff 138130)

			# Items
			Define(t18_class_trinket 124517)
		]];

		OvaleScripts:RegisterScript("MONK", nil, name, desc, code, "include");
	end
end