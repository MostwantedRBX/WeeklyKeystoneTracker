--print("WeeklyKeystoneTracker Starting...")

-- Returns an ItemLink for a mythic keystone if a player has one in their inventory.
-- Returns nil otherwise.
-- Example: [Keystone: Theater of Pain (6)]
local function searchForKey()
	for bag = 0, 4, 1 do
		local slotsInBag = GetContainerNumSlots(bag)
		if slotsInBag then
			for slot = 1, slotsInBag, 1 do
				if GetContainerItemID(bag, slot) == 180653 then
					--print('Bag: ' .. bag .. '\nSlots in bag: ' ..slotsInBag .. '\nSlot Key is in: ' .. slot)
					local linkToKey = GetContainerItemLink(bag, slot)
					return linkToKey
				end
			end
		end
	end
end

-- Separates the key with colons as the delimeter and stores it in a table
-- Returns: a table with the individual parts of the key separated by the
--          delimeter specified, otherwise defaults to a colon (:)
local function splitKey (keyCode, delimeter)
	print("splitting key")
	if delimeter == nil then
		delimeter = ":"
	end

	local t = {}
	for str in string.gmatch(keyCode, "([^" .. delimeter .. "]+)") do
		--print(str)
		table.insert(t, str)
	end
	return t
end

-- Takes the keyLink provided and extracts the information from it
-- Example: |cffa335ee|Hkeystone:180653:382:6:10:11:0:0|h[Keystone: Theater of Pain (6)]|h|r

	-- working on this, next, %d is digits in a pattern

	-- Item Code: |cffa335ee|Hkeystone:180653:382:6:10:11:0:0|h[Keystone: Theater of Pain (6)]|h|r
	-- |cffa335ee 						= color information
	-- |H								= hyperlink information start
	-- keystone:180653:382:6:10:11:0:0 	= item information
		-- :180653							= item id (mythic keystone)
		-- :382								= dungeon/instance ID
		-- :6								= key level
		-- :10:11:0:0						= modifiers (assumed)
	-- |h 								= End of link, text follows
	-- [Keystone: Theater of Pain (6)] 	= actual display text
	-- |h 								= end of hyperlink
	-- |r								= restore color to normal
local function extrapolateKey(linkToKey)
	-- obtaining the key from player's bags
	if linkToKey then
		-- turn the link into values that we can read and split it
		local keyCode = gsub(linkToKey, "\124", "\124\124");
		local keyInfo = splitKey(keyCode, ":")

		-- assign the values to their variables
		local instanceID = tonumber(keyInfo[3])
		local keyLevel = tonumber(keyInfo[4])
		local modifier1 = tonumber(keyInfo[5])
		local modifier2 = tonumber(keyInfo[6])
		local modifier3 = tonumber(keyInfo[7])
		local modifier4 = tonumber(strsub(keyInfo[8], 0, 2))

		-- in case modifier4 is nil we need to fix that
		-- only in effect in keyLevel < 10
		if modifier4 == nil then
			modifier4 = tonumber(strsub(keyInfo[8], 0, 1))
		end
	end
end

-- handles any events that were registered to our EventFrame
-- events handled:
	-- PLAYER_LOGIN
	-- ADDON_LOADED
	-- CHALLENGE_MODE_COMPLETED
	-- BAG_UPDATE
local function eventHandler(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		-- First-time setup
		if not WEEKLYKEYSTONETRACKER_GLOBAL then
			-- Start allocating stored variables upon first use.
			-- Initializing some default values.
			WEEKLYKEYSTONETRACKER_GLOBAL = {}
			WEEKLYKEYSTONETRACKER_GLOBAL.Characters = {}
			-- List of InstanceIDs
			WEEKLYKEYSTONETRACKER_GLOBAL.DungeonNames = {
				MISTS = 375, -- Mists of Tirna Scithe
				WAKE = 376,  -- The Necrotic Wake
				DOS = 377,   -- De Other Side
				HOA = 378,   -- Halls of Atonement
				PF = 379,    -- Plaguefall
				SD = 380,    -- Sanguine Depths
				SOA = 381,   -- Spires of Ascension
				TOP = 382,   -- Theater of Pain
			}
		end

		if not WEEKLYKEYSTONETRACKER_CHARACTER then
			-- Per-character settings first time
			WEEKLYKEYSTONETRACKER_CHARACTER = {}

			WEEKLYKEYSTONETRACKER_CHARACTER.Character = UnitName("player")
		end

		-- End of first-time setup
		
		-- If this isn't the first login, we want to...
		-- Store the player's current Keystone Information
		-- 

		-- End of PLAYER_LOGIN event
	elseif event == "CHALLENGE_MODE_COMPLETED" then
		print("Challenge mode completed!")
		-- End of CHALLENGE_MODE_COMPLETED event
	elseif event == "CHALLENGE_MODE_START" then
		print("Challenge mode started!")
		local mapChallengeModeID = C_ChallengeMode.GetActiveChallengeMapID()
		local activeKeystoneLevel, activeAffixIDs, wasActiveKeystoneCharged = C_ChallengeMode.GetActiveKeystoneInfo()
		local challengeModeActive = C_ChallengeMode.IsChallengeModeActive()

		SendChatMessage("Challenge Mode Starting! Get ready.", "PARTY", "Common");
		SendChatMessage("Dungeon: " .. mapChallengeModeID, "Whisper", "Common", "Jayisapriest");
		SendChatMessage("Key Level: " .. activeKeystoneLevel, "Whisper", "Common", "Jayisapriest");
		SendChatMessage("activeAffixIDs: " .. activeAffixIDs, "Whisper", "Common", "Jayisapriest");
		SendChatMessage("wasActiveKeystoneCharged: " .. wasActiveKeystoneCharged, "Whisper", "Common", "Jayisapriest");
		SendChatMessage("challengeModeActive: " .. challengeModeActive, "Whisper", "Common", "Jayisapriest");



		-- End of CHALLENGE_MODE_COMPLETED event
	elseif event == "BAG_UPDATE" then
		print("Bag updated.")
		local mapChallengeModeID, level, time, onTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo()

	end
end

local EventFrame = CreateFrame("frame","EventFrame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
EventFrame:RegisterEvent("CHALLENGE_MODE_START")
EventFrame:RegisterEvent("BAG_UPDATE")
EventFrame:SetScript("OnEvent", eventHandler)
