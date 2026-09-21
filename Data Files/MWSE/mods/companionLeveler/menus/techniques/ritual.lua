local func = require("companionLeveler.functions.common")
local tables = require("companionLeveler.tables")

local ritual = {}

-- Helper: Show confirmation dialog
--- @ param msg string confirmation message
--- @ param spellID string spell id
--- @ param time number time spend to cast ritual
--- @ param tp integer amount of tp spent
local function showConfirmation(msg, spellID, time, tp)
    ritual.choice = tes3.getObject(spellID)
    ritual.time = time
    ritual.tp = tp
    tes3.messageBox({
        message = msg,
        buttons = { tes3.findGMST("sYes").value, tes3.findGMST("sNo").value },
        callback = ritual.execution
    })
end

function ritual.createWindow(ref)
    ritual.id_menu = tes3ui.registerID("kl_ritual_menu")
    ritual.id_label = tes3ui.registerID("kl_ritual_label")
    ritual.id_cancel = tes3ui.registerID("kl_ritual_cancel_btn")

    ritual.ref = ref
    ritual.target = ref
    ritual.tech = require("companionLeveler.menus.techniques.techniques")

    local menu = tes3ui.createMenu { id = ritual.id_menu, fixedFrame = true }
    ritual.menu = menu
    local modData = func.getModData(ref)

    -- Labels
    local label = menu:createLabel { text = "Rituals", id = ritual.id_label }
    label.wrapText = true
    label.justifyText = "center"
    menu:createDivider { borderBottom = 28 }

    -- Button Block
    local ritual_block = menu:createBlock { id = "kl_ritual_block" }
    ritual_block.flowDirection = "top_to_bottom"
    ritual_block.autoHeight = true
    ritual_block.autoWidth = true
    ritual_block.paddingLeft = 10
    ritual_block.paddingRight = 10
    ritual_block.widthProportional = 1.0
    ritual_block.childAlignX = 0.5

    -- Ritual Buttons --

	--Creature Rituals
    if ref.object.objectType == tes3.objectType.creature or modData.metamorph == true then
        if modData.guildTraining and (modData.guildTraining[1] == tables.factions[5] or modData.guildTraining[2] == tables.factions[5]) then
            local msg = "Perform the Ritual of Almsivi Intervention?\nTP Cost: 2\nTime Cost: 10 Minutes"
            ritual_block:createButton { text = "Almsivi Intervention" }
                :register("mouseClick", function() showConfirmation(msg, "almsivi intervention", (1 / 6), 2) end)
        end
        if modData.abilities[85] then
            local msg = ("Perform the Cure Common Disease Ritual on %s?\nTP Cost: 2\nTime Cost: 5 Minutes"):format(ref.object.name)
            ritual_block:createButton { text = "Cure Common Disease" }
                :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "cure common disease", (1 / 12), 2) end)
        end
        if modData.abilities[87] then
            local msg = ("Perform the Cure Blight Disease Ritual on %s?\nTP Cost: 2\nTime Cost: 10 Minutes"):format(ref.object.name)
            ritual_block:createButton { text = "Cure Blight Disease" }
                :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "cure blight disease", (1 / 6), 2) end)
        end
        if modData.abilities[89] then
            local msg = ("Perform the Ritual of Telekinesis on %s?\nTP Cost: 2\nTime Cost: 5 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Telekinesis" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg, "kl_ritual_telekinesis", (1 / 12), 2) end)
        end
        if modData.abilities[91] then
            local msg = ("Perform the Ritual of Levitation on %s?\nTP Cost: 2\nTime Cost: 5 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Levitation" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg, "levitate", (1 / 12), 2) end)
        end
        if modData.abilities[92] then
            local msg = ("Perform the Ritual of Dispel on %s?\nTP Cost: 2\nTime Cost: 5 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Dispel" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg, "dispel", (1 / 12), 2) end)
        end
        if modData.abilities[95] then
            local msg = ("Perform the Second Barrier Ritual on %s?\nTP Cost: 2\nTime Cost: 5 Minutes"):format(ref.object.name)
            ritual_block:createButton { text = "Second Barrier" }
                :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "second barrier", (1 / 12), 2) end)
        end
    else
        --NPC Rituals
        if modData.bloodline ~= nil then
            --Vampyrum
            if modData.bloodline == 4 then
                --Sight
                local msg = ("Perform the Ritual of Sight on %s?\nTP Cost: 1\nTime Cost: 1 Minute"):format(tes3.player.object.name)
                ritual_block:createButton { text = "Sight" }
                    :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg, "kl_ritual_sight", (1 / 60), 1) end)
                --Vampire's Seduction
                if modData.stage >=2 then
                    local msg2 = ("Perform the Ritual of Vampire's Seduction on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(tes3.player.object.name)
                    ritual_block:createButton { text = "Vampire's Seduction" }
                        :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg2, "kl_ritual_seduction", (1 / 60), 2) end)
                end
                --Reign of Terror
                if modData.stage >= 3 then
                    local msg2 = ("Perform the Reign of Terror Ritual on %s?\nTP Cost: 3\nTime Cost: 1 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Reign of Terror" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_reign", (1 / 60), 3) end)
                end
                --Embrace of Shadows
                if modData.stage == 4 then
                    local msg2 = ("Perform the Embrace of Shadows Ritual on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Embrace of Shadows" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_embrace", (1 / 60), 2) end)
                end
            end
            --Volkihar
            if modData.bloodline == 5 then
                --Sight
                local msg = ("Perform the Ritual of Sight on %s?\nTP Cost: 1\nTime Cost: 1 Minute"):format(tes3.player.object.name)
                ritual_block:createButton { text = "Sight" }
                    :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg, "kl_ritual_sight", (1 / 60), 1) end)
                --Vampire's Seduction
                if modData.stage >=2 then
                    local msg2 = ("Perform the Ritual of Vampire's Seduction on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(tes3.player.object.name)
                    ritual_block:createButton { text = "Vampire's Seduction" }
                        :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg2, "kl_ritual_seduction", (1 / 60), 2) end)
                end
                --Vampire's Servant
                if modData.stage >= 3 then
                    local msg2 = ("Perform the Ritual of Vampire's Servant on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Vampire's Servant" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_servant", (1 / 60), 2) end)
                end
                --Embrace of Shadows
                if modData.stage == 4 then
                    local msg2 = ("Perform the Embrace of Shadows Ritual on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Embrace of Shadows" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_embrace", (1 / 60), 2) end)
                end
            end
            --Garlythi
            if modData.bloodline == 7 then
                --Solidify Flesh
                local msg = ("Perform the Solidify Flesh Ritual on %s?\nTP Cost: 1\nTime Cost: 1 Minute"):format(ref.object.name)
                ritual_block:createButton { text = "Solidify Flesh" }
                    :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "kl_ritual_solidify", (1 / 60), 1) end)
                
                local alter = ref.mobile:getSkillStatistic(11).current

                if alter >= 50 then
                    local msg2 = ("Perform the Ritual of Daedric Shield on %s?\nTP Cost: 2\nTime Cost: 10 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Daedric Shield" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_daedricShield", (1 / 6), 2) end)
                end

                if alter >= 75 then
                    local msg2 = ("Perform the Ritual of Blood Shield on %s?\nTP Cost: 3\nTime Cost: 30 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Blood Shield" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_bloodShield", (1 / 2), 3) end)
                end

                if alter >= 100 then
                    local msg2 = ("Perform the Ritual of Chaos Shield on %s?\nTP Cost: 5\nTime Cost: 30 Minute"):format(ref.object.name)
                    ritual_block:createButton { text = "Chaos Shield" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_chaosShield", (1 / 2), 5) end)
                end

                if alter >= 150 then
                    local msg2 = ("Perform the Ritual of Dark Shield on %s?\nTP Cost: 8\nTime Cost: 1 Hour"):format(ref.object.name)
                    ritual_block:createButton { text = "Dark Shield" }
                        :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_darkShield", 1, 8) end)
                end
            end

            --Lyrezi
            if modData.bloodline == 10 then
                --Solidify Flesh
                local msg = ("Perform the Ritual of Profane Transparency on %s?\nTP Cost: 1\nTime Cost: 1 Minute"):format(ref.object.name)
                ritual_block:createButton { text = "Profane Transparency" }
                    :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "kl_ritual_transparency", (1 / 60), 1) end)


                local msg2 = ("Perform the Ritual of Shift Light on %s?\nTP Cost: 2\nTime Cost: 1 Minute"):format(ref.object.name)
                ritual_block:createButton { text = "Shift Light" }
                    :register("mouseClick", function() ritual.target = ref showConfirmation(msg2, "kl_ritual_shiftLight", (1 / 60), 2) end)
            end
        end

        --Ritualist
        if modData.abilities[159] then
            local msg = ("Perform the Ritual of Glow on %s?\nTP Cost: 1\nTime Cost: 10 Minutes"):format(ref.object.name)
            ritual_block:createButton { text = "Glow" }
                :register("mouseClick", function() ritual.target = ref showConfirmation(msg, "kl_ritual_glow", (1 / 6), 1) end)

            local msg2 = ("Perform the Ritual of Physick on %s?\nTP Cost: 2\nTime Cost: 10 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Physick" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg2, "kl_ritual_physick", (1 / 6), 2) end)

            local msg3 = ("Perform the Ritual of The Hopper on %s?\nTP Cost: 2\nTime Cost: 15 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Hopper" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg3, "kl_ritual_hopper", (1 / 4), 2) end)

            local msg4 = ("Perform the Ritual of Dual Souls on %s?\nTP Cost: 3\nTime Cost: 30 Minutes"):format(ref.object.name)
            ritual_block:createButton { text = "Dual Souls" }
                :register("mouseClick", function() ritual.target = ref showConfirmation(msg4, "kl_ritual_dual_soul", (1 / 2), 3) end)

            local msg5 = ("Perform the Ritual of Trinkets on %s?\nTP Cost: 3\nTime Cost: 30 Minutes"):format(tes3.player.object.name)
            ritual_block:createButton { text = "Trinkets" }
                :register("mouseClick", function() ritual.target = tes3.mobilePlayer showConfirmation(msg5, "kl_ritual_trinkets", (1 / 2), 3) end)
        end
    end

    -- Cancel Button
    ritual_block:createButton { id = ritual.id_cancel, text = tes3.findGMST("sCancel").value }:register("mouseClick",
	function()
		menu:destroy()
		ritual.tech.createWindow(ref)
    end)

    menu:updateLayout()
    tes3ui.enterMenuMode(ritual.id_menu)
end

function ritual.execution(e)
    if not ritual.menu then return end
    if e.button ~= 0 then return end

    if ritual.choice == "almsivi intervention" then
		--Siwwy wittle teweport wituwals
        if tes3.getWorldController().flagTeleportingDisabled then
            func.clMessageBox(tes3.findGMST("sTeleportDisabled").value)
            return
        end
        if not func.spendTP(ritual.ref, ritual.tp) then return end
        tes3.setGlobal('GameHour', tes3.getGlobal('GameHour') + ritual.time)
        tes3ui.leaveMenuMode()
        ritual.menu:destroy()
        tes3.messageBox("%s performed the Ritual of Almsivi Intervention!", ritual.ref.object.name)
        local almsivi = tes3.findClosestExteriorReferenceOfObject { object = "TempleMarker", position = tes3.getLastExteriorPosition() }
        tes3.positionCell { reference = tes3.player, cell = almsivi.cell, position = almsivi.position, orientation = almsivi.orientation, forceCellChange = true }
        tes3.playSound { sound = "mysticism hit" }
        tes3.createVisualEffect { object = "VFX_MysticismHit", lifespan = 3, reference = ritual.ref }
    else
		--Normal Rituals
        if not func.spendTP(ritual.ref, ritual.tp) then return end
        tes3.setGlobal('GameHour', tes3.getGlobal('GameHour') + ritual.time)
        tes3ui.leaveMenuMode()
        ritual.menu:destroy()
        tes3.messageBox("%s performed the Ritual of %s!", ritual.ref.object.name, ritual.choice.name)
        if ritual.target == tes3.mobilePlayer and ritual.choice.effects[1].rangeType == tes3.effectRange.self then
            --Target Cast on Self
            tes3.cast { reference = ritual.target, target = ritual.target, spell = ritual.choice, instant = true, bypassResistances = true }
        else
            --Caster Cast on Target
            tes3.cast { reference = ritual.ref, target = ritual.target, spell = ritual.choice, instant = true, bypassResistances = true }
        end
    end
end

return ritual