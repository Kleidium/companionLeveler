local log = mwse.Logger.new()
local tables = require("companionLeveler.tables")
local func = require("companionLeveler.functions.common")


local feed = {}


function feed.createWindow(ref)
	--Initialize IDs
	feed.id_menu = tes3ui.registerID("kl_feed_menu")
	feed.id_pane = tes3ui.registerID("kl_feed_pane")
	feed.id_pane2 = tes3ui.registerID("kl_feed_pane2")
	feed.id_ok = tes3ui.registerID("kl_feed_ok")
	feed.id_tp_bar = tes3ui.registerID("kl_feed_tp_bar")
	feed.id_fat_bar = tes3ui.registerID("kl_feed_fat_bar")

	log:debug("Feed menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")
	feed.modData = func.getModData(ref)

	feed.ref = ref
	feed.level = feed.modData.level
	feed.obj_choices = 0
	feed.target = nil

	feed.sneak = ref.mobile:getSkillStatistic(19) --against security
	feed.illusion = ref.mobile:getSkillStatistic(12) --against willpower
	feed.hand = ref.mobile:getSkillStatistic(26) --against hand to hand
	--feed.short = ref.mobile:getSkillStatistic(22) --against agility

	feed.willText = tes3.findGMST(tes3.gmst.sAttributeWillpower).value
	feed.securityText = tes3.findGMST(tes3.gmst.sSkillSecurity).value
	feed.sneakText = tes3.findGMST(tes3.gmst.sSkillSneak).value
	feed.illusionText = tes3.findGMST(tes3.gmst.sSkillIllusion).value
	feed.handText = tes3.findGMST(tes3.gmst.sSkillHandtohand).value
	--feed.shortText = tes3.findGMST(tes3.gmst.sSkillShortblade).value
	feed.levelText = tes3.findGMST(tes3.gmst.sLevel).value
	feed.classText = tes3.findGMST(tes3.gmst.sClass).value

	-- Create Menu
	local menu = tes3ui.createMenu { id = feed.id_menu, fixedFrame = true }

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_feed" }
	head_block.autoWidth = true
	head_block.autoHeight = true
	head_block.borderBottom = 5

	--Title/TP Bar Blocks
	local title_block = head_block:createBlock{}
	title_block.width = 275
	title_block.autoHeight = true

	local tp_block = head_block:createBlock{}
	tp_block.width = 275
	tp_block.autoHeight = true

	-- Title
	title_block:createLabel { text = "Choose a target to feed upon." }

	-- TP Bar
	if feed.modData.bloodline == 13 then
		feed.tp_bar = tp_block:createFillBar({ current = feed.modData.tp_current, max = feed.modData.tp_max, id = feed.id_tp_bar })
		func.configureBar(feed.tp_bar, "small", "purple")
		feed.tp_bar.borderLeft = 154
	end

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_feed" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- feed Border
	local border = pane_block:createThinBorder { id = "kl_border_feed" }
	border.positionX = 4
	border.positionY = -4
	border.width = 300
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4
	border.borderLeft = 126

	--Calculate Bonuses
	if feed.sneak.current >= feed.illusion.current then
		if feed.sneak.current >= feed.hand.current then
			feed.modifier = feed.sneak.current
			feed.resistText = feed.securityText
			feed.skillNum = 19
		else
			feed.modifier = feed.hand.current
			feed.resistText = feed.handText
			feed.skillNum = 26
		end
	else
		if feed.illusion.current >= feed.hand.current then
			feed.modifier = feed.illusion.current
			feed.resistText = feed.willText
			feed.skillNum = ""
		else
			feed.modifier = feed.hand.current
			feed.resistText = feed.handText
			feed.skillNum = 26
		end
	end

	if feed.modifier > 200 then
		feed.modifier = 200
	end


	----Populate-----------------------------------------------------------------------------------------------------

	--Panes
	local pane = border:createVerticalScrollPane { id = feed.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	--Populate Pane

	--OBJ Choices
	if feed.modData.bloodline == 13 then
		--Dead or Alive NPCs
		for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.npc }) do
			if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
				local pos = refe.position
				local dist = pos:distance(tes3.player.position)
				log:debug("" .. refe.object.name .. "'s distance: " .. dist .. "")

				if dist < 400  and refe.object.name ~= "" and not func.validCompanionCheck(refe.mobile) then
					feed.obj_choices = feed.obj_choices + 1

					local a = pane:createTextSelect { text = "" .. refe.object.name .. "", id = "kl_feed_obj_btn_" .. feed.obj_choices .. ""}

					a:register("mouseClick", function(e) feed.onSelectTarget(a, refe) end)
				end
			end
		end
	elseif feed.modData.bloodline == 15 then
		--Living NPCs and Creatures
		for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.npc, tes3.objectType.creature }) do
			if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
				local pos = refe.position
				local dist = pos:distance(tes3.player.position)
				log:debug("" .. refe.object.name .. "'s distance: " .. dist .. "")

				if dist < 400  and refe.object.name ~= "" and not func.validCompanionCheck(refe.mobile) and not refe.mobile.isDead then
					feed.obj_choices = feed.obj_choices + 1

					local a = pane:createTextSelect { text = "" .. refe.object.name .. "", id = "kl_feed_obj_btn_" .. feed.obj_choices .. ""}

					a:register("mouseClick", function(e) feed.onSelectTarget(a, refe) end)
				end
			end
		end
	else
		--Living NPCs
		for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.npc }) do
			if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
				local pos = refe.position
				local dist = pos:distance(tes3.player.position)
				log:debug("" .. refe.object.name .. "'s distance: " .. dist .. "")

				if dist < 400  and refe.object.name ~= "" and not func.validCompanionCheck(refe.mobile) and not refe.mobile.isDead then
					feed.obj_choices = feed.obj_choices + 1

					local a = pane:createTextSelect { text = "" .. refe.object.name .. "", id = "kl_feed_obj_btn_" .. feed.obj_choices .. ""}

					a:register("mouseClick", function(e) feed.onSelectTarget(a, refe) end)
				end
			end
		end
	end

	--Text Block
	local text_block = menu:createBlock { id = "text_block_feed" }
	text_block.width = 490
	text_block.height = 112
	text_block.borderAllSides = 10
	text_block.flowDirection = "left_to_right"

	local base_block = text_block:createBlock {}
	base_block.width = 105
	base_block.height = 112
	base_block.borderAllSides = 4
	base_block.flowDirection = "top_to_bottom"

	local target_block = text_block:createBlock {}
	target_block.width = 175
	target_block.height = 112
	target_block.borderAllSides = 4
	target_block.flowDirection = "top_to_bottom"
	target_block.wrapText = true

	local chance_block = text_block:createBlock {}
	chance_block.width = 175
	chance_block.height = 112
	chance_block.borderAllSides = 4
	chance_block.flowDirection = "top_to_bottom"
	chance_block.wrapText = true

	--Target Block
	local target_title = target_block:createLabel({ text = "Target: " })
	target_title.color = tables.colors["white"]
	feed.level_label = target_block:createLabel { text = "" .. feed.levelText .. ": ", id = "kl_feed_level_label" }
	feed.class_label = target_block:createLabel { text = "" .. feed.classText .. ": ", id = "kl_feed_class_label" }
	feed.resist_label = target_block:createLabel { text = "" .. feed.resistText .. ": ", id = "kl_feed_resist_label" }

	--Chance
	local chance_title = chance_block:createLabel({ text = "Success Chance:" })
	chance_title.color = tables.colors["white"]
	func.clTooltip(chance_title, "skill:" .. feed.skillNum .. "")
	feed.chance_label = chance_block:createLabel { text = "", id = "kl_feed_chance" }


	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5
	button_block.borderTop = 10

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	feed.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()
		if feed.modData.bloodline == 13 and feed.modData.fed then
			if not func.spendTP(ref, 1) then return end
		end

		--Roll
		if math.random(0, 99) > feed.chance then
			--Fail
			func.clMessageBox("" .. ref.object.name .. " failed to feed on " .. feed.target.object.name .. "!")
			menu:destroy()
			tes3ui.leaveMenuMode()

			--trigger crime
			tes3.triggerCrime{
				victim = feed.target,
				type = tes3.crimeType.attack
			}

			feed.target.mobile:startCombat(feed.ref.mobile)
			feed.ref.mobile:startCombat(feed.target.mobile)
			--feed.createWindow(feed.ref)
		else
			--Success
			--Reset
			menu:destroy()
			tes3ui.leaveMenuMode()

			--check for bloodline specific effect

			--Aundae
			if feed.modData.bloodline == 1 then
				local mgk = math.round(feed.target.mobile.magicka.current / 10)
				feed.modData.bloodMagicka = feed.modData.bloodMagicka + mgk

				if feed.modData.bloodMagicka > feed.modData.level * 20 then
					feed.modData.bloodMagicka = feed.modData.level * 20
				end

				func.clMessageBox("" .. ref.object.name .. " extracted " .. mgk .. " blood magicka.")
			end

			--Vampyrum
			if feed.modData.bloodline == 4 then
				feed.modData.stage = 1
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_stage_2" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_sun_2" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_stage_3" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_sun_3" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_stage_4" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_vamp_sun_4" })

				func.clMessageBox("" .. ref.object.name .. " reverted to Vampyric Stage I.")
			end

			--Volkihar
			if feed.modData.bloodline == 5 then
				feed.modData.stage = 1
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_sun_1" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_stage_2" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_sun_2" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_stage_3" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_sun_3" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_stage_4" })
				tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_volk_sun_4" })

				if tes3.player.cell.isOrBehavesAsExterior then
					local gameHour = tes3.getGlobal('GameHour')
					if gameHour > 6 and gameHour < 20 then
						tes3.addSpell({ reference = feed.ref, spell = "kl_ability_volk_sun_1" })
					end
				end

				func.clMessageBox("" .. ref.object.name .. " reverted to Volkihar Stage I.")
			end

			feed.modData.fed = true
			feed.modData.fedHours = 0
			local removed = tes3.removeSpell({ reference = feed.ref, spell = "kl_ability_unfed" })
			if removed then func.clMessageBox("" .. feed.ref.object.name .. " has recovered from Blood Withdrawal.") end

			--Vampire Bite
			tes3.applyMagicSource({
				reference = feed.target,
				name = "Vampire Bite",
				effects = {
					{ id = tes3.effect.damageHealth,
						duration = 3,
						min = math.round(feed.modData.level / 3),
						max = feed.modData.level },
				},
			})
			tes3.applyMagicSource({
				reference = feed.ref,
				name = "Vampire Bite",
				effects = {
					{ id = tes3.effect.restoreHealth,
						duration = 3,
						min = math.round(ref.mobile.health.base / 5),
						max = math.round(ref.mobile.health.base / 4) },
				},
			})

			--Khulari Paralyze
			if feed.modData.bloodline == 9 then
				tes3.applyMagicSource({
					reference = feed.target,
					name = "Khulari Venom",
					effects = {
						{ id = tes3.effect.paralyze,
						duration = math.round(3, 10) },
					},
				})
			end

			--Thrafey Restoration
			if feed.modData.bloodline == 13 then
				local hth = math.round((feed.target.mobile.health.base * 0.15) / 5)
				if hth < 1 then
					hth = 1
				end
				local partyTable = func.partyTable()
				for i = 1, #partyTable do
					tes3.applyMagicSource({
						reference = partyTable[i],
						name = "Thrafey Restoration",
						effects = {
							{ id = tes3.effect.restoreHealth,
							duration = 5,
							min = hth,
							max = hth },
						},
					})
					tes3.createVisualEffect({ object = "VFX_RestorationHit", lifespan = 3, reference = partyTable[i] })
				end
				tes3.playSound({ sound = "restoration hit" })
			end

			--Tenarr Zalviit Dread Fang
			if feed.modData.bloodline == 15 then
				tes3.applyMagicSource({
					reference = feed.target,
					name = "Dread Fang",
					bypassResistances = true, --bypass resistance
					effects = {
						{ id = tes3.effect.damageHealth,
						duration = 1,
						min = feed.modData.level,
						max = feed.modData.level * 3 },
					},
				})
				tes3.playSound({ sound = "critical damage", reference = feed.target, volume = 0.8, pitch = 0.8 })
			end

			tes3.playSound({ sound = "mysticism hit" })
			tes3.createVisualEffect({ object = "VFX_RestorationHit", lifespan = 3, reference = feed.ref })
			tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 3, reference = feed.target })

			--trigger crime
			if feed.modData.bloodline ~= 2 then
				tes3.triggerCrime{
					victim = feed.target,
					type = tes3.crimeType.attack
				}
			end

			if feed.target.mobile.isDead then
				feed.target:delete()
				return
			end

			feed.target.mobile:startCombat(feed.ref.mobile)
			feed.ref.mobile:startCombat(feed.target.mobile)
		end
	end)
	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(feed.id_menu)
end

function feed.onSelectTarget(elem, ref)
	local menu = tes3ui.findMenu(feed.id_menu)

	if menu then
		for i = 1, feed.obj_choices do
			local btn = menu:findChild("kl_feed_obj_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4

		feed.target = ref
		feed.class = ref.object.class
		feed.resist = ref.mobile.willpower.current
		if feed.skillNum ~= "" then
			feed.resist = ref.mobile:getSkillStatistic(feed.skillNum).current
		end

		--Trap Label
		feed.class_label.text = "" .. feed.levelText .. ": " .. func.getLevel(ref) .. ""

		local classBonus = 0
		if feed.class.id == "Commoner" or feed.class.id == "Pauper" or feed.class.id == "Clothier" or feed.class.id == "Pawnbroker" or feed.class.id == "Merchant" or feed.class.id == "King" or feed.class.id == "Pilgrim" or feed.class.id == "Slave" or feed.class.id == "Noble" or feed.class.id == "Farmer" or feed.class.id == "Bookseller" or feed.class.id == "Gondolier" or feed.class.id == "Trader" or feed.class.id == "Publican" then
			classBonus = 15
		elseif feed.class.id == "Alchemist" or feed.class.id == "Apothecary" or feed.class.id == "Enchanter" or feed.class.id == "Pilgrim" or feed.class.id == "Miner" or feed.class.id == "Shipmaster" then
			classBonus = 5
		elseif feed.class.id == "Knight" or feed.class.id == "Warrior" or feed.class.id == "Champion" or feed.class.id == "Mage" or feed.class.id == "Rogue" or feed.class.id == "Sorcerer" or feed.class.id == "Agent" or feed.class.id == "Assassin" or feed.class.id == "Battlemage" or feed.class.id == "Nightblade" or feed.class.id == "Guard" then
			classBonus = -5
		elseif feed.class.id == "Ordinator" or feed.class.id == "Buoyant Armiger" or feed.class.id == "Witchhunter" then
			classBonus = -15
		end
		local levelBonus = math.round((feed.level - func.getLevel(feed.target)) * 1.75)
		local chance = math.round((feed.modifier + classBonus + levelBonus) - (feed.resist * 1.20)) + 15
		if feed.modData.bloodline == 2 then
			chance = 100
		end
		if feed.modData.bloodline == 13 and feed.target.mobile.isDead then
			chance = 100
		end
		feed.chance = chance

		feed.chance_label.text = "" .. feed.chance .. "%"
		feed.level_label.text = "" .. feed.classText .. ": " .. feed.class.name .. ""
		if classBonus < 0 then
			feed.level_label.color = tables.colors["red"]
		elseif classBonus > 0 then
			feed.level_label.color = tables.colors["green"]
		else
			feed.level_label.color = tables.colors["default_font"]
		end
		feed.resist_label.text = "" .. feed.resistText .. ": " .. feed.resist .. ""

		if feed.target ~= nil then
			feed.ok.widget.state = 1
			feed.ok.disabled = false
		end

		menu:updateLayout()
	end
end


return feed