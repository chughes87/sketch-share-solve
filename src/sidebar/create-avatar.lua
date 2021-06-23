class("CreateAvatarSidebar").extends(Sidebar)

function CreateAvatarSidebar:init()
	CreateAvatarSidebar.super.init(self)
end

function CreateAvatarSidebar:enter(context)
	local config = {
		menuItems = {
			{
				text = "Save",
				exec = function()
					self.onSave()
				end
			},
			{
				text = "Invert colors",
				exec = function()
					context.screen:invertBoard()
				end
			}
		}
	}

	CreateAvatarSidebar.super.enter(
		self,
		config,
		not playdate.isCrankDocked(),
		createAvatarPreview(context.level)
	)
end