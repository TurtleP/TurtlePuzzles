function intro_load()
	introtimer = 0
	introlevel = 1
	introalpha = 255
	intro_qx = 133 * scale/ 2
	intro_qy = 200 * scale / 2
	intro_codex = 133 * scale / 2
	intro_codey = 200 * scale / 2
	print("Intro has been loaded")
end


function intro_update(dt)
	introtimer = introtimer + dt
	if introtimer > 1.5 and introtimer < 2 then
		introlevel = 2
		intro_codex = intro_codex + 400 * scale * dt
		if intro_codex >= 200 * scale then
			intro_codex = 200 * scale
		end
	elseif introtimer > 2 then
		introlevel = 3
		intro_codey = intro_codey - 400 * scale * dt
		intro_qy = intro_qy + 400 * scale * dt
		if introtimer >= 3 then
			introtimer = nil
			introalpha = nil
			introlevel = nil
			gamestate = "menu"
			menu_load()
			print("Intro finished, loading menu")
		end
	end
end

function intro_draw()
	love.graphics.setColor(255, 55, 0)
	love.graphics.rectangle("fill", 0, 83*scale, love.graphics.getWidth(), love.graphics.getHeight() - 160*scale)
	love.graphics.setFont(hugefont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Tiny Turtle Industries", intro_qx, intro_qy)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 34*scale)
	love.graphics.rectangle("fill", 0, love.graphics.getHeight()-32*scale, love.graphics.getWidth(), 34*scale)
	love.graphics.setFont(smallfont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Presents..", intro_qx*2.3, intro_qy*1.3)
end