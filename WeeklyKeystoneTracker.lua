
--
print("Hello, World")
OpenAllBags()

 local function searchForKey()
  print("logging")
  for i=0,4 do
     local slots = GetContainerNumSlots(i)
    if slots then
      for s=1,slots do
        if GetContainerItemID(i,s) == 180653 then
          print('Bag: '..i..'Slots in bag: '..slots ..'Slot Key is in: '.. s)
          print("key found")
          return i,s
        end
        s=s+1
      end
    end
    i=i+1
  end
end


local function eventHandler(self,event,arg1)
  if event == "PLAYER_ENTERING_WORLD" then
    OpenAllBags()
    local bag, slot = searchForKey()
    print(string.find(GetContainerItemLink(bag,slot),"Spires of Ascension"))
  elseif event == "ADDON_LOADED" then
    if not WEEKLYKEYSTONETRACKER_KEY then
      WEEKLYKEYSTONETRACKER_KEY = {}
      WEEKLYKEYSTONETRACKER_KEY.taco = "Taco"
      print("setting variable")
    elseif WEEKLYKEYSTONETRACKER_KEY then
      print(WEEKLYKEYSTONETRACKER_KEY.taco)
    end
  end
end


local frame = CreateFrame("FRAME","WeeklyKeystoneTracker")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")
print("frame registered")
frame:SetScript("OnEvent", eventHandler)
