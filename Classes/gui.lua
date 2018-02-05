gui = class:new()

--A crap ton of gui crammed into 5 functions.



--------------
----WARNING---
--------------

--CODE WILL BURN EYES OUT!

function gui:init(...)
	local arguments = {...}
	if arguments[1] == "button" then -- Button(string), x(number), y(number), width(number), height(number), Text(string), Function(variable), arguments(table), Center(boolean)
		self.x = arguments[2]
		self.y = arguments[3]
		self.width = arguments[4]
		self.height = arguments[5]
		self.text = arguments[6]
		self.hoverover = false
		self.type = "button"
		if arguments[7] then
			self.action = arguments[7]
		end
		if arguments[8] then
			self.actionargs = {}
			self.actionargs = arguments[8]
		end
		self.center = arguments[9]
		self.active = true
		self.border = true
		self.describe = ""
		self.click = true
	elseif arguments[1] == "textbox" then -- Textbox, x, y, width, height, Descriptive, (text) value to take control of, maximum amount of characters, allowed characters
		self.type = "textbox"
		self.x = arguments[2]
		self.y = arguments[3]
		self.width = arguments[4]
		self.height = arguments[5]
		self.describe = arguments[6]
		self.text = arguments[7]
		self.limit = arguments[8]
		self.characters = arguments[9]
		self.hoverover = false
		self.selected = false
		self.items = arguments[7]
		self.blinktimer = 0
		self.active = true
		self.showtext = true
		self.center = true
		self.click = true
	elseif arguments[1] == "getbutton" then --Getbutton, x, y, width, height, descriptive, text, 
		self.type = "getbutton"
		self.x = arguments[2]
		self.y = arguments[3]
		self.width = arguments[4]
		self.height = arguments[5]
		self.describe = arguments[6]
		self.text = arguments[7]
		self.hoverover = false
		self.selected = false
		self.active = true
		self.click = true
	elseif arguments[1] == "flashybutton" then --Type, x, y, width, height, text, direction, function, args
		self.type = "flashybutton"
		self.x = arguments[2]
		self.y = arguments[3]
		self.width = arguments[4]
		self.height = arguments[5]
		self.text = arguments[6]
		self.direction = arguments[7]
		self.action = arguments[8]
		if arguments[9] then
			self.actionargs = {}
			self.actionargs = arguments[9]
		end
		self.hoverover = false
		self.active = true
		self.selecttimer = 0
		self.selectedlength = 0
		self.click = true
	elseif arguments[1] == "dropdown" then --Dropdown, x, y, width, height, text, textes (table),
		self.type = "dropdown"
		self.x = arguments[2]
		self.y = arguments[3]
		self.width = arguments[4]
		self.height = arguments[5]
		self.text = arguments[6]
		self.items = arguments[7]
		self.value = self.items[1]
		self.active = true
		self.hoverover = {}
		self.hoverover[1] = false
		for i = 1, #self.items do
			self.hoverover[i+1] = false
		end
		self.open = false
		self.rightclick = false
		self.actualy = self.y
		if self.y + self.height * #self.items > love.graphics.getHeight() then
			self.y = love.graphics.getHeight() - self.height * (#self.items + 2)
		end
		self.click = true
		self.kill = false
	end
end

function gui:update(dt)
	if self.active then
		local x2 = 0
		local x = 0
		local y = love.mouse.getY()
		if self.type ~= "dropdown" then
			if gamestate == "menu" then
				if menustate == "select" then
					x2 = love.mouse.getX()
					x = self.x - menuscroll
				else
					x2 = love.mouse.getX()
					x = self.x
				end
			elseif gamestate ~= "menu" then
				x2 = properx
				x = self.x
			end
			if x2 > x and x2 < self.width + x and propery > self.y and propery < self.y + self.height then --Inside block
				if self.level then --Levels
					if self.level <= currentlevel then
						self.hoverover = true
					else
						self.hoverover = false
					end
				else
					self.hoverover = true
				end
				if self.type == "flashybutton" then --Move bars in
					self.selectedlength = self.selectedlength + (((self.width/2)) * dt)
					if self.selectedlength > self.width/2 then
						self.selectedlength = self.width/2
					end
				end
			else
				self.hoverover = false --Move bars out
				if self.type == "flashybutton" then
					self.selectedlength = self.selectedlength - (150 * dt)
					if self.selectedlength < 0 then
						self.selectedlength = 0
					end
				end
			end
			if self.type == "textbox" then --Write text
				if self.selected then
					if love.keyboard.isDown("backspace") then
						self.text = string.sub(self.text, 1, -2)
						if string.len(self.text) < self.limit then
							self.full = false
						end
					end
					self.blinktimer = self.blinktimer + dt
					if self.blinktimer < 0.7 then
						self.blinking = true
					elseif self.blinktimer > 0.7 then
						self.blinking = false
					end
					if self.blinktimer > 1.5 then self.blinktimer = 0 end
				end
			end
		else
			local x = love.mouse.getX()
			for i = 1, #self.items + 1 do
				if x > self.x-drawingx and x < self.x-drawingx + self.width and propery > self.y + ((i-1)*self.height) and propery < self.y + (i*self.height) then
					self.hoverover[i] = true
				else
					self.hoverover[i] = false
				end
			end
		end
	end
end

function gui:draw()
	if self.active then
		if self.type == "button" then
			if self.level then --Draw the level background
				if currentlevel > self.level then
					love.graphics.setColor(228, 214, 0)
					love.graphics.rectangle("fill", self.x + 3, self.y + 3, self.width - 3, self.height - 3)
				end
				if currentlevel == self.level then
					love.graphics.setColor(100, 100, 100)
					love.graphics.rectangle("fill", self.x + 3, self.y + 3, self.width - 3, self.height - 3)
				end
				if currentlevel < self.level then
					love.graphics.setColor(50, 50, 50)
					love.graphics.rectangle("fill", self.x + 3, self.y + 3, self.width - 3, self.height - 3)
				end
			end
			if self.backgroundcolor then
				love.graphics.setColor(self.backgroundcolor)
				love.graphics.rectangle("fill", self.x + 3, self.y + 3, self.width - 3, self.height - 3)
			end
			
			if self.hoverover then --Blue or grey line
				love.graphics.setColor(0, 81, 255)
			elseif not self.hoverover then
				love.graphics.setColor(122, 122, 122)
			end
			if self.linewidth then
				love.graphics.setLineWidth(self.linewidth)
			else
				love.graphics.setLineWidth(6)
			end
			if self.border then
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height) --Outline
			end
			if self.textcolor then
				love.graphics.setColor(self.textcolor)
			else
				love.graphics.setColor(0, 0, 0)
			end
			if self.center then --Text
				love.graphics.print(self.text, self.x + ((self.width/3.2) - (string.len(self.text)*2)) - string.len(self.text) * 2, self.y + self.height/5)
			else
				love.graphics.print(self.text, self.x + 10, self.y + self.height-100/2)
			end
		end
		if self.type == "textbox" then
			
			if self.hoverover or self.selected then --Color outline
				love.graphics.setColor(0, 81, 255)
			elseif not self.hoverover or not self.selected then
				love.graphics.setColor(122, 122, 122)
			end
			
			love.graphics.setLineWidth(3)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height) --Outer rectangle
			
			if self.textcolor then
				love.graphics.setColor(self.textcolor)
				
			else
				love.graphics.setColor(0, 0, 0)
			end
			
			--love.graphics.print(self.text, self.x + 10, self.y + self.height/2)
			love.graphics.push()
			love.graphics.pop()
			
			if self.showtext then -- Text
				love.graphics.print(self.describe, self.x + ((self.width/2) - string.len(self.describe)*5), self.y - self.height/2)
			end
			
				
			
			if self.full and self.showtext then
				love.graphics.print("Character limit reached", self.x + self.width + 30, self.y)
			end
			
			if self.center then
				love.graphics.print(self.text, self.x + ((self.width/2) - (string.len(self.text)*5)), self.y + self.height/2)
			else
				love.graphics.print(self.text, self.x + 10, self.y + self.height/2)
			end
			
			
		end
		if self.type == "getbutton" then
			if self.hoverover or self.selected then
				love.graphics.setColor(0, 81, 255)
			else
				love.graphics.setColor(122, 122, 122)
			end
			love.graphics.setLineWidth(6)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(self.describe, self.x + ((self.width/2) - string.len(self.describe)*5), self.y - self.height/2)
			if self.center then
				love.graphics.print(self.text, self.x + ((self.width/2) - (string.len(self.text)*5)), self.y + self.height/2)
			else
				love.graphics.print(self.text, self.x + 10, self.y + self.height/2)
			end
		end
		if self.type == "flashybutton" then --Text
			if not self.textcolor then
				love.graphics.setColor(textcolor[1], textcolor[2], textcolor[3])
			else
				love.graphics.setColor(self.textcolor)
			end
			love.graphics.print(self.text, self.x + ((self.width/2) - (string.len(self.text)*10)), self.y + self.height/2)
		elseif self.type == "dropdown" then
			if self.hoverover[1] or self.open then
				love.graphics.setColor(0, 81, 255)
			elseif not self.hoverover[1] and not self.open then
				love.graphics.setColor(122, 122, 122)
			end
			love.graphics.setLineWidth(3)
			love.graphics.rectangle("fill", self.x, self.y, self.width - (30*scale), self.height)
			love.graphics.rectangle("fill", self.x + self.width - (30*scale), self.y, 30*scale, self.height)
			if self.open then
				for i = 1, #self.items do
					if self.hoverover[i+1] then
						love.graphics.setColor(0, 81, 255)
					else
						love.graphics.setColor(122, 122, 122)
					end
					love.graphics.rectangle("fill", self.x, self.y + self.height * i, self.width, self.height)
					love.graphics.setColor(0, 0, 0)
					love.graphics.print(self.items[i], self.x + ((self.width/2) - (string.len(self.text)*5)), self.y + self.height * i + self.height/2)
				end
			end
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(dropdownimage, self.x + self.width - (30*scale), self.y + (10*scale), 0, 1.8*scale)
			--love.graphics.setFont(smallfont)
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(self.value, self.x + ((self.width/2) - (string.len(self.text)*10)), self.y + self.height/2)
		end
	end
end

function gui:mousepressed(x, y, button)
	if self.active then
		if not self.open then
			if self.type == "dropdown" then
				x2 = self.x - drawingx
			else
				x2 = self.x
			end
			if menuscroll then
				if menustate == "select" then
					x2 = self.x - menuscroll
				end
			end
			if x > x2 and x < x2 + self.width and propery > self.y and propery < self.y + self.height then --Inside
				
				if self.type == "button" or self.type == "flashybutton" and self.action then
					if self.click then
					if self.actionargs then
						if self.level then --Unlock level
							if self.level <= currentlevel then
								self.action(unpack(self.actionargs))
							end
						else
							self.action(unpack(self.actionargs))
						end 
					else --Actions and stuff
						if self.level then
							if self.level <= currentlevel then
								self.action()
							end
						else
							self.action()
						end
					end
				end
				elseif self.type == "textbox" then
					self.selected = true
				elseif self.type == "getbutton" then
					self.selected = true
				elseif self.type == "dropdown" then
					self.open = true
				end
			else
				if self.type == "textbox" then
					self.selected = false
					self.blinking = false
				end
				if self.type == "getbutton" then
					self.selected = false
				end
			end
			x2 = nil
		else
			for i = 1, #self.items do
				if x > self.x-drawingx and x < self.x-drawingx + self.width and propery > self.y + (i*self.height) and propery < self.y + ((i+1) * self.height) then
					self.value = self.items[i]
					self.open = false
					self.kill = true
				end
			end
			if x > self.x-drawingx and x < self.x-drawingx + self.width and propery > self.y and propery < self.y + self.height then
				self.open = false
			end
		end
	end
end

function gui:keypressed(key, unicode)
	if self.active then
		if self.type == "textbox" and self.selected then --A bunch of textbox stuff
			if self.characters == "all" then
				if unicode > 31 and unicode < 127 and not self.full then
					self.text = self.text .. string.char(unicode)
					if string.len(self.text) == self.limit then
						self.full = true
					end
				end
			elseif self.characters == "letters" then
				if unicode > 31 and unicode < 48 or unicode > 57 and unicode < 127 and not self.full then
					self.text = self.text .. string.char(unicode)
					if string.len(self.text) == self.limit then
						self.full = true
					end
				end
			elseif self.characters == "numbers" then
				if unicode > 47 and unicode < 58 and not self.full then
					self.text = self.text .. string.char(unicode)
					if string.len(self.text) == self.limit then
						self.full = true
					end
				end
			end
			if key == "backspace" then
				self.text = string.sub(self.text, 1, -2)
				if string.len(self.text) < self.limit then
					self.full = false
				end
			end
		end
		if self.type == "getbutton" and self.selected then
			self.text = key
			self.selected = false
		end
	end
end

