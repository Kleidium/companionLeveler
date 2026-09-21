local config = require("companionLeveler.config")
local log = mwse.Logger.new()
local func = require("companionLeveler.functions.common")
local typeChange = require("companionLeveler.menus.typeChange")
local classChange = require("companionLeveler.menus.classChange")
local buildChange = require("companionLeveler.menus.buildChange")
local sheet = require("companionLeveler.menus.sheet")
local tech = require("companionLeveler.menus.techniques.techniques")
local cast = require("companionLeveler.menus.cast")

local root = {}

function root.createWindow(reference)
    root.id_menu = tes3ui.registerID("kl_root_menu")
    root.id_label = tes3ui.registerID("kl_root_label")
    root.id_label2 = tes3ui.registerID("kl_root_label2")
    root.id_label3 = tes3ui.registerID("kl_root_label3")
    root.id_label4 = tes3ui.registerID("kl_root_label4")
    root.id_sheet = tes3ui.registerID("kl_root_sheet_btn")
    root.id_change = tes3ui.registerID("kl_root_change_btn")
    root.id_build = tes3ui.registerID("kl_root_build_btn")
    root.id_growth = tes3ui.registerID("kl_root_growth_btn")
    root.id_cast = tes3ui.registerID("kl_root_cast_btn")
    root.id_tech = tes3ui.registerID("kl_root_tech_btn")
    root.id_item = tes3ui.registerID("kl_root_item_btn")
    root.id_cancel = tes3ui.registerID("kl_root_cancel_btn")
    root.id_exp = tes3ui.registerID("kl_root_exp_bar")

    log:trace("Root menu initialized.")

    root.reference = reference


    --Add Abilities/Constant Effect Equipment
    log:trace("Ability Check triggered on " .. reference.object.name .. ". (Key Press)")
    if reference.object.objectType == tes3.objectType.creature then
		func.addAbilitiesCre(reference)
	else
		func.addAbilitiesNPC(reference)
	end

	tes3.applyConstantEffectEquipment({ reference = reference, activate = true })

    --Check for version update
    func.updateModData(reference)

    root.buildTable = func.buildTable()

    for i = 1, #root.buildTable do
        if root.buildTable[i] == root.reference then
            root.slot = i
            break
        end
    end


    local menu = tes3ui.createMenu { id = root.id_menu, fixedFrame = true }
    menu.minWidth = 240
    local modData = func.getModData(reference)
    local class

    if reference.object.objectType ~= tes3.objectType.creature and modData.metamorph == false then
        class = "Class: " .. tes3.findClass(modData.class).name .. ""
    else
        class = "Type: " .. modData.type .. ""
    end

    --Title
    local label = menu:createLabel { text = "Companion Leveler", id = root.id_label }
    label.wrapText = true
    label.justifyText = "center"
    local divider = menu:createDivider{}
    divider.borderBottom = 28

    --Equipped
    local stack = tes3.getEquippedItem({ actor = reference, objectType = tes3.objectType.weapon })
    local path
    if stack ~= nil then
        path = "Icons\\".. stack.object.icon
    else
        path = "Icons\\k\\stealth_handtohand.dds"
    end
    local wepIcon = menu:createImage { path = path }
    wepIcon.justifyText = "center"
    wepIcon.borderBottom = 4

    if stack ~= nil then
        wepIcon:register("help", function(e)
            local tooltip = tes3ui.createTooltipMenu { object = stack.object, itemData = stack.itemData }

            local contentElement = tooltip:getContentElement()
            contentElement.paddingAllSides = 12
            contentElement.childAlignX = 0.5
            contentElement.childAlignY = 0.5
        end)
    end

    if stack == nil and reference.object.objectType == tes3.objectType.creature then
        wepIcon:destroy()
    end

    --Labels
    local label2 = menu:createLabel { text = "" .. reference.object.name .. "", id = root.id_label2 }
    label2.wrapText = true
    label2.justifyText = "center"
    local label3 = menu:createLabel { text = "" .. class .. "", id = root.id_label3 }
    label3.wrapText = true
    label3.justifyText = "center"
    local label4 = menu:createLabel { text = "Level: " .. modData.level .. "", id = root.id_label4 }
    label4.wrapText = true
    label4.justifyText = "center"
    label4.borderBottom = 28

    if #root.buildTable > 1 then
        --Multiparty Switches
        label4.borderBottom = 0

        local switchBlock = menu:createBlock { id = "kl_switch_block" }
        switchBlock.flowDirection = "left_to_right"
        switchBlock.autoHeight = true
        switchBlock.autoWidth = true
        switchBlock.widthProportional = 1.0
        switchBlock.childAlignX = 0.5
        switchBlock.borderTop = 4
        switchBlock.borderBottom = 28

        local button_prev = switchBlock:createButton { id = root.id_prev, text = "<" }
        local button_next = switchBlock:createButton { id = root.id_prev, text = ">" }
        button_prev:register("mouseClick", function() menu:destroy() root.slot = root.slot - 1 if root.slot < 1 then root.slot = #root.buildTable end root.createWindow(root.buildTable[root.slot]) end)
        button_next:register("mouseClick", function() menu:destroy() root.slot = root.slot + 1 if root.slot > #root.buildTable then root.slot = 1 end root.createWindow(root.buildTable[root.slot]) end)
    end


    --Button Block
    local root_block = menu:createBlock { id = "kl_root_block" }
    root_block.flowDirection = "top_to_bottom"
    root_block.autoHeight = true
    root_block.autoWidth = true
    root_block.paddingLeft = 10
    root_block.paddingRight = 10
    root_block.widthProportional = 1.0
	root_block.autoHeight = true
	root_block.childAlignX = 0.5


    -- Buttons
    local button_sheet = root_block:createButton { id = root.id_sheet, text = "Character Sheet" }
    local button_change = root_block:createButton { id = root.id_change, text = "Change Class/Type" }
    local button_tech = root_block:createButton { id = root.id_tech, text = "Use Techniques" }
    local button_cast = root_block:createButton { id = root.id_cast, text = "Cast Spells" }
    local button_item = root_block:createButton { id = root.id_item, text = "Use Items" }
    local button_trade = root_block:createButton { id = root.id_trade, text = "Companion Share"}
    if config.buildMode == true then
        local button_build = root_block:createButton { id = root.id_build, text = "Change Build" }
        button_build:register("mouseClick", function() menu:destroy() buildChange.buildChange(reference) end)
    end
    local button_cancel = root_block:createButton { id = root.id_cancel, text = tes3.findGMST("sCancel").value }

    --EXP Bar
    if config.expMode == true then
        func.calcEXP(reference)
        local exp = root_block:createFillBar({ current = modData.lvl_progress,
            max = modData.lvl_req,
            id = root.id_exp })
        func.configureBar(exp, "standard", "gold")
        exp.height = 21
        exp.borderTop = 10
        exp.borderBottom = 6

        func.clTooltip(exp, "exp")
    end

    -- Events
    button_sheet:register("mouseClick", function() menu:destroy() sheet.createWindow(reference) end)

    if reference.object.objectType == tes3.objectType.creature or modData.metamorph == true then
        button_change:register("mouseClick", function() menu:destroy() typeChange.typeChange(reference) end)
    else
        button_change:register("mouseClick", function() menu:destroy() classChange.classChange(reference) end)
    end

    button_trade:register("mouseClick", function()
        menu:destroy()
        tes3.showContentsMenu({ reference = reference })
        timer.delayOneFrame(function() reference.object:reevaluateEquipment() end)

        --Encumbrance
        local contentsMenu = tes3ui.findMenu("MenuContents")
        local buttons = contentsMenu:findChild("Buttons")
        local lameBar = contentsMenu:findChild("MenuContents_EncumbranceBar")
        local bar = buttons:createFillBar({ current = 0, max = reference.mobile.encumbrance.base, id = "kl_share_encumbrance_bar" })
        buttons:reorderChildren(0, -1, 1)
        if lameBar then
            lameBar.visible = false
        end
        bar.width = 218
        bar.height = 24
        bar.borderLeft = 4
        bar.borderTop = 4
        bar.widget.fillColor = { 0.21, 0.27, 0.62 }
        root.updateEncumbrance(reference)
        contentsMenu:updateLayout()

        contentsMenu:registerBefore("update", function() root.updateEncumbrance(reference) end)

    end)
    button_tech:register("mouseClick", function() menu:destroy() tech.createWindow(reference) end)
    button_cast:register("mouseClick", function() menu:destroy() cast.createWindow(reference) end)
    button_item:register("mouseClick", function() root.onItem() end)
    button_cancel:register("mouseClick", function() tes3ui.leaveMenuMode() menu:destroy() end)

    --Distance Check
    local pos = reference.position
	local dist = pos:distance(tes3.player.position)
    if dist > 825 then
        button_item.disabled = true
        button_item.widget.state = 2
        button_trade.disabled = true
        button_trade.widget.state = 2

        button_item:register("help", function(e)
            local tooltip = tes3ui.createTooltipMenu()

            local contentElement = tooltip:getContentElement()
            contentElement.flowDirection = tes3.flowDirection.leftToRight
            contentElement.paddingAllSides = 10

            local tLabel = tooltip:createLabel { text = "Too Far!" }
        end)
        button_trade:register("help", function(e)
            local tooltip = tes3ui.createTooltipMenu()

            local contentElement = tooltip:getContentElement()
            contentElement.flowDirection = tes3.flowDirection.leftToRight
            contentElement.paddingAllSides = 10

            local tLabel = tooltip:createLabel { text = "Too Far!" }
        end)
    end

    -- Final setup
    menu:updateLayout()
    tes3ui.enterMenuMode(root.id_menu)
end

function root.onItem()
	tes3.messageBox({ message = "From whose inventory?", buttons = { tes3.player.object.name, root.reference.object.name,  tes3.findGMST("sCancel").value }, callback = root.useItem })
end

function root.useItem(ev)
    if ev.button == 2 then return end

    local user = tes3.player
    if ev.button == 1 then
        user = root.reference
    end

    --Use Items--
    tes3ui.showInventorySelectMenu({
        reference = user,
        title = "Choose an item for " .. root.reference.object.name .. " to use.\nUsed items will not appear in \"Active Effects\".",
        filter = function(e)
            if e.item.objectType == tes3.objectType.alchemy or (e.item.enchantment and (e.item.enchantment.castType == 0 or e.item.enchantment.castType == 2)) then
                return true
            else
                return false
            end
        end,
        callback =
        function(e)
            if not e.item then return end

            if e.item.objectType == tes3.objectType.alchemy then
                --Potion--

                --Blood Tincture
                if string.match(e.item.id, "kl_potion_bTincture") then
                    if func.checkModData(root.reference) then
                        local modData = func.getModData(root.reference)
                        if modData.bloodline ~= nil and modData.bloodline == 6 then
                            modData.fed = true
                            modData.fedHours = 0
                            func.clMessageBox("" .. e.item.name .. " satisfies the hunger of " .. root.reference.object.name .. ".")
                        end
                    end
                end

                tes3.applyMagicSource({ reference = root.reference, source = e.item })
                tes3.removeItem({ reference = user, item = e.item })
            elseif e.item.enchantment.castType == 2 then
                --On Use Enchantment
                local cost = tes3.calculateChargeUse({ mobile = root.reference.mobile, enchantment = e.item.enchantment })
                if e.itemData.charge >= cost then
                    tes3.applyMagicSource({ reference = root.reference, effects = e.item.enchantment.effects, name = e.item.name })
                    e.itemData.charge = e.itemData.charge - cost
                    --Play Correct Sound
                    func.simulateSpellHit(root.reference, e.item.enchantment.effects[1])
                else
                    func.clMessageBox("" .. tes3.findGMST(tes3.gmst.sMagicInsufficientCharge).value .. "")
                    --Play Correct Sound
                    func.simulateSpellHit(root.reference, e.item.enchantment.effects[1], true)
                end
            elseif e.item.enchantment.castType == 0 then
                --Scroll
                tes3.applyMagicSource({ reference = root.reference, effects = e.item.enchantment.effects, name = e.item.name })
                tes3.removeItem({ reference = user, item = e.item })
                --Play Correct Sound
                func.simulateSpellHit(root.reference, e.item.enchantment.effects[1])
            end
        end
    })
end

function root.updateEncumbrance(ref)
    --Companion
    local menu = tes3ui.findMenu("MenuContents")
    if (menu == nil) then return end

    local bar = menu:findChild("kl_share_encumbrance_bar")
    if not bar then return end

    local burden = tes3.getEffectMagnitude{reference = ref.mobile, effect = tes3.effect.burden}
    local feather = tes3.getEffectMagnitude{reference = ref.mobile, effect = tes3.effect.feather}
    local weight = ref.object.inventory:calculateWeight() + burden - feather

    bar.widget.current = weight

    --Player
    local menu2 = tes3ui.findMenu("MenuInventory")
    if menu2 == nil then return end

    local bar2 = menu2:findChild("MenuInventory_Weightbar")
    if not bar then return end

    local burden2 = tes3.getEffectMagnitude{reference = tes3.mobilePlayer, effect = tes3.effect.burden}
    local feather2 = tes3.getEffectMagnitude{reference = tes3.mobilePlayer, effect = tes3.effect.feather}
    local weight2 = tes3.player.object.inventory:calculateWeight() + burden2 - feather2

    bar2.widget.current = weight2
end


return root