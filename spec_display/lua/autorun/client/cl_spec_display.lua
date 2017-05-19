-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/


if CLIENT then

	
	local ourMat = Material( "hud/spectator_eye.png" ) -- Calling Material() every frame is quite expensive

	hook.Add( "HUDPaint", "spectator_eye_image", function()
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( ourMat	) -- If you use Material, cache it!
		surface.DrawTexturedRect( 32, ScrH()/2-32, 64, 64 )
	end )
	
	hook.Add( "HUDPaint", "spectator_eye_amount", function()
		local zahl = 5
		surface.SetFont( "Trebuchet24" )
		surface.SetTextColor( 255, 255, 255, 255 )
		if zahl < 10 then
			surface.SetTextPos( 14, ScrH()/2-12 )
		else
			surface.SetTextPos( 6, ScrH()/2-12 )
		end
		surface.DrawText( zahl )
	end )
	
end