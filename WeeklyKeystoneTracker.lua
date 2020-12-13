
--
print("WeeklyKeystoneTracker Starting")

 local function searchForKey()
  print("searchForKey() running")
  for i=0,4 do
     local slots = GetContainerNumSlots(i)
    if slots then
      for s=1,slots do
        if GetContainerItemID(i,s) == 180653 then
          --debug
          print('Bag: '..i..'Slots in bag: '..slots ..'Slot Key is in: '.. s)
          print("key found")
          --end of debug
          link = GetContainerItemLink(i,s)
          return link
        end
        s=s+1
      end
    end
    i=i+1
  end
end
--29
local function extrapolateKey(link)
  --[[working on this, next, %d is digits in a pattern
  This below is the item code you get from GetContainerItemLink() that I'm trying to get the
  instance id from
  |cffa335ee|Hkeystone:180653:382:6:10:11:0:0|h[Keystone: Theater of Pain (6)]|h|r"
  ]]
  local key = searchForKey()
  local instanceId = string.find(key,":%d%d%d:")
end

local function eventHandler(self,event,arg1)
  if event == "PLAYER_ENTERING_WORLD" then
    --just in case
  elseif event == "ADDON_LOADED" then
    --checks to see if you have saved variables
    if not WEEKLYKEYSTONETRACKER then
      WEEKLYKEYSTONETRACKER = {}
      print("setting variable")
    end
    if WEEKLYKEYSTONETRACKER then
      OpenAllBags()
      print(string.find(searchForKey(),":%d%d%d:"))
      --List of InstanceIDs
      WEEKLYKEYSTONETRACKER.DungeonNames = {
        [378] = "HOA",
        [381] = "SOA",
        [382] = "TOP",
        [380] = "SD",
        [376] = "WAKE",
        [379] = "PF",
        [377] = "DOS",
        [375] = "MISTS"
      }
      --testing the table of names
      print(WEEKLYKEYSTONETRACKER.DungeonNames[378])
    end
  end
end


local frame = CreateFrame("FRAME","WeeklyKeystoneTracker")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", eventHandler)
