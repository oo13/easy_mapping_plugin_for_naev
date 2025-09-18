--[[
<?xml version='1.0' encoding='utf8'?>
<event name="Local System Map Seller">
 <chance>100</chance>
 <location>enter</location>
 <cond>
   if player.outfitNum then
      return player.outfitNum("Local System Map") &lt; 1
   else
      return player.numOutfit("Local System Map") &lt; 1
   end
 </cond>
</event>
--]]
--[[
This plugin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This plugin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this plugin.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2023-2025 OOTA, Masato
--]]
--[[
When you enter a system:
  1. If there is neither hail nor message: you know already the entire information in the local system map (or you don't have enough credits).
  2. If you receive either hail or message: you don't grasp the entire information in the local system map.

  2-1. If you receive a hail from a map seller: you can buy the local system map (even if the system has no landable spob) but, of course, it's expensive.
  2-2. If you receive the message "There seems to be no map seller in this system.": you have to discover the information by yourself.
--]]
local fmt = require "format"

local cost = 10e3
local minimum_independent_presence = 1
local maximum_volatility = 3
local wait_to_hail = 2.0
local seller_disapear_time = 15.0
local hailhook
local timeouthook
local seller = nil
local NPC_name = _("A vending machine of a map seller")
local new_versiontest_api = type(naev.versionTest(naev.version(), ">=0.13.0-alpha.9")) == "boolean"
local older_than_ver012a2 = not new_versiontest_api and naev.versionTest(naev.version(), "0.12.0-alpha.1") <= 0
local older_than_ver0122 = not new_versiontest_api and naev.versionTest(naev.version(), "0.12.2") <= 0

function hasLocalMap ()
   if player.outfitNum then
      return player.outfitNum("Local System Map") > 0
   else
      return player.numOutfit("Local System Map") > 0
   end
end

function create ()
   local cur = system.cur()
   local _, vol, _ = cur:nebula()
   local fac = faction.get("Independent")
   local pr = cur:presence(fac)
   if pr >= minimum_independent_presence and vol <= maximum_volatility then
      if player.credits() >= cost then
         hook.timer(wait_to_hail, "spawn")
      else
         -- You will mechanically ignore the hail from the sales.
         evt.finish()
         return
      end
   else
      hook.timer(wait_to_hail, "no_seller_is_found")
   end
end

function no_seller_is_found ()
   if hasLocalMap() then
      -- A player may discover the information in a few second.
      evt.finish()
      return
   end

   player.msg("#r" .. _("There seems to be no map seller in this system.") .. "#0")
   evt.finish()
end

function spawn ()
   if hasLocalMap() then
      -- A player may discover the information in a few second.
      evt.finish()
      return
   end

   local pos = vec2.new(100000, 100000) -- out of overlay map
   local seller_faction = faction.dynAdd(nil, "Map_Seller", _("Map Seller"))
   local seller_ship = ship.get("Llama")
   seller = pilot.add(seller_ship, "Trader", pos, NPC_name )
   if older_than_ver012a2 and player.misnActive("Seek And Destroy") and not naev.claimTest(system.cur()) then
      -- Prevent the seller talking about the wanted pilot in the mission "Seek And Destroy."
      -- This workaround reveals the offstage a bit, so I would use it only when it's necessary.
      seller:setLeader(player.pilot())
   end
   seller:setFaction(seller_faction)
   seller:setFriendly()
   seller:setInvincible()
   seller:control()
   seller:brake()
   seller:hailPlayer()
   hailhook = hook.pilot(seller, "hail", "hail")
   timeouthook = hook.timer(seller_disapear_time, "leave")
end

function hail ()
   hook.rm(timeouthook)
   hook.rm(hailhook)
   if hasLocalMap() then
      -- A player may discover the information in a few second.
      tk.msg(NPC_name, _[["OH! YOU SEEM TO NEED NO LOCAL SYSTEM MAP, SORRY."]])
   else
      if tk.yesno(NPC_name, fmt.f(_([["THE LOCAL SYSTEM MAP ON SALE FOR ONLY {cost}!"
Would you buy the local system map?]]), {cost=fmt.credits(cost)})) then
        player.pay(-cost)
        player.outfitAdd("Local System Map")
        player.msg(_("You got the local system map."))
        if older_than_ver0122 then
           -- setKnown() calls ovr_refresh() as a side effect.
           system.cur():setKnown(true)
        end
      end
   end
   player.commClose()
   leave()
end

function leave ()
   if seller ~= nil then
     seller:rm()
     seller = nil
   end
   evt.finish()
end
