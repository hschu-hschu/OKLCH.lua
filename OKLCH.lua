-- ModuleScript: OKLCH.lua
local OKLCH = {}

local function fInv(t)
	if t > 0.206896552 then
		return (t ^ 3)
	else
		return (t - 0.137931034) / 7.787
	end
end

local function f(t)
	if t > 0.008856 then
		return (t) ^ (1/3)
	else
		return (7.787 * t) + (16/116)
	end
end

-- XYZ <-> Linear RGB Matrix
local M = {
	{  3.2406, -1.5372, -0.4986 },
	{ -0.9689,  1.8758,  0.0415 },
	{  0.0557, -0.2040,  1.0570 }
}

local Mi = {
	{ 0.4124, 0.3576, 0.1805 },
	{ 0.2126, 0.7152, 0.0722 },
	{ 0.0193, 0.1192, 0.9505 }
}

-- Linear RGB ↔ sRGB
local function linearToSRGB(c)
	if c <= 0.0031308 then
		return 12.92 * c
	else
		return 1.055 * (c ^ (1/2.4)) - 0.055
	end
end

local function sRGBToLinear(c)
	if c <= 0.04045 then
		return c / 12.92
	else
		return ((c + 0.055) / 1.055) ^ 2.4
	end
end

-- OKLCH → RGB
function OKLCH.toRGB(L, C, H)
	local hRad = math.rad(H)
	local a = math.cos(hRad) * C
	local b = math.sin(hRad) * C

	local y = (L + 16) / 116
	local x = y + (a / 500)
	local z = y - (b / 200)

	local X = 0.95047 * fInv(x)
	local Y = 1.00000 * fInv(y)
	local Z = 1.08883 * fInv(z)

	-- XYZ -> Linear RGB
	local r = M[1][1]*X + M[1][2]*Y + M[1][3]*Z
	local g = M[2][1]*X + M[2][2]*Y + M[2][3]*Z
	local b_ = M[3][1]*X + M[3][2]*Y + M[3][3]*Z

	-- Linear -> sRGB
	r = math.clamp(linearToSRGB(r), 0, 1)
	g = math.clamp(linearToSRGB(g), 0, 1)
	b_ = math.clamp(linearToSRGB(b_), 0, 1)

	return Color3.new(r, g, b_)
end

-- RGB → OKLCH
function OKLCH.fromRGB(color)
	local r = sRGBToLinear(color.R)
	local g = sRGBToLinear(color.G)
	local b = sRGBToLinear(color.B)

	-- Linear RGB -> XYZ
	local X = Mi[1][1]*r + Mi[1][2]*g + Mi[1][3]*b
	local Y = Mi[2][1]*r + Mi[2][2]*g + Mi[2][3]*b
	local Z = Mi[3][1]*r + Mi[3][2]*g + Mi[3][3]*b

	-- XYZ -> Lab
	local fx = f(X / 0.95047)
	local fy = f(Y / 1.00000)
	local fz = f(Z / 1.08883)

	local L = (116 * fy) - 16
	local a = 500 * (fx - fy)
	local b_ = 200 * (fy - fz)

	local C = math.sqrt(a*a + b_*b_)
	local H = (math.deg(math.atan2(b_, a)) + 360) % 360

	return L, C, H
end

return OKLCH
