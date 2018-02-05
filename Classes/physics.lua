function resetcollisionoptions()
end

local function aabb(ax1,ay1,aw,ah, bx1,by1,bw,bh)
	local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

local function calculatemtd(v1, v2)
	--UGHHGHGHGHGH
	--LETS DO SOME MATH.
	local v1minx = v1.x --Min = top left
	local v1miny = v1.y
	local v2minx = v2.x
	local v2miny = v2.y
	local v1maxx = v1.x + v1.width -- Max = bottom right
	local v1maxy = v1.y + v1.height
	local v2maxx = v2.x + v2.width
	local v2maxy = v2.y + v2.height
	local abs = math.abs

	--K, we got our first set of values.

	local mtd = {} --Make our mtd table.
	--I don't like math too much anymore

	local left = v2minx - v1maxx
	local right = v2maxx - v1minx
	local up = v2miny - v1maxy
	local down = v2maxy - v1miny
	if left > 0 or right < 0 or up > 0 or down < 0 then --Not colliding. This is the easy part lol.
		return false
	end

	if abs(left) < right then --Determine the collision on both axises? Axis'? I give up. On the x and y axis
		mtd.x = left
	else
		mtd.x = right
	end

	if abs(up) < down then
		mtd.y = up
	else
		mtd.y = down
	end
	if abs(mtd.x) < abs(mtd.y) then
		mtd.y = 0
	else
		mtd.x = 0
	end
	return mtd
end

local function collisionCheck(v1, v2, v1name, v2name, dt)
	local should = true
	local collision
	local horizontal, vertical
	local cancollide = false
	if not v1.mask[v2name] or v1.mask[v2name] == false or v2.mask[v2name] == false then
		cancollide = false
	else
		for i, v in pairs(v1.mask[v2name]) do
			if v == v2name or v == "all" then
				cancollide = true
				break
			end
		end
	end
	if v1name == "block" then
		if v1.x == v2.x then
			return
		end
	end
	if cancollide then
		collision = aabb(v1.x, v1.y, v1.width, v1.height, v2.x, v2.y, v2.width, v2.height)
	end

	local mtd

	
	
	if collision or v1.mask then
		mtd = calculatemtd(v1, v2)
	end

	if mtd then
		if mtd.x ~= 0 then
			horizontal = true
		end
		if mtd.y ~= 0 then
			vertical = true
		end
	end
 
	if v1.mask then
		if horizontal then
		local speed = v1.xSpeed
		if not v2.passive then
			v1.xSpeed = 0 --HOLD UP
			if not v1.static then
				v1.x = v1.x + mtd.x
			end
		end
		if speed >= 0 then --Moving right
			if v1.rightcollide then 
				v1:rightcollide(v2, v2name)
				speed = 0
			end
		end
		if speed <= 0 then
			if v1.leftcollide then
				v1:leftcollide(v2, v2name)
					speed = 0
			end
		end
	end
	if vertical then
		local speed = v1.ySpeed
		if not v2.passive then
			v1.ySpeed = 0
			if not v1.static then
				v1.y = v1.y + mtd.y
			end
		
		if speed <= 0 then
			if v1.upcollide then
				v1:upcollide(v2, v2name)
					speed = -speed
			end
		end
		if speed > 0 then
			if v1.downcollide then
				v1:downcollide(v2, v2name)
					speed = 0
			end
		end
		end
	end
	end
	
	return should
end

local function docollision(dt) --Handles loops for physics. Lot less complicated than it seems.
	for j, w in pairs(objects) do --
		for i, v in pairs(w) do -- Select first objects table
			local thing = true
			if j == "block" then
				if not v.thrown then
					thing = false
				end
			end
			if thing then
				for name, lol in pairs(objects) do --Go through all objects names again
					for __, value in pairs(lol) do -- Goes through second objetcs table.
						local canpass = false
						if j == "block" or j ~= name then
								canpass = true
						end
						if canpass then -- They dont need to collide with themselves.
							local properx = gamexscroll
							if value.x >= v.x - 16*scale*2 and value.x < v.x + v.width + 16*scale*2 then
								collisionCheck(v, value, j, name, dt)
							end
						end
					end 
				end
			end
		end
	end
end

function loadphysics(dt) --Deltatime	Put in game, will load all the physics
	docollision(dt) --Yay collision system that does physics for me
end