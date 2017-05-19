-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/

if SERVER then
	
	util.AddNetworkString( "spec_display" )
	local currentlyObserved = {}
	
	local function checkSpectators( )
		for _, ply in ipairs( player.GetHumans() ) do
			if ply:IsSpec() then
				local target = ply:GetObserverTarget()
				if target and ply and ( ply:GetObserverMode() == OBS_MODE_IN_EYE or ply:GetObserverMode() == OBS_MODE_CHASE )then
					currentlyObserved[#currentlyObserved] = {target, amount}
				end
			end
		end
	end
	timer.Create( "spectate_monitor", 1, 0, checkSpectators )
	
	local function sendSpectatorWatching(ply, amount)
		net.Start( "spec_display" )
		net.WriteInt( amount, 8 )
		net.Send(ply)
	end
	
end


