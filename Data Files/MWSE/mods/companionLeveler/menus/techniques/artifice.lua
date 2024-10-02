local logger = require("logging.logger")
local log = logger.getLogger("Companion Leveler")
local func = require("companionLeveler.functions.common")


local artifice = {}


function artifice.createWindow(ref)
	--Initialize IDs
	artifice.id_menu = tes3ui.registerID("kl_artifice_menu")
	artifice.id_pane = tes3ui.registerID("kl_artifice_pane")
	artifice.id_ok = tes3ui.registerID("kl_artifice_ok")

	log = logger.getLogger("Companion Leveler")
	log:debug("Artifice menu initialized.")

	local tech = require("companionLeveler.menus.techniques.techniques")

	if (ref) then
		artifice.ref = ref
	end

	-- Create window and frame
	local menu = tes3ui.createMenu { id = artifice.id_menu, fixedFrame = true }

	-- Create layout
	local input_label = menu:createLabel { text = "Construct which golem?" }
	input_label.borderBottom = 5

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_artifice" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- Pane Border
	local border = pane_block:createThinBorder { id = "kl_border_artifice" }
	border.positionX = 4
	border.positionY = -4
	border.width = 210
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4

	-- Material Border
	local border2 = pane_block:createThinBorder { id = "kl_border2_artifice" }
	border2.positionX = 202
	border2.positionY = 0
	border2.width = 308
	border2.height = 170
	border2.paddingAllSides = 4
	border2.wrapText = true
	border2.flowDirection = tes3.flowDirection.topToBottom

	----Populate-----------------------------------------------------------------------------------------------------

	--Materials
	local mTitle = border2:createLabel { text = "Materials", id = "kl_artifice_mTitle" }
	mTitle.wrapText = true
	mTitle.justifyText = tes3.justifyText.center
	mTitle.borderBottom = 20

	local mats = border2:createLabel { text = "", id = "kl_artifice_mats_0"}
	mats.wrapText = true
	mats.justifyText = tes3.justifyText.center

	artifice.mats = mats

	--Pane
	local pane = border:createVerticalScrollPane { id = artifice.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	--Populate Pane
	local spider = tes3.getObject("centurion_spider")
	local sphere = tes3.getObject("centurion_sphere")
	local steam = tes3.getObject("centurion_steam")
	local archer = tes3.getObject("centurion_projectile")
	local advanced = tes3.getObject("centurion_steam_advance")

	local armorer = ref.mobile:getSkillStatistic(1)
	local enchant = ref.mobile:getSkillStatistic(9)

	if armorer.current >= 25 then
		local a = pane:createTextSelect { text = "" .. spider.name .. "", id = "kl_artifice_btn_0" }
		a:register("mouseClick", function(e) artifice.onSelect(a, spider, 0, 4) end)
	end

	if armorer.current >= 50 then
		local a = pane:createTextSelect { text = "" .. sphere.name .. "", id = "kl_artifice_btn_1" }
		a:register("mouseClick", function(e) artifice.onSelect(a, sphere, 1, 6) end)
	end

	if armorer.current >= 75 then
		local a = pane:createTextSelect { text = "" .. steam.name .. "", id = "kl_artifice_btn_2" }
		a:register("mouseClick", function(e) artifice.onSelect(a, steam, 2, 8) end)
	end

	if armorer.current >= 100 and enchant.current >= 75 then
		local a = pane:createTextSelect { text = "" .. archer.name .. "", id = "kl_artifice_btn_3" }
		a:register("mouseClick", function(e) artifice.onSelect(a, archer, 3, 12) end)
	end

	if armorer.current >= 150 and enchant.current >= 100 then
		local a = pane:createTextSelect { text = "" .. advanced.name .. "", id = "kl_artifice_btn_4" }
		a:register("mouseClick", function(e) artifice.onSelect(a, advanced, 4, 20) end)
	end

	--Calculate Bonuses
	local modifier = enchant.current
	if modifier > 200 then
		modifier = 200
	end

	artifice.hthBonus = math.round(modifier * 0.75)
	artifice.mgkBonus = math.round(modifier * 0.5)
	artifice.fatBonus = math.round(modifier * 1.25)
	artifice.strBonus = math.round(modifier * 0.20)

	--Text Block
	local text_block = menu:createBlock { id = "text_block_artifice" }
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
	local base_title = base_block:createLabel({ text = "Base Statistics:", id = "kl_att_artifice" })
	base_title.color = { 1.0, 1.0, 1.0 }
	artifice.base_hth = base_block:createLabel({ text = "Health: ", id = "kl_artifice_hth" })
	artifice.base_mgk = base_block:createLabel({ text = "Magicka: ", id = "kl_artifice_mgk" })
	artifice.base_fat = base_block:createLabel({ text = "Fatigue: ", id = "kl_artifice_fat" })
	artifice.base_str = base_block:createLabel({ text = "Strength: ", id = "kl_artifice_str" })

	--Enchantments
	local ench_title = ench_block:createLabel({ text = "Enchantments:" })
	ench_title.color = { 1.0, 1.0, 1.0 }
	func.clTooltip(ench_title, "skill:9")
	ench_block:createLabel { text = "Health: +" .. artifice.hthBonus .. "", id = "kl_artifice_hth_e" }
	ench_block:createLabel { text = "Magicka: +" .. artifice.mgkBonus .. "", id = "kl_artifice_mgk_e" }
	ench_block:createLabel { text = "Fatigue: +" .. artifice.fatBonus .. "", id = "kl_artifice_fat_e" }
	ench_block:createLabel { text = "Strength: +" .. artifice.strBonus .. "", id = "kl_artifice_str_e" }

	--Totals
	local total_title = total_block:createLabel({ text = "Total Statistics:" })
	total_title.color = { 1.0, 1.0, 1.0 }
	artifice.total_hth = total_block:createLabel { text = "Health: ", id = "kl_artifice_hth_t" }
	artifice.total_mgk = total_block:createLabel { text = "Magicka: ", id = "kl_artifice_mgk_t" }
	artifice.total_fat = total_block:createLabel { text = "Fatigue: ", id = "kl_artifice_fat_t" }
	artifice.total_str = total_block:createLabel { text = "Strength: ", id = "kl_artifice_str_t" }

	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	artifice.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()
		local modData = func.getModData(ref)

		if modData.tp_current < artifice.tp then
			tes3.messageBox("Not enough Technique Points!")
			return
		end

		local metal, gem, misc
		local success = false
		local limit = false

		for mobileActor in tes3.iterate(tes3.mobilePlayer.friendlyActors) do
			if (mobileActor.reference.object.objectType == tes3.objectType.creature) and string.match(mobileActor.object.name, "Centurion")
			and string.startswith(mobileActor.object.name, "Summoned")  == false then
				tes3.messageBox("You can only have one construct at a time!")
				limit = true
				break
			end
		end

		if limit then
			return
		end

		if tes3.canRest then
			--Centurion Spider
			if artifice.id == 0 then
				metal = func.checkReq(true, "ingred_scrap_metal_01", 2, tes3.player)
				gem = func.checkReq(true, "Misc_SoulGem_Petty", 1, tes3.player)
				misc = func.checkReq(true, "misc_de_foldedcloth00", 2, tes3.player)

				if metal and gem and misc then
					func.checkReq(false, "ingred_scrap_metal_01", 2, tes3.player)
					func.checkReq(false, "Misc_SoulGem_Petty", 1, tes3.player)
					func.checkReq(false, "misc_de_foldedcloth00", 2, tes3.player)
					success = true
				else
					metal = func.checkReq(true, "ingred_scrap_metal_01", 2, ref)
					gem = func.checkReq(true, "Misc_SoulGem_Petty", 1, ref)
					misc = func.checkReq(true, "misc_de_foldedcloth00", 2, ref)

					if metal and gem and misc then
						func.checkReq(false, "ingred_scrap_metal_01", 2, ref)
						func.checkReq(false, "Misc_SoulGem_Petty", 1, ref)
						func.checkReq(false, "misc_de_foldedcloth00", 2, ref)
						success = true
					end
				end
			--Centurion Sphere
			elseif artifice.id == 1 then
				metal = func.checkReq(true, "ingred_scrap_metal_01", 3, tes3.player)
				gem = func.checkReq(true, "Misc_SoulGem_Common", 1, tes3.player)
				misc = func.checkReq(true, "misc_com_silverware_knife", 1, tes3.player)

				if metal and gem and misc then
					func.checkReq(false, "ingred_scrap_metal_01", 3, tes3.player)
					func.checkReq(false, "Misc_SoulGem_Common", 1, tes3.player)
					func.checkReq(false, "misc_com_silverware_knife", 1, tes3.player)
					success = true
				else
					metal = func.checkReq(true, "ingred_scrap_metal_01", 3, ref)
					gem = func.checkReq(true, "Misc_SoulGem_Common", 1, ref)
					misc = func.checkReq(true, "misc_com_silverware_knife", 1, ref)

					if metal and gem and misc then
						func.checkReq(false, "ingred_scrap_metal_01", 3, ref)
						func.checkReq(false, "Misc_SoulGem_Common", 1, ref)
						func.checkReq(false, "misc_com_silverware_knife", 1, ref)
						success = true
					end
				end
			--Steam Centurion
			elseif artifice.id == 2 then
				metal = func.checkReq(true, "ingred_scrap_metal_01", 5, tes3.player)
				gem = func.checkReq(true, "Misc_SoulGem_Greater", 1, tes3.player)
				misc = func.checkReq(true, "misc_dwrv_gear00", 1, tes3.player)

				if metal and gem and misc then
					func.checkReq(false, "ingred_scrap_metal_01", 5, tes3.player)
					func.checkReq(false, "Misc_SoulGem_Greater", 1, tes3.player)
					func.checkReq(false, "misc_dwrv_gear00", 1, tes3.player)
					success = true
				else
					metal = func.checkReq(true, "ingred_scrap_metal_01", 5, ref)
					gem = func.checkReq(true, "Misc_SoulGem_Greater", 1, ref)
					misc = func.checkReq(true, "misc_dwrv_gear00", 1, ref)

					if metal and gem and misc then
						func.checkReq(false, "ingred_scrap_metal_01", 5, ref)
						func.checkReq(false, "Misc_SoulGem_Greater", 1, ref)
						func.checkReq(false, "misc_dwrv_gear00", 1, ref)
						success = true
					end
				end
			--Centurion Archer
			elseif artifice.id == 3 then
				metal = func.checkReq(true, "ingred_scrap_metal_01", 7, tes3.player)
				gem = func.checkReq(true, "Misc_SoulGem_Grand", 1, tes3.player)
				misc = func.checkReq(true, "misc_dwrv_artifact50", 1, tes3.player)
				local diamond = func.checkReq(true, "ingred_diamond_01", 1, tes3.player)

				if metal and gem and misc and diamond then
					func.checkReq(false, "ingred_scrap_metal_01", 7, tes3.player)
					func.checkReq(false, "Misc_SoulGem_Grand", 1, tes3.player)
					func.checkReq(false, "misc_dwrv_artifact50", 1, tes3.player)
					func.checkReq(false, "ingred_diamond_01", 1, tes3.player)
					success = true
				else
					metal = func.checkReq(true, "ingred_scrap_metal_01", 7, ref)
					gem = func.checkReq(true, "Misc_SoulGem_Grand", 1, ref)
					misc = func.checkReq(true, "misc_dwrv_artifact50", 1, ref)
					diamond = func.checkReq(true, "ingred_diamond_01", 1, ref)

					if metal and gem and misc and diamond then
						func.checkReq(false, "ingred_scrap_metal_01", 7, ref)
						func.checkReq(false, "Misc_SoulGem_Grand", 1, ref)
						func.checkReq(false, "misc_dwrv_artifact50", 1, ref)
						func.checkReq(false, "ingred_diamond_01", 1, ref)
						success = true
					end
				end
			--Advanced Steam Centurion
			elseif artifice.id == 4 then
				metal = func.checkReq(true, "ingred_scrap_metal_01", 10, tes3.player)
				gem = func.checkReq(true, "Misc_SoulGem_Grand", 2, tes3.player)
				misc = func.checkReq(true, "misc_dwrv_gear00", 1, tes3.player)
				local tube = func.checkReq(true, "misc_dwrv_artifact60", 2, tes3.player)

				if metal and gem and misc and tube then
					func.checkReq(false, "ingred_scrap_metal_01", 10, tes3.player)
					func.checkReq(false, "Misc_SoulGem_Grand", 2, tes3.player)
					func.checkReq(false, "misc_dwrv_gear00", 1, tes3.player)
					func.checkReq(false, "misc_dwrv_artifact60", 2, tes3.player)
					success = true
				else
					metal = func.checkReq(true, "ingred_scrap_metal_01", 10, ref)
					gem = func.checkReq(true, "Misc_SoulGem_Grand", 2, ref)
					misc = func.checkReq(true, "misc_dwrv_gear00", 1, ref)
					tube = func.checkReq(true, "misc_dwrv_artifact60", 2, ref)

					if metal and gem and misc and tube then
						func.checkReq(false, "ingred_scrap_metal_01", 10, ref)
						func.checkReq(false, "Misc_SoulGem_Grand", 2, ref)
						func.checkReq(false, "misc_dwrv_gear00", 1, ref)
						func.checkReq(false, "misc_dwrv_artifact60", 2, ref)
						success = true
					end
				end
			end

			if success then
				--Pass Time
				local gameHour = tes3.getGlobal('GameHour')
				gameHour = (gameHour + 1 + artifice.id)
				tes3.setGlobal('GameHour', gameHour)
				tes3.playSound({sound = "spiderRIGHT"})

				--Spend TP
				modData.tp_current = modData.tp_current - artifice.tp

				--Create Golem
				local golem = tes3.createReference({ object = artifice.obj, position = tes3.getCameraPosition(), orientation = tes3.player.orientation:copy(), cell = tes3.player.cell })
				golem.mobile.fight = 40
				tes3.setAIFollow({ reference = golem, target = ref })

				--Apply Bonuses
				if artifice.id == 0 then
					tes3.setStatistic({ attribute = tes3.attribute.speed, value = 200, reference = golem })
				end
				tes3.modStatistic({ name = "health", value = artifice.hthBonus, reference = golem })
				tes3.modStatistic({ name = "magicka", value = artifice.mgkBonus, reference = golem })
				tes3.modStatistic({ name = "fatigue", value = artifice.fatBonus, reference = golem })
				tes3.modStatistic({ attribute = tes3.attribute.strength, value = artifice.strBonus, reference = golem })

				menu:destroy()
				tes3ui.leaveMenuMode()
			else
				--Not Enough Materials
				tes3.messageBox("Not enough materials.")
			end
		else
			--Unsuitable Conditions
			tes3.messageBox("" .. ref.object.name .. " cannot work in water or with enemies nearby.")
		end
	end)
	button_cancel:register("mouseClick", function() menu:destroy() tech.createWindow(ref) end)


	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(artifice.id_menu)
end

function artifice.onSelect(elem, obj, id, tp)
	local menu = tes3ui.findMenu(artifice.id_menu)

	if menu then
		for i = 0, 4 do
			local btn = menu:findChild("kl_artifice_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4
		artifice.obj = obj
		artifice.id = id
		artifice.tp = tp

		artifice.base_hth.text = "Health: " .. obj.health .. ""
		artifice.base_mgk.text = "Magicka: " .. obj.magicka .. ""
		artifice.base_fat.text = "Fatigue: " .. obj.fatigue .. ""
		artifice.base_str.text = "Strength: " .. obj.attributes[1] .. ""

		artifice.total_hth.text = "Health: " .. obj.health + artifice.hthBonus .. ""
		artifice.total_mgk.text = "Magicka: " .. obj.magicka + artifice.mgkBonus .. ""
		artifice.total_fat.text = "Fatigue: " .. obj.fatigue + artifice.fatBonus .. ""
		artifice.total_str.text = "Strength: " .. obj.attributes[1] + artifice.strBonus .. ""

		if id == 0 then
			artifice.mats.text = "Scrap Metal: 2\nPetty Soul Gem: 1\nFolded Cloth: 2\nTime: 1 hour\nTP: " .. tp .. ""
		elseif id == 1 then
			artifice.mats.text = "Scrap Metal: 3\nCommon Soul Gem: 1\nKnife (silverware): 1\nTime: 2 hours\nTP: " .. tp .. ""
		elseif id == 2 then
			artifice.mats.text = "Scrap Metal: 5\nGreater Soul Gem: 1\nRusty Dwemer Cog: 1\nTime: 3 hours\nTP: " .. tp .. ""
		elseif id == 3 then
			artifice.mats.text = "Scrap Metal: 7\nGrand Soul Gem: 1\nDwemer Coherer: 1\nDiamond: 1\nTime: 4 hours\nTP: " .. tp .. ""
		elseif id == 4 then
			artifice.mats.text = "Scrap Metal: 10\nGrand Soul Gem: 2\nRusty Dwemer Cog: 1\nDwemer Tube: 2\nTime: 5 hours\nTP: " .. tp .. ""
		end

		artifice.ok.widget.state = 1
		artifice.ok.disabled = false

		menu:updateLayout()
	end
end


return artifice