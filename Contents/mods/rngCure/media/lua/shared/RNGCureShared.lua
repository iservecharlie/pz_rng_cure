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
--STATE----------------------------------------------
-----------------------------------------------------

RNGCureShared.currentOptions = nil

-----------------------------------------------------
--COMMON---------------------------------------------
local function has_key(table, key)
  return table[key] ~= nil
end

local function get_keys(table)
  local keys={}
  local n=0
  for k,v in pairs(table) do
    n=n+1
    keys[n]=k
  end
  return keys
end

local function deep_copy(val)
  local val_copy
  if type(val) == 'table' then
    val_copy = {}
    for k,v in pairs(val) do
      val_copy[k] = deep_copy(v)
    end
  else
    val_copy = val
  end
  return val_copy
end

local function getDefaultOptions()
  return {
    ["general"] = {
      ["rngCure"] = 10.0
    }
  }
end

local function applyOptions(options)
  if (type(options) ~= "table") then
    return false
  end
  RNGCureShared.currentOptions = deep_copy(options)
end

local function mergeOptions(default, loaded)
  local result = deep_copy(default)
  if type(loaded) ~= "table" then
    return default
  end
  local groups = get_keys(getDefaultOptions())
  for group_index, group_key in pairs(groups) do
    if type(loaded[group_key]) == "table" then
      for prop_key, prop_val in pairs(default[group_key]) do
        if loaded[group_key][prop_key] ~= nil then
          result[group_key][prop_key] = loaded[group_key][prop_key]
        end
      end
    end
  end
  return result
end

local function flattenVersion(version)
  return tostring(tonumber(version) * 100)
end

local function getSandboxOptionPath(group, prop)
  return ""..RNGCureShared.modId.."_"..flattenVersion(RNGCureShared.optionsVersion).."_"..group.."_"..prop
end

local function getSandboxOptions()
  local result = {}
  local defaults = getDefaultOptions()
  for group_index, group_key in pairs(get_keys(defaults)) do
    result[group_key] = {}
    for prop_index, prop_key in pairs(get_keys(defaults[group_key])) do
      local path = getSandboxOptionPath(group_key, prop_key)
      if has_key(SandboxVars, path) then
        result[group_key][prop_key] = SandboxVars[path]
      end
    end
  end
  return result
end-----------------------------------------------------

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

local function getOptions()
  return mergeOptions(getDefaultOptions(), getSandboxOptions())
end

-----------------------------------------------------
--EXPORTS--------------------------------------------
-----------------------------------------------------

RNGCureShared.applyOptions = applyOptions
RNGCureShared.getOptions = getOptions
RNGCureShared.getLocalPlayers = getLocalPlayers

return RNGCureShared
