local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")


local tinc = {}


function tinc.createWindow(ref)
	--Initialize IDs
	tinc.id_menu = tes3ui.registerID("kl_tinc_menu")
	tinc.id_pane = tes3ui.registerID("kl_tinc_pane")
	tinc.id_ok = tes3ui.registerID("kl_tinc_ok")

	log:debug("Tincture menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")

	local alchemy = ref.mobile:getSkillStatistic(16)
	local intelligence = ref.mobile.attributes[2]
	local modData = func.getModData(ref)
	tinc.magickaText = tes3.findGMST(tes3.gmst.sMagic).value

	-- Create window and frame
	local menu = tes3ui.createMenu { id = tinc.id_menu, fixedFrame = true }

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_tinc" }
	head_block.autoWidth = true
	head_block.autoHeight = true
	head_block.borderBottom = 5

	--Title/TP Bar Blocks
	local title_block = head_block:createBlock{}
	title_block.width = 265
	title_block.autoHeight = true

	local tp_block = head_block:createBlock{}
	tp_block.width = 265
	tp_block.autoHeight = true

	-- Title
	title_block:createLabel { text = "Process which corpse?" }

	-- TP Bar
	tinc.tp_bar = tp_block:createFillBar({ current = modData.tp_current, max = modData.tp_max, id = tinc.id_tp_bar })
	func.configureBar(tinc.tp_bar, "small", "purple")
	tinc.tp_bar.borderLeft = 145

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_tinc" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- Pane Border
	local border = pane_block:createThinBorder { id = "kl_border_tinc" }
	border.positionX = 4
	border.positionY = -4
	border.width = 210
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4

	-- Material Border
	local border2 = pane_block:createThinBorder { id = "kl_border2_tinc" }
	border2.positionX = 202
	border2.positionY = 0
	border2.width = 308
	border2.height = 170
	border2.paddingAllSides = 4
	border2.wrapText = true
	border2.flowDirection = tes3.flowDirection.topToBottom

	----Populate-----------------------------------------------------------------------------------------------------

	--Materials
	local mTitle = border2:createLabel { text = "Corpse Quality", id = "kl_tinc_mTitle" }
	mTitle.wrapText = true
	mTitle.justifyText = tes3.justifyText.center
	mTitle.borderBottom = 20

	local mats = border2:createLabel { text = "", id = "kl_tinc_mats_0"}
	mats.wrapText = true
	mats.justifyText = tes3.justifyText.center

	tinc.mats = mats

	--Pane
	local pane = border:createVerticalScrollPane { id = tinc.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	--Populate Pane
	local red = tes3.getObject("kl_potion_bTincture_red")
	local blue = tes3.getObject("kl_potion_bTincture_blue")
	local silver = tes3.getObject("kl_potion_bTincture_silver")
	local black = tes3.getObject("kl_potion_bTincture_black")
	local gold = tes3.getObject("kl_potion_bTincture_gold")

	tinc.total = 0

	for mobileActor in tes3.iterate(tes3.worldController.allMobileActors) do
		if (mobileActor.cell == tes3.getPlayerCell() and mobileActor.reference.object.objectType == tes3.objectType.npc and mobileActor.isDead) then
			local pos = mobileActor.reference.position
			local dist = pos:distance(tes3.player.position)
			log:debug("" .. mobileActor.reference.object.name .. "'s distance: " .. dist .. "")

			if dist < 750 then
				tinc.total = tinc.total + 1

				local a = pane:createTextSelect { text = "" .. mobileActor.reference.object.name .. "", id = "kl_tinc_btn_" .. tinc.total .. ""}
				local lvl = func.getLevel(mobileActor.reference)
				local obj
				local req
				local tp
				local time
				local mgk

				if lvl < 6 then
					obj = red
					req = 50
					tp = 2
					time = 0.5
					mgk = 25
				elseif lvl >= 6 and lvl < 10 then
					obj = blue
					req = 75
					tp = 3
					time = 1
					mgk = 50
				elseif lvl >= 10 and lvl < 16 then
					obj = silver
					req = 100
					tp = 5
					time = 1.5
					mgk = 90
				elseif lvl >= 16 and lvl < 21 then
					obj = black
					req = 125
					tp = 7
					time = 2.5
					mgk = 140
				elseif lvl >= 21 then
					obj = gold
					req = 175
					tp = 10
					time = 4
					mgk = 200
				end

				a:register("mouseClick", function(e) tinc.onSelect(a, obj, mobileActor.reference, req, tp, pos, time, mgk) end)
			end
		end
	end

	--Calculate Bonuses
	local modifier = alchemy.current
	local modifier2 = intelligence.current
	if modifier2 > 200 then
		modifier2 = 200
	end
	if modifier > 200 then
		modifier = 200
	end

	tinc.timeReduction = math.round(modifier * 0.35)
	tinc.mgkReduction = math.round(modifier2 * 0.26)

	--Text Block
	local text_block = menu:createBlock { id = "text_block_tinc" }
	text_block.width = 490
	text_block.height = 112
	text_block.borderAllSides = 10
	text_block.flowDirection = "left_to_right"

	local base_block = text_block:createBlock {}
	base_block.width = 165
	base_block.height = 112
	base_block.borderAllSides = 4
	base_block.flowDirection = "top_to_bottom"

	local ench_block = text_block:createBlock {}
	ench_block.width = 145
	ench_block.height = 112
	ench_block.borderAllSides = 4
	ench_block.flowDirection = "top_to_bottom"
	ench_block.wrapText = true

	local total_block = text_block:createBlock {}
	total_block.width = 200
	total_block.height = 112
	total_block.borderAllSides = 4
	total_block.flowDirection = "top_to_bottom"
	total_block.wrapText = true

	--Base Statistics
	local base_title = base_block:createLabel({ text = "Base Requirements", id = "kl_att_tinc" })
	base_title.color = { 1.0, 1.0, 1.0 }
	tinc.base_time = base_block:createLabel({ text = "Time: ", id = "kl_tinc_time" })
	tinc.base_mgk = base_block:createLabel({ text = "Magicka: ", id = "kl_tinc_mgk" })

	--Enchantments
	local ench_title = ench_block:createLabel({ text = "Reductions" })
	ench_title.color = { 1.0, 1.0, 1.0 }
	local rTime = ench_block:createLabel { text = "Time: " .. tinc.timeReduction .. "%", id = "kl_tinc_time_e" }
	func.clTooltip(rTime, "skill:16")
	local rMgk = ench_block:createLabel { text = "Magicka: " .. tinc.mgkReduction .. "%", id = "kl_tinc_mgk_e" }
	func.clTooltip(rMgk, "att:1")

	--Totals
	local total_title = total_block:createLabel({ text = "Total Requirements" })
	total_title.color = { 1.0, 1.0, 1.0 }
	tinc.total_time = total_block:createLabel { text = "Time: ", id = "kl_tinc_time_t" }
	tinc.total_mgk = total_block:createLabel { text = "Magicka: ", id = "kl_tinc_mgk_t" }

	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	tinc.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()

		if alchemy.current < tinc.req then
			func.clMessageBox("" .. ref.object.name .. " is not skilled enough to extract from " .. tinc.ref.object.name .. ".")
			return
		end

		if modData.tp_current < tinc.tp then
			func.clMessageBox("Not enough Technique Points!")
			return
		end

		if ref.mobile.magicka.current < tinc.mgk then
			func.clMessageBox("Not enough " .. tinc.magickaText .. "!")
			return
		end

		--Pass Time
		local gameHour = tes3.getGlobal('GameHour')
		gameHour = (gameHour + tinc.time)
		tes3.setGlobal('GameHour', gameHour)

		--Spend Magicka
		tes3.modStatistic({ reference = ref, name = "magicka", current = (tinc.mgk * -1) })

		--Spend TP
		modData.tp_current = modData.tp_current - tinc.tp

		--Process Dead
		tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 3, reference = tinc.ref })
		tes3.playSound({ sound = "conjuration hit", reference = tinc.ref })
		tes3.addItem({ reference = tes3.player, item = tinc.obj, count = 1 })
		func.clMessageBox("" .. ref.object.name .. " extracted " .. tinc.obj.name .. "!")

		tinc.ref:delete()

		menu:destroy()
		tes3ui.leaveMenuMode()

	end)

	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(tinc.id_menu)
end

function tinc.onSelect(elem, obj, ref, req, tp, pos, time, mgk)
	local menu = tes3ui.findMenu(tinc.id_menu)

	if menu then
		for i = 1, tinc.total do
			local btn = menu:findChild("kl_tinc_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4
		tinc.obj = obj
		tinc.ref = ref
		tinc.tp = tp
		tinc.pos = pos
		tinc.req = req
		tinc.time = time * (1 - (tinc.timeReduction * 0.01))
		tinc.mgk = mgk * (1 - (tinc.mgkReduction * 0.01))

		tinc.base_time.text = "Time: " .. math.round(time * 60) .. " minutes"
		tinc.base_mgk.text = "Magicka: " .. mgk .. ""

		tinc.total_time.text = "Time: " .. math.round(tinc.time * 60, 1) .. " minutes"
		tinc.total_mgk.text = "Magicka: " .. tinc.mgk .. ""

		tinc.mats.text = "Level " .. ref.object.level .."\n\n" .. obj.name .. "\nAlchemy Required: " .. req .. "\nTP: " .. tp .. "\nTime: " .. tinc.time .. " hours\nMagicka: " .. tinc.mgk .. ""

		tinc.ok.widget.state = 1
		tinc.ok.disabled = false

		menu:updateLayout()
	end
end


return tinc