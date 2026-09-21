local config = require("companionLeveler.config")
local tables = require("companionLeveler.tables")
local func = require("companionLeveler.functions.common")
local log = mwse.Logger.new()
local fact = require("companionLeveler.menus.factionList")
local pat = require("companionLeveler.menus.patronList")
local line = require("companionLeveler.menus.bloodlineList")
local guild = require("companionLeveler.menus.guildTrained")
local mut = require("companionLeveler.menus.mutationList")


local this = {}

--
----Helpers-----------------------------------------------------------------------------------------------------------------------
--

--- Helper for applying or removing a party-wide aura spell.
--- @param partyTable table party table
--- @param spellId string the spell id to add/remove
--- @param add boolean true to add, false to remove
--- @param onApply function?function(ref) or nil, called after adding spell
--- @param onRemove function?function(ref) or nil, called after removing spell
function this.updatePartyAura(partyTable, spellId, add, onApply, onRemove)
    for n = 1, #partyTable do
        local ref = partyTable[n]
        local affected = tes3.isAffectedBy({ reference = ref, object = spellId })
        if add then
            if not affected then
                tes3.addSpell({ reference = ref, spell = spellId })
                if onApply then onApply(ref) end
            end
        else
            if affected then
                tes3.removeSpell({ reference = ref, spell = spellId })
                if onRemove then onRemove(ref) end
            end
        end
    end
end


----Creature Abilities------------------------------------------------------------------------------------------------------------
--
function this.creatureAbilities(cType, companionRef)
    local name = companionRef.object.name
    local modData = func.getModData(companionRef)


    if cType == "Normal" then
        if modData.typelevels[1] >= 5 then
            local ability = tables.abList[1]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Normal Type Ability Instinct!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[1] .. ".")
                tes3.playSound({ sound = "alitSCRM" })
                modData.abilities[1] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[1] >= 10 then
            local ability = tables.abList[2]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Normal Type Ability Beast Blood!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[2] .. ".")
                tes3.playSound({ sound = "alitSCRM" })
                modData.abilities[2] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[1] >= 15 then
            local ability = tables.abList[3]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Normal Type Ability Greater Instinct!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[3] .. ".")
                tes3.playSound({ sound = "alitSCRM" })
                modData.abilities[3] = true
                modData.att_gained[8] = modData.att_gained[8] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[1] >= 20 then
            local ability = tables.abList[4]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Normal Type Ability Evolutionary Stamina!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[4] .. ".")
                tes3.playSound({ sound = "alitSCRM" })
                modData.abilities[4] = true
                modData.att_gained[6] = modData.att_gained[6] + 20
                modData.att_gained[5] = modData.att_gained[5] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Daedra" then
        if modData.typelevels[2] >= 5 then
            local ability = tables.abList[5]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Daedra Type Ability Taste of Freedom!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[5] .. ".")
                tes3.playSound({ sound = "dremora scream" })
                modData.abilities[5] = true
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[2] >= 10 then
            local ability = tables.abList[6]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Daedra Type Ability Daedric Skin!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[6] .. ".")
                tes3.playSound({ sound = "dremora scream" })
                modData.abilities[6] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[2] >= 15 then
            local ability = tables.abList[7]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Daedra Type Ability Sinful Freedom!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[7] .. ".")
                tes3.playSound({ sound = "dremora scream" })
                modData.abilities[7] = true
                modData.tp_max = modData.tp_max + 2
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[2] >= 20 then
            local ability = tables.abList[8]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Daedra Type Ability Dark Barrier!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[8] .. ".")
                tes3.playSound({ sound = "dremora scream" })
                modData.abilities[8] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Undead" then
        if modData.typelevels[3] >= 5 then
            local ability = tables.abList[9]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Undead Type Ability Numbed Flesh!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[9] .. ".")
                tes3.playSound({ sound = "skeleton moan" })
                modData.abilities[9] = true
                modData.hth_gained = modData.hth_gained + 15
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[3] >= 10 then
            local ability = tables.abList[10]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Undead Type Ability Ancestral Memory!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[10] .. ".")
                tes3.playSound({ sound = "skeleton moan" })
                modData.abilities[10] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[2] = modData.att_gained[2] + 10
                modData.att_gained[3] = modData.att_gained[3] + 10
                modData.att_gained[7] = modData.att_gained[7] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[3] >= 15 then
            local ability = tables.abList[11]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Undead Type Ability Still Breath!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[11] .. ".")
                tes3.playSound({ sound = "skeleton moan" })
                modData.abilities[11] = true
                modData.att_gained[6] = modData.att_gained[6] + 15
                modData.fat_gained = modData.fat_gained + 25
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[3] >= 20 then
            local ability = tables.abList[12]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Undead Type Ability Total Decay!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[12] .. ".")
                tes3.playSound({ sound = "skeleton moan" })
                modData.abilities[12] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Humanoid" then
        if modData.typelevels[4] >= 5 then
            local ability = tables.abList[13]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Humanoid Type Ability Strange Dream!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[13] .. ".")
                tes3.playSound({ sound = "ash vampire moan" })
                modData.abilities[13] = true
                modData.mgk_gained = modData.mgk_gained + 20
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[4] >= 10 then
            local ability = tables.abList[14]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Humanoid Type Ability Abnormal Growth!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[14] .. ".")
                tes3.playSound({ sound = "ash vampire moan" })
                modData.abilities[14] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[4] >= 15 then
            local ability = tables.abList[15]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Humanoid Type Ability Painfully Awake!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[15] .. ".")
                tes3.playSound({ sound = "ash vampire moan" })
                modData.abilities[15] = true
                modData.mgk_gained = (companionRef.mobile.magicka.base - companionRef.baseObject.magicka)
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[4] >= 20 then
            local ability = tables.abList[16]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Humanoid Type Ability Dream Mastery!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[16] .. ".")
                tes3.playSound({ sound = "ash vampire moan" })
                modData.abilities[16] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Centurion" then
        if modData.typelevels[5] >= 5 then
            local ability = tables.abList[17]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Centurion Type Ability Precision!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[17] .. ".")
                tes3.playSound({ sound = "cent sphere scream" })
                modData.abilities[17] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[5] >= 10 then
            local ability = tables.abList[18]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Centurion Type Ability Insulated Exoskeleton!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[18] .. ".")
                tes3.playSound({ sound = "cent sphere scream" })
                modData.abilities[18] = true
                modData.hth_gained = modData.hth_gained + 25
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[5] >= 15 then
            local ability = tables.abList[19]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Centurion Type Ability Augmented Grip!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[19] .. ".")
                tes3.playSound({ sound = "cent sphere scream" })
                modData.abilities[19] = true
                modData.att_gained[1] = modData.att_gained[1] + 20
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[5] >= 20 then
            local ability = tables.abList[20]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Centurion Type Ability Dwemer Refractors!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[20] .. ".")
                tes3.playSound({ sound = "cent sphere scream" })
                modData.abilities[20] = true
                modData.att_gained[6] = modData.att_gained[6] + 25
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Spriggan" then
        if modData.typelevels[6] >= 5 then
            local ability = tables.abList[21]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spriggan Type Ability Sap Secretion!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[21] .. ".")
                tes3.playSound({ sound = "sprigganmagic" })
                modData.abilities[21] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[6] >= 10 then
            local ability = tables.abList[22]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spriggan Type Ability Jade Wind!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[22] .. ".")
                tes3.playSound({ sound = "sprigganmagic" })
                modData.abilities[22] = true
                modData.att_gained[8] = modData.att_gained[8] + 15
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[6] >= 15 then
            local ability = tables.abList[23]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spriggan Type Ability Synthesis!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[23] .. ".")
                tes3.playSound({ sound = "sprigganmagic" })
                modData.abilities[23] = true
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[6] >= 20 then
            local ability = tables.abList[24]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spriggan Type Ability Overgrowth!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[24] .. ".")
                tes3.playSound({ sound = "sprigganmagic" })
                modData.abilities[24] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Goblin" then
        if modData.typelevels[7] >= 3 then
            local ability = tables.abList[25]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Quickness!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[25] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[25] = true
                modData.att_gained[5] = modData.att_gained[5] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 5 then
            local ability = tables.abList[26]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Springstep!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[26] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[26] = true
                modData.fat_gained = modData.fat_gained + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 7 then
            local ability = tables.abList[27]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Enduring Quickness!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[27] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[27] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 10 then
            local ability = tables.abList[28]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Feral Parrying!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[28] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[28] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 13 then
            local ability = tables.abList[29]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Chameleon Skin!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[29] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[29] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 15 then
            local ability = tables.abList[30]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Boon of Muluk!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[30] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[30] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[6] = modData.att_gained[6] + 10
                modData.att_gained[8] = modData.att_gained[8] + 10
                modData.tp_max = modData.tp_max + 2
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 17 then
            local ability = tables.abList[31]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Freedom of Movement!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[31] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[31] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
        if modData.typelevels[7] >= 20 then
            local ability = tables.abList[32]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Goblin Type Ability Perfect Dodge!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[32] .. ".")
                tes3.playSound({ sound = "goblin scream" })
                modData.abilities[32] = true
                modData.att_gained[4] = modData.att_gained[4] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability!")
            end
        end
    end
    if cType == "Domestic" then
        if math.random(1, 160) < (companionRef.mobile.personality.base + modData.typelevels[8]) then
            local pLuck = tes3.player.mobile.luck
            local pAmount = 1
            if config.aboveMaxAtt == false then
                if pLuck.base + pAmount > 100 then
                    pAmount = math.max(100 - pLuck.base, 0)
                end
            end
            tes3.modStatistic({ attribute = 7, value = pAmount, reference = tes3.player })
            log:info("" ..
                name .. " Domestic Type bonus increased " .. tes3.player.object.name .. "'s Luck by " .. pAmount .. ".")
            func.clMessageBox("" .. name .. "'s presence made you feel lucky to have them around!")
            tes3.playSound({ sound = "guar moan" })
        end
    end
    if cType == "Spectral" then
        if modData.typelevels[9] >= 5 then
            local ability = tables.abList[33]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spectral Type Ability Unafraid!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[33] .. ".")
                tes3.playSound({ sound = "ancestor ghost scream" })
                modData.abilities[33] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[9] >= 10 then
            local ability = tables.abList[34]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spectral Type Ability Spectral Will!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[34] .. ".")
                tes3.playSound({ sound = "ancestor ghost scream" })
                modData.abilities[34] = true
                modData.att_gained[3] = modData.att_gained[3] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[9] >= 15 then
            local ability = tables.abList[35]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spectral Type Ability Aetherial Link!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[35] .. ".")
                tes3.playSound({ sound = "ancestor ghost scream" })
                modData.abilities[35] = true
                modData.mgk_gained = (companionRef.mobile.magicka.base - companionRef.baseObject.magicka)
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[9] >= 20 then
            local ability = tables.abList[36]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Spectral Type Ability Incorporeal!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[36] .. ".")
                tes3.playSound({ sound = "ancestor ghost scream" })
                modData.abilities[36] = true
                modData.att_gained[4] = modData.att_gained[4] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Insectile" then
        if modData.typelevels[10] >= 5 then
            local ability = tables.abList[37]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Insectile Type Ability Entomic!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[37] .. ".")
                tes3.playSound({ sound = "kwamQ scream" })
                modData.abilities[37] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[10] >= 10 then
            local ability = tables.abList[38]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Insectile Type Ability Jointed Legs!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[38] .. ".")
                tes3.playSound({ sound = "kwamQ scream" })
                modData.abilities[38] = true
                modData.tp_max = modData.tp_max + 1
                modData.att_gained[5] = modData.att_gained[5] + 10
                modData.att_gained[4] = modData.att_gained[4] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[10] >= 15 then
            local ability = tables.abList[39]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Insectile Type Ability Venomous Mandibles!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[39] .. ".")
                tes3.playSound({ sound = "kwamQ scream" })
                modData.abilities[39] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[10] >= 20 then
            local ability = tables.abList[40]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Insectile Type Ability Pheromone!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[40] .. ".")
                tes3.playSound({ sound = "kwamQ scream" })
                modData.abilities[40] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Draconic" then
        if modData.typelevels[11] >= 5 then
            local ability = tables.abList[41]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Draconic Type Ability Dragon Scales!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[41] .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\dragon_ability.wav", volume = 0.8 })
                modData.abilities[41] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[11] >= 10 then
            local ability = tables.abList[42]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Draconic Type Ability Ancient Memory!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[42] .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\dragon_ability.wav", volume = 0.8 })
                modData.abilities[42] = true
                modData.att_gained[2] = modData.att_gained[2] + 10
                modData.att_gained[7] = modData.att_gained[7] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[11] >= 15 then
            local ability = tables.abList[43]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Draconic Type Ability Burning Grip!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[43] .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\dragon_ability.wav", volume = 0.8 })
                modData.abilities[43] = true
                modData.att_gained[1] = modData.att_gained[1] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[11] >= 20 then
            local ability = tables.abList[44]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Draconic Type Ability Dragonflight!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[44] .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\dragon_ability.wav", volume = 0.8 })
                modData.abilities[44] = true
                modData.att_gained[5] = modData.att_gained[5] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Brute" then
        if modData.typelevels[12] >= 5 then
            local ability = tables.abList[45]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Brute Type Ability Durable!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[45] .. ".")
                tes3.playSound({ sound = "ogrim moan" })
                modData.abilities[45] = true
                modData.hth_gained = modData.hth_gained + 15
                modData.fat_gained = modData.fat_gained + 15
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[12] >= 10 then
            local ability = tables.abList[46]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Brute Type Ability Short Temper!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[46] .. ".")
                tes3.playSound({ sound = "ogrim moan" })
                modData.abilities[46] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[12] >= 15 then
            local ability = tables.abList[47]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Brute Type Ability Stubborn Muscle!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[47] .. ".")
                tes3.playSound({ sound = "ogrim moan" })
                modData.abilities[47] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[12] >= 20 then
            local ability = tables.abList[48]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Brute Type Ability Wanton Destruction!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[48] .. ".")
                tes3.playSound({ sound = "ogrim moan" })
                modData.abilities[48] = true
                modData.att_gained[1] = modData.att_gained[1] + 25
                modData.hth_gained = modData.hth_gained + 30
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Aquatic" then
        if modData.typelevels[13] >= 5 then
            local ability = tables.abList[49]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Aquatic Type Ability Buoyancy!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[49] .. ".")
                tes3.playSound({ sound = "dreugh scream" })
                modData.abilities[49] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[13] >= 10 then
            local ability = tables.abList[50]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Aquatic Type Ability Gills!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[50] .. ".")
                tes3.playSound({ sound = "dreugh scream" })
                modData.abilities[50] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[13] >= 15 then
            local ability = tables.abList[51]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Aquatic Type Ability Vaporous Aura!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[51] .. ".")
                tes3.playSound({ sound = "dreugh scream" })
                modData.abilities[51] = true
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[13] >= 20 then
            local ability = tables.abList[52]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the Aquatic Type Ability Aquatic Ascendancy!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[52] .. ".")
                tes3.playSound({ sound = "dreugh scream" })
                modData.abilities[52] = true
                modData.mgk_gained = (companionRef.mobile.magicka.base - companionRef.baseObject.magicka)
                modData.att_gained[4] = modData.att_gained[4] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Avian" then
        if modData.typelevels[14] >= 5 then
            local ability = tables.abList[53]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[14] .. " Type Ability Avian Eye!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[53] .. ".")
                tes3.playSound({ sound = "cliff racer scream" })
                modData.abilities[53] = true
                modData.att_gained[8] = modData.att_gained[8] + 3
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[14] >= 10 then
            local ability = tables.abList[54]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[14] .. " Type Ability Take to the Skies!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[54] .. ".")
                tes3.playSound({ sound = "cliff racer scream" })
                modData.abilities[54] = true
                modData.att_gained[5] = modData.att_gained[5] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[14] >= 15 then
            local ability = tables.abList[55]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[14] .. " Type Ability Misdirection!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[55] .. ".")
                tes3.playSound({ sound = "cliff racer scream" })
                modData.abilities[55] = true
                modData.att_gained[4] = modData.att_gained[4] + 10
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
        if modData.typelevels[14] >= 20 then
            local ability = tables.abList[56]
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[14] .. " Type Ability Mental Misstep!")
                log:info("" .. name .. " learned the Ability " .. tables.abList[56] .. ".")
                tes3.playSound({ sound = "cliff racer scream" })
                modData.abilities[56] = true
            else
                log:debug("" .. name .. " already has the " .. ability .. " Ability.")
            end
        end
    end
    if cType == "Bestial" then
        if modData.typelevels[15] >= 5 then
            local ability = tes3.getObject(tables.abList[57])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[15] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "wolf moan" })
                modData.abilities[57] = true
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[15] >= 10 then
            local ability = tes3.getObject(tables.abList[58])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[15] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "wolf moan" })
                modData.abilities[58] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[4] = modData.att_gained[4] + 5
                modData.att_gained[5] = modData.att_gained[5] + 5
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[15] >= 15 then
            local ability = tes3.getObject(tables.abList[59])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[15] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "wolf moan" })
                modData.abilities[59] = true
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[15] >= 20 then
            local ability = tes3.getObject(tables.abList[60])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[15] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "wolf moan" })
                modData.abilities[60] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[4] = modData.att_gained[4] + 5
                modData.att_gained[5] = modData.att_gained[5] + 5
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Impish" then
        if modData.typelevels[16] >= 5 then
            local ability = tes3.getObject(tables.abList[61])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[16] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "scamp roar" })
                modData.abilities[61] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[16] >= 10 then
            local ability = tes3.getObject(tables.abList[62])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[16] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "scamp roar" })
                modData.abilities[62] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[16] >= 15 then
            local ability = tes3.getObject(tables.abList[63])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[16] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "scamp roar" })
                modData.abilities[63] = true
                modData.mgk_gained = (companionRef.mobile.magicka.base - companionRef.baseObject.magicka)
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[16] >= 20 then
            local ability = tes3.getObject(tables.abList[64])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[16] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "scamp roar" })
                modData.abilities[64] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Fiery" then
        if modData.typelevels[17] >= 5 then
            local ability = tes3.getObject(tables.abList[65])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[17] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "destruction area" })
                modData.abilities[65] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[17] >= 10 then
            local ability = tes3.getObject(tables.abList[66])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[17] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "destruction area" })
                modData.abilities[66] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[17] >= 15 then
            local ability = tes3.getObject(tables.abList[67])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[17] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "destruction area" })
                modData.abilities[67] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[17] >= 20 then
            local ability = tes3.getObject(tables.abList[68])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[17] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "destruction area" })
                modData.abilities[68] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Frozen" then
        if modData.typelevels[18] >= 5 then
            local ability = tes3.getObject(tables.abList[69])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[18] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "frost area" })
                modData.abilities[69] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[18] >= 10 then
            local ability = tes3.getObject(tables.abList[70])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[18] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "frost area" })
                modData.abilities[70] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[18] >= 15 then
            local ability = tes3.getObject(tables.abList[71])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[18] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "frost area" })
                modData.abilities[71] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[18] >= 20 then
            local ability = tes3.getObject(tables.abList[72])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[18] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "frost area" })
                modData.abilities[72] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Galvanic" then
        if modData.typelevels[19] >= 5 then
            local ability = tes3.getObject(tables.abList[73])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[19] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "shock area" })
                modData.abilities[73] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[19] >= 10 then
            local ability = tes3.getObject(tables.abList[74])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[19] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "shock area" })
                modData.abilities[74] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[19] >= 15 then
            local ability = tes3.getObject(tables.abList[75])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[19] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "shock area" })
                modData.abilities[75] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[19] >= 20 then
            local ability = tes3.getObject(tables.abList[76])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[19] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "shock area" })
                modData.abilities[76] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Poisonous" then
        if modData.typelevels[20] >= 5 then
            local ability = tes3.getObject(tables.abList[77])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[20] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "alteration area" })
                modData.abilities[77] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[20] >= 10 then
            local ability = tes3.getObject(tables.abList[78])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[20] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "alteration area" })
                modData.abilities[78] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[20] >= 15 then
            local ability = tes3.getObject(tables.abList[79])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[20] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "alteration area" })
                modData.abilities[79] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[20] >= 20 then
            local ability = tes3.getObject(tables.abList[80])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[20] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "alteration area" })
                modData.abilities[80] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Guild-Trained" then
        if modData.typelevels[21] >= 5 then
            local ability = tes3.getObject(tables.abList[81])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[21] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[81] = true
                modData.att_gained[1] = modData.att_gained[1] + 1
                modData.att_gained[2] = modData.att_gained[2] + 1
                modData.att_gained[3] = modData.att_gained[3] + 1
                modData.att_gained[4] = modData.att_gained[4] + 1
                modData.att_gained[5] = modData.att_gained[5] + 1
                modData.att_gained[6] = modData.att_gained[6] + 1
                modData.att_gained[7] = modData.att_gained[7] + 1
                modData.att_gained[8] = modData.att_gained[8] + 1

                --Potential (Commoner Class)
                local creMode = require("companionLeveler.modes.creClassMode")
                local table = {
                    [1] = companionRef
                }

                timer.delayOneFrame(function()
                    timer.delayOneFrame(function()
                        timer.delayOneFrame(function()
                            creMode.levelUp(table)
                            func.clMessageBox("" .. companionRef.object.name .. " unlocked their potential!")
                        end)
                    end)
                end)
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[21] >= 10 then
            local ability = tes3.getObject(tables.abList[82])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[21] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[82] = true
                modData.att_gained[2] = modData.att_gained[2] + 5
                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    guild.pickFaction(companionRef, 82)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[21] >= 15 then
            local ability = tes3.getObject(tables.abList[83])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[21] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[83] = true
                modData.att_gained[3] = modData.att_gained[3] + 5
                modData.att_gained[7] = modData.att_gained[7] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[21] >= 20 then
            local ability = tes3.getObject(tables.abList[84])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[21] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[84] = true
                modData.att_gained[2] = modData.att_gained[2] + 5
                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    guild.pickFaction(companionRef, 84)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Pestilent" then
        if modData.typelevels[22] >= 5 then
            local ability = tes3.getObject(tables.abList[85])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[22] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "rat scream" })
                modData.abilities[85] = true
                modData.att_gained[4] = modData.att_gained[4] + 3
                modData.att_gained[5] = modData.att_gained[5] + 3
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[22] >= 10 then
            local ability = tes3.getObject(tables.abList[86])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[22] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "rat scream" })
                modData.abilities[86] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[22] >= 15 then
            local ability = tes3.getObject(tables.abList[87])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[22] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "rat scream" })
                modData.abilities[87] = true
                modData.att_gained[4] = modData.att_gained[4] + 3
                modData.att_gained[5] = modData.att_gained[5] + 3
                modData.att_gained[6] = modData.att_gained[6] + 3
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[22] >= 20 then
            local ability = tes3.getObject(tables.abList[88])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[22] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ sound = "rat scream" })
                modData.abilities[88] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Fungal" then
        if modData.typelevels[23] >= 5 then
            local ability = tes3.getObject(tables.abList[89])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[23] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[89] = true
                modData.att_gained[2] = modData.att_gained[2] + 3
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[23] >= 10 then
            local ability = tes3.getObject(tables.abList[90])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[23] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[90] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[23] >= 15 then
            local ability = tes3.getObject(tables.abList[91])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[23] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[91] = true
                modData.att_gained[5] = modData.att_gained[5] + 5
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[23] >= 20 then
            local ability = tes3.getObject(tables.abList[92])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[23] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[92] = true
                modData.tp_max = modData.tp_max + 2
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Seismic" then
        if modData.typelevels[24] >= 5 then
            local ability = tes3.getObject(tables.abList[93])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[24] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[93] = true
                modData.tp_max = modData.tp_max + 1
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[24] >= 10 then
            local ability = tes3.getObject(tables.abList[94])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[24] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[94] = true
                modData.att_gained[1] = modData.att_gained[1] + 4
                modData.att_gained[6] = modData.att_gained[6] + 4
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[24] >= 15 then
            local ability = tes3.getObject(tables.abList[95])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[24] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[95] = true
                modData.att_gained[6] = modData.att_gained[6] + 10
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[24] >= 20 then
            local ability = tes3.getObject(tables.abList[96])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[24] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[96] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[3] = modData.att_gained[3] + 5
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Feline" then
        if modData.typelevels[25] >= 5 then
            local ability = tes3.getObject(tables.abList[97])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[25] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[97] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[25] >= 10 then
            local ability = tes3.getObject(tables.abList[98])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[25] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[98] = true
                modData.att_gained[4] = modData.att_gained[4] + 5
                modData.att_gained[5] = modData.att_gained[5] + 5
                modData.att_gained[8] = modData.att_gained[8] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[25] >= 15 then
            local ability = tes3.getObject(tables.abList[99])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[25] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[99] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[25] >= 20 then
            local ability = tes3.getObject(tables.abList[100])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[25] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[100] = true
                modData.att_gained[8] = modData.att_gained[8] + 3
                modData.att_gained[4] = modData.att_gained[4] + 3
                modData.att_gained[3] = modData.att_gained[3] + 3
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Reptilian" then
        if modData.typelevels[26] >= 5 then
            local ability = tes3.getObject(tables.abList[101])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[26] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[101] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[26] >= 10 then
            local ability = tes3.getObject(tables.abList[102])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[26] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[102] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[26] >= 15 then
            local ability = tes3.getObject(tables.abList[103])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[26] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[103] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[26] >= 20 then
            local ability = tes3.getObject(tables.abList[104])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[26] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[104] = true
                modData.att_gained[6] = modData.att_gained[6] + 5
                modData.att_gained[4] = modData.att_gained[4] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Vampiric" then
        if modData.typelevels[27] >= 5 then
            local ability = tes3.getObject(tables.abList[105])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[27] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[105] = true
                modData.att_gained[2] = modData.att_gained[2] + 5
                modData.att_gained[7] = modData.att_gained[7] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[27] >= 10 then
            local ability = tes3.getObject(tables.abList[106])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[27] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[106] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[27] >= 15 then
            local ability = tes3.getObject(tables.abList[107])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[27] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[107] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[27] >= 20 then
            local ability = tes3.getObject(tables.abList[108])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[27] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[108] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Amorphous" then
        if modData.typelevels[28] >= 5 then
            local ability = tes3.getObject(tables.abList[109])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[28] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[109] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[28] >= 10 then
            local ability = tes3.getObject(tables.abList[110])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[28] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[110] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[28] >= 15 then
            local ability = tes3.getObject(tables.abList[111])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[28] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[111] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[28] >= 20 then
            local ability = tes3.getObject(tables.abList[112])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[28] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[112] = true
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Steed" then
        if modData.typelevels[29] >= 5 then
            local ability = tes3.getObject(tables.abList[113])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[29] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[113] = true
                modData.att_gained[5] = modData.att_gained[5] + 5
                modData.att_gained[6] = modData.att_gained[6] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[29] >= 10 then
            local ability = tes3.getObject(tables.abList[114])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[29] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[114] = true
                modData.att_gained[1] = modData.att_gained[1] + 5
                modData.att_gained[2] = modData.att_gained[2] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[29] >= 15 then
            local ability = tes3.getObject(tables.abList[115])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[29] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[115] = true
                modData.att_gained[4] = modData.att_gained[4] + 5
                modData.att_gained[8] = modData.att_gained[8] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[29] >= 20 then
            local ability = tes3.getObject(tables.abList[116])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[29] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[116] = true
                modData.att_gained[5] = modData.att_gained[5] + 10
                modData.att_gained[3] = modData.att_gained[3] + 5
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end
    if cType == "Mutated" then
        if modData.typelevels[30] >= 5 then
            local ability = tes3.getObject(tables.abList[117])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[30] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[117] = true
                modData.att_gained[1] = modData.att_gained[1] + 1
                modData.att_gained[2] = modData.att_gained[2] + 1
                modData.att_gained[3] = modData.att_gained[3] + 1
                modData.att_gained[4] = modData.att_gained[4] + 1
                modData.att_gained[5] = modData.att_gained[5] + 1
                modData.att_gained[6] = modData.att_gained[6] + 1
                modData.att_gained[7] = modData.att_gained[7] + 1
                modData.att_gained[8] = modData.att_gained[8] + 1

                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    mut.pickMutation(companionRef, 1, false)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[30] >= 10 then
            local ability = tes3.getObject(tables.abList[118])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[30] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[118] = true
                modData.att_gained[1] = modData.att_gained[1] + 2
                modData.att_gained[2] = modData.att_gained[2] + 2
                modData.att_gained[3] = modData.att_gained[3] + 2
                modData.att_gained[4] = modData.att_gained[4] + 2
                modData.att_gained[5] = modData.att_gained[5] + 2
                modData.att_gained[6] = modData.att_gained[6] + 2
                modData.att_gained[7] = modData.att_gained[7] + 2
                modData.att_gained[8] = modData.att_gained[8] + 2
                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    mut.pickMutation(companionRef, 2, false)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[30] >= 15 then
            local ability = tes3.getObject(tables.abList[119])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[30] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[119] = true
                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    mut.pickMutation(companionRef, 3, false)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
        if modData.typelevels[30] >= 20 then
            local ability = tes3.getObject(tables.abList[120])
            local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability.id })
            if wasAdded == true then
                func.clMessageBox("" .. name .. " learned the " .. tables.typeTable[30] .. " Type Ability " .. ability.name .. "!")
                log:info("" .. name .. " learned the Ability " .. ability.name .. ".")
                tes3.playSound({ soundPath = "companionLeveler\\creature_ability.wav" })
                modData.abilities[120] = true
                modData.att_gained[1] = modData.att_gained[1] + 1
                modData.att_gained[2] = modData.att_gained[2] + 1
                modData.att_gained[3] = modData.att_gained[3] + 1
                modData.att_gained[4] = modData.att_gained[4] + 1
                modData.att_gained[5] = modData.att_gained[5] + 1
                modData.att_gained[6] = modData.att_gained[6] + 1
                modData.att_gained[7] = modData.att_gained[7] + 1
                modData.att_gained[8] = modData.att_gained[8] + 1
                timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                    mut.pickMutation(companionRef, 4, false)
                end })
            else
                log:debug("" .. name .. " already has the " .. ability.name .. " Ability.")
            end
        end
    end

    if modData.guildTraining then
        if modData.guildTraining[1] == tables.factions[4] or modData.guildTraining[2] == tables.factions[4] then
            --Blades Training
            this.bladesCre(companionRef)
        end
        if modData.guildTraining[1] == tables.factions[9] or modData.guildTraining[2] == tables.factions[9] then
            --Hlaalu Training
            local count = (modData.level * 4) + (tes3.player.object.reputation * 7)
            tes3.addItem({ reference = tes3.player, item = "Gold_001", count = count })
            func.clMessageBox("House Hlaalu has sent you a stipend of " .. count .. " to support " .. companionRef.object.name .. "'s future growth.")
        end
    end
end

function this.executeAbilitiesCre(companionRef)
    if config.triggeredAbilities == false then return end
    if (tes3.mobilePlayer.inCombat == true or companionRef.mobile.inCombat == true) then return end

    log:trace("Execute Abilities function triggered on " .. companionRef.object.name .. ".")

    local modData = func.getModData(companionRef)

    --Amorphous
    if modData.abilities[110] == true then
        this.slimeSecretion(companionRef)
    end
end


--Greater Instinct #3-------------------------------------------------------------------------------------------------------------------
function this.instinct()
    log:trace("Greater Instinct triggered.")

    if config.triggeredAbilities == false then
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_instinct" })
        log:debug("Greater Instinct removed from player.")
        return
    end

    local trigger = 0
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[3] == true then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        --Confer Aura
        tes3.addSpell({ reference = tes3.player, spell = "kl_ability_instinct" })
        log:debug("Greater Instinct bestowed upon player.")
    else
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_instinct" })
        log:debug("Greater Instinct removed from player.")
    end
end

--Dark Barrier #8 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.barrier()
    log:trace("Dark Barrier triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    if config.triggeredAbilities == false then
        this.updatePartyAura(party, "kl_ability_barrier", false)
        log:debug("Dark Barrier removed from party.")
        return
    end

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[8] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_barrier", trigger)
    if trigger then
        log:debug("Dark Barrier bestowed upon party.")
    else
        log:debug("Dark Barrier removed from party.")
    end
end

--Dream Mastery #16 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.dream()
    log:trace("Dream Mastery triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[16] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_dream", trigger)
    if trigger then
        log:debug("Dream Mastery bestowed upon party.")
    else
        log:debug("Dream Mastery removed from party.")
    end
end

--Dwemer Refractors #20 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.refractors()
    log:trace("Refraction Field triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[20] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_refraction", trigger)
    if trigger then
        log:debug("Refraction Field bestowed upon party.")
    else
        log:debug("Refraction Field removed from party.")
    end
end

--Jade Wind #22 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.jadewind()
    log:trace("Jade Wind triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[22] == true then
            trigger = true
            break
        end
    end

    if trigger then
        this.updatePartyAura(party, "kl_ability_jadewind", true, function(ref)
            local modData = func.getModData(ref)
            modData.att_gained[8] = modData.att_gained[8] + 3
        end)
        log:debug("Jade Wind bestowed upon party.")
    else
        this.updatePartyAura(party, "kl_ability_jadewind", false, nil, function(ref)
            local modData = func.getModData(ref)
            modData.att_gained[8] = modData.att_gained[8] - 3
        end)
        log:debug("Jade Wind removed from party.")
    end
end

--Springstep #26 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.springstep()
    log:trace("Springstep triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[26] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_springstep", trigger)
    if trigger then
        log:debug("Springstep bestowed upon party.")
    else
        log:debug("Springstep removed from party.")
    end
end

--Freedom of Movement #31 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.freedom()
    log:trace("Freedom of Movement triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[31] == true then
            trigger = true
            break
        end
    end

    if trigger then
        this.updatePartyAura(party, "kl_ability_freedom", true, function(ref)
            local modData = func.getModData(ref)
            modData.att_gained[5] = modData.att_gained[5] + 5
        end)
        log:debug("Freedom of Movement bestowed upon party.")
    else
        this.updatePartyAura(party, "kl_ability_freedom", false, nil, function(ref)
            local modData = func.getModData(ref)
            modData.att_gained[5] = modData.att_gained[5] - 5
        end)
        log:debug("Freedom of Movement removed from party.")
    end
end

--Spectral Will #34, Total Decay #12---------------------------------------------------------------------------------------------------------------
function this.spectralWill(e)
    if config.combatAbilities == false then return end
    log:trace("Spectral Will triggered.")
    local modData
    if func.checkModData(e.reference) then
        modData = func.getModData(e.reference)
    else
        return
    end


    if e.reference.object.objectType == tes3.objectType.creature or modData.metamorph == true then
        local risen = 0

        --Total Decay #12
        if modData.abilities[12] == true then
            if math.random(0, 99) < modData.level + math.random(1, 25) then
                e.mobile:resurrect({ resetState = false })
                tes3.setAIFollow({ reference = e.reference, target = tes3.player })

                func.clMessageBox("" .. e.reference.object.name .. " rises again!")
                log:info("" .. e.reference.object.name .. " rises again!")

                risen = 1
            else
                func.clMessageBox("" .. e.reference.object.name .. " failed to rise...")
                log:info("" .. e.reference.object.name .. " failed to rise...")
            end
        end

        --Spectral Will #34
        if (modData.abilities[34] == true and risen == 0) then
            local removedCount = tes3.removeItem({ reference = tes3.player, item = "Misc_SoulGem_Grand", count = 1 })

            if removedCount > 0 then
                e.mobile:resurrect({ resetState = false })
                tes3.setAIFollow({ reference = e.reference, target = tes3.player })

                func.clMessageBox("" .. e.reference.object.name .. " regained their form through your Grand Soul Gem!")
                log:info("" .. e.reference.object.name .. " regained their form through your Grand Soul Gem!")

                for i = 0, 7 do
                    func.modStatAndTrack("attribute", i, -3, e.reference, modData)
                end

                log:info("" .. e.reference.object.name .. "'s attributes were reduced by 3 through resurrection.")
            else
                func.clMessageBox("" .. e.reference.object.name .. " could not regain their form.")
                log:info("" .. e.reference.object.name .. " could not regain their form. (No Grand Soul Gem)")
            end
        end
    end
end

--Pheromone #40-------------------------------------------------------------------------------------------------------------------
function this.pheromone(ref)
    if config.triggeredAbilities == false then return end

	if (string.startswith(ref.object.name, "Kwama") or string.endswith(ref.object.name, "Kwama") or string.startswith(ref.object.name, "Shalk") or string.endswith(ref.object.name, "Shalk")) then
		local creTable = func.creTable()
		local trigger = 0

		for i = 1, #creTable do
			local reference = creTable[i]
			local modData = func.getModData(reference)
			if modData.abilities[40] == true then
				trigger = 1
				log:debug("" .. ref.object.name .. " was warded off by " .. reference.object.name .. ".")
                break
			end
		end

		--Ward off
		if trigger == 1 then
			ref.mobile.fight = 0
		end
	end
end

--Ancient Memory #42--------------------------------------------------------------------------------------------------------------
function this.thuum(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Thuum triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[42] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Personality Damage Bonus
                if math.random(0, 99) < (e.attacker.personality.current / 1.4) then
                    result = math.round(e.attacker.personality.current / 12)
                    if result > 15 then
                        result = 15
                    end
                    log:debug("Draconic Thu'um! " .. result .. " damage added!")
                end
            end
        end
    end

    return result
end

--Short Temper #46 (Aura)-------------------------------------------------------------------------------------------------------------------
function this.temper()
    
    log:trace("Short Temper triggered.")

    local party = func.partyTable()
    if config.triggeredAbilities == false then
        this.updatePartyAura(party, "kl_ability_temper", false)
        log:debug("Short Temper removed from party.")
        return
    end

    local trigger = false
    local creTable = func.creTable()
    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[46] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_temper", trigger)
    if trigger then
        log:debug("Short Temper bestowed upon party.")
    else
        log:debug("Short Temper removed from party.")
    end
end

--Aquatic Ascendancy #52 (Aura)----------------------------------------------------------------------------------------------------------
function this.aqualung()
    
    log:trace("Aqualung triggered.")

    local party = func.partyTable()
    if config.triggeredAbilities == false then
        this.updatePartyAura(party, "kl_ability_aqualung", false)
        log:debug("Aqualung removed from party.")
        return
    end

    local trigger = false
    local creTable = func.creTable()
    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[52] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_aqualung", trigger)
    if trigger then
        log:debug("Aqualung bestowed upon party.")
    else
        log:debug("Aqualung removed from party.")
    end
end

--Misdirection #55-----------------------------------------------------------------------------------------------------------------
function this.misdirection(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Misdirection triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_misdirection" })
            if not affected then
                local modData = func.getModData(e.attacker.reference)

                if modData.abilities[55] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_misdirection", instant = true })
                    log:debug("" .. e.mobile.object.name .. " was misdirected!")
                end
            end
        end
    end
end

--Mental Misstep #56---------------------------------------------------------------------------------------------------------------
function this.misstep(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Mental Misstep triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_misstep" })
            if not affected then
                local modData = func.getModData(e.attacker.reference)

                if modData.abilities[56] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_misstep", instant = true })
                    log:debug("" .. e.mobile.object.name .. " was unfocused!")
                end
            end
        end
    end
end

--Beast Within #58------------------------------------------------------------------------------------------------------------------
function this.beastwithin(e)
    if config.combatAbilities == false then return end
    
    log:trace("Beast Within triggered.")

    if e.killingBlow and e.attacker ~= nil then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[58] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Beast Within!
                tes3.applyMagicSource({
                    reference = e.attacker,
                    name = "Beast Within",
                    effects = {
                        { id = tes3.effect.restoreHealth,
                            min = 1,
                            max = 2,
                            duration = math.random(1, 3) },
                        { id = tes3.effect.restoreFatigue,
                            min = 1,
                            max = 2,
                            duration = math.random(1, 4) }
                    },
                })
                log:debug("Beast Within!")
            end
        end
    end
end

--Dominance #60---------------------------------------------------------------------------------------------------------------------
function this.dominance(e)
    if config.combatAbilities == false then return end

    
    log:trace("Dominance triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local creTable = func.creTable()

		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
			if actor.objectType ~= tes3.objectType.npc then
				local trigger = 0
				local personality
				local strength
				local caster

				for i = 1, #creTable do
					local reference = creTable[i]
					local modData = func.getModData(reference)
					if (modData.abilities[60] == true) then
						trigger = 1
						caster = reference.object.name
						personality = reference.mobile.attributes[7]
						strength = reference.mobile.attributes[1]
						log:debug("" .. caster .. " attempted to demoralize " .. actor.reference.object.name .. ".")
					end
				end

				if trigger == 1 then
					--Check for Demoralize
					local affected = tes3.isAffectedBy({ reference = actor.reference, effect = 54 })
					if not affected then
						if personality.current > (actor.reference.mobile.willpower.current + math.random(1, 50)) then
							local randNum = math.random(60, 120)
							local amount = math.round(strength.current / 1.3)
							if amount > 90 then
								amount = 90
							end

                            --Demoralize Creature
							tes3.applyMagicSource({
								reference = actor.reference,
								name = "Dominance",
								bypassResistances = true,
								effects = {
									{ id = tes3.effect.demoralizeCreature,
										duration = (randNum + (personality.current / 2)),
										min = (amount / 2),
										max = amount }
								},
							})
                            tes3.createVisualEffect({ object = "VFX_IllusionHit", lifespan = 3, reference = actor.reference })
                            tes3.playSound({ sound = "illusion hit", reference = actor.reference, volume = 0.8 })
							log:debug("" .. actor.reference.object.name .. " was intimidated by " .. caster .. "'s Dominance!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " was intimidated by " .. caster .. "'s Dominance!")
                            end
						else
							log:debug("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Dominance!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Dominance!")
                            end
						end
					else
						log:debug("" .. actor.reference.object.name .. " is already affected by Dominance.")
					end
				end
			end
		end
	end
end

--Alchemical Composition #62 (Aura)--------------------------------------------------------------------------------------------------------
function this.composition()
    
    log:trace("Alchemical Composition triggered.")

    local party = func.partyTable()
    if config.triggeredAbilities == false then
        this.updatePartyAura(party, "kl_ability_composition", false, nil, function(ref)
            if ref.object.objectType == tes3.objectType.npc then
                local modData = func.getModData(ref)
                modData.skill_gained[17] = modData.skill_gained[17] - 5
                modData.skill_gained[10] = modData.skill_gained[10] - 5
            end
        end)
        log:debug("Alchemical Composition removed from party.")
        return
    end

    local trigger = false
    for i, reference in ipairs(func.creTable()) do
        local modData = func.getModData(reference)
        if modData.abilities[62] == true then
            trigger = true
            break
        end
    end

    if trigger then
        this.updatePartyAura(party, "kl_ability_composition", true, function(ref)
            if ref.object.objectType == tes3.objectType.npc then
                local modData = func.getModData(ref)
                modData.skill_gained[17] = modData.skill_gained[17] + 5
                modData.skill_gained[10] = modData.skill_gained[10] + 5
            end
        end)
        log:debug("Alchemical Composition bestowed upon party.")
    else
        this.updatePartyAura(party, "kl_ability_composition", false, nil, function(ref)
            if ref.object.objectType == tes3.objectType.npc then
                local modData = func.getModData(ref)
                modData.skill_gained[17] = modData.skill_gained[17] - 5
                modData.skill_gained[10] = modData.skill_gained[10] - 5
            end
        end)
        log:debug("Alchemical Composition removed from party.")
    end
end

--Mysterious Aura #63 (Aura)---------------------------------------------------------------------------------------------------------------
function this.mystery()
    
    log:trace("Mysterious Aura triggered.")

    local party = func.partyTable()

    if config.triggeredAbilities == false then
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_detectench" })
        for n = 1, #party do
            local ref = party[n]
            local affected = tes3.isAffectedBy({ reference = ref, object = "kl_ability_mysterious" })

            if affected then
                tes3.removeSpell({ reference = ref, spell = "kl_ability_mysterious" })

                if ref.object.objectType == tes3.objectType.npc then
                    local modData = func.getModData(ref)
                    modData.skill_gained[11] = modData.skill_gained[11] - 5
                    modData.skill_gained[12] = modData.skill_gained[12] - 5
                    modData.skill_gained[13] = modData.skill_gained[13] - 5
                    modData.skill_gained[14] = modData.skill_gained[14] - 5
                    modData.skill_gained[15] = modData.skill_gained[15] - 5
                    modData.skill_gained[16] = modData.skill_gained[16] - 5
                end
            end
        end
        log:debug("Mysterious Aura removed from party.")
        return
    end

    local trigger = 0
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[63] == true then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        --Confer Aura
        tes3.addSpell({ reference = tes3.player, spell = "kl_ability_detectench" })
        for n = 1, #party do
            local ref = party[n]
            local affected = tes3.isAffectedBy({ reference = ref, object = "kl_ability_mysterious" })

            if not affected then
                tes3.addSpell({ reference = ref, spell = "kl_ability_mysterious" })

                if ref.object.objectType == tes3.objectType.npc then
                    local modData = func.getModData(ref)
                    modData.skill_gained[11] = modData.skill_gained[11] + 5
                    modData.skill_gained[12] = modData.skill_gained[12] + 5
                    modData.skill_gained[13] = modData.skill_gained[13] + 5
                    modData.skill_gained[14] = modData.skill_gained[14] + 5
                    modData.skill_gained[15] = modData.skill_gained[15] + 5
                    modData.skill_gained[16] = modData.skill_gained[16] + 5
                end
            end
        end
        log:debug("Mysterious Aura bestowed upon party.")
    else
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_detectench" })
        for n = 1, #party do
            local ref = party[n]
            local affected = tes3.isAffectedBy({ reference = ref, object = "kl_ability_mysterious" })

            if affected then
                tes3.removeSpell({ reference = ref, spell = "kl_ability_mysterious" })

                if ref.object.objectType == tes3.objectType.npc then
                    local modData = func.getModData(ref)
                    modData.skill_gained[11] = modData.skill_gained[11] - 5
                    modData.skill_gained[12] = modData.skill_gained[12] - 5
                    modData.skill_gained[13] = modData.skill_gained[13] - 5
                    modData.skill_gained[14] = modData.skill_gained[14] - 5
                    modData.skill_gained[15] = modData.skill_gained[15] - 5
                    modData.skill_gained[16] = modData.skill_gained[16] - 5
                end
            end
        end
        log:debug("Mysterious Aura removed from party.")
    end
end

--Manasponge Aura #64 (Aura)---------------------------------------------------------------------------------------------------------------
function this.manasponge()
    
    log:trace("Manasponge Aura triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[64] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_manasponge", trigger)
    if trigger then
        log:debug("Manasponge Aura bestowed upon party.")
    else
        log:debug("Manasponge Aura removed from party.")
    end
end

--Warm Aura #66--------------------------------------------------------------------------------------------------------------------
function this.warmAura()
    
    log:trace("Warm Aura triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[66] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_fireAura", trigger)
    if trigger then
        log:debug("Warm Aura bestowed upon party.")
    else
        log:debug("Warm Aura removed from party.")
    end
end

--Ignition #68----------------------------------------------------------------------------------------------------------------------
function this.ignition(e)
    if config.combatAbilities == false then return end
    
    log:trace("Ignition triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[68] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                    --Fire Damage Bonus
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_ignition", instant = true })
            end
        end
    end
end

--Chill Aura #70--------------------------------------------------------------------------------------------------------------------
function this.chillAura()
    
    log:trace("Chill Aura triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[70] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_frostAura", trigger)
    if trigger then
        log:debug("Chill Aura bestowed upon party.")
    else
        log:debug("Chill Aura removed from party.")
    end
end

--Permafrost #72--------------------------------------------------------------------------------------------------------------------
function this.permafrost(e)
    if config.combatAbilities == false then return end
    
    log:trace("Permafrost triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[72] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                    --Frost Damage Bonus
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_permafrost", instant = true })
            end
        end
    end
end

--Static Aura #74--------------------------------------------------------------------------------------------------------------------
function this.staticAura()
    
    log:trace("Static Aura triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[74] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_shockAura", trigger)
    if trigger then
        log:debug("Static Aura bestowed upon party.")
    else
        log:debug("Static Aura removed from party.")
    end
end

--Voltaic Grasp #76-----------------------------------------------------------------------------------------------------------------
function this.voltaic(e)
    if config.combatAbilities == false then return end
    
    log:trace("Voltaic Grasp triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[76] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Shock Damage Bonus
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_voltaic_grasp", instant = true })
            end
        end
    end
end

--Toxic Aura #78--------------------------------------------------------------------------------------------------------------------
function this.toxicAura()
    
    log:trace("Toxic Aura triggered.")

    local party = func.partyTable()
    local trigger = false
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[78] == true then
            trigger = true
            break
        end
    end

    this.updatePartyAura(party, "kl_ability_poisAura", trigger)
    if trigger then
        log:debug("Toxic Aura bestowed upon party.")
    else
        log:debug("Toxic Aura removed from party.")
    end
end

--Venomous Kiss #80-----------------------------------------------------------------------------------------------------------------
function this.venomous(e)
    if config.combatAbilities == false then return end
    
    log:trace("Venomous Kiss triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[80] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_venomous_kiss" })

                if not affected then
                    --Poison
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_venomous_kiss", instant = true })
                    log:debug("" .. e.mobile.object.name .. " was poisoned!")
                end

                --Poison Weakness
                tes3.applyMagicSource({
                    reference = e.mobile,
                    name = "Lingering Kiss",
                    effects = {
                        { id = tes3.effect.weaknesstoPoison,
                            min = 1,
                            max = 3,
                            duration = math.random(5, 15)
                        }
                    },
                })
            end
        end
    end
end

--Inoculate #86-----------------------------------------------------------------------------------------------------------------
function this.inoculateCre(e)
    if config.combatAbilities == false then return end
    
    log:trace("Creature Inoculate triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[86] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Random Common Disease
                if math.random(1, 10) == 10 then
                    local dis = tes3.getObject(tables.commonDiseases[math.random(1, #tables.commonDiseases)])
                    tes3.applyMagicSource({ reference = e.mobile, source = dis })
                    func.simulateSpellHit(e.mobile.reference, dis.effects[1], false)
                    log:trace("" .. e.attacker.reference.object.name .. " inoculated " .. e.mobile.object.name .. "!")
                end
            end
        end
    end
end

--Pathogen #88-----------------------------------------------------------------------------------------------------------------
function this.pathogen(e)
    if config.combatAbilities == false then return end
    
    log:trace("Black Pathogen triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[88] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Random Blight Disease
                if math.random(1, 25) == 25 then
                    local dis = tes3.getObject(tables.blightDiseases[math.random(1, #tables.blightDiseases)])
                    tes3.applyMagicSource({ reference = e.mobile, source = dis })
                    func.simulateSpellHit(e.mobile.reference, dis.effects[1], false)
                    log:trace("" .. e.attacker.reference.object.name .. " blighted " .. e.mobile.object.name .. "!")
                end
            end
        end
    end
end

--Mollifying Spores #90---------------------------------------------------------------------------------------------------------------------
function this.spores(e)
    if config.combatAbilities == false then return end

    
    log:trace("Spores triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local creTable = func.creTable()

        local trigger = 0
        local caster

        for i = 1, #creTable do
            local reference = creTable[i]
            local modData = func.getModData(reference)
            if (modData.abilities[90] == true) then
                trigger = 1
                caster = reference.object.name
                break
            end
        end

        if trigger == 1 then
            for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                if func.getLevel(actor.reference) < 5 then
                    tes3.applyMagicSource({
                        reference = actor.reference,
                        name = "Mollifying Spores",
                        bypassResistances = false,
                        effects = {
                            { id = tes3.effect.calmCreature, duration = 20, min = 20, max = 20 },
                            { id = tes3.effect.calmHumanoid, duration = 20, min = 20, max = 20 }
                        },
                    })
                    func.simulateSpellHit(actor.reference, tes3.getObject("calm humanoid").effects[1])
                    log:debug("" .. actor.reference.object.name .. " was mollified by " .. caster .. "'s Mollifying Spores!")
                end
		    end
        end
	end
end

--Quake #94-----------------------------------------------------------------------------------------------------------------
function this.quake(e)
    if config.combatAbilities == false then return end
    
    log:trace("Quake triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[94] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                local will = e.attacker.attributes[3].current

                if will < 50 then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_quake_01", instant = true })
                    log:debug("Quake 1!")
                elseif will < 75 then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_quake_02", instant = true })
                    log:debug("Quake 2!")
                elseif will < 100 then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_quake_03", instant = true })
                    log:debug("Quake 3!")
                elseif will < 150 then
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_quake_04", instant = true })
                    log:debug("Quake 4!")
                else
                    tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_quake_05", instant = true })
                    log:debug("Quake 5!")
                end
            end
        end
    end
end

--Potential Energy #96-----------------------------------------------------------------------------------------------------------------
function this.pEnergy(e)
    if config.combatAbilities == false then return end
    
    log:trace("Potential Energy triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[96] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                if modData.tp_current > 1 then
                    modData.tp_current = modData.tp_current - 1
                    result = math.round(e.damage * 0.33)
                    log:debug("" .. e.attacker.object.name .. " added " .. result .. " potential energy damage!")
                end
            end
        end
    end

    return result
end

--Twist Reflex #98-----------------------------------------------------------------------------------------------------------------
function this.twist(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Twist triggered.")

    local result = e.damage

    if e.mobile then
        if func.validCompanionCheck(e.mobile) then
            local modData = func.getModData(e.mobile.reference)
            if e.mobile.actorType == 0 or modData.metamorph == true then
                if modData.abilities[98] then
                    result = 0
                end
            end
        end
    end

    return result
end

--Hidden Claws #99-----------------------------------------------------------------------------------------------------------------
function this.claws(e)
    if config.combatAbilities == false then return end
    
    log:trace("Claws triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[99] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                local agi = e.attacker.attributes[4].current
                if agi > 200 then
                    agi = 200
                end
                local dur = math.round(agi * 0.15)
                local max = math.round(agi * 0.02)
                if max < 1 then
                    max = 1
                end

                tes3.applyMagicSource({
                    reference = e.mobile.reference,
                    name = "Claws",
                    bypassResistances = true,
                    effects = {
                        { id = tes3.effect.damageHealth,
                            duration = dur,
                            min = 0,
                            max = max }
                    },
				})
                log:debug("Claws inflict bleeding on " .. e.mobile.reference.object.name .. "!")
            end
        end
    end
end

--Whisker Alarum #100-----------------------------------------------------------------------------------------------------------------
function this.whisker(e)
    if config.combatAbilities == false then return end
    log:trace("Whisker triggered.")

    if e.caster == nil then return e.resistedPercent end
    log:debug("Caster is " .. e.caster.object.name .. " and target is " .. e.target.object.name .. ".")

    local result = e.resistedPercent

    if func.validCompanionCheck(e.target.mobile) then
        local modData = func.getModData(e.target)
        if modData.abilities[100] and modData.typelevels[25] >= 20 then
            local will = e.target.mobile.attributes[3].current
            if will > 200 then
                will = 200
            end

            if will > (e.caster.mobile.attributes[3].current + math.random(1, 120)) then
                result = 100
                log:debug("" .. e.target.object.name .. " avoided the spell!")
            end
        end
    end

    return result
end

--Poison Touch #101-----------------------------------------------------------------------------------------------------------------
function this.poisonTouch(e)
    if config.combatAbilities == false then return end

    log:trace("Poison Touch triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[101] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Poison Damage Bonus
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_poison_touch", instant = true })
            end
        end
    end
end

--Acid Touch #103-----------------------------------------------------------------------------------------------------------------
function this.acidTouch(e)
    if config.combatAbilities == false then return end

    log:trace("Acid Touch triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[103] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Disintegrate Armor
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_acid_touch", instant = true })
            end
        end
    end
end

--Corrosive Touch #104-----------------------------------------------------------------------------------------------------------------
function this.corrosiveTouch(e)
    if config.combatAbilities == false then return end

    log:trace("Corrosive Touch triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[104] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Acid Damage Bonus/Disintegrate Weapon
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_corrosive_touch", instant = true })
            end
        end
    end
end

--Debilitating Touch #106-----------------------------------------------------------------------------------------------------------------
function this.debilitatingTouch(e)
    if config.combatAbilities == false then return end

    log:trace("Debilitating Touch triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[106] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Absorb Fatigue
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_vamp_debil", instant = true })
            end
        end
    end
end

--Exsanguinate #107-----------------------------------------------------------------------------------------------------------------
function this.exsanguinate(e)
    if config.combatAbilities == false then return end

    log:trace("Exsanguinate triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[107] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Absorb Health
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_vamp_exsan", instant = true })
            end
        end
    end
end

--Soul Drain #108-----------------------------------------------------------------------------------------------------------------
function this.soulDrain(e)
    if config.combatAbilities == false then return end

    log:trace("Soul Drain triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[108] and (e.attacker.actorType == 0 or modData.metamorph == true) then
                --Soul Trap
                tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_vamp_soul", instant = true })
            end
        end
    end
end

--Slime Secretion/Mystic Secretion #110/#112------------------------------------------------------------------------------------------------------------
function this.slimeSecretion(ref, modData)
    --Slime Secretion
    local selection = math.random(1, #tables.commonSlimes)
    tes3.addItem({ item = tables.commonSlimes[selection], reference = tes3.player })

    local slime = tes3.getObject(tables.commonSlimes[selection])
    func.clMessageBox("" .. ref.object.name .. " secreted " .. slime.name .. ".")

    --Mystic Secretion
    if modData.abilities[112] == true then
        if math.random(1, 3) == 3 then --33%
            local selection2 = math.random(1, #tables.rareSlimes)
            tes3.addItem({ item = tables.rareSlimes[selection2], reference = tes3.player })

            local slime2 = tes3.getObject(tables.rareSlimes[selection2])
            func.clMessageBox("" .. ref.object.name .. " also secreted " .. slime2.name .. "!")
        end
    end
end

--Pace #113---------------------------------------------------------------------------------------------------------------------------------------
function this.pace(e)
    log:trace("Pace triggered.")

    local creTable = func.creTable()
    local trigger = 0

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[113] then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        if e.cell.isOrBehavesAsExterior then
            local partyTable = func.partyTable()

            if e.cell.restingIsIllegal == false then
                for i = 1, #partyTable do
                    local affected = tes3.isAffectedBy({ reference = partyTable[i], object = "kl_spell_pace" })
                    if not affected then
                        tes3.cast({ reference = partyTable[i], target = partyTable[i], spell = "kl_spell_pace", instant = true, bypassResistances = true })
                    end
                end
                log:debug("Pace bestowed upon party.")
            end
        end
    end
end

--Split Second #115-------------------------------------------------------------------------------------------------------------------------------------
function this.splitSecond(e)

    if config.combatAbilities == false then return false end
    log:trace("Split second triggered.")

    if e.attacker then
        if e.mobile == tes3.mobilePlayer or func.validCompanionCheck(e.mobile) then
            if e.mobile.health.current <= e.damage then
                if tes3.getWorldController().flagTeleportingDisabled then
                    func.clMessageBox(tes3.findGMST("sTeleportDisabled").value)
                    return false
                end
                local creTable = func.creTable()
                for i = 1, #creTable do
                    local modData = func.getModData(creTable[i])
                    if modData.abilities[115] == true then
                        local town = tes3.findClosestExteriorReferenceOfObject { object = "TravelMarker", position = tes3.getLastExteriorPosition() }
                        if func.spendTP(creTable[i], 4) == false then
                            return false
                        end
                        local msg = ""
                        if e.mobile == creTable[i].mobile then
                            msg = "" .. creTable[i].object.name .. " saved themselves from death!"
                        else
                            msg = "" .. creTable[i].object.name .. " saved " .. e.mobile.object.name .. " from death!"
                        end

                        timer.start({ duration = 0.4, type = timer.simulate, callback = function()
                            tes3.playSound({ soundPath = "companionLeveler\\footsteps.wav" })
                            tes3.positionCell { reference = tes3.player, cell = town.cell, position = town.position, orientation = town.orientation, forceCellChange = true }
                            tes3.setStatistic({ name = "fatigue", current = -10, reference = creTable[i] })
                            func.clMessageBox(msg)
                            log:debug("Split Second succeeded.")
                        end})
                        return true --blocked
                    end
                end
            end
        end
    end
end


--Guild-Trained---------------------------------------------------------------------------------------------------------------------

--Mages Guild 1: Fortify Maximum Magicka 1.8x, +2 TP

--Fighters Guild
function this.fightersGuildCre(e)
    
    if config.combatAbilities == false then return 0 end
    log:trace("Fighters Guild training triggered.")

    local num = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType ~= 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.guildTraining and (modData.guildTraining[1] == tables.factions[2] or modData.guildTraining[2] == tables.factions[2]) then
                num = math.random(1, 4)
                log:debug("Fighters Guild creature: " .. num .. " damage added.")
            end
        end
    end

    return num
end

--Blades
function this.bladesCre(ref)
    
    if config.triggeredAbilities == false then return end
    log:trace("Blades creature training triggered.")

    local modData = func.getModData(ref)

    if modData.level % 2  == 0 then
        func.modStatAndTrack("attribute", tes3.attribute.speed, 1, ref, modData)
        func.clMessageBox("" .. ref.object.name .. "'s Blades training increased Speed by 1.")
    end
    if modData.level % 3 == 0 then
        func.modStatAndTrack("attribute", tes3.attribute.agility, 1, ref, modData)
        func.clMessageBox("" .. ref.object.name .. "'s Blades training increased Agility by 1.")
    end

    log:debug("Blades training applied to " .. ref.object.name .. ".")
end

--House Redoran
function this.lament(e)
    if config.combatAbilities == false then return end

    
    log:trace("Lament of Ash triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            if string.startswith(actor.object.id, "ash_") or (actor.object.type and actor.object.type == 3) then
                local creTable = func.creTable()

                for i = 1, #creTable do
                    local reference = creTable[i]
                    local modData = func.getModData(reference)

                    if modData.guildTraining then
                        if modData.guildTraining[1] == tables.factions[8] or modData.guildTraining[2] == tables.factions[8] then
                            log:debug("" .. reference.object.name .. " spotted an Ash creature!")

                            local affected = tes3.isAffectedBy({ reference = reference, object = "kl_spell_lament" })

                            if not affected then
                                tes3.cast({ reference = reference, target = reference, spell = "kl_spell_lament", instant = true, bypassResistances = true })

                                log:debug("" .. reference.object.name .. " is overcome with fury!")
                                if config.bMessages == true then
                                    func.clMessageBox("" .. reference.object.name .. " is overcome with fury at the sight of the Ash Creature!")
                                end
                            else
                                log:debug("" .. reference.object.name .. " is already affected by Lament of Ash.")
                            end
                        end
                    end
                end
            end
        end
	end
end

--Morag Tong
function this.tongCre(e)
    
    if config.combatAbilities == false then return end
    log:trace("Tong training triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType ~= 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.guildTraining then
                if modData.guildTraining[1] == tables.factions[10] or modData.guildTraining[2] == tables.factions[10] then
                    --Crit Chance
                    if math.random(1, 20) == 20 then
                        answer = math.round(e.damage * 0.40)
                        tes3.playSound({ sound = "critical damage", reference = e.mobile.reference, volume = 0.8, pitch = 0.8 })
                        log:debug("Tong training critical!")
                    end
                end
            end
        end
    end

    return answer
end

--Imperial Legion
function this.legionCre(e)
    if config.triggeredAbilities == false then return end

    
    log:trace("Legion training triggered.")

    if e.count > 0 then
        local creTable = func.creTable()

        for i = 1, #creTable do
            local reference = creTable[i]
            local modData = func.getModData(reference)

            if modData.guildTraining then
                if modData.guildTraining[1] == tables.factions[11] or modData.guildTraining[2] == tables.factions[11] then
                    --Prevent Ambush
                    e.count = 0
                    log:info("" .. reference.object.name .. " prevented an ambush.")
                    func.clMessageBox("" .. reference.object.name .. " prevented an ambush!")
                    break
                end
            end
        end
    end
end

--Census and Excise
function this.censusCre()
    
    log:trace("Census Training triggered.")

    if config.triggeredAbilities == false then
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_detectench2" })
        log:debug("Census Training removed from player.")
        return
    end

    local trigger = 0
    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.guildTraining then
            if modData.guildTraining[1] == tables.factions[12] or modData.guildTraining[2] == tables.factions[12] then
                trigger = 1
                break
            end
        end
    end

    if trigger == 1 then
        --Confer Aura
        tes3.addSpell({ reference = tes3.player, spell = "kl_ability_detectench2" })
        log:debug("Census Training added to player.")
    else
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_detectench2" })
        log:debug("Census Training removed from player.")
    end
end

--East Empire Company
function this.companyCre()
    
    log:trace("Company Training triggered.")

    local trigger = 0
    local creTable = func.creTable()
    local name = ""

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.guildTraining then
            if modData.guildTraining[1] == tables.factions[13] or modData.guildTraining[2] == tables.factions[13] then
                trigger = 1
                name = reference.object.name
                break
            end
        end
    end

    if trigger == 1 then
        --Detect Ore
        for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.container }) do
            if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
                if string.startswith(refe.object.id, "rock_glass") or string.startswith(refe.object.id, "rock_ebony") then
                    func.clMessageBox("" .. name .. " detects glass or ebony nearby.")
                    break
                end
            end
        end
    end
end

--Ashlanders
function this.ashlandCre(e)
    
    if config.combatAbilities == false then return end
    log:trace("Ashlander training triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType ~= 1 and e.mobile.object.objectType == tes3.objectType.creature then
            local modData = func.getModData(e.attacker.reference)
            if modData.guildTraining then
                if modData.guildTraining[1] == tables.factions[15] or modData.guildTraining[2] == tables.factions[15] then
                    answer = math.round(e.damage * 0.05)
                    log:debug("Ashland training bonus damage!")
                end
            end
        end
    end

    return answer
end

--House Dres
function this.dresCre(e)
    
    if config.combatAbilities == false then return end
    log:trace("Dres training triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType ~= 1 and e.mobile.object.race and e.mobile.object.race ~= "Dark Elf" then
            local modData = func.getModData(e.attacker.reference)
            if modData.guildTraining then
                if modData.guildTraining[1] == tables.factions[17] or modData.guildTraining[2] == tables.factions[17] then
                    answer = math.round(e.damage * 0.07)
                    log:debug("Dres training bonus damage!")
                end
            end
        end
    end

    return answer
end

--House Indoril
function this.indorilCre(e)
    if config.combatAbilities == false then return end

    
    log:trace("Indoril training triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local creTable = func.creTable()

        for i = 1, #creTable do
            local reference = creTable[i]
            local modData = func.getModData(reference)

            if modData.guildTraining then
                if modData.guildTraining[1] == tables.factions[18] or modData.guildTraining[2] == tables.factions[18] then

                    local affected = tes3.isAffectedBy({ reference = reference, object = "summon ancestral ghost" })

                    if not affected then
                        tes3.cast({ reference = reference, target = reference, spell = "summon ancestral ghost", instant = true, bypassResistances = true })
                        local affected2 = tes3.isAffectedBy({ reference = reference, object = "first barrier" })
                        if not affected2 then
                            tes3.cast({ reference = reference, target = reference, spell = "first barrier", instant = true, bypassResistances = true })
                        end
                        log:debug("" .. reference.object.name .. "'s Ancestral Ghost appeared!")
                    else
                        log:debug("" .. reference.object.name .. "'s Ghost is already here.")
                    end
                end
            end
        end
	end
end

--Astrological Society
function this.astroCre()
    
    log:trace("Astrological Training triggered.")

    local creTable = func.creTable()

    for i = 1, #creTable do
        local reference = creTable[i]
        local modData = func.getModData(reference)

        if modData.guildTraining then
            if modData.guildTraining[1] == tables.factions[20] or modData.guildTraining[2] == tables.factions[20] then
                --Remove Existing Effect(s)
                for n = 0, 12 do
                    tes3.removeSpell({ reference = reference, spell = "kl_ability_astroCre_" .. n .. "" })
                end

                local month = tes3.worldController.month.value

                --Apply New Effect
                if month >= 0 and month <= 11 then
                    tes3.addSpell({ reference = reference, spell = "kl_ability_astroCre_" .. month .. "" })
                    log:debug("Astrological training bestowed upon " .. reference.object.name .. ".")
                elseif month > 11 then
                    tes3.addSpell({ reference = reference, spell = "kl_ability_astroCre_12" })
                    log:debug("Astrological training bestowed upon " .. reference.object.name .. ".")
                end
            end
        end
    end
end


--
----NPC Abilities----------------------------------------------------------------------------------------------------------------------------------------------
--

--Learn Abilities-----------------------------------------------------------------------------------------------------------------
function this.npcAbilities(class, companionRef)
    
    local modData = func.getModData(companionRef)

    --Stendarr
    if modData.level % 3 == 0 then
        if modData.patron ~= nil then
            if modData.patron == 7 then
                this.stendarr(companionRef)
            end
        end
    end

    --Hermaeus Mora
    if modData.level % 2 ~= 0 then
        if modData.patron and modData.patron == 13 then
            modData.tp_max = modData.tp_max + 1
            modData.tp_current = modData.tp_current + 1
            func.clMessageBox("Insight, gleaned amongst tides of fate! " .. companionRef.object.name .. "'s Technique Points increase by 1.")
        end
    else
        --Namira
        if modData.patron and modData.patron == 21 then
            this.namiraTribute(companionRef)
        end
    end

    --Peryite
    if modData.patron and modData.patron == 23 then
        this.peryiteTribute(companionRef)
    end

    --Jyggalag
    if modData.orderStreak then
        if modData.class == modData.lastClass then
            modData.orderStreak = modData.orderStreak + 1
            if modData.orderStreak == 5 then
                modData.orderStreak = 1
				for i = 0, 7 do
					tes3.modStatistic({ attribute = i, value = 1, reference = companionRef })
				end
                timer.delayOneFrame(function()
                    timer.delayOneFrame(function()
                        timer.delayOneFrame(function()
                            func.updateIdealSheet(companionRef)
                            func.clMessageBox("" .. companionRef.object.name .. " walks the path of Order! All attributes increased by 1. Streak reset to 1.")
                        end)
                    end)
                end)
                tes3.applyMagicSource({
                    reference = companionRef,
                    name = "Perfect Order",
                    bypassResistances = true,
                    effects = {{ id = tes3.effect.light, duration = 3, min = 5, max = 5 }, },
                })
            end
        else
            modData.orderStreak = 1
            func.clMessageBox("" .. companionRef.object.name .. "'s Order Streak was broken! Streak reset to 1.")
        end
        modData.lastClass = modData.class
    end

    --Accountant
    if modData.rebate then
        if modData.rebate > 0 then
            tes3.addItem({ reference = tes3.player, item = "Gold_001", count = math.round(modData.rebate) })
            func.clMessageBox("" .. companionRef.object.name .. " saved you " .. math.round(modData.rebate) .. " gold this period.")
            modData.rebate = 0
        end
    end

    --Add Abilities--------------------------------------------------------------------------------------------------
    if modData.level % 5 == 0 then
        for i = 1, #tables.classesSpecial do
            if class == tables.classesSpecial[i] then
                local ability = tables.abListNPC[i]
                local spellObject = tes3.getObject(ability)

                local wasAdded = tes3.addSpell({ reference = companionRef, spell = ability })

                if wasAdded == true then
                    func.clMessageBox("" ..
                        companionRef.object.name .. " learned the " .. class .. " Ability " .. spellObject.name .. "!")
                    log:info("" .. companionRef.object.name .. " learned the Ability " .. ability .. ".")

                    tes3.playSound({ soundPath = "companionLeveler\\ability.wav", volume = 0.8 })
                    modData.abilities[i] = true


                    --Special--

                    --Potential (Commoner Class)
                    if spellObject.name == "Potential" then
                        local npcMode = require("companionLeveler.modes.npcClassMode")
                        local table = {
                            [1] = companionRef
                        }

                        timer.delayOneFrame(function()
                            timer.delayOneFrame(function()
                                timer.delayOneFrame(function()
                                    npcMode.levelUp(table)
                                    func.clMessageBox("" .. companionRef.object.name .. " unlocked their potential!")
                                end)
                            end)
                        end)
                    end

                    --Alter Self (Metamorph Class)
                    if spellObject.name == "Alter Self" then
                        func.removeAbilitiesNPC(companionRef)
                        tes3.addSpell({ reference = companionRef, spell = "kl_ab_npc_metamorph" })
                        modData.metamorph = true
                        modData.typelevels[1] = modData.level
                    end

                    --Multitask (Polymath Class)
                    if spellObject.name == "Multitask" then
                        for n = 0, 26 do
                            local num = 2
                            if config.aboveMaxSkill == false then
                                if companionRef.mobile:getSkillStatistic(n).base + num > 100 then
                                    num = math.max(100 - companionRef.mobile:getSkillStatistic(n).base, 0)
                                end
                            end
                            tes3.modStatistic({ skill = n, value = num, reference = companionRef })
                        end
                    end


                    --Factions--

                    --Deceptor (Infiltrator Class)
                    if spellObject.name == "Deceptor" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            fact.pickFaction(companionRef, 129)
                        end })
                    end

                    --Shed Regret (Exile Class)
                    if spellObject.name == "Shed Regret" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            fact.pickFaction(companionRef, 131)
                        end })
                    end

                    --Consul (Diplomat Class)
                    if spellObject.name == "Consul" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            fact.pickFaction(companionRef, 132)
                        end })
                    end

                    --Allegiance (Retainer Class)
                    if spellObject.name == "Allegiance" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            fact.pickFaction(companionRef, 133)
                        end })
                    end

                    --Friend With Benefits (Recruit Class)
                    if spellObject.name == "Friend With Benefits" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            fact.pickFaction(companionRef, 134)
                        end })
                    end


                    --Patrons--

                    --Sacrosanctus (Cleric Class)
                    if spellObject.name == "Sacrosanctus" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            pat.pickPatron(companionRef, 139)
                        end })
                    end

                    --Bloodlines--

                    --Vampirism (Sanguine Aspirant Class)
                    if spellObject.name == "Vampirism" then
                        timer.start({ type = timer.simulate, duration = 1, iterations = 1, callback = function()
                            line.pickBloodline(companionRef, 156)
                        end })
                    end

                    --TP--

                    --Battlemage
                    if spellObject.name == "Battle-Learned" then
                        modData.tp_max = modData.tp_max + 1
                    end

                    --Hermit
                    if spellObject.name == "Introspection" then
                        modData.tp_max = modData.tp_max + 1
                    end

                    --Pilgrim
                    if spellObject.name == "Enlightened" then
                        modData.tp_max = modData.tp_max + 1
                    end

                    --Wise Woman
                    if spellObject.name == "Wisdom of Ash" then
                        modData.tp_max = modData.tp_max + 1
                    end

                    --Sorcerer
                    if spellObject.name == "Forbidden Knowledge" then
                        modData.tp_max = modData.tp_max + 2
                    end

                    --Warlock
                    if spellObject.name == "Arcane Mastery" then
                        modData.tp_max = modData.tp_max + 5
                    end

                    --Clever-Man
                    if spellObject.name == "Northern Mysticism" then
                        modData.tp_max = modData.tp_max + 2
                    end


                    --Training Sessions--

                    --Drillmaster
                    if spellObject.name == "Gifted Instructor" then
                        modData.sessions_max = modData.sessions_max + 1
                    end

                    --Mod Data Stats
                    timer.delayOneFrame(function()
                        timer.delayOneFrame(function()
                            timer.delayOneFrame(function()
                                func.updateIdealSheet(companionRef)
                            end)
                        end)
                    end)
                else
                    log:debug("" .. companionRef.object.name .. " already has the " .. ability .. " Ability.")
                    func.clMessageBox("" ..
                        companionRef.object.name .. " already has the " .. spellObject.name .. " Ability.")
                end
            end
        end
    end
end

--Execute Learned Abilities-------------------------------------------------------------------------------------------------------
function this.executeAbilities(companionRef)
    if config.triggeredAbilities == false then return end
    if (tes3.mobilePlayer.inCombat == true or companionRef.mobile.inCombat == true) then return end

    
    log:trace("Execute Abilities function triggered on " .. companionRef.object.name .. ".")

    local attTable = companionRef.mobile.attributes
    local modData = func.getModData(companionRef)
    local class = tes3.findClass(modData.class)

    local alchemy = companionRef.mobile:getSkillStatistic(16)
    local speechcraft = companionRef.mobile:getSkillStatistic(25)
    local enchant = companionRef.mobile:getSkillStatistic(9)
    local mercantile = companionRef.mobile:getSkillStatistic(24)
    local armorer = companionRef.mobile:getSkillStatistic(1)
    local conjuration = companionRef.mobile:getSkillStatistic(13)
    local restoration = companionRef.mobile:getSkillStatistic(15)
    local sneak = companionRef.mobile:getSkillStatistic(19)
    local marksman = companionRef.mobile:getSkillStatistic(23)
    local mysticism = companionRef.mobile:getSkillStatistic(14)
    local security = companionRef.mobile:getSkillStatistic(18)

    --Acrobat reduces fall damage based on their Acrobatics. See #1 Acrobatic

    --Agent provides training in Sneak, Speechcraft, and Acrobatics. (See train.lua)

    --Assassin accepts a contract once per level. (See this.contract) #4 Opportunist

    --Barbarians become enraged when wounded. (See this.rage) #5 Inner Rage

    --Bards provide an inspiration buff with a chance at an encore. #6 Jack-of-all-Trades
    this.inspiration(companionRef, class, modData, speechcraft, false)

    --Crusaders confer a physical resistance aura to the party. (See this.resolve) #8 Resolve

    --Healers confer a regenerating aura to the party. (See this.blessed) #9 Blessed Aura

    --Scouts have a 3% chance at awarding 1 EXP when changing cells. (See this.survey) #16 Observation

    --Thief
    if (modData.abilities[19] == true or class.name == "Thief") then
        if tes3.player.cell.restingIsIllegal then
            if math.random(1, 140) < (((sneak.current + security.current) / 2) + modData.level) then
                local randNum = math.random(1, 10)
    
                --Steal something
                tes3.addItem({ item = tables.stolenGoods[randNum], reference = companionRef })
    
                local spoils = tes3.getObject(tables.stolenGoods[randNum])
                func.clMessageBox("" ..
                    companionRef.object.name .. " \"procured\" an item. (" .. spoils.name .. ").")
            end
        end
    end

    --Apothecary
    if (modData.abilities[23] == true or class.name == "Apothecary") then
        if math.random(1, 150) < (alchemy.current + modData.level) then
            --Brew a potion
            if (alchemy.current > 0 and alchemy.current < 25) then
                local selection = math.random(1, #tables.alchemyPotionsB)
                tes3.addItem({ item = tables.alchemyPotionsB[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.alchemyPotionsB[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a weak potion. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 25 and alchemy.current < 50) then
                local selection = math.random(1, #tables.alchemyPotionsC)
                tes3.addItem({ item = tables.alchemyPotionsC[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.alchemyPotionsC[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a cheap potion. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 50 and alchemy.current < 75) then
                local selection = math.random(1, #tables.alchemyPotionsS)
                tes3.addItem({ item = tables.alchemyPotionsS[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.alchemyPotionsS[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a decent potion. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 75 and alchemy.current < 100) then
                local selection = math.random(1, #tables.alchemyPotionsQ)
                tes3.addItem({ item = tables.alchemyPotionsQ[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.alchemyPotionsQ[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a quality potion! (" .. potion.name .. ")")
            end
            if alchemy.current >= 100 then
                local selection = math.random(1, #tables.alchemyPotionsE)
                tes3.addItem({ item = tables.alchemyPotionsE[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.alchemyPotionsE[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you an exquisite potion! (" .. potion.name .. ")")
            end
        end
    end

    --Drillmaster provides training in their class skills. (See train.lua)

    --Enchanters provide basic enchanting services and can fashion soul gems as techniques. (See this.techniques) #26 Power Reservoir

    --Hunter and Poacher
    if (modData.abilities[28] == true or class.name == "Hunter" or modData.abilities[75] == true or class.name == "Poacher") then
        if tes3.player.cell.restingIsIllegal  == false then
            if math.random(1, 130) < (marksman.current + modData.level) then
                local randNum = math.random(1, 16)
    
                --Give random meat/hide
                tes3.addItem({ item = tables.huntedMeat[randNum], reference = tes3.player })
    
                local spoils = tes3.getObject(tables.huntedMeat[randNum])
                func.clMessageBox("" ..
                    companionRef.object.name .. " shared some extra " .. spoils.name .. " with you.")
            end
        end
    end

    --Merchants train companions in Mercantile. (See train.lua)

    --Necromancer can raise undead minions as a technique. (see techniques.lua) #30 Dark Appetite

    --Priest
    if (modData.abilities[31] == true or class.name == "Priest") then
        local party = func.partyTable()
        local mod = restoration.current
        if mod > 300 then
            mod = 300
        end
        if mod < 5 then
            mod = 5
        end
        local dur = 120 + (mod * 4)
        local eighth = math.round(mod / 8)
        local sixth = math.round(mod / 6)
        local fourth = math.round(mod / 4)

        --Bless the party
        for i = 1, #party do
            local reference = party[i]

            if mod < 25 then
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Novice Blessing",
                    effects = {
                        { id = tes3.effect.fortifyAttribute, attribute = math.random(0, 7),
                            duration = dur,
                            min = eighth,
                            max = sixth },
                    },
                })
            end
            if (mod >= 25 and mod < 50) then
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Blessing of the Apprentice",
                    effects = {
                        { id = tes3.effect.fortifyAttribute, attribute = math.random(0, 7),
                            duration = dur,
                            min = eighth,
                            max = sixth }, { id = tes3.effect.resistCommonDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth },
                    },
                })
            end
            if (mod >= 50 and mod < 75) then
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Blessing of the Adept",
                    effects = {
                        { id = tes3.effect.fortifyAttribute, attribute = math.random(0, 7),
                            duration = dur,
                            min = eighth,
                            max = sixth }, { id = tes3.effect.resistCommonDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth }, { id = tes3.effect.resistBlightDisease,
                            duration = dur,
                            min = sixth,
                            max = math.round(mod / 5) },
                    },
                })
            end
            if (mod >= 75 and mod < 100) then
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Expert Blessing",
                    effects = {
                        { id = tes3.effect.fortifyAttribute, attribute = math.random(0, 7),
                            duration = dur,
                            min = eighth,
                            max = sixth }, { id = tes3.effect.resistCommonDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth }, { id = tes3.effect.resistBlightDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth }, { id = tes3.effect.fortifyAttack,
                            duration = dur,
                            min = math.round(mod / 20),
                            max = math.round(mod / 15) },
                    },
                })
            end
            if mod >= 100 then
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Blessing of the Divine",
                    effects = {
                        { id = tes3.effect.fortifyAttribute, attribute = math.random(0, 7),
                            duration = dur,
                            min = eighth,
                            max = sixth }, { id = tes3.effect.resistCommonDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth }, { id = tes3.effect.resistBlightDisease,
                            duration = dur,
                            min = sixth,
                            max = fourth }, { id = tes3.effect.fortifyAttack,
                            duration = dur,
                            min = math.round(mod / 20),
                            max = math.round(mod / 15) }, { id = tes3.effect.fortifyHealth,
                            duration = dur,
                            min = sixth,
                            max = sixth },
                    },
                })
            end
        end
        func.clMessageBox("" .. companionRef.object.name .. " conferred a blessing to the party.")
    end

    --Savant
    if (modData.abilities[32] == true or class.name == "Savant") then
        local value = 1
        local randSkill = math.random(0, 26)

        if modData.aboveMaxSkill == false then
            local skillStat = tes3.player.mobile:getSkillStatistic(randSkill)
            if skillStat.base + value > 100 then
                value = math.max(100 - skillStat.base, 0)
            end
        end

        --Level random skill
        if math.random(1, 150) < (((attTable[2].current + speechcraft.current) / 2) + modData.level) then
            tes3.modStatistic({ skill = randSkill, value = value, reference = tes3.player })
            func.clMessageBox("" .. companionRef.object.name .. " lectured you on " .. tes3.getSkillName(randSkill) .. ".")
        end
    end

    --Smith
    if (modData.abilities[35] == true or class.name == "Smith") then
        local party = func.partyTable()
        local amount = math.round(armorer.current / 2)

        for i = 1, #party do
            local reference = party[i]

            --Reinforce Armor
            for id, slot in pairs(tes3.armorSlot) do
                local armor = tes3.getEquippedItem {
                    actor = reference,
                    objectType = tes3.objectType.armor,
                    slot = slot
                }
                if armor then
                    armor.variables.condition = armor.variables.condition + amount
                end
            end

            --Reinforce Weapon
            local weapon = tes3.getEquippedItem {
                actor = reference,
                objectType = tes3.objectType.weapon,
            }
            if weapon and weapon.variables then
                weapon.variables.condition = weapon.variables.condition + amount
            end
        end

        func.clMessageBox("" ..
            companionRef.object.name .. " reinforced the party's equipment by " .. amount .. ".")
    end

    --Smuggler
    if (modData.abilities[36] == true or class.name == "Smuggler") then
        local amount = math.round(((modData.level + security.current) * 2.5))

        --Generate Gold
        tes3.addItem({ reference = tes3.player, item = "Gold_001", count = amount })
        func.clMessageBox("" .. companionRef.object.name .. " shared a cut of their profits with you. (" .. amount .. " Gold)")
    end

    --Archaeologist digs artifacts up as a technique. (see techniques.lua) #41 Archaeological Inclination

    --Artificer can create constructs as a technique. (see techniques.lua) #42 Skilled Artificer

    --Artisan
    if (modData.abilities[43] == true or class.name == "Artisan") then
        if math.random(1, 150) < (armorer.current + modData.level) then
            --Fashion a tool
            if (armorer.current > 0 and armorer.current < 25) then
                local selection = math.random(1, #tables.artisanTools)
                tes3.addItem({ item = tables.artisanTools[selection], reference = companionRef })

                local tool = tes3.getObject(tables.artisanTools[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " fashioned you a basic tool. (" .. tool.name .. ")")
            end
            if (armorer.current >= 25 and armorer.current < 50) then
                local selection = math.random(1, #tables.artisanTools2)
                tes3.addItem({ item = tables.artisanTools2[selection], reference = companionRef })

                local tool = tes3.getObject(tables.artisanTools2[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " fashioned you a decent tool. (" .. tool.name .. ")")
            end
            if (armorer.current >= 50 and armorer.current < 75) then
                local selection = math.random(1, #tables.artisanTools3)
                tes3.addItem({ item = tables.artisanTools3[selection], reference = companionRef })

                local tool = tes3.getObject(tables.artisanTools3[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " fashioned you a useful tool. (" .. tool.name .. ")")
            end
            if (armorer.current >= 75 and armorer.current < 100) then
                local selection = math.random(1, #tables.artisanTools4)
                tes3.addItem({ item = tables.artisanTools4[selection], reference = companionRef })

                local tool = tes3.getObject(tables.artisanTools4[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " fashioned you a well-made tool. (" .. tool.name .. ")")
            end
            if armorer.current >= 100 then
                local selection = math.random(1, #tables.artisanTools5)
                tes3.addItem({ item = tables.artisanTools5[selection], reference = companionRef })

                local tool = tes3.getObject(tables.artisanTools5[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " fashioned you an artisan tool. (" .. tool.name .. ")")
            end
        end
    end

    --Baker
    if (modData.abilities[44] == true or class.name == "Baker") then
        local modList = tes3.getModList()
        local list = tables.bakedGoods

        for i, v in pairs(modList) do
            if v == "Tamriel_Data.esm" then
                list = tables.bakedGoodsTR
                break
            end
        end

        local item = list[math.random(1, #list)]

        --Provide Baked Goods
        tes3.addItem({ item = item, reference = companionRef })

        local food = tes3.getObject(item)
        func.clMessageBox("" ..
            companionRef.object.name .. " provided some food. (" .. food.name .. ")")
    end

    --Barrister
    if (modData.abilities[45] == true or class.name == "Barrister") then
        local bounty = tes3.mobilePlayer.bounty

        --Do lawyer things
        if math.random(1, 140) < (speechcraft.current + modData.level) then
            if bounty > 0 then
                if bounty < 2000 then
                    tes3.mobilePlayer.bounty = (bounty / 1.5)
                else
                    tes3.mobilePlayer.bounty = (bounty - 700)
                end
                func.clMessageBox("" .. companionRef.object.name .. " reduced your bounty through a legal loophole!")
            end
        end
    end

    --Battle Alchemist
    if (modData.abilities[46] == true or class.name == "Battle Alchemist") then
        if math.random(1, 140) < (alchemy.current + modData.level) then
            --Brew a potion
            if (alchemy.current > 0 and alchemy.current < 25) then
                local selection = math.random(1, #tables.poisonsB)
                tes3.addItem({ item = tables.poisonsB[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.poisonsB[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a weak poison. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 25 and alchemy.current < 50) then
                local selection = math.random(1, #tables.poisonsC)
                tes3.addItem({ item = tables.poisonsC[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.poisonsC[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a cheap poison. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 50 and alchemy.current < 75) then
                local selection = math.random(1, #tables.poisonsS)
                tes3.addItem({ item = tables.poisonsS[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.poisonsS[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a decent poison. (" .. potion.name .. ")")
            end
            if (alchemy.current >= 75 and alchemy.current < 100) then
                local selection = math.random(1, #tables.poisonsQ)
                tes3.addItem({ item = tables.poisonsQ[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.poisonsQ[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you a quality poison! (" .. potion.name .. ")")
            end
            if alchemy.current >= 100 then
                local selection = math.random(1, #tables.poisonsE)
                tes3.addItem({ item = tables.poisonsE[selection], reference = tes3.player })

                local potion = tes3.getObject(tables.poisonsE[selection])
                func.clMessageBox("" ..
                    companionRef.object.name .. " brewed you an exquisite poison! (" .. potion.name .. ")")
            end
        end
    end

    --Pearl Diver
    if (modData.abilities[47] == true or class.name == "Pearl Diver") then
        if tes3.player.cell.restingIsIllegal  == false then
            if math.random(1, 140) < (attTable[8].current + modData.level) then
                --Find a Pearl
                tes3.addItem({ item = "ingred_pearl_01", reference = companionRef })
                func.clMessageBox("" .. companionRef.object.name .. " found a Pearl.")
            end
        end
    end

    --Beastmaster can train creature companions as a technique. (See beast.lua) #48 Beast Whisperer

    --Bookseller gives another skill point when you read skill books. (See this.comprehension) #49 Reading Comprehension

    --Courtesan
    if (modData.abilities[50] == true or class.name == "Courtesan") then

        --Stand there and look pretty
        tes3.applyMagicSource({
            reference = tes3.player,
            name = "Good Company",
            bypassResistances = true,
            effects = {
                { id = tes3.effect.fortifyAttribute, attribute = 6,
                    duration = (math.random(120, 180) + (attTable[7].current * 3)),
                    min = (modData.level / 2),
                    max = modData.level },
            },
        })
        func.clMessageBox("" .. companionRef.object.name .. "'s charm rubbed off on you.")
    end

    --Farmer and Gardener
    if (
        modData.abilities[52] == true or modData.abilities[53] == true or class.name == "Farmer" or
            class.name == "Gardener") then
        local randNum = math.random(1, 41)

        --Find random plants
        tes3.addItem({ item = tables.plants[randNum], reference = companionRef })

        local spoils = tes3.getObject(tables.plants[randNum])
        func.clMessageBox("" ..
            companionRef.object.name .. " gathered a plant. (" .. spoils.name .. ")")
    end

    --Journalist
    if (modData.abilities[58] == true or class.name == "Journalist") then
        if tes3.player.cell.restingIsIllegal  == true then
            if math.random(10, 160) < (speechcraft.current + modData.level) then
                --Write article
                tes3.runLegacyScript {
                    reference = tes3.player,
                    command = "ModReputation 1"
                }
                func.clMessageBox("" .. companionRef.object.name .. "'s article increased your reputation!")
            end
        end
    end

    --Master-at-Arms can train NPC party members in weapon skills as a technique. (see train.lua)

    --Miner/Ore Miner
    if (modData.abilities[62] == true or class.name == "Miner" or modData.abilities[74] == true or class.name == "Ore Miner") then
        if tes3.player.cell.restingIsIllegal  == false then
            if math.random(1, 185) < (attTable[6].current + modData.level) then
                local modList = tes3.getModList()
                local list = tables.ore
    
                for i, v in pairs(modList) do
                    if v == "Tamriel_Data.esm" then
                        list = tables.TRore
                        break
                    end
                end

                local item = list[math.random(1, #list)]
    
                --Mine something
                tes3.addItem({ item = item, reference = companionRef })
    
                local spoils = tes3.getObject(item)
                func.clMessageBox("" ..
                    companionRef.object.name .. " seems to have mined some " .. spoils.name .. ".")
            end
        end
    end

    --Pawnbroker/Trader
    if (modData.abilities[66] == true or class.name == "Pawnbroker" or modData.abilities[69] == true or class.name == "Trader") then
        if tes3.player.cell.restingIsIllegal then
            if math.random(1, 140) < (mercantile.current + modData.level) then
                --Buy from leveled lists
                local item
                repeat
                    local randNum = math.random(1, 18)
                    log:debug("Trade List #" .. randNum .. " chosen.")
                    item = tes3.getObject(tables.tradeLists[randNum]):pickFrom()
                until (item ~= nil)
                local price = math.round(item.value * (1 - ((mercantile.current + 10) / 350)))
    
                local removedCount = tes3.removeItem({ reference = companionRef, item = "Gold_001", count = price, playSound = false })
                if removedCount < price then
                    tes3.addItem({ reference = companionRef, item = "Gold_001", count = removedCount, playSound = false })
                    func.clMessageBox("" .. companionRef.object.name .. " tried to buy " .. item.name .. " for " .. price .. ", but didn't have enough gold.")
                else
                    tes3.addItem({ reference = companionRef, item = item.id, count = 1 })
                    func.clMessageBox("" .. companionRef.object.name .. " bought " .. item.name .. " for " .. price .. " gold.")
                end
            end
        end
    end

    --Publican
    if (modData.abilities[67] == true or class.name == "Publican") then
        local modList = tes3.getModList()
        local list = tables.drinks

        for i, v in pairs(modList) do
            if v == "Tamriel_Data.esm" then
                list = tables.TRdrinks
                break
            end
        end

        local item = list[math.random(1, #list)]

        --Serve drink
        tes3.addItem({ item = item, reference = tes3.player })

        local drink = tes3.getObject(item)
        func.clMessageBox("" ..
            companionRef.object.name .. " served you some " .. drink.name .. ".")
    end

    --Commoner gives an additional level once their class ability is learned. (See this.npcAbilities) #70 Potential

    --Gambler
    if (modData.abilities[71] == true or class.name == "Gambler") then
        if tes3.player.cell.restingIsIllegal then
            --Gamble
            local randNum = (math.random(10, 300) + (modData.level * 20))
            local removedCount = tes3.removeItem({ reference = companionRef, item = "Gold_001", count = randNum, playSound = true })
            if removedCount > 0 then
                if math.random(10, 175) < attTable[8].current then
                    --Success
                    local winnings = math.round(removedCount * (((attTable[8].current + 10) / 350) + math.random()))
                    tes3.addItem({ reference = companionRef, item = "Gold_001", count = (removedCount + winnings), playSound = true })
                    func.clMessageBox("" .. companionRef.object.name .. " won " .. winnings .. " gold from their last gambling session.")
                else
                    --Failure
                    func.clMessageBox("" .. companionRef.object.name .. " lost " .. removedCount .. " gold from their last gambling session.")
                end
            else
                func.clMessageBox("" .. companionRef.object.name .. " had no gold to gamble with.")
            end
        end
    end

    --Herders will placate most wild guars and netch, setting their fight to zero. (See this.tranquility) #72 Tranquility

    --Jesters demoralize humanoid enemies, reducing their Luck and Agility. (See this.jest) #73 Jester's Privilege

    --Thaumaturges reduce enemies' Fire, Frost, and Shock resistances. (See this.thaumaturgy) #80 Thaumaturgy

    --Shaman
    if (modData.abilities[83] == true or class.name == "Shaman") then
        --Restore Magicka
        tes3.applyMagicSource({
            reference = tes3.player,
            name = "Trance",
            effects = {
                { id = tes3.effect.restoreMagicka,
                    duration = (math.random(10, 30) + (mysticism.current * 2)),
                    min = 1,
                    max = 1 },
            },
        })
        func.clMessageBox("" .. companionRef.object.name .. " imbued you with aetherial energy!")
    end

    --Summoner
    if (modData.abilities[87] == true or class.name == "Summoner") then
        --Summon a free minion
        if (conjuration.current > 0 and conjuration.current < 25) then
            tes3.applyMagicSource({
                reference = companionRef,
                name = "Summoned Scamp",
                effects = {
                    { id = tes3.effect.summonScamp,
                        duration = (math.random(120, 180) + (conjuration.current * 3))
                    },
                }
            })
            func.clMessageBox("" .. companionRef.object.name .. " summoned a Scamp.")
        end
        if (conjuration.current >= 25 and conjuration.current < 50) then
            tes3.applyMagicSource({
                reference = companionRef,
                name = "Summoned Clannfear",
                effects = {
                    { id = tes3.effect.summonClannfear,
                        duration = (math.random(120, 180) + (conjuration.current * 3))
                    },
                }
            })
            func.clMessageBox("" .. companionRef.object.name .. " summoned a Clannfear.")
        end
        if (conjuration.current >= 50 and conjuration.current < 75) then
            local choice
            local randNum = math.random(1, 3)

            if randNum == 1 then
                choice = tes3.effect.summonFlameAtronach
            elseif (randNum == 2) then
                choice = tes3.effect.summonFrostAtronach
            elseif (randNum == 3) then
                choice = tes3.effect.summonStormAtronach
            end

            tes3.applyMagicSource({
                reference = companionRef,
                name = "Summoned Atronach",
                effects = {
                    { id = choice,
                        duration = (math.random(120, 180) + (conjuration.current * 4))
                    },
                }
            })
            func.clMessageBox("" .. companionRef.object.name .. " summoned an Atronach.")
        end
        if (conjuration.current >= 75 and conjuration.current < 100) then
            local choice
            local randNum = math.random(1, 3)

            if randNum == 1 then
                choice = tes3.effect.summonHunger
            elseif (randNum == 2) then
                choice = tes3.effect.summonDaedroth
            elseif (randNum == 3) then
                choice = tes3.effect.summonWingedTwilight
            end

            tes3.applyMagicSource({
                reference = companionRef,
                name = "Summoned Greater Daedra",
                effects = {
                    { id = choice,
                        duration = (math.random(120, 180) + (conjuration.current * 4))
                    },
                }
            })
            func.clMessageBox("" .. companionRef.object.name .. " summoned a greater Daedra.")
        end
        if conjuration.current >= 100 then
            tes3.applyMagicSource({
                reference = companionRef,
                name = "Summoned Golden Saint",
                effects = {
                    { id = tes3.effect.summonGoldenSaint,
                        duration = (math.random(120, 180) + (conjuration.current * 5))
                    },
                }
            })
            func.clMessageBox("" .. companionRef.object.name .. " summoned a Golden Saint!")
        end
    end

    --Plagueherald spreads diseases they carry to enemies. (see this.inoculate) #96 Patient Zero

    --Bounty Hunter accepts bounties once per level. (see this.bounty) #97 Citizen's Arrest

    --Scribe
    if (modData.abilities[98] == true or class.name == "Scribe") then
        if math.random(1, 140) < (enchant.current + modData.level) then
            --Compile a scroll
            if (enchant.current > 0 and enchant.current < 25) then
                local selection = math.random(1, 7)
                tes3.addItem({ item = tables.scrolls[selection], reference = companionRef })

                local scroll = tes3.getObject(tables.scrolls[selection])
                func.clMessageBox("" .. companionRef.object.name .. " compiled a " .. scroll.name .. ".")
            end
            if (enchant.current >= 25 and enchant.current < 50) then
                local selection = math.random(1, 24)
                tes3.addItem({ item = tables.scrolls[selection], reference = companionRef })

                local scroll = tes3.getObject(tables.scrolls[selection])
                func.clMessageBox("" .. companionRef.object.name .. " compiled a " .. scroll.name .. ".")
            end
            if (enchant.current >= 50 and enchant.current < 75) then
                local selection = math.random(1, 45)
                tes3.addItem({ item = tables.scrolls[selection], reference = companionRef })

                local scroll = tes3.getObject(tables.scrolls[selection])
                func.clMessageBox("" .. companionRef.object.name .. " compiled a " .. scroll.name .. ".")
            end
            if (enchant.current >= 75 and enchant.current < 100) then
                local selection = math.random(1, 76)
                tes3.addItem({ item = tables.scrolls[selection], reference = companionRef })

                local scroll = tes3.getObject(tables.scrolls[selection])
                func.clMessageBox("" .. companionRef.object.name .. " compiled a " .. scroll.name .. ".")
            end
            if enchant.current >= 100 then
                local selection = math.random(1, 91)
                tes3.addItem({ item = tables.scrolls[selection], reference = companionRef })

                local scroll = tes3.getObject(tables.scrolls[selection])
                func.clMessageBox("" .. companionRef.object.name .. " compiled a " .. scroll.name .. ".")
            end
        end
    end

    --Silver Hand gets a buff when fighting werewolves. (see this.requiem) #99 Moonlight Requiem

    --Poet
    if (modData.abilities[100] == true or class.name == "Poet") then
        local value = 1

        if modData.aboveMaxSkill == false then
            local skillStat = tes3.player.mobile:getSkillStatistic(25)
            if skillStat.base + value > 100 then
                value = math.max(100 - skillStat.base, 0)
            end
        end

        --Teach Speechcraft
        if math.random(1, 140) < (speechcraft.current + modData.level) then
            tes3.modStatistic({ skill = 25, value = value, reference = tes3.player })
            func.clMessageBox("" .. companionRef.object.name .. " gave an epiphanic verse which taught you a bit about Speechcraft.")
        end
    end

    --Diresingers exhaust enemies through woeful songs. (see this.dirge) #101 Dirge

    --Banker
    if (modData.abilities[102] == true or class.name == "Banker") then
        if tes3.player.cell.restingIsIllegal then
            if math.random(0, 150) < mercantile.current then
                local count = tes3.getItemCount({ reference = companionRef, item = "Gold_001" })
                local percentage = mercantile.current / 1250
                if percentage > 0.1 then
                    percentage = 0.1
                end
                local amount = math.round(count * percentage)
    
                --Generate Gold Interest
                tes3.addItem({ reference = companionRef, item = "Gold_001", count = amount })
                func.clMessageBox("" .. companionRef.object.name .. " generated " .. amount .. " gold in interest.")
            end
        end
    end

    --Vampire Hunters get buffs when fighting vampires. (see this.elegy) #103 Sanguine Elegy

    --Druids sometimes charm enemy creatures. (see this.communion) #107 Natural Communion

    --Rangers detect nearby creatures. (see this.track) #108 Experienced Tracker

    --Succubus deals extra damage to males. (see this.maneater) #109 Maneater

    --Incubus deals extra damage to females. (see this.ladykiller) #110 Lady Killer

    --Vagabonds prevent rest interruption. (see this.cunning) #111 Vagabond's Cunning

    --Scavenger
    if (modData.abilities[112] == true or class.name == "Scavenger") then
        if tes3.player.cell.restingIsIllegal  == false then
            if math.random(1, 120) < attTable[8].current then
                local randNum = math.random(1, #tables.scavengeList)
                local list = tables.scavengeList[randNum]
                local item = list[math.random(1, #list)]

                --Scavenge random items
                tes3.addItem({ item = item, reference = companionRef })

                local spoils = tes3.getObject(item)
                func.clMessageBox("" .. companionRef.object.name .. " scavenged something from nearby. (" .. spoils.name .. ")")
            end
        end
    end

    --Ninja can escape from most dungeons. (see techniques.lua) #113 Shinobi

    --Fisherman
    if (modData.abilities[114] == true or class.name == "Fisherman") then
        local cell = tes3.getPlayerCell()

        if (cell.restingIsIllegal  == false and cell.displayName ~= "Ashlands Region" and cell.displayName ~= "Red Mountain Region" and cell.displayName ~= "Molag Amur Region") then
            local modList = tes3.getModList()
            local list = tables.fish

			for i, v in pairs(modList) do
				if v == "abotWaterLife.esm" then
                    list = tables.abotFish
                    break
                end
            end

            local item = list[math.random(1, #list)]

            --Gather Aquatic Item
            tes3.addItem({ item = item, reference = companionRef })

            local spoils = tes3.getObject(item)
            func.clMessageBox("" .. companionRef.object.name .. " fished something up. (" .. spoils.name .. ")")
        end
    end

    --Arcanists can transfer magicka back and forth between themselves and the player. (see techniques.lua) #115 Mystic Conduit


    --Egg Miner
    if (modData.abilities[146] == true or class.name == "Egg Miner") then
        --e g g
        local num = math.random(1, 2)
        local obj = tes3.getObject("food_kwama_egg_0" .. num)
        tes3.addItem({ item = obj.id, reference = tes3.player })
        func.clMessageBox("" .. companionRef.object.name .. " provided you with a " .. obj.name .. ".")
    end

    --Ratcatcher
    if (modData.abilities[152] == true or class.name == "Ratcatcher") then
        --yummy rat
        local obj = tes3.getObject("ingred_rat_meat_01")
        tes3.addItem({ item = obj.id, reference = tes3.player })
        func.clMessageBox("" .. companionRef.object.name .. " shared some " .. obj.name .. " with you.")
    end

    --Wandering Artist works with painting skill?

    --clothier can maybe make clothes/make them warmer or increase enchant capacity?

    --cook can maybe make ashfall type cooked goods

    --cat-catcher enslaves NPC enemies when they are heavily wounded Personality/Willpower? probably something else

    --guild guide can teleport as a service
end


--Acrobatic #1-----------------------------------------------------------------------------------------------------------------------
function this.acrobatic(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Acrobatic triggered.")

    if e.mobile then
        local npcTable = func.npcTable()
        local trigger = 0
        local mobile

        for i = 1, #npcTable do
            local modData = func.getModData(npcTable[i])

            if modData.abilities[1] then
                trigger = 1
                mobile = npcTable[i].mobile
                break
            end
        end

        if trigger == 1 then
            if (func.validCompanionCheck(e.mobile) and e.mobile.actorType == 1) or (e.mobile == tes3.mobilePlayer) then
                log:debug("Current fall damage: " .. e.damage .. ".")

                --Fall Damage Reduction
                local acrobatics = mobile:getSkillStatistic(20)
                local reduction = acrobatics.current

                if e.mobile ~= mobile then
                    --Other Party Member
                    reduction = math.round(acrobatics.current * 0.5)
                end

                if reduction > 100 then
                    reduction = 100
                elseif reduction < 0 then
                    reduction = 0
                end

                e.damage = math.round(e.damage * (1 - (reduction * 0.01)))
                log:debug("" .. e.mobile.object.name .. "'s fall damage reduced to " .. e.damage .. ".")
            end
        end
    end

    return e.damage
end

--Opportunist #4---------------------------------------------------------------------------------------------------------------------
function this.contract(reference)
    
    log:trace("Contract check triggered on " .. reference.object.name .. ".")

    local modData = func.getModData(reference)

    if (modData.abilities[4] == true or modData.class == "Assassin") then
        local temp = {}
        for obj in tes3.iterateObjects(tes3.objectType.npc) do
            temp[obj] = true
        end

        local list = {}
        for obj in pairs(temp) do
            list[#list+1] = obj
        end

        local choice

        repeat
            local check = true

            choice = list[math.random(1, #list)]

            if choice.name == "" then
                check = false
            else
                for n = 1, #tables.contractBlacklist do
                    if string.match(choice.name, tables.contractBlacklist[n]) then
                        check = false
                        break
                    end
                end
                if choice.sourceMod == nil or string.startswith(choice.sourceMod, "F&F") or string.startswith(choice.sourceMod, "Friends_and_Foes") then
                    check = false
                end
            end
        until (check == true)

        local amount = (choice.level * 100)

        if amount > 4000 then
            amount = 4000
        end

        local data = { choice.id, amount }

        table.insert(modData.contracts, data)

        func.clMessageBox("" .. reference.object.name .. " received a contract to kill " .. choice.name .. " for " .. amount .. " gold.")
        log:info("" .. reference.object.name .. " received a contract to kill " .. choice.name .. " for " .. amount .. " gold.")
    end
end

function this.contractKill(e)
    
    log:trace("Contract kill check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.contracts then
            for n = 1, #modData.contracts do
                log:trace("" .. reference.object.name .. "'s Contract List #" .. n .. ": " .. modData.contracts[n][1] .. "")
                local object = tes3.getObject(modData.contracts[n][1])

                if object.name == e.reference.object.name then
                    table.remove(modData.contracts, n)

                    local amount = (e.reference.object.level * 100)

                    if amount > 4000 then
                        amount = 4000
                    end

                    tes3.addItem({ reference = reference, item = "Gold_001", count = amount })
                    tes3.playSound({ sound = "Item Gold Down" })

                    func.clMessageBox("" .. reference.object.name .. " received a " .. amount .. " gold reward for " .. e.reference.object.name .. "'s death!")
                    log:info("" .. reference.object.name .. " received a " .. amount .. " gold reward for " .. e.reference.object.name .. "'s death!")
                end
            end
        end
    end
end

--Inner Rage #5--------------------------------------------------------------------------------------------------------------
function this.rage(e)
    if config.combatAbilities == false then return end
    
    log:trace("Inner Rage triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.mobile) and e.mobile.actorType == 1 then
            local modData = func.getModData(e.mobile.reference)

            if modData.abilities[5] then
                local threshold = .3 + (e.mobile.endurance.current / 200)

                if threshold > .8 then
                    threshold = .8
                end

                if e.mobile.health.normalized < threshold then
                    --Angery
                    local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_rage" })
                    if not affected then
                        tes3.cast({ reference = e.mobile, target = e.mobile, spell = "kl_spell_rage", instant = true })
                        log:debug("" .. e.mobile.object.name .. " became enraged!")
                        func.clMessageBox("" .. e.mobile.object.name .. " became enraged!")
                    end
                end
            end
        end
    end
end

--Jack-of-all-Trades #6------------------------------------------------------------------------------------------------------
function this.inspiration(companionRef, class, modData, speechcraft, encore)
    if (modData.abilities[6] == true or class.name == "Bard") then
        local party = func.partyTable()
        local attribute = math.random(0, 7)

        --Sing a song to the party
        for i = 1, #party do
            local reference = party[i]

            tes3.applyMagicSource({
                reference = reference,
                name = "Bardic Inspiration",
                bypassResistances = true,
                effects = {
                    { id = tes3.effect.fortifyAttribute, attribute = attribute,
                        duration = (math.random(120, 180) + (speechcraft.current * 5)),
                        min = math.round(modData.level / 3),
                        max = modData.level - 2 },
                },
            })
        end
        func.clMessageBox("" .. companionRef.object.name .. " sang an inspiring song of " .. tes3.attributeName[attribute] .. "!")

        --Encore
        if not encore and math.random(0, 199) < speechcraft.current then
            timer.start({ type = timer.game, duration = math.random(6, 12), iterations = 1, callback = function() func.clMessageBox("Encore!") this.inspiration(companionRef, class, modData, speechcraft, true) end })
        end
    end
end

--Resolve #8------------------------------------------------------------------------------------------------------------------
function this.resolve()
    
    log:trace("Resolve triggered.")

    local trigger = 0
    local npcTable = func.npcTable()
    local willpower

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[8] == true then
            trigger = 1
            willpower = reference.mobile.attributes[3]
            break
        end
    end

    if trigger == 1 then
        local partyTable = func.partyTable()

        for i = 1, #partyTable do
            --Confer Aura
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_01" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_02" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_03" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_04" })

            --25pts
            if willpower.current >= 25 and willpower.current < 50 then
                tes3.addSpell({ reference = partyTable[i], spell = "kl_ability_resolve_01" })
            end
            --50pts
            if willpower.current >= 50 and willpower.current < 75 then
                tes3.addSpell({ reference = partyTable[i], spell = "kl_ability_resolve_02" })
            end
            --75pts
            if willpower.current >= 75 and willpower.current < 100 then
                tes3.addSpell({ reference = partyTable[i], spell = "kl_ability_resolve_03" })
            end
            --100pts
            if willpower.current >= 100 then
                tes3.addSpell({ reference = partyTable[i], spell = "kl_ability_resolve_04" })
            end
        end
        log:debug("Resolve bestowed upon party.")
    else
        local partyTable = func.partyTable()

        for i = 1, #partyTable do
            --Remove Aura
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_01" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_02" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_03" })
            tes3.removeSpell({ reference = partyTable[i], spell = "kl_ability_resolve_04" })
        end

        log:debug("Resolve removed from party.")
    end
end

--Blessed Aura #9---------------------------------------------------------------------------------------------------------------------
function this.blessed()
    
    log:trace("Blessed Aura triggered.")

    local party = func.partyTable()

    local trigger = 0
    local npcTable = func.npcTable()
    local restoration

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[9] == true then
            trigger = 1
            restoration = reference.mobile:getSkillStatistic(15)
            break
        end
    end

    if (trigger == 1 and restoration.current >= 50) then
        --Confer Aura
        if restoration.current >= 75 then
            if restoration.current >= 100 then
                --100
                for n = 1, #party do
                    local ref = party[n]
                    tes3.addSpell({ reference = ref, spell = "kl_ability_blessed_3" })
                end
                log:debug("Blessed Aura 3 bestowed upon party.")
            else
                --75
                for n = 1, #party do
                    local ref = party[n]
                    tes3.addSpell({ reference = ref, spell = "kl_ability_blessed_2" })
                end
                log:debug("Blessed Aura 2 bestowed upon party.")
            end
        else
            --50
            for n = 1, #party do
                local ref = party[n]
                tes3.addSpell({ reference = ref, spell = "kl_ability_blessed" })
            end
            log:debug("Blessed Aura bestowed upon party.")
        end
    else
        --Remove Aura
        for n = 1, #party do
            local ref = party[n]
            tes3.removeSpell({ reference = ref, spell = "kl_ability_blessed" })
            tes3.removeSpell({ reference = ref, spell = "kl_ability_blessed_2" })
            tes3.removeSpell({ reference = ref, spell = "kl_ability_blessed_3" })
        end

        log:debug("Blessed Aura removed from party.")
    end
end

--Observant #16---------------------------------------------------------------------------------------------------------------------
function this.survey(e)
    if config.triggeredAbilities == false then return 0 end
    if e.cell.restingIsIllegal then return 0 end

    
    log:trace("Survey triggered.")

    local npcTable = func.npcTable()
    local trigger = 0
    local name

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)
        if (modData.abilities[16] == true or modData.class == "Scout") then
            if math.random(0, 99) < 4 then
                trigger = 1
                name = reference.object.name
                break
            end
        end
    end

    if trigger == 1 then
        log:info("" .. name .. "'s observations granted bonus experience.")
        return 1
    else
        return 0
    end
end

--Reading Comprehension #49---------------------------------------------------------------------------------------------------------
function this.comprehension(e)
    if config.triggeredAbilities == false then return end

    
    log:trace("Comprehension triggered.")

	if e.source == "book" then
		local npcTable = func.npcTable()
		local trigger = 0
        local name

		for i = 1, #npcTable do
			local reference = npcTable[i]
			local modData = func.getModData(reference)
			if (modData.abilities[49] == true or modData.class == "Bookseller") then
				if math.random(1, 120) < (reference.mobile.intelligence.current + modData.level) then
					trigger = 1
                    name = reference.object.name
				end
			end
		end

		if trigger == 1 then
			if config.aboveMaxSkill == false then
				local skill = tes3.player.mobile:getSkillStatistic(e.skill)
				if skill.base + 1 > 100 then
					--Do nothing
				else
					tes3.modStatistic({ skill = e.skill, value = 1, reference = tes3.player })
				end
			else
				tes3.modStatistic({ skill = e.skill, value = 1, reference = tes3.player })
			end
            log:debug("" .. name .. "'s literary insight enhanced your studies in " .. tes3.getSkillName(e.skill) .. ".")
            func.clMessageBox("" .. name .. "'s literary insight enhanced your studies in " .. tes3.getSkillName(e.skill) .. ".")
		end
	end
end

--Rugged Navigator #68--------------------------------------------------------------------------------------------------------------
function this.navigator(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Navigator triggered.")
    if e.mobile and e.mobile.reference.object.faction and e.mobile.reference.object.faction.id == "Mages Guild" then return end

    local npcTable = func.npcTable()
    local originalPrice = e.price

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[68] == true then
            e.price = math.round(e.price * 0.75)
            log:debug("" .. reference.object.name .. "'s navigation skills reduced travel costs to " .. e.price .. ".")
        end
    end

    if e.price < 1  and originalPrice > 0 then
        e.price = 1
    end
end

--Tranquility #72-------------------------------------------------------------------------------------------------------------------
function this.tranquility(ref)
    
    log:trace("Tranquility triggered.")

    if config.triggeredAbilities == false then return end

	if (string.endswith(ref.object.name, " Guar") == true or string.endswith(ref.object.name, " Netch") == true or string.endswith(ref.object.name, " Rat") == true) then
		local npcTable = func.npcTable()
		local trigger = 0

		for i = 1, #npcTable do
			local reference = npcTable[i]
			local modData = func.getModData(reference)
			if modData.abilities[72] == true then
				trigger = 1
				log:debug("" .. ref.object.name .. " was placated by " .. reference.object.name .. ".")
                break
			end
		end

		--Placate
		if trigger == 1 then
			ref.mobile.fight = 35
		end
	end
end

--Jester's Privilege #73----------------------------------------------------------------------------------------------------------
function this.jest(e)
    --change caster to companion?
    if config.combatAbilities == false then return end

    
    log:trace("Jest triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
			if actor.objectType ~= tes3.objectType.creature then
				local npcTable = func.npcTable()
				local trigger = 0
				local speechcraft
				local level
				local caster

				for i = 1, #npcTable do
					local reference = npcTable[i]
					local modData = func.getModData(reference)
					if (modData.abilities[73] == true or modData.class == "Jester") then
						trigger = 1
						caster = reference.object.name
						speechcraft = reference.mobile:getSkillStatistic(25)
						level = modData.level
						log:debug("" .. caster .. " attempted to provoke " .. actor.reference.object.name .. ".")
					end
				end

				if trigger == 1 then
					--Check for Jest spell
					local affected = tes3.isAffectedBy({ reference = actor.reference, object = "kl_spell_jest" })
					if not affected then
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_jest", instant = true, bypassResistances = true })

						if speechcraft.current > (actor.reference.mobile.willpower.current + 10) then
							local randNum = math.random(10, 60)
							local amount = level
                            local mod = speechcraft.current
                            if mod > 200 then
                                mod = 200
                            end
                            if mod < 0 then
                                mod = 0
                            end

                            --Drain Agility
							tes3.applyMagicSource({
								reference = actor.reference,
								name = "Jest",
								bypassResistances = true,
								effects = {{ id = tes3.effect.drainAttribute, attribute = 3, duration = (randNum + (amount * 2)), min = mod * 0.10, max = mod * 0.35 }, },
							})
							log:debug("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Jest!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Jest!")
                            end
						else
							log:debug("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Jest!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Jest!")
                            end
						end
					else
						log:debug("" .. actor.reference.object.name .. " is already affected by Jest.")
					end
				end
			end
		end
	end
end

--Flayer #75-------------------------------------------------------------------------------------------------------------
function this.poach(e)
    if config.combatAbilities == false then return end
    
    log:trace("Poach triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 and e.mobile.actorType == 0 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[75] then
                --Damage Bonus
                if e.mobile.reference.object.type == 0 then
                    result = math.round(e.damage * 0.12)
                else
                    result = math.round(e.damage * 0.06)
                end
                log:debug("Poach! " .. result .. " damage added!")
            end
        end
    end

    return result
end

--Runic #77--------------------------------------------------------------------------------------------------------------
function this.arcaneK(e)
    if config.combatAbilities == false then return end
    
    log:trace("Runic triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[77] then
                --Enchant Damage Bonus
                local result = 0
                local enchant = e.attacker:getSkillStatistic(9)
                result = math.round(enchant.current / 12)

                if result > 10 then
                    result = 10
                end

                --Damage Health
                tes3.applyMagicSource({
                    reference = e.mobile,
                    name = "Runic",
                    effects = {
                        { id = tes3.effect.damageHealth,
                            min = math.round(result / 2),
                            max = result }
                    },
                })
                tes3.playSound({ sound = "critical damage", reference = e.mobile.reference, volume = 0.8 })
                tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 2, reference = e.mobile })
                log:debug("Runic spell damage added!")
            end
        end
    end
end

--Arcane Augmentation #78--------------------------------------------------------------------------------------------------------------
function this.arcaneA(e)
    if config.combatAbilities == false then return end
    
    log:trace("Arcane Augmentation triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[78] then
                --Enchant Damage Bonus
                local result = 0
                local enchant = e.attacker:getSkillStatistic(9)
                result = math.round(enchant.current / 12)

                if result > 10 then
                    result = 10
                end

                --Damage Health
                tes3.applyMagicSource({
                    reference = e.mobile,
                    name = "Arcane Augmentation",
                    effects = {
                        { id = tes3.effect.damageHealth,
                            min = math.round(result / 2),
                            max = result }
                    },
                })
                tes3.playSound({ sound = "critical damage", reference = e.mobile.reference, volume = 0.8 })
                tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 2, reference = e.mobile })
                log:debug("Arcane Augmentation spell damage added!")
            end
        end
    end
end

--Thaumaturgy #80-----------------------------------------------------------------------------------------------------------------
function this.thaumaturgy(e)
    if config.combatAbilities == false then return end

    
    log:trace("Thaumaturgy triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
			local npcTable = func.npcTable()
            local trigger = 0
            local willpower
            local caster

            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
                if (modData.abilities[80] == true or modData.class == "Thaumaturge") then
                    trigger = 1
                    caster = reference.object.name
                    willpower = reference.mobile.attributes[3]
                    log:debug("" .. caster .. " attempted to shear " .. actor.reference.object.name .. ".")
                end
            end

            if trigger == 1 then
                --Weakness to Corprus as an effect to check for
                local affected = tes3.isAffectedBy({ reference = actor.reference, effect = 34 })
                if not affected then
                    local mod = willpower.current
                    if mod > 300 then
                        mod = 300
                    end
                    if mod < 3 then
                        mod = 3
                    end
                    local min = math.round(mod / 7)
                    local max = math.round(mod / 5)

                    tes3.applyMagicSource({
                        reference = actor.reference,
                        name = "Shear",
                        bypassResistances = true,
                        effects = {
                            { id = tes3.effect.weaknesstoCorprusDisease,
                                duration = mod,
                                min = 1,
                                max = 1 }, { id = tes3.effect.weaknesstoFire,
                                duration = mod,
                                min = min,
                                max = max }, { id = tes3.effect.weaknesstoFrost,
                                duration = mod,
                                min = min,
                                max = max }, { id = tes3.effect.weaknesstoShock,
                                duration = mod,
                                min = min,
                                max = max },
                        },
                    })
                    tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 3, reference = actor.reference })
                    tes3.playSound({ sound = "destruction hit", reference = actor.reference, volume = 0.8 })
                    log:debug("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Thaumaturgy!")
                    if config.bMessages == true then
                        func.clMessageBox("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Thaumaturgy!")
                    end
                else
                    log:debug("" .. actor.reference.object.name .. " is already affected by Shear.")
                end
            end
        end
	end
end

--Living Weapon #84-------------------------------------------------------------------------------------------------------------
function this.knifehand(e)
    if config.combatAbilities == false then return end
    
    log:trace("Knifehand triggered.")

    if e.attacker ~= nil and e.mobile ~= nil then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[84] then
                e.mobile:applyDamage({ damage = e.fatigueDamage * 0.25 })
            
                log:debug("Pugilist: " .. e.fatigueDamage * 0.25 .. " damage dealt.")
            end
        end
    end
end

--Insight #88--------------------------------------------------------------------------------------------------------------------
function this.insight(num)
    if config.triggeredAbilities == false then return num end

    
    log:trace("Insight triggered.")

    local npcTable = func.npcTable()
    local trigger = 0
    local name

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)
        if (modData.abilities[88] == true or modData.class == "Sage") then
            if math.random(1, 200) < (reference.mobile.intelligence.current + modData.level) then
                trigger = 1
                name = reference.object.name
            end
        end
    end

    if trigger == 1 then
        log:debug("" .. name .. "'s insight granted bonus experience.")
        func.clMessageBox("" .. name .. "'s insight granted bonus experience.")

        return num + 1
    else
        return num
    end
end

--Patient Zero #96--------------------------------------------------------------------------------------------------------------------
function this.inoculate(e)
    if config.combatAbilities == false then return end

    
    log:trace("Inoculate triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            local npcTable = func.npcTable()
            local trigger = 0
            local destruction
            local alchemy
            local level
            local caster

            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
                if (modData.abilities[96] == true or modData.class == "Plagueherald") then
                    trigger = 1
                    caster = reference
                    destruction = reference.mobile:getSkillStatistic(10)
                    alchemy = reference.mobile:getSkillStatistic(16)
                    level = modData.level
                    log:debug("" .. caster.object.name .. " attempted to inoculate " .. actor.reference.object.name .. ".")
                end
            end

            if trigger == 1 then
                local diseases = tes3.getSpells({ target = caster, spellType = 3, getRaceSpells = false, getBirthsignSpells = false })
                if #diseases > 0 then
                    for i = 1, #diseases do
                        local affected = tes3.isAffectedBy({ reference = actor.reference, object = diseases[i] })
                        if not affected then
                            if ((destruction.current * 0.3) + (alchemy.current * 0.3) + (level * 0.3)) > (actor.reference.mobile.endurance.current + math.random(1, 30)) then
                                tes3.addSpell({ reference = actor.reference, spell = diseases[i] })
                                log:debug("" .. actor.reference.object.name .. " was inflicted with " .. caster.object.name .. "'s " .. diseases[i].name .. "!")
                                tes3.createVisualEffect({ object = "VFX_PoisonHit", lifespan = 3, reference = actor.reference })
                                tes3.playSound({ sound = "Drink", reference = actor.reference, volume = 0.8 })
                                if config.bMessages == true then
                                    func.clMessageBox("" .. actor.reference.object.name .. " was inflicted with " .. caster.object.name .. "'s " .. diseases[i].name .. "!")
                                end
                            else
                                log:debug("" .. actor.reference.object.name .. " resisted " .. caster.object.name .. "'s " .. diseases[i].name .. "!")
                                if config.bMessages == true then
                                    func.clMessageBox("" .. actor.reference.object.name .. " resisted " .. caster.object.name .. "'s " .. diseases[i].name .. "!") 
                                end
                            end
                        else
                            log:debug("" .. actor.reference.object.name .. " is already affected by " .. diseases[i].name .. ".")
                        end
                    end
                else
                    log:debug("" .. caster.object.name .. " has no diseases to spread!")
                end
            end
		end
	end
end

--Citizen's Arrest #97--------------------------------------------------------------------------------------------------------------------
function this.bounty(reference)
    if config.triggeredAbilities == false then return end

    
    log:trace("Bounty triggered on " .. reference.object.name .. ".")

    local modData = func.getModData(reference)

    if (modData.abilities[97] == true or modData.class == "Bounty Hunter") then
        local temp = {}
        for _, cell in pairs(tes3.dataHandler.nonDynamicData.cells) do
            temp[cell] = true
        end

        local list = {}
        for cell in pairs(temp) do
            list[#list+1] = cell
        end

        local choice

        repeat
            local check = true

            choice = list[math.random(1, #list)]

            if (choice.displayName ~= nil) then
                for n = 1, #tables.bountyBlacklist do
                    if string.match(choice.displayName, tables.bountyBlacklist[n]) then
                        check = false
                        break
                    end
                end
            else
                check = false
            end

        until (check == true)


        table.insert(modData.bounties, choice.id)

        local cellName = choice.displayName
        local unused
        if string.match(cellName, ",") then
            cellName, unused = choice.displayName:match("([^,]+),([^,]+)")
        end

        func.clMessageBox("" .. reference.object.name .. " received a bounty to kill a fugitive. They were last seen in " .. cellName .. ".")
        log:info("" .. reference.object.name .. " received a bounty to kill a fugitive. They were last seen in " .. cellName .. ".")
    end
end

function this.bountyCheck()
    if config.triggeredAbilities == false then return end

    
    log:trace("Bounty check triggered.")

    local npcTable = func.npcTable()
    local modData

    for i = 1, #npcTable do
        local reference = npcTable[i]
        modData = func.getModData(reference)

        if (modData.abilities[97] == true or modData.class == "Bounty Hunter") then
            if modData.bounties then
                for n = 1, #modData.bounties do
                    log:trace("" .. reference.object.name .. "'s Bounty Cell List #" .. n .. ": " .. modData.bounties[n] .. "")

                    if tes3.player.cell.id == modData.bounties[n] then
                        local choice = math.random(1, 11)

                        tes3.createReference({ object = "kl_npc_fugitive_" .. choice .. "", position = tes3.getCameraPosition(), orientation = tes3.player.orientation:copy(), cell = modData.bounties[n] })
                        table.remove(modData.bounties, n)

                        log:info("" .. reference.object.name .. "'s Bounty #" .. n .. " was found!")
                    end
                end
            end
        end
    end
end

function this.bountyKill(e)
    
    log:trace("Bounty kill check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if (modData.abilities[97] == true or modData.class == "Bounty Hunter") then
            if string.startswith(e.reference.object.id, "kl_npc_fugitive") then
                local amount = (e.reference.object.level * math.random(25, 75))

                if amount > 2000 then
                    amount = 2000
                end

                tes3.addItem({ reference = reference, item = "Gold_001", count = amount })
                tes3.playSound({ sound = "Item Gold Down" })

                func.clMessageBox("" .. reference.object.name .. " received a " .. amount .. " bounty!")
                log:info("" .. reference.object.name .. " received a " .. amount .. " bounty!")
            end
        end
    end
end

--Moonlight Requiem #99--------------------------------------------------------------------------------------------------------------------
function this.requiem(e)
    if config.combatAbilities == false then return end

    
    log:trace("Moonlight Requiem triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            if string.match(actor.reference.object.id, "werewolf") then
                local npcTable = func.npcTable()

                for i = 1, #npcTable do
                    local reference = npcTable[i]
                    local modData = func.getModData(reference)

                    if (modData.abilities[99] == true or modData.class == "Silver Hand") then
                        log:debug("" .. reference.object.name .. " spotted a werewolf!")

                        local affected = tes3.isAffectedBy({ reference = reference, object = "kl_spell_requiem" })

                        if not affected then
                            tes3.cast({ reference = reference, target = reference, spell = "kl_spell_requiem", instant = true, bypassResistances = true })

                            log:debug("" .. reference.object.name .. " entered a frenzy!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. reference.object.name .. " entered a frenzy!")
                            end
                        else
                            log:debug("" .. reference.object.name .. " is already affected by Moonlight Requiem.")
                        end
                    end
                end
            end
        end
	end
end

--Dirge #101----------------------------------------------------------------------------------------------------------
function this.dirge(e)
    if config.combatAbilities == false then return end

    
    log:trace("Dirge triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
			if actor.objectType ~= tes3.objectType.creature then
				local npcTable = func.npcTable()
				local trigger = 0
				local speechcraft
				local level
				local caster

				for i = 1, #npcTable do
					local reference = npcTable[i]
					local modData = func.getModData(reference)
					if (modData.abilities[101] == true or modData.class == "Diresinger") then
						trigger = 1
						caster = reference.object.name
						speechcraft = reference.mobile:getSkillStatistic(25)
						level = modData.level
						log:debug("" .. caster .. " attempted to dispirit " .. actor.reference.object.name .. ".")
					end
				end

				if trigger == 1 then
					--Check for Dirge spell object
					local affected = tes3.isAffectedBy({ reference = actor.reference, object = "kl_spell_dirge" })
					if not affected then
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_dirge", instant = true, bypassResistances = true })

						if (speechcraft.current - math.random(1, 20)) > (actor.reference.mobile.willpower.current + 10) then
							local amount = level
							if amount > 30 then
								amount = 30
							end
                            local duration = speechcraft.current + amount
                            if duration > 180 then
                                duration = 180
                            end

                            --Damage Fatigue
							tes3.applyMagicSource({
								reference = actor.reference,
								name = "Dirge",
								bypassResistances = true,
								effects = {
									{ id = tes3.effect.damageFatigue,
										duration = duration,
										min = 2,
										max = 3 }
								},
							})
                            tes3.createVisualEffect({ object = "VFX_IllusionHit", lifespan = 4, reference = actor.reference })
							log:debug("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Dirge!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Dirge!")
                            end
						else
							log:debug("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Dirge!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " ignored " .. caster .. "'s Dirge!")
                            end
						end
					else
						log:debug("" .. actor.reference.object.name .. " is already affected by Dirge.")
					end
				end
			end
		end
	end
end

--Sanguine Elegy #103--------------------------------------------------------------------------------------------------------------------
function this.elegy(e)
    if config.combatAbilities == false then return end

    
    log:trace("Sanguine Elegy triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            local affected = tes3.isAffectedBy({ reference = actor.reference, effect = 133 })
            local faction = actor.reference.object.faction
            local clan = false
            if faction ~= nil then
                log:debug("Faction not nil. (" .. faction.id .. ")")
                if (faction.id == "Clan Aundae" or faction.id == "Clan Quarra" or faction.id == "Clan Berne") then
                    if actor.reference.object.name ~= "Cattle" then
                        clan = true
                        log:debug("" .. actor.reference.object.name .. " is a vampire clan member.")
                    end
                end
            end
            if (affected or clan) then
                log:debug("" .. actor.reference.object.name .. " is a Vampire.")
                local npcTable = func.npcTable()

                for i = 1, #npcTable do
                    local reference = npcTable[i]
                    local modData = func.getModData(reference)

                    if (modData.abilities[103] == true or modData.class == "Vampire Hunter") then
                        log:debug("" .. reference.object.name .. " sensed a vampire!")

                        local affected2 = tes3.isAffectedBy({ reference = reference, object = "kl_spell_elegy" })

                        if not affected2 then
                            tes3.cast({ reference = reference, target = reference, spell = "kl_spell_elegy", instant = true, bypassResistances = true })

                            log:debug("" .. reference.object.name .. " entered a fervor!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. reference.object.name .. " entered a fervor!")
                            end
                        else
                            log:debug("" .. reference.object.name .. " is already affected by Sanguine Elegy.")
                        end
                    end
                end
            end
        end
	end
end

--Natural Communion #107-----------------------------------------------------------------------------------------------------------------
function this.communion(e)
    if config.combatAbilities == false then return end

    
    log:trace("Communion triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            if actor.objectType ~= tes3.objectType.npc then
                local npcTable = func.npcTable()
                local trigger = 0
                local willpower
                local caster
    
                for i = 1, #npcTable do
                    local reference = npcTable[i]
                    local modData = func.getModData(reference)
                    if (modData.abilities[107] == true or modData.class == "Druid") then
                        trigger = 1
                        caster = reference
                        willpower = reference.mobile.attributes[3]
                        log:debug("" .. caster.object.name .. " attempted to commune with " .. actor.reference.object.name .. ".")
                    end
                end
    
                if trigger == 1 then
                    --Command Creature as an effect to check for
                    local affected = tes3.isAffectedBy({ reference = actor.reference, effect = 118 })

                    if not affected then
                        if ((actor.reference.mobile.willpower.current + math.random(1, 60)) < willpower.current) and (math.random(0, 9) < 5) then

                            --30 sec, level 5
                            if willpower.current < 25 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "command creature", instant = true })
                            end

                            --60 sec, level 5
                            if willpower.current >= 25 and willpower.current < 50 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_commune_01", instant = true })
                            end

                            --120 sec, level 10
                            if willpower.current >= 50 and willpower.current < 75 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_commune_02", instant = true })
                            end

                            --180 sec, level 15
                            if willpower.current >= 75 and willpower.current < 100 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_commune_03", instant = true })
                            end

                            --240 sec, level 20
                            if willpower.current >= 100 and willpower.current < 150 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_commune_04", instant = true })
                            end

                            --480 sec, level 23
                            if willpower.current >= 150 then
                                tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_commune_05", instant = true })
                            end

                            --Messages
                            log:debug("" .. actor.reference.object.name .. " was charmed by " .. caster.object.name .. "!")
                            if config.bMessages == true then
                                func.clMessageBox("" .. actor.reference.object.name .. " was charmed by " .. caster.object.name .. "!")
                            end
                        end
                    else
                        log:debug("" .. actor.reference.object.name .. " is already affected by a Command spell.")
                    end
                end
            end
        end
	end
end

--Experienced Tracker #108-------------------------------------------------------------------------------------------------------------------
function this.track()
    
    log:trace("Track triggered.")

    local trigger = 0
    local npcTable = func.npcTable()
    local intelligence

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[108] == true then
            trigger = 1
            intelligence = reference.mobile.attributes[2]
            break
        end
    end

    if trigger == 1 then
        --Confer Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_01" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_02" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_03" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_04" })

        --25pts
        if intelligence.current >= 25 and intelligence.current < 50 then
            tes3.addSpell({ reference = tes3.player, spell = "kl_ability_track_01" })
        end
        --50pts
        if intelligence.current >= 50 and intelligence.current < 75 then
            tes3.addSpell({ reference = tes3.player, spell = "kl_ability_track_02" })
        end
        --75pts
        if intelligence.current >= 75 and intelligence.current < 100 then
            tes3.addSpell({ reference = tes3.player, spell = "kl_ability_track_03" })
        end
        --100pts
        if intelligence.current >= 100 then
            tes3.addSpell({ reference = tes3.player, spell = "kl_ability_track_04" })
        end

        log:debug("Track bestowed upon player.")
    else
        --Remove Aura
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_01" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_02" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_03" })
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_track_04" })

        log:debug("Track removed from player.")
    end
end

--Maneater #109--------------------------------------------------------------------------------------------------------------
function this.maneater(e)
    if config.combatAbilities == false then return end
    
    log:trace("Maneater triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            if e.mobile.actorType == 1 then
                local modData = func.getModData(e.attacker.reference)

                if modData.abilities[109] then
                    --Personality/Illusion Damage Bonus
                    if (e.mobile.willpower.current + math.random(0, 40)) < e.attacker.personality.current then
                        local illusion = e.attacker:getSkillStatistic(12)
                        result = math.round(illusion.current / 12)

                        if result > 10 then
                            result = 10
                        end

                        local mod = math.round(result / 2)

                        if not e.mobile.object.female then
                            --Restore Magicka
							tes3.applyMagicSource({
								reference = e.attacker,
								name = "Maneater",
								effects = {
									{ id = tes3.effect.restoreMagicka,
										min = mod,
										max = mod }
								},
							})
                            --Damage Magicka
							tes3.applyMagicSource({
								reference = e.mobile,
								name = "Maneater",
								effects = {
									{ id = tes3.effect.damageMagicka,
										min = mod,
										max = mod }
								},
							})
                            tes3.playSound({ sound = "critical damage", reference = e.mobile.reference, volume = 0.8 })
                            tes3.createVisualEffect({ object = "VFX_IllusionHit", lifespan = 3, reference = e.mobile })
                            log:debug("Maneater!")
                        end

                        log:debug("Succubus: " .. result .. " damage added.")
                    end
                end
            end
        end
    end

    return result
end

--Lady Killer #110--------------------------------------------------------------------------------------------------------------
function this.ladykiller(e)
    if config.combatAbilities == false then return end
    
    log:trace("Lady Killer triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            if e.mobile.actorType == 1 then
                local modData = func.getModData(e.attacker.reference)

                if modData.abilities[110] then
                    --Personality/Mysticism Damage Bonus
                    if (e.mobile.willpower.current + math.random(0, 40)) < e.attacker.personality.current then
                        local mysticism = e.attacker:getSkillStatistic(14)
                        result = math.round(mysticism.current / 12)

                        if result > 10 then
                            result = 10
                        end

                        local mod = math.round(result / 2)

                        if e.mobile.object.female then
                            --Restore Health
							tes3.applyMagicSource({
								reference = e.attacker,
								name = "Lady Killer",
								effects = {
									{ id = tes3.effect.restoreHealth,
										min = mod,
										max = mod }
								},
							})
                            --Damage Health
							tes3.applyMagicSource({
								reference = e.mobile,
								name = "Lady Killer",
								effects = {
									{ id = tes3.effect.damageHealth,
										min = mod,
										max = mod }
								},
							})
                            tes3.playSound({ sound = "critical damage", reference = e.mobile.reference, volume = 0.8 })
                            tes3.createVisualEffect({ object = "VFX_MysticismHit", lifespan = 3, reference = e.mobile })
                            log:debug("Lady Killer!")
                        end
                    
                        log:debug("Incubus: " .. result .. " damage added.")
                    end
                end
            end
        end
    end

    return result
end

--Vagabond's Cunning #111---------------------------------------------------------------------------------------------------------
function this.cunning(e)
    if config.triggeredAbilities == false then return end

    
    log:trace("Cunning triggered.")

    if e.count > 0 then
        local npcTable = func.npcTable()

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)

            if modData.abilities[111] == true then
                local security = reference.mobile:getSkillStatistic(18)

                if math.random(0, 99) < security.current then
                    --Prevent Ambush
                    e.count = 0
                    log:info("" .. reference.object.name .. " prevented an ambush.")
                    func.clMessageBox("" .. reference.object.name .. " prevented an ambush!")
                    break
                end
            end
        end
    end
end

--Transporter #116---------------------------------------------------------------------------------------------------------------------------
function this.delivery(reference)
    
    log:trace("Delivery check triggered on " .. reference.object.name .. ".")

    local modData = func.getModData(reference)

    if (modData.abilities[116] == true or modData.class == "Courier") then
        local speechcraft = reference.mobile:getSkillStatistic(25)
        local type = math.random(1, 5)
        if modData.level >= 10  then
            type = math.random(1, 6)
        end
        local weight, name, mesh, icon, bonus
        if type == 1 then
            weight = 0.1
            name = "Letter: "
            mesh = [[m\Text_Parchment_01.NIF]]
            icon = [[m\Tx_parchment_01.tga]]
            bonus = 0
        elseif type == 2 then
            weight = 1.5
            name = "Book: "
            mesh = [[m\Text_Octavo_03.NIF]]
            icon = [[m\Tx_octavo_03.tga]]
            bonus = 25
        elseif type == 3 then
            weight = 3.0
            name = "Parcel: "
            mesh = [[m\Text_Scroll_02.NIF]]
            icon = [[m\Tx_scroll_02.tga]]
            bonus = math.round(25 + (speechcraft.base / 3))
            if bonus > 225 then
                bonus = 225
            end
        elseif type == 4 then
            weight = 6
            name = "Package: "
            mesh = [[m\dwemer_satchel00.NIF]]
            icon = [[m\misc_dwe_satchel00.dds]]
            bonus = math.round(125 + (speechcraft.base / 2))
            if bonus > 475 then
                bonus = 475
            end
        elseif type == 5 then
            weight = 10
            name = "Large Package: "
            mesh = [[m\dwemer_satchel00.NIF]]
            icon = [[m\misc_dwe_satchel00.dds]]
            bonus = math.round(200 + speechcraft.base)
            if bonus > 700 then
                bonus = 700
            end
        else
            weight = 20
            name = "Dense Package: "
            mesh = [[m\dwemer_satchel00.NIF]]
            icon = [[m\misc_dwe_satchel00.dds]]
            bonus = math.round(150 + (speechcraft.base * 5))
            if bonus > 1500 then
                bonus = 1500
            end
        end


        local temp = {}
        for obj in tes3.iterateObjects(tes3.objectType.npc) do
            temp[obj] = true
        end

        local list = {}
        for obj in pairs(temp) do
            list[#list+1] = obj
        end

        local choice

        repeat
            local check = true

            choice = list[math.random(1, #list)]

            if choice.name == "" then
                check = false
            else
                for n = 1, #tables.contractBlacklist do
                    if string.match(choice.name, tables.contractBlacklist[n]) then
                        check = false
                        break
                    end
                end
                local source = choice.sourceMod or ""
                if choice.aiConfig.fight > 80 or string.startswith(source, "F&F") or string.startswith(source, "Friends_and_Foes") then
                    check = false
                end
                if string.len(choice.name) > 17 then
                    check = false
                end
            end
        until (check == true)

        local amount = math.round((speechcraft.base * 5) + (modData.level * 15) + bonus)

        if amount > 3250 then
            amount = 3250
        end

        local obj = tes3.createObject({ objectType = tes3.objectType.miscItem, getIfExists = true, value = 1, weight = weight, name = "" .. name .. "" .. choice.name .. "", mesh = mesh, icon = icon })
        tes3.addItem({ item = obj, count = 1, reference = reference })

        local data = { choice.id, amount, obj.id }
        table.insert(modData.deliveries, data)

        func.clMessageBox("" .. reference.object.name .. " received a delivery to " .. choice.name .. " for " .. amount .. " gold.")
        log:info("" .. reference.object.name .. " received a delivery to " .. choice.name .. " for " .. amount .. " gold.")
    end
end

function this.deliveryCheck(e)
    
    log:trace("Delivery check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.deliveries then
            for n = 1, #modData.deliveries do
                local recipient = tes3.getObject(modData.deliveries[n][1])
                log:trace("" .. reference.object.name .. "'s Delivery List #" .. n .. ": " .. recipient.name .. "")

                if recipient.name == e.object.name then
                    local burden = tes3.getObject(modData.deliveries[n][3])
                    local removed = tes3.removeItem({ reference = reference, item = modData.deliveries[n][3], count = 1, playSound = true })
                    if removed > 0 then
                        --Delivery Success
                        tes3.addItem({ reference = reference, item = "Gold_001", count = modData.deliveries[n][2] })
                        tes3.playSound({ sound = "Item Gold Down", volume = 0.9 })

                        func.clMessageBox("" .. reference.object.name .. " received " .. modData.deliveries[n][2] .. " gold for delivering the " .. burden.name .. ".")
                        log:info("" .. reference.object.name .. " received " .. modData.deliveries[n][2] .. " gold for delivering the " .. burden.name .. ".")
    
                        table.remove(modData.deliveries, n)
                    else
                        --Forgot Package
                        func.clMessageBox("" .. reference.object.name .. " is missing the " .. burden.name .. ".")
                        log:info("" .. reference.object.name .. " is missing the " .. burden.name .. ".")
                    end
                end
            end
        end
    end
end

--Celestial Wont #117 (Aura)----------------------------------------------------------------------------------------------------------------------
function this.wont()
    
    log:trace("Wont triggered.")

    local trigger = 0
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[117] == true then
            trigger = 1
            break
        end
    end

    local partyTable = func.partyTable()

    if trigger == 1 then
        -- Remove all astrologer auras first
        for n = 0, 12 do
            this.updatePartyAura(partyTable, "kl_ability_astrologer_" .. n, false)
        end
        -- Apply the correct aura for the current month
        local month = tes3.worldController.month.value
        if month >= 0 and month <= 11 then
            this.updatePartyAura(partyTable, "kl_ability_astrologer_" .. month, true)
        elseif month > 11 then
            this.updatePartyAura(partyTable, "kl_ability_astrologer_12", true)
        end
        log:debug("Wont bestowed upon party.")
    else
        -- Remove all astrologer auras
        for n = 0, 12 do
            this.updatePartyAura(partyTable, "kl_ability_astrologer_" .. n, false)
        end
        log:debug("Wont removed from party.")
    end
end

--Groundskeeper's Intuition #119 (Aura)----------------------------------------------------------------------------------------------------------
function this.intuition()
    
    log:trace("Intuition triggered.")

    local trigger = 0
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[119] == true then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_intuition"})
        tes3.addSpell({ reference = tes3.player, spell = "kl_ability_intuition"})
        log:debug("Intuition bestowed upon player.")
    else
        tes3.removeSpell({ reference = tes3.player, spell = "kl_ability_intuition"})
        log:debug("Intuition removed from player.")
    end
end

--Adrenaline #120-------------------------------------------------------------------------------------------------------------------------
function this.adrenaline(e)
    if config.combatAbilities == false then return end
    
    log:trace("Adrenaline triggered.")

    if e.killingBlow then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[120] then
                --Adrenaline Rush
                if e.attacker.endurance.current > math.random(1, 100) then
                    local endMod = e.attacker.endurance.current
                    if endMod > 300 then
                        endMod = 300
                    end

                    --Adrenaline Rush!
                    tes3.applyMagicSource({
                        reference = e.attacker,
                        name = "Adrenaline Rush",
                        effects = {
                            { id = tes3.effect.restoreHealth,
                                min = 2,
                                max = math.round(endMod * 0.12) },
                            { id = tes3.effect.restoreFatigue,
                                min = 2,
                                max = math.round(endMod * 0.12),
                                duration = 12 },
                            { id = tes3.effect.restoreAttribute,
                                min = 1,
                                max = 1,
                                attribute = 0 },
                            { id = tes3.effect.fortifyAttribute,
                                min = 2,
                                max = math.round(endMod * 0.12),
                                attribute = 0,
                                duration = 12 },
                            { id = tes3.effect.fortifyAttribute,
                                min = 2,
                                max = math.round(endMod * 0.12),
                                attribute = 3,
                                duration = 12 },
                            { id = tes3.effect.fortifyAttribute,
                                min = 2,
                                max = math.round(endMod * 0.12),
                                attribute = 4,
                                duration = 12 }
                        },
                    })
                    tes3.playSound({ sound = "critical damage", reference = e.attacker, volume = 0.8 })
                    tes3.createVisualEffect({ object = "VFX_RestorationHit", lifespan = 3, reference = e.attacker })
                    log:debug("Adrenaline Rush!")
                end
            end
        end
    end
end

--Deceptor #129---------------------------------------------------------------------------------------------------------------------------
function this.deceptor(e)
    if config.combatAbilities == false then return end
    
    log:trace("Deceptor triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 and e.mobile.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[129] then
                --Damage Bonus
                local mod
                if e.mobile.object.faction ~= nil and e.mobile.object.faction.id == modData.infiltrated then
                    local security = e.attacker:getSkillStatistic(18)
                    mod = (security.base * 0.0012)
                    if mod > 0.20 then
                        mod = 0.20
                    end
                    result = math.round(e.damage * mod)
                end
                log:debug("Deceptor! " .. result .. " damage added! (" .. mod .. "%)")
            end
        end
    end

    return result
end

--Shed Regret #131------------------------------------------------------------------------------------------------------------------------
function this.shed(e)
    if config.combatAbilities == false then return end
    
    log:trace("Shed triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 and e.mobile.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[131] then
                --Damage Bonus
                if e.mobile.object.faction ~= nil then
                    local enemy = nil
                    for i = 1, #modData.fEnemies do
                        if e.mobile.object.faction.id == modData.fEnemies[i][1] then
                            enemy = modData.fEnemies[i]
                            break
                        end
                    end
                    if enemy ~= nil then
                        local amount = (enemy[2] * -4) * 0.01
                        if e.attacker.willpower.base < 100 then
                            amount = amount / 2
                        elseif e.attacker.willpower.base >= 150 then
                            amount = amount * 1.25
                        end
                        result = math.round(e.damage * amount)
                    end
                end
                log:debug("Shed Regret! " .. result .. " damage added!")
            end
        end
    end

    return result
end

--Consul #132, Allegiance #133-----------------------------------------------------------------------------------------------------------------------------
function this.fRep(mobile)
    if config.triggeredAbilities == false then return end
    if mobile == nil then return end
    if mobile.object.faction == nil then return end
    
    log:trace("Faction Rep triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local ref = npcTable[i]
        local modData = func.getModData(ref)

        --Diplomat
        if modData.abilities[132] == true then
            if mobile.object.faction.id == modData.consulate then
                local speech = ref.mobile:getSkillStatistic(25)
                local mod = math.round(speech.current * 0.1)
                if mod > 15 then
                    mod = 15
                end
                if mod < 0 then
                    mod = 0
                end
                tes3.modDisposition({ reference = mobile, value = mod, temporary = true })
                log:debug("" .. ref.object.name .. " applied a +" .. mod .. " disp bonus to " .. modData.consulate .. " member. (132)")
            end
        end

        --Retainer
        if modData.abilities[133] == true then
            for n = 1, #modData.allegiances[2] do
                if mobile.object.faction.id == modData.allegiances[2][n][1] then
                    local mod = modData.allegiances[2][n][2] * 3
                    if mod > 12 then
                        mod = 12
                    end
                    if mod < -20 then
                        mod = -20
                    end
                    tes3.modDisposition({ reference = mobile, value = mod, temporary = true })
                    log:debug("" .. ref.object.name .. " applied a " .. mod .. " disp change to " .. modData.allegiances[2][n][1] .. " member. (133)")
                end
            end
        end
    end
end

--Broadside #135-------------------------------------------------------------------------------------------------------------
function this.broadside(e)
    if config.combatAbilities == false then return end
    
    log:trace("Broadside triggered.")

    local result = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[135] then
                --Damage Bonus
                if e.mobile.underwater or e.mobile.isSwimming then
                    result = math.round(e.damage * 0.10)
                    log:debug("Broadside! " .. result .. " damage added!")
                end
            end
        end
    end

    return result
end

--Shadow Manipulation #136 (Pseudo Aura)---------------------------------------------------------------------------------------------------------------------
function this.shadow(e)
    
    log:trace("Shadow Manipulation triggered.")

    local trigger = 0
    local illusion
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[136] == true then
            trigger = 1
            illusion = reference.mobile:getSkillStatistic(12).current
            break
        end
    end

    if trigger == 1 then
        if math.random(1, 400) < illusion.current then
            return false
        else
            return e.isDetected
        end
    else
        return e.isDetected
    end
end


--Weather Report #138----------------------------------------------------------------------------------------------------------
function this.weather(e)
    if config.combatAbilities == false then return end

    
    log:trace("Weather triggered.")

	if (e.target == tes3.mobilePlayer and tes3.getPlayerCell().isOrBehavesAsExterior == true) then
        log:trace("Combat target is player.")
		for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
            local npcTable = func.npcTable()
            local trigger = 0
            local caster

            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
                if modData.abilities[138] == true then
                    trigger = 1
                    caster = reference
                    break
                end
            end

            if trigger == 1 then
                --Check for weather spells
                local affected = false
                for i = 0, 9 do
                    if tes3.isAffectedBy({ reference = actor.reference, object = "kl_spell_weather_" .. i .. "" }) == true then
                        affected = true
                        break
                    end
                end
                if not affected then
                    local index = tes3.getCurrentWeather().index
                    local spell = tes3.getObject("kl_spell_weather_" .. index .. "")
                    if spell then
                        tes3.cast({ reference = caster, target = actor.reference, spell = spell, instant = true, bypassResistances = false })
                        log:debug("" .. actor.reference.object.name .. " was affected by the weather's " .. spell.name .. "!")
                        if config.bMessages == true then
                            func.clMessageBox("" .. actor.reference.object.name .. " was affected by the weather's " .. spell.name .. "!")
                        end
                    else
                        log:debug("" .. actor.reference.object.name .. " couldn't find a weather spell.")
                    end
                else
                    log:debug("" .. actor.reference.object.name .. " is already affected by the weather.")
                end
            end
		end
	end
end

--Kyne's Breath #142-----------------------------------------------------------------------------------------------------------------
function this.kyne(e)
    if config.combatAbilities == false then return end
    
    log:trace("Kyne triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.mobile) then
            local modData = func.getModData(e.mobile.reference)

            if e.mobile.actorType == 1 and modData.abilities[142] and not modData.metamorph then
                local will = e.mobile.attributes[3].current

                if will < 50 then
                    local affected = tes3.isAffectedBy({ reference = e.attacker, obect = "kl_spell_squall_01"})
                    if not affected then
                        tes3.cast({ reference = e.mobile, target = e.attacker, spell = "kl_spell_squall_01", instant = true })
                        log:debug("Squall 1!")
                    end
                elseif will < 80 then
                    local affected = tes3.isAffectedBy({ reference = e.attacker, obect = "kl_spell_squall_02"})
                    if not affected then
                        tes3.cast({ reference = e.mobile, target = e.attacker, spell = "kl_spell_squall_02", instant = true })
                        log:debug("Squall 2!")
                    end
                elseif will < 100 then
                    local affected = tes3.isAffectedBy({ reference = e.attacker, obect = "kl_spell_squall_03"})
                    if not affected then
                        tes3.cast({ reference = e.mobile, target = e.attacker, spell = "kl_spell_squall_03", instant = true })
                        log:debug("Squall 3!")
                    end
                else
                    local affected = tes3.isAffectedBy({ reference = e.attacker, obect = "kl_spell_squall_04"})
                    if not affected then
                        tes3.cast({ reference = e.mobile, target = e.attacker, spell = "kl_spell_squall_04", instant = true })
                        log:debug("Squall 4!")
                    end
                end
            end
        end
    end
end

--Farseek #145-----------------------------------------------------------------------------------------------------------------
function this.farseek()
    
    log:trace("Farseek triggered.")

    local trigger = 0
    local npcTable = func.npcTable()
    local name = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[145] then
            trigger = 1
            name = reference.object.name
            break
        end
    end

    if trigger == 1 then
        --Detect Daedric/Unique Weapons and Armor
        for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.armor, tes3.objectType.weapon, tes3.objectType.container }) do
            if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
                if refe.object.objectType == tes3.objectType.container then
                    local found = false
                    for _, stack in pairs(refe.object.inventory) do
                        local item = stack.object
                        if string.startswith(item.id, "daedric") or string.find(item.id, "unique") then
                            func.clMessageBox("" .. name .. " detects the presence of a powerful artifact!")
                            found = true
                            log:debug("" .. item.id .. " found in the " .. refe.object.name .. " container.")
                            break
                        end
                    end
                    if found then break end
                else
                    if string.startswith(refe.object.id, "daedric") or string.find(refe.object.id, "unique") or string.startswith(refe.object.id, "keening") or string.startswith(refe.object.id, "sunder") then
                        func.clMessageBox("" .. name .. " detects the presence of a powerful artifact!")
                        log:debug("" .. refe.object.id .. " found in the current cell.")
                        break
                    end
                end
            end
        end
    end
end


-------Patrons------------------------------------------------------------------------------------------------
-----
---
--

--
--Divines--------------------------------------------------------------------------------------------------------------------------
--

--Akatosh---------------------------------------------------------------------------------------tested
function this.akatosh(e)
    
    if config.triggeredAbilities == false then return end
    log:trace("Akatosh triggered.")

    local npcTable = func.npcTable()
    local clerics = {}
    local patron = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 1 then
            clerics[#clerics + 1] = reference
            patron = modData.patron
        end
    end

    if #clerics >= 1 then
        tes3.cast({ reference = tes3.player, spell = "kl_spell_duty_1", instant = true, bypassResistances = true })
        for i = 1, #clerics do
            tes3.modStatistic({ reference = clerics[i], attribute = tes3.attribute.endurance, value = -1, limit = true })
            tes3.modStatistic({ reference = clerics[i], attribute = tes3.attribute.speed, value = -1, limit = true })
            local modData = func.getModData(clerics[i])
            modData.att_gained[6] = modData.att_gained[6] - 1
            modData.att_gained[5] = modData.att_gained[5] - 1
            log:debug("" .. tables.patrons[patron] .. " duty inflicted upon " .. clerics[i].object.name .. ".")
        end
        log:debug("" .. tables.patrons[patron] .. " duty inflicted upon player.")
    end
end

--Arkay---------------------------------------------------------------------------------------tested
function this.arkay(e)
    
    if config.triggeredAbilities == false then return end
    log:trace("Arkay triggered.")

    local npcTable = func.npcTable()
    local clerics = {}
    local answer = true
    local patron = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 2 then
            clerics[#clerics + 1] = reference
            patron = modData.patron
            break
        end
    end

    if #clerics >= 1 then
        if e.mobile.object.type and e.mobile.object.type ~= 1 then
            answer = false
            log:debug("" .. tables.patrons[patron] .. " duty upheld.")
        end
    end

    return answer
end

--Dibella---------------------------------------------------------------------------------------tested
--Gift
function this.dibella(mobile)
    
    if config.triggeredAbilities == false then return end
    log:trace("Dibella gift triggered.")

    local trigger = 0
    local npcTable = func.npcTable()
    local reference

    for i = 1, #npcTable do
        reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 3 then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        local affected = tes3.isAffectedBy({ reference = mobile, object = "kl_spell_gift_3"})
        if not affected then
            tes3.applyMagicSource({ reference = reference, target = mobile, source = "kl_spell_gift_3" })
        end
        log:debug("Mysterious Love bestowed upon " .. mobile.object.name ..".")
    end
end
--Duty
function this.dibellaDuty(e)
    
    if config.combatAbilities == false then return end
    log:trace("Dibella triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.patron and modData.patron == 3 then
                --Damage Penalty
                answer = math.round(e.damage * 0.10)
                log:debug("" .. tables.patrons[modData.patron] .. " duty upheld.")
            end
        end
    end

    return answer
end

--Julianos---------------------------------------------------------------------------------------tested
--Duty
function this.julianosDuty(e)
    
    if config.triggeredAbilities == false then return end
    log:trace("Julianos duty triggered.")

    local npcTable = func.npcTable()
    local clerics = {}
    local patron = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 4 then
            clerics[#clerics + 1] = reference
            patron = modData.patron
        end
    end

    if #clerics >= 1 then
        for i = 1, #clerics do
            local modData = func.getModData(clerics[i])
            for n = 1, 7 do
                local rd = math.random(0, 26)
                func.modStatAndTrack("skill", rd, -1, clerics[i], modData)
            end
            -- for n = 0, 26 do
            --     func.modStatAndTrack("skill", n, -1, clerics[i], modData)
            -- end
            func.clMessageBox("Julianos punishes " .. clerics[i].object.name .. " for breaking the law!")
            log:debug("" .. tables.patrons[patron] .. " duty inflicted upon " .. clerics[i].object.name .. ".")
        end
    end
end
--Gift
function this.julianos(e)
    
    if config.triggeredAbilities == false then return end
    log:trace("Julianos gift triggered.")

    local npcTable = func.npcTable()
    local clerics = {}
    local patron = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 4 then
            clerics[#clerics + 1] = reference
            patron = modData.patron
        end
    end

    if #clerics >= 1 then
        for i = 1, #clerics do
            if math.random(1, 3) == 3 then
                local modData = func.getModData(clerics[i])

                tes3.modStatistic({ reference = clerics[i], skill = e.skill, value = 1 })
                modData.skill_gained[e.skill + 1] = modData.skill_gained[e.skill + 1] + 1

                func.clMessageBox("" .. clerics[i].object.name .. "'s " .. tes3.getSkillName(e.skill) .. " " .. tes3.findGMST(tes3.gmst.sSkill).value .. " increased to " .. clerics[i].mobile:getSkillStatistic(e.skill).base .. ".")
                log:debug("" .. tables.patrons[patron] .. " gift bestowed upon " .. clerics[i].object.name .. ".")
            end
        end
    end
end

--Kynareth--------------------------------------------------------------------------------------------tested
function this.kynareth(e)
    
    log:trace("Kynareth triggered.")

    local npcTable = func.npcTable()
    local clerics = {}
    local patron = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 5 then
            clerics[#clerics + 1] = reference
            patron = modData.patron
        end
    end

    if patron ~= "" then
        if e.cell.isOrBehavesAsExterior then
            local index = tes3.getCurrentWeather().index
            local partyTable = func.partyTable()

            for i = 1, #clerics do
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_1" })
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_2" })
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_3" })

                if index == 5 or index == 4 then
                    --rain
                    tes3.addSpell({ reference = clerics[i], spell = "kl_ability_kynduty_1" })
                end
                if index == 7 or index == 6 then
                    --ash
                    tes3.addSpell({ reference = clerics[i], spell = "kl_ability_kynduty_2" })
                end
                if index == 8 or index == 9 then
                    --snow
                    tes3.addSpell({ reference = clerics[i], spell = "kl_ability_kynduty_3" })
                end
            end

            if math.random(1, 5) == 5 then --20% roughly, doesn't matter too much
                if e.cell.restingIsIllegal == false then
                    for i = 1, #partyTable do
                        local affected = tes3.isAffectedBy({ reference = partyTable[i], object = "kl_spell_gift_5" })
                        if not affected then
                            tes3.cast({ reference = partyTable[i], target = partyTable[i], spell = "kl_spell_gift_5", instant = true, bypassResistances = true })
                            if partyTable[i] == tes3.player then
                                func.clMessageBox("Kynareth's Auspicious Winds envelop you!")
                            end
                        end
                    end
                    log:debug("Kynareth's Gift bestowed upon party.")
                end
            end
        else
            for i = 1, #clerics do
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_1" })
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_2" })
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_kynduty_3" })
            end
        end
    end
end

--Stendarr-----------------------------------------------------------------------------------------------------------------------------------------tested
--Duty
function this.stendarrDuty(e)
    if e.attacker == nil or config.triggeredAbilities == false then return end
    
    log:trace("Stendarr duty triggered.")

    if e.killingBlow and e.mobile.object.level < 5 then
        if e.attacker == tes3.mobilePlayer or func.validCompanionCheck(e.attacker) then
            local npcTable = func.npcTable()
            local clerics = {}
            local patron = ""
        
            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
        
                if modData.patron and modData.patron == 7 then
                    clerics[#clerics + 1] = reference
                    patron = modData.patron
                end
            end

            if #clerics >= 1 then
                for i = 1, #clerics do
                    local modData = func.getModData(clerics[i])
                    tes3.modStatistic({ reference = clerics[i], attribute = tes3.attribute.strength, value = -1, limit = true })
                    tes3.modStatistic({ reference = clerics[i], attribute = tes3.attribute.endurance, value = -1, limit = true })
                    modData.att_gained[1] = modData.att_gained[1] - 1
                    modData.att_gained[6] = modData.att_gained[6] - 1
                    log:debug("" .. tables.patrons[patron] .. " duty inflicted upon " .. clerics[i].object.name .. ".")
                    func.clMessageBox("Stendarr judges " .. clerics[i].object.name .. " for the death of the meek!")
                end
            end
        end
    end
end

--Gift
function this.stendarr(ref)
    
    if config.triggeredAbilities == false then return end
    log:trace("Stendarr gift triggered.")

    local modData = func.getModData(ref)

    func.modStatAndTrack("attribute", tes3.attribute.strength, 1, ref, modData)
    func.modStatAndTrack("attribute", tes3.attribute.endurance, 1, ref, modData)

    func.clMessageBox("" .. ref.object.name .. "'s Strength and Endurance were acknowledged by Stendarr!")
    log:debug("Stendarr gift bestowed upon " .. ref.object.name .. ".")
end

--Talos------------------------------------------------------------------------------------------------------------------------------------------------------tested
--Duty
function this.talosDuty(e)
    
    if config.combatAbilities == false then return end
    log:trace("Talos duty triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 and e.mobile.object.objectType == tes3.objectType.npc then
            local modData = func.getModData(e.attacker.reference)

            if modData.patron and modData.patron == 8 then
                --Damage Penalty
                answer = math.round(e.damage * 0.20)
                log:debug("" .. tables.patrons[modData.patron] .. " duty upheld.")
            end
        end
    end

    return answer
end

--Zenithar---------------------------------------------------------------------------------------------------------------------------------------------------tested
--Duty
function this.zenitharDuty(ref)
    if config.triggeredAbilities == false then return end
    
    log:trace("Zenithar duty triggered.")

    local npcTable = func.npcTable()
    local clerics = {}

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 9 then
            clerics[#clerics + 1] = reference
            break
        end
    end

    if #clerics > 0 then
        if ref.object.promptsEquipmentReevaluation ~= nil and ref.object.objectType ~= tes3.objectType.book then
            local value = tes3.getValue({ reference = ref })
            if not value or value < 1 then
                value = 100
            end
            local seen = tes3.triggerCrime({ value = value, forceDetection = true })
            if not seen then
                tes3.mobilePlayer.bounty = tes3.mobilePlayer.bounty + value
            end
            func.clMessageBox("Thief! Zenithar will expose your breach of contract!")
            log:debug("Zenithar caught you stealing!")
        elseif ref.baseObject.objectType == tes3.objectType.container or ref.baseObject.objectType == tes3.objectType.npc then
            local seen = tes3.triggerCrime({ value = 200, forceDetection = true })
            if not seen then
                tes3.mobilePlayer.bounty = tes3.mobilePlayer.bounty + 200
            end
            func.clMessageBox("Trespasser! Zenithar will expose your breach of contract!")
            log:debug("Zenithar caught you trespassing!")
        end
    end
end
--Gift
function this.zenithar(e)
    if config.triggeredAbilities == false then return end
    
    log:trace("Zenithar gift triggered.")

    local originalPrice = e.price
    local npcTable = func.npcTable()
    local clerics = {}

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 9 then
            clerics[#clerics + 1] = reference
        end
    end

    for i = 1, #clerics do
        e.price = math.round(e.price * 0.88)
        log:debug("" .. clerics[i].object.name .. "'s connection to Zenithar reduced the price to " .. e.price .. ".")
    end

    if e.price < 1  and originalPrice > 0 then
        e.price = 1
    end
end


--
----Daedric Princes-----------------------------------------------------------------------------------------------------------------------------------------------------
--

--Azura------------------------------------------------------------------------------------------------
function this.azuraTribute()
    log:trace("Azura tribute triggered.")

    --Ectoplasm every 3 days at 5pm
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 10 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24
    
        if modData.tributeHours >= 72 then
            local paid = false
    
            paid = func.checkReq(false, "ingred_ectoplasm_01", 1, clerics[i])
            if not paid then
                paid = func.checkReq(false, "ingred_ectoplasm_01", 1, tes3.player)
            end
        
            modData.tributePaid = paid
    
            if paid then
                modData.tributeHours = 0
                func.clMessageBox("" .. clerics[i].object.name .. " paid their tribute in deference to Azura.")
            else
                func.clMessageBox("" .. clerics[i].object.name .. " failed to give tribute to Azura. Tribute may be offered again in 3 days.")
            end
        end
    end
end

function this.azuraGift()
    log:trace("Azura gift triggered.")

    --Buffed during twilight hours
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 10 then
            clerics[#clerics + 1] = npcTable[i]
            break
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])

        if modData.tributePaid then
            local affected = tes3.isAffectedBy({ reference = clerics[i], object = "kl_spell_gift_10" })
            if not affected then
                tes3.cast({ reference = clerics[i], target = clerics[i], spell = "kl_spell_gift_10", bypassResistances = true, instant = true })
                func.clMessageBox("" .. clerics[i].object.name .. " is exposed to Azura's twilight!")
            end
        end
    end
end

--Boethiah--------------------------------------------------------------------------------------------

function this.bloodKarma(e)
    
    log:trace("Blood karma check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if e.mobile.object.objectType == tes3.objectType.mobileNPC then
            --NPC
            if modData.bloodKarma and modData.bloodKarma <= 99.75 then
                modData.bloodKarma = modData.bloodKarma + 0.25
            end
        else
            --Creature
            if modData.bloodKarma and modData.bloodKarma <= 99.90 then
                modData.bloodKarma = modData.bloodKarma + 0.10
            end
        end
    end
end

function this.boethiahTribute()
    log:trace("Boethiah tribute triggered.")

    --5 Blood Karma Daily
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.bloodKarma and modData.bloodKarma >= -97 then
            modData.bloodKarma = modData.bloodKarma - 3
            func.clMessageBox("" .. reference.object.name .. " paid a tribute of blood to Boethiah.")

            if modData.bloodKarma < 0 then
                local mod = math.round(modData.bloodKarma * 1)
                if mod < 1 then
                    mod = 1
                end
                tes3.applyMagicSource({
                    reference = reference,
                    name = "Blood Tithe",
                    bypassResistances = true,
                    effects = {{ id = tes3.effect.drainHealth, duration = mod * 15, min = mod, max = mod * 2, }},
                })
                func.clMessageBox("" .. reference.object.name .. " is subjected to a blood tithe.")
            end
        end
    end
end

function this.boethiahGift(e)
    
    if config.combatAbilities == false then return end
    log:trace("Boethiah Gift triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.bloodKarma then
                --Blood Karma
                answer = (e.damage * modData.bloodKarma) / 400 --25% at full karma, -25% at max neg karma
                log:debug("Blood Karma added " .. answer .. " damage.")
            end
        end
    end

    return answer
end

--Clavicus Vile---------------------------------------------------------------------------------------------
--techniques.lua, "Call Scampson"

--Hermaeus Mora----------------------------------------------------------------------------------------------

function this.moraTribute()
    log:trace("H. Mora tribute triggered.")

    --Book every 3 days at 12am
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 13 then
            clerics[#clerics + 1] = npcTable[i]
            break
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24
    
        if modData.tributeHours >= 72 then
            local paid = false

			timer.delayOneFrame(function()
				timer.delayOneFrame(function()
					timer.delayOneFrame(function()
                        tes3ui.showInventorySelectMenu({
                            reference = tes3.player,
                            title = "Hermaeus Mora demands tribute...",
                            filter = function(e)
                                if e.item.objectType == tes3.objectType.book and tes3.getValue({ item = e.item }) > 20 then
                                    return true
                                else
                                    return false
                                end
                            end,
                            callback =
                            function(e)
                                if not e.item then  modData.tributePaid = false return end
                                
                                paid = func.checkReq(false, e.item.id, 1, tes3.player)

                                modData.tributePaid = paid

                                if paid then
                                    modData.tributeHours = 0
                                    func.clMessageBox("" .. clerics[i].object.name .. " paid their tribute in deference to Hermaeus Mora.")
                                else
                                    func.clMessageBox("" .. clerics[i].object.name .. " failed to give tribute to Hermaeus Mora, and suffers psychic damage! Tribute may be offered again in 3 days.")
                                    tes3.modStatistic({ reference = clerics[i], attribute = tes3.attribute.intelligence, value = -1 })
                                end
                            end
                        })
					end)
				end)
			end)
        end
    end
end

--Hircine--------------------------------------------------------------------------------------------------
function this.huntCheck(e)
    
    log:trace("Hircine hunt check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.hircineHunt and e.mobile.baseObject.id == modData.hircineHunt[1] and modData.hircineHunt[3] < modData.hircineHunt[2] then
            --Hunt Target
            modData.hircineHunt[3] = modData.hircineHunt[3] + 1

            --Hunt Complete?
            if modData.hircineHunt[3] == modData.hircineHunt[2] then
                modData.lycanthropicPower = modData.lycanthropicPower + 1
                local num = math.random(1, 6)
                if num == 1 then
                    --lycanthropic power + 1
                    modData.lycanthropicPower = modData.lycanthropicPower + 1
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Lycanthropic Power increased by 1.")
                elseif num == 2 then
                    --strength + 2
                    func.modStatAndTrack("attribute", tes3.attribute.strength, 2, reference, modData)
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Strength increased by 2.")
                elseif num == 3 then
                    --agility + 2
                    func.modStatAndTrack("attribute", tes3.attribute.agility, 2, reference, modData)
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Agility increased by 2.")
                elseif num == 4 then
                    --endurance + 2
                    func.modStatAndTrack("attribute", tes3.attribute.endurance, 2, reference, modData)
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Endurance increased by 2.")
                elseif num == 5 then
                    --speed + 2
                    func.modStatAndTrack("attribute", tes3.attribute.speed, 2, reference, modData)
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Speed increased by 2.")
                else
                    --health + 5
                    tes3.modStatistic({ reference = reference, name = "health", value = 5 })
                    modData.hth_gained = modData.hth_gained + 5
                    func.clMessageBox("" .. reference.object.name .. " completed the hunt for " .. tes3.getObject(modData.hircineHunt[1]).name .. "! Health increased by 5.")
                end
            end
            if modData.lycanthropicPower > 300 then
                modData.lycanthropicPower = 300
            end
        end
    end
end

function this.hircineTribute()
    log:trace("Hircine tribute triggered.")

    --Hunt Day Lapsed
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.hircineHunt then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24
    
        if modData.tributeHours >= (144 + math.random(12, 72)) then
            if modData.hircineHunt[3] < modData.hircineHunt[2] then
                modData.tributePaid = false
                func.clMessageBox("" .. clerics[i].object.name .. " failed to hunt " .. tes3.getObject(modData.hircineHunt[1]).name .. "!")
            end

            modData.hircineHunt =  tables.hircineHunts[math.random(1, #tables.hircineHunts)]
            modData.tributeHours = 0
            func.clMessageBox("" .. clerics[i].object.name .. " was issued a new hunt for " .. modData.hircineHunt[2] .. " " .. tes3.getObject(modData.hircineHunt[1]).name .. ".")
        end
    end
end


--Jyggalag----------------------------------------------------------------------------------------------------------------------------------------------------------
--Gift triggers at level up.
--Tribute paid by maintaining Order Streak, or no rewards given.

--Malacath----------------------------------------------------------------------------------------------------------------------------------------------------------

function this.malacathGift(e)
    
    if config.combatAbilities == false then return end
    log:trace("Malacath gift triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.mobile) then
            local answer = 0
            local modData = func.getModData(e.mobile.reference)

            if modData.patron and modData.patron == 16 then
                --Damage Reflection
                answer = math.round(e.damage * 0.15)
                e.attacker:applyDamage({ damage = answer })
                log:debug("Malacath gift applied " .. answer .. " damage.")
            end
        end
    end
end

function this.malacathTribute()
    log:trace("Malacath tribute triggered.")

    --Muck every 2 days at 6pm
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 16 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24
    
        if modData.tributeHours >= 48 then
            local paid = false
    
            paid = func.checkReq(false, "ingred_muck_01", 1, clerics[i])
            if not paid then
                paid = func.checkReq(false, "ingred_muck_01", 1, tes3.player)
            end
        
            modData.tributePaid = paid
    
            if paid then
                --All Good
                func.clMessageBox("" .. clerics[i].object.name .. " paid their tribute in respect to Malacath.")
            else
                --Cursed
                local num = math.random(1, 10)
                local spell = tes3.getObject("kl_spell_curse_" .. num .. "")
                tes3.applyMagicSource({ reference = clerics[i], source = spell, bypassResistances = true, target = clerics[i] })
                func.clMessageBox("" .. clerics[i].object.name .. " failed to give tribute to Malacath! " .. clerics[i].object.name .. " was afflicted with the " .. spell.name .. "!")
            end

            modData.tributeHours = 0
        end
    end
end

--Mehrunes Dagon----------------------------------------------------------------------------------------------------------------------------------------
function this.dagonTribute()
    log:trace("Dagon tribute triggered.")

    --Sacrifice Day Lapsed
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 17 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24

        if modData.tributeHours == 96 then
            if not modData.tributePaid then
                func.clMessageBox("Dagon grows impatient, mortal. " .. clerics[i].object.name .. " must destroy!")
            end
        end

        if modData.tributeHours >= 120 then
            if modData.tributePaid then
                modData.tributePaid = false
                modData.tributeHours = 0
                local light = tes3.createReference({ object = "red 256", position = clerics[i].mobile.position, cell = clerics[i].mobile.cell, orientation = clerics[i].mobile.orientation  })
                tes3.playSound({ sound = "restoration area", reference = clerics[i] })
                timer.start({ type = timer.simulate, duration = 4, callback = function() light:delete() end })
                func.clMessageBox("Dagon commands " .. clerics[i].object.name .. " to destroy! The weak must be culled!")
            else
                local light = tes3.createReference({ object = "red 256", position = clerics[i].mobile.position, cell = clerics[i].mobile.cell, orientation = clerics[i].mobile.orientation  })
                tes3.playSound({ sound = "destruction area", reference = clerics[i], volume = 1.2 })
                timer.start({ type = timer.simulate, duration = 3, callback = function() light:delete() end })
                tes3.createVisualEffect({ object = "VFX_DestructArea", lifespan = 2, reference = clerics[i], scale = 2 })
                clerics[i].mobile:kill()
                func.clMessageBox("" .. clerics[i].object.name .. " is annihilated. Dagon will not suffer fools.")
            end
        end
    end
end

function this.dagonSacrifice(e)
    if e.attacker == nil then return end
    
    log:trace("Dagon sacrifice triggered.")

    if e.killingBlow and e.mobile.fight < 71 and e.mobile.object.objectType == tes3.objectType.npc then
        if e.attacker == tes3.mobilePlayer or func.validCompanionCheck(e.attacker) then
            local npcTable = func.npcTable()
            local clerics = {}
        
            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
        
                if modData.patron and modData.patron == 17 and modData.tributePaid == false then
                    clerics[#clerics + 1] = reference
                    break
                end
            end

            if #clerics >= 1 then
                for i = 1, #clerics do
                    local modData = func.getModData(clerics[i])
                    modData.tributePaid = true
                    tes3.playSound({ sound = "destruction hit", reference = e.mobile, volume = 0.9 })
                    tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 3, reference = e.mobile })
                    log:debug("" .. clerics[i].object.name .. " sacrificed " .. e.mobile.object.name .. " to Mehrunes Dagon.")
                    func.clMessageBox("" .. clerics[i].object.name .. " sacrificed " .. e.mobile.object.name .. " to Mehrunes Dagon!")
                end
            end
        end
    end
end

function this.combustion(e)
    if config.combatAbilities == false then return end

    
    log:trace("Combustion triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local npcTable = func.npcTable()
        local trigger = 0
        local destruction
        local caster

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)
            if modData.patron and modData.patron == 17 then
                trigger = 1
                caster = reference.object.name
                destruction = reference.mobile:getSkillStatistic(10)
                log:debug("" .. caster .. " attempted to Combust.")
                break
            end
        end

        if trigger == 1 then
            for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                local affected = tes3.isAffectedBy({ reference = actor.reference, object = "kl_spell_dagon_combustion" })
                if not affected then
                    tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_dagon_combustion", instant = true, bypassResistances = false })
                    log:debug("" .. actor.reference.object.name .. " was affected by " .. caster .. "'s Combustion!")
                    if destruction.current >= 50 then
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_dagon_char", instant = true, bypassResistances = false })
                        log:debug("" .. actor.reference.object.name .. " was also affected by " .. caster .. "'s Char!")
                    end
                    if destruction.current >= 100 then
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_dagon_incinerate", instant = true, bypassResistances = false })
                        log:debug("" .. actor.reference.object.name .. " was blasted by " .. caster .. "'s Incinerate!")
                    end
                    if destruction.current >= 150 then
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "kl_spell_dagon_immolation", instant = true, bypassResistances = false })
                        log:debug("" .. actor.reference.object.name .. " was subjected to " .. caster .. "'s Immolation!")
                    end
                else
                    log:debug("" .. actor.reference.object.name .. " is already affected by Combustion.")
                end
            end
        end
	end
end

--Mephala-------------------------------------------------------------------------------------------------------------------------------------------------
function this.mephalaGift(e)
    
    if config.combatAbilities == false then return end
    log:trace("Mephala Gift triggered.")

    if e.attacker and func.validCompanionCheck(e.attacker) then
        local modData = func.getModData(e.attacker.reference)
        if modData.patron and modData.patron == 18 and modData.tributePaid then
            local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_silk-grip" })
            if not affected then
                tes3.cast({ reference = e.attacker, spell = "kl_spell_silk-grip", target = e.mobile, bypassResistances = false, instant = true })
                log:debug("Silk-Grip applied.")
            else
                tes3.cast({ reference = e.attacker, spell = "kl_spell_silk-bite", target = e.mobile, bypassResistances = true, instant = true })
                log:debug("Silk-Bite applied.")
            end
        end
    end
end

function this.mephalaTribute()
    log:trace("Mephala tribute triggered.")

    --Sacrifice Day Lapsed
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 18 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24

        if modData.tributeHours == 96 then
            if not modData.tributePaid then
                func.clMessageBox("Mephala's whispers grow louder!")
            end
        end

        if modData.tributeHours >= 120 then
            if modData.tributePaid then
                modData.tributePaid = false
                modData.tributeHours = 0
                local light = tes3.createReference({ object = "kl_light_purple_256", position = clerics[i].mobile.position, cell = clerics[i].mobile.cell, orientation = clerics[i].mobile.orientation  })
                tes3.playSound({ sound = "mysticism cast", reference = clerics[i] })
                timer.start({ type = timer.simulate, duration = 4, callback = function() light:delete() end })
                func.clMessageBox("" .. clerics[i].object.name .. " feels their power begin to wane. The Webspinner commands betrayal!")
            end
        end
    end
end

function this.mephalaSacrifice(e)
    if e.attacker == nil then return end
    
    log:trace("Mephala sacrifice triggered.")

    if e.killingBlow then
        if e.attacker == tes3.mobilePlayer or func.validCompanionCheck(e.attacker) then
            local disposition = e.mobile.object.disposition
            if not disposition then
                disposition = e.mobile.object.baseDisposition
                log:debug("Base disposition used.")
            end
            if not disposition then return end
            if disposition < 70 then return log:debug("Disposition below 70.") end

            local npcTable = func.npcTable()
            local clerics = {}
        
            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
        
                if modData.patron and modData.patron == 18 and modData.tributePaid == false then
                    clerics[#clerics + 1] = reference
                    break
                end
            end

            if #clerics >= 1 then
                for i = 1, #clerics do
                    local modData = func.getModData(clerics[i])
                    modData.tributePaid = true
                    modData.tributeHours = 0
                    tes3.playSound({ sound = "mysticism hit", reference = e.mobile, volume = 0.9 })
                    tes3.createVisualEffect({ object = "VFX_MysticismHit", lifespan = 3, reference = e.mobile })
                    log:debug("" .. clerics[i].object.name .. " betrayed " .. e.mobile.object.name .. " in tribute to Mephala.")
                    func.clMessageBox("" .. clerics[i].object.name .. " betrayed " .. e.mobile.object.name .. " in tribute to Mephala.")
                end
            end
        end
    end
end

--Meridia--------------------------------------------------------------------------------------------------------------------------------------------------
function this.meridiaTribute()
    log:trace("Meridia tribute triggered.")

    --Tribute Day Lapsed
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 19 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24

        if modData.tributeHours == 48 then
            if not modData.tributePaid then
                func.clMessageBox("Meridia demands judgment! Go forth and purify!")
            end
        end

        if modData.tributeHours >= 72 then
            if modData.tributePaid then
                modData.tributePaid = false
                modData.tributeHours = 0
                tes3.playSound({ sound = "restoration area", reference = clerics[i] })
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_patron_19" })
                func.clMessageBox("" .. clerics[i].object.name .. "'s favor with Meridia begins to wane, and their powers with it!")
            end
        end
    end
end

function this.meridiaGift(e)
    
    if config.combatAbilities == false then return end
    log:trace("Meridia Gift triggered.")

    if e.attacker and func.validCompanionCheck(e.attacker) then
        local modData = func.getModData(e.attacker.reference)
        if modData.patron and modData.patron == 19 and modData.tributePaid then
            local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_beacon" })
            if not affected then
                tes3.cast({ reference = e.attacker, spell = "kl_spell_beacon", target = e.mobile, bypassResistances = true, instant = true })
                if (e.mobile.object.type and e.mobile.object.type == tes3.creatureType.undead) or e.mobile.hasVampirism then
                    tes3.cast({ reference = e.attacker, spell = "kl_spell_searing_beacon", target = e.mobile, bypassResistances = false, instant = true })
                end
            end
        end
    end
end

function this.meridiaSacrifice(e)
    if e.attacker == nil then return end
    
    log:trace("Meridia sacrifice triggered.")

    if string.startswith(e.mobile.object.name, "Summoned") then return end

    if e.killingBlow then
        if (e.attacker == tes3.mobilePlayer or func.validCompanionCheck(e.attacker)) and ((e.mobile.object.type and e.mobile.object.type == tes3.creatureType.undead) or e.mobile.hasVampirism) then
            local npcTable = func.npcTable()
            local clerics = {}
        
            for i = 1, #npcTable do
                local reference = npcTable[i]
                local modData = func.getModData(reference)
        
                if modData.patron and modData.patron == 19 and modData.tributePaid == false then
                    clerics[#clerics + 1] = reference
                    break
                end
            end

            if #clerics >= 1 then
                for i = 1, #clerics do
                    local modData = func.getModData(clerics[i])
                    modData.tributePaid = true
                    modData.tributeHours = 0
                    tes3.addSpell({ reference = clerics[i], spell = "kl_ability_patron_19" })
                    tes3.playSound({ sound = "restoration hit", reference = e.mobile, volume = 0.9 })
                    tes3.createVisualEffect({ object = "VFX_RestorationHit", lifespan = 3, reference = e.mobile })
                    log:debug("" .. clerics[i].object.name .. " regained Meridia's favor!")
                    func.clMessageBox("False life purified! " .. clerics[i].object.name .. " regained Meridia's favor!")
                end
            end
        end
    end
end

--Molag Bal-------------------------------------------------------------------------------------------------------------------------------------------------
function this.molagTribute(e)
    
    log:trace("Molag tribute triggered.")

    local npcTable = func.npcTable()
    local answer = true

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 20 then
            answer = false
            break
        end
    end

    return answer
end

function this.molagGift(e)
    
    log:trace("Molag gift triggered.")

    if not e.killingBlow or not e.attacker then return end

    if e.attacker == tes3.mobilePlayer or func.validCompanionCheck(e.attacker) then
        local npcTable = func.npcTable()

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)
    
            if modData.patron and modData.patron == 20 and modData.soulEnergy < modData.level * 100 then
                local soul = 500
                if e.mobile.object.soul then
                    soul = e.mobile.object.soul
                end
                log:debug("" .. e.mobile.object.name .. " Soul Value: " .. soul .. "")
                modData.soulEnergy = modData.soulEnergy + math.round(soul * 0.1)
                if modData.soulEnergy > modData.level * 100 then
                    modData.soulEnergy = modData.level * 100
                end
                local light = tes3.createReference({ object = "kl_light_azure_64", position = e.mobile.position, cell = e.mobile.cell, orientation = e.mobile.orientation  })
                timer.start({ type = timer.simulate, duration = 2, callback = function() light:delete() end })
                tes3.playSound({ sound = "mysticism hit", reference = e.mobile, volume = 0.6, pitch = 0.7 })
                tes3.createVisualEffect({ object = "VFX_MysticismHit", lifespan = 2, reference = reference })
                break
            end
        end
    end
end

--Namira----------------------------------------------------------------------------------------------------------------------------------------------------
function this.namiraTribute(ref)
    
    log:trace("Namira tribute triggered.")

    local modData = func.getModData(ref)

    tes3.modStatistic({ reference = ref, attribute = tes3.attribute.personality, value = -1 })
    tes3.modStatistic({ reference = ref, attribute = tes3.attribute.endurance, value = -1 })
    modData.att_gained[7] = modData.att_gained[7] - 1
    modData.att_gained[6] = modData.att_gained[6] - 1

    timer.start({ type = timer.simulate, duration = 5, iterations = 1, callback = function() func.clMessageBox("" .. ref.object.name .. " is affected by Namira's decay.") end })
    log:debug("" .. ref.object.name .. " is affected by Namira's decay.")
end

function this.namiraGift(e)
    
    if config.combatAbilities == false then return end
    log:trace("Namira Gift triggered.")
    
    local gameHour = tes3.getGlobal('GameHour')

    if gameHour > 22 or gameHour < 5 then
        if e.attacker then
            if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
                local modData = func.getModData(e.attacker.reference)
    
                if modData.patron and modData.patron == 21 then
                    local affected = tes3.isAffectedBy({ reference = e.mobile, object = "kl_spell_namira_decay" })
                    if not affected then
                        --Decay
                        tes3.cast({ reference = e.attacker, target = e.mobile, spell = "kl_spell_namira_decay", instant = true, bypassResistances = true })
                        log:debug("Foe struck with Namira's decay.")
                    end
                end
            end
        end
    end
end

--Nocturnal--------------------------------------------------------------------------------------------------------------------------------------------------
function this.nocturnalGift(ref)
    
    if config.triggeredAbilities == false then return end
    log:trace("Nocturnal Gift triggered.")

    local lock = tes3.getLockLevel({ reference = ref })

    if lock and lock < 51 then
        local npcTable = func.npcTable()
    
        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)
    
            if modData.patron and modData.patron == 22 then
                tes3.unlock({ reference = ref })
                tes3.createVisualEffect({ object = "VFX_AlterationHit", lifespan = 2, reference = ref })
                log:debug("" .. ref.object.name .. " unlocked by Evergloam Shadows.")
            end
        end
    end
end

--Peryite-----------------------------------------------------------------------------------------------------------------------------------------------------
function this.peryiteTribute(ref)
    for i = 1, 17 do
        local affected = tes3.isAffectedBy({ reference = ref, object = "kl_disease_blessing_" .. i ..""})

        if affected then
            tes3.removeSpell({ spell = "kl_disease_blessing_" .. i .."", reference = ref })

            local id = 0
            local exists = true
            repeat
                id = id + 1
                exists = tes3.getObject("kl_ability_peryite_" .. i .."_" .. id .. "")
            until exists == nil

            local ability = tes3.getObject("kl_ability_peryite_" .. i .."")
            local spell = tes3.createObject({ objectType = tes3.objectType.spell, id = "kl_ability_peryite_" .. i .."_" .. id .. "", castType = tes3.spellType.ability })
            spell.name = ability.name
            for n, effect in ipairs(ability.effects) do
                local newEffect = spell.effects[n]
                newEffect.id = effect.id
                newEffect.rangeType = effect.rangeType
                newEffect.attribute = effect.attribute
                newEffect.min = effect.min
                newEffect.max = effect.max
            end

            local wasAdded = tes3.addSpell({ reference = ref, spell = spell })

            if wasAdded then
                local light = tes3.createReference({ object = "kl_light_green_256", position = ref.mobile.position, cell = ref.mobile.cell, orientation = ref.mobile.orientation  })
                tes3.playSound({ sound = "restoration cast", reference = ref })
                timer.start({ type = timer.simulate, duration = 4, callback = function() light:delete() end })
                log:debug("" .. ref.object.name .. " received " .. ability.name .. " #" .. id .. " from Peryite.")
                timer.start({ type = timer.simulate, duration = 1, callback = function() func.clMessageBox("" .. ref.object.name .. " received " .. ability.name .. " #" .. id .. " from Peryite.") end })
            end
        end
    end
    local num = math.random(1, 17)
    tes3.addSpell({ reference = ref, spell = "kl_disease_blessing_" .. num .. ""})
    log:debug("" .. tes3.getObject("kl_disease_blessing_" .. num .."").name .. " disease received from Peryite.")
    timer.start({ type = timer.simulate, duration = 3, callback = function() func.clMessageBox("" .. tes3.getObject("kl_disease_blessing_" .. num .."").name .. " disease received from Peryite.") end })
end

--Sanguine (Aura)------------------------------------------------------------------------------------------------------------------------
function this.sanguineTribute()
    log:trace("Sanguine tribute triggered.")

    --Cyrodiilic Brandy every 4 days at 2am
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 24 then
            clerics[#clerics + 1] = npcTable[i]
            break
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 24
    
        if modData.tributeHours >= 96 then
            local paid = false
    
            paid = func.checkReq(false, "potion_cyro_brandy_01", 1, clerics[i])
            if not paid then
                paid = func.checkReq(false, "potion_cyro_brandy_01", 1, tes3.player)
            end
        
            modData.tributePaid = paid
    
            if paid then
                modData.tributeHours = 0
                tes3.playSound({ sound = "Item Potion Up", reference = clerics[i], volume = 0.9, pitch = 0.9 })
                func.clMessageBox("" .. clerics[i].object.name .. " poured their libation in tribute to Sanguine.")
            else
                func.clMessageBox("" .. clerics[i].object.name .. " failed to give tribute to Sanguine. Tribute may be offered again in 4 days.")
                timer.start({ type = timer.simulate, duration = 2, callback = function()
                    local party = func.partyTable()
                    for n = 1, #party do
                        local removed = tes3.removeSpell({ reference = party[n], spell = "kl_ability_blood_ardor" })
                        if removed then
                            tes3.cast({ reference = party[n], target = party[n], spell = "kl_spell_hangover", instant = true, bypassResistances = true })
                        end
                    end
                end })
            end
        end
    end
end

function this.sanguineGift()
    
    log:trace("Sanguine Gift triggered.")

    local party = func.partyTable()

    local trigger = 0
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.patron and modData.patron == 24 and modData.tributePaid then
            trigger = 1
            break
        end
    end

    if trigger == 1 then
        --Confer Aura
        for n = 1, #party do
            local ref = party[n]
            tes3.addSpell({ reference = ref, spell = "kl_ability_blood_ardor" })
        end
        log:debug("Blood Ardor added to party.")
    else
        --Remove Aura
        for n = 1, #party do
            local ref = party[n]
            tes3.removeSpell({ reference = ref, spell = "kl_ability_blood_ardor" })
        end
        log:debug("Blood Ardor removed from party.")
    end
end

--Sheogorath----------------------------------------------------------------------------------------------------------------------
function this.sheoCombat(e)
    if config.combatAbilities == false then return end

    
    log:trace("Sheogorath Combat triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local npcTable = func.npcTable()
        local trigger = 0
        local cleric

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)
            if modData.patron and modData.patron == 25 then
                trigger = 1
                log:debug("Sheogorath took an interest in the fight!")
                func.clMessageBox("Sheogorath took an interest in the fight!")
                cleric = reference
                break
            end
        end

        if trigger == 1 then
            local num = math.random(1, 13)
            if num == 1 then
                local cell = tes3.getPlayerCell()
                local pos = func.calculatePosition()
                local num2 = math.random(1, 10)
                local ref

                if num2 == 1 then
                    --Friendly Scamp
                    tes3.cast({ reference = tes3.player, target = tes3.player, spell = "summon scamp", instant = true })
                elseif num2 == 2 then
                    --Unfriendly Scamp
                    ref = tes3.createReference({ object = "scamp", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                elseif num2 == 3 then
                    --Friendly Saint
                    tes3.cast({ reference = tes3.player, target = tes3.player, spell = "summon golden saint", instant = true })
                elseif num2 == 4 then
                    --Unfriendly Saint
                    ref = tes3.createReference({ object = "golden saint", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                elseif num2 == 5 then
                    --Friendly Atronach
                    tes3.cast({ reference = tes3.player, target = tes3.player, spell = "summon storm atronach", instant = true })
                elseif num2 == 6 then
                    --Unfriendly Atronach
                    ref = tes3.createReference({ object = "atronach_storm", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                elseif num2 == 7 then
                    --Imperial Guard
                    ref = tes3.createReference({ object = "Imperial Guard", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                elseif num2 == 8 then
                    --4 Rats
                    tes3.createReference({ object = "rat", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                    tes3.createReference({ object = "rat", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                    tes3.createReference({ object = "rat", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                    ref = tes3.createReference({ object = "rat", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                elseif num2 == 9 then
                    --Mudcrab
                    ref = tes3.createReference({ object = "mudcrab", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                    ref.mobile.fight = 20
                else
                    --Ordinator
                    ref = tes3.createReference({ object = "ordinator wander", cell = cell, position = pos, orientation = tes3.getPlayerEyeVector()})
                end
                if ref then
                    tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 2, reference = ref })
                end
                log:debug("Sheogorath summoned something!")
            elseif num == 2 then
                --Cast on Foes
                local spell = tables.destructionTable3[math.random(1, #tables.destructionTable3)]
                if math.random(1, 2) == 2 then
                    spell = tables.illusionTable3[math.random(1, #tables.illusionTable3)]
                end
                for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                    tes3.cast({ reference = actor.reference, target = actor.reference, spell = spell, instant = true, bypassResistances = false })
                end
                log:debug("Sheogorath attacked your foes!")
            elseif num == 3 then
                --Cast on Party
                local spell = tables.destructionTable3[math.random(1, #tables.destructionTable3)]
                if math.random(1, 2) == 2 then
                    spell = tables.illusionTable3[math.random(1, #tables.illusionTable3)]
                end
                local party = func.partyTable()
                for i = 1, #party do
                    tes3.cast({ reference = party[i], target = party[i], spell = spell, instant = true, bypassResistances = false })
                end
                log:debug("Sheogorath attacked the party!")
            elseif num == 4 then
                --Attack Everyone
                local spell = tables.destructionTable3[math.random(1, #tables.destructionTable3)]
                if math.random(1, 2) == 2 then
                    spell = tables.illusionTable3[math.random(1, #tables.illusionTable3)]
                end
                local party = func.partyTable()
                for i = 1, #party do
                    tes3.cast({ reference = party[i], target = party[i], spell = spell, instant = true, bypassResistances = false })
                end
                for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                    tes3.cast({ reference = actor.reference, target = actor.reference, spell = spell, instant = true, bypassResistances = false })
                end
                log:debug("Sheogorath attacked everyone!")
            elseif num == 5 then
                --Transform Enemies
                local num2 = math.random(1, 3)
                if num2 == 1 then
                    --Scribs
                    for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                        local ref = tes3.createReference({ object = "scrib", cell = actor.cell, position = actor.position, orientation = actor.orientation })
                        tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 2, reference = ref })
                        if math.random(1, 2) == 2 then
                            tes3.applyMagicSource({
                                reference = ref,
                                name = "Invisible!?",
                                effects = {
                                    { id = tes3.effect.invisibility,
                                        min = 1,
                                        max = 1,
                                        duration = 180 }
                                },
                            })
                        end
                        actor.reference:disable()
                    end
                elseif num2 == 2 then
                    --Flaming Dogs
                    for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                        local ref = tes3.createReference({ object = "BM_wolf_grey", cell = actor.cell, position = actor.position, orientation = actor.orientation })
                        tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 2, reference = ref })
                        tes3.applyMagicSource({
                            reference = ref,
                            name = "ON FIRE!",
                            effects = {
                                { id = tes3.effect.fireDamage,
                                    min = 1,
                                    max = 1,
                                    duration = 120 }
                            },
                        })
                        tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 120, reference = ref })
                        actor.reference:disable()
                    end
                else
                    --Hunger
                    for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                        local ref = tes3.createReference({ object = "hunger", cell = actor.cell, position = actor.position, orientation = actor.orientation })
                        tes3.createVisualEffect({ object = "VFX_DefaultHit", lifespan = 2, reference = ref })
                        actor.reference:disable()
                    end
                end
                log:debug("Sheogorath transformed your foes!")
            elseif num == 6 then
                --Teleport
                local num2 = math.random(1, 3)
                if num2 == 1 then
                    tes3.cast({ reference = tes3.player, target = tes3.player, spell = "divine intervention", instant = true, bypassResistances = true })
                elseif num2 == 2 then
                    tes3.cast({ reference = tes3.player, target = tes3.player, spell = "almsivi intervention", instant = true, bypassResistances = true })
                end
                log:debug("Sheogorath teleported you!")
            elseif num == 7 then
                --Knockdown
                local num2 = math.random(1, 2)

                if num2 == 1 then
                    --Knockdown Enemies
                    for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                        actor:hitStun({ knockDown = true })
                    end
                    log:debug("Sheogorath stunned the enemies!")
                else
                    --Knockdown Allies
                    local party = func.partyTable()
                    for i = 1, #party do
                        party[i].mobile:hitStun({ knockDown = true })
                    end
                    log:debug("Sheogorath knocked you all down!")
                end
            elseif num == 8 then
                --Stop Combat, make passive
                for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                    actor.fight = 40
                    actor:stopCombat(true)
                end
                local party = func.partyTable()
                for i = 1, #party do
                    party[i].mobile:stopCombat(true)
                end
                log:debug("Sheogorath decided you should be friends!")
            elseif num == 9 then
                --BLINDED!
                tes3.applyMagicSource({
                    reference = tes3.player,
                    name = "HAHA BLINDED!!",
                    effects = {
                        { id = tes3.effect.blind,
                            min = 100,
                            max = 100,
                            duration = 12 }
                    },
                    bypassResistances = true
                })
                log:debug("Sheogorath blinded you!")
            elseif num == 10 then
                --Make 1 Clone
                --Enemy Clone
                for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                    local ref = tes3.createReference({ object = actor.object, cell = actor.cell, position = actor.position, orientation = actor.orientation })
                    if math.random(1, 2) == 2 then
                        --Evil Twin
                        ref.mobile.fight = 40
                        ref.mobile:startCombat(actor)
                    end
                    timer.start({ type = timer.simulate, duration = 90, callback = function() ref:disable() end })
                    log:debug("Sheogorath cloned an enemy!")
                    break
                end
            elseif num == 11 then
                --Heal
                if math.random(1, 2) == 2 then
                    local party = func.partyTable()
                    for i = 1, #party do
                        tes3.cast({ reference = party[i], target = party[i], spell = "hearth heal", instant = true, bypassResistances = true })
                        tes3.cast({ reference = party[i], target = party[i], spell = "regenerate", instant = true, bypassResistances = true })
                    end
                    log:debug("Sheogorath healed the party!")
                else
                    for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "hearth heal", instant = true, bypassResistances = true })
                        tes3.cast({ reference = actor.reference, target = actor.reference, spell = "regenerate", instant = true, bypassResistances = true })
                    end
                    log:debug("Sheogorath healed the enemies!")
                end
            elseif num == 12 then
                --Items
                local num2 = math.random(1, 3)
                if num2 == 1 then
                    --Silly Fork :)
                    tes3.addItem({ reference = tes3.player, item = "kl_misc_silly_fork" })
                elseif num2 == 2 then
                    --Dull, Dumb Knife
                    tes3.addItem({ reference = tes3.player, item = "kl_misc_dull_knife" })
                else
                    --Filled Spoon
                    tes3.addSoulGem({ item = "kl_misc_filled_spoon" })
                    tes3.addItem({ reference = tes3.player, item = "kl_misc_filled_spoon", soul = tes3.getObject("kl_ghost_sheo") })
                end
                log:debug("Sheogorath gave you a present!")
            elseif num == 13 then
                --Kill All Enemies
                for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                    actor:kill()
                end
            end
            timer.start({ type = timer.simulate, duration = 1, callback =
            function()
                local light = tes3.createReference({ object = "kl_light_purple_256", position = cleric.mobile.position, cell = cleric.mobile.cell, orientation = cleric.mobile.orientation  })
                tes3.playSound({ soundPath = "companionLeveler\\sheo_" .. math.random(1, 4) .. ".wav", volume = 1.1 })
                timer.start({ type = timer.simulate, duration = 4, callback = function() light:delete() end})
            end })
        end
	end
end

--Vaermina------------------------------------------------------------------------------------------------------------------------
function this.vaerminaGift()
    log:trace("Vaermina gift triggered.")

    --Reset Nightmare CD
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 26 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = 0

        if modData.tributePaid then
            if config.expMode then
                local num = math.random(1, 10)
                modData.lvl_progress = modData.lvl_progress + num
            end
            modData.tributePaid = false
            timer.start({ type = timer.simulate, duration = 2, callback = function() func.clMessageBox("Vaermina sent " .. clerics[i].object.name .. " a nightmare.") end})
        end
        timer.delayOneFrame(function()
            tes3.addSpell({ reference = clerics[i], spell = "kl_ability_nightmare", bypassResistances = true })
        end)
    end
end

function this.vaerminaTribute()
    log:trace("Vaermina tribute triggered.")

    --Sleepy Timer
    local clerics = {}
    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local modData = func.getModData(npcTable[i])

        if modData.patron and modData.patron == 26 then
            clerics[#clerics + 1] = npcTable[i]
        end
    end

    for i = 1, #clerics do
        local modData = func.getModData(clerics[i])
        modData.tributeHours = modData.tributeHours + 1

        if tes3.mobilePlayer.sleeping then
            modData.tributeHours = 0
        end
    
        if modData.tributeHours >= 24 then
            timer.delayOneFrame(function()
                tes3.removeSpell({ reference = clerics[i], spell = "kl_ability_nightmare" })
                func.clMessageBox("" .. clerics[i].object.name .. "'s nightmare is at an end...")
            end)
        end

        --Reset EXP CD
        local gameHour = tes3.getGlobal('GameHour')
        if gameHour < 1 then
            modData.tributePaid = true
        end
    end
end

function this.nightmare(e)
    if config.combatAbilities == false then return end

    
    log:trace("Nightmare triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local npcTable = func.npcTable()
        local trigger = 0
        local caster

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)
            if modData.patron and modData.patron == 26 and tes3.isAffectedBy({ reference = reference, object = "kl_ability_nightmare"}) then
                trigger = 1
                caster = reference
                log:debug("" .. caster.object.name .. "'s waking nightmare spills forth!")
                break
            end
        end

        if trigger == 1 then
            for actor in tes3.iterate(tes3.mobilePlayer.hostileActors) do
                local affected = tes3.isAffectedBy({ reference = actor.reference, object = "kl_spell_vaermina_nightmare" })
                if not affected then
                    tes3.cast({ reference = caster, target = actor.reference, spell = "kl_spell_vaermina_nightmare", instant = true, bypassResistances = false })
                    log:debug("" .. actor.reference.object.name .. " was affected by " .. caster.object.name .. "'s nightmare!")
                else
                    log:debug("" .. actor.reference.object.name .. " is already affected by Waking Nightmare.")
                end
            end
        end
	end
end

--Rebate #147---------------------------------------------------------------------------------------------------------------------------------------
function this.accountant(e)
    if config.triggeredAbilities == false or e.value >= 0 then return end

    log:trace("Accountant Triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local ref = npcTable[i]
        local modData = func.getModData(ref)

        if modData.abilities[147] == true then
            local merc = ref.mobile:getSkillStatistic(24).current
            local amount = merc / 1500
            if amount > 0.1 then
                amount = 0.1
            end

            if modData.rebate then
                modData.rebate = modData.rebate + ((e.value * -1) * amount)
            else
                modData["rebate"] = ((e.value * -1) * amount)
            end

            break
        end
    end
end

--Searing Armament #148-------------------------------------------------------------------------------------------------------------------------
function this.sear(e)
    if config.combatAbilities == false then return end

    log:trace("Sear triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.abilities[148] then
                --Destruction Damage Bonus
                local result = 0
                local dest = e.attacker:getSkillStatistic(10)
                result = math.round(dest.current / 15)

                if result > 10 then
                    result = 10
                elseif result < 2 then
                    result = 2
                end

                --Damage Health
                tes3.applyMagicSource({
                    reference = e.mobile,
                    name = "Sear",
                    effects = {
                        { id = tes3.effect.damageHealth,
                            min = math.round(result / 3),
                            max = result }
                    },
                })
                --Fire Damage
                if (e.mobile.object.type and e.mobile.object.type == tes3.creatureType.undead) or e.mobile.hasVampirism then
                    tes3.applyMagicSource({
                        reference = e.mobile,
                        name = "Greater Sear",
                        effects = {
                            { id = tes3.effect.fireDamage,
                                min = math.round(result / 2),
                                max = result }
                        },
                    }
                )
                end
                tes3.playSound({ sound = "destruction hit", reference = e.mobile.reference, volume = 0.8 })
                tes3.createVisualEffect({ object = "VFX_DestructHit", lifespan = 2, reference = e.mobile })
                log:debug("Sear spell damage added!")
            end
        end
    end
end

--Battle Chant #149--------------------------------------------------------------------------------------------------------------
function this.triggerChant(e)
    if config.combatAbilities == false then return end

    log:trace("Trigger Chant triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        this.battleChant()
	end
end

function this.battleChant()
    log:trace("Battle Chant triggered.")

    if not tes3.mobilePlayer.inCombat then return end

    local npcTable = func.npcTable()
    local trigger = 0
    local speechcraft
    local caster

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)
        if modData.abilities[149] then
            trigger = 1
            caster = reference.object.name
            speechcraft = reference.mobile:getSkillStatistic(25)
            log:debug("" .. caster .. " attempted to Chant.")
            break
        end
    end

    if trigger == 1 then
        local partyTable func.partyTable()
        local obj = tes3.getObject("kl_spell_skald" .. math.random(1, 4))

        for i = 1, #partyTable do
            local affected = tes3.isAffectedBy({ reference = partyTable[i], object = obj })

            if not affected then
                tes3.cast({ reference = partyTable[i], target = partyTable[i], spell = obj, instant = true, bypassResistances = false })
                log:debug("" .. partyTable[i].object.name .. " was affected by " .. obj.name .. "!")
            else
                log:debug("" .. partyTable[i].object.name .. " is already affected by " .. obj.name .. ".")
            end

            local affected2 = tes3.isAffectedBy({ reference = partyTable[i], effect = tes3.effect.silence })

            if affected2 then
                partyTable[i].mobile.silence = 0
                log:debug("" .. partyTable[i].object.name .. " was cured of Silence!")
            end
        end

        local num = math.round(speechcraft.current / 20)
        if num > 7 then
            num = 7
        end

        timer.start({ type = timer.simulate, duration = 9 - num, callback = this.battleChant })
    end
end

--Boundless #150-------------------------------------------------------------------------------------------------------
function this.boundless()

    log:trace("Boundless triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[150] then
            if modData.secrets then
                modData.secrets = modData.secrets + 1
            else
                modData["secrets"] = 1
            end
            local num = 1000 - (reference.mobile:getSkillStatistic(14).current * 5)
            if num < 250 then
                num = 250
            end

            if modData.secrets >= num and modData.tp_current < modData.tp_max then
                modData.tp_current = modData.tp_current + 1
                modData.secrets = modData.secrets - num
                if modData.secrets < 0 then
                    modData.secrets = 0
                end
                func.clMessageBox("" .. reference.object.name .. " used secret knowledge to manifest a technique point!")
            end
        end
    end
end

--Dragon Leap #154--------------------------------------------------------------------------------------------------------
function this.dragonLeap(e)
    if config.combatAbilities == false then return end

    log:trace("Dragon Leap triggered.")

	if (e.target == tes3.mobilePlayer) then
        log:trace("Combat target is player.")
        local npcTable = func.npcTable()

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)

            if modData.abilities[154] then
                local pos = e.actor.position
                local dist = pos:distance(npcTable[i].position)

                if dist > 450 then
                    tes3.positionCell({ reference = npcTable[i], cell = e.actor.cell, position = pos })
                    log:debug("Dragon Leap executed on " .. npcTable[i].object.name .. ".")
                end
            end
        end
	end
end


--Bloodlines-------------------------------------------------------------------------------------------------------------

--Berne
function this.criticalFang(e)
    if config.combatAbilities == false then return 0 end
    log:trace("Critical Fang triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.bloodline and modData.bloodline == 2 and modData.fed then
                --Crit Chance
                if math.random(1, 100) <= 12 then
                    answer = e.damage
                    tes3.playSound({ sound = "critical damage", reference = e.attacker, volume = 0.8 })
                    log:debug("" .. tables.bloodlines[modData.bloodline] .. " critical!")
                end
            end
        end
    end

    return answer
end

--Quarra
function this.bloodFrenzy(e)
    if config.combatAbilities == false then return 0 end
    log:trace("Blood Frenzy triggered.")

    local answer = 0

    if e.attacker then
        if func.validCompanionCheck(e.attacker) and e.attacker.actorType == 1 then
            local modData = func.getModData(e.attacker.reference)

            if modData.bloodline and modData.bloodline == 3 then
                local dmg = math.round(e.damage * (modData.bloodFrenzy / 100))
                answer = dmg
                log:debug("" .. dmg .. " Blood Frenzy damage added.")
            end
        end
    end

    return answer
end

function this.breakBloodFrenzy()
    log:trace("Blood Frenzy Break triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.bloodline then
            if modData.bloodline == 3 then
                modData.bloodFrenzy = 0
                func.clMessageBox("" .. reference.object.name .. "'s Blood Frenzy has been quelled.")
                local removed = { false, false, false, false }
                for n = 1, 4 do
                    local rem = tes3.removeSpell({ reference = reference, spell = "kl_ability_clouded_" .. n})
                    if rem then removed[n] = true end
                end
                for n = 1, 4 do
                    if removed[n] then
                        func.clMessageBox("" .. reference.object.name .. "'s mind is no longer clouded!")
                        break
                    end
                end
            end
        end
    end
end

--On Kill
function this.killFeed(e)
    log:trace("Feed on Kill check triggered.")

    if e.mobile.actorType == 1 then
        log:debug("Humanoid death detected.")
        local npcTable = func.npcTable()

        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)

            if modData.bloodline then
                log:debug("Vampiric Bloodline detected.")
                if modData.bloodline == 3 then
                    log:debug("Bloodline 3 detected.")
                    modData.fed = true
                    modData.fedHours = 0
                    modData.bloodFrenzy = modData.bloodFrenzy + math.random(1, 2)
                    log:debug("Blood Frenzy accumulated.")
                    if modData.bloodFrenzy > 40 then
                        modData.bloodFrenzy = 40
                    end
                    if modData.bloodFrenzy > 9 then
                        local added = tes3.addSpell({ reference = reference, spell = "kl_ability_clouded_1"})
                        if added then func.clMessageBox("" .. reference.object.name .. "'s mind becomes clouded with frenzy.") end
                    end
                    if modData.bloodFrenzy > 19 then
                        local added = tes3.addSpell({ reference = reference, spell = "kl_ability_clouded_2"})
                        if added then func.clMessageBox("" .. reference.object.name .. "'s clouded mind worsens as the frenzy deepens!") end
                    end
                    if modData.bloodFrenzy > 29 then
                        local added = tes3.addSpell({ reference = reference, spell = "kl_ability_clouded_3"})
                        if added then func.clMessageBox("" .. reference.object.name .. "'s becoming drunk with frenzy!") end
                    end
                    if modData.bloodFrenzy > 39 then
                        local added = tes3.addSpell({ reference = reference, spell = "kl_ability_clouded_4"})
                        if added then func.clMessageBox("" .. reference.object.name .. " is losing themselves to the Blood Frenzy!!") end
                    end
                end
                if (modData.bloodline > 6 and modData.bloodline < 13) or modData.bloodline == 14 then
                    modData.fed = true
                    modData.fedHours = 0
                end
            end
        end
    end
end

--Volkihar/Tenarr Zalviit
function this.sunWeaken(e)
    log:trace("Sun Weakening triggered.")

    local npcTable = func.npcTable()
    local gameHour = tes3.getGlobal('GameHour')
    local trigger = false
    if gameHour > 6 and gameHour < 20 and e.cell.isOrBehavesAsExterior then
        trigger = true
    end

    if trigger then
        for i = 1, #npcTable do
            local reference = npcTable[i]
            local modData = func.getModData(reference)

            if modData.bloodline then
                if modData.bloodline == 5 then
                    for i = 1, 4 do
                        if modData.stage == i then
                            tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_" .. i })
                        else
                            tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_" .. i })
                        end
                    end
                elseif modData.bloodline == 15 then
                    tes3.addSpell({ reference = npcTable[i], spell = "kl_ability_tenarr_sun" })
                end
            end
        end
    else
        for i = 1, #npcTable do
            for n = 1, 4 do
                tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_volk_sun_" .. n })
            end
            tes3.removeSpell({ reference = npcTable[i], spell = "kl_ability_tenarr_sun" })
        end
    end
end

--Khulari
function this.khulariReaping(e)
    if config.combatAbilities == false then return end
    
    log:trace("Khulari Reaping triggered.")

    if e.attacker ~= nil and tes3.isAffectedBy({ reference = e.mobile, effect = 45 }) then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.bloodline then
                if modData.bloodline == 9 then
                    tes3.applyMagicSource({
                        reference = e.attacker,
                        name = "Khulari Reaping",
                        effects = {
                            { id = tes3.effect.restoreHealth,
                                min = 1,
                                max = 3,
                                duration = 3 }
                        },
                    })
                end
            end
        end
    end
end

--Lyrezi
function this.lyreziStifling(e)
    if config.combatAbilities == false then return end
    
    log:trace("Lyrezi Stifling triggered.")

    if e.attacker ~= nil then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if modData.bloodline then
                if modData.bloodline == 10 then
                    if math.random(1, 6) == 6 then
                        tes3.applyMagicSource({
                            reference = e.attacker,
                            name = "Lyrezi Stifling",
                            effects = {
                                { id = tes3.effect.silence,
                                    duration = 4 }
                            },
                        })
                    end
                end
            end
        end
    end
end

--Montalion
function this.montLair(e)
    log:trace("Montalion Lair check triggered.")

    local npcTable = func.npcTable()

    for i = 1, #npcTable do
        local ref = npcTable[i]
        local modData = func.getModData(ref)

        if modData.bloodline then
            if modData.lair_mark ~= nil then
                --log:debug("Cell: " .. e.cell.id .. " Lair: " .. modData.lair_mark[i] .. "")
                if e.cell.id == modData.lair_mark[1] then
                    tes3.addSpell({ reference = ref, spell = "kl_ability_mont_heal" })
                else
                    tes3.removeSpell({ reference = ref, spell = "kl_ability_mont_heal" })
                end
            end
        end
    end
end

--Vraseth
function this.nimbleness(e)
    
    if config.combatAbilities == false then return e.damage end
    log:trace("Nimbleness triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.mobile) then
            local modData = func.getModData(e.mobile.reference)

            if modData.bloodline and modData.bloodline == 14 then
                --Parry Chance
                if math.random(1, 7) == 7 then
                    log:debug("Vraseth parry!")
                    return 0
                else
                    return e.damage
                end
            end
        end
    end

    return e.damage
end
--------------------------------------------------------


--Trafficker's Bounty #157----------------------------------------------------------------------
function this.detectSlave()
    
    log:trace("Slave Detection triggered.")

    local trigger = 0
    local npcTable = func.npcTable()
    local name = ""

    for i = 1, #npcTable do
        local reference = npcTable[i]
        local modData = func.getModData(reference)

        if modData.abilities[157] then
            trigger = 1
            name = reference.object.name
            break
        end
    end

    if trigger == 1 then
        --Detect Slaves
        for refe in tes3.getPlayerCell():iterateReferences({ tes3.objectType.npc }) do
            if refe.cell == tes3.getPlayerCell() and refe.disabled == false then
                if string.startswith(refe.object.class.id, "Slave") then
                    local num = math.random(1, 3)
                    if num == 1 then
                        func.clMessageBox("" .. name .. " senses a slave nearby.")
                    elseif num == 2 then
                        func.clMessageBox("" .. name .. " thinks there may be some slaves here.")
                    else
                        func.clMessageBox("" .. name .. " detected a slave.")
                    end
                    break
                end
            end
        end
    end
end

--Hexblade #160-----------------------------------------------------------------------------------------------------------------
function this.hexblade(e)
    if config.combatAbilities == false then return end
    
    log:trace("Hexblade triggered.")

    if e.attacker then
        if func.validCompanionCheck(e.attacker) then
            local modData = func.getModData(e.attacker.reference)

            if e.attacker.actorType == 1 and modData.abilities[160] then
                --Damage Random Attribute
                local num = math.random(0, 7)
                tes3.applyMagicSource({
                    reference = e.mobile,
                    name = "Hex",
                    effects = {
                        { id = tes3.effect.damageAttribute,
                            min = 1,
                            max = 2,
                            attribute = num}
                    },
                })
                log:debug("" .. e.attacker.reference.object.name .. " hexed " .. e.mobile.object.name .. "!")
            end
        end
    end
end








--Esoteric Ability Events--

function this.onCast(e)
    log:trace("Casting Ability Trigger triggered.")

    if e.source.objectType ~= tes3.objectType.alchemy then
        --Spell

        --Haarvenu
        if func.checkModData(e.caster) then
            local modData = func.getModData(e.caster)
            if modData.bloodline ~= nil and modData.bloodline == 8 then
                if e.source:hasEffect(14) or e.source:hasEffect(15) or e.source:hasEffect(16) or e.source:hasEffect(27) then
                    log:debug("Elemental Bloodline triggered.")
                    tes3.applyMagicSource({
                        reference = e.caster,
                        name = "Elemental Bloodline",
                        effects = {
                            { id = tes3.effect.restoreHealth,
                                min = (e.source.magickaCost / 5) / 3,
                                max = (e.source.magickaCost / 5) / 3,
                                duration = 3}
                        },
                    })
                end
            end
        end
    else
        --Potion
        if string.match(e.source.id, "kl_potion_bTincture") then
            if func.checkModData(e.caster) then
                local modData = func.getModData(e.caster)
                if modData.bloodline ~= nil and modData.bloodline == 6 then
                    log:debug("Blood Tincture triggered.")
                    modData.fed = true
                    modData.fedHours = 0
                    func.clMessageBox("" .. e.source.name .. " satisfies the hunger of " .. e.caster.object.name .. ".")
                end
            end
        end
    end
end
event.register("magicCasted", this.onCast)





return this