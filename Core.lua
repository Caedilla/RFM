local RFM = RFM or LibStub("AceAddon-3.0"):NewAddon("RFM", "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("RFM")
local InInstance, InstanceType, itemFrameMoveOnUpdateTime
local cfg = {
	Border = {
		edgeFile = [[Interface\ChatFrame\ChatFrameBackground]], -- Pixel Border settings. 
		edgeSize = 1,
	},
}
local ChatFrameList = {
	ChatFrame1,
	ChatFrame2,
	ChatFrame3,
	ChatFrame4,
	ChatFrame5,
	ChatFrame6,
	ChatFrame7,
	ChatFrame8,
	ChatFrame9,
	ChatFrame10,
}
-------------------------------------------------------------------------------------
----------------						Talents							-------------
-------------------------------------------------------------------------------------
function RFM:TalentSwitcher(r,c)
	LearnTalent(GetTalentInfo(r,c,1))
end
function RFM:AffPvP()
	RFM:TalentSwitcher(1,2)
	RFM:TalentSwitcher(2,2)
	RFM:TalentSwitcher(3,2)
	RFM:TalentSwitcher(4,3)
	RFM:TalentSwitcher(5,1)
	RFM:TalentSwitcher(6,1)
	RFM:TalentSwitcher(7,2)	
end
function RFM:AffPvE()
	RFM:TalentSwitcher(1,3)
	RFM:TalentSwitcher(2,1)
	RFM:TalentSwitcher(3,1)
	RFM:TalentSwitcher(4,3)
	RFM:TalentSwitcher(5,1)
	RFM:TalentSwitcher(6,1)
	RFM:TalentSwitcher(7,2)	
end
function RFM:GetPvPTalents()
	RAPossibleTalents = {}
	RAPossibleTalents = C_SpecializationInfo.GetPvpTalentSlotInfo(2)
	RAPossibleTalents = RAPossibleTalents.availableTalentIDs
	for i = 1,#RAPossibleTalents do
		print(GetPvpTalentInfoByID(RAPossibleTalents[i]))
	end	
	PlayerTalentFrameTalentsPvpTalentFrame.TalentSlot1:SetSelectedTalent(talentID)
	PlayerTalentFrameTalentsPvpTalentFrame.TalentSlot2:SetSelectedTalent(talentID)
	PlayerTalentFrameTalentsPvpTalentFrame.TalentSlot3:SetSelectedTalent(talentID)
end

function RFM.Reload()
	--ChatFrame1:AddMessage("|cFFFF75B3RSA:|r " .. format(message1) .. "|cffffa0a0|Hrldui:RSA|h[Reload]|h|r" .. format(message2))
	ChatFrame1:AddMessage("|cFFFF75B3RSA:|r |cffffa0a0|Hrldui:RSA|h[Reload UI]|h|r")
	--ChatFrame1:AddMessage("|Hlinktype:google.com|hgoogle.com|h")
end


--"Interface/PVPFrame/Icons/UI_RankedPvP_05"
--"Interface/LFGFRAME/UI-LFG-ICON-ROLES"
--"Interface/Glues/AccountUpgrade/ClassTrialThanksFrame"
--"Interface/PVPFrame/Icons/UI_RankedPvP_05_Small"
--"Interface/PVPFrame/PvPQueue"
--"Interface/Warfront/WarfrontMapIcons"
--"Interface/PVPFrame/Scoreboard"
--"Interface/MINIMAP/ObjectIconsAtlas"
-------------------------------------------------------------------------------------
----------------					Bagnon Adjustments					-------------
-------------------------------------------------------------------------------------
local function itemFrameMoveOnUpdate(self,elapsed)
    itemFrameMoveOnUpdateTime = itemFrameMoveOnUpdateTime + elapsed
    if itemFrameMoveOnUpdateTime > 0 then
		BagnonFrameinventory.itemFrame:SetPoint("TOPLEFT",BagnonFrameinventory,8,-32)
        itemFrameMoveOnUpdateTime = 0
		RFM.BagnonMonitor:SetScript("OnUpdate", nil)
    end
end

local function BagnonInventoryMoveSize()
	BagnonFrameinventory:ClearAllPoints()
	--BagnonFrameinventory:SetPoint("BOTTOMRIGHT",ChatFrame3,"TOPRIGHT",2,8)
	--BagnonFrameinventory:SetPoint("BOTTOMLEFT",ChatFrame3,"TOPLEFT",-2,8)
	BagnonFrameinventory:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-4,4)
	BagnonFrameinventory:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT",-435,627)
	itemFrameMoveOnUpdateTime = 0
	RFM.BagnonMonitor:SetScript("OnUpdate", itemFrameMoveOnUpdate)	
end

-------------------------------------------------------------------------------------
----------------					Grid2 Adjustments					-------------
-------------------------------------------------------------------------------------
local function Grid2LayoutFrameMover()
	if InCombatLockdown() then return end
	--Grid2LayoutFrame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-4,210)
	local a,b,c,d,e = Grid2LayoutFrame:GetPoint()
	if a == "BOTTOMLEFT" and b == ChatFrame1 and c == "TOPLEFT" and d == -2 and e == 6 then
		RFM.Grid2Monitor:SetScript("OnUpdate",nil)
	else 
		Grid2LayoutFrame:ClearAllPoints()
		Grid2LayoutFrame:SetPoint("BOTTOMLEFT",ChatFrame1,"TOPLEFT",-2,6)
	end
end

-------------------------------------------------------------------------------------
----------------				  Blizzard Frame Hider  				-------------
----------------				SorhaQuestLog Raid Hider				-------------
----------------				    In Combat Hider						-------------
-------------------------------------------------------------------------------------
local function ShouldShow()
	InInstance, InstanceType = IsInInstance()
	if InstanceType == "raid" then return false end
	if IsInRaid() then return end
	if InstanceType == "arena" then return false end
	if InstanceType == "pvp" then return false end
	return true
end
local function Hider()
	if InCombatLockdown() then -- Hide Minimap and SLDT Frames attatched to it while in Combat.
		--if MinimapCluster:IsShown() then MinimapCluster:Hide() end
	else
		--if not MinimapCluster:IsShown() then MinimapCluster:Show() end
		-- Always hide Blizzard's Raid Frames.
		if CompactRaidFrameManager then
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:Hide()
			CompactRaidFrameContainer:UnregisterAllEvents()
			CompactRaidFrameContainer:Hide()
		end
		
		-- Always hide Blizzard's Player Frame.
		PlayerFrame:UnregisterAllEvents()
		PlayerFrame:Hide()
		
		-- Always hide Blizzard's Pet Frame.
		PetFrame:UnregisterAllEvents()
		PetFrame:Hide()
		
		-- Always hide Blizzard's Target Frame.
		TargetFrame:UnregisterAllEvents()
		TargetFrame:Hide()
		
		-- Always hide Blizzard's Focus Frame.
		FocusFrame:UnregisterAllEvents()
		FocusFrame:Hide()
		
		-- Always hide BLizzard's Boss Frames.
		Boss1TargetFrame:UnregisterAllEvents()
		Boss1TargetFrame:Hide()
		Boss2TargetFrame:UnregisterAllEvents()
		Boss2TargetFrame:Hide()
		Boss3TargetFrame:UnregisterAllEvents()
		Boss3TargetFrame:Hide()
		Boss4TargetFrame:UnregisterAllEvents()
		Boss4TargetFrame:Hide()	
		
		-- Hide Combat log header background
		CombatLogQuickButtonFrame_CustomTexture:Hide()		
	end
	

	if SorhaQuestLog then
		RFM.Monitor:UnregisterEvent('ADDON_LOADED')		
		if ShouldShow() then
			if InCombatLockdown() == false then
				SorhaQuestLog:SetModuleEnabled("QuestTracker", true)
				SQLShowHiddenButton:Hide()
				SQLShowHiddenButton:ClearAllPoints()
				SQLShowHiddenButton:SetScript("OnEnter", nil)
				SQLShowHiddenButton:SetScript("OnLeave", nil)
				SQLShowHiddenButton:RegisterForClicks()
				SQLShowHiddenButton:SetBackdropBorderColor(0,0,0,0)
			end
		else
			if InCombatLockdown() == false then
				SorhaQuestLog:SetModuleEnabled("QuestTracker", false)
			end
		end
	-- Toggle SQL
	--SorhaQuestLog:SetModuleEnabled("QuestTracker", not SorhaQuestLog:GetModuleEnabled("QuestTracker"))
	end
end

-------------------------------------------------------------------------------------
----------------					Auto Queue Accept					-------------
-------------------------------------------------------------------------------------
local function LFRAcceptRole()
	LFGListApplicationDialog.SignUpButton:Click()
end

local function LFDAcceptRole()
	LFDRoleCheckPopupAcceptButton:Click()
end

local function LFGAcceptRole()
	LFGInvitePopupAcceptButton:Click()
end

-------------------------------------------------------------------------------------
----------------					My Cvar Settings					-------------
-------------------------------------------------------------------------------------
local function MyCvars()
	SetCVar("nameplateOtherAtBase", 0) -- 0 = above, 2 = below, 1 seems to make large units closer to their head.
	SetCVar("nameplateOverlapH", 0.25)
	SetCVar("nameplateOverlapV", 0.5)
	SetCVar("nameplateShowAll", 1) -- Always show nameplates, rather than just in combat.
	SetCVar("nameplateMaxDistance", 40)
	
	SetCVar("nameplateOverlapH", 1)
	SetCVar("nameplateOverlapV", 0.1)
	
	-- Forces nameplates to stay on screen when the nameplate should be below or above the screen.
	SetCVar("nameplateOtherBottomInset", -1)
	SetCVar("nameplateLargeBottomInset", -1) 	
	SetCVar("nameplateOtherTopInset", -1)
	SetCVar("nameplateLargeTopInset", -1)	
	SetCVar("nameplateMotion", 1) -- Stacking at 1, overlapping at 0.
	SetCVar("nameplateShowEnemyGuardians", 1)
	SetCVar("nameplateShowEnemyMinions", 1)
	SetCVar("nameplateShowEnemyMinus", 1)
	SetCVar("nameplateShowEnemyPets", 1)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("nameplateTargetRadialPosition", 1) -- Target Nameplate stays on screen when the unit is offscreen.
	SetCVar("nameplateShowSelf", 0) -- Hide Personal Resource Display	
	SetCVar("ActionButtonUseKeyDown", 0) -- Disable using abilities on key press. Use on key release.
	SetCVar("animFrameSkipLOD", 0) -- Animations skip frames at higher distance, reduce performance load. DISABLED FOR NOW.
	SetCVar("autoLootDefault", 1) -- Always enable Auto Loot
	SetCVar("autoLootRate", 5) -- Faster Auto Loot
	SetCVar("autoSelfCast", 1)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6) -- Maximum Camera Range
	SetCVar("cameraSmooth", 0)
	SetCVar("cameraYawMoveSpeed", 120) -- Slow horizontal camera rotation. Default 180.
	SetCVar("deselectOnClick", 1) -- Disable sticky targetting.
	SetCVar("flightAngleLookAhead", 1) -- Spin and angle character when flying.	
	SetCVar("findYourselfAnywhere", 1) -- Glow Character Always
	SetCVar("findYourselfAnywhereOnlyInCombat", 1)
	SetCVar("findYourselfInBG", 1)
	SetCVar("findYourselfInBGOnlyInCombat", 0)
	SetCVar("findYourselfInRaid", 1)
	SetCVar("findYourselfInRaidOnlyInCombat", 0)
	SetCVar("findYourselfMode", 2) -- 0 Circle, 1 Circle and Highlight, 2 Highlight
	SetCVar("interactOnLeftClick", 0)

	-- GRAPHICS
	SetCVar("componentTextureLevel", 0) -- Character Model Texture level. 0 highest, 2 lowest.
	SetCVar("RAIDcomponentTextureLevel", 1)	
	SetCVar("doodadLodDist", 50) -- 150 Default. 
	SetCVar("EmitterCombatRange", 250) -- 900 Default. Weapon / Shoulder Glows
	SetCVar("NonEmitterCombatRange", 1200) -- 900 Default.
	SetCVar("groundEffectDensity", 256)
	SetCVar("RAIDgroundEffectDensity", 64)
	SetCVar("groundEffectDist", 128)
	SetCVar("RAIDgroundEffectDist", 32)
	SetCVar("groundEffectFade", 128)
	SetCVar("groundEffectFade", 32)
	SetCVar("gxMaxFrameLatency", 6)
	SetCVar("horizonStart", 4000) -- Maximum visible distance. 4000 Max farclip beyond that is always foggy.
	SetCVar("RAIDhorizonStart", 1000)
	SetCVar("farclip", 24000) -- Maximum view distance of terrain in fog
	SetCVar("RAIDfarclip", 5000)
	SetCVar("lightMode", 2) -- Lighting effects 0-2, 2 best.
	SetCVar("lodObjectCullDist", 60) -- Distance to stop drawing lod objects
	SetCVar("lodObjectCullSize", 30) -- size of objects to cull
	SetCVar("lodObjectFadeScale", 50)
	SetCVar("lodObjectMinSize", 250)
	SetCVar("RAIDlodObjectCullDist", 30)
	SetCVar("RAIDlodObjectCullSize", 30)
	SetCVar("RAIDlodObjectFadeScale", 50)
	SetCVar("RAIDlodObjectMinSize", 35)	
	SetCVar("M2ForceAdditiveParticleSort", 1) -- Not sure, glowy shit?
	SetCVar("M2UseThreads", 3)
	SetCVar("maxFPS", 75)
	SetCVar("maxFPSBk", 15)
	SetCVar("maxFPSLoading", 10)
	SetCVar("MSAAAlphaTest", 1)
	SetCVar("MSAAQuality", 2,0)	
	SetCVar("mtParticles", 2) -- Particle threads? Default 1
	SetCVar("occlusionMaxJobs", 6) -- Occlusion threads? Default 3	
	SetCVar("particleDensity", 100) -- Particle Density
	SetCVar("RAIDparticleDensity", 25)
	SetCVar("particleMTDensity", 200) -- Particle Density for Multi-threaded particles.
	SetCVar("RAIDparticleMTDensity", 50)
	SetCVar("projectedTextures", 1)	
	SetCVar("reflectionDownscale", 0)
	SetCVar("reflectionMode", 3)
	SetCVar("RAIDreflectionMode", 2)
	SetCVar("waterDetail", 3)
	SetCVar("RAIDwaterDetail", 1)
	SetCVar("rippleDetail", 2)
	SetCVar("RAIDrippleDetail", 0)
	SetCVar("shadowMode", 3)
	SetCVar("shadowSoft", 1) -- Soft Blurred Edge shadows.
	SetCVar("entityShadowFadeScale", 100)
	SetCVar("RAIDentityShadowFadeScale", 10)
	SetCVar("RAIDshadowSoft", 0)
	SetCVar("RAIDshadowMode", 1)
	SetCVar("shadowTextureSize", 1024)
	SetCVar("RAIDshadowTextureSize", 1024)	
	SetCVar("SSAO", 4)
	SetCVar("RAIDSSAO", 4)
	SetCVar("assaoDetailShadowStrength", 5)
	SetCVar("assaoFadeOutFrom", 0)
	SetCVar("assaoFadeOutTo", 200)
	SetCVar("assaoHorizonAngleThresh", 0.5)
	SetCVar("assaoNormals", 0)
	SetCVar("assaoRadius", 1.25)
	SetCVar("assaoSharpness", 0.75)
	SetCVar("assaoShadowClamp", 1)	
	SetCVar("assaoShadowMult", 3)
	SetCVar("assaoShadowPower", 1.5)	
	SetCVar("wmoDoodadDist", 1000)
	SetCVar("wmoLodDist", 400)
	SetCVar("RAIDwmoLodDist", 400)
	
	-- Other Stuff
	SetCVar("synchronizeSettings", 0)
	SetCVar("synchronizeMacros", 0)
	SetCVar("synchronizeConfig", 0)
	SetCVar("synchronizeChatFrames", 0)
	SetCVar("synchronizeBindings", 0)	
	SetCVar("skipStartGear", 1)
	SetCVar("TargetPriorityCombatLock", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("showTamers", 0)	
end

function RFM:OnEnable()
	-- Primary Chat Window, left
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT",6,8)
	ChatFrame1:SetWidth(421)
	ChatFrame1:SetHeight(191)
	
	-- Hide BFA Voice Chat buttons
	ChatFrameChannelButton:ClearAllPoints()
	ChatFrameChannelButton:SetPoint("TOPRIGHT",50000,50000)
	ChatFrameChannelButton:Hide()
	ChatFrameToggleVoiceMuteButton:ClearAllPoints()
	ChatFrameToggleVoiceMuteButton:Hide()
	ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
	ChatFrameToggleVoiceDeafenButton:Hide()
	
	-- Move PVP Objective Score Down a bit.
	UIWidgetTopCenterContainerFrame:SetPoint("TOP",0,-30)
	UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
	UIWidgetBelowMinimapContainerFrame:SetPoint("TOP",0,-60)
	
	--Minimap:SetClassBlipTexture([[Interface\Addons\RFM\Media\MinimapClassIcons.tga]])
	--[[
	RAID_CLASS_COLORS.DEATHKNIGHT.r = 207/255 RAID_CLASS_COLORS.DEATHKNIGHT.g = 55/255 RAID_CLASS_COLORS.DEATHKNIGHT.b = 77/255
	RAID_CLASS_COLORS.DEMONHUNTER.r = 153/255 RAID_CLASS_COLORS.DEMONHUNTER.g = 255/255 RAID_CLASS_COLORS.DEMONHUNTER.b = 0/255
	RAID_CLASS_COLORS.DRUID.r = 255/255 RAID_CLASS_COLORS.DRUID.g = 131/255 RAID_CLASS_COLORS.DRUID.b = 50/255
	RAID_CLASS_COLORS.HUNTER.r = 161/255 RAID_CLASS_COLORS.HUNTER.g = 186/255 RAID_CLASS_COLORS.HUNTER.b = 73/255
	RAID_CLASS_COLORS.MAGE.r = 55/255 RAID_CLASS_COLORS.MAGE.g = 197/255 RAID_CLASS_COLORS.MAGE.b = 255/255
	RAID_CLASS_COLORS.MONK.r = 0/255 RAID_CLASS_COLORS.MONK.g = 169/255 RAID_CLASS_COLORS.MONK.b = 138/255
	RAID_CLASS_COLORS.PALADIN.r = 255/255 RAID_CLASS_COLORS.PALADIN.g = 99/255 RAID_CLASS_COLORS.PALADIN.b = 183/255
	RAID_CLASS_COLORS.PRIEST.r = 255/255 RAID_CLASS_COLORS.PRIEST.g = 236/255 RAID_CLASS_COLORS.PRIEST.b = 211/255
	RAID_CLASS_COLORS.ROGUE.r = 255/255 RAID_CLASS_COLORS.ROGUE.g = 216/255 RAID_CLASS_COLORS.ROGUE.b = 0/255
	RAID_CLASS_COLORS.SHAMAN.r = 0/255 RAID_CLASS_COLORS.SHAMAN.g = 107/255 RAID_CLASS_COLORS.SHAMAN.b = 195/255
	RAID_CLASS_COLORS.WARLOCK.r = 150/255 RAID_CLASS_COLORS.WARLOCK.g = 119/255 RAID_CLASS_COLORS.WARLOCK.b = 229/255
	RAID_CLASS_COLORS.WARRIOR.r = 187/255 RAID_CLASS_COLORS.WARRIOR.g = 127/255 RAID_CLASS_COLORS.WARRIOR.b = 75/255
	]]--
	
	-- Create Backdrops
	for i=1,10 do
		local Chat = CreateFrame("Frame","R_ChatFrame"..i,ChatFrameList[i])
		local Background = Chat:CreateTexture("R_ChatFrame"..i.."Background","BACKGROUND")
		local AnchorFrame = _G[ChatFrameList[i]:GetName()]
		
		
		local ChatTab = CreateFrame("Frame","R_ChatTab"..i,GeneralDockManager)
		local TabText = ChatTab:CreateFontString("R_ChatTabText"..i)
		local text = _G["ChatFrame"..i.."TabText"]
		local tab = _G["ChatFrame"..i.."Tab"]
		TabText:SetFont(LSM:Fetch("font", "RUF"),18,"OUTLINE")			
		TabText:SetText(_G["ChatFrame"..i.."TabText"]:GetText())
		
		
		Chat:SetBackdrop(cfg.Border)
		Chat:SetBackdropBorderColor(0,0,0,1)
		Chat:SetFrameLevel(0)
		AnchorFrame.ScrollBar:ClearAllPoints()
		AnchorFrame.ScrollBar:SetPoint("RIGHT", AnchorFrame,24,0)
		AnchorFrame.ScrollBar:SetHeight(191)
		AnchorFrame.ScrollToBottomButton:ClearAllPoints()
		AnchorFrame.ScrollToBottomButton:SetPoint("TOPRIGHT",50000,50000)		
		
		if i == 3 then
			AnchorFrame.ScrollBar:ClearAllPoints()
			AnchorFrame.ScrollBar:SetPoint("TOPLEFT", AnchorFrame,-24,0)
			AnchorFrame.ScrollBar:SetHeight(191)
			AnchorFrame.ScrollToBottomButton:ClearAllPoints()
			AnchorFrame.ScrollToBottomButton:SetPoint("TOPRIGHT",50000,50000)
		end
		if i == 2 then
			Chat:SetPoint("TOPLEFT",AnchorFrame,-2,28)
			Chat:SetPoint("BOTTOMRIGHT",AnchorFrame,2,-4)
		else
			Chat:SetPoint("TOPLEFT",AnchorFrame,-2,4)
			Chat:SetPoint("BOTTOMRIGHT",AnchorFrame,2,-4)
		end

		
		if i == 1 then
			TabText:SetPoint("LEFT",GeneralDockManager,"LEFT",0,0)
			TabText:SetText(string.upper(text:GetText()))
			TabText:Show()
			tab:SetWidth(35)
			tab:SetHeight(15)
		elseif i == 2 then
			TabText:SetPoint("LEFT",_G["R_ChatTabText"..i-1],"RIGHT",0,0)
			TabText:SetText(string.upper(text:GetText()))
			TabText:Show()
			tab:SetWidth(51)
			tab:SetHeight(15)
		elseif i == 3 then
			TabText:SetPoint("LEFT",_G["R_ChatTabText"..i-1],"RIGHT",0,0)
			TabText:SetText(string.upper(text:GetText()))
			TabText:Show()
			tab:SetWidth(45)
			tab:SetHeight(15)
		elseif i == 4 then
			TabText:SetPoint("LEFT",_G["R_ChatTabText"..i-1],"RIGHT",0,0)
			TabText:SetText(string.upper(text:GetText()))
			TabText:Show()
			tab:SetWidth(86)
			tab:SetHeight(15)
		--[[elseif i == 5 then
			TabText:SetPoint("LEFT",_G["R_ChatTabText"..i-1],"RIGHT",0,0)
			TabText:SetText(string.upper(text:GetText()))
			TabText:Show()
			tab:SetWidth(45)
			tab:SetHeight(15)]]--
		end
		
		GeneralDockManager:ClearAllPoints()
		GeneralDockManager:SetPoint("TOPLEFT",ChatFrame1,0,17)
		GeneralDockManager:SetPoint("TOPRIGHT",ChatFrame1,0,17)
		
		
		Background:SetAllPoints(Chat)
		Background:SetTexture(LSM:Fetch("background", "Solid"))
		Background:SetVertexColor(0,0,0,0.5)
	end
	
	-- Run the check on all of these events.
	local Monitor = CreateFrame("Frame", "RFM_Monitor")
	Monitor:RegisterEvent("PLAYER_ENTERING_WORLD")
	Monitor:RegisterEvent("PLAYER_REGEN_DISABLED")
	Monitor:RegisterEvent("PLAYER_REGEN_ENABLED")
	Monitor:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	Monitor:RegisterEvent("GROUP_ROSTER_UPDATE")
	Monitor:RegisterEvent('ADDON_LOADED')
	Monitor:SetScript("OnEvent", Hider)
	RFM.Monitor = Monitor
	
	-- Automatic Queue Accept
	LFGListApplicationDialog:SetScript("OnShow", LFRAcceptRole)
	LFDRoleCheckPopup:SetScript("OnShow", LFDAcceptRole)
	LFGInvitePopup:SetScript("OnShow", LFGAcceptRole)
	
	
	if Grid2 then	
		local Grid2Monitor = CreateFrame("Frame","RFM_Grid2Monitor")		
		Grid2Monitor:RegisterEvent("PLAYER_ENTERING_WORLD")
		--Grid2Monitor:RegisterEvent("GROUP_ROSTER_UPDATE")
		Grid2Monitor:SetScript("OnUpdate",Grid2LayoutFrameMover)
		RFM.Grid2Monitor = Grid2Monitor		
		Grid2LayoutFrame:HookScript("OnShow",Grid2LayoutFrameMover)
		Grid2LayoutFrame:HookScript("OnSizeChanged",Grid2LayoutFrameMover)
		if not InCombatLockdown() then
			Grid2LayoutFrame:Hide()
			Grid2LayoutFrame:Show()
			Grid2LayoutFrameMover()
		end
	end	
	if Bagnon then
		local BagnonMonitor = CreateFrame("Frame","RFM_BagnonMonitor")
		RFM.BagnonMonitor = BagnonMonitor
		BagnonFrameinventory:Show()
		BagnonFrameinventory:Hide()
		BagnonFrameinventory:HookScript("OnShow",BagnonInventoryMoveSize)
	end
	
	MyCvars()
end

