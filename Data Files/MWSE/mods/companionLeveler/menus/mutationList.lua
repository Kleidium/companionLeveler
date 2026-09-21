local tables = require("companionLeveler.tables")
local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")



local mut = {}


function mut.pickMutation(ref, slot, swap)
	--Initialize IDs
	mut.id_menu = tes3ui.registerID("kl_mutation_menu")
	mut.id_pane = tes3ui.registerID("kl_mutation_pane")
	mut.id_ok = tes3ui.registerID("kl_mutation_ok")
	mut.id_growth = tes3ui.registerID("kl_mutation_growth_btn")
	mut.id_image = tes3ui.registerID("kl_mutation_image")

	log:debug("Mutation menu initialized.")

	if (ref) then
		mut.ref = ref
	end

	mut.total = 0
	mut.slot = slot
	mut.swap = swap

	if (tes3ui.findMenu(mut.id_menu) ~= nil) then
		return
	end
	log:debug("Mutation menu triggered.")

	-- Create window and frame
	local menu = tes3ui.createMenu { id = mut.id_menu, fixedFrame = true }
	menu.alpha = 1.0

	-- Create layout
	local modData = func.getModData(ref)

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_mut" }
	head_block.autoWidth = true
	head_block.autoHeight = true
	head_block.borderBottom = 5

	--Title/TP Bar Blocks
	local title_block = head_block:createBlock{}
	title_block.width = 265
	title_block.autoHeight = true

	local tp_block = head_block:createBlock{}
	tp_block.width = 120
	tp_block.autoHeight = true

	-- Title
	local title_label = title_block:createLabel { text = "Choose a mutation for Slot " .. slot  .. "."}

	if swap then
		title_label.text = "Choose a Mutation Slot to replace."
		local btn = menu:createButton { text = "Swap Slot: 1", id = "kl_swap_btn" }
		btn:register("mouseClick", function(e)
			if btn.text == "Swap Slot: 1" then
				btn.text = "Swap Slot: 2"
				mut.slot = 2
			elseif btn.text == "Swap Slot: 2" then
				btn.text = "Swap Slot: 3"
				mut.slot = 3
			elseif btn.text == "Swap Slot: 3" then
				btn.text = "Swap Slot: 4"
				mut.slot = 4
			else
				btn.text = "Swap Slot: 1"
				mut.slot = 1
			end
			menu:updateLayout()
		end)
		-- TP Bar
		mut.tp_bar = tp_block:createFillBar({ current = modData.tp_current, max = modData.tp_max, id = mut.id_tp_bar })
		func.configureBar(mut.tp_bar, "small", "purple")
	end

	--Pane and Image Block
	local pane_block = menu:createBlock { id = "pane_block_mutation" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	local border = pane_block:createThinBorder { id = "kl_border_mutation" }
	border.width = 400
	border.height = 225

	--Pane
	local pane = border:createVerticalScrollPane { id = mut.id_pane }
	pane.height = 225
	pane.width = 400
	pane.widget.scrollbarVisible = true

	--Populate Pane
	for i = 1, 22 do --22 mutations total
		local found = false

		mut.total = mut.total + 1
		local spell = tes3.getObject("kl_ability_mutation_" .. i)
		local a = pane:createTextSelect({ text = "" .. spell.name .. "", id = "kl_mutation_btn_" .. mut.total .. "" })
		a:register("mouseClick", function(e) mut.onSelect(a, i)end)
		if modData.mutationSlots ~= nil then
			for n = 1, 4 do
				if i == modData.mutationSlots[n] then
					found = true
					break
				end
			end
		end

		a:register("help", function(e)
			local tooltip = tes3ui.createTooltipMenu { spell = spell }

			local contentElement = tooltip:getContentElement()
			contentElement.paddingAllSides = 12
			contentElement.childAlignX = 0.5
			contentElement.childAlignY = 0.5

			tooltip:createDivider()

			local typeLabel = tooltip:createLabel { text = "[PASSIVE]" }
			typeLabel.color = tables.colors["white"]

			if found then typeLabel.text = "[PASSIVE]\nEquipped" end
		end)

		if found then a.disabled = true a.widget.state = 2 end
	end

	--Sort Spells
	pane:getContentElement():sortChildren(function(c, d)
		local cText
		local dText

		for int = 1, mut.total do
			cText = ""
			local cChild = c:findChild("kl_mutation_btn_" .. int .. "")
			if cChild ~= nil then cText = cChild.text break end
		end
		for num = 1, mut.total do
			dText = ""
			local dChild = d:findChild("kl_mutation_btn_" .. num .. "")
			if dChild ~= nil then dText = dChild.text break end
		end

		return cText < dText
	end)

	--Text Blocks
	local text_block = menu:createBlock { id = "text_block" }
	text_block.width = 400
	text_block.height = 190
	text_block.flowDirection = "left_to_right"
	text_block.borderTop = 50

	local slot_block = text_block:createBlock {}
	slot_block.width = 200
	slot_block.height = 110
	slot_block.flowDirection = "top_to_bottom"
	--slot_block.borderLeft = 60

	local slot_block2 = text_block:createBlock {}
	slot_block2.width = 200
	slot_block2.height = 110
	slot_block2.flowDirection = "top_to_bottom"


	--1-2
	local slot1 = slot_block:createLabel({ text = "Slot 1:", id = "kl_slot1_label" })
	slot1.color = tables.colors["white"]
	slot1.wrapText = true
	slot1.justifyText = "center"

	local slot1b = slot_block:createLabel({ text = "", id = "kl_slot1" })
	slot1b.wrapText = true
	slot1b.justifyText = "center"
	slot1b.borderLeft = 2

	local slot3 = slot_block:createLabel({ text = "Slot 3:", id = "kl_slot3_label" })
	slot3.color = tables.colors["white"]
	slot3.borderTop = 10
	slot3.wrapText = true
	slot3.justifyText = "center"

	local slot3b = slot_block:createLabel({ text = "", id = "kl_slot3" })
	slot3b.wrapText = true
	slot3b.justifyText = "center"
	slot3b.borderLeft = 2

	--3-4
	local slot2 = slot_block2:createLabel({ text = "Slot 2:", id = "kl_slot2_label" })
	slot2.color = tables.colors["white"]
	slot2.wrapText = true
	slot2.justifyText = "center"

	local slot2b = slot_block2:createLabel({ text = "", id = "kl_slot2" })
	slot2b.wrapText = true
	slot2b.justifyText = "center"
	slot2b.borderLeft = 2

	local slot4 = slot_block2:createLabel({ text = "Slot 4:", id = "kl_slot4_label" })
	slot4.color = tables.colors["white"]
	slot4.wrapText = true
	slot4.justifyText = "center"
	slot4.borderTop = 10

	local slot4b = slot_block2:createLabel({ text = "", id = "kl_slot4" })
	slot4b.wrapText = true
	slot4b.justifyText = "center"
	slot4b.borderLeft = 2


	--Fill Slots
	if modData.mutationSlots ~= nil then
		for i = 1, 4 do
			if modData.mutationSlots[i] ~= nil then
				local obj = tes3.getObject("kl_ability_mutation_" .. modData.mutationSlots[i])
				local a = menu:findChild("kl_slot" .. i)
				a.text = obj.name
				a:register("help", function(e)
					local tooltip = tes3ui.createTooltipMenu { spell = obj }

					local contentElement = tooltip:getContentElement()
					contentElement.paddingAllSides = 12
					contentElement.childAlignX = 0.5
					contentElement.childAlignY = 0.5

					tooltip:createDivider()

					local typeLabel = tooltip:createLabel { text = "[PASSIVE]\nEquipped" }
					typeLabel.color = tables.colors["white"]
				end)
			end
		end
	end


	--Button Block
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0 -- width is 100% parent width
	button_block.autoHeight = true
	button_block.childAlignX = 0.5
	button_block.borderTop = 8

	if swap then
		mut.button_cancel = button_block:createButton { id = mut.id_cancel, text = tes3.findGMST("sCancel").value}
		mut.button_cancel:register(tes3.uiEvent.mouseClick, function(e) menu:destroy() tes3ui.leaveMenuMode() end)
	end
	mut.button_ok = button_block:createButton { id = mut.id_ok, text = tes3.findGMST("sOK").value }
	mut.button_ok.disabled = true

	-- Events
	mut.button_ok:register(tes3.uiEvent.mouseClick, mut.onOK)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(mut.id_menu)
end

----Events----------------------------------------------------------------------------------------------------------
function mut.onOK()
	local menu = tes3ui.findMenu(mut.id_menu)
	local modData = func.getModData(mut.ref)
	if (menu) then
		if mut.swap then
			mut.swapped = tes3.getObject("kl_ability_mutation_" .. modData.mutationSlots[mut.slot])
			tes3.messageBox({ message = "Swap " .. mut.swapped.name .. " for " .. mut.mutation .. "?\nTP Cost: 7",
            buttons = { tes3.findGMST("sYes").value, tes3.findGMST("sNo").value },
            callback = mut.onSwapConfirm })
		else
			func.clMessageBox("" .. mut.ref.object.name .. " developed the " .. mut.mutation .. " Mutation.")
			log:info("" .. mut.ref.object.name .. " aquired Mutation: " .. mut.mutation .. ".")
			if modData.mutationSlots ~= nil then
				if modData.mutationSlots[mut.slot] ~= nil then
					tes3.removeSpell({ reference = mut.ref, spell = "kl_ability_mutation_" .. modData.mutationSlots[1] .. "" })
				end
				modData.mutationSlots[mut.slot] = mut.id
			else
				modData["mutationSlots"] = { mut.id, nil, nil, nil }
			end
			tes3.addSpell({ reference = mut.ref, spell = "kl_ability_mutation_" .. mut.id .. "" })

			menu:destroy()
			tes3ui.leaveMenuMode()
			func.updateIdealSheet(mut.ref)
		end
	end
end

function mut.onSelect(elem, id)
	local menu = tes3ui.findMenu(mut.id_menu)
	if (menu) then

		mut.mutation = elem.text
		mut.id = id

		--States
		for n = 0, mut.total do
			local btn = menu:findChild("kl_mutation_btn_" .. n .. "")
			if btn then
				if btn.widget.state == 4 then
					btn.widget.state = 1
				end
			end
		end

		elem.widget.state = 4

		log:debug("" .. mut.ref.object.name .. " chose to develop the " .. mut.mutation .. " Mutation.")
		mut.button_ok.disabled = false
		menu:updateLayout()
	end
end

function mut.onSwapConfirm(e)
	if e.button == 0 then
		if not func.spendTP(mut.ref, 7) then return end
		local menu = tes3ui.findMenu(mut.id_menu)

		local modData = func.getModData(mut.ref)

		func.clMessageBox("" .. mut.ref.object.name .. " swapped the " .. mut.swapped.name .. " Mutation for the " .. mut.mutation .. " Mutation. Checking Ideal Stats is recommended.")
		log:info("" .. mut.ref.object.name .. " swapped to Mutation: " .. mut.mutation .. ".")
		if modData.mutationSlots ~= nil then
			if modData.mutationSlots[mut.slot] ~= nil then
				tes3.removeSpell({ reference = mut.ref, spell = "kl_ability_mutation_" .. modData.mutationSlots[mut.slot] .. "" })
			end
			modData.mutationSlots[mut.slot] = mut.id
		else
			modData["mutationSlots"] = { mut.id, nil, nil, nil }
		end
		tes3.addSpell({ reference = mut.ref, spell = "kl_ability_mutation_" .. mut.id .. "" })

		menu:destroy()
		tes3ui.leaveMenuMode()
	else
		--Nothing
	end
end






return mut