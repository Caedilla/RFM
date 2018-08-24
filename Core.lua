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
	--Grid2LayoutFrame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-4,210)
	Grid2LayoutFrame:ClearAllPoints()
	Grid2LayoutFrame:SetPoint("BOTTOMRIGHT",ChatFrame1,"BOTTOMRIGHT",0,4)
	--print("Moving Grid2")
	--RFM.BagnonMonitor:SetScript("OnUpdate", itemFrameMoveOnUpdate)	
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
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameContainer:Hide()
		
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
	SetCVar("MSAAAlphaTest", 0)
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
	SetCVar("RAIDreflectionMode", 0)
	SetCVar("waterDetail", 3)
	SetCVar("RAIDwaterDetail", 1)
	SetCVar("rippleDetail", 2)
	SetCVar("RAIDrippleDetail", 0)
	SetCVar("shadowMode", 3) -- Soft Blurred Edge shadows.
	SetCVar("RAIDshadowMode", 3)
	SetCVar("shadowTextureSize", 1024)
	SetCVar("RAIDshadowTextureSize", 1024)	
	SetCVar("SSAO", 4)
	SetCVar("RAIDSSAO", 4)
	SetCVar("wmoDoodadDist", 1000)
	SetCVar("wmoLodDist", 400)
	SetCVar("RAIDwmoLodDist", 400)
	SetCVar("synchronizeSettings", 0)
	SetCVar("synchronizeMacros", 0)
	SetCVar("synchronizeConfig", 0)
	SetCVar("synchronizeChatFrames", 0)
	SetCVar("synchronizeBindings", 0)
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
	
	
	-- Create Backdrops
	for i=1,10 do
		local Chat = CreateFrame("Frame","R_ChatFrame"..i,ChatFrameList[i])
		local Background = Chat:CreateTexture("R_ChatFrame"..i.."Background","BACKGROUND")
		local AnchorFrame = _G[ChatFrameList[i]:GetName()]
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
		RFM.Grid2Monitor = Grid2Monitor
		Grid2LayoutFrame:HookScript("OnShow",Grid2LayoutFrameMover)
		if not InCombatLockdown() then
			Grid2LayoutFrame:Hide()
			Grid2LayoutFrame:Show()
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

