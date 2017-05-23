-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/


if CLIENT then

	-- Basic vars
	local showEye = false
	local showAmount = false
	local amount = 0
	local spec_eye_size = 64
	local spec_eye_y_align_center = 1
	local spec_eye_x_offset = 0
	local spec_eye_y_offset = 0
	
	-- Receival of the server's spectator count
	net.Receive( "spec_display_config", function( net_response )
		spec_eye_size 			= net.ReadInt( 32 )
		spec_eye_y_align_center	= net.ReadInt( 1 )
		spec_eye_x_offset		= net.ReadInt( 32 )
		spec_eye_y_offset		= net.ReadInt( 32 )
	end)
	
	-- Receival of the server's spectator count
	net.Receive( "spec_display", function( net_response )
		amount 		= net.ReadInt( 8 )
		showAmount 	= net.ReadBool()
		showEye 	= net.ReadBool()
	end)
	
	-- Eye-Icon on the side
	local spec_eye = Material( "hud/spectator_eye.png" )

	-- Drawing of the eye
	hook.Add( "HUDPaint", "spectator_eye_image", function()
		if showEye then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( spec_eye )
			surface.DrawTexturedRect( 32 + spec_eye_x_offset, (ScrH() / 2 - ( spec_eye_size / 2 ) * spec_eye_y_align_center) + spec_eye_y_offset, spec_eye_size, spec_eye_size )
			
		end
	end )
	
	-- Drawing of the amount of spectators
	hook.Add( "HUDPaint", "spectator_eye_amount", function()
		if showAmount and amount > 0 then
			surface.SetFont( "Trebuchet24" )
			surface.SetTextColor( 255, 255, 255, 255 )
			
			-- Move the text slightly to the left for double digit numbers
			if amount < 10 then
				surface.SetTextPos( 14 + spec_eye_x_offset, ((ScrH() / 2 - 12) * spec_eye_y_align_center) + spec_eye_y_offset )
			else
				surface.SetTextPos( 6 + spec_eye_x_offset, ((ScrH() / 2 - 12) * spec_eye_y_align_center) + spec_eye_y_offset )
			end
			
			surface.DrawText( amount )
		end
	end )
	
end