# Companion Leveler
Companion Leveler allows NPC and creature companions to level up with the player (Default), or through experience (Experience Mode).

In **Class Mode**, companions level up skills/attributes based on their default class (NPC companions) or default creature type (creature companions); you are also able to change an NPC's class or a creature's creature type.

In **Build Mode**, the player selects what attributes/skills their companions train as well as the amount trained per level.

Class Mode is the default setting. Also by default, health is increased by 10% of endurance, like the player (configurable). At level up, an optional summary window appears to detail the specifics of each companion's level up results.


## Class Mode:

In Class Mode, your companions level up when you do based on their default class/default creature type. You may speak to any NPC companion and ask them to "check status". You may also use the menu key (default: k key, configurable) to access the Companion Leveler menu. The prospective companion must already be following you for them to open the menu. Otherwise, you may do this at any time.

When changing class/type, the selection is memorized by the mod and does not actually change the companion's class/type or modify any files. So your Scout companion will still talk about Scout things while they train as a Mage, etc.

NPC companions have access to all player classes as well as most NPC classes, with a few exceptions.

Creature companions have access to Morrowind's original 4 creature types (Normal, Daedra, Undead, Humanoid) as well as 21 new types (Centurion, Spriggan, Goblin, Domestic, Spectral, Insectile, Draconic, Brute, Aquatic, Avian, Bestial, Impish and more). All types have favored attributes just like NPC classes, and have the additional benefit of imparting abilities the further you level into that type.

Both NPC and Creature companions have the ability to learn spells based on magic schools trained (NPCs) or creature type (creatures).



<details><summary>NPCs in Class Mode:</summary>

When leveling up, NPCs train three attributes. The first two attributes are the favored attributes of the NPC's chosen class. The 3rd attribute is an attribute chosen by random. Each attribute is raised 1-4 points on level up by default (configurable).

NPCs also train in three random Major Skills by 3, 2, and 1 points respectively (configurable). NPCs train two random Minor Skills by 2 each (also configurable). The default settings increase Major Skills by 6 and Minor Skills by 4 for a total of 10 Major/Minor per level up, like the player. In addition, 2 random skills are chosen among all skills and increased by 1 each.

NPCs are also able to gain bonuses based on their Race, Specialization, Faction, and player Mentoring.

Racial bonuses are based on the NPC's racial skill bonuses, increasing a racial skill by 1 at a 50% chance at level up. (Configurable)

Specialization Bonuses are based on the specialization of the NPC's default class, increasing an attribute and a skill by 1 each at a 50% chance at level up. (Configurable) So if an NPC's chosen class is Mage, but they were originally a Scout, their specialization bonus will be based on Scout's specialization, which is Combat.

Faction Bonuses are based on the faction the NPC belongs to, if any. Faction bonuses increase an attribute and a skill by 1 each at a 25% chance at level up, based on the faction's favored attributes and skills. (Configurable) If the NPC has no faction, they are not able to receive this bonus.

Mentor Bonuses are based on the Major Skills of the player's class, even custom ones. Mentor bonuses increase a skill by 1 a 25% chance at level up, chosen randomly from the player's Major Skills. (Configurable)

Spell Learning is also available. Whenever an NPC trains a school of magic, the NPC rolls to learn a spell of that school (50% chance configurable), chosen from a table of spells that grows larger with greater skill. (Apprentice spells at 25+, Journeyman at 50+, Expert at 75+ and Master at 100+)

NPC Abilities are now here. All vanilla classes and some classes from Danae's Ahead of the Classes﻿ have abilities. Abilities are learned every 5 levels, and are based on the class your companion is training as at that 5th level. Each class only has one ability to learn, so don't be afraid to mix and match abilities! There are over 140 NPC Abilities.</details>



<details><summary>Creatures in Class Mode:</summary>

When leveling up, creatures train 3 attributes. The first two attributes are the favored attributes of the creature's chosen type. The 3rd attribute is an attribute chosen by random. Each attribute is raised 1-4 points on level up by default (configurable). Creatures may also gain a bonus in attributes based on their type (Normal creatures gain a guaranteed additional +1 Agility on level up).

Creatures do not train skills. Instead, creature types impart abilities as the creature levels up in that type. These abilities are passive effects that may increase your creature's stats or resistances. Typically, creature type abilities are learned at type levels 5, 10, 15, and 20. Once an ability is learned by a creature, they retain the ability even when leveling as a different type. The mod records the creature's level in each type.

Creature Spell Learning is also available. Whenever a creature levels up, the creature rolls to learn a spell from their current type's spell table (30% chance, configurable). Creatures have access to a basic spell table until level 10, where they will then have access to the full spell tables for each type.</details>



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## Build Mode:

In Build Mode, your companions level up Attributes and Skills based on parameters you set. Use the menu key (default: k) or ask an NPC to "check status" to access the Build Mode menu, which pulls up a list of attributes and skills as well as input boxes allowing you to set up how your companions level up (their build). By default, all boxes have a value of 0 in them (a roll of 0 to 0 per stat on level up).

Make sure to set your companions' builds before they begin leveling up or else they will gain 0s in all stats every level up until you set the values you want!

Creatures do not train skills. Instead, creature types impart abilities as the creature levels up in that type. These abilities are passive effects that may increase your creature's stats or resistances. Typically, creature type abilities are learned at type levels 5, 10, 15, and 20. Once an ability is learned by a creature, they retain the ability even when leveling as a different type. The mod records the creature's level in each type.

NPC companions also roll to learn spells when training a school of magic. If your minimum trained value is above 0 for a school of magic, that NPC will roll to learn a spell of that school within their abilities. (Apprentice spells at 25+, Journeyman at 50+, Expert at 75+ and Master at 100+)

Creature Spell Learning is also available. Whenever a creature levels up, the creature rolls to learn a spell from their current type's spell table (30% chance, configurable). Creatures have access to a basic spell table until level 10, where they will then have access to the full spell tables for each type.

NPC Abilities are now here. All vanilla classes and some classes from Danae's Ahead of the Classes﻿ have abilities. Abilities are learned every 5 levels, and are based on the class your NPC companion is training as at that 5th level. Each class only has one ability to learn, so don't be afraid to mix and match abilities! There are currently 110 abilities in total. 



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Character Sheet:

One big limitation in Morrowind you may be familiar with is commonly called the 3 day bug. This bug essentially resets actors' stats when the player is away from them for 72 in game hours. Some companion mods offer a telepathy ring of sorts that allow you to talk to companions from anywhere, and each time you talk to them it "resets" the 72 hour clock. There may be other ways/mods made to prevent this as well. With that said...

Companion Leveler now remembers each change the mod makes to your companions. So if your companions lose their stats or abilities, you can fix them back to what Companion Leveler thinks are their Ideal values! If Companion Leveler thinks your stats should be different than what they are now, but they are already correct, then you can tell Companion Leveler to remember current stats as the new Ideal.

You can also reset companions back to the way they were before any changes were made.

In addition, the Character Sheet provides a way to view or forget companions' spells and abilities as well as creature type levels; the "Special" list shows you current contracts (Assassin class) and bounties (Bounty Hunter class).

Through the character sheet, NPCs can be told to avoid training ONE of their skills when leveling up. So if you want to avoid leveling up Speechcraft when your NPC levels up, set Speechcraft as their "Ignored Skill" and they will instead roll a different skill to train.

NPCs and creatures can now be blacklisted as well. Blacklisted companions will not level up!


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Compatibility:

This mod should be compatible with any companion as long as they are following you, with some conditions:

Mods like Supreme Follower System work well with Companion Leveler with no additional considerations, because SFS does not have any additional scripts that mess with follower's stats.

Mods like ﻿The Strider's Nest have a system in place which innately allows their companions to level up their own way as you do the companion's quests or fulfil other conditions. When these mods alter their companions stats, they could erase or revert the stats gained through Companion Leveler. However, this example mod in particular allows you to turn off their companion leveling so you can modify stats yourself, like with Companion Leveler.

Other mods may or may not allow you to turn their leveling off, so if a companion mod levels up the companions they add you may wish to see if there is a way to disable that feature.

Mods like Live Free have scripts that constantly reset the values of their companions stats in an attempt to get around the "3 day bug". These scripts will revert any changes Companion Leveler makes because the companion's attributes are constantly being reset. In order to get around this, these scripts must be disabled. You can still use Live Free and Companion Leveler at the same time, but the slaves affected by Live Free will constantly have their stats reset.

Basically, if your companion is following you and no scripts are changing their stats, they should be compatible. Your companions retain their stats and abilities even when you leave them somewhere, but be aware of the "3 day bug" that can reset any actor's stats to default values when left alone for 72 hours in game.﻿ If your companion's stats are reset, use the Character Sheet to fix them!﻿


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Extra:

I want to thank everyone in the Morrowind Modding Discord that helped me answer any questions I had pertaining to MWSE and its functionality. Namely:

Archimag, Hrnchamd, and Merlord. If I forgot anyone, I'm sorry!

I also want to thank Danae123﻿ for ﻿ideas such as the blacklist, some class abilities, and compatibility with Ahead of the Classes!

This mod hasn't been tested with every companion mod out there. Be sure to let me know if your favorite companions are incompatible.
