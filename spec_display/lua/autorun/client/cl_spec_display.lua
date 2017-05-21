-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/


if CLIENT then

	-- Basic vars
	local showEye = false
	local showAmount = false
	local amount = 0
	
	-- Receival of the server's spectator count
	net.Receive( "spec_display", function( net_response )
		amount = net.ReadInt( 8 )
		showAmount = net.ReadBool( )
		showEye = net.ReadBool( )
	end)
	
	-- Eye-Icon on the side
	local spec_eye = Material( "hud/spectator_eye.png" )

	-- Drawing of the eye
	hook.Add( "HUDPaint", "spectator_eye_image", function()
		if amount > 0 and showEye then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( spec_eye )
			surface.DrawTexturedRect( 32, ScrH()/2-32, 64, 64 )
		end
	end )
	
	-- Drawing of the amount of spectators
	hook.Add( "HUDPaint", "spectator_eye_amount", function()
		if showAmount and amount > 0 then
			surface.SetFont( "Trebuchet24" )
			surface.SetTextColor( 255, 255, 255, 255 )
			if amount < 10 then
				surface.SetTextPos( 14, ScrH()/2-12 )
			else
				surface.SetTextPos( 6, ScrH()/2-12 )
			end
			surface.DrawText( amount )
		end
	end )
	
end