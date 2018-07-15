
AlxBar = {} 

AlxBar.sys = {
  name = "AnLorXen_Toolbar", 
  savedVarsVersion = 0.1, 

  defaults = {
    gui = { 
      position = {
        x = 12, 
        y = 4 
      }, 
      height = 26,  
      font = {
        name = "esoui/common/fonts/univers57.otf", 
        size = 20, 
        style = "soft-shadow-thick" 
      }, 
      spacer = {
        name = "esoui/art/buttons/checkbox_mouseover.dds", 
        width = 32
      } 
    } 
  }, 

  cmds = {
    reload = "/rl", 
    reset = "/bar", 
    toggle = "/tb", 
    test   = "/test"
  }, 

  timerId1K = "AnLorXen_Timer1K", 
  timerId3K = "AnLorXen_Timer3K" 
} 

AlxBar.cfg = { 

  colors = { 
    hex = { 
      critical = "FF2020", 
      default = "CCCC80", 
      dark = "7A7A4C", 
      warning = "FFFF20", 
      white   = "FFFFFF" 
    }, 
    rgba = {
      default = function() return 0.8, 0.8, 0.5, 1.0 end, 
      white   = function() return 1.0, 1.0, 1.0, 1.0 end, 
      red     = function() return 0.8, 0.0, 0.0, 1.0 end, 
      yellow  = function() return 0.8, 0.8, 0.0, 1.0 end, 
      green   = function() return 0.0, 0.8, 0.0, 1.0 end, 
      blue    = function() return 0.0, 0.0, 0.8, 1.0 end       
    } 
  }, 

  player = { 
    exp = 0, 
    x = 0, 
    y = 0
  }, 

  bag = {
    warning = 25, 
    critical = 10     
  }, 

  fps = {
    times = {
      warning = 45, 
      critical = 30
    }
  }, 

  ping = {
    times = {
      warning = 150, 
      critical = 300
    }
  }, 

  counter = { 
    times = {
      max = 900, 
      warning = 120, 
      critical = 30, 
      last = nil 
    }, 
  }, 

  equip = { 
    levels = {
      warning = 10, 
      critical = 5 
    }, 
    slots = {
      [1] = {
        name = EQUIP_SLOT_MAIN_HAND, 
        equipped = false, 
        charge = 0, 
        max = 999, 
        percent = 0 
      }, 
      [2] = {
        name = EQUIP_SLOT_OFF_HAND, 
        equipped = false, 
        charge = 0, 
        max = 999, 
        percent = 0  
      }, 
      [3] = {
        name = EQUIP_SLOT_BACKUP_MAIN, 
        equipped = false, 
        charge = 0, 
        max = 999, 
        percent = 0  
      }, 
      [4] = {
        name = EQUIP_SLOT_BACKUP_OFF, 
        equipped = false, 
        charge = 0, 
        max = 999, 
        percent = 0  
      }
    } 
  } 

} 

AlxBar.gui = { 
  name = "AlxBarUI", 
  constructor = nil 
} 



-- ************************************
-- ************************************
-- ************************************



AlxBar.TestCmd = function() 

  d("left: " .. AlxBar.gui.constructor.top:GetLeft()) 
  d("top: " .. AlxBar.gui.constructor.top:GetTop()) 




  -- d("Look at my |t32:32:esoui/art/icons/mounticon_horse_a.dds|t") 
  
  -- 
  -- local ts = GetTimeString() 
  -- local hh, mm, ss = ts:match("([^:]+):([^:]+):([^:]+)") 
  -- local del = "|cA0A0CF:|r" 

  -- local dTime = hh ..del.. mm ..del.. ss 

  -- d("f'ed: " .. dTime) 
  -- d("not: " .. ts) 
  
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.BuildUI = function() 
  local ui, font, spacer, insertLabel, insertTexture 

  if AlxBar.gui.constructor == nil then 
    ui = {} 
    font = AlxBar.settings.gui.font 
    spacer = AlxBar.settings.gui.spacer 
    AlxBar.gui.constructor = ui 

    insertLabel = function(_name, _parent, _pAnchor)       
      local ctrl = WINDOW_MANAGER:CreateControl(
        string.format("%s_%s", AlxBar.gui.name, _name), 
        ui.top, CT_LABEL) 
      ctrl:SetAnchor(TOPLEFT, _parent, _pAnchor, 0, 0) 
      ctrl:SetColor(AlxBar.cfg.colors.rgba.default()) 
      ctrl:SetFont(string.format(
        "%s|%d|%s", font.name, font.size, font.style)
      ) 
      ctrl:SetHeight(AlxBar.settings.gui.height) 
      ctrl:SetHorizontalAlignment(TEXT_ALIGN_CENTER) 
      return ctrl 
    end 

    insertTexture = function(_name, _parent, _pAnchor) 
      local ctrl, dot 

      ctrl = WINDOW_MANAGER:CreateControl(
        string.format("%s_%s", AlxBar.gui.name, _name), 
        ui.top, CT_CONTROL) 
      ctrl:SetAnchor(TOPLEFT, _parent, _pAnchor, 0, 0) 
      ctrl:SetWidth(spacer.width) 
      dot = WINDOW_MANAGER:CreateControl(
        string.format("%s_%s_tx", AlxBar.gui.name, _name), ctrl, CT_TEXTURE) 
      dot:SetAlpha(0.7) 
      dot:SetAnchor(TOPLEFT, ctrl, TOPLEFT, (spacer.width - 16) / 2, 4) 
      dot:SetResizeToFitFile(true) 
      dot:SetTexture(spacer.name) 

      return ctrl 
    end 

    ui.top = WINDOW_MANAGER:CreateTopLevelWindow(
      string.format("%s_Top", AlxBar.gui.name)
    ) 
    ui.top:SetAnchor(
      TOPLEFT, GuiRoot, TOPLEFT, 
      AlxBar.settings.gui.position.x, 
      AlxBar.settings.gui.position.y 
    ) 
    ui.top:SetClampedToScreen(true) 
    ui.top:SetHeight(AlxBar.settings.gui.height) 
    ui.top:SetHidden(false) 
    ui.top:SetMouseEnabled(true) 
    ui.top:SetMovable(true) 
    ui.top:SetResizeToFitDescendents(true) 

    ui.top:SetHandler("OnMoveStop", AlxBar.MouseMoveStopped) 

    -- ui.top:SetHandler("OnMoveStop", function(self) d("landed at: " ui.top:GetLeft() .. ", " .. ui.top:GetTop()) end) 

    -- ui.bd = WINDOW_MANAGER:CreateControlFromVirtual(
    --   string.format("%s%s", AlxBar.gui.name, "_Bd"), 
    --   ui.top, "ZO_DefaultBackdrop") 
    -- ui.bd:SetAlpha(0.6) 
    -- ui.bd:SetAnchor(TOPLEFT, ui.top, TOPLEFT, 4, 4) 
    -- ui.bd:SetAnchor(BOTTOMRIGHT, ui.top, BOTTOMRIGHT, -4, -4) 

    ui.time = insertLabel("Time", ui.top, TOPLEFT) 

    ui.dot1 = insertTexture("Dot1", ui.time, TOPRIGHT) 
    ui.fps = insertLabel("Fps", ui.dot1, TOPRIGHT) 

    ui.dot2 = insertTexture("Dot2", ui.fps, TOPRIGHT) 
    ui.ping = insertLabel("Ping", ui.dot2, TOPRIGHT) 

    ui.dot3 = insertTexture("Dot3", ui.ping, TOPRIGHT) 
    ui.exp = insertLabel("Exp", ui.dot3, TOPRIGHT) 

    ui.dot4 = insertTexture("Dot4", ui.exp, TOPRIGHT) 
    ui.bag = insertLabel("Bag", ui.dot4, TOPRIGHT) 

    ui.dot5 = insertTexture("Dot5", ui.bag, TOPRIGHT) 
    ui.repair = insertLabel("Repair", ui.dot5, TOPRIGHT) 

    ui.dot6 = insertTexture("Dot6", ui.repair, TOPRIGHT) 
    ui.charge = insertLabel("Charge", ui.dot6, TOPRIGHT) 

    ui.dot7 = insertTexture("Dot7", ui.charge, TOPRIGHT) 
    ui.counter = insertLabel("Counter", ui.dot7, TOPRIGHT) 





    -- ui.dot8 = insertTexture("Dot8", ui.counter, TOPRIGHT) 

-- http://esoapi.uesp.net/current/src/libraries/zo_combobox/zo_combobox_base.lua.html#314
    -- ALX_ComboBox_Persona = ZO_ComboBox_Base:Subclass() 

    -- ui.persona = WINDOW_MANAGER:CreateControl(
    --   string.format("%s_%s", AlxBar.gui.name, "Persona"), 
    --   ui.top, CT_DROPDOWN)
    




  end 
end 



AlxBar.ToggleUI = function() 

end 



AlxBar.ShowUI = function() 

end 



AlxBar.HideUI = function() 

end 



AlxBar.Refresh = function() 
  AlxBar.UpdateExp() 
  AlxBar.UpdateBagSpace() 
  AlxBar.UpdateRepairCost() 
  AlxBar.UpdateWeaponCharge() 
end



AlxBar.BumpCompass = function(_bool) 
  if _bool then 
    ZO_CompassFrame:ClearAnchors()
    ZO_CompassFrame:SetAnchor(
      TOP, GuiRoot, TOP, 0, AlxBar.settings.gui.height + 40
    ) 
    ZO_TargetUnitFramereticleover:ClearAnchors()
    ZO_TargetUnitFramereticleover:SetAnchor(
      TOP, GuiRoot, TOP, 0, AlxBar.settings.gui.height + 88
    ) 
  else 
    ZO_CompassFrame:ClearAnchors()
    ZO_CompassFrame:SetAnchor(TOP, GuiRoot, TOP, 0, 40) 
    ZO_TargetUnitFramereticleover:ClearAnchors()
    ZO_TargetUnitFramereticleover:SetAnchor(TOP, GuiRoot, TOP, 0, 88) 
  end 
end 



AlxBar.SetBarHeight = function(_height) 
  AlxBar.settings.gui.height = _height 
end 



AlxBar.MouseMoveStopped = function() 
  AlxBar.SetBarLocation(
    AlxBar.gui.constructor.top:GetLeft(), 
    AlxBar.gui.constructor.top:GetTop() 
  ) 
end 

AlxBar.SetBarLocation = function(_x, _y) 
  AlxBar.settings.gui.position.x = _x 
  AlxBar.settings.gui.position.y = _y 
  AlxBar.gui.constructor.top:SetSimpleAnchor(
    GuiRoot, 
    AlxBar.settings.gui.position.x, 
    AlxBar.settings.gui.position.y
  ) 
end 



AlxBar.SetFontSize = function(_size) 
  AlxBar.settings.gui.font.size = _size 
end 



AlxBar.SetColor = function(_sText, _sColor) 
  local prefix = "|c" 
  local suffix = "|r" 
  return string.format("%s%s%s%s", prefix, _sColor, _sText, suffix) 
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.UpdateTime = function() 
  if AlxBar.gui.constructor == nil then 
    return 
  else 
    local sSep, sOut 
    local sTime = GetTimeString() 
    local sHour, sMin, sSec = sTime:match("([^:]+):([^:]+):([^:]+)") 
    sSep = AlxBar.SetColor(":", AlxBar.cfg.colors.hex.dark) 
    sSec = AlxBar.SetColor(sSec, AlxBar.cfg.colors.hex.dark) 
    sOut = string.format("%s%s%s%s%s", sHour, sSep, sMin, sSep, sSec) 

    AlxBar.gui.constructor.time:SetText(sOut) 
  end 
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.UpdateFpsAndPing = function() 
  local nFps, colorFps, sFps
  local nPing, colorPing, sPing 
  local colors = AlxBar.cfg.colors.hex 

  nFps = GetFramerate() 
  if nFps < AlxBar.cfg.fps.times.warning then 
    colorFps = colors.warning 
  elseif nFps < AlxBar.cfg.fps.times.critical then 
    colorFps = colors.critical 
  else 
    colorFps = colors.default 
  end 
  sFps = string.format("%s %s", 
    AlxBar.SetColor("FPS:", colors.dark), 
    AlxBar.SetColor(tostring(math.floor(nFps)), colorFps)
  ) 
  AlxBar.gui.constructor.fps:SetText(sFps)     

  nPing = GetLatency() 
  if nPing > AlxBar.cfg.ping.times.warning then 
    colorPing = colors.warning 
  elseif nPing > AlxBar.cfg.ping.times.critical then 
    colorPing = colors.critical 
  else 
    colorPing = colors.default 
  end
  sPing = string.format("%s %s", 
    AlxBar.SetColor("PR:", colors.dark), 
    AlxBar.SetColor(tostring(nPing), colorPing) 
  ) 
  AlxBar.gui.constructor.ping:SetText(sPing)   
end 



-- ************************************
-- ************************************
-- ************************************



-- LWF4.__internal.comma_number = function(amount)
--   if amount == nil then return nil; end
--   if type(amount) == "string" then amount = tonumber( amount ) end
--   if type(amount) ~= "number" then return amount; end
--   if amount < 1000 then return amount; end
--   return FormatIntegerWithDigitGrouping( amount, GetString( SI_DIGIT_GROUP_SEPARATOR ) )





AlxBar.UpdateExp = function() 
  if AlxBar.gui.constructor == nil then 
    return 
  else 
    local cp, xp, xpMax, sSep 

    if IsUnitChampion("player") then 
      cp = GetPlayerChampionPointsEarned() 
      xp = GetPlayerChampionXP("player") 
      xpMax = GetNumChampionXPInChampionPoint(cp) 
    else 
      xp = GetUnitXP("player") 
      xpMax = GetUnitXPMax("player") 
    end 
    if xp == nil then xp = 0 end 
    if xp >= 10000 then 
      xp = FormatIntegerWithDigitGrouping(xp, ",") 
    end 
    if xpMax == nil then xpMax = 0 end 
    if xpMax >= 10000 then 
      xpMax = FormatIntegerWithDigitGrouping(xpMax, ",") 
    end 
    sSep = AlxBar.SetColor("/", AlxBar.cfg.colors.hex.dark) 

    AlxBar.gui.constructor.exp:SetText(
      string.format("%s %s %s", xp, sSep, xpMax)
    ) 
  end
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.UpdateBagSpace = function() 
  local colors = AlxBar.cfg.colors.hex 
  local bagUsed = GetNumBagUsedSlots(BAG_BACKPACK) 
  local bagSize = GetBagSize(BAG_BACKPACK) 
  local bagFree = GetNumBagFreeSlots(BAG_BACKPACK) 
  local sTexture = "|t24:32:esoui/art/mainmenu/menubar_inventory_up.dds|t" 
  local sUsed, sSep  

  if bagFree <= AlxBar.cfg.bag.critical then 
    sUsed = AlxBar.SetColor(tostring(bagUsed), colors.critical) 
  elseif bagFree <= AlxBar.cfg.bag.warning then 
    sUsed = AlxBar.SetColor(tostring(bagUsed), colors.warning) 
  else 
    sUsed = tostring(bagUsed) 
  end 
  sSep = AlxBar.SetColor("/", colors.dark) 

  AlxBar.gui.constructor.bag:SetText(
    string.format("%s%s %s %d", sTexture, sUsed, sSep, bagSize)
  ) 
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.UpdateRepairCost = function() 
  local bagSlot 
  local cost = 0 
  local sTexture = "|t24:32:esoui/art/ava/ava_resourcestatus_tabicon_defense_inactive.dds|t" 
  for bagSlot = 0, GetBagSize(BAG_WORN), 1 do 
    cost = cost + GetItemRepairCost(BAG_WORN, bagSlot) 
  end 
  if cost == 0 then 
    AlxBar.gui.constructor.repair:SetText("~") 
  else 
    AlxBar.gui.constructor.repair:SetText(
      string.format("%s %d %s", sTexture, cost, 
      AlxBar.SetColor("g", AlxBar.cfg.colors.hex.dark))
    ) 
  end   
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.UpdateWeaponCharge = function() 
  local colors = AlxBar.cfg.colors.hex 
  local link = nil  
  local sOut = ""  
  local sLevel 
  local sTexture = "|t24:32:esoui/art/campaign/campaignbrowser_indexicon_normal_up.dds|t" 
  for key, slot in pairs(AlxBar.cfg.equip.slots) do 
    slot.equipped = false 
    slot.charge = 999 
    slot.max = 999 
    slot.percent = 100 
    
    link = GetItemLink(BAG_WORN, slot.name) 
    if link ~= nil and link ~= "" then 
      slot.equipped = true 
      if IsItemChargeable(BAG_WORN, slot.name) then 
        slot.charge = GetItemLinkNumEnchantCharges(link) 
        slot.max = GetItemLinkMaxEnchantCharges(link) 
        slot.percent = math.floor((slot.charge / slot.max) * 100) 
      end 
    end 

    if slot.equipped then 
      if slot.percent <= AlxBar.cfg.equip.levels.critical then 
        sLevel = AlxBar.SetColor(
          string.format("%d%s", slot.percent, "%"), colors.critical
        ) 
      elseif slot.percent <= AlxBar.cfg.equip.levels.warning then 
        sLevel = AlxBar.SetColor(
          string.format("%d%s", slot.percent, "%"), colors.warning
        ) 
      else 
        sLevel = string.format(
          "%d%s", slot.percent, AlxBar.SetColor("%", colors.dark) 
        )
      end 
      sOut = string.format("%s %s", sOut, sLevel) 
    end 
  end 

  AlxBar.gui.constructor.charge:SetText(
    string.format("%s%s", sTexture, sOut)
  ) 
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.ResetCounter = function() 
  AlxBar.cfg.counter.times.last = GetGameTimeMilliseconds() 
end 



AlxBar.UpdateCounter = function() 
  local times = AlxBar.cfg.counter.times 
  local colors = AlxBar.cfg.colors.hex 
  local player = AlxBar.cfg.player 
  local timeNow = GetGameTimeMilliseconds() 
  local timeLeft = 0 
  local sOut, sLeft 

  local px, py = GetMapPlayerPosition("player") 
  if px ~= player.x or py ~= player.y then 
    player.x = px 
    player.y = py 
    AlxBar.ResetCounter() 
  end 

  timeLeft = times.max - math.floor((timeNow - times.last) / 1000) 
  if timeLeft <= times.critical then 
    sLeft = AlxBar.SetColor(tostring(timeLeft), colors.critical) 
  elseif timeLeft <= times.warning then 
    sLeft = AlxBar.SetColor(tostring(timeLeft), colors.warning) 
  else 
    sLeft = tostring(timeLeft) 
  end 

  sOut = AlxBar.SetColor("CD:", colors.dark) 
  AlxBar.gui.constructor.counter:SetText(
    string.format("%s %s", sOut, sLeft)
  )
end 



-- ************************************
-- ************************************
-- ************************************



AlxBar.AddOnLoaded = function(_event, _name) 
  if _name == AlxBar.sys.name then 
		EVENT_MANAGER:UnregisterForEvent(
      AlxBar.sys.name, EVENT_ADD_ON_LOADED
    )
    AlxBar.Init() 
	end
end 



AlxBar.PlayerActivated = function(_event, _initial) 
  if _initial then 
  end 
  AlxBar.BumpCompass(true) 
  AlxBar.UpdateExp() 
  AlxBar.UpdateBagSpace() 
  AlxBar.UpdateRepairCost() 
  AlxBar.UpdateWeaponCharge() 
end 



AlxBar.ExperienceUpdated = function() 
  AlxBar.UpdateExp() 
end 



AlxBar.InventoryCapUpdated = function(_event, _prevCap, _currCap, _prevUpgrade, _currUpgrade) 
  AlxBar.UpdateBagSpace() 
end 

AlxBar.InventoryUpdated = function(_event, _bagId, _slotId, _isNew, _itemSoundCat, _updateReason, _stackCount) 
  if _bagId ~= BAG_BACKPACK then return end 
  if _updateReason == INVENTORY_UPDATE_REASON_DURABILITY_CHANGE then 
    AlxBar.UpdateRepairCost() 
  end 
  if _updateReason == INVENTORY_UPDATE_REASON_ITEM_CHARGE then 
    -- 
  end 
  AlxBar.UpdateWeaponCharge() 
  AlxBar.UpdateBagSpace() 
end 

  -- INVENTORY_UPDATE_REASON_DEFAULT = 0 
  -- INVENTORY_UPDATE_REASON_DURABILITY_CHANGE = 1 
  -- INVENTORY_UPDATE_REASON_ITEM_CHARGE = 3 


-- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (
  --   number eventCode, 
  --   Bag bagId, 
  --   number slotId, 
  --   boolean isNewItem, 
  --   ItemUISoundCategory itemSoundCategory, 
  --   number inventoryUpdateReason, 
  --   number stackCountChange
  -- )

-- EVENT_INVENTORY_BAG_CAPACITY_CHANGED (
  --   number eventCode, 
  --   number previousCapacity, 
  --   number currentCapacity, 
  --   number previousUpgrade, 
  --   number currentUpgrade
  -- )


  
AlxBar.AbilityUsed = function(_evt, _slot) 
  d("Ability used: " .. _slot) 
end 



AlxBar.Timer1KChanged = function() 
  AlxBar.UpdateTime() 
  AlxBar.UpdateFpsAndPing() 
  AlxBar.UpdateCounter() 
end

AlxBar.Timer3KChanged = function() 
  AlxBar.UpdateRepairCost() 
  AlxBar.UpdateWeaponCharge() 
end 



AlxBar.CombatStateChanged = function(_evt, _bool) 
  if _bool then 
    AlxBar.ResetCounter() 
  else 
    AlxBar.UpdateRepairCost() 
    AlxBar.UpdateWeaponCharge() 
  end 
end 



AlxBar.UnitDestoyed = function(_evt, _unit) 
  d("UnitDestoyed: " .. _unit) 
end 



AlxBar.FinesseRankChanged = function(_evt, _unitTag, _rankNum, _name, _xpBonus, _loot) 
  d("FinesseRankChanged:") 
  d("UnitTag: " .. _unitTag) 
  d("RankNumber: " .. _rankNum) 
  d("Name: " .. _name) 
  d("XP_Bonus: " .. _xpBonus) 
  d("Loot: " .. tostring(_loot)) 
end 




-- ************************************
-- ************************************
-- ************************************



AlxBar.Init = function() 

  -- TODO: Setup Context Menu Here 

  -- TODO: Setup Keybindings Here 



  -- TODO: Setup Saved Variables Here 
  -- ZO_SavedVars:New(savedVariableTable, version, namespace, defaults, profile, displayName, characterName, characterId, characterKeyType)
  -- ZO_SavedVars:NewCharacterNameSettings(savedVariableTable, version, namespace, defaults, profile)
  -- ZO_SavedVars:NewCharacterIdSettings(savedVariableTable, version, namespace, defaults, profile)
  -- ZO_SavedVars:NewAccountWide(savedVariableTable, version, namespace, defaults, profile, displayName)

  AlxBar.settings = ZO_SavedVars:New(
    "AlxBarVars", AlxBar.sys.savedVarsVersion, nil, AlxBar.sys.defaults
  ) 



  -- TODO: Setup Settings Menu Here 

  SLASH_COMMANDS[AlxBar.sys.cmds.reload] = function() ReloadUI("ingame") end 
  SLASH_COMMANDS[AlxBar.sys.cmds.reset] = function() AlxBar.Refresh() end 
  SLASH_COMMANDS[AlxBar.sys.cmds.toggle] = function() AlxBar.ToggleUI() end 
  SLASH_COMMANDS[AlxBar.sys.cmds.test] = function() AlxBar.TestCmd() end 


  AlxBar.BuildUI() 

  AlxBar.ResetCounter() 


end





EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_ADD_ON_LOADED, AlxBar.AddOnLoaded
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_PLAYER_ACTIVATED, AlxBar.PlayerActivated 
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_EXPERIENCE_UPDATE, AlxBar.ExperienceUpdated 
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AlxBar.InventoryUpdated 
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_INVENTORY_BAG_CAPACITY_CHANGED, AlxBar.InventoryUpdated 
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name,  EVENT_ACTION_SLOT_ABILITY_USED, AlxBar.AbilityUsed 
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_PLAYER_COMBAT_STATE, AlxBar.CombatStateChanged
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_UNIT_DESTROYED, AlxBar.UnitDestoyed
) 

EVENT_MANAGER:RegisterForEvent(
  AlxBar.sys.name, EVENT_FINESSE_RANK_CHANGED, AlxBar.FinesseRankChanged 
) 

EVENT_MANAGER:RegisterForUpdate(
  AlxBar.sys.timerId1K, 1000, AlxBar.Timer1KChanged
)
EVENT_MANAGER:RegisterForUpdate(
  AlxBar.sys.timerId3K, 3000, AlxBar.Timer3KChanged
)


-- EVENT_COMBAT_EVENT (
  --   number eventCode, 
  --   ActionResult result,   ACTION_RESULT_DAMAGE ?
  --   boolean isError, 
  --   string abilityName, 
  --   number abilityGraphic, 
  --   ActionSlotType abilityActionSlotType, 
  --   string sourceName, 
  --   CombatUnitType sourceType, 
  --   string targetName, 
  --   CombatUnitType targetType, 
  --   number hitValue, 
  --   CombatMechanicType powerType, 
  --   DamageType damageType, 
  --   boolean log, 
  --   number sourceUnitId, 
  --   number targetUnitId, 
  --   number abilityId
-- )
