Opinions = {
				[1] = "vegetarian"
				[2] = "religious"
				[3] = "hopper"
				[4] = "hipster"
			}

function Opinions:getNameById(id)
	return self[id]
end

function Opinions:getIdByName(name)
	for index = 1, #self do
		if self[index] == name
			return index
		end
	end
	
	return 0
end