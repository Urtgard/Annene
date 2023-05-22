-----------------
--	Other Addons
-----------------
-- ElvUI
-- PetTracker
-- tdBattlePetScript
-- Derangement's Pet Battle Cooldowns
-- Battle Pet Battle UI Tweaks

local A = Annene

A.otherAddons = {}

function A.otherAddons:Setup()
    for _, addon in pairs(self) do
        if type(addon) == "table" and addon.Setup then
            addon:Setup()
        end
    end
end

A.otherAddons.ElvUI = {}
function A.otherAddons.ElvUI:Setup()
    if ElvUI then
        local E = unpack(ElvUI)
        if E.private.skins.blizzard.petbattleui then
            E.PopupDialogs["Annene"] = {
                text = "You have got ElvUI's pet battle skin and Annene both enabled at the same time.\n\nSelect which skin you want to use.\n",
                OnAccept = function()
                    DisableAddOn("Annene")
                    ReloadUI()
                end,
                OnCancel = function()
                    E.private.skins.blizzard.petbattleui = false
                    ReloadUI()
                end,
                button1 = "ElvUI's skin",
                button2 = "Annene",
                timeout = 0,
                whileDead = 1,
                hideOnEscape = false
            }
            E:StaticPopup_Show("Annene")
        end
    end
end

A.otherAddons.PetTracker = {}
function A.otherAddons.PetTracker:Setup()
    if PetTracker and PetTracker.EnemyBar then
        PetTracker.EnemyBar:ClearAllPoints()
        if A.db.global.PetTracker then
            PetTracker.EnemyBar:Show()
            PetTracker.EnemyBar:SetPoint("BOTTOM", A.anchor, "TOP", 0, 6)
            PetTracker.EnemyBar:SetScale(0.67)
        else
            PetTracker.EnemyBar:Hide()
        end
    end
end

A.otherAddons.tdBattlePetScript = {}
function A.otherAddons.tdBattlePetScript:Setup()
    if tdBattlePetScriptAutoButton then
        if (C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)) then
            PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("CENTER", -30, 0)
        end
        local _, _, ArtFrame2 = PetBattleFrame.BottomFrame.TurnTimer:GetChildren()
        if ArtFrame2 then
            ArtFrame2:Hide()
        end
    end
end

A.otherAddons.DerangementPetBattleCooldowns = {}
function A.otherAddons.DerangementPetBattleCooldowns:Setup()
    if DeePetBattleFrame then
        -- Ally1
        if A.db.global.DerangementPetBattleCooldowns.Ally1.show == true then
            DeePetBattleFrame.Ally1:Show()
            DeePetBattleFrame.Ally1:SetPoint(
                "TOPLEFT",
                PetBattleFrame.ActiveAlly,
                "TOPRIGHT",
                A.db.global.DerangementPetBattleCooldowns.Ally1.x,
                A.db.global.DerangementPetBattleCooldowns.Ally1.y
            )
        else
            DeePetBattleFrame.Ally1:Hide()
        end
        -- Ally2 & Ally3
        for i = 2, C_PetBattles.GetNumPets(1) do
            if A.db.global.DerangementPetBattleCooldowns["Ally" .. i].show == true then
                DeePetBattleFrame["Ally" .. i]:Show()
                DeePetBattleFrame["Ally" .. i]:SetPoint(
                    "RIGHT",
                    PetBattleFrame["Ally" .. i],
                    "LEFT",
                    -12 + A.db.global.DerangementPetBattleCooldowns["Ally" .. i].x,
                    A.db.global.DerangementPetBattleCooldowns["Ally" .. i].y
                )
            else
                DeePetBattleFrame["Ally" .. i]:Hide()
            end
        end
        -- Enemy1
        if A.db.global.DerangementPetBattleCooldowns.Enemy1.show == true then
            DeePetBattleFrame.Enemy1:SetFrameStrata("BACKGROUND")
            DeePetBattleFrame.Enemy1:Show()
            DeePetBattleFrame.Enemy1:ClearAllPoints()
            DeePetBattleFrame.Enemy1:SetPoint(
                "BOTTOM",
                A.anchor,
                "TOP",
                A.db.global.DerangementPetBattleCooldowns.Enemy1.x,
                4 + A.db.global.DerangementPetBattleCooldowns.Enemy1.y
            )
        else
            DeePetBattleFrame.Enemy1:Hide()
        end
        -- Enemy2 & Enemy3
        for i = 2, C_PetBattles.GetNumPets(2) do
            if A.db.global.DerangementPetBattleCooldowns["Enemy" .. i].show == true then
                DeePetBattleFrame["Enemy" .. i]:Show()
                DeePetBattleFrame["Enemy" .. i]:SetPoint(
                    "LEFT",
                    PetBattleFrame["Enemy" .. i],
                    "RIGHT",
                    12 + A.db.global.DerangementPetBattleCooldowns["Enemy" .. i].x,
                    A.db.global.DerangementPetBattleCooldowns["Enemy" .. i].y
                )
            else
                DeePetBattleFrame["Enemy" .. i]:Hide()
            end
        end
    end
end

A.otherAddons.BattlePetBattleUITweaks = {}
function A.otherAddons.BattlePetBattleUITweaks:Setup()
    if IsAddOnLoaded("BattlePetBattleUITweaks") then
        -- Round Counter
        if BattlePetBattleUITweaksSettings.RoundCounter then
            PetBattleFrame.TopVersus:Show()
            PetBattleFrame.TopVersusText:Show()
        end

        -- Enemy Abilities
        _BattlePetBattleUITweaks.abilities:SetPoint(
            "BOTTOM",
            A.anchor,
            "TOP",
            A.db.global.BattlePetBattleUITweaks.EnemyAbilities.x,
            A.db.global.BattlePetBattleUITweaks.EnemyAbilities.y - 4
        )
        _BattlePetBattleUITweaks.abilities:SetScale(A.db.global.BattlePetBattleUITweaks.EnemyAbilities.scale)

        hooksecurefunc(
            "PetBattlePetSelectionFrame_Hide",
            function()
                _BattlePetBattleUITweaks.abilities:ClearAllPoints()
                _BattlePetBattleUITweaks.abilities:SetPoint(
                    "BOTTOM",
                    A.anchor,
                    "TOP",
                    A.db.global.BattlePetBattleUITweaks.EnemyAbilities.x,
                    A.db.global.BattlePetBattleUITweaks.EnemyAbilities.y - 4
                )
            end
        )
    end
end
