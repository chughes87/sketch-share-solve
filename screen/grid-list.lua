local gfx <const> = playdate.graphics

class("GridList").extends(Screen)

function GridList:init()
	GridList.super.init(self)
	self.level = 1

	self.sidebar = Sidebar()
	self.sidebar.onNavigated = function (index)
		self.level = index
	end
	self.sidebar.onSelected = function ()
		self.onSelectedLevel(self.level)
	end
end

function GridList:enter(context)
	local menuItems = {}
	for i = 1, rawlen(LEVELS) do
		table.insert(menuItems, {
			text = "Level " .. i
		})
	end
	local sidebarConfig = {
		topText = "Playing",
		menuItems = menuItems
	}
	self.sidebar:enter(sidebarConfig, not playdate.isCrankDocked(), context.player, 4)
end

function GridList:leave()
	self.sidebar:leave()
end

function GridList:crankDocked()
	self.sidebar:close()
end

function GridList:crankUndocked()
	self.sidebar:open()
end

function GridList:cranked(change, acceleratedChange)
	self.sidebar:cranked(change, acceleratedChange)
end

function GridList:AButtonDown()
	self.sidebar:AButtonDown()
end
