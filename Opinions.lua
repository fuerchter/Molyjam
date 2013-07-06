Opinions = {
				[1] = "vegetarian",
				[2] = "religious",
				[3] = "hopper",
				[4] = "hipster"
			}

function Opinions.getNameById(id)
	return Opinions[id]
end

function Opinions.getIdByName(name)
	for index = 1, #Opinions do
		if Opinions[index] == name then
			return index
		end
	end
	
	return 0
end