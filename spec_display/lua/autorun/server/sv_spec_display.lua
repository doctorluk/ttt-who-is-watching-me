-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/

if SERVER then
	
	resource.AddFile( "materials/hud/spectator_eye.png" )
	
	util.AddNetworkString( "spec_display" )
	
	local GROUP_ALIVE = 1
	local GROUP_NOTFOUND = 2
	local GROUP_FOUND = 3
	local GROUP_SPEC = 4
	
	local showInnos = false
	
	local function checkSpectators( )
		for _, ply in ipairs( player.GetHumans() ) do
			ply.viewercount = 0
		end
		
		for _, ply in ipairs( player.GetHumans() ) do
			if ply:IsSpec() or not ply:Alive() then
				local target = ply:GetObserverTarget()
				if target and ( ply:GetObserverMode() == OBS_MODE_IN_EYE or ply:GetObserverMode() == OBS_MODE_CHASE ) then
					if not target.viewercount then target.viewercount = 0 end
					target.viewercount = target.viewercount + 1
				end
			end
		end
		
		showInnos = spec_canInnosSee()
		
		for _, ply in ipairs( player.GetHumans() ) do
			net.Start( "spec_display" )
			net.WriteInt( ply.viewercount, 8 )
			net.WriteBool( ply:IsTraitor() )
			net.WriteBool( showInnos )
			net.Send( ply )
		end
	end
	timer.Create( "spectate_monitor", 1, 0, checkSpectators )
	
	-- Check if innocents can see spectator eyes
	function spec_canInnosSee( )
		
		for _, ply in ipairs( player.GetHumans() ) do
			if getScoreGroup(ply) == GROUP_SPEC then
				return true
			end
			if getScoreGroup(ply) == GROUP_FOUND  then
				return true
			end
		end
		
		return false
		
	end
	
	function getScoreGroup(p)
	   if not IsValid(p) then return -1 end -- will not match any group panel

		if DetectiveMode() then
			if p:IsSpec() and (not p:Alive()) then
				if p:GetNWBool("body_found", false) then
					return GROUP_FOUND
				else
					return GROUP_NOTFOUND
				end
			elseif p:Alive() and p:IsActive() then
				return GROUP_ALIVE
			end
	   end

	   return GROUP_SPEC
	   
	end
	
end


