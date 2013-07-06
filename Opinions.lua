Opinions = {
				[1] = "vegetarian",
				[2] = "religious",
				[3] = "hopper",
				[4] = "hipster"
			}

function Opinions.getName(id)
	return Opinions[id]
end

function Opinions.getId(name)
	for index = 1, #Opinions do
		if Opinions[index] == name then
			return index
		end
	end
	
	return 0
end