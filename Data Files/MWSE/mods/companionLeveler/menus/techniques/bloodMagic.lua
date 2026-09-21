local log = mwse.Logger.new()
local config = require("companionLeveler.config")
local tables = require("companionLeveler.tables")
local func = require("companionLeveler.functions.common")


local bmgk = {}


function bmgk.createWindow(ref)
	--Initialize IDs
	bmgk.id_menu = tes3ui.registerID("kl_bmgk_menu")
	bmgk.id_pane = tes3ui.registerID("kl_bmgk_pane")
	bmgk.id_pane2 = tes3ui.registerID("kl_bmgk_pane2")
	bmgk.id_ok = tes3ui.registerID("kl_bmgk_ok")

	log:debug("bmgk menu initialized.")

	local root = require("companionLeveler.menus.techniques.techniques")
	local modData = func.getModData(ref)
	--testing
	--modData.bloodMagicka = modData.level * 20

	bmgk.caster = ref
	bmgk.npc_choices = 0
	bmgk.spell_choices = 0
	bmgk.illusion = ref.mobile:getSkillStatistic(12).current
	bmgk.destruction = ref.mobile:getSkillStatistic(10).current
	bmgk.alteration = ref.mobile:getSkillStatistic(11).current
	bmgk.conjuration = ref.mobile:getSkillStatistic(13).current
	bmgk.mysticism = ref.mobile:getSkillStatistic(14).current
	bmgk.restoration = ref.mobile:getSkillStatistic(15).current

	-- Create Menu
	local menu = tes3ui.createMenu { id = bmgk.id_menu, fixedFrame = true }

	-- Heading Block
	local head_block = menu:createBlock{ id = "kl_header_bmgk" }
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
	title_block:createLabel { text = "Cast which spell?" }

	-- Blood Magicka Bar
	bmgk.mgk_bar = tp_block:createFillBar({ current = modData.bloodMagicka, max = modData.level * 20, id = bmgk.id_mgk_bar })
	func.configureBar(bmgk.mgk_bar, "small", "wine")
	bmgk.mgk_bar.borderLeft = 155

	-- Pane Block
	local pane_block = menu:createBlock { id = "pane_block_bmgk" }
	pane_block.autoWidth = true
	pane_block.autoHeight = true

	-- bmgk Border
	local border = pane_block:createThinBorder { id = "kl_border_bmgk" }
	border.positionX = 4
	border.positionY = -4
	border.width = 267
	border.height = 160
	border.borderAllSides = 4
	border.paddingAllSides = 4

	-- Attribute Border
	local border2 = pane_block:createThinBorder { id = "kl_border2_bmgk" }
	border2.positionX = 202
	border2.positionY = 0
	border2.width = 267
	border2.height = 160
	border2.paddingAllSides = 4
	border2.borderAllSides = 4


	----Populate-----------------------------------------------------------------------------------------------------

	--Panes
	local pane = border:createVerticalScrollPane { id = bmgk.id_pane }
	pane.height = 148
	pane.width = 210
	pane.widget.scrollbarVisible = true

	bmgk.pane2 = border2:createVerticalScrollPane { id = bmgk.id_pane2 }
	bmgk.pane2.height = 148
	bmgk.pane2.width = 210
	bmgk.pane2.widget.scrollbarVisible = true

	--Populate Panes

	--Choices
	for mobileActor in tes3.iterate(tes3.worldController.allMobileActors) do
		if mobileActor.cell == tes3.getPlayerCell() then
			local pos = mobileActor.reference.position
			local dist = pos:distance(tes3.player.position)
			log:debug("" .. mobileActor.reference.object.name .. "'s distance: " .. dist .. "")

			if dist < 700 and mobileActor.reference.object.name ~= "" and mobileActor.reference.object.name ~= "<spawner>" then
				bmgk.npc_choices = bmgk.npc_choices + 1

				local a = bmgk.pane2:createTextSelect { text = "" .. mobileActor.reference.object.name .. "", id = "kl_bmgk_npc_btn_" .. bmgk.npc_choices .. ""}

				a:register("mouseClick", function(e) bmgk.onSelectTarget(a, mobileActor) end)
			end
		end
	end

	--Spell Choices
	local choices = {}
	local reqs = {}

	if bmgk.illusion >= 25 then
		table.insert(choices, "kl_bm_1")
		table.insert(reqs, 25)
		if bmgk.illusion >= 50 then
			table.insert(choices, "kl_bm_2")
			table.insert(reqs, 40)
			if bmgk.illusion >= 75 then
				table.insert(choices, "kl_bm_3")
				table.insert(reqs, 70)
				if bmgk.illusion >= 100 then
					table.insert(choices, "kl_bm_4")
					table.insert(reqs, 100)
				end
			end
		end
	end

	if bmgk.mysticism >= 25 then
		table.insert(choices, "kl_bm_5")
		table.insert(reqs, 30)
		if bmgk.mysticism >= 50 then
			table.insert(choices, "kl_bm_6")
			table.insert(reqs, 50)
			if bmgk.mysticism >= 75 then
				table.insert(choices, "kl_bm_7")
				table.insert(reqs, 100)
				if bmgk.mysticism >= 100 then
					table.insert(choices, "kl_bm_8")
					table.insert(reqs, 225)
				end
			end
		end
	end

	if bmgk.destruction >= 25 then
		table.insert(choices, "kl_bm_9")
		table.insert(reqs, 35)
		if bmgk.destruction >= 50 then
			table.insert(choices, "kl_bm_10")
			table.insert(reqs, 75)
			if bmgk.destruction >= 75 then
				table.insert(choices, "kl_bm_11")
				table.insert(reqs, 90)
				if bmgk.destruction >= 100 then
					table.insert(choices, "kl_bm_12")
					table.insert(reqs, 200)
				end
			end
		end
	end

	if bmgk.conjuration >= 25 then
		table.insert(choices, "kl_bm_13")
		table.insert(reqs, 20)
		if bmgk.conjuration >= 50 then
			table.insert(choices, "kl_bm_14")
			table.insert(reqs, 60)
			if bmgk.conjuration >= 75 then
				table.insert(choices, "kl_bm_15")
				table.insert(reqs, 120)
				if bmgk.conjuration >= 100 then
					table.insert(choices, "kl_bm_16")
					table.insert(reqs, 250)
				end
			end
		end
	end

	if bmgk.alteration >= 25 then
		table.insert(choices, "kl_bm_17")
		table.insert(reqs, 25)
		if bmgk.alteration >= 50 then
			table.insert(choices, "kl_bm_18")
			table.insert(reqs, 45)
			if bmgk.alteration >= 75 then
				table.insert(choices, "kl_bm_19")
				table.insert(reqs, 70)
				if bmgk.alteration >= 100 then
					table.insert(choices, "kl_bm_20")
					table.insert(reqs, 125)
				end
			end
		end
	end

	if bmgk.restoration >= 25 then
		table.insert(choices, "kl_bm_21")
		table.insert(reqs, 30)
		if bmgk.restoration >= 50 then
			table.insert(choices, "kl_bm_22")
			table.insert(reqs, 40)
			if bmgk.restoration >= 75 then
				table.insert(choices, "kl_bm_23")
				table.insert(reqs, 70)
				if bmgk.restoration >= 100 then
					table.insert(choices, "kl_bm_24")
					table.insert(reqs, 150)
				end
			end
		end
	end

	local spellList = choices
	for i = 1, #spellList do
		bmgk.spell_choices = bmgk.spell_choices + 1
		local spell = tes3.getObject( "" .. spellList[i] )
		local a = pane:createTextSelect { text = "" .. spell.name .. "",  id = "kl_bmgk_spell_btn_" .. bmgk.spell_choices .. ""}
		a:register("mouseClick", function(e) bmgk.onSelectSpell(a, spell.id, reqs[i]) end)
		a:register("help", function(e)
            local tooltip = tes3ui.createTooltipMenu { spell = spell }

            local contentElement = tooltip:getContentElement()
            contentElement.paddingAllSides = 12
            contentElement.childAlignX = 0.5
            contentElement.childAlignY = 0.5
        end)
	end

	--Text Block
	local text_block = menu:createBlock { id = "text_block_bmgk" }
	text_block.autoWidth = true
	text_block.autoHeight = true
	text_block.borderAllSides = 10
	text_block.flowDirection = "top_to_bottom"

	--Cast Chance
	local chance_title = text_block:createLabel({ text = "Cast Chance:" })
	chance_title.color = tables.colors["white"]
	bmgk.cast_chance = text_block:createLabel { text = "100%", id = "kl_bmgk_bmgk_chance" }

	--Magicka Cost
	local cost_title = text_block:createLabel({ text = "Blood Magicka Cost:" })
	cost_title.color = tables.colors["white"]
	bmgk.mgk_cost = text_block:createLabel { text = "", id = "kl_bmgk_mgk_cost" }


	----Bottom Button Block------------------------------------------------------------------------------------------
	local button_block = menu:createBlock {}
	button_block.widthProportional = 1.0
	button_block.autoHeight = true
	button_block.childAlignX = 0.5
	button_block.borderTop = 10

	local button_ok = button_block:createButton { text = tes3.findGMST("sOK").value }
	button_ok.widget.state = 2
	button_ok.disabled = true
	bmgk.ok = button_ok
	local button_cancel = button_block:createButton { text = tes3.findGMST("sCancel").value }

	--Events
	button_ok:register("mouseClick", function()
		if modData.bloodMagicka < bmgk.cost then
			func.clMessageBox("Not enough Blood Magicka!")
			return
		end

		--Reset
		menu:destroy()
		tes3ui.leaveMenuMode()

		--Cast Spell
		tes3.cast({ reference = bmgk.caster, target = bmgk.target, spell = bmgk.spell, instant = true, alwaysSucceeds = true })

		--Spend blood mgk
		modData.bloodMagicka = modData.bloodMagicka - bmgk.cost

		if bmgk.target ~= tes3.mobilePlayer and bmgk.target ~= bmgk.caster.mobile then
			if bmgk.isSpellHostile(tes3.getObject(bmgk.spell)) then
				local isHostile
				for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
					if actor.reference == bmgk.target then
						isHostile = true
					end
				end
				if not isHostile then
					tes3.triggerCrime{
						victim = bmgk.target,
						type = tes3.crimeType.attack
					}
				end
				bmgk.target:startCombat(bmgk.caster.mobile)
			end
		end
	end)
	button_cancel:register("mouseClick", function() menu:destroy() root.createWindow(ref) end)

	-- Final setup
	menu:updateLayout()
	tes3ui.enterMenuMode(bmgk.id_menu)
end

function bmgk.onSelectTarget(elem, mobileActor)
	local menu = tes3ui.findMenu(bmgk.id_menu)

	if menu then
		for i = 1, bmgk.npc_choices do
			local btn = menu:findChild("kl_bmgk_npc_btn_" .. i .. "")
			if btn then
				btn.widget.state = 1
			end
		end

		elem.widget.state = 4

		bmgk.target = mobileActor

		if bmgk.target ~= nil and bmgk.spell ~= nil then
			bmgk.ok.widget.state = 1
			bmgk.ok.disabled = false
		end

		menu:updateLayout()
	end
end

function bmgk.onSelectSpell(elem, id, req)
	local menu = tes3ui.findMenu(bmgk.id_menu)

	if menu then
		for i = 1, bmgk.spell_choices do
			local btn = menu:findChild("kl_bmgk_spell_btn_" .. i .. "")
			btn.widget.state = 1
		end

		elem.widget.state = 4
		bmgk.spell = id

		local spell = tes3.getObject(id)

		bmgk.mgk_cost.text = "" .. req .. ""
		bmgk.cost = req


		if bmgk.target ~= nil and bmgk.spell ~= nil then
			bmgk.ok.widget.state = 1
			bmgk.ok.disabled = false
		end

		menu:updateLayout()
	end
end

--- @param magicSource tes3spell|tes3enchantment|tes3alchemy
function bmgk.isSpellHostile(magicSource)
	log:debug("Hostile spell check triggered.")
    for _, effect in ipairs(magicSource.effects) do
        if (effect.object.isHarmful) then
            -- If one of the spell's effects is harmful, then
            -- `true` is returned and function ends here.
			log:debug("Spell is hostile.")
            return true
        end
    end
    -- If no harmful effect was found then return `false`.
	log:debug("Spell is not hostile.")
    return false
end

return bmgk