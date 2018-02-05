turtle = class:new()


swimquads = {}
for i = 1, 2 do
	swimquads[i] = love.graphics.newQuad((i-1)*14, 0, 13, 16, 28, 16)
end

function turtle:init(x, y, lives, i)
 	--Physics values!
	self.x = x
  	self.oldx = x
  	self.oldy = y
  	self.width = 13*(scale)
  	self.height = 16*(scale)
  	self.y = y
    self.active = true
    self.ySpeed = 250
    self.xSpeed = 0
    self.inAir = true
	self.hats = hats[hat]
    self.friction = 20
	self.quadcenterX = 6
	self.quadcenterY = 8
	self.scale = scale
	self.scaley = scale
	self.mask = {"all"}
	self.offsetX, self.offsetY = 0
    --turtle stuff!
    self.lives = lives
    self.playernumber = i
    self.image =  standright
    self.dying = false
    self.dyingtimer = 0
    self.dead = false
	self.offsetsX = 0
    self.alpha = 255
    self.rotation = 0
    self.maximumspeed = 300
	self.walk = 0
	self.teleporting = false
	self.dir = "right"
	self.jumpsnd = 0
	self.onladder = false
	self.deathheight = 400
	self.score = 0
	self.swim = false
	self.swimquad = 1
	self.timer = 0
	self.swimsnd = false
	self.coincount = 0
	self.controls = true
	self.finishsnd = 0
	self.haskey = false
	self.pushing = false
	self.drawhats = true
	self.completed = false
end

function turtle:drawplayer()
--Draw him normally
    love.graphics.setColor(255, 255, 255, self.alpha)
	if self.dir == "right" and not self.swim then
   		love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scaley)
	elseif self.dir == "left" and not self.swim then
		love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scaley, 13)
	end
	
	
	
	if self.dir == "right" and self.swim then
   		love.graphics.drawq(swimquadimage, swimquads[self.swimquad], self.x, self.y, self.rotation, self.scale, self.scaley)
	elseif self.dir == "left" and  self.swim then
		love.graphics.drawq(swimquadimage, swimquads[self.swimquad],self.x, self.y, self.rotation, self.scale, self.scaley, 13)
	end
end

function turtle:addpoints(i)
	if i > 0 then
		turtlescore = turtlescore + i
	end
end

function turtle:addcoins()
		emeraldcount = emeraldcount + 0.5
		self:addpoints(50)
end

function turtle:addlife()
	self.lives = self.lives + 1
end

function turtle:update(dt)
	if not self.dying then
	self:move(dt)
	end
	
	if self.dir == "right" then
		self.scale = scale
		self.offsetsX = 0
	else
		self.scale = -scale
		self.offsetsX = 13
	end
	
	if self.lives <= 0 then
		paused = true
	end
	
	if self.completed then
		if self.active then
			self.completed = false
			self.finishsnd = 0
		end
	end
	
	self:onladdercheck(dt)
	if self.active and not self.onladder and not self.swim then
		self.ySpeed = self.ySpeed + 500 * dt
	end
	if self.active  then
		self.y = self.y + self.ySpeed * dt
	end
	
	if self.lives <= 0 and self.active then
		self.lives = 0
		self:gameover()
		music:stop(currentlevelmusic)
	end

	if emeraldcount > 9 then
		self:addlife()
		emeraldcount = 0
	end
	
	if self.y > screen_height then
		self:die("offscreen (or a spike?)")
	end
	
		for i, v in pairs(objects["spikes"]) do
			if self.dying then
				v.passive = true
			else
				v.passive = false
			end
		end
		
		for i, v in pairs(objects["block"]) do
			if self.dying then
				v.passive = true
			else
				v.passive = false
			end
		end
	
	for i, v in pairs(objects["lava"]) do
		if v.liquid == 2 then
			if self.y < v.y - v.height then
				self.swim = false
				v.passive = false
			end
		end
	end
	
	if self.image == climb1 or self.image == climb2 then
		self.drawhats = false
	else 
		self.drawhats = true
	end
	
	if self.swim and love.keyboard.isDown(upcontrol[self.playernumber]) then
		self.timer = self.timer + dt
	if self.timer >= 0 and self.timer < 1 then
		self.swimquad = 1
		self.swimsnd = false
	else 
		self.swimquad = 2
		if self.swimsnd == false then
		playsound(swimming)
		self.swimsnd = true
		end
	end
	if self.timer > 2 then
		self.timer = 0
	end
	self.y = self.y - 60*dt
	end
	
	if self.swim and not love.keyboard.isDown(upcontrol[self.playernumber]) then
		self.timer = self.timer + dt
	if self.timer >= 0 and self.timer < 1 then
		self.swimquad = 1
		self.swimsnd = false
	else 
		self.swimquad = 2
		if self.swimsnd == false then
		playsound(swimming)
		self.swimsnd = true
		end
	end
	if self.timer > 2 then
		self.timer = 0
	end
	self.y = self.y + 60*dt
	end
	
end

function turtle:jump()
	if self.ySpeed == 0 then
			self.ySpeed = -225 - (50*scale)
			self.inAir = true
	end
end

function turtle:use(used)
	if true then
	return
	end
end

function turtle:drawhat()
	if hat > 0 and self.drawhats and self.lives > 0 then
		
		love.graphics.setColor(255, 255, 255)
		if hat ~= 13 then
		if self.dir == "right" then
		love.graphics.drawq(hatimg[hat], hatquads[hat], self.x+2, self.y-7, 0, self.scale, self.scaley)
		else 
		love.graphics.drawq(hatimg[hat], hatquads[hat], self.x+38, self.y-7, 0, -scale, scale)
		end
		end
		
		if hat == 13 then
		if self.dir == "right" then
		love.graphics.drawq(hatimg[hat], hatquads[hat], self.x+2, self.y-16, 0, scale, scale)
		else 
		love.graphics.drawq(hatimg[hat], hatquads[hat], self.x+38, self.y-16, 0, -scale, scale)
		end
		end
		
		love.graphics.push()	
		love.graphics.pop()
	end
end

function turtle:onladdercheck(dt)
	local onladder = false
	for i, v in pairs(objects["ladder"]) do
		local vx = math.floor(v.x/(16*scale))
		local vy = math.floor(v.y/(16*scale))
		local x = math.floor(self.x/(16*scale))
		local y = math.floor(self.y/(16*scale))
		if x == vx and y == vy or x == vx and y+1 == vy then
			if y+1 == vy and y ~= vy then
				if self.y + self.height < v.y then
									
					if love.keyboard.isDown(upcontrol[self.playernumber]) then
						self.ySpeed = -325 - (50*scale)
						print("climb")
						break
					else
						self.ySpeed = 0
					end
				end
			end
			onladder = true
			if self.ySpeed > 500*dt and not love.keyboard.isDown(downcontrol[self.playernumber]) and not self.inAir then
				self.y = vy * (16*scale) - self.height
			end
			if self.ySpeed ~= -2 - (50*scale) and self.ySpeed ~= 2 + (50*scale) then
				self.ySpeed = 0
			end
			break
		end
	end
	self.onladder = onladder
end

function turtle:keypressed(key)
	if key == upcontrol[self.playernumber] and self.active and not self.teleporting and not self.onladder and not self.swim then
		self:jump()
	end
	
	--[[if key == rightcontrol[self.playernumber] and self.active then
		if self.x > 0 then
		drawingx = drawingx + 30 * 2 * 0.01666667
		end
	end
	
	if key == leftcontrol[self.playernumber] and self.active then
		if self.x < 23*(16*scale) then
		drawingx = drawingx + 30 * 2 * 0.01666667
		end
	end]]
	
	if key == usecontrol[self.playernumber] and self.active then
		self:use()
	end
	
	
	if self.inAir == true and self.jumpsnd == 0 and key == upcontrol[self.playernumber] then
		playsound(jumps)
		self.jumpsnd = 1
	end
	
	if self.swim then
		if key == upcontrol[self.playernumber] and not key == downcontrol[self.playernumber] and self.active and not self.teleporting then
			self.ySpeed = -2 - (25*scale)
		else 
		
		end
	end
	
	
end

function turtle:downcollide(v, name)

	
	if name == "permabutton" or name == "crate" or name == "block" or name == "button" or name == "fakewall" or (name == "invisowall" and v.solid == "solid") and self.inAir then
		self.inAir = false
		self.jumpsnd = 0
	end
	
	if name == "block" then
		--print("ok")
	end	
	
	if name == "spring" then
		bounces = bounces + 1
		if bounces == 10 and achcompleted[3] == false then
			achcompleted[3] = true
			addcoins(50)
		end
	end
	
	if (name == "button" or name == "permabutton" or name == "floorbutton") and v.push == false then
		if v.height ~= 5*scale then
			v.height = 5*scale
			v.y = v.y + 4*scale
			v.offsetY = -4*scale
		end
		v.quad = 2
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		
		for i, w in pairs(objects["fakewall"]) do
			if w.name == v.name then
				v.fakewall = i
				break
			end
		end

		for i, w in pairs(objects["invisowall"]) do
			if w.name == v.name then
				v.invisowall = i
				break
			end
		end
		v.push = true
	end
	
	if (name == "button") and self.inAir then
		self.inAir = false
	end
	
	if name == "spikes" and self.lives > 0  then
		self.image = dying
		self.dying = true
		v.passive = true
		if self.ySpeed == 0 then
			self.ySpeed = -250 - (50*scale)
		end
		if self.deathheight <= 0 then
			if self.ySpeed == 0 and self.deathheight > 0 then
			self.ySpeed = 250 + (50*scale)
		end
	end
	end
	
	if name == "coin" then
		v.remove = true
		playsound(coins)
		if not self.collect then
		self:addcoins()
		end
	end
	if name == "block" and self.dying then
		v.passive = true
	elseif name == "block" and not self.dying then
		v.passive = false
	end
	if name == "lava" and v.liquid == 1 then
		self:die("lava!")
	end
	
	if not self.swim then
	if name == "lava" and v.liquid == 2 then
		self.swim = true
		v.passive = true
	end
	
	if self.swim and name == "lava" and v.liquid == 2 then
		self.swim = true
	end
	
	if name == "water" then
		self.swim = true
	end
	end
	
	if name == "key" then
		self.haskey = true
		v.kill = true
	end
	if name == "spring" then
		playsound(springsnd)
		if self.ySpeed == 0 then
			self.ySpeed = -350 - (50*scale)
			self.inAir = true
		end
		v.push = true
	end	
	if (name == "trigger") and v.push == false then
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		
		for i, w in pairs(objects["fakewall"]) do
			if w.name == v.name then
				v.fakewall = i
				break
			end
		end

		for i, w in pairs(objects["invisowall"]) do
			if w.name == v.name then
				v.invisowall = i
				break
			end
		end
		v.push = true
	end
end

function turtle:hitdoor(dir)
	if dir == "down" then
		--nothing
	end
	if dir == "up" then
		self:die("door")
	end
end

function turtle:upcollide(v, name)
	if name == "coin" then
		v.remove = true
		playsound(coins)
		if not self.collect then
		self:addcoins()
		end
	end
	if name == "key" then
		self.haskey = true
		v.kill = true
	end
	if name == "spikes" and self.lives > 0 and v.dir == "down" then
		self:die("ouch, dem spikes")
	end
	if (name == "trigger") and v.push == false then
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		
		for i, w in pairs(objects["fakewall"]) do
			if w.name == v.name then
				v.fakewall = i
				break
			end
		end

		for i, w in pairs(objects["invisowall"]) do
			if w.name == v.name then
				v.invisowall = i
				break
			end
		end
		v.push = true
	end
end

function turtle:rightcollide(v, name)
	if name == "coin" and not v.remove then
		v.remove = true
		playsound(coins)
		if not self.collect then
		self:addcoins()
		end
	end
	
	if (name == "trigger") and v.push == false then
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		
		for i, w in pairs(objects["fakewall"]) do
			if w.name == v.name then
				v.fakewall = i
				break
			end
		end

		for i, w in pairs(objects["invisowall"]) do
			if w.name == v.name then
				v.invisowall = i
				break
			end
		end
		v.push = true
	end
	
	if not self.swim then
	if name == "lava" and v.liquid == 2 then
		self.swim = true
		v.passive = true
	end
	
	if self.swim and name == "lava" and v.liquid == 2 then
		self.swim = true
	end
	
	if name == "water" then
		self.swim = true
	end
	end
	
	if self.swim then
	if self.swim and name == "lava" and v.liquid == 2 then
		self.swim = true
		v.passive = true
	end
	
	if name == "water" then
		self.swim = true
	end
	end
	
	if name == "lever" and not self.inAir then
		v.quad = 2
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		v.push = not v.push
	end
	
if name == "exit" and not self.dying and self.finishsnd == 0  then
		music:stop(currentlevelmusic)
		self.image = finish
		self.active = false
			finishlevel = true
			if self.finishsnd == 0 then
			playsound(finishmusic)
			self.finishsnd = 1
			end
	if finishmusic:isStopped() then
		if not self.completed then
			nextlevel()
			self.completed = true
		end
	end
	
end

	if name == "key" then
		self.haskey = true
		v.kill = true
	end
	if name == "gate" then
		if self.haskey then
			v.kill = true
			self.haskey = false
		end
	end
	if name == "teleporter" and v.types == "enter" then
		for i, w in pairs(objects["teleporter"]) do
			if w.name == v.name and w.types == "exit" then
				v.teleporter = i
				v.parent = self
				playsound(teleportsnd)
			end
		end
	end
	if name == "crate" and self.dir == "right" then
		v.x = v.x + 30*scale*0.01666667
	end
	
end

function turtle:leftcollide(v, name)
	if name == "coin" then
		v.remove = true
		playsound(coins)
		if not self.collect then
		self:addcoins()
		end
	end
	
	if (name == "trigger") and v.push == false then
		v.active = false
		for i, w in pairs(objects["door"]) do
			if w.name == v.name then
				v.door = i
				break
			end
		end
		
		for i, w in pairs(objects["fakewall"]) do
			if w.name == v.name then
				v.fakewall = i
				break
			end
		end

		for i, w in pairs(objects["invisowall"]) do
			if w.name == v.name then
				v.invisowall = i
				break
			end
		end
		v.push = true
	end
	
	if not self.swim then
	if name == "lava" and v.liquid == 2 then
		self.swim = true
		v.passive = true
	end
	
	if self.swim and name == "lava" and v.liquid == 2 then
		self.swim = true
	end
	
	if name == "water" then
		self.swim = true
	end
	end
	
	if self.swim then
	if self.swim and name == "lava" and v.liquid == 2 then
		self.swim = true
		v.passive = true
	end
	
	if name == "water" then
		self.swim = true
	end
	end
	
	if name == "exit" and not self.dying then
		music:stop(currentlevelmusic)
		self.image = finish
		self.active = false
			finishlevel = true
			if self.finishsnd == 0 then
				playsound(finishmusic)
				self.finishsnd = 1
			end
		if finishmusic:isStopped() then
			if not self.completed then
				nextlevel()
				self.completed = true
			end
		end
	end
	
	if name == "key" then
		self.haskey = true
		v.kill = true
	end
	if name == "gate" then
		if self.haskey then
			v.kill = true
			self.haskey = false
		end
	end
	if name == "teleporter" and v.types == "enter" then
		for i, w in pairs(objects["teleporter"]) do
			if w.name == v.name and w.types == "exit" then
				v.teleporter = i
				v.parent = self
				playsound(teleportsnd)
			end
		end
	end
	if name == "crate" and self.dir == "left" then
		v.x = v.x - 30*scale*0.01666667
	end
end

function turtle:die(reason) --Die
	print("turtle died because of " .. reason)
	self.active = false
	self.dying = true
	playsound(death)
	self:respawn()
	conditions(1)
end

function turtle:gameover()
	self.active = false
	self.dying = true
	self.image = dead
	self:ends()
end

function turtle:ends()
	playsound(gameover)
end

function turtle:respawn() --Teleport back in multiplayer
	self.x = self.oldx
	self.y = self.oldy
	self.lives = self.lives - 1
	self.dying = false
	self.active = true
	if self.lives <= 0 then
		self.image = dead
	end
	gamexscroll = 48
end

function turtle:move(dt)
	if love.keyboard.isDown(rightcontrol[self.playernumber]) and self.active and not self.teleporting then
		self.x = self.x + 60*scale*dt
		self.dir = "right"
	end
	if love.keyboard.isDown(leftcontrol[self.playernumber]) and self.active and not self.teleporting then
		self.x = self.x - 60*scale*dt
		self.dir = "left"
	end
	--Adds friction for a general slowdonw.
	if not love.keyboard.isDown(rightcontrol[self.playernumber]) and not love.keyboard.isDown(leftcontrol[self.playernumber]) then
		self.xSpeed = self.xSpeed * (1 - math.min(dt*self.friction, 1)) --Even more slow down
		self.walk = 0
	end

	if self.xSpeed > self.maximumspeed then
		self.xSpeed = self.maximumspeed
	end

	if self.xSpeed < -self.maximumspeed then
		self.xSpeed = -self.maximumspeed
	end
	
	if self.onladder and (love.keyboard.isDown(upcontrol[self.playernumber]) == false and love.keyboard.isDown(downcontrol[self.playernumber]) == false) and self.active and not self.teleporting then
		self.ySpeed = 0
	end

	if (love.keyboard.isDown(rightcontrol[self.playernumber]) or love.keyboard.isDown(leftcontrol[self.playernumber])) and self.active and not self.teleporting and not  self.inAir and not self.pushing then
		self.walk = self.walk + 30*dt
		if self.walk >= 0 and self.walk < 3 then
			self.image = standright
		elseif self.walk >= 3 and self.walk < 5 then
			self.image = walk1	
		elseif self.walk >= 5 and self.walk < 7 then
			self.image = walk2	
		elseif self.walk >= 7 and self.walk < 9 then
			self.image = walk3
		end
		if self.walk >= 6 then
			self.walk = 0
		end
	end
	
	if (love.keyboard.isDown(rightcontrol[self.playernumber]) or love.keyboard.isDown(leftcontrol[self.playernumber])) and self.active and not self.teleporting and not  self.inAir and self.pushing then
		self.walk = self.walk + 30*dt
		if self.walk >= 0 and self.walk < 3 then
			self.image = standright
		elseif self.walk >= 3 and self.walk < 5 then
			self.image = push1	
		elseif self.walk >= 5 and self.walk < 7 then
			self.image = push2	
		elseif self.walk >= 7 and self.walk < 9 then
			self.image = push3
		end
		if self.walk >= 6 then
			self.walk = 0
		end
	end
	
	
	if (love.keyboard.isDown(rightcontrol[self.playernumber]) == false and love.keyboard.isDown(leftcontrol[self.playernumber]) == false and not love.keyboard.isDown(upcontrol[self.playernumber]) and not love.keyboard.isDown(downcontrol[self.playernumber])) and self.onladder == false and self.active and not self.teleporting and not self.inAir then
		   self.image =  standright
	end
	
	if  self.inAir then
		self.image = jump
	end
	
	if love.keyboard.isDown(upcontrol[self.playernumber]) and not love.keyboard.isDown(downcontrol[self.playernumber]) and self.active and not self.teleporting and self.onladder then
		if self.ySpeed == 0 then
			self.ySpeed = -2 - (50*scale)
		end
		self.walk = self.walk + 30*dt
		if self.walk >= 0 and self.walk < 3 then
			self.image = climb1
		elseif self.walk >= 3 and self.walk < 5 then
			self.image = climb2
		end
		if self.walk >= 5 then
			self.walk = 0
		end
	end
	
	if love.keyboard.isDown(downcontrol[self.playernumber]) and not love.keyboard.isDown(upcontrol[self.playernumber])  and self.active and not self.teleporting and self.onladder then
		if self.ySpeed == 0 then
			self.ySpeed = 2 + (50*scale)
		end
		self.walk = self.walk + 30*dt
		if self.walk >= 0 and self.walk < 3 then
			self.image = climb1
		elseif self.walk >= 3 and self.walk < 5 then
			self.image = climb2
		end
		if self.walk >= 5 then
			self.walk = 0
		end
	end
	
	
	if self.active then
		self.x = self.x + math.min(self.xSpeed * dt)
	end
	
	
	
end