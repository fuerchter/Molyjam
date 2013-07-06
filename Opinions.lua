Opinions = {}
Opinions.__index = Opinions

setmetatable(Opinions, {
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

--creates an entity
function Opinions:_init()
	self.list = {}
	
	self.list[1] = "vegetarian"
	self.list[2] = "religious"
	self.list[3] = "hopper"
	self.list[4] = "hipster"
end

function Opinions:getNameById(id)
	return self.list[id]
end

function Opinions:getIdByName(name)
	for index = 1, #self.list do
		if self.list[index] == name
			return index
		end
	end
	
	return 0
end