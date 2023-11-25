-----------------------------------------------------
--CORE-----------------------------------------------
-----------------------------------------------------

local function cureVirus(player)
  local bodyDamage = player:getBodyDamage()
  for i = 0, bodyDamage:getBodyParts():size() - 1 do
    local bodyPart = bodyDamage:getBodyParts():get(i)
    bodyPart:SetInfected(false)
  end
  bodyDamage:setInf(false)
  bodyDamage:setInfectionLevel(0)
  bodyDamage:setInfectionTime(-1.0)
  bodyDamage:setInfectionMortalityDuration(-1.0)
end

local function shouldRollForInfectionSurvival(player)
  local bodyDamage = player:getBodyDamage()
  local infectionLevel = bodyDamage:getInfectionLevel()
  
  if(infectionLevel >= 90 and not player:getModData().hasRolledDiceForInfectionInstance) then
    bodyDamage:setInfectionLevel(91)
  	return true 
  elseif(infectionLevel < 90) then
    player:getModData().hasRolledDiceForInfectionInstance = false
  end
  return false
end

local function onEveryTenMinutes()
  local players = RNGCureShared.getLocalPlayers()
  for key, player in ipairs(players) do
    if player:getBodyDamage():IsInfected() then
      if shouldRollForInfectionSurvival(player) then		
        local diceRoll =  ZombRand(100)
        if diceRoll <= 10 then
          cureVirus(player)
        end
        player:getModData().hasRolledDiceForInfectionInstance = true
      end
    end
  end
end

Events.EveryTenMinutes.Add(onEveryTenMinutes)