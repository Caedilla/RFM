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

local function UpdateDataTexts()
	if _G['SavedInstances_DataText1'] then
		if _G['SavedInstances_DataText1'].text then
			_G['SavedInstances_DataText1'].text:SetText('Lockouts')
		end
	end
end

local function TSM_PopupHider()
	StaticPopup_Hide('TSM_APP_DATA_ERROR')
end

local function Hider()
	if InCombatLockdown() then
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

		UpdateDataTexts()
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
	--[[local currentResolution = ({GetScreenResolutions()})[GetCurrentResolution()]
	currentResolution = string.sub(currentResolution, 6)
	currentResolution = tonumber(currentResolution)
	if 768/currentResolution >= 0.64 then
		SetCVar('useUiScale', false)
		UIParent:SetScale(768/currentResolution)
	else
		SetCVar('useUiScale', false)
		SetCVar('uiScale', 768/currentResolution)
	end]]--

		SetCVar('useUiScale', false)
		UIParent:SetScale(768/1440)


	do -- Nameplates
		SetCVar('nameplateOverlapH', 0.6)
		SetCVar('nameplateOverlapV', 0.6)
		SetCVar('nameplateShowAll', 1) -- Always show nameplates, rather than just in combat.
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
		SetCVar('nameplateMotion', 1) -- Stacking at 1, overlapping at 0.
		SetCVar('nameplateShowEnemyGuardians', 1)
		SetCVar('nameplateShowEnemyMinions', 1)
		SetCVar('nameplateShowEnemyMinus', 1)
		SetCVar('nameplateShowEnemyPets', 1)
		SetCVar('nameplateShowEnemyTotems', 1)
		SetCVar('nameplateTargetRadialPosition', 1) -- Target Nameplate stays on screen when the unit is offscreen.
		SetCVar('nameplateOverlapH', 0.6)
		SetCVar('nameplateOverlapH', 0.6)
	end

	do -- Sound
		SetCVar('Sound_MasterVolume', 0.1)
		SetCVar('Sound_DialogVolume', 1.0)
		SetCVar('Sound_MusicVolume', 0.2)
		SetCVar('Sound_AmbienceVolume', 0.2)
		SetCVar('Sound_SFXVolume', 0.2)
		SetCVar('Sound_ZoneMusicNoDelay', 1)
		SetCVar('Sound_EnableSoundWhenGameIsInBG', 1)
		SetCVar('Sound_EnableErrorSpeech', 0)
	end

	do -- Normal World Graphics
		SetCVar('componentTextureLevel', 0) -- Character Model Texture level. 0 highest, 2 lowest.
		SetCVar('doodadLodDist', 300) -- 150 Default.
		SetCVar('EmitterCombatRange', 1200) -- Weapon / Shoulder Glows
		SetCVar('NonEmitterCombatRange', 6400)
		SetCVar('entityShadowFadeScale', 100)
		SetCVar('entityLodDist', 10) -- No idea, default 10.
		SetCVar('entityLodOffset', 25) -- No idea, default 10. Either of these entityLod settings being higher fixes double pig tail blood elf hair from sticking out when zoomed out.
		SetCVar('groundEffectDensity', 128)
		SetCVar('groundEffectDist', 256) -- 500 Max
		SetCVar('groundEffectFade', 128)
		SetCVar('gxMaxFrameLatency', 3)
		SetCVar('horizonStart', 5000) -- Maximum visible distance. 5000 Max farclip beyond that is always foggy.
		SetCVar('farclip', 8000) -- Maximum view distance of terrain in fog
		SetCVar('ffxAntiAliasingMode', 3) -- CMAA
		SetCVar('lodObjectCullDist', 100) -- Distance to stop drawing lod objects. Default 30.
		SetCVar('lodObjectCullSize', 30) -- size of objects to cull. Default 15. Higher = Bigger objects get culled at distance.
		SetCVar('lodObjectFadeScale', 75) -- Default 100.
		SetCVar('lodObjectMinSize', 10) -- Default 20.
		SetCVar('M2ForceAdditiveParticleSort', 1) -- Not sure, glowy shit?
		SetCVar('M2UseThreads', 1)
		SetCVar('maxFPS', 144)
		SetCVar('maxFPSBk', 30)
		SetCVar('maxFPSLoading', 15)
		SetCVar('targetFPS', 0)
		SetCVar('MSAAAlphaTest', 1)
		SetCVar('MSAAQuality', 2, 0) -- 2, 0
		SetCVar('occlusionMaxJobs', 6) -- Occlusion threads? Default 3
		SetCVar('particleDensity', 100) -- Particle Density
		SetCVar('particleMTDensity', 50) -- Particle Density for Multi-threaded particles. 100 Max.
		SetCVar('projectedTextures', 1)
		SetCVar('reflectionDownscale', 1) -- Downscale slightly, at 0 the reflections look too crisp.
		SetCVar('reflectionMode', 3) -- Reflect everything possible. Default 3
		SetCVar('rippleDetail', 2)
		SetCVar('shadowMode', 3)
		SetCVar('shadowSoft', 1) -- Soft Blurred Edge shadows.
		SetCVar('shadowTextureSize', 1024) -- With Soft shadows there is no need for higher resolution shadows.
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
		SetCVar('useHighResolutionUITextures', 1)
		SetCVar('waterDetail', 2) -- Actually looks better than 3 since the reflection warps a little over the water.
		SetCVar('wmoDoodadDist', 2000)
		SetCVar('wmoLodDist', 1000)
		SetCVar('volumeFog', 1)
		SetCVar('volumeFogLevel', 3)
		SetCVar('spellClutter', -1) -- -1 Default
		SetCVar('TerrainLodDiv', 64) -- 768 Default
		SetCVar('TerrainLodDist', 768) -- 400 Default
		SetCVar('maxLightCount', 32)
		SetCVar('shadowRt', 3)
	end
	do -- Raid Specific Graphics
		SetCVar('RAIDsettingsEnabled', 1)
		SetCVar('RAIDcomponentTextureLevel', 0)
		SetCVar('RAIDentityShadowFadeScale', 10)
		SetCVar('RAIDgroundEffectDensity', 64)
		SetCVar('RAIDgroundEffectDist', 32)
		SetCVar('RAIDhorizonStart', 600)
		SetCVar('RAIDfarclip', 600)
		SetCVar('RAIDhorizonClip', 600)
		SetCVar('RAIDlodObjectCullDist', 50)
		SetCVar('RAIDlodObjectCullSize', 25)
		SetCVar('RAIDlodObjectFadeScale', 50)
		SetCVar('RAIDlodObjectMinSize', 10)
		SetCVar('RAIDparticleDensity', 25)
		SetCVar('RAIDparticleMTDensity', 50)
		SetCVar('RAIDreflectionMode', 2)
		SetCVar('RAIDrippleDetail', 0)
		SetCVar('RAIDshadowSoft', 1)
		SetCVar('RAIDshadowMode', 2)
		SetCVar('RAIDshadowTextureSize', 512)
		SetCVar('RAIDSSAO', 0)
		SetCVar('RAIDwaterDetail', 1)
		SetCVar('RAIDwmoLodDist', 200)
		SetCVar('RAIDTerrainLodDiv', 64) -- 768 Default
		SetCVar('RAIDTerrainLodDist', 128) -- 400 Default
		SetCVar('RAIDshadowRt', 0)
		SetCVar('RAIDvolumeFogLevel', 0)
		SetCVar('RAIDshadowMode', 1)
		SetCVar('RAIDshadowSoft', 1) -- Soft Blurred Edge shadows.
		SetCVar('RAIDshadowTextureSize', 1024) -- With Soft shadows there is no need for higher resolution shadows.
		SetCVar('RAIDspellClutter', 100)
	end

	do -- Camera stuff
		if RFM.Client == 1 then -- Maximum Camera Range is higher in Classic
			SetCVar('cameraDistanceMaxZoomFactor', 2.6)
		else
			SetCVar('cameraDistanceMaxZoomFactor', 4)
		end
		SetCVar('cameraSmooth', 0)
		SetCVar('cameraYawMoveSpeed', 120) -- Slow horizontal camera rotation. Default 180.
		SetCVar('cameraZoomSpeed', 25)
		SetCVar('ShakeStrengthCamera', 0)
		SetCVar('ShakeStrengthUI', 0)
		SetCVar('cameraSmoothStyle', 0)
		SetCVar('cameraSmoothTrackingStyle', 0)
		SetCVar('CameraReduceUnexpectedMovement', 1)
	end

	do -- Mouse Stuff
		SetCVar('rawMouseAccelerationEnable', 0)
		SetCVar('rawMouseEnable', 1)
		SetCVar('rawMouseRate', 1000) -- Default 125. Polling Rate?
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
		SetCVar('autoLootRate', 25) -- Faster Auto Loot
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
		SetCVar('screenshotFormat', 'png')
		SetCVar('showSpenderFeedback', 0)
		SetCVar('showTamers', 0)
		SetCVar('showToastOffline', 0)
		SetCVar('showToastOnline', 1)
		SetCVar('skipStartGear', 1)
		SetCVar('spellQueueWindow', 200)
		SetCVar('TargetPriorityCombatLock', 1)
		SetCVar('UberTooltips', 1)
		SetCVar('minimapAltitudeHintMode', 2) --Change minimap altitude difference display. 0=none, 1=darken, 2=arrows
		SetCVar('calendarShowResets', 1)
		SetCVar('streamStatusMessage', 1)
		SetCVar('secureAbilityToggle', 1)
		SetCVar('advancedCombatLogging', 1)
		SetCVar('autoStand', 0)
		SetCVar('disableAELooting', 0)
		SetCVar('removeChatDelay', 1)
		SetCVar('whisperMode', 'inline')
		SetCVar('fstack_showhidden', 0)
		SetCVar('blockChannelInvites', 1)
		SetCVar('AutoPushSpellToActionBar', 0)
		SetCVar('displaySpellActivationOverlays', 0)
		SetCVar('spellActivationOverlayOpacity', 0)
		SetCVar('showTutorials',0)
	end

	do -- Combat Text
		SetCVar('floatingCombatTextCombatHealing', 1)
		SetCVar('floatingCombatTextCombatDamage', 1)
		SetCVar('floatingCombatTextPetMeleeDamage', 1)
		SetCVar('floatingCombatTextPetSpellDamage', 1)
		SetCVar('floatingCombatTextCombatLogPeriodicSpells', 1)
		SetCVar('WorldTextScale', 1.5)
		SetCVar('WorldTextGravity', 1)
		SetCVar('WorldTextRandomXY', 0.5)
		SetCVar('WorldTextRandomXY', 0.5)
		SetCVar('WorldTextRandomXY', 0.5)
		SetCVar('WorldTextRampPow', 20)
		SetCVar('WorldTextRampPowCrit', 10)
		SetCVar('WorldTextRampDuration', 2.5)
		SetCVar('WorldTextStartPosRandomness', 10)
		SetCVar('WorldTextCritScreenY', -0.0275)
	end

end

local function PlaceChat()
	local chat = _G['ChatFrame1']
	chat:ClearAllPoints()
	chat:SetPoint('BOTTOMRIGHT', -30, 14)
	chat:SetWidth(424)
	chat:SetHeight(190)
end

local function ChatTabStyler(frame, i)
	local BlizzardFrame = frame
	local BlizzardBackground = _G[frame:GetName() .. 'Background']
	local BlizzardTabText = _G[frame:GetName() .. 'TabText']
	local name = 'RFM_Chat'
	local Chat = CreateFrame('Frame', name .. i, BlizzardFrame, BackdropTemplateMixin and "BackdropTemplate")
	local Background = Chat:CreateTexture(name .. i .. 'Background', 'BACKGROUND')

	BlizzardFrame:SetShadowColor(0, 0, 0, 0)
	BlizzardFrame:SetClampRectInsets(0, 0, 0, 0)
	local font = LSM:Fetch('font', 'PT Sans Narrow Bold')
	BlizzardFrame:SetFont(font, 16, 'OUTLINE')

	Chat:SetBackdrop(cfg.Border)
	Chat:SetBackdropBorderColor(0, 0, 0, 1)
	Chat:SetFrameLevel(0)
	Chat:SetPoint('TOPLEFT', BlizzardBackground, -2, 4)
	Chat:SetPoint('BOTTOMRIGHT', BlizzardBackground, 2, -4)
	Background:SetAllPoints(Chat)
	Background:SetTexture(LSM:Fetch('background', 'Solid'))
	Background:SetVertexColor(0, 0, 0, 0.5)
	--BlizzardTabText:SetWidth(BlizzardTabText:GetStringWidth()+2)
	--BlizzardTabText:SetHeight(BlizzardTabText:GetStringHeight()+2)
	font = LSM:Fetch('font', 'RUF')
	--BlizzardTabText:SetFont(font, 20, 'OUTLINE')
	--BlizzardTabText:SetText(BlizzardTabText:GetText():upper())

	local tabs = {
		'Left',
		'Middle',
		'Right',
		'HighlightLeft',
		'HighlightMiddle',
		'HighlightRight',
		'SelectedLeft',
		'SelectedMiddle',
		'SelectedRight',
	}

	for k,v in pairs(tabs) do
		local BlizzardTab = _G[frame:GetName() .. 'Tab' .. v]
		--BlizzardTab:SetAlpha(0)
		--BlizzardTab:SetIgnoreParentAlpha(true)
	end

end

local function MoveGeneralDockManager()
	local dock = _G['GeneralDockManager']

	dock:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -4, 0)
	dock:SetPoint('BOTTOMRIGHT', ChatFrame1, 'TOPRIGHT', 0, 0)
end

local function StyleFont(obj, font, size, flags, sr, sg, sb, sa, sox, soy, r, g, b)
	if not obj then return end
	obj:SetFont(font, size, flags)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb, sa) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

local function SkadaStyler()
	local skada = _G['SkadaBarWindow1']
	local frame = CreateFrame('frame', 'RFM_SkadaStyler', skada, BackdropTemplateMixin and "BackdropTemplate")
	local background = frame:CreateTexture('RFM_SkadaStylerBackground', 'BACKGROUND')

	frame:SetBackdrop(cfg.Border)
	frame:SetBackdropBorderColor(0, 0, 0, 1)
	frame:SetFrameLevel(0)

	local skada2 = _G['SkadaBarWindow2']
	frame:SetPoint('TOPLEFT', skada, -1, 1)
	frame:SetPoint('BOTTOMRIGHT', skada2, 1, 4)

	background:SetAllPoints(frame)
	background:SetTexture(LSM:Fetch('background', 'Solid'))
	background:SetVertexColor(0, 0, 0, 0.5)

	frame:SetParent(skada)
end

local function FontStyler()
	local NORMAL		= LSM:Fetch('font', 'PT Sans Narrow Bold')
	local NUMBER		= LSM:Fetch('font', 'PT Sans Narrow Bold')
	local COMBAT		= LSM:Fetch('font', 'PT Sans Narrow Bold')
	local NAMEFONT		= LSM:Fetch('font', 'PT Sans Narrow Bold')
	local BUBBLE		= LSM:Fetch('font', 'PT Sans Narrow Bold')
	local NORMALSIZE	= 14
	local NORMALOFFSET	= 1
	local BIGOFFSET		= 1
	local OUTLINE		= 'Outline'

	--_G.CHAT_FONT_HEIGHTS = {6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	--_G.NAMEPLATE_FONT		= NAMEFONT
	_G.UNIT_NAME_FONT		= NAMEFONT
	_G.DAMAGE_TEXT_FONT		= COMBAT
	_G.STANDARD_TEXT_FONT	= NORMAL

	StyleFont(_G.AchievementFont_Small,NORMAL, NORMALSIZE, '') -- Achiev dates
	StyleFont(_G.BossEmoteNormalHuge,NORMAL, 24, '') -- Talent Title
	StyleFont(_G.ChatBubbleFont,BUBBLE, NORMALSIZE, OUTLINE)
	StyleFont(_G.CoreAbilityFont,NORMAL, 26, '') -- Core abilities(title)
	StyleFont(_G.DestinyFontHuge,NORMAL, 32, '', 0,0,0,0, BIGOFFSET) -- Garrison Mission Report
	StyleFont(_G.DestinyFontMed,NORMAL, 14, '') -- Added in 7.3.5 used for ?
	StyleFont(_G.Fancy12Font,NORMAL, 12, '') -- Added in 7.3.5 used for ?
	StyleFont(_G.Fancy14Font,NORMAL, 14, '') -- Added in 7.3.5 used for ?
	StyleFont(_G.Fancy22Font,NORMAL, 20, '') -- Talking frame Title font
	StyleFont(_G.Fancy24Font,NORMAL, 20, '') -- Artifact frame - weapon name
	StyleFont(_G.FriendsFont_Large,NORMAL, NORMALSIZE, '')
	StyleFont(_G.FriendsFont_Normal,NORMAL, NORMALSIZE, '')
	StyleFont(_G.FriendsFont_Small,NORMAL, NORMALSIZE, '')
	StyleFont(_G.FriendsFont_UserText,NORMAL, NORMALSIZE, '')
	StyleFont(_G.Game12Font,NORMAL, 12, '') -- PVP Stuff
	StyleFont(_G.Game13FontShadow,NORMAL, 14, OUTLINE, '') -- InspectPvpFrame
	StyleFont(_G.Game15Font_o1,NORMAL, 24, OUTLINE, '') -- CharacterStatsPane (ItemLevelFrame)
	StyleFont(_G.Game16Font,NORMAL, 16, OUTLINE, '') -- Added in 7.3.5 used for ?
	StyleFont(_G.Game18Font,NORMAL, 18, OUTLINE, '') -- MissionUI Bonus Chance
	StyleFont(_G.Game24Font, NORMAL, 24, OUTLINE, '') -- Garrison Mission level (in detail frame)
	StyleFont(_G.Game30Font,NORMAL, 30, OUTLINE, '') -- Mission Level
	StyleFont(_G.Game42Font,NORMAL, 42, OUTLINE, '') -- PVP Stuff
	StyleFont(_G.Game46Font,NORMAL, 46, OUTLINE, '') -- Added in 7.3.5 used for ?
	StyleFont(_G.Game48Font,NORMAL, 48, OUTLINE, '')
	StyleFont(_G.Game48FontShadow,NORMAL, 48, '', 0,0,0,0, BIGOFFSET)
	StyleFont(_G.Game60Font,NORMAL, 60, '')
	StyleFont(_G.Game72Font,NORMAL, 72, '')
	StyleFont(_G.Game120Font,NORMAL, 120, '')
	StyleFont(_G.GameFont_Gigantic,NORMAL, 32, '', 0,0,0,0, BIGOFFSET) -- Used at the install steps
	StyleFont(_G.GameFontHighlightMedium,NORMAL, 15, OUTLINE) -- Fix QuestLog Title mouseover
	StyleFont(_G.GameFontHighlightSmall2,NORMAL, NORMALSIZE, '') -- Skill or Recipe description on TradeSkill frame
	StyleFont(_G.GameFontNormalHuge2,NORMAL, 24, OUTLINE) -- Mythic weekly best dungeon name
	StyleFont(_G.GameFontNormalLarge2,NORMAL, 15, OUTLINE) -- Garrison Follower Names
	StyleFont(_G.GameFontNormalMed2,NORMAL, NORMALSIZE*1.1, '') -- Quest tracker
	StyleFont(_G.GameFontNormalMed3,NORMAL, 15, OUTLINE)
	StyleFont(_G.GameFontNormalSmall2,NORMAL, 12, OUTLINE) -- MissionUI Followers names
	StyleFont(_G.GameTooltipHeader,NORMAL, NORMALSIZE, '')
	StyleFont(_G.InvoiceFont_Med,NORMAL, 12, '') -- Mail
	StyleFont(_G.InvoiceFont_Small,NORMAL, NORMALSIZE, '') -- Mail
	StyleFont(_G.MailFont_Large,NORMAL, 14, '') -- Mail
	StyleFont(_G.NumberFont_Outline_Huge,NUMBER, 28, 'THICKOUTLINE', 28)
	StyleFont(_G.NumberFont_Outline_Large,NUMBER, 15, 'OUTLINE')
	StyleFont(_G.NumberFont_Outline_Med,NUMBER, NORMALSIZE*1.1, 'OUTLINE')
	StyleFont(_G.NumberFont_OutlineThick_Mono_Small,NUMBER, NORMALSIZE, 'OUTLINE')
	StyleFont(_G.NumberFont_Shadow_Med,NORMAL, NORMALSIZE, '') -- Chat EditBox
	StyleFont(_G.NumberFont_Shadow_Small,NORMAL, NORMALSIZE, '')
	StyleFont(_G.NumberFontNormalSmall,NORMAL, 11, 'OUTLINE') -- Calendar, EncounterJournal
	StyleFont(_G.Number11Font,NORMAL, 11, '')
	StyleFont(_G.Number12Font,NORMAL, 12, '')
	StyleFont(_G.Number15Font,NORMAL, 15, '')
	StyleFont(_G.PriceFont,NORMAL, 13, '')
	StyleFont(_G.PVPArenaTextString,NORMAL, 22, 'OUTLINE')
	StyleFont(_G.PVPInfoTextString,NORMAL, 22, 'OUTLINE')
	StyleFont(_G.QuestFont,NORMAL, NORMALSIZE, '')
	StyleFont(_G.QuestFont_Enormous, NORMAL, 24, '', 0,0,0,0, NORMALOFFSET) -- Garrison Titles
	StyleFont(_G.QuestFont_Huge,NORMAL, 15, '', 0,0,0,0, BIGOFFSET) -- Quest rewards title(Rewards)
	StyleFont(_G.QuestFont_Large,NORMAL, 14)
	StyleFont(_G.QuestFont_Shadow_Huge,NORMAL, 15, '', 0,0,0,0, NORMALOFFSET) -- Quest Title
	StyleFont(_G.QuestFont_Shadow_Small,NORMAL, 14, '', 0,0,0,0, NORMALOFFSET)
	StyleFont(_G.QuestFont_Super_Huge,NORMAL, 22, '', 0,0,0,0, BIGOFFSET)
	StyleFont(_G.ReputationDetailFont,NORMAL, NORMALSIZE, '') -- Rep Desc when clicking a rep
	StyleFont(_G.SubZoneTextFont,NORMAL, 24, 'OUTLINE') -- World Map(SubZone)
	StyleFont(_G.SubZoneTextString,NORMAL, 25, 'OUTLINE')
	StyleFont(_G.SystemFont_Huge1, NORMAL, 20, '') -- Garrison Mission XP
	StyleFont(_G.SystemFont_Huge1_Outline, NORMAL, 18, 'OUTLINE') -- Garrison Mission Chance
	StyleFont(_G.SystemFont_Large,NORMAL, 15, '')
	StyleFont(_G.SystemFont_Med1,NORMAL, NORMALSIZE, '')
	StyleFont(_G.SystemFont_Med3,NORMAL, NORMALSIZE*1.1, '')
	StyleFont(_G.SystemFont_Outline,NORMAL, 13, 'OUTLINE') -- Pet level on World map
	StyleFont(_G.SystemFont_Outline_Small,NUMBER, NORMALSIZE, 'OUTLINE')
	StyleFont(_G.SystemFont_OutlineThick_Huge2,NORMAL, 20, 'THICKOUTLINE')
	StyleFont(_G.SystemFont_OutlineThick_WTF,NORMAL, 32, 'OUTLINE') -- World Map
	StyleFont(_G.SystemFont_Shadow_Huge1,NORMAL, 20, 'OUTLINE') -- Raid Warning, Boss emote frame too
	StyleFont(_G.SystemFont_Shadow_Huge3,NORMAL, 22, '', 0,0,0,0, BIGOFFSET) -- FlightMap
	StyleFont(_G.SystemFont_Shadow_Large,NORMAL, 15, '')
	StyleFont(_G.SystemFont_Shadow_Large_Outline,NUMBER, 20, 'OUTLINE')
	StyleFont(_G.SystemFont_Shadow_Med1,NORMAL, NORMALSIZE, '')
	StyleFont(_G.SystemFont_Shadow_Med2,NORMAL, 13 * 1.1, '') -- Shows Order resourses on OrderHallTalentFrame
	StyleFont(_G.SystemFont_Shadow_Med3,NORMAL, 13 * 1.1, '')
	StyleFont(_G.SystemFont_Shadow_Med3,NORMAL, NORMALSIZE*1.1, '')
	StyleFont(_G.SystemFont_Shadow_Outline_Huge2,NORMAL, 20, 'OUTLINE')
	StyleFont(_G.SystemFont_Shadow_Small,NORMAL, NORMALSIZE*0.9, '')
	StyleFont(_G.SystemFont_Small,NORMAL, NORMALSIZE, '')
	StyleFont(_G.SystemFont_Tiny,NORMAL, NORMALSIZE, '')
	StyleFont(_G.Tooltip_Med,NORMAL, NORMALSIZE, '')
	StyleFont(_G.Tooltip_Small,NORMAL, NORMALSIZE, '')
	StyleFont(_G.ZoneTextString,NORMAL, 32, 'OUTLINE')
	StyleFont(_G.Game10Font_o1,NORMAL, 10, 'OUTLINE')
	StyleFont(_G.SystemFont_Shadow_Huge4,NORMAL, 27, '', nil, nil, nil, nil, 1, -1)
	StyleFont(_G.SystemFont_Shadow_Outline_Huge4,NORMAL, 27, 'OUTLINE', nil, nil, nil, nil, 1, -1)
	StyleFont(_G.Number11Font,NUMBER, 11, '')
	StyleFont(_G.Number12Font_o1,NUMBER, 12, 'OUTLINE')
	StyleFont(_G.Number13Font,NUMBER, 13, '')
	StyleFont(_G.Number13FontGray,NUMBER, 13, '')
	StyleFont(_G.Number13FontWhite,NUMBER, 13, OUTLINE)
	StyleFont(_G.Number13FontYellow,NUMBER, 13, OUTLINE)
	StyleFont(_G.Number14FontWhite,NUMBER, 14, OUTLINE)
	StyleFont(_G.Number18Font,NUMBER, 18, OUTLINE)
	StyleFont(_G.Number18FontWhite,NUMBER, 18, OUTLINE)
	StyleFont(_G.FriendsFont_11,NORMAL, 11, OUTLINE)
	StyleFont(_G.SpellFont_Small,NORMAL, 10, OUTLINE)
	StyleFont(_G.SubSpellFont,NORMAL, 11, OUTLINE) -- Spellbook Sub Names
end

local function SetScale()
	if InCombatLockdown() then C_Timer.After(5, SetScale) end
	if WorldMapFrame:GetEffectiveScale() ~= 0.75 then
		WorldMapFrame:SetScale(0.75 / WorldMapFrame:GetEffectiveScale())
		--WorldMapFrame.BorderFrame:SetScale(1)
		WorldMapFrameBg:Hide()
		WorldMapFrame.BorderFrame:Hide()
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x,y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local s = WorldMapFrame:GetScale()
			return x/s, y/s
		end
	end
end

function RFM:OnEnable()

	RFM.Client = 1
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		RFM.Client = 2
	end

	if RFM.Client == 1 then
	else
	end

	-- Move PVP Objective Score Down a bit.
	UIWidgetTopCenterContainerFrame:ClearAllPoints()
	UIWidgetTopCenterContainerFrame:SetPoint('TOP', 0, -30)

	UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
	UIWidgetBelowMinimapContainerFrame:SetPoint('TOP', 0, -60)

	-- Resize World Map to a better size
	SetScale()


	-- Create Backdrops
	--for i=1, 10 do
	--	ChatTabStyler(_G['ChatFrame' .. i], i)
	--end

	--ChatAlertFrame:ClearAllPoints()
	--ChatAlertFrame:SetPoint('BOTTOMLEFT','ChatFrame1ButtonFrame','BOTTOMLEFT',-400,200)

	-- Automatic Queue Accept
	--LFGListApplicationDialog:SetScript("OnShow", LFRAcceptRole)
	--LFDRoleCheckPopup:SetScript("OnShow", LFDAcceptRole)
	--LFGInvitePopup:SetScript("OnShow", LFGAcceptRole)

	-- Run the check on all of these events.
	local Monitor = CreateFrame('Frame', 'RFM_Monitor')
	--Monitor:RegisterEvent('PLAYER_ENTERING_WORLD')
	--Monitor:RegisterEvent('PLAYER_REGEN_DISABLED')
	--Monitor:RegisterEvent('PLAYER_REGEN_ENABLED')
	--Monitor:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	--Monitor:RegisterEvent('GROUP_ROSTER_UPDATE')
	--Monitor:RegisterEvent('ADDON_LOADED')
	--Monitor:SetScript('OnEvent', Hider)
	--RFM.Monitor = Monitor

	MyCvars()
	--C_Timer.After(5, FontStyler)
	--C_Timer.After(5, TSM_PopupHider)
	--C_Timer.After(5, UpdateDataTexts)
	--C_Timer.After(3, PlaceChat)
	--C_Timer.After(3, MoveGeneralDockManager)
	--C_Timer.After(3, SkadaStyler)
end

function RFM:OnInitialize()
	LSM:Register(SOUND,'MGS Alert', 1495882)
end