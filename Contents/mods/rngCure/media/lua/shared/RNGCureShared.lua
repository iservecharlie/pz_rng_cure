RNGCureShared = {}
RNGCureShared.__index = RNGCureShared

-----------------------------------------------------
--CONST----------------------------------------------
-----------------------------------------------------

RNGCureShared.version = "1.1"
RNGCureShared.optionsVersion = "1.1"
RNGCureShared.author = "titoCardo"
RNGCureShared.modName = "RNG Cure"
RNGCureShared.modId = "rng_cure"

-----------------------------------------------------
--COMMON---------------------------------------------
local function getLocalInfectedPlayers()
  local result = {}
  for playerIndex = 0, getNumActivePlayers()-1 do
    local player = getSpecificPlayer(playerIndex)
    if player ~= nil then
      if player:isLocalPlayer() then
        local bodyDamage = player:getBodyDamage()
        if bodyDamage:IsInfected() and bodyDamage:getInfectionLevel() < 100 then
          table.insert(result, player)
        end
      end
    end
  end
  return result
end
-----------------------------------------------------
--EXPORTS--------------------------------------------
-----------------------------------------------------

RNGCureShared.getLocalInfectedPlayers = getLocalInfectedPlayers

return RNGCureShared
