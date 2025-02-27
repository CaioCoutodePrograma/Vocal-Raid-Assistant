local _, addon = ...
local L = addon.L

local intendedWoWProject = WOW_PROJECT_MAINLINE

--[===[@non-version-retail@
--@version-classic@
intendedWoWProject = WOW_PROJECT_CLASSIC
--@end-version-classic@
--@version-bcc@
intendedWoWProject = WOW_PROJECT_BURNING_CRUSADE_CLASSIC or WOW_PROJECT_MAINLINE
--@end-version-bcc@
--@end-non-version-retail@]===]

function addon:IsClassic()
  return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function addon:IsBCC()
  return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end

function addon:IsRetail()
  return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

function addon:IsCorrectVersion()
  return intendedWoWProject == WOW_PROJECT_ID
end

function addon:prettyPrint(...)
  print("|c00ff0000Vocal Raid Assistant:|r ", ...)
end

local intendedWoWProjectName = {
  [WOW_PROJECT_MAINLINE] = "Retail",
  [WOW_PROJECT_CLASSIC] = "Classic",
  [WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5] = "The Burning Crusade Classic"
}

function addon:ErrorPlayer(spellID, channel, isTest)
	local cvarName ='Sound_Enable'..(channel == "Sound" and 'SFX' or channel)
	if GetCVar("Sound_EnableAllSound") == "0" then
		if isTest then
			errorMsg = format('Can not play sounds, your gamesound (Master channel) is disabled')
		end
	elseif GetCVar(cvarName) == "0" then
		if isTest then
			errorMsg = format("Can not play sounds, you configured VRA to play sounds via channel \"%s\", but %s channel is disabled.", channel, channel)
		end
	else
		errorMsg = format("Missing soundfile for configured spell: %s, Voice Pack: %s", GetSpellInfo(spellID) or spellID, addon.profile.sound.soundpack)
	end
	return errorMsg
end

local wrongTargetMessage = "This version of VRA was packaged for World of Warcraft " .. intendedWoWProjectName[intendedWoWProject] ..
                              ". Please install the " .. intendedWoWProjectName[WOW_PROJECT_ID] ..
                              " version instead.\nIf you are using an addon manager, then" ..
                              " contact their support for further assistance and reinstall VRA manually."

if not addon.IsCorrectVersion() then --Wait 10 seconds then error message
  C_Timer.After(10, function() addon:prettyPrint(wrongTargetMessage) end)
end