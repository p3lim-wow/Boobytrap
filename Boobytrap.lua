if(select(2, UnitClass('player')) ~= 'HUNTER') then return end

local Boobytrap = CreateFrame('Frame', nil, UIParent)
Boobytrap:SetPoint('CENTER', -260, -274)
Boobytrap:SetSize(150, 13)
Boobytrap:SetBackdrop({
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {left = -1, right = -1, top = -1, bottom = -1},	
})
Boobytrap:SetBackdropColor(0, 0, 0)
Boobytrap:Hide()

local Bar = CreateFrame('StatusBar', nil, Boobytrap)
Bar:SetAllPoints()
Bar:SetStatusBarTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
Bar:SetStatusBarColor(0.2, 0.2, 0.6)
Bar:SetMinMaxValues(0, 60)

local Background = Bar:CreateTexture(nil, 'BACKGROUND')
Background:SetAllPoints()
Background:SetTexture(0, 0, 0.3)

local Time = Bar:CreateFontString(nil, 'ARTWORK')
Time:SetPoint('RIGHT', -2, 0)
Time:SetJustifyH('RIGHT')
Time:SetFont([=[Interface\AddOns\Boobytrap\semplice.ttf]=], 8, 'OUTLINEMONOCHROME')

local Name = Bar:CreateFontString(nil, 'ARTWORK')
Name:SetPoint('LEFT', 2, 0)
Name:SetPoint('RIGHT', Time, 'LEFT')
Name:SetJustifyH('LEFT')
Name:SetFont([=[Interface\AddOns\Boobytrap\semplice.ttf]=], 8, 'OUTLINEMONOCHROME')

Bar:SetScript('OnUpdate', function(self, elapsed)
	self.elapsed = (self.elapsed or 0) - elapsed

	self:SetValue(self.elapsed)
	Time:SetFormattedText('%d', self.elapsed)
end)

local player
Boobytrap:RegisterEvent('PLAYER_LOGIN')
Boobytrap:SetScript('OnEvent', function(self, event, ...)
	if(event == 'PLAYER_LOGIN') then
		player = UnitGUID('player')
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	else
		local _, event, _, source, _, _, _, _, destination, _, _, spell = ...
		if(source == player and spell == 3355) then
			if(event == 'SPELL_AURA_REMOVED') then
				self:Hide()
			elseif(event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH') then
				Bar.elapsed = 60
				Name:SetText(destination)
				self:Show()
			end
		end
	end
end)
