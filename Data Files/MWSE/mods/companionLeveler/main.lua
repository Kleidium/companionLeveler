----Initialize-------------------------------------------------------------------------------------------------------------------
local config = require("companionLeveler.config")
local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")
local buildMode = require("companionLeveler.modes.buildMode")
local npcMode = require("companionLeveler.modes.npcClassMode")
local creMode = require("companionLeveler.modes.creClassMode")
local root = require("companionLeveler.menus.root")
local abilities = require("companionLeveler.functions.abilities")
local tables = require("companionLeveler.tables")


local function initialized()
	log:info("" .. tables.version .. " Initialized.")
	if not tes3.isModActive("companionLeveler.ESP") then
		log:warn("companionLeveler.esp not active. Errors will occur.")
		func.clMessageBox("companionLeveler.esp not active. Errors will occur.")
	end
end
event.register("initialized", initialized)

local function versionCheck()
	log:info("Checking version...")
	local partyTable = func.partyTable()

	for i = 1, #partyTable do
		func.updateModData(partyTable[i])
	end

	log:info("Version check complete.")
end
event.register("loaded", versionCheck)



--
----Level-Up Mode------------------------------------------------------------------------------------------------------------------------------
--

local function onLevelUp()
	if config.expMode == true then return end

	--Mode Select
	if config.buildMode == true then
		local buildTable = func.buildTable()

		if #buildTable > 0 then
			buildMode.companionLevelBuild(buildTable)
		end
	else
		local npcTable = func.npcTable()
		local creTable = func.creTable()

		if #npcTable > 0 then
			npcMode.levelUp(npcTable)
		end

		if #creTable > 0 then
			creMode.levelUp(creTable)
		end
	end
end
event.register("levelUp", onLevelUp)


--
----Exp Mode----------------------------------------------------------------------------------------------------------------------
--

--Level Up
local function handleLevelUp(build, npc, creature)
    if #build > 0 then
        buildMode.companionLevelBuild(build)
    else
        if #npc > 0 then
            npcMode.levelUp(npc)
        end
        if #creature > 0 then
            creMode.levelUp(creature)
        end
    end
end

--Skill Experience
local function onSkillRaised(e)
	abilities.comprehension(e)
	abilities.julianos(e)

	if config.expMode == false then return end

	--Determine EXP Rewarded------------------------------------------------
	local majSkills = tes3.player.object.class.majorSkills
	local minSkills = tes3.player.object.class.minorSkills
	local classSkill = 0
	local amtRewarded = 0

	for n = 1, 5 do
		if (e.skill == majSkills[n] or e.skill == minSkills[n]) then
			classSkill = 1
			amtRewarded = config.expClassSkill
			log:debug("Major/Minor skill detected.")
		end
	end

	if classSkill == 0 then
		amtRewarded = config.expMiscSkill
		log:debug("Misc skill detected.")
	end

	--Insight #88
	local finalAmt = abilities.insight(amtRewarded)

	--Add EXP to companions------------------------------------------------
	local build, npc, creature = func.awardEXP(finalAmt)
	handleLevelUp(build, npc, creature)
end
event.register("skillRaised", onSkillRaised)

--Kill Experience/Abilities
local function onDeath(e)
	abilities.spectralWill(e)

	if string.startswith(e.reference.object.name, "Summoned") then return end

	abilities.contractKill(e)
	abilities.bountyKill(e)
	abilities.bloodKarma(e)
	abilities.huntCheck(e)
	abilities.killFeed(e)

	if config.expMode == false then return end

	--Level Up Tables
	local build, npc, creature = func.awardEXP(config.expKill)
	handleLevelUp(build, npc, creature)
end
event.register("death", onDeath)

--Quest Experience
local function onJournal(e)
	
	if config.expMode == false then return end

	if not e.new then
		--Level Up Tables
		local build, npc, creature = func.awardEXP(config.expQuest)
		handleLevelUp(build, npc, creature)
	end
end
event.register("journal", onJournal)


--
----Class/Type/Build Change Controls-------------------------------------------------------------------------------
--

event.register("uiActivated", function()
	local actor = tes3ui.getServiceActor()
	log:debug("Object Type: " .. actor.reference.baseObject.objectType .. "")

	if actor and func.validCompanionCheck(actor) and actor.inCombat == false then
		log:debug("NPC Follower detected. Giving class change topic.")
		tes3.applyConstantEffectEquipment({ reference = actor, activate = true })
		tes3.setGlobal("kl_companion", 1)
	else
		log:debug("Target not an NPC Follower. No class change topic given.")
		tes3.setGlobal("kl_companion", 0)
	end

	--Abilities
	abilities.fRep(actor)
	abilities.dibella(actor)

	--Clavicus Vile: Scampson
	if actor.object.baseObject.id == "kl_scamp_scampson" then
		func.applyScampsonContract(actor, "kl_scampson_weapons_contract", "bartersWeapons")
		func.applyScampsonContract(actor, "kl_scampson_armor_contract", "bartersArmor")
		func.applyScampsonContract(actor, "kl_scampson_clothing_contract", "bartersClothing")
		func.applyScampsonContract(actor, "kl_scampson_ingredient_contract", "bartersIngredients")
		func.applyScampsonContract(actor, "kl_scampson_roguish_contract", "bartersProbes")
		func.applyScampsonContract(actor, "kl_scampson_roguish_contract", "bartersLockpicks")
		func.applyScampsonContract(actor, "kl_scampson_shiny_contract", "bartersLights")
		func.applyScampsonContract(actor, "kl_scampson_domestic_contract", "bartersMiscItems")
		func.applyScampsonContract(actor, "kl_scampson_alchemical_contract", "bartersApparatus")
		func.applyScampsonContract(actor, "kl_scampson_alchemical_contract", "bartersAlchemy")
		func.applyScampsonContract(actor, "kl_scampson_repair_contract", "offersRepairs")
		func.applyScampsonContract(actor, "kl_scampson_bronze_contract", nil, 500)
		func.applyScampsonContract(actor, "kl_scampson_silver_contract", nil, 1000)
		func.applyScampsonContract(actor, "kl_scampson_gold_contract", nil, 2000)
		func.applyScampsonContract(actor, "kl_scampson_pearl_contract", nil, 3000)
		func.applyScampsonContract(actor, "kl_scampson_diamond_contract", nil, 5000)
		func.applyScampsonContract(actor, "kl_scampson_crystal_contract", nil, 10000)
	end

end, { filter = "MenuDialog" })


event.register(tes3.event.keyDown, function(e)
	if e.keyCode ~= config.typeBind.keyCode then return end
	if tes3ui.menuMode() then return end

	local t = tes3.getPlayerTarget()

	if not t then
		local buildTable = func.buildTable()
		if #buildTable > 0 then
			root.createWindow(buildTable[1])
		end
	else
		if func.validCompanionCheck(t.mobile) then
			root.createWindow(t)
		end
	end
end)


--
----Ability Controls-----------------------------------------------------------------------------------------
--

--Tools-----------------------------------------------------------------

--Clear Non-Companion Creature Abilities
local function abilityClear(e)
	if e.reference.object.objectType ~= tes3.objectType.creature then return end

	log:trace("Ability Check triggered on " .. e.reference.object.name .. ". (Activated)")
	if not func.validCompanionCheck(e.mobile) then
		func.removeAbilitiesCre(e.reference)

		

		abilities.tranquility(e.reference)
		abilities.pheromone(e.reference)
	else
		func.addAbilitiesCre(e.reference)
	end
end
event.register(tes3.event.mobileActivated, abilityClear)

--Triggered Ability Timer: Recurring
local function abilityTimer2()
	log:trace("Recurring NPC ability timer triggered.")

	local party = func.npcTable()
	local num = 0
	if #party > 0 then
		for i = 1, #party do
			local modData = func.getModData(party[i])
			if modData.patron and modData.patron == 23 then
				num = 1
				log:debug("Peryite oversees the party's tasks.")
				break
			end
		end
	end
	local float = math.random()
	local int = math.random(8, 23) - num
	timer.start({ type = timer.game, duration = (float + int), iterations = 1, callback = "companionLeveler:abilityTimer2" })

	if #party > 0 then
		local choice = math.random(1, #party)
		local reference = party[choice]

		if math.random(0, 99) < config.triggerChance then
			abilities.executeAbilities(reference)
		end
	end
end
timer.register("companionLeveler:abilityTimer2", abilityTimer2)

--Creature Triggered Ability Timer: Recurring
local function abilityTimer3()
	log:trace("Recurring creature ability timer triggered.")

	local creatures = func.creTable()
	local num = 0
	-- if #party > 0 then
	-- 	for i = 1, #party do
	-- 		local modData = func.getModData(party[i])
	-- 		if modData.patron and modData.patron == 23 then
	-- 			num = 1
	-- 			log:debug("Peryite oversees the party's tasks.")
	-- 			break
	-- 		end
	-- 	end
	-- end
	local float = math.random()
	local int = math.random(8, 23) - num
	timer.start({ type = timer.game, duration = (float + int), iterations = 1, callback = "companionLeveler:abilityTimer3" })

	if #creatures > 0 then
		local choice = math.random(1, #creatures)
		local reference = creatures[choice]

		if math.random(0, 99) < config.triggerChance then
			abilities.executeAbilitiesCre(reference)
		end
	end
end
timer.register("companionLeveler:abilityTimer3", abilityTimer3)

--Hourly Timer: For Time-Based Abilities
local function hourlyTimer()
	log:trace("Hourly timer triggered.")

	--Begin Next Iteration
	local gameHour = tes3.getGlobal('GameHour')
	local rounded = math.round(gameHour)
	if rounded < gameHour then
		timer.start({ type = timer.game, duration = (rounded + 1) - gameHour, iterations = 1, callback = "companionLeveler:hourlyTimer" })
	else
		local num = rounded - gameHour
		if num < 0 then
			num = 0
		end
		timer.start({ type = timer.game, duration = num, iterations = 1, callback = "companionLeveler:hourlyTimer" })
	end

	--Patrons/Bloodlines--
	log:debug("Time is now " .. gameHour .. ".")
	--func.clMessageBox("Time is now " .. gameHour .. " (" .. tes3.getGlobal('GameHour') .. ").")

	--Vaermina Tribute
	abilities.vaerminaTribute()

	--Dagon Tribute
	if gameHour >= 1 and gameHour < 2 then
		log:debug("1am detected.")
		abilities.dagonTribute()
	end

	--Sanguine Tribute
	if gameHour >= 2 and gameHour < 3 then
		log:debug("2am detected.")
		abilities.sanguineTribute()
	end

	--Mephala Tribute
	if gameHour >= 3 and gameHour < 4 then
		log:debug("3am detected.")
		abilities.mephalaTribute()
	end

	--Quarra Blood Frenzy
	if gameHour >= 6 and gameHour < 7 then
		log:debug("6am detected.")
		abilities.breakBloodFrenzy()
	end

	--Meridia Tribute
	if gameHour >= 12 and gameHour < 13 then
		log:debug("12pm detected.")
		abilities.meridiaTribute()
	end

	--Azura Tribute
	if gameHour >= 17 and gameHour < 18 then
		log:debug("5pm detected.")
		abilities.azuraTribute()
	end

	--Malacath Tribute
	if gameHour >= 18 and gameHour < 19 then
		log:debug("6pm detected.")
		abilities.malacathTribute()
	end

	--Azura Gift
	if (gameHour < 8 and gameHour >= 6) or (gameHour < 20 and gameHour >= 18) then
		log:debug("Twilight hours detected.")
		abilities.azuraGift()
	end

	--Hircine Tribute
	if gameHour >= 22 and gameHour < 23 then
		log:debug("10pm detected.")
		abilities.hircineTribute()
	end

	--Boethiah Tribute
	if gameHour < 1 then
		log:debug("Midnight detected.")
		abilities.boethiahTribute()
		abilities.moraTribute()
	end

	--Bloodlines--

	local npcTable = func.npcTable()

	for i = 1, #npcTable do
		if func.checkModData(npcTable[i]) then
			local modData = func.getModData(npcTable[i])
			if modData.fedHours ~= nil and modData.fedHours >= 0 then
				modData.fedHours = modData.fedHours + 1
				--Bloodline Specific--

				--Vampyrum Order
				if modData.bloodline == 4 then
					if modData.fedHours > 24 and modData.fedHours < 48 then
						modData.fed = false
						modData.stage = 2
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_4" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_4" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_2" })
						tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_2" })
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Vampyrum Stage II.") end
					elseif modData.fedHours > 48 and modData.fedHours < 72 then
						modData.fed = false
						modData.stage = 3
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_4" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_4" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_3" })
						tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_3" })
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Vampyrum Stage III.") end
					elseif modData.fedHours > 72 then
						modData.fed = false
						modData.stage = 4
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_3" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_stage_4" })
						tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_vamp_sun_4" })
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Vampyrum Stage IV!") end
					end
				elseif modData.bloodline == 5 then
					--Volkihar
					if modData.fedHours < 24 then
						modData.fed = true
						modData.stage = 1
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_1" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_4" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_4" })
						if tes3.player.cell.isOrBehavesAsExterior then
							if gameHour > 6 and gameHour < 20 then
								tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_1" })
							end
						end
					end
					if modData.fedHours > 24 and modData.fedHours < 48 then
						modData.stage = 2
						modData.fed = false
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_1" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_4" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_4" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_2" })
						if tes3.player.cell.isOrBehavesAsExterior then
							if gameHour > 6 and gameHour < 20 then
								tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_2" })
							end
						end
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Volkihar Stage II.") end
					elseif modData.fedHours > 48 and modData.fedHours < 72 then
						modData.stage = 3
						modData.fed = false
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_1" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_4" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_4" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_3" })
						if tes3.player.cell.isOrBehavesAsExterior then
							if gameHour > 6 and gameHour < 20 then
								tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_3" })
							end
						end
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Volkihar Stage III.") end
					elseif modData.fedHours > 72 then
						modData.stage = 4
						modData.fed = false
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_1" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_2" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_3" })
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_4" })
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_stage_4" })
						if tes3.player.cell.isOrBehavesAsExterior then
							if gameHour > 6 and gameHour < 20 then
								tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_4" })
							end
						end
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " ascended to Volkihar Stage IV!") end
					end
				elseif (modData.bloodline >= 1 and modData.bloodline <= 3) or (modData.bloodline >= 6 and modData.bloodline <= 14) then
					if modData.fedHours < 24 then
						modData.fed = true
					else
						modData.fed = false
					end
					if modData.fedHours >= 36 then
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_unfed" })
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " has begun to suffer Blood Withdrawal.") end
					else
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_unfed" })
					end
				elseif modData.bloodline == 15 then
					if modData.fedHours < 48 then
						modData.fed = true
					else
						modData.fed = false
					end
					if modData.fedHours >= 60 then
						local added = tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_unfed" })
						if added then func.clMessageBox("" .. npcTable[i].object.name .. " has begun to suffer Blood Withdrawal.") end
					else
						tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_unfed" })
					end
				end
			end
		end
	end
end
timer.register("companionLeveler:hourlyTimer", hourlyTimer)

--Hircine Werewolf Timer
local function wereTimer()
	log:trace("Werewolf timer triggered.")

	local werewolf = tes3.getReference("kl_werewolf_companion")

	if not werewolf.isDead then
		local modData = func.getModData(werewolf)
		local cleric = tes3.getReference(modData.npcID)
		local cModData = func.getModData(cleric)
		cleric:enable()
		cModData.hircineHunt = modData.hircineHunt
		cModData.lycanthropicPower = modData.lycanthropicPower
		tes3.positionCell({ reference = cleric, cell = werewolf.cell, position = werewolf.position })
		tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 1, reference = cleric })
		tes3.setAIFollow({ reference = cleric, target = tes3.player })
		if werewolf.mobile.health.current < cleric.mobile.health.base then
			cleric.mobile.health.current = werewolf.mobile.health.current
		end
		timer.delayOneFrame(function()
			timer.delayOneFrame(function()
				timer.delayOneFrame(function()
					werewolf:disable()
				end)
			end)
		end)
	end
end
timer.register("companionLeveler:wereTimer", wereTimer)

--Ability Triggers--------------------------------------------------------

--Combat Abilities
local function onCombat(e)
	--100%

	abilities.combustion(e) --Mehrunes Dagon
	abilities.sheoCombat(e) --Sheogorath
	abilities.nightmare(e) --Vaermina
	abilities.lament(e)
	abilities.indorilCre(e)
	abilities.dragonLeap(e)

	if math.random(0, 99) < config.combatChance then
		abilities.jest(e)
		abilities.thaumaturgy(e)
		abilities.inoculate(e)
		abilities.requiem(e)
		abilities.dirge(e)
		abilities.elegy(e)
		abilities.communion(e)
		abilities.dominance(e)
		abilities.weather(e)
		abilities.spores(e)
		abilities.triggerChant(e)
	end
end
event.register(tes3.event.combatStarted, onCombat)

--Before Damage Abilities
local function onDamage(e)
	if e.source == "attack" then
		local result = 0

		--split this between creature and npc to limit type checks?

		--Reliable
		abilities.ignition(e)
		abilities.permafrost(e)
		abilities.venomous(e)
		abilities.inoculateCre(e)
		abilities.pathogen(e)
		result = result + abilities.poach(e)
		result = result + abilities.deceptor(e)
		result = result + abilities.shed(e)
		result = result + abilities.broadside(e)
		result = result + abilities.boethiahGift(e)
		result = result - abilities.dibellaDuty(e)
		result = result - abilities.talosDuty(e)
		abilities.malacathGift(e)
		abilities.namiraGift(e)
		result = result + abilities.fightersGuildCre(e)
		result = result + abilities.tongCre(e)
		result = result + abilities.ashlandCre(e)
		result = result + abilities.dresCre(e)
		result = result + abilities.criticalFang(e)
		result = result + abilities.bloodFrenzy(e)
		e.damage = abilities.nimbleness(e) --damage stays same or becomes 0
		abilities.hexblade(e)

		--Combat Chance
		if math.random(0, 99) < config.combatChance then
			result = result + abilities.thuum(e)
			result = result + abilities.maneater(e)
			result = result + abilities.ladykiller(e)
			result = result + abilities.pEnergy(e) --Before Quake
			abilities.misdirection(e)
			abilities.misstep(e)
			abilities.rage(e)
			abilities.voltaic(e)
			abilities.mephalaGift(e)
			abilities.meridiaGift(e)
			abilities.quake(e)
			abilities.claws(e)
			abilities.poisonTouch(e)
			abilities.acidTouch(e)
			abilities.corrosiveTouch(e)

			if e.projectile then
				abilities.arcaneA(e)
			else
				abilities.arcaneK(e)
				abilities.sear(e)
			end

		end

		e.damage = e.damage + result

		--After Added Damage
		e.block = abilities.splitSecond(e)

	elseif e.source == "fall" then
		e.damage = abilities.acrobatic(e)
		e.damage = abilities.twist(e)
	end
end
event.register("damage", onDamage)

--After Damage Abilities
local function damaged(e)
	--Reliable
	abilities.beastwithin(e)
	abilities.stendarrDuty(e)
	abilities.dagonSacrifice(e)
	abilities.mephalaSacrifice(e)
	abilities.meridiaSacrifice(e)
	abilities.molagGift(e)
	abilities.khulariReaping(e)
	abilities.lyreziStifling(e)

	--Combat Chance
	if math.random(0, 99) < config.combatChance then
		abilities.adrenaline(e)
		abilities.kyne(e)
	end
end
event.register("damaged", damaged)

--After H2H Damage
local function damagedHandToHandCallback(e)
	--Reliable
	abilities.knifehand(e)
end
event.register(tes3.event.damagedHandToHand, damagedHandToHandCallback)

--Spell Resist Checks
local function onSpellResist(e)
	e.resistedPercent = abilities.whisker(e)
end
event.register(tes3.event.spellResist, onSpellResist)

--Cell Change Abilities
local function onCellChanged(e)
	abilities.instinct()
	abilities.barrier()
	abilities.dream()
	abilities.refractors()
	abilities.jadewind()
	abilities.springstep()
	abilities.freedom()
	abilities.temper()
	abilities.aqualung()
	abilities.composition()
	abilities.mystery()
	abilities.manasponge()
	abilities.resolve()
	abilities.blessed()
	abilities.bountyCheck()
	abilities.track()
	abilities.wont()
	abilities.intuition()
	abilities.kynareth(e)
	abilities.sanguineGift()
	abilities.censusCre()
	abilities.companyCre()
	abilities.astroCre()
	abilities.warmAura()
	abilities.chillAura()
	abilities.staticAura()
	abilities.toxicAura()
	abilities.farseek()
	abilities.boundless()
	abilities.pace(e)
	abilities.sunWeaken(e)
	abilities.montLair(e)
	abilities.detectSlave()

	if config.expMode == false then return end

	local exp = abilities.survey(e)

	if exp > 0 then
		--Award EXP
		local build, npc, creature = func.awardEXP(exp)
		handleLevelUp(build, npc, creature)
	end
end
event.register(tes3.event.cellChanged, onCellChanged)

--On Rest Abilities
local function onCalcRestInterrupt(e)
	abilities.cunning(e)
	abilities.legionCre(e)
	if e.resting then
		abilities.vaerminaGift()
	end
end
event.register(tes3.event.calcRestInterrupt, onCalcRestInterrupt)

--Soul Capture Abilities
local function filterSoulGemTargetCallback(e)
	local arkay = abilities.arkay(e)
	local molag = abilities.molagTribute(e)
	if arkay == false or molag == false then
		e.filter = false
	end
end
event.register(tes3.event.filterSoulGemTarget, filterSoulGemTargetCallback)

--On Activate Abilities
local function onActivate(e)
	if e.activator ~= tes3.player then return end

	if (e.target.baseObject.objectType == tes3.objectType.door) then
		log:trace("Door callback triggered.")
		local cell = tes3.player.cell

		if cell.isOrBehavesAsExterior then
			local vector = tes3.getLastExteriorPosition()
			local modData = func.getModDataP()
			modData.lastExteriorPosition = {vector.x, vector.y, vector.z}

			log:debug("Last Exterior Position Assigned: " .. tostring(vector) .. "")
		end
	elseif (tes3.hasOwnershipAccess({target = e.target}) == false or (e.target.baseObject.objectType == tes3.objectType.npc and tes3.mobilePlayer.isSneaking and e.target.mobile.health.current > 0)) then
		abilities.zenitharDuty(e.target)
	end

	if tes3.getLocked({ reference = e.target }) then
		abilities.nocturnalGift(e.target)
	end

	if (e.target.baseObject.objectType == tes3.objectType.npc) then
		abilities.deliveryCheck(e.target)
	end
end
event.register("activate", onActivate)


--Economic Events-------------------------------------------------------------------------------------------------------------------------

--Travel Price
local function onCalcTravelPrice(e)
	abilities.navigator(e)
	abilities.zenithar(e)
end
event.register("calcTravelPrice", onCalcTravelPrice)

--Repair Price
local function calcRepairPriceCallback(e)
	abilities.zenithar(e)
end
event.register(tes3.event.calcRepairPrice, calcRepairPriceCallback)

--Training Price
local function calcTrainingPriceCallback(e)
	abilities.zenithar(e)
end
event.register(tes3.event.calcTrainingPrice, calcTrainingPriceCallback)

--Spell Price
local function calcSpellPriceCallback(e)
	abilities.zenithar(e)
end
event.register(tes3.event.calcSpellPrice, calcSpellPriceCallback)

--Spellmaking Price
local function calcSpellmakingPriceCallback(e)
	abilities.zenithar(e)
end
event.register(tes3.event.calcSpellmakingPrice, calcSpellmakingPriceCallback)

--Enchanting Price
local function calcEnchantmentPriceCallback(e)
	abilities.zenithar(e)
end
event.register(tes3.event.calcEnchantmentPrice, calcEnchantmentPriceCallback)

--Barter Offer
local function barterOfferCallback(e)
	if e.success then
		abilities.accountant(e)
	else
		--nothing
	end
end
event.register(tes3.event.barterOffer, barterOfferCallback)

--Stealth Events-----------------------------------------------------------------------------------------------

--Sneaking Abilities
local function detectSneakCallback(e)
	if e.target == tes3.mobilePlayer or func.validCompanionCheck(e.target) then
		e.isDetected = abilities.shadow(e)
	end
end
event.register(tes3.event.detectSneak, detectSneakCallback)

--Crime Abilities
local function crimeWitnessedCallback(e)
	abilities.akatosh(e)
	abilities.julianosDuty(e)
end
event.register(tes3.event.crimeWitnessed, crimeWitnessedCallback)









--
--Config Stuff------------------------------------------------------------------------------------------------------------------------------
--

event.register("modConfigReady", function()
	require("companionLeveler.mcm")
	config = require("companionLeveler.config")
end)

--for testing:
-- local function expTest()
-- 	if config.expMode == false then return end
-- 	tes3.player.mobile:exerciseSkill(10, 100)
-- end

--event.register("jump", onLevelUp)
-- event.register("jump", expTest)