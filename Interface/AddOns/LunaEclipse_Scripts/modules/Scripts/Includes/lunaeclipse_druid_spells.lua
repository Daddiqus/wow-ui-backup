local addonName, addonTable = ...; -- Pulls back the Addon-Local Variables and store them locally.
local FORCE_DEBUG = false;

if LunaEclipse_Scripts:isCompatableWOWVersion() and LunaEclipse_Scripts:isRequiredOvaleVersion(addonTable.REQUIRED_OVALE_VERSION) then
	local OvaleScripts = addonTable.Ovale.OvaleScripts;

	do
		local name = "lunaeclipse_druid_spells";
		local desc = "LunaEclipse: Druid spells";
		local code = [[
			# Druid spells and functions
			Define(ashamanes_bite 210702)
			Define(ashamanes_frenzy 210722)
				SpellInfo(ashamanes_frenzy cd=75 combo=3)
				SpellAddBuff(ashamanes_frenzy bloodtalons_buff=-1)
			Define(ashamanes_rip_debuff 224435)
			Define(astral_communion 202359)
				SpellInfo(astral_communion cd=80 astralpower=-75)
			Define(astral_influence 197524)
			Define(barkskin 22812)
				SpellInfo(barkskin cd=60 gcd=0 offgcd=1)
				SpellInfo(barkskin addcd=30 specialization=guardian talent=!survival_of_the_fittest)
			Define(bear_form 5487)
				SpellInfo(bear_form to_stance=druid_bear_form)
				SpellInfo(bear_form unusable=1 if_stance=druid_bear_form)
			Define(bear_form_buff 5487)
			Define(berserk 106951)
			Define(berserk_cat 106951)
				SpellInfo(berserk_cat cd=180 gcd=0 offgcd=1)
				SpellAddBuff(berserk_cat berserk_cat_buff=1)
				SpellInfo(berserk_cat duration=15)
				SpellInfo(berserk_cat replace=incarnation_king_of_the_jungle talent=incarnation_talent)
			SpellList(berserk_cat_buff incarnation_king_of_the_jungle_buff berserk_cat) # berserk_cat_buff needs to apply to incarnation_king_of_the_jungle_buff as well
			Define(blessing_of_anshe_buff 202739)
			Define(blessing_of_elune_buff 202737)
			Define(blessing_of_the_ancients 202360)
				SpellInfo(blessing_of_the_ancients cd=15)
				SpellAddBuff(blessing_of_the_ancients blessing_of_elune_buff=1 if_buff=blessing_of_anshe_buff)
				SpellAddBuff(blessing_of_the_ancients blessing_of_anshe_buff=1 if_buff=blessing_of_elune_buff)
			Define(bloodtalons 155672)
			Define(bloodtalons_buff 145152)
				SpellInfo(bloodtalons_buff duration=30 max_stacks=2)
			Define(bristling_fur 155835)
				SpellInfo(bristling_fur cd=40 gcd=0 offgcd=1)
				SpellAddBuff(bristling_fur bristling_fur_buff=1)
			Define(bristling_fur_buff 155835)
				SpellInfo(bristling_fur_buff duration=8)
			Define(brutal_slash 202028)
				SpellInfo(brutal_slash cd=18 cd_haste=melee charges=3 stance=druid_cat_form)
				SpellInfo(brutal_slash combo=1 energy=20 physical=1)
				SpellInfo(brutal_slash buff_energy=berserk_cat_buff buff_energy_amount=-10)
				SpellRequire(brutal_slash energy 0=buff,clearcasting_buff if_spell=omen_of_clarity)
				SpellAddBuff(brutal_slash bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddBuff(brutal_slash clearcasting_buff=-1 if_spell=omen_of_clarity)
			Define(cat_form 768)
				SpellInfo(cat_form to_stance=druid_cat_form)
				SpellInfo(cat_form unusable=1 if_stance=druid_cat_form)
				SpellAddBuff(cat_form cat_form_buff=1)
			Define(cat_form_buff 768)
			Define(celestial_alignment 194223)
				SpellInfo(celestial_alignment cd=180)
				SpellAddBuff(celestial_alignment celestial_alignment_buff=1)
			Define(celestial_alignment_buff 194223)
			Define(cenarion_ward 102351)
				SpellInfo(cenarion_ward cd=30)
				SpellAddTargetBuff(cenarion_ward cenarion_ward_buff=1)
			Define(cenarion_ward_buff 102351)
				SpellInfo(cenarion_ward_buff duration=8)
			Define(circadian_invocation_moonfire_debuff 240606)
				SpellInfo(circadian_invocation_moonfire_debuff duration=10)
			Define(circadian_invocation_sunfire_debuff 240607)
				SpellInfo(circadian_invocation_sunfire_debuff duration=10)
			Define(clearcasting 135700)
			Define(clearcasting_buff 135700)
				SpellInfo(clearcasting_buff duration=15)
				#TODO Next spell have no energy cost
			Define(dash 1850)
				SpellInfo(dash cd=180 gcd=0 offgcd=1)
				SpellInfo(dash to_stance=druid_cat_form if_stance=!druid_cat_form)
			Define(displacer_beast 102280)
				SpellInfo(displacer_beast cd=30)
				SpellInfo(displacer_beast to_stance=druid_cat_form if_stance=!druid_cat_form)
				SpellAddBuff(displacer_beast displacer_beast_buff=1)
			Define(displacer_beast_buff 137452)
				SpellInfo(displacer_beast_buff duration=4)
			Define(efflorescence 145205)
				SpellAddBuff(efflorescence efflorescence_buff=1)
			Define(efflorescence_buff 145205)
				SpellInfo(efflorescence_buff duration=30)
			Define(elunes_guidance 202060)
				SpellInfo(elunes_guidance cd=45 combo=5)
			Define(elunes_guidance_buff 202060)
				#TODO 1 combo per s
			Define(entangling_roots 339)
			Define(ferocious_bite 22568)
				SpellInfo(ferocious_bite combo=finisher energy=25 extra_energy=25 physical=1 stance=druid_cat_form)
				SpellInfo(ferocious_bite buff_energy=berserk_cat_buff buff_energy_amount=-12.5)
				SpellAddBuff(ferocious_bite bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddTargetDebuff(ferocious_bite rip_debuff=refresh_keep_snapshot)
			Define(flourish 197721)
				SpellInfo(flourish cd=60)
			Define(force_of_nature 205636)
				SpellInfo(force_of_nature cd=60)
			Define(frenzied_regeneration 22842)
				SpellInfo(frenzied_regeneration cd=24 offgcd=1)
				SpellAddBuff(frenzied_regeneration frenzied_regeneration_buff=1)
			Define(frenzied_regeneration_buff 22842)
			Define(fury_of_elune 202770)
				SpellInfo(fury_of_elune cd=90 astralpower=6)
				SpellAddBuff(fury_of_elune fury_of_elune_up_buff=1)
			Define(fury_of_elune_talent 19)
			Define(fury_of_elune_up_buff 202770)
				#TODO 12 astralpower per s
			Define(full_moon 202771)	
				SpellInfo(full_moon cd=15 max_charges=3 astralpower=-40 sharedcd=new_moon)
			Define(galactic_guardian_buff 213708)
			Define(germination_buff 155777)
				SpellInfo(germination_buff duration=18)
			Define(gory_fur_buff 201671)
			Define(growl 6795)
				SpellInfo(growl cd=8)
			Define(half_moon 202768)
				SpellInfo(half_moon cd=15 max_charges=3 astralpower=-20 sharedcd=new_moon)
			Define(healing_touch 5185)
			Define(incapacitating_roar 99)
				SpellInfo(incapacitating_roar cd=30)
			Define(incarnation_chosen_of_elune 102560)
				SpellInfo(incarnation_chosen_of_elune cd=180)
				SpellAddBuff(incarnation_chosen_of_elune incarnation_chosen_of_elune_buff=1)
			Define(incarnation_chosen_of_elune_buff 102560)
				SpellInfo(incarnation_chosen_of_elune_buff duration=30)
			Define(incarnation_king_of_the_jungle 102543)
				SpellInfo(incarnation_king_of_the_jungle cd=180)
				SpellAddBuff(incarnation_king_of_the_jungle incarnation_king_of_the_jungle_buff=1)
			Define(incarnation_king_of_the_jungle_buff 102543)
				SpellInfo(incarnation_king_of_the_jungle_buff duration=30)
			Define(incarnation_son_of_ursoc 102558)
				SpellInfo(incarnation_son_of_ursoc cd=180)
				SpellAddBuff(incarnation_son_of_ursoc incarnation_son_of_ursoc_buff=1)
			Define(incarnation_son_of_ursoc_buff 102558)
				SpellInfo(incarnation_son_of_ursoc_buff duration=30)
			Define(incarnation_tree_of_life 33891)
				SpellInfo(incarnation_tree_of_life cd=180)
				SpellAddBuff(incarnation_tree_of_life incarnation_tree_of_life_buff=1)
			Define(incarnation_tree_of_life_buff 117679)
				SpellInfo(incarnation_tree_of_life_buff duration=30)
			Define(infected_wounds 48484)
			Define(innervate 29166)
				SpellInfo(innervate cd=180)
				SpellAddTargetBuff(innervate innervate_buff=1)
			Define(innervate_buff 29166)
				#TODO The spells cost no mana
			Define(ironbark 102342)
				SpellInfo(ironbark cd=90)
				SpellAddTargetBuff(ironbark ironbark_buff=1)
			Define(ironbark_buff 102342)
				SpellInfo(ironbark_buff duration=12)
			Define(ironfur 192081)
				SpellInfo(ironfur rage=45 cd=0.5 offgcd=1)
				SpellAddBuff(ironfur ironfur_buff=1)
			Define(ironfur_buff 192081)
			Define(lifebloom 33763)
				SpellAddTargetBuff(lifebloom lifebloom_buff=1)
			Define(lifebloom_buff 33763)
				SpellInfo(lifebloom_buff duration=15)
			Define(lunar_beam 204066)
				SpellInfo(lunar_beam cd=90)
			Define(lunar_empowerment_buff 164547)
				SpellInfo(lunar_empowerment_buff max_stacks=3)
			Define(lunar_strike_balance 194153)
				SpellInfo(lunar_strike_balance astralpower=-12)
				SpellRequire(lunar_strike_balance astralpower_percent 150=buff,celestial_alignment_buff)
				SpellRequire(lunar_strike_balance astralpower_percent 150=buff,incarnation_chosen_of_elune_buff)
				SpellRequire(lunar_strike_balance astralpower_percent 125=buff,blessing_of_elune_buff)
				#SpellAddTargetDebuff(lunar_strike_balance moonfire_debuff=extend,5 talent=natures_balance_talent)
				SpellAddBuff(lunar_strike_balance lunar_empowerment_buff=-1)
			Define(lunar_strike 197628)
				SpellAddBuff(lunar_strike lunar_empowerment_buff=0)
			Define(maim 22570)
				SpellInfo(maim cd=10 combo=finisher energy=35 interrupt=1 physical=1 stance=druid_cat_form)
				SpellInfo(maim buff_energy=berserk_cat_buff buff_energy_amount=-17.5)
			Define(mangle 33917)
				SpellInfo(mangle rage=-6 cd=6 cd_haste=melee)
			Define(mark_of_ursol 192083)
				SpellInfo(mark_of_ursol rage=45 cd=0.5 offgcd=1)
				SpellAddBuff(mark_of_ursol mark_of_ursol_buff=1)
			Define(mark_of_ursol_buff 192083)
			Define(mass_entanglement 102359)
				SpellInfo(mass_entanglement cd=30)
			Define(maul 6807)
				SpellInfo(maul cd=3 cd_haste=melee gcd=0 offgcd=1 rage=20 stance=druid_bear_form)
			Define(mighty_bash 5211)
				SpellInfo(mighty_bash cd=50 interrupt=1)
			Define(moonfire 8921)
				SpellInfo(moonfire astralpower=-3)
				SpellAddBuff(moonfire moonfire_debuff=1)
			Define(moonfire_cat 155625)
				SpellInfo(moonfire_cat combo=1 energy=30 stance=druid_cat_form)
				SpellInfo(moonfire_cat unusable=1 if_stance=!druid_cat_form)
				SpellInfo(moonfire_cat unusable=1 specialization=!feral)
				SpellInfo(moonfire_cat unusable=1 talent=!lunar_inspiration_talent)
				SpellAddTargetDebuff(moonfire_cat moonfire_cat_debuff=1)
			Define(moonfire_cat_debuff 155625)
				SpellInfo(moonfire_cat_debuff duration=14 haste=melee tick=2)
			Define(moonfire_debuff 164812)
				SpellInfo(moonfire_debuff duration=16)
			Define(moonfire_dmg_debuff 164812)
			Define(moonkin_form 24858)
				SpellInfo(moonkin_form to_stance=druid_moonkin_form)
				SpellInfo(moonkin_form unusable=1 if_stance=druid_moonkin_form)
			Define(new_moon 202767)
				SpellInfo(new_moon cd=15 max_charges=3 astralpower=-10)
			Define(omen_of_clarity 16864)
			Define(omen_of_clarity_buff 16870)
			Define(owlkin_frenzy_buff 157228)
				SpellInfo(owlkin_frenzy_buff duration=10)
			Define(predatory_swiftness 16974)
			Define(predatory_swiftness_buff 69369)
				SpellInfo(predatory_swiftness_buff duration=12)
				#TODO Healing touch, entangling_roots and rebirth are instant and free
			Define(primal_fury 159286)
			Define(prowl 5215)
				SpellInfo(prowl cd=10 gcd=0 offgcd=1 to_stance=druid_cat_form)
				SpellAddBuff(prowl prowl_buff=1)
			Define(prowl_buff 5215)
			Define(pulverize 80313)
				SpellRequire(pulverize unusable 1=target_debuff,!thrash_bear_debuff,2)
				SpellAddBuff(pulverize pulverize_buff=1)
				SpellAddTargetDebuff(pulverize thrash_bear_debuff=-2)
			Define(pulverize_buff 158792)
				SpellInfo(pulverize_buff duration=20)
			Define(rage_of_the_sleeper 200851)
				SpellInfo(rage_of_the_sleeper cd=90)
			Define(rake 1822)
				SpellInfo(rake combo=1 energy=35 stance=druid_cat_form)
				SpellInfo(rake buff_energy=berserk_cat_buff buff_energy_amount=-17.5)
				SpellAddBuff(rake bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddTargetDebuff(rake rake_debuff=1)
				SpellDamageBuff(rake bloodtalons_buff=1.5 talent=bloodtalons_talent)
				SpellDamageBuff(rake_debuff incarnation_king_of_the_jungle_buff=2)
				SpellDamageBuff(rake_debuff prowl_buff=2)
				SpellDamageBuff(rake_debuff shadowmeld_buff=2)
				SpellDamageBuff(rake savage_roar_buff=1.25 talent=savage_roar_talent)
				SpellDamageBuff(rake tigers_fury_buff=1.15 if_spell=tigers_fury)
			Define(rake_debuff 155722)
				SpellInfo(rake_debuff duration=15 tick=3 talent=!jagged_wounds_talent)
				SpellInfo(rake_debuff duration=10.05 tick=2.01 talent=jagged_wounds_talent)
				SpellDamageBuff(rake_debuff bloodtalons_buff=1.5 talent=bloodtalons_talent)
				SpellDamageBuff(rake_debuff incarnation_king_of_the_jungle_buff=2)
				SpellDamageBuff(rake_debuff prowl_buff=2)
				SpellDamageBuff(rake_debuff shadowmeld_buff=2)
				SpellDamageBuff(rake_debuff savage_roar_buff=1.25 talent=savage_roar_talent)
				SpellDamageBuff(rake_debuff tigers_fury_buff=1.15 if_spell=tigers_fury)
			Define(rebirth 20484) 
			    # Rebirth removing PS buff is a bug since Rebirth is instant for Feral now.  Remove when fixed.
				SpellAddBuff(rebirth predatory_swiftness_buff=-1 if_spell=predatory_swiftness)
			Define(regrowth 8936)
				SpellInfo(regrowth gcd_haste=spell if_buff=predatory_swiftness_buff)
				SpellAddBuff(regrowth bloodtalons_buff=1 talent=bloodtalons_talent specialization=feral)
				SpellAddTargetBuff(regrowth regrowth_buff=1)
				SpellAddBuff(regrowth omen_of_clarity_buff=-1)
			Define(regrowth_buff 8936)
				SpellInfo(regrowth_buff duration=12)
			Define(rejuvenation 774)
				SpellAddTargetBuff(rejuvenation rejuvenation_buff=1)
			Define(rejuvenation_buff 774)
				SpellInfo(rejuvenation_buff duration=15)
			Define(remove_corruption 2782)
			Define(renewal 108238)
				SpellInfo(renewal cd=120 gcd=0 offgcd=1)
			Define(revive 50769)
			Define(rip 1079)
				SpellInfo(rip combo=finisher energy=30 stance=druid_cat_form)
				SpellInfo(rip buff_energy=berserk_cat_buff buff_energy_amount=-15)
				SpellAddTargetDebuff(rip rip_debuff=1)
			Define(rip_debuff 1079)
				SpellInfo(rip_debuff duration=24 tick=2 talent=!jagged_wounds_talent)
				SpellInfo(rip_debuff duration=16.08 tick=1.34 talent=jagged_wounds_talent)
				SpellDamageBuff(rip_debuff bloodtalons_buff=1.5  talent=bloodtalons_talent)
				SpellDamageBuff(rip_debuff savage_roar_buff=1.25 talent=savage_roar_talent)
				SpellDamageBuff(rip_debuff tigers_fury_buff=1.15 if_spell=tigers_fury)
			Define(savage_roar 52610)
				SpellInfo(savage_roar combo=finisher energy=40 stance=druid_cat_form)
				SpellInfo(savage_roar duration=4 adddurationcp=4)
				SpellInfo(savage_roar buff_energy=berserk_cat_buff buff_energy_amount=-20)
				SpellInfo(savage_roar unusable=1 talent=!savage_roar_talent)
				SpellAddBuff(savage_roar savage_roar_buff=1)
			Define(savage_roar_buff 52610)
			Define(solar_empowerment_buff 164545)
				SpellInfo(solar_empowerment_buff max_stacks=3)
			Define(shadowmeld_buff 58984)
			Define(shred 5221)
				SpellInfo(shred combo=1 energy=40 physical=1 stance=druid_cat_form)
				SpellInfo(shred buff_energy=berserk_cat_buff buff_energy_amount=-20)
				SpellRequire(shred energy 0=buff,clearcasting_buff if_spell=omen_of_clarity)
				SpellAddBuff(shred bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddBuff(shred clearcasting_buff=-1 if_spell=omen_of_clarity)
			Define(skull_bash 106839)
				SpellInfo(skull_bash cd=15 gcd=0 offgcd=1 interrupt=1)
			Define(solar_beam 78675)
				SpellInfo(solar_beam cd=60 gcd=0 offgcd=1 interrupt=1)
			Define(solar_wrath 190984)
				SpellInfo(solar_wrath travel_time=1 astralpower=-8)
				SpellRequire(solar_wrath astralpower_percent 150=buff,celestial_alignment_buff)
				SpellRequire(solar_wrath astralpower_percent 150=buff,incarnation_chosen_of_elune_buff)
				SpellRequire(solar_wrath astralpower_percent 125=buff,blessing_of_elune_buff)
				#SpellAddTargetDebuff(solar_wrath sunfire_debuff=extend,3.3 talent=natures_balance_talent)
				SpellAddBuff(solar_wrath solar_empowerment_buff=-1)
			Define(spring_blossom_buff 207386)
				SpellInfo(spring_blossom_buff duration=6)
			Define(stampeding_roar 77761)
				SpellInfo(stampeding_roar cd=120)
			Define(starfall 191034)
				SpellInfo(starfall astralpower=60)
				SpellInfo(starfall addastralpower=-20 talent=soul_of_the_forest_talent)
				SpellAddTargetDebuff(starfall stellar_empowerment_debuff=1)
				SpellAddBuff(starfall starfall_buff=1)
			Define(starfall_buff 191034)
				SpellInfo(starfall_buff duration=8)
			Define(starsurge 197626)
				SpellInfo(starsurge cd=10 astralpower=40)
				SpellAddBuff(starsurge lunar_empowerment_buff=1)
				SpellAddBuff(starsurge solar_empowerment_buff=1)
			Define(starsurge_moonkin 78674)
				SpellInfo(starsurge_moonkin astralpower=40)
				SpellRequire(starsurge_moonkin astralpower_percent 87.5=buff,the_emerald_dreamcatcher_buff,1)
				SpellRequire(starsurge_moonkin astralpower_percent 85.71=buff,the_emerald_dreamcatcher_buff,2)
				SpellRequire(starsurge_moonkin astralpower 0=buff,oneths_intuition_buff)
				SpellAddBuff(starsurge_moonkin lunar_empowerment_buff=1)
				SpellAddBuff(starsurge_moonkin solar_empowerment_buff=1)
				SpellAddBuff(starsurge_moonkin the_emerald_dreamcatcher_buff=1)
				SpellAddBuff(starsurge_moonkin oneths_intuition_buff=-1)
			Define(stellar_empowerment_debuff 197637)
			Define(stellar_flare 202347)
				SpellInfo(stellar_flare astralpower=15)
				SpellAddTargetDebuff(stellar_flare stellar_flare_debuff=1)
			Define(stellar_flare_debuff 202347)
				SpellInfo(stellar_flare_debuff duration=24 haste=spell tick=2)
			Define(sunfire 93402)
				SpellInfo(sunfire astralpower=-3)
				SpellAddTargetDebuff(sunfire sunfire_debuff=1)
			Define(sunfire_debuff 164815)
				SpellInfo(sunfire_debuff duration=12)
			Define(sunfire_dmg_debuff 164815)
			Define(survival_instincts 61336)
				SpellInfo(survival_instincts cd=120 gcd=0 offgcd=1 charges=2)
				SpellInfo(survival_instincts addcd=120 specialization=guardian)
				SpellInfo(survival_instincts addcd=-80 specialization=guardian talent=survival_of_the_fittest)
				SpellAddBuff(survival_instincts survival_instincts_buff=1)
			Define(survival_instincts_buff 61336)
				SpellInfo(survival_instincts_buff duration=6)
			Define(swiftmend 18562)
				SpellInfo(swiftmend cd=30)
			Define(swipe_bear 213771)
				SpellInfo(swipe_bear stance=druid_bear_form)
			Define(swipe_cat 106785) # Artifact will reduce energy cost by 2 for every target with thrash_cat_debuff
				SpellInfo(swipe_cat combo=1 energy=45 physical=1 stance=druid_cat_form)
				SpellInfo(swipe_cat buff_energy=berserk_cat_buff buff_energy_amount=-22.5)
				SpellRequire(swipe_cat energy 0=buff,clearcasting_buff if_spell=omen_of_clarity)
				SpellAddBuff(swipe_cat bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddBuff(swipe_cat clearcasting_buff=-1 if_spell=omen_of_clarity)
			Define(t18_class_trinket 124514)
			Define(tigers_fury 5217)
				SpellInfo(tigers_fury cd=30 energy=-60 gcd=0 offgcd=1 stance=druid_cat_form)
				SpellAddBuff(tigers_fury tigers_fury_buff=1)
			Define(tigers_fury_buff 5217)
				SpellInfo(tigers_fury duration=8)
			Define(thrash_bear 77758) # Applies the stacking debuff pulverize uses now
				SpellInfo(thrash_bear rage=-4 cd=6 cd_haste=melee stance=druid_bear_form)
				SpellAddTargetDebuff(thrash_bear thrash_bear_debuff=1)
			Define(thrash_bear_debuff 192090)
				SpellInfo(thrash_bear_debuff duration=15 max_stacks=3 tick=3)
			Define(thrash_cat 106830)
				SpellInfo(thrash_cat energy=50 stance=druid_cat_form)
				SpellInfo(thrash_cat buff_energy=berserk_cat_buff buff_energy_amount=-25)
				SpellRequire(thrash_cat energy 0=buff,clearcasting_buff if_spell=omen_of_clarity)
				SpellAddBuff(thrash_cat bloodtalons_buff=-1 talent=bloodtalons_talent)
				SpellAddBuff(thrash_cat clearcasting_buff=-1 if_spell=omen_of_clarity)
				SpellAddTargetDebuff(thrash_cat thrash_cat_debuff=1)
			Define(thrash_cat_debuff 106830)
				SpellInfo(thrash_cat_debuff duration=15 tick=3 talent=!jagged_wounds_talent)
				SpellInfo(thrash_cat_debuff duration=10.05 tick=2.01 talent=jagged_wounds_talent)
			Define(tranquility 740)
				SpellInfo(tranquility cd=120)
			Define(typhoon 132469)
				SpellInfo(typhoon cd=30 interrupt=1)
			Define(warrior_of_elune 202425)
			Define(warrior_of_elune_buff 202425)
				#TODO 2 Lunar strikes are instant
			Define(wildgrowth 48438)
				SpellInfo(wildgrowth cd=10)
				SpellAddTargetBuff(wildgrowth wildgrowth_buff=1)
			Define(wildgrowth_buff 48438)
				SpellInfo(wildgrowth duration=7)
			Define(wild_charge 102401)
				SpellInfo(wild_charge cd=15 gcd=0 offgcd=1)
				SpellInfo(wild_charge replace=wild_charge_bear if_stance=druid_bear_form)
				SpellInfo(wild_charge replace=wild_charge_cat if_stance=druid_cat_form)
			Define(wild_charge_bear 16979)
				SpellInfo(wild_charge_bear cd=15 stance=druid_bear_form)
			Define(wild_charge_cat 49376)
				SpellInfo(wild_charge_cat cd=15 stance=druid_cat_form)

			# Talents Common
			Define(renewal_talent 4)
			Define(displacer_beast_talent 5)
			Define(wild_charge_talent 6)
			Define(balance_affinity_talent 7)
			Define(feral_affinity_balance_talent 7)
			Define(guardian_affinity_talent 8)
			Define(feral_affinity_guardian_talent 8)
			Define(feral_affinity_restoration_talent 8)
			Define(restoration_affinity_talent 9)
			Define(guardian_affinity_restoration_talent 9)
			Define(mighty_bash_talent 10)
			Define(mass_entanglement_talent 11)
			Define(typhoon_talent 12)
			Define(soul_of_the_forest_talent 13)
			Define(incarnation_talent 14)
			Define(moment_of_clarity_talent 21)

			# Talents Moonkin
			Define(force_of_nature_talent 1)
			Define(warrior_of_elune_talent 2)
			Define(starlord_talent 3)
			Define(stellar_flare_talent 15)
			Define(shooting_stars_talent 16)
			Define(astral_communion_talent 17)
			Define(blessing_of_the_ancients_talent 18)
			Define(fury_of_elune_talent 19)
			Define(stellar_drift_talent 20)
			Define(natures_balance_talent 21)

			# Talents Feral
			Define(predator_talent 1)
			Define(blood_scent_talent 2)
			Define(lunar_inspiration_talent 3)
			Define(savage_roar_talent 15)
			Define(sabertooth_talent 16)
			Define(jagged_wounds_talent 17)
			Define(elunes_guidance_talent 18)
			Define(brutal_slash_talent 19)
			Define(bloodtalons_talent 20)

			# Talents Guardian
			Define(survival_of_the_fittest 18)
			Define(pulverize_talent 21)

			# Talents Restoration
			Define(cenarion_ward_talent 2)
			Define(spring_blossom_talent 16)
			Define(germination_talent 18)
			Define(flourish_talent 21)

			# Artifact
			Define(essence_of_ghanir 208253)
				SpellInfo(essence_of_ghanir cd=90)

		]];

		OvaleScripts:RegisterScript("DRUID", nil, name, desc, code, "include");
	end
end