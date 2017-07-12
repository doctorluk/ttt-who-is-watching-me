-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/

if SERVER then
	
	resource.AddFile( "materials/hud/spectator_eye.png" )
	
	util.AddNetworkString( "spec_display" )
	util.AddNetworkString( "spec_display_config" )
	
	-- Types of a player's condition
	local SPEC_ALIVE = 1
	local SPEC_NOTFOUND = 2
	local SPEC_FOUND = 3
	local SPEC_INSPEC = 4
	
	local showInnos = false
	
	local function spec_getPlayerState(p)
	   if not IsValid(p) then return -1 end

		if DetectiveMode() then
			if p:IsSpec() and (not p:Alive()) then
				if p:GetNWBool("body_found", false) then
					return SPEC_FOUND
				else
					return SPEC_NOTFOUND
				end
			elseif p:Alive() and p:IsActive() then
				return SPEC_ALIVE
			end
	   end

	   return SPEC_INSPEC
	   
	end
	
	-- Check if innocents can see spectator eyes
	local function spec_canInnosSee()
		
		for _, ply in ipairs( player.GetHumans() ) do
			if spec_getPlayerState(ply) == SPEC_INSPEC then
				return true
			end
			if spec_getPlayerState(ply) == SPEC_FOUND  then
				return true
			end
		end
		
		return false
		
	end
	
	local function spec_checkSpectators()
		-- Reset counts at start
		for _, ply in ipairs( player.GetHumans() ) do
			ply.viewercount = 0
		end
		
		-- Count players watching someone
		for _, ply in ipairs( player.GetHumans() ) do
			if ply:IsSpec() or not ply:Alive() then
				local target = ply:GetObserverTarget()
				if target and ( ply:GetObserverMode() == OBS_MODE_IN_EYE or ply:GetObserverMode() == OBS_MODE_CHASE ) then
					if not target.viewercount then target.viewercount = 0 end
					target.viewercount = target.viewercount + 1
				end
			end
		end
		
		-- Check if we have identified bodies or spectators
		showInnos = spec_canInnosSee()
		
		-- Send players the info about their spectators
		for _, ply in ipairs( player.GetHumans() ) do
		
			local amount, showAmount, showIcon
		
			if ply:IsTraitor() then
				amount = ply.viewercount
				showAmount = true
				showIcon = ply.viewercount > 0
			else
				amount = 0
				showAmount = false
				showIcon = ply.viewercount > 0 and showInnos
			end
			
			net.Start( "spec_display" )
			net.WriteInt( amount, 8 ) -- amount
			net.WriteBool( showAmount ) -- showAmount
			net.WriteBool( showIcon ) -- showIcon
			net.Send( ply )
			
		end
	end
	timer.Create( "spectate_monitor", 1, 0, spec_checkSpectators )
	
	-- Sending server config upon connection
	local function sendSpecConfig( ply )
		net.Start( "spec_display_config" )
		net.WriteInt( GetConVar("spec_eye_y_align_center"):GetInt(), 2 )
		net.WriteInt( GetConVar("spec_eye_x_offset"):GetInt(), 32 )
		net.WriteInt( GetConVar("spec_eye_y_offset"):GetInt(), 32 )
		net.Send( ply )
	end
	hook.Add( "PlayerInitialSpawn", "spectate_monitor_config", sendSpecConfig )
	
end


