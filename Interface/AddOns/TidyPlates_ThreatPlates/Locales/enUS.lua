﻿local L = LibStub("AceLocale-3.0"):NewLocale("TidyPlatesThreat", "enUS", true, true)
--local L = LibStub("AceLocale-3.0"):NewLocale("TidyPlatesThreat", "enUS", true, false)
if not L then return end

---------------------------------------------------------------------------------------------------
-- Strings which are created dynamically in the addon
---------------------------------------------------------------------------------------------------
L["Show Friendly Units"] = true
L["Players"] = true
L["NPCs"] = true
L["Totems"] = true
L["Guardians"] = true
L["Pets"] = true

L["Show Enemy Units"] = true
L["Minuss"] = "Minors"

L["Show Neutral Units"] = true

---------------------------------------------------------------------------------------------------
-- String constants in the game
---------------------------------------------------------------------------------------------------
L["  <no option>        Displays options dialog"] = true
L["  help               Prints this help message"] = true
L["  update-profiles    Migrates deprecated settings in your configuration"] = true
L[" options by typing: /tptp"] = true
L[" role."] = true
L[" to DPS."] = true
L[" to tanking."] = true
L["-->>Nameplate Overlapping is now |cff00ff00ON!|r<<--"] = true
L["-->>Nameplate Overlapping is now |cffff0000OFF!|r<<--"] = true
L["-->>Threat Plates verbose is now |cff00ff00ON!|r<<--"] = true
L["-->>Threat Plates verbose is now |cffff0000OFF!|r<<-- shhh!!"] = true
L["-->>|cff00ff00Tank Plates Enabled|r<<--"] = true
L["-->>|cffff0000Activate Threat Plates from the Tidy Plates options!|r<<--"] = true
L["-->>|cffff0000DPS Plates Enabled|r<<--"] = true
L[". You have installed an older or incompatible version of TidyPlates: "] = true
L[":\n---------------------------------------\nWould you like to \nset your theme to |cff89F559Threat Plates|r?\n\nClicking '|cff00ff00Yes|r' will set you to Threat Plates. \nClicking '|cffff0000No|r' will open the Tidy Plates options."] = true
L[":\n---------------------------------------\n|cff89F559Threat Plates|r v8.4 introduces a new default look and feel (currently shown). Do you want to switch to this new look and feel?\n\nYou can revert your decision by changing the default look and feel again in the options dialog (under Nameplate Settings - Healthbar View - Default Settings).\n\nNote: Some of your custom settings may get overwritten if you switch back and forth."] = true
L["A to Z"] = true
L["About"] = true
L["Add black outline."] = true
L["Add thick black outline."] = true
L["Additional Adjustments"] = true
L["Additionally color the healthbar based on the target mark if the unit is marked."] = true
L["Additionally color the name based on the target mark if the unit is marked."] = true
L["Additionally color the nameplate's healthbar or name based on the target mark if the unit is marked."] = true
L["Adjust Color For"] = true
L["All Auras (Mine)"] = true
L["All Auras"] = true
L["Alpha & Scaling"] = true
L["Alpha by Status"] = true
L["Alpha"] = true
L["Amount Text Formatting"] = true
L["Amount Text"] = true
L["Anchor Point"] = true
L["Anchor"] = true
L["Appearance"] = true
L["Area"] = true
L["Arena 1"] = true
L["Arena 2"] = true
L["Arena 3"] = true
L["Arena 4"] = true
L["Arena 5"] = true
L["Arena Number Colors"] = true
L["Arena Orb Colors"] = true
L["Arena"] = true
L["Army of the Dead Ghoul"] = true
L["Art Options"] = true
L["Aura 2.0"] = true
L["Aura"] = true
L["Background Color"] = true
L["Background Color:"] = true
L["Background Opacity"] = true
L["Background Texture"] = true
L["Bar Border"] = true
L["Bar Height"] = true
L["Bar Limit"] = true
L["Bar Mode"] = true
L["Bar Width"] = true
L["Black List (Mine)"] = true
L["Black List"] = true
L["Blizzard Filter Options"] = true
L["Blizzard Nameplates for Friendly Units"] = true
L["Blizzard Nameplates"] = true
L["Blizzard Target Fading"] = true
L["Blizzard"] = true
L["Bone Spike"] = true
L["Border Color:"] = true
L["Border Texture"] = true
L["Bosses"] = true
L["Bottom-to-top"] = true
L["By Class"] = true
L["By Custom Color"] = true
L["By Health"] = true
L["By Reaction"] = true
L["Canal Crab"] = true
L["Cancel"] = true
L["Castbar"] = true
L["Change the color depending on the amount of health points the nameplate shows."] = true
L["Change the color depending on the reaction of the unit (friendly, hostile, neutral)."] = true
L["Changes the default settings to the selected design. Some of your custom settings may get overwritten if you switch back and forth.."] = true
L["Changing these settings will alter the placement of the nameplates, however the mouseover area does not follow. |cffff0000Use with caution!|r"] = true
L["Class Icons"] = true
L["Clear and easy to use nameplate theme for use with TidyPlates.\n\nCurrent version: "] = true
L["Clear"] = true
L["Color By Class"] = true
L["Color Healthbar By Enemy Class"] = true
L["Color Healthbar By Friendly Class"] = true
L["Color Healthbar by Target Marks in Healthbar View"] = true
L["Color Name by Target Marks in Headline View"] = true
L["Color by Dispel Type"] = true
L["Color by Health"] = true
L["Color by Reaction"] = true
L["Color by Target Mark"] = true
L["Color"] = true
L["Coloring"] = true
L["Colors"] = true
L["Column Limit"] = true
L["Combo Points"] = true
L["Cooldown Spiral"] = true
L["Copied!"] = true
L["Copy"] = true
L["Creation"] = true
L["Custom Color"] = true
L["Custom Nameplates"] = true
L["Custom No-Target Alpha"] = true
L["Custom No-Target Scale"] = true
L["Custom Target Alpha"] = true
L["Custom Target Scale"] = true
L["Custom"] = true
L["Custom-Text-specific"] = true
L["DPS/Healing"] = true
L["Darnavan"] = true
L["Debuffs On Friendly Units"] = true
L["Default Buff Color"] = true
L["Default Debuff Color"] = true
L["Default Settings (All Profiles)"] = true
L["Deficit Text"] = true
L["Define a custom alpha for this nameplate and overwrite any other alpha settings."] = true
L["Define a custom color for this nameplate and overwrite any other color settings."] = true
L["Define a custom scaling for this nameplate and overwrite any other scaling settings."] = true
L["Define base alpha settings for various unit types. Only one of these settings is applied to a unit at the same time, i.e., they are mutually exclusive."] = true
L["Define base scale settings for various unit types. Only one of these settings is applied to a unit at the same time, i.e., they are mutually exclusive."] = true
L["Deformed Fanatic"] = true
L["Determine your role (tank/dps/healing) automatically based on current spec."] = true
L["Disables nameplates (healthbar and name) for the units of this type and only shows an icon (if enabled)."] = true
L["Disabling this will turn off all icons for custom nameplates without harming other custom settings per nameplate."] = true
L["Disconnected Units"] = true
L["Display Settings"] = true
L["Display health amount text."] = true
L["Display health percentage text."] = true
L["Display health text on targets with full HP."] = true
L["Do not sort auras."] = true
L["Don't Switch"] = true
L["Drudge Ghoul"] = true
L["Duration"] = true
L["Ebon Gargoyle"] = true
L["Edge Size"] = true
L["Elite Border"] = true
L["Elite Icon Style"] = true
L["Elite Icon"] = true
L["Empowered Adherent"] = true
L["Enable Adjustments"] = true
L["Enable Alpha Threat"] = true
L["Enable Arena Widget"] = true
L["Enable Aura Widget 2.0"] = true
L["Enable Blizzard 'On-Target' Fading"] = true
L["Enable Class Icons Widget"] = true
L["Enable Coloring"] = true
L["Enable Combo Points Widget"] = true
L["Enable Custom Alpha"] = true
L["Enable Custom Color"] = true
L["Enable Custom Scale"] = true
L["Enable Enemy"] = true
L["Enable Friendly"] = true
L["Enable Friends"] = true
L["Enable Guild Members"] = true
L["Enable Headline View (Text-Only)"] = true
L["Enable Nameplates"] = true
L["Enable Quest Widget"] = true
L["Enable Resource Widget"] = true
L["Enable Scale Threat"] = true
L["Enable Social Widget"] = true
L["Enable Stealth Widget (Feature not yet fully implemented!)"] = true
L["Enable Target Highlight Widget"] = true
L["Enable Threat Coloring of Healthbar"] = true
L["Enable Threat System"] = true
L["Enable Threat Textures"] = true
L["Enable nameplate clickthrough for enemy units."] = true
L["Enable nameplate clickthrough for friendly units."] = true
L["Enable"] = true
L["Enabled Threat Glow"] = true
L["Enabling this will allow you to set the alpha adjustment for non-target nameplates."] = true
L["Enabling this will allow you to set the alpha adjustment for non-target names in headline view."] = true
L["Enemy Casting"] = true
L["Enemy Custom Text"] = true
L["Enemy NPCs"] = true
L["Enemy Name Color"] = true
L["Enemy Players"] = true
L["Enemy Status Text"] = true
L["Enemy Units"] = true
L["Everything"] = true
L["Faction Icon"] = true
L["Fanged Pit Viper"] = true
L["Filter by Dispel Type"] = true
L["Filter by Spell"] = true
L["Filter by Unit Reaction"] = true
L["Filtered Auras"] = true
L["Filtering"] = true
L["Font"] = true
L["Force Headline View while Out-of-Combat"] = true
L["Force Healthbar on Target"] = true
L["Foreground Texture"] = true
L["Friendly Caching"] = true
L["Friendly Casting"] = true
L["Friendly Custom Text"] = true
L["Friendly NPCs"] = true
L["Friendly Name Color"] = true
L["Friendly Names Color"] = true
L["Friendly Players"] = true
L["Friendly Status Text"] = true
L["Friendly Units"] = true
L["Friends & Guild Members"] = true
L["Gas Cloud"] = true
L["General Colors"] = true
L["General Nameplate Settings"] = true
L["General Settings"] = true
L["Group Quest"] = true
L["Guardians"] = true
L["Headline View X"] = true
L["Headline View Y"] = true
L["Headline View"] = true
L["Health Coloring"] = true
L["Health Text"] = true
L["Health"] = true
L["Healthbar Mode"] = true
L["Healthbar View"] = true
L["Healthbar X"] = true
L["Healthbar Y"] = true
L["Hide Friendly Units"] = true
L["Hide Healthbars"] = true
L["Hide Nameplate"] = true
L["Hide Special Units"] = true
L["Hide in Combat"] = true
L["Hide in Instance"] = true
L["Hide on Attacked Units"] = true
L["High Threat"] = true
L["Highlight Mobs on Off-Tanks"] = true
L["Highlight Texture"] = true
L["Horizontal Align"] = true
L["Horizontal Alignment"] = true
L["Horizontal Spacing"] = true
L["Hostile NPCs"] = true
L["Hostile Players"] = true
L["Icon Mode"] = true
L["Icon Style"] = true
L["Icon"] = true
L["If checked, nameplates of mobs attacking another tank can be shown with different color, scale, and opacity."] = true
L["If checked, threat feedback from boss level mobs will be shown."] = true
L["If checked, threat feedback from elite and rare mobs will be shown."] = true
L["If checked, threat feedback from minor mobs will be shown."] = true
L["If checked, threat feedback from mobs you're currently not in combat with will be shown."] = true
L["If checked, threat feedback from neutral mobs will be shown."] = true
L["If checked, threat feedback from normal mobs will be shown."] = true
L["If checked, threat feedback from tapped mobs will be shown regardless of unit type."] = true
L["If checked, threat feedback will only be shown in instances (dungeons, raids, arenas, battlegrounds), not in the open world."] = true
L["If enabled your nameplates alpha will always be the setting below when you have no target."] = true
L["If enabled your nameplates scale will always be the setting below when you have no target."] = true
L["If enabled your target's alpha will always be the setting below."] = true
L["If enabled your target's scale will always be the setting below."] = true
L["Ignore Marked Units"] = true
L["Ignored Alpha"] = true
L["Ignored Scaling"] = true
L["Immortal Guardian"] = true
L["In combat, use alpha based on threat level as configured in the threat system. The custom alpha is only used out of combat."] = true
L["In combat, use coloring based on threat level as configured in the threat system. The custom color is only used out of combat."] = true
L["In combat, use coloring, alpha, and scaling based on threat level as configured in the threat system. Custom settings are only used out of combat."] = true
L["In combat, use scaling based on threat level as configured in the threat system. The custom scale is only used out of combat."] = true
L["Interruptable Casts"] = true
L["Kinetic Bomb"] = true
L["Label Text Offset"] = true
L["Layout"] = true
L["Left-to-right"] = true
L["Level Text"] = true
L["Level"] = true
L["Lich King"] = true
L["Living Ember"] = true
L["Living Inferno"] = true
L["Look and Feel"] = true
L["Low Threat"] = true
L["Marked Immortal Guardian"] = true
L["Max HP Text"] = true
L["Medium Threat"] = true
L["Migrating deprecated settings in configuration ..."] = true
L["Minor"] = true
L["Mode"] = true
L["Mono"] = true
L["Mouseover"] = true
L["Muddy Crawfish"] = true
L["NPC Role"] = true
L["NPC Role, Guild"] = true
L["NPC Role, Guild, or Level"] = true
L["Nameplate Clickthrough"] = true
L["Nameplate Settings"] = true
L["Nameplate Style"] = true
L["Nameplate clickthrough cannot be changed while in combat."] = true
L["Names"] = true
L["Neutral NPCs"] = true
L["Neutral Units & Minions & Status"] = true
L["Neutral Units"] = true
L["No Outline, Monochrome"] = true
L["No target found."] = true
L["No"] = true
L["Non-Attacked Units"] = true
L["Non-Target Alpha"] = true
L["None"] = true
L["Normal Border"] = true
L["Normal Units"] = true
L["Nothing to paste!"] = true
L["Off-Tank"] = true
L["Offset X"] = true
L["Offset Y"] = true
L["Offset"] = true
L["Only Alternate Power"] = true
L["Only in Instances"] = true
L["Only on Attacked Units"] = true
L["Onyxian Whelp"] = true
L["Open Blizzard Settings"] = true
L["Open Options"] = true
L["Options"] = true
L["Outline"] = true
L["Outline, Monochrome"] = true
L["Paste"] = true
L["Pasted!"] = true
L["Percent Text"] = true
L["Pets"] = true
L["Placement"] = true
L["Player Quest"] = true
L["Preview"] = true
L["Quest"] = true
L["Quests of your group members that you don't have in your quest log or that you have already completed."] = true
L["Raging Spirit"] = true
L["Rares & Bosses"] = true
L["Rares & Elites"] = true
L["Reanimated Adherent"] = true
L["Reanimated Fanatic"] = true
L["Render font without antialiasing."] = true
L["Resource Bar"] = true
L["Resource Text"] = true
L["Resource"] = true
L["Restore Defaults"] = true
L["Reverse Order"] = true
L["Right-to-left"] = true
L["Row Limit"] = true
L["Same as Background"] = true
L["Same as Foreground"] = true
L["Same as Headline"] = true
L["Scale by Status"] = true
L["Scale"] = true
L["Set Icon"] = true
L["Set Name"] = true
L["Set alpha settings for different threat levels."] = true
L["Set scale settings for different threat levels."] = true
L["Set the roles your specs represent."] = true
L["Set threat textures and their coloring options here."] = true
L["Sets your spec "] = true
L["Shadow Fiend"] = true
L["Shadow"] = true
L["Shadowy Apparition"] = true
L["Shambling Horror"] = true
L["Shielded Coloring"] = true
L["Show Blizzard Nameplates for Friendly Units"] = true
L["Show Border"] = true
L["Show Buffs on Bosses"] = true
L["Show By Status"] = true
L["Show By Unit Type"] = true
L["Show Castbar in Headline View"] = true
L["Show Castbar"] = true
L["Show Elite Border"] = true
L["Show Elite Icon"] = true
L["Show Enemy"] = true
L["Show For"] = true
L["Show Friendly Class Icons"] = true
L["Show Friendly"] = true
L["Show Health Text"] = true
L["Show Icon to the Left"] = true
L["Show Level Text"] = true
L["Show Mouseover"] = true
L["Show Name Text"] = true
L["Show Nameplate"] = true
L["Show Overlay for Uninterruptable Casts"] = true
L["Show Skull Icon"] = true
L["Show Spell Icon"] = true
L["Show Spell Text"] = true
L["Show Target Mark Icon in Headline View"] = true
L["Show Target Mark Icon in Healthbar View"] = true
L["Show Target"] = true
L["Show all debuffs on friendly units that you can cure."] = true
L["Show all nameplates (CTRL-V)."] = true
L["Show an quest icon at the nameplate for quest mobs."] = true
L["Show auras as bars (with optional icons)."] = true
L["Show auras as icons in a grid configuration."] = true
L["Show auras in order created with oldest aura first."] = true
L["Show enemy nameplates (ALT-V)."] = true
L["Show friendly nameplates (SHIFT-V)."] = true
L["Show in Headline View"] = true
L["Show in Healthbar View"] = true
L["Show shadow with text."] = true
L["Show stack count as overlay on aura icon."] = true
L["Show the mouseover highlight on all units."] = true
L["Show threat feedback based on unit type or status or environmental conditions."] = true
L["Show threat glow only on units in combat with the player."] = true
L["Shows a border around the castbar of nameplates (requires /reload)."] = true
L["Shows a faction icon next to the nameplate of players."] = true
L["Shows a glow based on threat level around the nameplate's healthbar (in combat)."] = true
L["Shows an icon for friends and guild members next to the nameplate of players."] = true
L["Shows resource information for bosses and rares."] = true
L["Shows resource information only for alternatve power (of bosses or rares, mostly)."] = true
L["Size"] = true
L["Sizing"] = true
L["Skull Icon"] = true
L["Skull"] = true
L["Social"] = true
L["Sort Order"] = true
L["Sort by overall duration in ascending order."] = true
L["Sort by time left in ascending order."] = true
L["Sort in ascending alphabetical order."] = true
L["Spec Roles"] = true
L["Special Effects"] = true
L["Spell Icon"] = true
L["Spell Text"] = true
L["Spirit Wolf"] = true
L["Square"] = true
L["Stack Count"] = true
L["Status Text"] = true
L["Stealth"] = true
L["Style"] = true
L["Switch"] = true
L["Symbol"] = true
L["Tank"] = true
L["Tapped Units"] = true
L["Target Highlight"] = true
L["Target Marked Units"] = true
L["Target Marked"] = true
L["Target Markers"] = true
L["Target Only"] = true
L["Target Unit"] = true
L["Text Boundaries"] = true
L["Text Height"] = true
L["Text Width"] = true
L["Text at Full HP"] = true
L["Texture"] = true
L["Textures"] = true
L["These options allow you to control whether target marker icons are hidden or shown on nameplates and whether a nameplate's healthbar (in healthbar view) or name (in headline view) are colored based on target markers."] = true
L["These options allow you to control whether the castbar is hidden or shown on nameplates."] = true
L["These options allow you to control which nameplates are visible within the game field while you play."] = true
L["These settings will define the space that text can be placed on the nameplate. Having too large a font and not enough height will cause the text to be not visible."] = true
L["Thick Outline"] = true
L["Thick Outline, Monochrome"] = true
L["Thick"] = true
L["This allows you to save friendly player class information between play sessions or nameplates going off the screen. |cffff0000(Uses more memory)"] = true
L["This lets you select the layout style of the aura widget. (requires /reload)"] = true
L["This lets you select the layout style of the aura widget."] = true
L["This option allows you to control whether a spell's icon is hidden or shown on castbars."] = true
L["This option allows you to control whether a spell's name is hidden or shown on castbars."] = true
L["This option allows you to control whether a unit's health is hidden or shown on nameplates."] = true
L["This option allows you to control whether a unit's level is hidden or shown on nameplates."] = true
L["This option allows you to control whether a unit's name is hidden or shown on nameplates."] = true
L["This option allows you to control whether custom settings for nameplate style, color, alpha and scaling should be used for this nameplate."] = true
L["This option allows you to control whether headline view (text-only) is enabled for nameplates."] = true
L["This option allows you to control whether nameplates should fade in or out when displayed or hidden."] = true
L["This option allows you to control whether textures are hidden or shown on nameplates for different threat levels. Dps/healing uses regular textures, for tanking textures are swapped."] = true
L["This option allows you to control whether the custom icon is hidden or shown on this nameplate."] = true
L["This option allows you to control whether the elite icon for elite units is hidden or shown on nameplates."] = true
L["This option allows you to control whether the skull icon for rare units is hidden or shown on nameplates."] = true
L["This option allows you to control whether threat affects the alpha of nameplates."] = true
L["This option allows you to control whether threat affects the healthbar color of nameplates."] = true
L["This option allows you to control whether threat affects the scale of nameplates."] = true
L["This widget shows a highlight border around the healthbar of your target's nameplate."] = true
L["This widget shows a quest icon above unit nameplates or colors the nameplate healthbar of units that are involved with any of your current quests."] = true
L["This widget shows a stealth icon on nameplates of units that can detect stealth."] = true
L["This widget shows a unit's auras (buffs and debuffs) on its nameplate."] = true
L["This widget shows class icons on nameplates of players."] = true
L["This widget shows icons for friends, guild members, and faction on nameplates."] = true
L["This widget shows information about your target's resource on your target nameplate. The resource bar's color is derived from the type of resource automatically."] = true
L["This widget shows various icons (orbs and numbers) on enemy nameplates in arenas for easier differentiation."] = true
L["This widget shows your combo points on your target nameplate."] = true
L["This widget will display auras that match your filtering on your target nameplate and others you recently moused over."] = true
L["This will allow you to add additional scaling changes to specific mob types."] = true
L["This will allow you to disable threat art on target marked units."] = true
L["This will allow you to disable threat scale changes on target marked units."] = true
L["This will allow you to disabled threat alpha changes on target marked units."] = true
L["This will color the aura based on its type (poison, disease, magic, curse) - for Icon Mode the icon border is colored, for Bar Mode the bar itself."] = true
L["This will format text to a simpler format using M or K for millions and thousands. Disabling this will show exact HP amounts."] = true
L["This will format text to show both the maximum hp and current hp."] = true
L["This will format text to show hp as a value the target is missing."] = true
L["This will toggle the aura widget to only show for your current target."] = true
L["This will toggle the aura widget to show the cooldown spiral on auras. (requires /reload)"] = true
L["This will toggle the aura widget to show the cooldown spiral on auras."] = true
L["Threat System"] = true
L["Tidy Plates Fading"] = true
L["Time Left"] = true
L["Time Text Offset"] = true
L["Toggling"] = true
L["Top-to-bottom"] = true
L["Totem Alpha"] = true
L["Totem Nameplates"] = true
L["Totem Scale"] = true
L["Treant"] = true
L["Truncate Text"] = true
L["Type direct icon texture path using '\\' to separate directory folders, or use a spellid."] = true
L["Typeface"] = true
L["Undetermined"] = true
L["Uninterruptable Casts"] = true
L["Unit Base Alpha"] = true
L["Unit Base Scale"] = true
L["Unknown option: "] = true
L["Usage: /tptp [options]"] = true
L["Use Blizzard default nameplates for friendly nameplates and disable ThreatPlates for these units."] = true
L["Use Target's Name"] = true
L["Use Threat Alpha"] = true
L["Use Threat Coloring"] = true
L["Use Threat Scale"] = true
L["Use a custom color for healthbar (in healthbar view) or name (in headline view) of friends and/or guild members."] = true
L["Use a custom color for the healtbar's background."] = true
L["Use a custom color for the healtbar's border."] = true
L["Use a custom color for the healthbar of quest mobs."] = true
L["Use a custom color for the healthbar of your current target."] = true
L["Use alpha settings of healthbar view also to headline view."] = true
L["Use scaling settings of healthbar view also to headline view."] = true
L["Use the healthbar's background color also for the border."] = true
L["Use the healthbar's foreground color also for the background."] = true
L["Use the healthbar's foreground color also for the border."] = true
L["Val'kyr Shadowguard"] = true
L["Venomous Snake"] = true
L["Vertical Align"] = true
L["Vertical Alignment"] = true
L["Vertical Spacing"] = true
L["Viper"] = true
L["Visibility"] = true
L["Volatile Ooze"] = true
L["Warning Glow for Threat"] = true
L["Water Elemental"] = true
L["We're unable to change this while in combat"] = true
L["Web Wrap"] = true
L["White List (Mine)"] = true
L["White List"] = true
L["Wide"] = true
L["Widgets"] = true
L["X"] = true
L["Y"] = true
L["Yes"] = true
L["You can access the "] = true
L["Your own quests that you have to complete."] = true
L["\n\nFeel free to email me at |cff00ff00threatplates@gmail.com|r\n\n--\n\nBlacksalsify\n\n(Original author: Suicidal Katt - |cff00ff00Shamtasticle@gmail.com|r)"] = true
L["options:"] = true
L["|cff00ff00High Threat|r"] = true
L["|cff00ff00Low Threat|r"] = true
L["|cff00ff00Tank|r"] = true
L["|cff00ff00tanking|r"] = true
L["|cff0faac8Off-Tank|r"] = true
L["|cff89F559Threat Plates|r: DPS switch detected, you are now in your |cffff0000dpsing / healing|r role."] = true
L["|cff89F559Threat Plates|r: Role toggle not supported because automatic role detection is enabled."] = true
L["|cff89F559Threat Plates|r: Tank switch detected, you are now in your |cff00ff00tanking|r role."] = true
L["|cff89f559 role.|r"] = true
L["|cff89f559Additional options can be found by typing |r'/tptp'|cff89F559.|r"] = true
L["|cff89f559Threat Plates:|r Welcome back |cff"] = true
L["|cff89f559Welcome to |rTidy Plates: |cff89f559Threat Plates!\nThis is your first time using Threat Plates and you are a(n):\n|r|cff"] = true
L["|cff89f559You are currently in your "] = true
L["|cffff0000DPS/Healing|r"] = true
L["|cffff0000High Threat|r"] = true
L["|cffff0000Low Threat|r"] = true
L["|cffff0000dpsing / healing|r"] = true
L["|cffffff00Medium Threat|r"] = true
L["|cffffffffGeneral Settings|r"] = true
L["|cffffffffTotem Settings|r"] = true
L['Reverse the sort order (e.g., "A to Z" becomes "Z to A").'] = true