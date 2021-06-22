local gfx <const> = playdate.graphics

class("Board").extends(gfx.sprite)

function Board:init()
	Board.super.init(self)

	self.image = gfx.image.new(400, 240, gfx.kColorClear)
	self:setImage(self.image)
	self:setCenter(0, 0)
	self:moveTo(CELL * BOARD_OFFSET_X, CELL * BOARD_OFFSET_Y)
	self:setZIndex(5)

	self.onUpdateSolution = function() end

	self.cursor = Cursor()
end

function Board:enter(level, mode)
	self.last = 0
	self.level = level
	self.mode = mode

	self.solution = {}
	self.crossed = {}
	for y = 1, self.level.height do
		for x = 1, self.level.width do
			local index = x - 1 + (y - 1) * self.level.width + 1
			self.solution[index] = self.mode == MODE_CREATE and level.grid[index] or 0
			self.crossed[index] =
				self.mode == MODE_PLAY and level:isCellKnownEmpty(x, y) and 1
				or 0
		end
	end

	self:add()
	self.cursor:enter(level)

	self:redraw()
end

function Board:leave()
	self:remove()
	self.cursor:leave()
end

function Board:toggle(index, isStart)
	if self.crossed[index] == 0 and (isStart or self.solution[index] ~= self.last) then
		self.solution[index] = self.solution[index] == 1 and 0 or 1
		self.last = self.solution[index]
		self:redraw()
		self.onUpdateSolution(self.solution)
	end
end

function Board:toggleCross(index, isStart)
	if self.solution[index] == 0 and (isStart or self.crossed[index] ~= self.last) then
		self.crossed[index] = self.crossed[index] == 1 and 0 or 1
		self.last = self.crossed[index]
		self:redraw()
	end
end

function Board:invert()
	for i = 1, #self.solution do
		self.solution[i] = self.solution[i] == 1 and 0 or 1
	end
	self.onUpdateSolution(self.solution)
	self:redraw()
end

function Board:getCursor()
	return self.cursor:getIndex()
end

function Board:moveBy(dx, dy)
	self.cursor:moveBy(dx, dy)
	self:redraw()
end

function Board:hideCursor()
	self.cursor:leave()
end

function Board:redraw()
	local isSolved = self.mode == MODE_PLAY and self.level:isSolved(self.solution)
	self.image:clear(gfx.kColorClear)
	gfx.lockFocus(self.image)
	do
		-- lines
		if isSolved then
			gfx.setColor(gfx.kColorBlack)
			gfx.drawRect(0, 0, CELL * self.level.width + 1, CELL * self.level.height + 1)
		else
			for x = 0, self.level.width do
				gfx.setColor(gfx.kColorBlack)
				gfx.setDitherPattern((isSolved or x % 5 == 0) and 0 or 0.5)
				gfx.drawLine(
					CELL * x,
					0,
					CELL * x,
					CELL * self.level.height + 1
				)
			end
			for y = 0, self.level.height do
				gfx.setColor(gfx.kColorBlack)
				gfx.setDitherPattern((isSolved or y % 5 == 0) and 0 or 0.5)
				gfx.drawLine(
					0,
					CELL * y,
					CELL * self.level.width + 1,
					CELL * y
				)
			end
		end

		-- cells
		gfx.setFont(fontGrid)
		for y = 1, self.level.height do
			for x = 1, self.level.width do
				gfx.setDrawOffset(CELL * (x - 1) + 1, CELL * (y - 1) + 1)
				local index = x - 1 + (y - 1) * self.level.width + 1
				if isSolved then
					if self.solution[index] == 1 then
						gfx.setColor(gfx.kColorBlack)
						gfx.fillRect(0, 0, CELL, CELL)
					end
				else
					if self.solution[index] == 1 then
						imgBoard:drawImage(2, 0, 0)
					elseif self.crossed[index] == 1 then
						imgBoard:drawImage(1, 0, 0)
					end
				end
			end
		end
	end
	gfx.unlockFocus()
	self:markDirty()
end
