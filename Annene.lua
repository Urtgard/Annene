Annene = LibStub("AceAddon-3.0"):NewAddon("Annene", "AceEvent-3.0")
local A = Annene

function A:OnInitialize()
	------------------
	--	Database
	------------------
	self.defaults = {
		global = {
			x = 0,
			y = -210,
			scale = 1.0,
			anchor = false,
			PetSelectionFrameOffset = 131,
			weatherFrameAtTop = false,
			PetTracker = true,
			DerangementPetBattleCooldowns = {
				Ally1 = { show = false, x = 0, y = 0 },
				Ally2 = { show = true, x = 0, y = 0 },
				Ally3 = { show = true, x = 0, y = 0 },
				Enemy1 = { show = true, x = 0, y = 0 },
				Enemy2 = { show = true, x = 0, y = 0 },
				Enemy3 = { show = true, x = 0, y = 0 }
			},
			BattlePetBattleUITweaks = {
				EnemyAbilities = { x = 0, y = 0, scale = 0.8 }
			}
		}
	}
	self.db = LibStub("AceDB-3.0"):New("AnneneDB", self.defaults)
end

function A:OnEnable()
	------------------
	--	Events
	------------------
	self:RegisterEvent("PET_BATTLE_OPENING_START", "PetBattleFrameSetStyle")
	self:RegisterEvent("ADDON_LOADED", "AddonLoaded")

	--[[
		The order of event handlers is not guaranteed.
		PetBattleFrameSetStyle may be executed before BlizzardPetBattleFrame_Display has been called.
		In this case, not all elements that need to be adjusted exist yet,
		and it may overwrite changes that have already been made.
	]]
	hooksecurefunc("PetBattleFrame_Display", function(petBattleFrame)
		A:PetBattleFrameSetStyle()
	end)

	------------------
	-- 	Options
	------------------
	self:BuildOptionsTable()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Annene", self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Annene", "Annene")

	-----------------
	--	Frames
	-----------------
	A.anchor = CreateFrame("Frame", "AnneneAnchor", UIParent)
	local anchor = A.anchor
	anchor:SetWidth(156)
	anchor:SetHeight(2)
	anchor:SetPoint("CENTER", "UIParent", "CENTER")

	A.tooltipAnchor = CreateFrame("Frame", "AnneneTooltipAnchor", UIParent)
	A.tooltipAnchor:SetWidth(1)
	A.tooltipAnchor:SetHeight(1)
	A.tooltipAnchor:SetPoint("CENTER", "UIParent", "BOTTOMRIGHT", -6, 6)

	hooksecurefunc(
		"PetBattleAbilityTooltip_Show",
		function()
			if A.db.global.anchor then
				GameTooltip:Hide()
				PetBattlePrimaryAbilityTooltip:ClearAllPoints()
				PetBattlePrimaryAbilityTooltip:SetPoint("BOTTOMRIGHT", A.tooltipAnchor, "CENTER", 0, 0)
			end
		end
	)

	hooksecurefunc(
		"PetBattleUnitTooltip_Attach",
		function(self)
			if A.db.global.anchor then
				GameTooltip:Hide()
				self:ClearAllPoints()
				self:SetPoint("BOTTOMRIGHT", A.tooltipAnchor, "CENTER", 0, 0)
			end
		end
	)

	PetBattleFrame.BottomFrame.SwitchPetButton:SetScript(
		"OnEnter",
		function(self)
			if A.db.global.anchor then
				GameTooltip:Hide()
				GameTooltip:SetOwner(A.tooltipAnchor, "ANCHOR_LEFT")
			else
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			end
			GameTooltip:SetText(SWITCH_PET, 1, 1, 1, true)
			GameTooltip:AddLine(SWITCH_PET_DESCRIPTION, nil, nil, nil, true)
			GameTooltip:Show()
		end
	)

	PetBattleFrame.BottomFrame.CatchButton:SetScript(
		"OnEnter",
		function(self)
			if A.db.global.anchor then
				GameTooltip:Hide()
				GameTooltip:SetOwner(A.tooltipAnchor, "ANCHOR_LEFT")
			else
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			end
			GameTooltip:SetText(self.name, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
			GameTooltip:AddLine(self.description, nil, nil, nil, true)
			if self.additionalText then
				GameTooltip:AddLine(self.additionalText, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
			end
			GameTooltip:Show()
		end
	)

	PetBattleFrame.BottomFrame.ForfeitButton:SetScript(
		"OnEnter",
		function(self)
			if A.db.global.anchor then
				GameTooltip:Hide()
				GameTooltip:SetOwner(A.tooltipAnchor, "ANCHOR_LEFT")
			else
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			end
			GameTooltip:SetText(PET_BATTLE_FORFEIT, 1, 1, 1, true)
			GameTooltip:AddLine(PET_BATTLE_FORFEIT_DESCRIPTION, nil, nil, nil, true)
			GameTooltip:Show()
		end
	)
end

------------------
-- 	Options Table
------------------
function A:BuildOptionsTable()
	local newOrder
	do
		local current = 0
		function newOrder()
			current = current + 1
			return current
		end
	end
	self.options = {
		type = "group",
		args = {
			x = {
				order = newOrder(),
				name = "x-offset",
				type = "range",
				softMin = -500,
				softMax = 500,
				step = 1,
				set = function(info, val)
					A.db.global.x = val
					A:PetBattleFrameSetPosition(val, A.db.global.y)
				end,
				get = function()
					return A.db.global.x
				end
			},
			y = {
				order = newOrder(),
				name = "y-offset",
				type = "range",
				softMin = -500,
				softMax = 500,
				step = 1,
				set = function(info, val)
					A.db.global.y = val
					A:PetBattleFrameSetPosition(A.db.global.x, val)
				end,
				get = function()
					return A.db.global.y
				end
			},
			blankLine1 = {
				type = "description",
				order = newOrder(),
				name = " "
			},
			scale = {
				order = newOrder(),
				name = "scale",
				type = "range",
				min = 0.1,
				softMin = .5,
				softMax = 2,
				step = .01,
				set = function(info, val)
					A.db.global.scale = val
					PetBattleFrame:SetScale(val)
				end,
				get = function()
					return A.db.global.scale
				end
			},
			PetSelectionFrameOffset = {
				order = newOrder(),
				name = "PetSelectionFrame-offset",
				type = "range",
				softMin = -500,
				softMax = 500,
				step = 1,
				set = function(info, val)
					A.db.global.PetSelectionFrameOffset = val
					PetBattleFrame.BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", 0, val)
				end,
				get = function()
					return A.db.global.PetSelectionFrameOffset
				end
			},
			blankLine2 = {
				type = "description",
				order = newOrder(),
				name = " "
			},
			anchor = {
				type = "toggle",
				name = "Anchor tooltips to bottom right",
				set = function(info, val)
					A.db.global.anchor = val
					A:PetBattleFrameSetStyle()
				end,
				get = function()
					return A.db.global.anchor
				end,
				order = newOrder()
			},
			weatherFrameAtTop = {
				type = "toggle",
				name = "Show weather frame at top",
				set = function(info, val)
					A.db.global.weatherFrameAtTop = val
					A:PetBattleFrameSetStyle()
				end,
				get = function()
					return A.db.global.weatherFrameAtTop
				end,
				order = newOrder()
			},
			blankLine3 = {
				type = "description",
				order = -2,
				name = " "
			},
			defaults = {
				order = -1,
				name = "Restore default settings",
				type = "execute",
				func = function()
					Annene.db:ResetDB()
					A:PetBattleFrameSetStyle()
				end,
				width = 1.2
			}
		}
	}

	-- Battle Pet Battle UI Tweaks
	if C_AddOns.IsAddOnLoaded("BattlePetBattleUITweaks") then
		self.options.args["headerBattlePetBattleUITweaks"] = {
			type = "header",
			name = "Battle Pet Battle UI Tweaks",
			order = newOrder()
		}

		self.options.args["BattlePetBattleUITweaksEnemyAbilities"] = {
			type = "description",
			name = "Enemy Abilities:",
			fontSize = "medium",
			-- width = .8,
			order = newOrder()
		}
		self.options.args["BattlePetBattleUITweaksEnemyAbilitiesX"] = {
			order = newOrder(),
			name = "x-offset",
			type = "range",
			softMin = -400,
			softMax = 400,
			step = 1,
			set = function(info, val)
				A.db.global.BattlePetBattleUITweaks.EnemyAbilities.x = val
				A:PetBattleFrameSetStyle()
			end,
			get = function()
				return A.db.global.BattlePetBattleUITweaks.EnemyAbilities.x
			end
		}
		self.options.args["BattlePetBattleUITweaksEnemyAbilitiesY"] = {
			order = newOrder(),
			name = "y-offset",
			type = "range",
			softMin = -400,
			softMax = 400,
			step = 1,
			set = function(info, val)
				A.db.global.BattlePetBattleUITweaks.EnemyAbilities.y = val
				A:PetBattleFrameSetStyle()
			end,
			get = function()
				return A.db.global.BattlePetBattleUITweaks.EnemyAbilities.y
			end
		}
		self.options.args["BattlePetBattleUITweaksEnemyAbilitiesScale"] = {
			order = newOrder(),
			name = "scale",
			type = "range",
			min = 0.01,
			softMin = 0,
			softMax = 2,
			step = .05,
			set = function(info, val)
				A.db.global.BattlePetBattleUITweaks.EnemyAbilities.scale = val
				A:PetBattleFrameSetStyle()
			end,
			get = function()
				return A.db.global.BattlePetBattleUITweaks.EnemyAbilities.scale
			end
		}
	end

	-- PetTracker
	if C_AddOns.IsAddOnLoaded("PetTracker") then
		self.options.args["headerPetTracker"] = { type = "header", name = "PetTracker", order = newOrder() }
		self.options.args["PetTracker"] = {
			type = "toggle",
			name = "PetTracker Enemybar",
			set = function(info, val)
				A.db.global.PetTracker = val
				A:PetBattleFrameSetStyle()
			end,
			get = function()
				return A.db.global.PetTracker
			end,
			order = newOrder()
		}
	end

	-- Derangement's Pet Battle Cooldowns
	if C_AddOns.IsAddOnLoaded("DerangementPetBattleCooldowns") then
		self.options.args["headerDerangementPetBattleCooldowns"] = {
			type = "header",
			name = "Derangement's Pet Battle Cooldowns",
			order = newOrder()
		}
		for _, v in pairs({ "Ally", "Enemy" }) do
			for i = 1, 3 do
				self.options.args[v .. i .. "desc"] = {
					type = "description",
					name = v .. i .. ":",
					fontSize = "medium",
					width = .4,
					order = newOrder()
				}
				self.options.args[v .. i .. "show"] = {
					type = "toggle",
					name = "Show",
					width = .4,
					set = function(info, val)
						A.db.global.DerangementPetBattleCooldowns[v .. i].show = val
						A:PetBattleFrameSetStyle()
					end,
					get = function()
						return A.db.global.DerangementPetBattleCooldowns[v .. i].show
					end,
					order = newOrder()
				}
				self.options.args[v .. i .. "x"] = {
					order = newOrder(),
					name = "x-offset",
					type = "range",
					softMin = -400,
					softMax = 400,
					step = 1,
					set = function(info, val)
						A.db.global.DerangementPetBattleCooldowns[v .. i].x = val
						A:PetBattleFrameSetStyle()
					end,
					get = function()
						return A.db.global.DerangementPetBattleCooldowns[v .. i].x
					end
				}
				self.options.args[v .. i .. "y"] = {
					order = newOrder(),
					name = "y-offset",
					type = "range",
					softMin = -400,
					softMax = 400,
					step = 1,
					set = function(info, val)
						A.db.global.DerangementPetBattleCooldowns[v .. i].y = val
						A:PetBattleFrameSetStyle()
					end,
					get = function()
						return A.db.global.DerangementPetBattleCooldowns[v .. i].y
					end
				}
				self.options.args[v .. i .. "space"] = {
					type = "description",
					name = " ",
					width = .6,
					order = newOrder()
				}
			end
		end
	end
end

function A:PetBattleFrameSetStyle()
	if (C_PetBattles.IsInBattle() == false
			or #PetBattleFrame.BottomFrame.abilityButtons == 0) then
		return
	end

	PetBattleFrame:SetScale(self.db.global.scale)

	--rearrange buttons
	PetBattleFrame.BottomFrame.abilityButtons[3]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[3]:SetPoint("TOPRIGHT", PetBattleFrame.BottomFrame, "TOP", -3, -30)
	PetBattleFrame.BottomFrame.abilityButtons[2]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[2]:SetPoint(
		"TOPRIGHT",
		PetBattleFrame.BottomFrame.abilityButtons[3],
		"TOPLEFT",
		-8,
		0
	)
	PetBattleFrame.BottomFrame.abilityButtons[1]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[1]:SetPoint(
		"TOPRIGHT",
		PetBattleFrame.BottomFrame.abilityButtons[2],
		"TOPLEFT",
		-8,
		0
	)
	PetBattleFrame.BottomFrame.SwitchPetButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.SwitchPetButton:SetPoint(
		"TOPLEFT",
		PetBattleFrame.BottomFrame.abilityButtons[3],
		"TOPRIGHT",
		8,
		0
	)
	PetBattleFrame.BottomFrame.CatchButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.CatchButton:SetPoint(
		"TOPLEFT",
		PetBattleFrame.BottomFrame.SwitchPetButton,
		"TOPRIGHT",
		8,
		0
	)
	PetBattleFrame.BottomFrame.ForfeitButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.ForfeitButton:SetPoint("TOPLEFT", PetBattleFrame.BottomFrame.CatchButton, "TOPRIGHT", 8, 0)

	local buttonSize = 46
	for _, button in pairs(PetBattleFrame.BottomFrame.abilityButtons) do
		button:SetSize(buttonSize, buttonSize)

		button.HotKey:Hide()
	end

	PetBattleFrame.BottomFrame.SwitchPetButton:SetSize(buttonSize, buttonSize)
	PetBattleFrame.BottomFrame.CatchButton:SetSize(buttonSize, buttonSize)
	PetBattleFrame.BottomFrame.ForfeitButton:SetSize(buttonSize, buttonSize)

	--hide unnecessary stuff
	PetBattleFrame.BottomFrame.MicroButtonFrame:Hide()
	PetBattleFrame.BottomFrame.FlowFrame:Hide()
	PetBattleFrame.BottomFrame.Delimiter:Hide()
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:Hide()
	PetBattleFrameXPBar:Hide()
	PetBattleFrameXPBar.Show = function() end
	PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide()
	PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide()

	--move and resize
	PetBattleFrame.BottomFrame:ClearAllPoints()
	PetBattleFrame.BottomFrame:SetPoint("TOP", self.anchor, "BOTTOM", 0, -29)

	PetBattleFrame.BottomFrame.LeftEndCap:ClearAllPoints()
	PetBattleFrame.BottomFrame.LeftEndCap:SetPoint("LEFT", 80, -10)

	PetBattleFrame.BottomFrame.RightEndCap:ClearAllPoints()
	PetBattleFrame.BottomFrame.RightEndCap:SetPoint("RIGHT", -80, -10)

	PetBattleFrame.BottomFrame.TurnTimer:SetPoint("TOP", 0, 24)

	PetBattleFrame.BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", 0, self.db.global.PetSelectionFrameOffset)

	self:PetBattleFrameSetPosition(self.db.global.x, self.db.global.y)

	PetBattleFrame.TopArtLeft:ClearAllPoints()
	PetBattleFrame.TopArtLeft:SetPoint("TOPRIGHT", self.anchor, "TOP", 0, -1)
	PetBattleFrame.TopArtRight:ClearAllPoints()
	PetBattleFrame.TopArtRight:SetPoint("TOPLEFT", self.anchor, "TOP", 0, -1)

	PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -365, 20)
	PetBattleFrame.AllyPadBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 365, 20)
	--SetTexCoord
	PetBattleFrame.BottomFrame.LeftEndCap:SetTexCoord(0.90136719, 0.77734375, 0.66992188, 0.42578125)
	PetBattleFrame.BottomFrame.RightEndCap:SetTexCoord(0.77734375, 0.90136719, 0.66992188, 0.42578125)
	PetBattleFrame.BottomFrame.Background:SetTexCoord(
		0,
		0.48828125,
		0,
		0.00390625,
		1.55078125,
		0.48828125,
		1.55078125,
		0.00390625
	)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:SetTexCoord(0, 1, 1, 0)

	--incactive Pets
	PetBattleFrame.Ally2:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, "TOPLEFT", 65, -4)
	PetBattleFrame.Ally3:SetPoint("TOPLEFT", PetBattleFrame.Ally2, "BOTTOMLEFT", 0, -4)
	PetBattleFrame.Enemy2:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, "TOPRIGHT", -65, -4)
	PetBattleFrame.Enemy3:SetPoint("TOPRIGHT", PetBattleFrame.Enemy2, "BOTTOMRIGHT", 0, -4)

	--TurnTimer
	PetBattleFrame.BottomFrame.TurnTimer:SetWidth(370)
	PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetWidth(61)
	PetBattleFrame.BottomFrame.TurnTimer.SkipButton:ClearAllPoints()
	if (C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)) then
		PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("CENTER", 0, 0)
	else
		PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("LEFT", 21, 0)
	end
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetWidth(265)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetPoint("CENTER", 31, 0)
	PetBattleFrame.BottomFrame.TurnTimer.Bar:SetPoint("LEFT", 83, 0)
	PetBattleFrame.BottomFrame.TurnTimer.TimerText:SetPoint("CENTER", 25, 0)
	local TIMER_BAR_TEXCOORD_LEFT = 0.56347656
	local TIMER_BAR_TEXCOORD_RIGHT = 0.89453125
	local TIMER_BAR_TEXCOORD_TOP = 0.00195313
	local TIMER_BAR_TEXCOORD_BOTTOM = 0.03515625
	PetBattleFrame.BottomFrame.TurnTimer:SetScript(
		"OnUpdate",
		function(self, elapsed)
			if
				((C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_WAITING_PRE_BATTLE) and
					(C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_ROUND_IN_PROGRESS) and
					(C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_WAITING_FOR_FRONT_PETS))
			then
				self.Bar:SetAlpha(0)
				self.TimerText:SetText("")
			elseif (self.turnExpires) then
				local timeRemaining = self.turnExpires - GetTime()

				--Deal with variable lag from the server without looking weird
				if (timeRemaining <= 0.01) then
					timeRemaining = 0.01
				end

				local timeRatio = 1.0
				if (self.turnTime > 0.0) then
					timeRatio = timeRemaining / self.turnTime
				end
				local usableSpace = 264

				self.Bar:SetWidth(usableSpace * timeRatio)
				self.Bar:SetTexCoord(
					TIMER_BAR_TEXCOORD_LEFT,
					TIMER_BAR_TEXCOORD_LEFT + (TIMER_BAR_TEXCOORD_RIGHT - TIMER_BAR_TEXCOORD_LEFT) * timeRatio,
					TIMER_BAR_TEXCOORD_TOP,
					TIMER_BAR_TEXCOORD_BOTTOM
				)

				if (C_PetBattles.IsWaitingOnOpponent()) then
					self.Bar:SetAlpha(0.5)
					self.TimerText:SetText(PET_BATTLE_WAITING_FOR_OPPONENT)
				else
					self.Bar:SetAlpha(1)
					if (self.turnTime > 0.0) then
						self.TimerText:SetText(ceil(timeRemaining))
					else
						self.TimerText:SetText("")
					end
				end
			else
				self.Bar:SetAlpha(0)
				if (C_PetBattles.IsWaitingOnOpponent()) then
					self.TimerText:SetText(PET_BATTLE_WAITING_FOR_OPPONENT)
				else
					self.TimerText:SetText(PET_BATTLE_SELECT_AN_ACTION)
				end
			end
		end
	)

	local texture = "Interface\\Addons\\Annene\\texture.BLP"
	PetBattleFrame.TopArtLeft:SetTexture(texture)
	PetBattleFrame.TopArtRight:SetTexture(texture)
	PetBattleFrame.BottomFrame.LeftEndCap:SetTexture(texture)
	PetBattleFrame.BottomFrame.RightEndCap:SetTexture(texture)
	PetBattleFrame.BottomFrame.abilityButtons[1].SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.abilityButtons[2].SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.abilityButtons[3].SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.SwitchPetButton.SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.CatchButton.SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.ForfeitButton.SelectedHighlight:SetTexture(texture)
	PetBattleFrame.BottomFrame.TurnTimer.TimerBG:SetTexture(texture)
	PetBattleFrame.TopVersus:Hide()
	PetBattleFrame.TopVersusText:Hide()

	self.otherAddons:Setup()

	-- WeatherFrame
	PetBattleFrame.WeatherFrame:ClearAllPoints()
	if self.db.global.weatherFrameAtTop then
		PetBattleFrame.WeatherFrame.BackgroundArt:SetPoint("TOP", UIParent, 0, 0)
		if PetBattleFrame.TopVersus:IsVisible() then
			PetBattleFrame.WeatherFrame:SetPoint("TOP", 0, -60)
		else
			PetBattleFrame.WeatherFrame:SetPoint("TOP", 0, -24)
		end
	else
		PetBattleFrame.WeatherFrame:SetPoint("TOP", PetBattleFrame.BottomFrame, "BOTTOM", 0, -20)
		PetBattleFrame.WeatherFrame.BackgroundArt:SetPoint("TOP", PetBattleFrame.WeatherFrame, 0, 24)
		PetBattleFrame.WeatherFrame:SetFrameStrata("BACKGROUND")
	end
end

function A:PetBattleFrameSetPosition(x, y)
	self.anchor:SetPoint("CENTER", "UIParent", "CENTER", x, y)
end

function A:AddonLoaded(_, addonName)
	if addonName == "PetTracker_Battle" then
		self:PetBattleFrameSetStyle()
		self:UnregisterEvent("ADDON_LOADED")
	end
end
