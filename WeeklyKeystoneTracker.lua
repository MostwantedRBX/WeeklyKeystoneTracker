
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

local frame = CreateFrame("FRAME","WeeklyKeystoneTracker")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
print("frame registered")
local function eventHandler(self,event)
  print("eventHandler")
  OpenAllBags()
  local bag, slot = searchForKey()
  print(string.find(GetContainerItemLink(bag,slot),"Spires of Ascension"))

end
frame:SetScript("OnEvent", eventHandler)
