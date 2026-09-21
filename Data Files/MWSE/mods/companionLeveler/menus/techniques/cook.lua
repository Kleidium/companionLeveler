local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")


local cook = {}


function cook.createWindow(ref)
	--Initialize IDs
	cook.id_menu = tes3ui.registerID("kl_cook_menu")
	cook.id_pane = tes3ui.registerID("kl_cook_pane")
	cook.id_ok = tes3ui.registerID("kl_cook_ok")

	log:debug("Cooking menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")

	local modData = func.getModData(ref)
	cook.ref = ref
	cook.alchemy = ref.mobile:getSkillStatistic(tes3.skill.alchemy)
	cook.int = ref.mobile.attributes[2]
	cook.alchemyText = tes3.findGMST(tes3.gmst.sSkillAlchemy).value
	cook.moon_sugar = tes3.getObject("ingred_moon_sugar_01")
	cook.rat_meat = tes3.getObject("ingred_rat_meat_01")
	cook.crab_meat = tes3.getObject("ingred_crab_meat_01")
	cook.hound_meat = tes3.getObject("ingred_hound_meat_01")
	cook.durzog_meat = tes3.getObject("ingred_durzog_meat_01")
	cook.small_egg = tes3.getObject("food_kwama_egg_01")
	cook.large_egg = tes3.getObject("food_kwama_egg_02")
	cook.ash_yam = tes3.getObject("ingred_ash_yam_01")
	cook.kwama_cuttle = tes3.getObject("ingred_kwama_cuttle_01")
	cook.comberry = tes3.getObject("ingred_comberry_01")
	cook.corkbulb = tes3.getObject("ingred_corkbulb_root_01")
	cook.ripe_berries = tes3.getObject("ingred_belladonna_01")
	cook.bread = tes3.getObject("ingred_bread_01")
	cook.hackle_lo = tes3.getObject("ingred_hackle-lo_leaf_01")
	cook.bittergreen = tes3.getObject("ingred_bittergreen_petals_01")
	cook.marshmerrow = tes3.getObject("ingred_marshmerrow_01")
	cook.saltrice = tes3.getObject("ingred_saltrice_01")
	cook.scrib_jelly = tes3.getObject("ingred_scrib_jelly_01")
	cook.scrib_jerky = tes3.getObject("ingred_scrib_jerky_01")
	cook.scuttle = tes3.getObject("ingred_scuttle_01")
	cook.scathecraw = tes3.getObject("ingred_scathecraw_01")
	cook.ash_salts = tes3.getObject("ingred_ash_salts_01")
	cook.dough = tes3.getObject("kl_ingred_dough")
	cook.pearl = tes3.getObject("ingred_pearl_01")
	cook.roobrush = tes3.getObject("ingred_roobrush_01")
	cook.violet_coprinus = tes3.getObject("ingred_coprinus_01")
	cook.luminous_russula = tes3.getObject("ingred_russula_01")
	cook.wickwheat = tes3.getObject("ingred_wickwheat_01")
	cook.hypha_facia = tes3.getObject("ingred_bc_hypha_facia")
	cook.sweet_pulp = tes3.getObject("ingred_sweetpulp_01")
	cook.trama_root = tes3.getObject("ingred_trama_root_01")


	cook.recipes = {
		[220] = {"Dough", { { cook.wickwheat, 3 } }, 0.3, 1}, --Dough
		[225] = {"Bread", { { cook.dough, 1 } }, 0.5, 0}, --Bread
		[226] = {"Rat Sandwich", {{ cook.bread, 1 }, { cook.rat_meat, 1 }, { cook.scuttle, 1 }}, 0.25, 2}, --Rat Sandwich
		[227] = {"Hound Sandwich", {{ cook.bread, 1}, { cook.hound_meat, 1 }, { cook.hackle_lo, 1 }}, 0.25, 2}, --Hound Sandwich
		[228] = {"Scrib Sandwich", {{ cook.bread, 1}, { cook.scrib_jelly, 1 }, { cook.scrib_jerky, 1 }}, 0.25, 2}, --Scrib Sandwich
		[229] = {"Crab Sandwich", {{ cook.bread, 1}, { cook.crab_meat, 1 }, { cook.bittergreen, 1 }}, 0.25, 2}, --Crab Sandwich
		[230] = {"Crab Stew", {{ cook.crab_meat, 2 }, { cook.bittergreen, 1 }, { cook.wickwheat, 1 }, { cook.scuttle, 1 }}, 1.5, 3}, --Crab Stew
		[231] = {"Scribbled Eggs", {{ cook.scrib_jerky, 1 }, { cook.small_egg, 2 }}, 0.25, 2}, --Scribbled Eggs
		[233] = {"Scribbled Eggs & Toast", {{ cook.scrib_jelly, 1 }, { cook.bread, 1 }, { cook.small_egg, 2 }, { cook.scrib_jerky, 1 }}, 0.5, 3}, --Scribbled Eggs and Toast
		[232] = {"Egg Sandwich", {{ cook.bread, 1 }, { cook.small_egg, 2 }, { cook.ash_salts, 1 }}, 0.25, 2}, --Egg Sandwich
		[234] = {"Kwama Egg Stew", {{ cook.small_egg, 3 }, { cook.hackle_lo, 1 }, { cook.scathecraw, 1 }, { cook.roobrush, 1 }, { cook.scuttle, 1 }}, 1.5, 3}, --Kwama Egg Stew
		[235] = {"Hackle-lo Salad", {{ cook.hackle_lo, 3 }, { cook.scathecraw, 1 }, { cook.luminous_russula, 1 }, { cook.violet_coprinus, 1 }, { cook.scuttle, 1 }}, 0.5, 3}, --Hackle-lo Salad
		[237] = {"Spice Bread", {{ cook.marshmerrow, 2 }, { cook.wickwheat, 3 }, { cook.bittergreen, 1 }}, 1, 2}, --Spice Bread
		[240] = {"Swamp Soup", {{ cook.crab_meat, 1}, { cook.luminous_russula, 1}, { cook.violet_coprinus, 1 }, {cook.hypha_facia, 1 }, { cook.small_egg, 1 }}, 1.5, 3}, --Swamp Soup
		[265] = {"Scuttle Crab", {{ cook.scuttle, 2 }, { cook.wickwheat, 4}, { cook.large_egg, 1 }, { cook.crab_meat, 2 }, { cook.bittergreen, 1 }}, 3, 4}, --Scuttle Crab
		[245] = {"Hound Chili", {{ cook.hound_meat, 3 }, { cook.bittergreen, 1 }, { cook.ash_salts, 1 }, { cook.hackle_lo, 1 }}, 2, 3}, --Hound Chili
		[250] = {"Ash Yam Loaf", {{ cook.dough, 1 }, { cook.ash_yam, 1 }}, 1, 2}, --Ash Yam Loaf
		[258] = {"Berry Loaf", {{ cook.dough, 1 }, { cook.comberry, 2 }, { cook.ripe_berries, 1 }}, 1, 3}, --Berry Loaf
		[255] = {"Moon Bread", {{ cook.dough, 1 }, { cook.moon_sugar, 1 }, { cook.marshmerrow, 1 }}, 1, 4}, --Moon Bread
		[271] = {"Moonberry Jam", {{ cook.ripe_berries, 3 }, { cook.comberry, 2 }, { cook.bittergreen, 1 }, { cook.scrib_jelly, 1 }, { cook.moon_sugar, 1 }}, 0.5, 4}, --Moonberry Jam
		[259] = {"Ash Yam Pie", {{ cook.ash_yam, 3 }, { cook.dough, 1 }, { cook.comberry, 1 }}, 1, 3}, --Ash Yam Pie
		[253] = {"Mushroom Pie", {{ cook.dough, 1 }, { cook.violet_coprinus, 1 }, { cook.luminous_russula, 1 }, { cook.hypha_facia, 1 }}, 1.5, 3}, --Mushroom Pie
		[254] = {"Sweet Root Rolls", {{ cook.dough, 1 }, { cook.sweet_pulp, 1 }, { cook.trama_root, 1 }, {cook.corkbulb, 1 }}, 1.5, 3}, --Sweet Root Rolls
		[262] = {"Kwama Egg Quiche", {{ cook.large_egg, 1 }, { cook.ash_salts, 1 }, { cook.dough, 1 }}, 1, 3}, --Kwama Egg Quiche
		[264] = {"Marshmerrow Cake", {{ cook.marshmerrow, 3}, { cook.dough, 2 }, { cook.sweet_pulp, 1 }}, 2, 4}, --Marshmerrow Cake
		[266] = {"Spiced Root Cake", {{ cook.trama_root, 2 }, { cook.corkbulb, 2 }, { cook.dough, 2 }}, 2, 3}, --Spiced Root Cake
		[270] = {"Durzog Fry", {{ cook.durzog_meat, 1 }, { cook.small_egg, 1 }, { cook.saltrice, 2 }, { cook.scathecraw, 1 }}, 1, 3}, --Durzog Fry
		[273] = {"Yam Chips", {{ cook.ash_yam, 4 }, { cook.hound_meat, 1 }, { cook.hackle_lo, 1 }, { cook.large_egg, 1 }, { cook.kwama_cuttle, 1 }, { cook.roobrush, 1 }}, 3, 5}, --Yam Chips
		[275] = {"Hound and Rat", {{ cook.rat_meat, 1}, { cook.hound_meat, 1 }, { cook.saltrice, 1 }, { cook.scuttle, 1 }, { cook.small_egg, 1 }, { cook.ash_salts, 1 }, { cook.dough, 1 }}, 3, 5}, --Hound and Rat
		[277] = {"Carnivore Casserole", {{ cook.dough, 1 }, { cook.durzog_meat, 1 }, { cook.rat_meat, 1 }, { cook.hound_meat, 1 }, { cook.large_egg, 1 }, { cook.bittergreen, 1 }, { cook.ash_salts, 1 }}, 3, 5}, --Carnivore Casserole
		[280] = {"Pearl-Dusted Marshmerrow Cake", {{ cook.marshmerrow, 3}, { cook.dough, 2 }, { cook.pearl, 1 }, { cook.sweet_pulp, 1 }}, 3, 6}, --Pearl-Dusted Marshmerrow Cake
		[285] = {"Magic Mushroom Stew", {{ cook.moon_sugar, 1 }, { cook.violet_corpinus, 1 }, { cook.luminous_russula, 1 }, { cook.hypha_facia, 1 }, { cook.ash_salts, 1 }, { cook.durzog_meat, 1 }}, 3, 6} --Magic Mushroom Stew
	}

	--TR Recipes
	local modList = tes3.getModList()

	for i, v in pairs(modList) do
		if v == "Tamriel_Data.esm" then
			cook.scrib_cabbage = tes3.getObject("Ingred_scrib_cabbage_01")
	
			cook.recipes[256] = {"Cabbage Biscuits", {{ cook.dough, 1 }, { cook.scrib_cabbage, 1 }}, 1, 3} -- TR Cabbage Biscuits
			cook.recipes[257] = {"Cabbage Soup", {{ cook.scrib_cabbage, 1 }, { cook.saltrice, 2 }, { cook.ash_salts, 1 }}, 1.5, 3} --TR Cabbage Soup
			break
		end
	end




	-- Create window and frame
	local menu = tes3ui.createMenu { id = cook.id_menu, fixedFrame = true }

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_cook" }
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
	title_block:createLabel { text = "Cooking" }

	-- TP Bar
	cook.tp_bar = tp_block:createFillBar({ current = modData.tp_current, max = modData.tp_max, id = cook.id_tp_bar })
	func.configureBar(cook.tp_bar, "small", "purple")
	cook.tp_bar.borderLeft = 145

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_cook" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- Pane Border
	local border = pane_block:createThinBorder { id = "kl_border_cook" }
	border.positionX = 4
	border.positionY = -4
	border.width = 210
	border.height = 190
	border.borderAllSides = 4
	border.paddingAllSides = 4

	-- Material Border
	local border2 = pane_block:createThinBorder { id = "kl_border2_cook" }
	border2.positionX = 202
	border2.positionY = 0
	border2.width = 308
	border2.height = 200
	border2.paddingAllSides = 4
	border2.wrapText = true
	border2.flowDirection = tes3.flowDirection.topToBottom

	----Populate-----------------------------------------------------------------------------------------------------

	--Materials
	local mTitle = border2:createLabel { text = "Materials", id = "kl_cook_mTitle" }
	mTitle.wrapText = true
	mTitle.justifyText = tes3.justifyText.center
	mTitle.borderBottom = 20

	local mats = border2:createLabel { text = "", id = "kl_cook_mats_0"}
	mats.wrapText = true
	mats.justifyText = tes3.justifyText.center

	cook.mats = mats

	--Pane
	local pane = border:createVerticalScrollPane { id = cook.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	--Populate Pane

	for i = 200, 300 do
		local table = cook.recipes[i] or nil
		if table ~= nil then
			local req = i - 200
			if math.round((cook.alchemy.current / 2 ) + (cook.int.current / 3)) >= req then
				local s = pane:createTextSelect { text = "" .. cook.recipes[i][1] .. "", id = "kl_cook_btn_" .. i }
				s:register("mouseClick", function(e) cook.onSelect(s, cook.recipes[i]) end)
				if cook.recipes[i][1] == "Pearl-Dusted Marshmerrow Cake" then
					s:register("help", function(e)
						local tooltip = tes3ui.createTooltipMenu { spell = "kl_food_pearl-dusted" }

						local contentElement = tooltip:getContentElement()
						contentElement.paddingAllSides = 12
						contentElement.childAlignX = 0.5
						contentElement.childAlignY = 0.5
					end)
				elseif cook.recipes[i][1] ~= "Dough" and cook.recipes[i][1] ~= "Bread" then
					s:register("help", function(e)
						local tooltip = tes3ui.createTooltipMenu { spell = "kl_food_" .. cook.recipes[i][1] }

						local contentElement = tooltip:getContentElement()
						contentElement.paddingAllSides = 12
						contentElement.childAlignX = 0.5
						contentElement.childAlignY = 0.5
					end)
				end
			end
		end
	end



	--Calculate Bonuses
	local modifier = cook.int.current
	if modifier > 200 then
		modifier = 200
	end

	cook.timeReduction = math.round(modifier * 0.40)

	--Text Block
	local text_block = menu:createBlock { id = "text_block_cook" }
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
	local base_title = base_block:createLabel({ text = "Base Time:", id = "kl_att_cook" })
	base_title.color = { 1.0, 1.0, 1.0 }
	cook.base_time = base_block:createLabel({ text = "", id = "kl_cook_time" })

	--Enchantments
	local ench_title = ench_block:createLabel({ text = "Time Reduction:" })
	ench_title.color = { 1.0, 1.0, 1.0 }
	func.clTooltip(ench_title, "att:1")
	ench_block:createLabel { text = "" .. cook.timeReduction .. "%", id = "kl_cook_time_e" }

	--Totals
	local total_title = total_block:createLabel({ text = "Total Time:" })
	total_title.color = { 1.0, 1.0, 1.0 }
	cook.total_time = total_block:createLabel { text = "", id = "kl_cook_time_t" }

	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	cook.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()

		if modData.tp_current < cook.tp then
			func.clMessageBox("Not enough Technique Points!")
			return
		end

		local item
		local success = false
		local success2 = false
		local success3 = false

		--Check Player Materials
		for i = 1, #cook.table[2] do
			local obj = cook.table[2][i][1]
			local amt = cook.table[2][i][2]

			item = func.checkReq(true, obj.id, amt, tes3.player)
			if item then
				success = true
			else
				success = false
				break
			end
		end

		--Check NPC Materials
		for i = 1, #cook.table[2] do
			local obj = cook.table[2][i][1]
			local amt = cook.table[2][i][2]

			item = func.checkReq(true, obj.id, amt, cook.ref)
			if item then
				success2 = true
			else
				success2 = false
				break
			end
		end

		if success then
			--Player Items Taken
			for i = 1, #cook.table[2] do
				local obj = cook.table[2][i][1]
				local amt = cook.table[2][i][2]

				item = func.checkReq(false, obj.id, amt, tes3.player)
			end

			success3 = true
		elseif success2 then
			--NPC Items Taken
			for i = 1, #cook.table[2] do
				local obj = cook.table[2][i][1]
				local amt = cook.table[2][i][2]

				item = func.checkReq(false, obj.id, amt, cook.ref)
			end

			success3 = true
		end

		if success3 then
			--Pass Time
			local gameHour = tes3.getGlobal('GameHour')
			gameHour = (gameHour + cook.timeCost)
			tes3.setGlobal('GameHour', gameHour)
			tes3.playSound({sound = "potion success"})

			--Spend TP
			modData.tp_current = modData.tp_current - cook.tp
			cook.tp_bar.widget.current = modData.tp_current

			--Synthesize cook
			if cook.table[1] == "Bread" then
				tes3.addItem({ reference = tes3.player, item = "ingred_bread_01", count = 1 })
				func.clMessageBox("" .. cook.ref.object.name .. " prepared " .. cook.table[1] .. ".")
			elseif cook.table[1] == "Dough" then
				tes3.addItem({ reference = tes3.player, item = "ingred_bread_01", count = 1 })
				func.clMessageBox("" .. cook.ref.object.name .. " prepared " .. cook.table[1] .. ".")
			else
				--Buffs
				local partyTable = func.partyTable()

				if cook.table[1] == "Pearl-Dusted Marshmerrow Cake" then
					--Pearl-Dusted
					for i = 1, #partyTable do
						if tes3.isAffectedBy({ reference = partyTable[i], object = "kl_food_fullness" }) then
							--Do Nothing
							func.clMessageBox("" .. partyTable[i].object.name .. " was still full from the last meal!")
						else
							--Apply Buff + Fullness
							tes3.cast({ reference = partyTable[i], spell = "kl_food_pearl-dusted", instant = true, bypassResistances = true })
							tes3.cast({ reference = partyTable[i], spell = "kl_food_fullness", instant = true, bypassResistances = true })
						end
					end
				else
					--All Others
					for i = 1, #partyTable do
						if tes3.isAffectedBy({ reference = partyTable[i], object = "kl_food_fullness" }) then
							--Do Nothing
							func.clMessageBox("" .. partyTable[i].object.name .. " was still full from the last meal!")
						else
							--Apply Buff + Fullness
							tes3.cast({ reference = partyTable[i], target = partyTable[i], spell = "kl_food_" .. cook.table[1] .. "", instant = true, bypassResistances = true })
							tes3.cast({ reference = partyTable[i], target = partyTable[i], spell = "kl_food_fullness", instant = true, bypassResistances = true })
						end
					end
				end

				func.clMessageBox("" .. cook.ref.object.name .. " prepared " .. cook.table[1] .. " for the party!")
			end

			menu:destroy()
			tes3ui.leaveMenuMode()
		else
			--Not Enough Materials
			func.clMessageBox("Not enough materials.")
		end
	end)

	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(cook.id_menu)
end

function cook.onSelect(elem, table)
	local menu = tes3ui.findMenu(cook.id_menu)

	if menu then
		for i = 200, 300 do
			local btn = menu:findChild("kl_cook_btn_" .. i .. "") or nil
			if btn ~= nil then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4
		cook.tp = table[4]
		cook.time = table[3]
		cook.timeCost = table[3] * (1 - (cook.timeReduction * 0.01))
		cook.table = table

		cook.base_time.text = "" .. math.round(cook.time * 60) .. " minutes"

		cook.total_time.text = "" .. math.round(cook.timeCost * 60, 1) .. " minutes"

		cook.mats.text = ""

		for i = 1, #table[2] do
			local obj = table[2][i][1]
			local amt = table[2][i][2]

			cook.mats.text = cook.mats.text .. obj.name .. " x" .. tostring(amt) .. "\n"
		end

		cook.mats.text = cook.mats.text .. "Time: " .. math.round(cook.time * 60) .. " minutes\nTP: " .. cook.tp .. ""

		cook.ok.widget.state = 1
		cook.ok.disabled = false

		menu:updateLayout()
	end
end


return cook