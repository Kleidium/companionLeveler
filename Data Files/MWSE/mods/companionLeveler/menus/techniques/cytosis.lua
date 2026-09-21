local log = mwse.Logger.new()
local tables = require("companionLeveler.tables")
local func = require("companionLeveler.functions.common")


local cyto = {}


function cyto.createWindow(ref)
	--Initialize IDs
	cyto.id_menu = tes3ui.registerID("kl_cyto_menu")
	cyto.id_pane = tes3ui.registerID("kl_cyto_pane")
	cyto.id_ok = tes3ui.registerID("kl_cyto_ok")
	cyto.id_tp_bar = tes3ui.registerID("kl_cyto_tp_bar")
	cyto.id_mag_bar = tes3ui.registerID("kl_cyto_mag_bar")

	log:debug("Phagocytosis menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")
	local modData = func.getModData(ref)

	cyto.ref = ref
	cyto.modData = modData
	cyto.target = nil
	cyto.level = modData.level
	cyto.int = ref.mobile.attributes[2].current
	cyto.endure = ref.mobile.attributes[6].current
	cyto.magickaText = tes3.findGMST(tes3.gmst.sMagic).value
	cyto.levelText = tes3.findGMST(tes3.gmst.sLevel).value
	cyto.intText = tes3.findGMST(tes3.gmst.sAttributeIntelligence).value
	cyto.endText = tes3.findGMST(tes3.gmst.sAttributeEndurance).value
	cyto.npc_choices = 0

	-- Create Menu
	local menu = tes3ui.createMenu { id = cyto.id_menu, fixedFrame = true }

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_cyto" }
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
	title_block:createLabel { text = "Choose a target." }

	-- magicka Bar
	cyto.mag_bar = tp_block:createFillBar({ current = ref.mobile.magicka.current, max = ref.mobile.magicka.base, id = cyto.id_mag_bar })
	func.configureBar(cyto.mag_bar, "small", "blue")
	cyto.mag_bar.borderLeft = 20

	-- TP Bar
	cyto.tp_bar = tp_block:createFillBar({ current = modData.tp_current, max = modData.tp_max, id = cyto.id_tp_bar })
	func.configureBar(cyto.tp_bar, "small", "purple")
	cyto.tp_bar.borderLeft = 5

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_cyto" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- cyto Border
	local border = pane_block:createThinBorder { id = "kl_border_cyto" }
	border.positionX = 4
	border.positionY = -4
	border.width = 300
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4
	border.borderLeft = 126

	--Calculate Bonuses
	cyto.modifier = cyto.int
	if cyto.modifier > 200 then
		cyto.modifier = 200
	end

	cyto.magReduction = math.round(cyto.modifier * 0.4)
	cyto.dmgMod = math.round(cyto.modifier * 0.10)
	if cyto.dmgMod < 2 then
		cyto.dmgMod = 2
	end

	cyto.modifier2 = cyto.endure
	if cyto.modifier2 > 200 then
		cyto.modifier2 = 200
	end
	cyto.acidMod = math.round(cyto.modifier2 * 0.15)
	if cyto.acidMod < 4 then
		cyto.acidMod = 4
	end


	----Populate-----------------------------------------------------------------------------------------------------

	--Panes
	cyto.pane = border:createVerticalScrollPane { id = cyto.id_pane }
	cyto.pane.height = 148
	cyto.pane.width = 210
	cyto.pane.widget.scrollbarVisible = true

	--Populate Pane

	--Choices
	for mobileActor in tes3.iterate(tes3.worldController.allMobileActors) do
		if mobileActor.cell == tes3.getPlayerCell() then
			local pos = mobileActor.reference.position
			local dist = pos:distance(tes3.player.position)
			log:debug("" .. mobileActor.reference.object.name .. "'s distance: " .. dist .. "")

			if dist < 600 and mobileActor.reference.object.name ~= "" and mobileActor.reference.object.name ~= "<spawner>" and mobileActor.reference ~= ref then
				cyto.npc_choices = cyto.npc_choices + 1

				local a = cyto.pane:createTextSelect { text = "" .. mobileActor.reference.object.name .. "", id = "kl_cyto_npc_btn_" .. cyto.npc_choices .. ""}

				a:register("mouseClick", function(e) cyto.onSelectTarget(a, mobileActor.reference) end)
			end
		end
	end

	--Text Block
	local text_block = menu:createBlock { id = "text_block_cyto" }
	text_block.width = 490
	text_block.height = 112
	text_block.borderAllSides = 10
	text_block.flowDirection = "left_to_right"

	local base_block = text_block:createBlock {}
	base_block.width = 175
	base_block.height = 112
	base_block.borderAllSides = 4
	base_block.flowDirection = "top_to_bottom"

	local param_block = text_block:createBlock {}
	param_block.width = 175
	param_block.height = 112
	param_block.borderAllSides = 4
	param_block.flowDirection = "top_to_bottom"
	param_block.wrapText = true

	local total_block = text_block:createBlock {}
	total_block.width = 175
	total_block.height = 112
	total_block.borderAllSides = 4
	total_block.flowDirection = "top_to_bottom"
	total_block.wrapText = true

	--Magicka
	local base_title = base_block:createLabel({ text = "" .. cyto.magickaText .. " Cost:", id = "kl_base_cyto" })
	base_title.color = tables.colors["white"]
	cyto.base_mag = base_block:createLabel({ text = "Base: ", id = "kl_cyto_mag" })
	--Reductions
	local reduce_label = base_block:createLabel { text = "Reduction: " .. cyto.magReduction .. "%", id = "kl_cyto_mag_e" }
	func.clTooltip(reduce_label, "att:1")
	--Totals
	cyto.total_mag = base_block:createLabel { text = "Total Cost: ", id = "kl_cyto_mag_t" }
	base_block:createLabel { text = "TP Cost: 3" }

	--Level/Endurance
	local target_title = param_block:createLabel({ text = "Target: " })
	target_title.color = tables.colors["white"]
	cyto.level_label = param_block:createLabel { text = "" .. cyto.levelText .. ": ", id = "kl_cyto_level_label" }
	cyto.endurance_label = param_block:createLabel { text = "" .. cyto.endText .. ": ", id = "kl_cyto_end_label" }

	--Chance
	local chance_title = total_block:createLabel({ text = "Success Chance:" })
	chance_title.color = tables.colors["white"]
	func.clTooltip(chance_title, "att:5")
	cyto.chance_label = total_block:createLabel { text = "", id = "kl_cyto_chance" }


	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5
	button_block.borderTop = 10

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	cyto.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()
		if not func.spendTP(ref, 3) then return end

		if ref.mobile.magicka.current < cyto.magCost then
			func.clMessageBox("Not enough " .. cyto.magickaText .. "!")
			return
		end

		--Reset
		menu:destroy()
		tes3ui.leaveMenuMode()

		--Spend magicka
		tes3.modStatistic({ reference = ref, name = "magicka", current = (cyto.magCost * -1) })

		--Roll

		if math.random(0, 99) > cyto.chance then
			--Fail
			tes3.playSound({ sound = "Spell Failure Illusion" })
			func.clMessageBox("" .. ref.object.name .. " failed to envelop the target!")
			cyto.createWindow(ref)
		else
			if cyto.target ~= tes3.mobilePlayer then
				local isHostile
				for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
					if actor.reference == cyto.target then
						isHostile = true
					end
				end
				if not isHostile then
					tes3.triggerCrime{
						victim = cyto.target,
						type = tes3.crimeType.attack
					}
				end
				cyto.target:startCombat(cyto.ref.mobile)
			end
			tes3.createVisualEffect({ object = "VFX_IllusionHit", lifespan = 7, reference = cyto.ref })
			tes3.createVisualEffect({ object = "VFX_IllusionHit", lifespan = 7, reference = cyto.target })
			tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 7, reference = cyto.target })
			tes3.playSound({ sound = "illusion hit", reference = cyto.target, volume = 0.9 })

			tes3.applyMagicSource({ bypassResistances = false,
				reference = cyto.target,
				name = "Phagocytosis Acid",
				effects = {
					{ id = tes3.effect.damageHealth,
						min = math.round(cyto.dmgMod / 2),
						max = cyto.dmgMod,
						duration = 7 },
					{ id = tes3.effect.poison,
						min = 1,
						max = math.round(cyto.dmgMod / 2),
						duration = 7 },
					{ id = tes3.effect.disintegrateWeapon,
						min = 1,
						max = cyto.acidMod,
						duration = 7 },
					{ id = tes3.effect.disintegrateArmor,
						min = math.round(cyto.acidMod / 2),
						max = cyto.acidMod,
						duration = 7 }
				},
			})
			tes3.applyMagicSource({ bypassResistances = true,
				reference = cyto.target,
				name = "Phagocytosis",
				effects = {
					{ id = tes3.effect.paralyze,
						duration = 7 }
				},
			})
			tes3.applyMagicSource({ bypassResistances = true,
				reference = cyto.ref,
				name = "Phagocytosis Stun",
				effects = {
					{ id = tes3.effect.paralyze,
						duration = 7 }
				},
			})
		end
	end)
	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(cyto.id_menu)
end

function cyto.onSelectTarget(elem, ref)
	local menu = tes3ui.findMenu(cyto.id_menu)

	if menu then
		for i = 1, cyto.npc_choices do
			local btn = menu:findChild("kl_cyto_npc_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4

		cyto.target = ref
		cyto.level = func.getLevel(ref)
		cyto.endurance = ref.mobile.attributes[6].current

		--Level Label
		cyto.level_label.text = "" .. cyto.levelText .. ": " .. cyto.level .. ""

		cyto.chance = math.round(70 - (((cyto.level * 2) - cyto.modData.level) + cyto.endurance - cyto.modifier2))

		cyto.chance_label.text = "" .. cyto.chance .. "%"
		cyto.endurance_label.text = "" .. cyto.endText .. ": " .. cyto.endurance .. ""

		cyto.magCost = math.round((cyto.endurance * 3) * (1 - (cyto.magReduction * 0.01)))
		if cyto.magCost < 1 then
			cyto.magCost = 1
		end

		cyto.base_mag.text = "Base: " .. math.round(cyto.endurance * 3) .. ""
		cyto.total_mag.text = "Total Cost: " .. cyto.magCost .. ""

		if cyto.target ~= nil then
			cyto.ok.widget.state = 1
			cyto.ok.disabled = false
		end

		menu:updateLayout()
	end
end


return cyto