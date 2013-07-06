Quote = {}
Quote.__index = Quote

setmetatable(Quote, {
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

function Quote:_init(text, influence)
	self.text=text

	self.influence=influence
	--[[self.influence={}
	self.influence[1]=1
	self.influence[2]=1
	self.influence[3]=0
	self.influence[4]=0]]
end

function Quote:update(dt)

end

function Quote:draw()
	
end