class("Profile").extends()

function Profile:init(profile)
	self.id = profile.id
	self.hidden = profile.hidden or false
	self.name = profile.name
	self.created = profile.created
	self.played = profile.played
	self.options = profile.options or {}

	local avatar = playdate.datastore.readImage(AVATAR_FOLDER_NAME .. self.id)
	if avatar then
		self.avatar = avatar
	else
		local id =
			(self.id == PLAYER_ID_RDK and AVATAR_ID_RDK) or
			(self.id == PLAYER_ID_QUICK_PLAY and AVATAR_ID_QUICK_PLAY) or
			AVATAR_ID_NIL
		self.avatar = imgAvatars:getImage(id)
	end
end

function Profile:save(context)
	local profile = {
		id = self.id,
		hidden = self.hidden,
		name = self.name,
		created = self.created,
		played = self.played,
		options = self.options
	}

	context.save.profiles[self.id] = profile

	local hasProfile = false
	for _, id in pairs(context.save.profileList) do
		if id == profile.id then
			hasProfile = true
		end
	end

	if not hasProfile then
		table.insert(context.save.profileList, self.id)
	end

	playdate.datastore.writeImage(self.avatar, AVATAR_FOLDER_NAME .. self.id)
	playdate.datastore.write(context.save)
end

function Profile:delete(context)
	-- hide profile if player has created puzzles
	if #self.created > 0 then
		self.hidden = true
		self:save(context)
	else
		local profileIndex = nil
		for i, id in pairs(context.save.profileList) do
			if id == self.id then
				profileIndex = i
			end
		end

		if profileIndex then
			table.remove(context.save.profileList, profileIndex)
		end
		context.save.profiles[self.id] = nil

		playdate.datastore.write(context.save)
	end
end

function Profile:getNumPlayed()
	local numPlayed = 0
	for _ in pairs(self.played) do
		numPlayed += 1
	end
	return numPlayed
end

function Profile:playedAllBy(creator)
	if self.id == creator.id then
		return true
	end
	for _, id in pairs(creator.created) do
		if not self.played[id] then
			return false
		end
	end
	return true
end

Profile.load = function (context, id)
	return Profile(context.save.profiles[id])
end

function Profile.createEmpty()
	return Profile({
		id = playdate.string.UUID(16),
		hidden = false,
		avatar = AVATAR_ID_NIL,
		name = "Player",
		created = {},
		played = {}
	})
end