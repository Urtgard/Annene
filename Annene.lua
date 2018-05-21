Annene = LibStub("AceAddon-3.0"):NewAddon("Annene", "AceEvent-3.0")
local A = Annene

function A:OnEnable()
	------------------
	--	Database
	------------------
	self.defaults = {
		global = {
			x = 0,
			y = -210,
			scale = 1.0,
			PetSelectionFrameOffset = 131,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("AnneneDB", self.defaults)

	------------------
	--	Events
	------------------
	self:RegisterEvent("PET_BATTLE_OPENING_START", "PetBattleFrameSetStyle")

	------------------
	-- 	Options
	------------------
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Annene", self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Annene", "Annene")	
end

------------------
-- 	Options Table
------------------
local newOrder
do
	local current = 0
	function newOrder()
		current = current + 1
		return current
	end
end
A.options = {
	type = "group",

	args = {
		x = {
			order = newOrder(),
		    name = "x-offset",
		    type = "range",
		    softMin = -500,
		    softMax = 500,
		    step = 1,
	   		set = function(info,val)
	   			A.db.global.x = val
	   			A:PetBattleFrameSetPosition(val, A.db.global.y)
	   		end,
	    	get = function() return A.db.global.x end
		},
		y = {
			order = newOrder(),
		    name = "y-offset",
		    type = "range",
		    softMin = -500,
		    softMax = 500,
		    step = 1,
	   		set = function(info,val)
	   			A.db.global.y = val
	   			A:PetBattleFrameSetPosition(A.db.global.x, val)
	   		end,
	    	get = function() return A.db.global.y end
		},
		blankLine1 = {
			type = "description",
			order = newOrder(),
			name = " ",
		},
		scale = {
			order = newOrder(),
		    name = "scale",
		    type = "range",
		    min = 0.1,
		    softMin = .5,
		    softMax = 2,
		    step = .01,
	   		set = function(info,val)
	   			A.db.global.scale = val
	   			PetBattleFrame:SetScale(val)
	   		end,
	    	get = function() return A.db.global.scale end
		},
		PetSelectionFrameOffset = {
			order = newOrder(),
			name = "PetSelectionFrame-offset",
		    type = "range",
		    softMin = -500,
		    softMax = 500,
		    step = 1,
	   		set = function(info,val)
	   			A.db.global.PetSelectionFrameOffset = val
	   			PetBattleFrame.BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", 0, val)
	   		end,
	    	get = function() return A.db.global.PetSelectionFrameOffset end
		},
		blankLine2 = {
			type = "description",
			order = newOrder(),
			name = " ",
		},
		defaults = {
			order = newOrder(),
			name = "Restore default settings",
			type = "execute",
			func = function()
				for k,v in pairs(A.defaults.global) do
					A.db.global[k] = v
				end
				A:PetBattleFrameSetStyle()
			end
		},
	}
}

function A:PetBattleFrameSetStyle()
	PetBattleFrame:SetScale(self.db.global.scale)

	--rearrange buttons
	PetBattleFrame.BottomFrame.abilityButtons[3]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[3]:SetPoint("TOPRIGHT", PetBattleFrame.BottomFrame, "TOP", -3, -30)
	PetBattleFrame.BottomFrame.abilityButtons[2]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[2]:SetPoint("TOPRIGHT", PetBattleFrame.BottomFrame.abilityButtons[3], "TOPLEFT", -8, 0)
	PetBattleFrame.BottomFrame.abilityButtons[1]:ClearAllPoints()
	PetBattleFrame.BottomFrame.abilityButtons[1]:SetPoint("TOPRIGHT", PetBattleFrame.BottomFrame.abilityButtons[2], "TOPLEFT", -8, 0)
	PetBattleFrame.BottomFrame.SwitchPetButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.SwitchPetButton:SetPoint("TOPLEFT", PetBattleFrame.BottomFrame.abilityButtons[3], "TOPRIGHT", 8, 0)
	PetBattleFrame.BottomFrame.CatchButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.CatchButton:SetPoint("TOPLEFT", PetBattleFrame.BottomFrame.SwitchPetButton, "TOPRIGHT", 8, 0)
	PetBattleFrame.BottomFrame.ForfeitButton:ClearAllPoints()
	PetBattleFrame.BottomFrame.ForfeitButton:SetPoint("TOPLEFT", PetBattleFrame.BottomFrame.CatchButton, "TOPRIGHT", 8, 0)

	local bSize = 46
	PetBattleFrame.BottomFrame.abilityButtons[1]:SetWidth(bSize)
	PetBattleFrame.BottomFrame.abilityButtons[2]:SetWidth(bSize)
	PetBattleFrame.BottomFrame.abilityButtons[3]:SetWidth(bSize)
	PetBattleFrame.BottomFrame.abilityButtons[1]:SetHeight(bSize)
	PetBattleFrame.BottomFrame.abilityButtons[2]:SetHeight(bSize)
	PetBattleFrame.BottomFrame.abilityButtons[3]:SetHeight(bSize)

	PetBattleFrame.BottomFrame.SwitchPetButton:SetWidth(bSize)
	PetBattleFrame.BottomFrame.SwitchPetButton:SetHeight(bSize)
	PetBattleFrame.BottomFrame.CatchButton:SetWidth(bSize)
	PetBattleFrame.BottomFrame.CatchButton:SetHeight(bSize)
	PetBattleFrame.BottomFrame.ForfeitButton:SetWidth(bSize)
	PetBattleFrame.BottomFrame.ForfeitButton:SetHeight(bSize)
	--hide unnecessary stuff
	PetBattleFrame.BottomFrame.MicroButtonFrame:Hide()
	PetBattleFrame.BottomFrame.FlowFrame:Hide()
	PetBattleFrame.BottomFrame.Delimiter:Hide()
	PetBattleFrame.TopVersusText:Hide()
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:Hide()
	PetBattleFrameXPBar:Hide()
	PetBattleFrameXPBar.Show = function() end
	PetBattleFrame.BottomFrame.abilityButtons[1].HotKey:Hide()
	PetBattleFrame.BottomFrame.abilityButtons[2].HotKey:Hide()
	PetBattleFrame.BottomFrame.abilityButtons[3].HotKey:Hide()
	PetBattleFrame.BottomFrame.SwitchPetButton.HotKey:Hide()
	PetBattleFrame.BottomFrame.CatchButton.HotKey:Hide()
	
	--move and resize
	PetBattleFrame.BottomFrame:ClearAllPoints()
	PetBattleFrame.BottomFrame:SetPoint("TOP", PetBattleFrame.TopVersus, "BOTTOM", 0, 35)
	
	PetBattleFrame.BottomFrame.LeftEndCap:ClearAllPoints()
	PetBattleFrame.BottomFrame.LeftEndCap:SetPoint("LEFT", 80, -10)
	
	PetBattleFrame.BottomFrame.RightEndCap:ClearAllPoints()
	PetBattleFrame.BottomFrame.RightEndCap:SetPoint("RIGHT", -80, -10)

	PetBattleFrame.BottomFrame.TurnTimer:SetPoint("TOP", 0, 24)
	
	PetBattleFrame.BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", 0, self.db.global.PetSelectionFrameOffset)

	self:PetBattleFrameSetPosition(self.db.global.x, self.db.global.y)
	PetBattleFrame.TopVersus:Hide()

	PetBattleFrame.TopArtLeft:ClearAllPoints()
	PetBattleFrame.TopArtLeft:SetPoint("TOPRIGHT", PetBattleFrame.TopVersus, "TOP", 0, 0)
	PetBattleFrame.TopArtRight:ClearAllPoints()
	PetBattleFrame.TopArtRight:SetPoint("TOPLEFT", PetBattleFrame.TopVersus, "TOP", 0, 0)

	PetBattleFrame.WeatherFrame:ClearAllPoints()
	PetBattleFrame.WeatherFrame:SetPoint("TOP", PetBattleFrame.BottomFrame, "BOTTOM", 0, -20)
	PetBattleFrame.WeatherFrame:SetFrameStrata("BACKGROUND")

	PetBattleFrame.EnemyPadBuffFrame:SetPoint("TOPLEFT", PetBattleFrame.TopArtRight, "BOTTOMRIGHT", -365, 20)
	PetBattleFrame.AllyPadBuffFrame:SetPoint("TOPRIGHT", PetBattleFrame.TopArtLeft, "BOTTOMLEFT", 365, 20)
	--SetTexCoord
	PetBattleFrame.BottomFrame.LeftEndCap:SetTexCoord(0.90136719, 0.77734375, 0.66992188, 0.42578125)
	PetBattleFrame.BottomFrame.RightEndCap:SetTexCoord(0.77734375, 0.90136719, 0.66992188, 0.42578125)
	PetBattleFrame.BottomFrame.Background:SetTexCoord(0, 0.48828125, 0, 0.00390625, 1.55078125, 0.48828125, 1.55078125, 0.00390625)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:SetTexCoord(0, 1, 1, 0)

	--incactive Pets
	PetBattleFrame.Ally2:SetPoint("TOPLEFT", PetBattleFrame.TopArtLeft, "TOPLEFT", 65, -4)	
	PetBattleFrame.Ally3:SetPoint("TOPLEFT", PetBattleFrame.Ally2, "BOTTOMLEFT", 0, -4)
	PetBattleFrame.Enemy2:SetPoint("TOPRIGHT", PetBattleFrame.TopArtRight, "TOPRIGHT", -65, -4)	
	PetBattleFrame.Enemy3:SetPoint("TOPRIGHT", PetBattleFrame.Enemy2, "BOTTOMRIGHT", 0, -4)
	
	--TurnTimer
	PetBattleFrame.BottomFrame.TurnTimer:SetWidth(370)
	PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetWidth(61)
	 PetBattleFrame.BottomFrame.TurnTimer.SkipButton:ClearAllPoints();
    if(C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)) then
        PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("CENTER", 0, 0);
    else
        PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("LEFT", 21, 0);
    end
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetWidth(265)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetPoint("CENTER", 31, 0)
	PetBattleFrame.BottomFrame.TurnTimer.Bar:SetPoint("LEFT", 83, 0)
	PetBattleFrame.BottomFrame.TurnTimer.TimerText:SetPoint("CENTER", 25, 0)
	local TIMER_BAR_TEXCOORD_LEFT = 0.56347656;
 	local TIMER_BAR_TEXCOORD_RIGHT = 0.89453125;
 	local TIMER_BAR_TEXCOORD_TOP = 0.00195313;
	local TIMER_BAR_TEXCOORD_BOTTOM = 0.03515625;
	PetBattleFrame.BottomFrame.TurnTimer:SetScript("OnUpdate", function(self, elapsed)
		if ( ( C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_WAITING_PRE_BATTLE ) and
 		 ( C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_ROUND_IN_PROGRESS ) and
 		 ( C_PetBattles.GetBattleState() ~= LE_PET_BATTLE_STATE_WAITING_FOR_FRONT_PETS ) ) then
 		self.Bar:SetAlpha(0);
 		self.TimerText:SetText("");
	 	elseif ( self.turnExpires ) then
	 		local timeRemaining = self.turnExpires - GetTime();
	 
	 		--Deal with variable lag from the server without looking weird
	 		if ( timeRemaining <= 0.01 ) then
	 			timeRemaining = 0.01;
	 		end
	 
	 		local timeRatio = 1.0;
	 		if ( self.turnTime > 0.0 ) then
	 			timeRatio = timeRemaining / self.turnTime;
	 		end
	 		local usableSpace = 264;
	 
	 		self.Bar:SetWidth(usableSpace * timeRatio);
	 		self.Bar:SetTexCoord(TIMER_BAR_TEXCOORD_LEFT, TIMER_BAR_TEXCOORD_LEFT + (TIMER_BAR_TEXCOORD_RIGHT - TIMER_BAR_TEXCOORD_LEFT) * timeRatio, TIMER_BAR_TEXCOORD_TOP, TIMER_BAR_TEXCOORD_BOTTOM);
	 
	 		if ( C_PetBattles.IsWaitingOnOpponent() ) then
	 			self.Bar:SetAlpha(0.5);
	 			self.TimerText:SetText(PET_BATTLE_WAITING_FOR_OPPONENT);
	 		else
	 			self.Bar:SetAlpha(1);
	 			if ( self.turnTime > 0.0 ) then
	 				self.TimerText:SetText(ceil(timeRemaining));
	 			else
	 				self.TimerText:SetText("")
	 			end
	 		end
	 	else
	 		self.Bar:SetAlpha(0);
	 		if ( C_PetBattles.IsWaitingOnOpponent() ) then
	 			self.TimerText:SetText(PET_BATTLE_WAITING_FOR_OPPONENT);
	 		else
	 			self.TimerText:SetText(PET_BATTLE_SELECT_AN_ACTION);
	 		end
	 	end
	end)

	--PetTracker
	if PetTrackerEnemyActions then
		PetTrackerEnemyActions:SetPoint("BOTTOM", PetBattleFrame.TopVersus, "TOP", 0, 9)
		PetTrackerEnemyActions:SetScale(0.7)
	end

	if tdBattlePetScriptAutoButton then
		tdBattlePetScriptAutoButton:SetWidth(60)
		if(C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)) then
        	PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetPoint("CENTER", -30, 0);
    	end
    	local _,_,ArtFrame2 = PetBattleFrame.BottomFrame.TurnTimer:GetChildren()
    	ArtFrame2:Hide()
	end

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
end

A.anchor = CreateFrame("Frame", "AnnAnchor", UIParent)
local anchor = A.anchor
anchor:SetWidth(2)
anchor:SetHeight(2)
anchor:SetPoint("CENTER", "UIParent", "CENTER")
PetBattleFrame.TopVersus:SetPoint("TOP", anchor, "CENTER")

function A:PetBattleFrameSetPosition(x, y)
	self.anchor:SetPoint("CENTER", "UIParent", "CENTER", x, y)
end
