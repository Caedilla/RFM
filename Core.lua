local RFM = RFM or LibStub('AceAddon-3.0'):NewAddon('RFM', 'AceConsole-3.0', 'AceEvent-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('RFM')
local InInstance, InstanceType, itemFrameMoveOnUpdateTime

local cfg = {
	Border = {
		edgeFile = [[Interface\ChatFrame\ChatFrameBackground]], -- Pixel Border settings.
		edgeSize = 1,
	},
}

local function ShouldShow()
	InInstance, InstanceType = IsInInstance()
	if InstanceType == 'raid' then return false end
	if IsInRaid() then return end
	if InstanceType == 'arena' then return false end
	if InstanceType == 'pvp' then return false end
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
		if RFM.Client == 1 then
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
		end

		-- Hide Combat log header background
		CombatLogQuickButtonFrame_CustomTexture:Hide()
	end


	if SorhaQuestLog then
		RFM.Monitor:UnregisterEvent('ADDON_LOADED')
		if ShouldShow() then
			if InCombatLockdown() == false then
				SorhaQuestLog:SetModuleEnabled('QuestTracker', true)
				SQLShowHiddenButton:Hide()
				SQLShowHiddenButton:ClearAllPoints()
				SQLShowHiddenButton:SetScript('OnEnter', nil)
				SQLShowHiddenButton:SetScript('OnLeave', nil)
				SQLShowHiddenButton:RegisterForClicks()
				SQLShowHiddenButton:SetBackdropBorderColor(0, 0, 0, 0)
			end
		else
			if InCombatLockdown() == false then
				SorhaQuestLog:SetModuleEnabled('QuestTracker', false)
			end
		end
	-- Toggle SQL
	--SorhaQuestLog:SetModuleEnabled('QuestTracker', not SorhaQuestLog:GetModuleEnabled('QuestTracker'))
	end
end


local function LFRAcceptRole()
	LFGListApplicationDialog.SignUpButton:Click()
end

local function LFDAcceptRole()
	LFDRoleCheckPopupAcceptButton:Click()
end

local function LFGAcceptRole()
	LFGInvitePopupAcceptButton:Click()
end

local function MyCvars()
	local currentResolution = ({GetScreenResolutions()})[GetCurrentResolution()]
	currentResolution = string.sub(currentResolution, 6)
	currentResolution = tonumber(currentResolution)
	if 768/currentResolution >= 0.64 then
		UIParent:SetScale(768/currentResolution)
		SetCVar('useUiScale', false)
	else
		SetCVar('uiScale', 768/currentResolution)
		SetCVar('useUiScale', true)
	end

	do -- Nameplates
		SetCVar('nameplateOverlapH', 0.25)
		SetCVar('nameplateOverlapV', 0.5)
		SetCVar('nameplateShowAll', 1) -- Always show nameplates, rather than just in combat.
		SetCVar('nameplateOverlapH', 1)
		SetCVar('nameplateOverlapV', 0.1)
		SetCVar('nameplateOtherBottomInset', -1) -- Forces nameplates to stay on screen when the nameplate should be below or above the screen.
		SetCVar('nameplateLargeBottomInset', -1)
		SetCVar('nameplateOtherTopInset', -1)
		SetCVar('nameplateLargeTopInset', -1)
		SetCVar('nameplateGlobalScale', 1)
		SetCVar('nameplateHorizontalScale', 1)
		SetCVar('nameplateLargerScale', 1) -- Boss Nameplates
		SetCVar('nameplateMaxScale', 1)
		SetCVar('nameplateMinScale', 1)
		SetCVar('nameplateSelectedScale', 1)
		SetCVar('nameplateSelfScale', 1)
		SetCVar('nameplateVerticalScale', 1)
		SetCVar('nameplateLargeTopInset', -1)
		SetCVar('nameplateMotion', 1) -- Stacking at 1, overlapping at 0.
		SetCVar('nameplateShowEnemyGuardians', 1)
		SetCVar('nameplateShowEnemyMinions', 1)
		SetCVar('nameplateShowEnemyMinus', 1)
		SetCVar('nameplateShowEnemyPets', 1)
		SetCVar('nameplateShowEnemyTotems', 1)
		SetCVar('nameplateTargetRadialPosition', 1) -- Target Nameplate stays on screen when the unit is offscreen.
	end

	do -- Normal World Graphics
		SetCVar('componentTextureLevel', 0) -- Character Model Texture level. 0 highest, 2 lowest.
		SetCVar('doodadLodDist', 300) -- 150 Default.
		SetCVar('EmitterCombatRange', 1200) -- Weapon / Shoulder Glows
		SetCVar('NonEmitterCombatRange', 6400)
		SetCVar('entityShadowFadeScale', 100)
		SetCVar('entityLodDist', 10)  -- No idea, default 10.
		SetCVar('entityLodOffset', 10) -- No idea, default 10.
		SetCVar('groundEffectDensity', 256)
		SetCVar('groundEffectDist', 500)
		SetCVar('groundEffectFade', 128)
		SetCVar('gxMaxFrameLatency', 2)
		SetCVar('horizonStart', 4250) -- Maximum visible distance. 5000 Max farclip beyond that is always foggy.
		SetCVar('farclip', 8000) -- Maximum view distance of terrain in fog
		SetCVar('ffxAntiAliasingMode', 3) -- CMAA
		if RFM.Client == 1 then SetCVar('lightMode', 2) end -- Lighting effects 0-2, 2 best.
		SetCVar('lodObjectCullDist', 100) -- Distance to stop drawing lod objects. Default 30.
		SetCVar('lodObjectCullSize', 10) -- size of objects to cull. Default 15. Higher = Bigger objects get culled at distance.
		SetCVar('lodObjectFadeScale', 100) -- Default 100.
		SetCVar('lodObjectMinSize', 10) -- Default 20.
		SetCVar('M2ForceAdditiveParticleSort', 1) -- Not sure, glowy shit?
		SetCVar('M2UseThreads', 1)
		SetCVar('maxFPS', 144)
		SetCVar('maxFPSBk', 30)
		SetCVar('maxFPSLoading', 15)
		SetCVar('MSAAAlphaTest', 1)
		SetCVar('MSAAQuality', 2, 0) -- 2, 0
		SetCVar('occlusionMaxJobs', 6) -- Occlusion threads? Default 3
		SetCVar('particleDensity', 100) -- Particle Density
		SetCVar('particleMTDensity', 100) -- Particle Density for Multi-threaded particles. 100 Max.
		SetCVar('projectedTextures', 1)
		SetCVar('reflectionDownscale', 1) -- Downscale slightly, at 0 the reflections look too crisp.
		SetCVar('reflectionMode', 3) -- Reflect everything possible. Default 3
		SetCVar('rippleDetail', 2)
		SetCVar('shadowMode', 3)
		SetCVar('shadowSoft', 1) -- Soft Blurred Edge shadows.
		SetCVar('shadowTextureSize', 1024) -- With Soft shadows there is no need for higher resolution shadows.
		if RFM.Client == 1 then SetCVar('spellEffectLevel', 50) end
		SetCVar('SSAO', 4)
		SetCVar('assaoBlurPassCount', 0)
		SetCVar('assaoDetailShadowStrength', 5) -- SSAO strength on small details like hair.
		SetCVar('assaoFadeOutFrom', 0)
		SetCVar('assaoFadeOutTo', 400)
		SetCVar('assaoHorizonAngleThresh', 0.5)
		SetCVar('assaoNormals', 1)
		SetCVar('assaoRadius', 0.75)
		SetCVar('assaoSharpness', 1)
		SetCVar('assaoShadowClamp', 0.5)
		SetCVar('assaoShadowMult', 1.5)
		SetCVar('assaoShadowPower', 1.25)
		SetCVar('terrainLodDist', 1000) -- Seems to be related to how far away the game streams in data or something like that too? Higher numbers tank FPS.
		SetCVar('useHighResolutionUITextures', 1)
		SetCVar('waterDetail', 2) -- Actually looks better than 3 since the reflection warps a little over the water.
		SetCVar('wmoDoodadDist', 1000)
		SetCVar('wmoLodDist', 300)
		SetCVar('volumeFog', 1)
		SetCVar('volumeFogLevel', 4)
	end
	do -- Raid Specific Graphics
		SetCVar('RAIDcomponentTextureLevel', 0)
		SetCVar('RAIDentityShadowFadeScale', 10)
		SetCVar('RAIDgroundEffectDensity', 64)
		SetCVar('RAIDgroundEffectDist', 32)
		SetCVar('RAIDhorizonStart', 1000)
		SetCVar('RAIDfarclip', 4000)
		SetCVar('RAIDlodObjectCullDist', 50)
		SetCVar('RAIDlodObjectCullSize', 15)
		SetCVar('RAIDlodObjectFadeScale', 50)
		SetCVar('RAIDlodObjectMinSize', 20)
		SetCVar('RAIDparticleDensity', 25)
		SetCVar('RAIDparticleMTDensity', 50)
		SetCVar('RAIDreflectionMode', 2)
		SetCVar('RAIDrippleDetail', 0)
		SetCVar('RAIDshadowSoft', 1)
		SetCVar('RAIDshadowMode', 2)
		SetCVar('RAIDshadowTextureSize', 512)
		if RFM.Client == 1 then SetCVar('RAIDspellEffectLevel', 15) end
		SetCVar('RAIDSSAO', 0)
		SetCVar('RAIDterrainLodDist', 400)
		SetCVar('RAIDwaterDetail', 1)
		SetCVar('RAIDwmoLodDist', 400)
	end

	do -- Camera stuff
		if RFM.Client == 1 then  -- Maximum Camera Range is higher in Classic
			SetCVar('cameraDistanceMaxZoomFactor', 2.6)
		else
			SetCVar('cameraDistanceMaxZoomFactor', 4)
		end
		SetCVar('cameraSmooth', 0)
		SetCVar('cameraYawMoveSpeed', 120) -- Slow horizontal camera rotation. Default 180.
		SetCVar('cameraZoomSpeed', 25)
	end

	do -- Mouse Stuff
		SetCVar('rawMouseAccelerationEnable', 0)
		SetCVar('rawMouseEnable', 1)
		SetCVar('rawMouseRate', 500) -- Default 125. Polling Rate?
		SetCVar('rawMouseResolution', 1600) -- Default 400.
	end

	do -- Disable Synchronising Settings
		SetCVar('synchronizeSettings', 0)
		SetCVar('synchronizeMacros', 0)
		SetCVar('synchronizeConfig', 0)
		SetCVar('synchronizeChatFrames', 0)
		SetCVar('synchronizeBindings', 0)
	end

	do -- Misc Stuff
		SetCVar('ActionButtonUseKeyDown', 0) -- Disable using abilities on key press. Use on key release.
		SetCVar('autoLootDefault', 1) -- Always enable Auto Loot
		SetCVar('autoLootRate', 5) -- Faster Auto Loot
		SetCVar('autoSelfCast', 1)
		SetCVar('chatBubbles', 1)
		SetCVar('chatBubblesParty', 1)
		SetCVar('deselectOnClick', 1) -- Disable sticky targetting.
		SetCVar('findYourselfAnywhere', 1) -- Glow Character Always
		SetCVar('findYourselfAnywhereOnlyInCombat', 1)
		SetCVar('findYourselfInBG', 1)
		SetCVar('findYourselfInBGOnlyInCombat', 0)
		SetCVar('findYourselfInRaid', 1)
		SetCVar('findYourselfInRaidOnlyInCombat', 0)
		SetCVar('findYourselfMode', 2) -- 0 Circle, 1 Circle and Highlight, 2 Highlight
		SetCVar('flightAngleLookAhead', 1) -- Spin and angle character when flying.
		SetCVar('interactOnLeftClick', 0)
		SetCVar('questLogOpen', 0) -- Questlog toggled off on map by default
		SetCVar('screenshotQuality', 10)
		SetCVar('showSpenderFeedback', 0)
		SetCVar('showTamers', 0)
		SetCVar('showToastOffline', 0)
		SetCVar('showToastOnline', 1)
		SetCVar('skipStartGear', 1)
		SetCVar('spellQueueWindow', 60)
		SetCVar('TargetPriorityCombatLock', 1)
		SetCVar('UberTooltips', 1)
	end

end

function RFM:PlaceChat()
	-- Primary Chat Window, left
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint('BOTTOMLEFT', 6, 8)
	ChatFrame1:SetWidth(421)
	ChatFrame1:SetHeight(191)
end

local function TSM_PopupHider()
	StaticPopup_Hide('TSM_APP_DATA_ERROR')
end

local function ChatTabStyler(frame, i)
	local BlizzardFrame = frame
	local BlizzardBackground = _G[frame:GetName() .. 'Background']
	local BlizzardTab = _G[frame:GetName() .. 'Tab']
	local BlizzardTabText = _G[frame:GetName() .. 'TabText']
	local name = 'RFM_Chat'
	local Chat = CreateFrame('Frame', name .. i, BlizzardFrame)
	local Background = Chat:CreateTexture(name .. i .. 'Background', 'BACKGROUND')

	BlizzardFrame:SetShadowColor(0, 0, 0, 0)

	Chat:SetBackdrop(cfg.Border)
	Chat:SetBackdropBorderColor(0, 0, 0, 1)
	Chat:SetFrameLevel(0)
	Chat:SetPoint('TOPLEFT', BlizzardBackground, -2, 4)
	Chat:SetPoint('BOTTOMRIGHT', BlizzardBackground, 2, -4)
	Background:SetAllPoints(Chat)
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(0, 0, 0, 0.5)
	BlizzardTabText:SetWidth(BlizzardTabText:GetStringWidth()+2)
	BlizzardTabText:SetHeight(BlizzardTabText:GetStringHeight()+2)
	local font = LSM:Fetch('font', 'RUF')
	BlizzardTabText:SetFont(font, 20, 'OUTLINE')
	BlizzardTabText:SetText(BlizzardTabText:GetText():upper())
end

function RFM:OnEnable()

	RFM.Client = 1
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		RFM.Client = 2
	end

	if RFM.Client == 1 then

	else

	end

	-- Hide BFA Voice Chat buttons
	--ChatFrameChannelButton:ClearAllPoints()
	--ChatFrameChannelButton:SetPoint('TOPRIGHT', 50000, 50000)
	--ChatFrameChannelButton:Hide()
	--ChatFrameToggleVoiceMuteButton:ClearAllPoints()
	--ChatFrameToggleVoiceMuteButton:Hide()
	--ChatFrameToggleVoiceDeafenButton:ClearAllPoints()
	--ChatFrameToggleVoiceDeafenButton:Hide()

	-- Move PVP Objective Score Down a bit.
	UIWidgetTopCenterContainerFrame:SetPoint('TOP', 0, -30)
	UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
	UIWidgetBelowMinimapContainerFrame:SetPoint('TOP', 0, -60)


	-- Create Backdrops
	for i=1, 10 do
		ChatTabStyler(_G['ChatFrame' .. i], i)
	end

	-- Run the check on all of these events.
	local Monitor = CreateFrame('Frame', 'RFM_Monitor')
	Monitor:RegisterEvent('PLAYER_ENTERING_WORLD')
	Monitor:RegisterEvent('PLAYER_REGEN_DISABLED')
	Monitor:RegisterEvent('PLAYER_REGEN_ENABLED')
	Monitor:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	Monitor:RegisterEvent('GROUP_ROSTER_UPDATE')
	Monitor:RegisterEvent('ADDON_LOADED')
	Monitor:SetScript('OnEvent', Hider)
	RFM.Monitor = Monitor

	C_Timer.After(5, TSM_PopupHider)
	RFM:PlaceChat()

	MyCvars()
end