local tables = require("companionLeveler.tables")
local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")
local config = require("companionLeveler.config")



local line = {}


function line.pickBloodline(ref, aID)
	--Initialize IDs
	line.id_menu = tes3ui.registerID("kl_line_menu")
	line.id_pane = tes3ui.registerID("kl_line_pane")
	line.id_ok = tes3ui.registerID("kl_line_ok")
	line.id_growth = tes3ui.registerID("kl_line_growth_btn")
	line.id_image = tes3ui.registerID("kl_line_image")

	log:debug("Bloodline menu initialized.")

	if (ref) then
		line.ref = ref
		line.aID = aID
	end

	line.total = 0

	if (tes3ui.findMenu(line.id_menu) ~= nil) then
		return
	end
	log:debug("Bloodline menu triggered.")

	-- Create window and frame
	local menu = tes3ui.createMenu { id = line.id_menu, fixedFrame = true }
	menu.alpha = 1.0

	-- Create layout
	local name = ref.object.name
	--local modData = func.getModData(ref)

	local input_label = menu:createLabel { text = "Select " .. name .. "'s Bloodline:" }
	input_label.borderBottom = 12
	if aID == 156 then
		input_label.text = "Choose a bloodline to sire " .. ref.object.name .. "."
	end

	--Pane and Image Block
	local pane_block = menu:createBlock { id = "pane_block_line" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	local border = pane_block:createThinBorder { id = "kl_border_line" }
	border.width = 400
	border.height = 225

	--Pane
	local pane = border:createVerticalScrollPane { id = line.id_pane }
	pane.height = 225
	pane.width = 400
	pane.widget.scrollbarVisible = true

	--Populate Pane
	if aID == 156 then
		for i = 1, #tables.bloodlines do
			line.total = line.total + 1
			local a = pane:createTextSelect({ text = "" .. tables.bloodlines[i] .. "", id = "kl_line_btn_" .. line.total .. "" })
			a:register("mouseClick", function(e) line.onSelect(a, i)end)
			func.bloodlineTooltip(a, i)
			if config.abilityColors == true then
				a.widget.idle = tables.colors["white"]
				local t = tables.bloodlineTypes

				if string.match(t[i], "TRIGGER") then
					a.widget.idle = tables.colors["green"]
				elseif string.match(t[i], "COMBAT") then
					a.widget.idle = tables.colors["red"]
				elseif string.match(t[i], "TECHNIQUE") then
					a.widget.idle = tables.colors["dark_purple"]
				elseif string.match(t[i], "AURA") then
					a.widget.idle = tables.colors["ui_blue"]
				elseif string.startswith(t[i], "[SPECIAL") then
					a.widget.idle = tables.colors["pink"]
				end
			end
		end
	end

	--Sort Spells
	pane:getContentElement():sortChildren(function(c, d)
		local cText
		local dText

		for int = 1, line.total do
			cText = ""
			local cChild = c:findChild("kl_line_btn_" .. int .. "")
			if cChild ~= nil then cText = cChild.text break end
		end
		for num = 1, line.total do
			dText = ""
			local dChild = d:findChild("kl_line_btn_" .. num .. "")
			if dChild ~= nil then dText = dChild.text break end
		end

		return cText < dText
	end)

	--Text Blocks
	local text_block = menu:createBlock { id = "text_block" }
	text_block.width = 400
	text_block.height = 360
	text_block.flowDirection = "top_to_bottom"
	text_block.borderTop = 16

	local msg_block = text_block:createBlock {}
	msg_block.width = 400
	msg_block.height = 100
	msg_block.flowDirection = "top_to_bottom"

	local gift_block = text_block:createBlock {}
	gift_block.width = 400
	gift_block.height = 120
	gift_block.flowDirection = "top_to_bottom"
	gift_block.borderTop = 10
	gift_block.borderBottom = 10

	local duty_block = text_block:createBlock {}
	duty_block.width = 400
	duty_block.height = 120
	duty_block.flowDirection = "top_to_bottom"

	--Message
	local msg = msg_block:createLabel({ text = "", id = "kl_msg" })
	msg.wrapText = true
	msg.justifyText = tes3.justifyText.center

	--Region
	local region = gift_block:createLabel({ text = "Region:", id = "kl_reg_label" })
	region.color = tables.colors["white"]

	local region2 = gift_block:createLabel({ text = "", id = "kl_reg" })
	region2.wrapText = true
	region2.borderLeft = 2
	region2.borderBottom = 10

	--Gifts
	local gift = gift_block:createLabel({ text = "Bloodline Gifts:", id = "kl_gift_label" })
	gift.color = tables.colors["white"]

	local gift2 = gift_block:createLabel({ text = "", id = "kl_gift" })
	gift2.wrapText = true
	gift2.borderLeft = 2
	--gift2.borderBottom = 10

	--Feeding
	local gift3 = duty_block:createLabel({ text = "Feeding Method:", id = "kl_feed_label" })
	gift3.color = tables.colors["white"]

	local gift4 = duty_block:createLabel({ text = "", id = "kl_feed" })
	gift4.wrapText = true
	gift4.borderLeft = 2
	gift4.borderBottom = 10

	--Sunlight
	local duty = duty_block:createLabel({ text = "Reaction to Sunlight:", id = "kl_sun_label" })
	duty.color = tables.colors["white"]

	local duty2 = duty_block:createLabel({ text = "", id = "kl_sun" })
	duty2.wrapText = true
	duty2.borderLeft = 2


	--Button Block
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0 -- width is 100% parent width
	button_block.autoHeight = true
	button_block.childAlignX = 0.5
	button_block.borderTop = 18

	line.button_ok = button_block:createButton { id = line.id_ok, text = tes3.findGMST("sOK").value }
	line.button_ok.disabled = true

	-- Events
	line.button_ok:register(tes3.uiEvent.mouseClick, line.onOK)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(line.id_menu)
end

----Events----------------------------------------------------------------------------------------------------------
function line.onOK()
	local menu = tes3ui.findMenu(line.id_menu)
	local modData = func.getModData(line.ref)
	if (menu) then
		if line.aID == 156 then
			--Sanguine Aspirant
			func.clMessageBox("" .. line.ref.object.name .. " entered the service of " .. line.bloodline .. ".")
			log:info("" .. line.ref.object.name .. " entered the service of " .. line.bloodline .. ".")
			modData["bloodline"] = line.id
			modData["fed"] = true
			modData["fedHours"] = 0
			tes3.addSpell({ reference = line.ref, spell = "kl_ability_bloodline_" .. line.id .. "" })

			if line.id == 1 then
				modData["bloodMagicka"] = 0
			end

			if line.id == 3 then
				modData["bloodFrenzy"] = 0
			end

			if line.id == 4  or line.id == 5 then
				modData["stage"] = 1
			end
		end
		menu:destroy()
		tes3ui.leaveMenuMode()
		func.updateIdealSheet(line.ref)
	end
end

function line.onSelect(elem, id)
	local menu = tes3ui.findMenu(line.id_menu)
	if (menu) then

		line.bloodline = elem.text
		line.id = id

		--States
		for n = 0, line.total do
			local btn = menu:findChild("kl_line_btn_" .. n .. "")
			if btn then
				if btn.widget.state == 4 then
					btn.widget.state = 1
				end
			end
		end

		elem.widget.state = 4

		--Change Text
		local msg = menu:findChild("kl_msg")
		msg.text = "" .. tables.bloodlineMessages[id] .. ""

		local region = menu:findChild("kl_reg")
		region.text = tables.bloodlineRegion[id]

		local gift = menu:findChild("kl_gift")
		gift.text = tables.bloodlineGifts[id]

		local duty = menu:findChild("kl_sun")
		duty.text = tables.bloodlineSunlight[id]

		local gift = menu:findChild("kl_feed")
		gift.text = tables.bloodlineFeeding[id]

		log:debug("" .. line.ref.object.name .. " chose to serve " .. line.bloodline .. ".")
		line.button_ok.disabled = false
		menu:updateLayout()
	end
end






return line