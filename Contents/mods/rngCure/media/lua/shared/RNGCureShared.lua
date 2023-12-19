RNGCureShared = {}
RNGCureShared.__index = RNGCureShared

-----------------------------------------------------
--CONST----------------------------------------------
-----------------------------------------------------

RNGCureShared.version = "1.0"
RNGCureShared.optionsVersion = "1.0"
RNGCureShared.author = "titoCardo"
RNGCureShared.modName = "RNG Cure"
RNGCureShared.modId = "rng_cure"

-----------------------------------------------------
--COMMON---------------------------------------------
local function getLocalPlayers()
  local result = {}
  for playerIndex = 0, getNumActivePlayers()-1 do
    local player = getSpecificPlayer(playerIndex)
    if player ~= nil then
      if player:isLocalPlayer() then
        table.insert(result, player)
      end
    end
  end
  return result
end
-----------------------------------------------------
--EXPORTS--------------------------------------------
-----------------------------------------------------

RNGCureShared.getLocalPlayers = getLocalPlayers

return RNGCureShared
