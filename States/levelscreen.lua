function levelscreen_load(reason, level)
	love.graphics.setBackgroundColor(0, 0, 0)
	
	screen = {
		walk = 0,
		image = nil,
		timer = 3,
		levels = level,
		reasons = reason
	}
	
	if screen.reasons == "next" or screen.reasons == "credits" then
		gamestate = "loadlevel"
		music:stop("title")
		love.audio.stop(title_intro)
	end
	
	if screen.reasons == "next"  then
		
		
		make_objects_tables()
		form_map(level)
		make_objects(level)
		resetcollisionoptions()
	end
	print("your reason is: " .. reason)
	
	if screen.reasons == "editor" or screen.reasons == "editmap" then
		screen.timer = 0
	end
	screeny = 240

end

function levelscreen_draw()
	if screen.reasons == "next" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("Loading" , screen_width/2.5, screen_height/2)
		love.graphics.draw(screen.image, screen_width/2.2, screen_height/1.5, 0, 5, 5)
	elseif screen.reasons == "end" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("THANK YOU FOR" , screen_width/2.5, screen_height/4)
		love.graphics.print("FINISHING THIS MAPPACK" , screen_width/3, screen_height/2.5)
	end
	
	
	if screen.reasons == "credits" then
		love.graphics.setColor(255, 255, 255)
		love.graphics.push()
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("BETA STAFF", screen_width/2.5, screeny)
		love.graphics.print("QCode - Game Framework", screen_width/3, screeny+40)
		love.graphics.print("Hatninja - Sprites", screen_width/3, screeny+80)
		love.graphics.print("Idiot9.0 - Sprites - Some Code", screen_width/3, screeny+120)
		love.graphics.print("Kyle_Prior - Music/SFX", screen_width/3, screeny+160)
		love.graphics.print("Rokit Boy - Some Code", screen_width/3, screeny+200)
		love.graphics.print("Thunderflipper", screen_width/3, screeny+240)
		love.graphics.print("Pyromaniac - Web Developer", screen_width/3, screeny+280)
		love.graphics.print("CONTRIBUTORS", screen_width/2.5, screeny+380)
		love.graphics.pop()
	end
end

function levelscreen_keypress(key, unicode)
	if key == "return" and screen.reasons ~= "next" then
		menu_load(false)
	end
end

function levelscreen_update(dt)
	if screen.reasons == "next" then
		screen.walk = screen.walk + 30*dt
		if screen.walk >= 0 and screen.walk < 3 then
			screen.image = standright
		elseif screen.walk >= 3 and screen.walk < 5 then
			screen.image = walk1	
		elseif screen.walk >= 5 and screen.walk < 7 then
			screen.image = walk2	
		elseif screen.walk >= 7 and screen.walk < 9 then
			screen.image = walk3
		end
		if screen.walk >= 6 then
			screen.walk = 0
		end
		
		screen.timer = screen.timer - dt
		
		if screen.timer <= 0 then
			screen.timer = 0
			game_load(screen.levels)
			screen.timer = 3
		end
	end
	
	if screen.reasons == "credits" then
		screen.timer = screen.timer - dt
		
		if screen.timer <= 0 then
			screen.timer = 0
			screeny = screeny - 2
		end
	end
	
	if screen.reasons == "editmap" then
		editor_load()
	end
	
end