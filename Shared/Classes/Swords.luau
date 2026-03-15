-->> Swords.luau
-- Swords information for Sword Masters
--> Scripted by Marcos


local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local _


local Swords = {



    ["Great Sword"] = {
        Type = "Sword";
        Name = "Great Sword";
        Description = "Great sword owned by advanced sword masters!";
        Image = 126165401292845;
        Rarity = "Rare";
        Delay = 0.35;
        Damage = 18;
    };

    ["Molten Sword"] = {
        Type = "Sword";
        Name = "Molten Sword";
        Description = "Molten hot sword made out of lava rocks and steel";
        Image = 95641756499877;
        Rarity = "Exclusive";
        Delay = 0.35;
        Damage = 22;
    };

    ["Gladiator's Sword"] = {
        Type = "Sword";
        Name = "Gladiator's Sword";
        Description = "The great spartan sword";
        Image = 18148861656;
        Rarity = "Uncommon";
        Delay = 0.35;
        Damage = 16;
    };

    ["Default Sword"] = {
        Type = "Sword";
        Name = "Default Sword";
        Description = "Default Sword of the game";
        Image = 18148544101;
        Rarity = "Starter";
        Delay = 0.35;
        Damage = 15;
    };

    ["Red Sword"] = {
        Type = "Sword";
        Name = "Red Sword";
        Description = "Red version of the default sword";
        Image = 18148840345;
        Rarity = "Common";
        Delay = 0.35;
        Damage = 15;
    };

    ["Admin pan"] = {
        Type = "Sword";
        Name = "Admin pan";
        Description = "Pan of gods";
        Image = 18148544101;
        Rarity = "Admin";
        Delay = 0.15;
        Damage = 1000;
    };

    ["Blue Sword"] = {
        Type = "Sword";
        Name = "Blue Sword";
        Description = "Blue version of the default sword";
        Image = 18148825328;
        Rarity = "Common";
        Delay = 0.35;
        Damage = 15;
    };

    ["Mountain Sword"] = {
        Type = "Sword";
        Name = "Mountain Sword";
        Description = "The great mountain sword staight from the top";
        Image = 14133395468;
        Rarity = "Special";
        Delay = 0.35;
        Damage = 22;
    };

    ["Bob's Knife"] = {
        Type = "Sword";
        Name = "Bob's Knife";
        Description = "Perfect for cooking!";
        Image = 18148884388;
        Rarity = "Rare";
        Delay = 0.35;
        Damage = 18;
    };

    ["Crystal Sword"] = {
        Type = "Sword";
        Name = "Crystal Sword";
        Description = "Shiny sword made out of rare crystals!";
        Image = 126446528852253;
        Rarity = "Legendary";
        Delay = 0.35;
        Damage = 22;
    };

    ["Shadow Sword"] = {
        Type = "Sword";
        Name = "Shadow Sword";
        Description = "Mysterious sword created by the unknown";
        Image = 18131378192;
        Rarity = "Epic";
        Delay = 0.35;
        Damage = 20;
    };

    ["Void Crystal Sword"] = {
        Type = "Sword";
        Name = "Void Crystal Sword";
        Description = "Void version of Crystal Sword which is exclusive to players who complete special challenges";
        Image = 131121800170987;
        Rarity = "Exclusive";
        Delay = 0.35;
        Damage = 22;
    };

    ["Green Sword"] = {
        Type = "Sword";
        Name = "Green Sword";
        Description = "Green version of the default sword";
        Image = 18148691575;
        Rarity = "Common";
        Delay = 0.35;
        Damage = 15;
    };

};



Swords.PricesByRarity = {
	["Common"] = 1500,
	["Uncommon"] = 5000,
	["Rare"] = 10000,
	["Epic"] = 22000,
	["Legendary"] = 50000,

}



return Swords;