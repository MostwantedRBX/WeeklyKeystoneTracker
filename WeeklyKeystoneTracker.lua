print("WeeklyKeystoneTracker Starting")

-- Returns an ItemLink for a mythic keystone if a player has one in their inventory.
-- Returns nil otherwise.
-- Example: |cffa335ee|Hkeystone:180653:382:6:10:11:0:0|h[Keystone: Theater of Pain (6)]|h|r
local function searchForKey()
	print("searchForKey() running")
	for bag = 0, 4, 1 do
		local slotsInBag = GetContainerNumSlots(bag)
		if slotsInBag then
			for slot = 1, slotsInBag, 1 do
				if GetContainerItemID(bag, slot) == 180653 then
					-- debug
					print('Bag: ' .. bag .. '\nSlots in bag: ' ..slotsInBag .. '\nSlot Key is in: ' .. slot)
					-- end of debug
					linkToKey = GetContainerItemLink(bag, slot)
					return linkToKey
				end
			end
		end
	end
end


local function extrapolateKey(link)
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

	local key = searchForKey()
	local instanceId = string.find(key, ":%d%d%d:")
	-- can use substring since we know they are constants probably,
	-- or colon delimeters rather than string.find
end

local function eventHandler(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then 
		-- just in case
		elseif event == "ADDON_LOADED" then
		-- checks to see if you have saved variables
			if not WEEKLYKEYSTONETRACKER then
				WEEKLYKEYSTONETRACKER = {}
				print("setting variable")
			end
		
		if WEEKLYKEYSTONETRACKER then
			-- OpenAllBags() -- this probably needs to not be here because it messes with Bagnon
			print(string.find(searchForKey(), ":%d%d%d:"))
			-- List of InstanceIDs
			WEEKLYKEYSTONETRACKER.DungeonNames = {
				[378] = "HOA",  -- Halls of Atonement
				[381] = "SOA",  -- Spires of Ascension
				[382] = "TOP",  -- Theater of Pain
				[380] = "SD",   -- Sanguine Depths
				[376] = "WAKE", -- The Necrotic Wake
				[379] = "PF",   -- Plaguefall
				[377] = "DOS",  -- De Other Side
				[375] = "MISTS" -- Mists of Tirna Scithe
			}
		end
	end
end

local eventFrame = CreateFrame("FRAME","WeeklyKeystoneTracker")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:SetScript("OnEvent", eventHandler)