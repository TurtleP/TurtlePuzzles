--main.lua (love.load)
ach = { {deaths == 10,50,1,"Die 10 times","It was an accident!"}, {emeralds == 5,100,2,"Collect 5 Emeralds","Emerald digger"}, {bounces == 10, 50, 3, "Bounce on springs 10 times", "Too Much Fun"}}

achcompleted = {false, false, false}
--end

--game.lua--
function unlock(c, a) --coins to give, achievement
	if achcompleted[a] == false then
		addcoins(c)
		print("okay--")
		achcompleted[a] = true
	end
	print("!")
end

function conditions(dt) --how to unlock achievements
	for i = 1, #ach do
		if not ach[i][1] then
			unlock(ach[i][2],ach[i][3])
			print("!")
		end
	end
end

function addcoins(c)
	turtlecoins = turtlecoins+c
end

function game_update(dt)

conditions(dt)

end
--end