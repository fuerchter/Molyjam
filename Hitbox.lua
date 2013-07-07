Hitbox = {}
Hitbox.__index = Hitbox

setmetatable(Hitbox, {
	__call = function (cls, ...)
				local self = setmetatable({}, cls)
				self:_init(...)
				return self
			end,
})

--position is upper-left corner
function Hitbox:_init(position, width, height)
	self.position = position
	self.width = width
	self.height = height
end

function Hitbox:doesOverlapWith(hitbox)
	local x_overlap = false
	local y_overlap = false

	if self.position.x < hitbox.position.x and self.position.x + self.width > hitbox.position.x then
		x_overlap = true
	elseif self.position.x < hitbox.position.x + hitbox.width and self.position.x + self.width > hitbox.position.x + hitbox.width then
		x_overlap = true
	end
	
	if self.position.y < hitbox.position.y and self.position.y + self.height > hitbox.position.y then
		y_overlap = true
	elseif self.position.y < hitbox.position.y + hitbox.height and self.position.y + self.height > hitbox.position.y + hitbox.height then
		y_overlap = true
	end
	
	return (x_overlap and y_overlap)
end