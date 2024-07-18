local logger = require("logging.logger")
local log = logger.getLogger("Companion Leveler")
local func = require("companionLeveler.functions.common")


local gem = {}


function gem.createWindow(ref)
	--Initialize IDs
	gem.id_menu = tes3ui.registerID("kl_gem_menu")
	gem.id_pane = tes3ui.registerID("kl_gem_pane")
	gem.id_ok = tes3ui.registerID("kl_gem_ok")

	log = logger.getLogger("Companion Leveler")
	log:debug("Soul Gem menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")

	local enchant = ref.mobile:getSkillStatistic(tes3.skill.enchant)

	-- Create window and frame
	local menu = tes3ui.createMenu { id = gem.id_menu, fixedFrame = true }

	-- Create layout
	local input_label = menu:createLabel { text = "Soul Gem Synthesis" }
	input_label.borderBottom = 5

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_gem" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- Pane Border
	local border = pane_block:createThinBorder { id = "kl_border_gem" }
	border.positionX = 4
	border.positionY = -4
	border.width = 210
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4

	-- Material Border
	local border2 = pane_block:createThinBorder { id = "kl_border2_gem" }
	border2.positionX = 202
	border2.positionY = 0
	border2.width = 308
	border2.height = 170
	border2.paddingAllSides = 4
	border2.wrapText = true
	border2.flowDirection = tes3.flowDirection.topToBottom

	----Populate-----------------------------------------------------------------------------------------------------

	--Materials
	local mTitle = border2:createLabel { text = "Materials", id = "kl_gem_mTitle" }
	mTitle.wrapText = true
	mTitle.justifyText = tes3.justifyText.center
	mTitle.borderBottom = 20

	local mats = border2:createLabel { text = "", id = "kl_gem_mats_0"}
	mats.wrapText = true
	mats.justifyText = tes3.justifyText.center

	gem.mats = mats

	--Pane
	local pane = border:createVerticalScrollPane { id = gem.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	--Populate Pane
	local petty = tes3.getObject("misc_SoulGem_Petty")
	local common = tes3.getObject("misc_SoulGem_Common")
	local greater = tes3.getObject("misc_SoulGem_Greater")
	local grand = tes3.getObject("misc_SoulGem_Grand")

	local p = pane:createTextSelect { text = "" .. petty.name .. "", id = "kl_gem_btn_0" }
	p:register("mouseClick", function(e) gem.onSelect(p, petty, 25, 2, 25, 0.25) end)

	local c = pane:createTextSelect { text = "" .. common.name .. "", id = "kl_gem_btn_1" }
	c:register("mouseClick", function(e) gem.onSelect(c, common, 50, 4, 50, 0.5) end)

	local g = pane:createTextSelect { text = "" .. greater.name .. "", id = "kl_gem_btn_2" }
	g:register("mouseClick", function(e) gem.onSelect(g, greater, 75, 7, 75, 1) end)

	local gd = pane:createTextSelect { text = "" .. grand.name .. "", id = "kl_gem_btn_3" }
	gd:register("mouseClick", function(e) gem.onSelect(gd, grand, 100, 10, 100, 2) end)



	--Calculate Bonuses
	local modifier = enchant.current
	if modifier > 200 then
		modifier = 200
	end

	gem.mgkReduction = math.round(modifier * 0.30)

	--Text Block
	local text_block = menu:createBlock { id = "text_block_gem" }
	text_block.width = 490
	text_block.height = 112
	text_block.borderAllSides = 10
	text_block.flowDirection = "left_to_right"

	local base_block = text_block:createBlock {}
	base_block.width = 175
	base_block.height = 112
	base_block.borderAllSides = 4
	base_block.flowDirection = "top_to_bottom"

	local ench_block = text_block:createBlock {}
	ench_block.width = 175
	ench_block.height = 112
	ench_block.borderAllSides = 4
	ench_block.flowDirection = "top_to_bottom"
	ench_block.wrapText = true

	local total_block = text_block:createBlock {}
	total_block.width = 175
	total_block.height = 112
	total_block.borderAllSides = 4
	total_block.flowDirection = "top_to_bottom"
	total_block.wrapText = true

	--Base Statistics
	local base_title = base_block:createLabel({ text = "Base Cost:", id = "kl_att_gem" })
	base_title.color = { 1.0, 1.0, 1.0 }
	gem.base_mgk = base_block:createLabel({ text = "Magicka: ", id = "kl_gem_mgk" })

	--Enchantments
	local ench_title = ench_block:createLabel({ text = "Cost Reduction:" })
	ench_title.color = { 1.0, 1.0, 1.0 }
	ench_block:createLabel { text = "Magicka: " .. gem.mgkReduction .. "%", id = "kl_gem_mgk_e" }

	--Totals
	local total_title = total_block:createLabel({ text = "Total Cost:" })
	total_title.color = { 1.0, 1.0, 1.0 }
	gem.total_mgk = total_block:createLabel { text = "Magicka: ", id = "kl_gem_mgk_t" }

	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	gem.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()
		local modData = func.getModData(ref)

		if enchant.current < gem.req then
			tes3.messageBox("" .. ref.object.name .. " is not skilled enough to synthesize " .. gem.obj.name .. ".")
			return
		end

		if modData.tp_current < gem.tp then
			tes3.messageBox("Not enough Technique Points!")
			return
		end

		if ref.mobile.magicka.current < gem.mgkCost then
			tes3.messageBox("Not enough Magicka!")
			return
		end

		local item
		local success = false

		--Check Materials
		if gem.req == 25 then
			item = func.checkReq(true, "ingred_resin_01", 1, tes3.player)

			if item then
				item = func.checkReq(false, "ingred_resin_01", 1, tes3.player)
				success = true
			else
				item = func.checkReq(true, "ingred_resin_01", 1, ref)
				if item then
					item = func.checkReq(false, "ingred_resin_01", 1, ref)
					success = true
				end
			end
		elseif gem.req == 50 then
			item = func.checkReq(true, "misc_SoulGem_Petty", 2, tes3.player)

			if item then
				item = func.checkReq(false, "misc_SoulGem_Petty", 2, tes3.player)
				success = true
			else
				item = func.checkReq(true, "misc_SoulGem_Petty", 2, ref)
				if item then
					item = func.checkReq(false, "misc_SoulGem_Petty", 2, ref)
					success = true
				end
			end
		elseif gem.req == 75 then
			item = func.checkReq(true, "misc_SoulGem_Common", 3, tes3.player)

			if item then
				item = func.checkReq(false, "misc_SoulGem_Common", 3, tes3.player)
				success = true
			else
				item = func.checkReq(true, "misc_SoulGem_Common", 3, ref)
				if item then
					item = func.checkReq(false, "misc_SoulGem_Common", 3, ref)
					success = true
				end
			end
		elseif gem.req == 100 then
			item = func.checkReq(true, "misc_SoulGem_Greater", 2, tes3.player)

			if item then
				item = func.checkReq(false, "misc_SoulGem_Greater", 2, tes3.player)
				success = true
			else
				item = func.checkReq(true, "misc_SoulGem_Greater", 2, ref)
				if item then
					item = func.checkReq(false, "misc_SoulGem_Greater", 2, ref)
					success = true
				end
			end
		end

		if success then
			--Pass Time
			local gameHour = tes3.getGlobal('GameHour')
			gameHour = (gameHour + gem.time)
			tes3.setGlobal('GameHour', gameHour)
			tes3.playSound({sound = "enchant success"})

			--Spend TP
			modData.tp_current = modData.tp_current - gem.tp

			--Spend Magicka
			tes3.modStatistic({ reference = ref, name = "magicka", current = (gem.mgkCost * -1) })

			--Synthesize Gem
			tes3.addItem({ reference = tes3.player, item = gem.obj, count = 1 })
			tes3.messageBox("" .. gem.obj.name .. " created.")
		else
			--Not Enough Materials
			tes3.messageBox("Not enough materials.")
		end
	end)

	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(gem.id_menu)
end

function gem.onSelect(elem, obj, req, tp, mgkCost, time)
	local menu = tes3ui.findMenu(gem.id_menu)

	if menu then
		for i = 0, 3 do
			local btn = menu:findChild("kl_gem_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4
		gem.obj = obj
		gem.tp = tp
		gem.req = req
		gem.mgkCost = math.round(mgkCost * (1 - (gem.mgkReduction * 0.01)))
		gem.time = time

		gem.base_mgk.text = "Magicka: " .. mgkCost .. ""

		gem.total_mgk.text = "Magicka: " .. gem.mgkCost .. ""

		if req == 25 then
			gem.mats.text = "Resin: 1\nTime: 15 minutes\nEnchant Required: 25\nTP: " .. tp .. ""
		elseif req == 50 then
			gem.mats.text = "Petty Soul Gem: 2\nTime: 30 minutes\nEnchant Required: 50\nTP: " .. tp .. ""
		elseif req == 75 then
			gem.mats.text = "Common Soul Gem: 3\nTime: 1 hour\nEnchant Required: 75\nTP: " .. tp .. ""
		elseif req == 100 then
			gem.mats.text = "Greater Soul Gem: 2\nTime: 2 hours\nEnchant Required: 100\nTP: " .. tp .. ""
		end

		gem.ok.widget.state = 1
		gem.ok.disabled = false

		menu:updateLayout()
	end
end


return gem