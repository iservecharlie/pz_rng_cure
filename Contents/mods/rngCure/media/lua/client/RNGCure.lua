-----------------------------------------------------
--CORE-----------------------------------------------
-----------------------------------------------------
local minimumInfectionLevelToProcCureChance = 60
local defaultInfectionLevelCureChanceProc = 90

local function cureVirus(player)
  local bodyDamage = player:getBodyDamage()
  for i = 0, bodyDamage:getBodyParts():size() - 1 do
    local bodyPart = bodyDamage:getBodyParts():get(i)
    bodyPart:SetFakeInfected(true)
    bodyPart:SetInfected(false)
  end

  bodyDamage:setIsFakeInfected(true)
  bodyDamage:setFakeInfectionLevel(bodyDamage:getInfectionLevel())

  bodyDamage:setInf(false)
  bodyDamage:setInfectionLevel(0)
  bodyDamage:setInfectionTime(-1.0)
  bodyDamage:setInfectionMortalityDuration(-1.0)
end

local function getInfectionLevelCureChanceProc(player)
  local infectionlevelToProc = defaultInfectionLevelCureChanceProc
  if SandboxVars.RNGCure.RandomCureChanceProc then
    if player:getModData().infectionLevelCureChanceProc == nil then
      infectionlevelToProc = minimumInfectionLevelToProcCureChance + ZombRand(30)
      player:getModData().infectionLevelCureChanceProc = infectionlevelToProc
    else
      infectionlevelToProc = player:getModData().infectionLevelCureChanceProc
    end
  end
  return infectionlevelToProc
end

local function shouldRollForInfectionSurvival(player)
  local bodyDamage = player:getBodyDamage()
  local infectionLevel = bodyDamage:getInfectionLevel()
  local infectionLevelToProc = getInfectionLevelCureChanceProc(player)
  local hasRolledDiceForInfectionInstance = player:getModData().hasRolledDiceForInfectionInstance
  local result = false

  if SandboxVars.RNGCure.DebugLogs then
    print("Infection level is " .. tostring(infectionLevel))
    print("Proc level is " .. tostring(infectionLevelToProc))
    print("Has rolled for infection instance is " .. tostring(hasRolledDiceForInfectionInstance))
  end

  if(infectionLevel >= infectionLevelToProc and not hasRolledDiceForInfectionInstance) then
    bodyDamage:setInfectionLevel(infectionLevelToProc + 1)
    result = true
  elseif(infectionLevel < infectionLevelToProc and hasRolledDiceForInfectionInstance) then
    player:getModData().hasRolledDiceForInfectionInstance = false
  end
  print("Result is " .. tostring(result))
  return result
end

local function doRollForInfectionSurvival(player)
  local cureChance = SandboxVars.RNGCure.CureChance
  print("RNG for cure is set to (percent): " ..  tostring(cureChance))
  local username = player:getUsername()
  local diceRoll =  ZombRand(100)
  print(username .. " has rolled " .. tostring(diceRoll))
  if diceRoll <= tonumber(cureChance) then
    cureVirus(player)
    print(username .. " has been saved by the successful dice roll.")
  else
    print(username .. " will die because of failed dice roll.")
  end
  player:getModData().hasRolledDiceForInfectionInstance = true
  player:getModData().infectionLevelCureChanceProc = nil
end

local function onEveryTenMinutes()
  local players = RNGCureShared.getLocalInfectedPlayers()
  for key, player in ipairs(players) do
    local shouldRollForCure = shouldRollForInfectionSurvival(player)
    if shouldRollForCure then
      doRollForInfectionSurvival(player)
    end
  end
end

Events.EveryTenMinutes.Add(onEveryTenMinutes)

local function onGameStart()
  print("RNG for cure is set to (percent): " .. tostring(SandboxVars.RNGCure.CureChance))
  if SandboxVars.RNGCure.RandomCureChanceProc then
    print("Infection level proc for RNG Cure is set to happen between infection level 50 - 90")
  else
    print("Infection level proc for RNG Cure is set to happen at infection level 90")
  end
end
Events.OnGameStart.Add(onGameStart)