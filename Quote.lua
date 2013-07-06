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
end

function Quote:update(dt)

end

function Quote:draw()
	
end