local gfx <const> = playdate.graphics

function drawPaddedRect(x, y, w, h)
	-- outline
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, w, h)
	-- padding
	gfx.setColor(gfx.kColorBlack)
	gfx.setDitherPattern(0.5)
	gfx.fillRect(x + 2, y + 2, w - 4, h - 4)
  gfx.setColor(gfx.kColorBlack)
	gfx.drawLine(x + 23, y + 2, x + 23, y + h - 2)
	gfx.drawLine(x + 2, y + h - 3, x + w - 2, y + h - 3)
end

function drawStripedRect(x, y, w, h)
	-- outline
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, w, h)
	-- stripes
	gfx.setColor(gfx.kColorBlack)
	gfx.setDitherPattern(0.8, gfx.image.kDitherTypeDiagonalLine)
	gfx.fillRect(x + 2, y + 2, w - 4, h - 4)
end

function drawRightTextRect(x, y, w, h, text)
	-- outline
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, w, h)
	-- text
	gfx.setFont(fontText)
	local width = gfx.getTextSize(text)
	gfx.drawText(text, x + w - width - 5, y + 6)
end

function drawAvatar(x, y, id)
	gfx.setColor(gfx.kColorBlack)
	gfx.drawRect(x, y, 26, 26)
	gfx.drawRect(x + 2, y + 2, 22, 22)
	imgAvatars:getImage(id):drawScaled(x + 3, y + 3, 2)
end
