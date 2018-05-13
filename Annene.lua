------------------
--Variables
local x, xOld, y, yOld = 0, 0, 0, 0
------------------

local Annene = CreateFrame("Frame")
Annene:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
Annene:RegisterEvent("PET_BATTLE_OPENING_START")
Annene:RegisterEvent("ADDON_LOADED")
Annene:RegisterEvent("PLAYER_LOGOUT")

function Annene:PET_BATTLE_OPENING_START()
	self:PetBattleFrameSetStyle()
end

function Annene:ADDON_LOADED(name)
	if name == "Annene" then
		if AnneneDB == nil then
			AnneneDB = {}
		end

		if AnneneDB.x then
			x = AnneneDB.x
			xOld = x
		else
			AnneneDB.x = 0
		end

		if AnneneDB.y then
			y = AnneneDB.y
			yOld = y
		else
			AnneneDB.y = 0
		end

		self.OptionsPanel.Option1.EditBox:SetText(x)
		self.OptionsPanel.Option2.EditBox:SetText(y)
	end
end

function Annene:PLAYER_LOGOUT()
	AnneneDB.x = x
	AnneneDB.y = y
end

function Annene:PetBattleFrameSetStyle()
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
	
	PetBattleFrame.BottomFrame.PetSelectionFrame:SetPoint("BOTTOM", 0, 131)

	self:PetBattleFrameSetPosition(x, y)
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

function Annene:PetBattleFrameSetPosition(x, y)
	PetBattleFrame.TopVersus:SetPoint("TOP","UIParent", "CENTER", 0+x, -210+y)
end

--Options 
Annene.OptionsPanel = CreateFrame("Frame", "AnneneOptions", UIParent)
local f = Annene.OptionsPanel
f:Hide()
f.name = "Annene"
f.okay = function()
	x = f.Option1.EditBox:GetText()
	xOld = x
	y = f.Option2.EditBox:GetText()
	yOld = y
end
f.cancel = function()
	x, y = xOld, yOld
	f.Option1.EditBox:SetText(x)
	f.Option2.EditBox:SetText(y)
	Annene:PetBattleFrameSetPosition(x, y)
end
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(Annene.OptionsPanel)


f.title = f:CreateFontString("Title")
f.title:SetFontObject("GameFontNormalLarge")
f.title:SetText("Annene Options")
f.title:SetPoint("TOPLEFT",15,-15)

--x value
--Description
f.Option1 = {}
f.Option1.Descr = f:CreateFontString("Option1Descr")
f.Option1.Descr:SetFontObject("GameFontWhite")
f.Option1.Descr:SetText("Set the x offset")
f.Option1.Descr:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 5, -15)
--Edit Box
f.Option1.EditBox = CreateFrame("EditBox", "Option1EditBox", f, "InputBoxTemplate")
f.Option1.EditBox:SetPoint("LEFT", f.Option1.Descr, "RIGHT", 10, 1)
f.Option1.EditBox:SetWidth(30)
f.Option1.EditBox:SetHeight(16)
f.Option1.EditBox:SetAutoFocus(false)
f.Option1.EditBox:SetScript("OnEditFocusGained", function(self) self.Button:Enable() end)
f.Option1.EditBox:SetScript("OnEditFocusLost", function(self) self.Button:Disable() end)
f.Option1.EditBox:SetMaxLetters(5)
--Button
f.Option1.EditBox.Button = CreateFrame("Button", "Option1Button", f, "UIPanelButtonTemplate")
f.Option1.EditBox.Button:SetPoint("LEFT", f.Option1.EditBox, "RIGHT", 3, 0)
f.Option1.EditBox.Button:SetWidth(32)
f.Option1.EditBox.Button:SetHeight(21)
f.Option1.EditBox.Button:SetText("OK")
f.Option1.EditBox.Button:Disable()
f.Option1.EditBox.Button:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		f.Option1.EditBox:ClearFocus()
		f.Option1.EditBox:SetText(tonumber(f.Option1.EditBox:GetText()))
		Annene:PetBattleFrameSetPosition(f.Option1.EditBox:GetText(), f.Option2.EditBox:GetText())
	end end)

--y value
--Description
f.Option2 = {}
f.Option2.Descr = f:CreateFontString("Option2Descr")
f.Option2.Descr:SetFontObject("GameFontWhite")
f.Option2.Descr:SetText("Set the y offset")
f.Option2.Descr:SetPoint("TOPLEFT", f.Option1.Descr, "BOTTOMLEFT", 0, -12)
--Edit Box
f.Option2.EditBox = CreateFrame("EditBox", "Option2EditBox", f, "InputBoxTemplate")
f.Option2.EditBox:SetPoint("LEFT", f.Option2.Descr, "RIGHT", 10, 1)
f.Option2.EditBox:SetWidth(30)
f.Option2.EditBox:SetHeight(16)
f.Option2.EditBox:SetAutoFocus(false)
f.Option2.EditBox:SetScript("OnEditFocusGained", function(self) self.Button:Enable() end)
f.Option2.EditBox:SetScript("OnEditFocusLost", function(self) self.Button:Disable() end)
f.Option2.EditBox:SetMaxLetters(5)
--Button
f.Option2.EditBox.Button = CreateFrame("Button", "Option2Button", f, "UIPanelButtonTemplate")
f.Option2.EditBox.Button:SetPoint("LEFT", f.Option2.EditBox, "RIGHT", 3, 0)
f.Option2.EditBox.Button:SetWidth(32)
f.Option2.EditBox.Button:SetHeight(21)
f.Option2.EditBox.Button:SetText("OK")
f.Option2.EditBox.Button:Disable()
f.Option2.EditBox.Button:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		f.Option2.EditBox:ClearFocus()
		f.Option2.EditBox:SetText(tonumber(f.Option2.EditBox:GetText()))
		Annene:PetBattleFrameSetPosition(f.Option1.EditBox:GetText(), f.Option2.EditBox:GetText())
	end end)
