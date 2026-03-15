-->> Color6.lua
--> A group of Color3 functions from various devs packed in one single module
--> Made by Marcos @malcosrub


export type Dictionary<K, V> = ({ [K]: V })
export type Array<T> = (Dictionary<number, T>)



local min = math.min
local max = math.max
local floor = math.floor
local clamp = math.clamp
local band = bit32.band
local rshift = bit32.rshift
local lshift = bit32.lshift



local Color6 = {Blend = {}, Palette = {}}

local function transformValue(value: number): number
	return value <= .03928 and value / 12.92 or ((value + .055) / 1.055) ^ 2.4
end


function GetLuminance(color: Color3): number

	local red = transformValue(color.R)
	local green = transformValue(color.G)
	local blue = transformValue(color.B)

	local lum = .2126 * red + .7152 * green + .0722 * blue

	return lum
end



function Darken(color: Color3, coefficient: number): Color3
	return color:Lerp(Color3.new(), coefficient)
end

function Lighten(color: Color3, coefficient: number): Color3
	return color:Lerp(Color3.new(1,1,1), coefficient)
end



function Emphasise(color: Color3, coefficient: number, threshold: number?): Color3
	return GetLuminance(color) > threshold and Darken(color, coefficient) or Lighten(color, coefficient)
end



function GetContrastRatio(foreground: Color3, background: Color3): number
	local lumA = GetLuminance(foreground)
	local lumB = GetLuminance(background)

	return (max(lumA, lumB) + .05) / (min(lumA, lumB) + .05)
end



function PerceivedBrightness(color: Color3): number
	local red = color.R * 255
	local green = color.G * 255
	local blue = color.B * 255

	local bright = ((red * 299 + green * 587 + blue * 114) / 1000) / 255

	return bright
end





function Clamp(color: Color3): Color3
	local red = clamp(color.R, 0, 1)
	local green = clamp(color.G, 0, 1)
	local blue = clamp(color.B, 0, 1)

	return Color3.new(red, green, blue)
end





function FromInt(int: number): Color3
	int = floor(int)

	local red = band(rshift(int, 16), 255)
	local green = band(rshift(int, 8), 255)
	local blue = band(int, 255)

	return Clamp(Color3.fromRGB(red, green, blue))
end

function ToInt(color: Color3): number

	local int = floor(color.R * 255)
	int = lshift(int, 8) + floor(color.G * 255)
	int = lshift(int, 8) + floor(color.B * 255)

	return int
end





function Invert(color: Color3): Color3
	local inverse = Color3.new(
		1 - color.R,
		1 - color.G,
		1 - color.B
	)

	return Clamp(inverse)
end



function IsDark(color: Color3): boolean
	return GetLuminance(color) < 0.5
end

function IsLight(color: Color3): boolean
	return not IsDark(color)
end



function Rotate(color: Color3, angle: number)

	local hue, sat, val = color:ToHSV()
	local newHue = clamp((hue + (angle / 360)) % 1, 0, 1)

	local newColor = Color3.fromHSV(newHue, sat, val)

	return Clamp(newColor)
end



function CustomFilter(background:Color3, foreground: Color3, filterFunc: (number, number) -> number): (Color3, Color3) -> Color3

	local newColor = Color3.fromRGB(
		filterFunc(background.R, foreground.R),
		filterFunc(background.G, foreground.G),
		filterFunc(background.B, foreground.B)
	)

	return Clamp(newColor)
end





function Color6.Blend.Multiply(background:Color3, foreground: Color3): Color3
	return CustomFilter(background, foreground, function(bg: number, fg: number): number
		return ((fg * 255) * (bg * 255)) / 255
	end)
end



function Color6.Blend.Burn(background:Color3, foreground: Color3): Color3
	return CustomFilter(background, foreground, function(bg: number, fg: number): number
		local bg = clamp(bg * 255, 0, 255)
		local fg = fg * 255

		return (bg == 0) and bg or max(0, (255 - lshift((255 - fg), 8) / bg))
	end)
end



function Color6.Blend.Dodge(background:Color3, foreground: Color3): Color3
	return CustomFilter(background, foreground, function(bg: number, fg: number): number
		local bg = clamp(bg * 255, 0, 255)
		local fg = fg * 255

		return (bg == 255) and bg or min(255, lshift(fg, 8) / (255 - bg))
	end)
end



function Color6.Blend.Screen(background:Color3, foreground: Color3): Color3
	return CustomFilter(background, foreground, function(bg: number, fg: number): number
		return 255 - rshift(((255 - (foreground * 255)) * (255 - (background * 255))), 8)
	end)
end



function Color6.Blend.Overlay(background:Color3, foreground: Color3): Color3
	return CustomFilter(background, foreground, function(bg: number, fg: number): number
		local bg = bg * 255
		local fg = fg * 255

		return (bg < 128) and (2 * fg * bg / 255) or (255 - 2 * (255 - bg) * (255 - fg) / 255)
	end)
end




function Color6.Palette.Analogous(base: Color3): Array<Color3>
	return {
		Rotate(base, -30),
		Rotate(base, 30),
	}
end

function Color6.Palette.Complementary(base: Color3): Array<Color3>
	return {
		Rotate(base, 180)
	}
end

function Color6.Palette.Monochromatic(base: Color3): Array<Color3>
	return {
		Lighten(base, .5),
		Darken(base, .5)
	}
end

function Color6.Palette.SplitComplementary(base: Color3): Array<Color3>
	return {
		Rotate(base, 180 - 30),
		Rotate(base, 180 + 30),
	}
end

function Color6.Palette.Tetradic(base: Color3): Array<Color3>
	return {
		Rotate(base, -180),
		Rotate(base, -120),
		Rotate(base, -300),
	}
end

function Color6.Palette.Vibrant(base: Color3): Array<Color3>
	return {
		Rotate(base, 180 - 30),
		Rotate(base, 180 + 30),
	}
end




Color6.fromHex = Color3.fromHex
Color6.fromHSV = Color3.fromHSV
Color6.fromRGB = Color3.fromRGB
Color6.new = Color3.new
--Color6.toHSV = Color3.toHSV

Color6.GetLuminance = GetLuminance
Color6.Darken = Darken
Color6.Lighten = Lighten
Color6.Emphasise = Emphasise
Color6.GetContrastRatio = GetContrastRatio
Color6.GetPerceivedBrightness = PerceivedBrightness
Color6.Clamp = Clamp
Color6.fromInt = FromInt
Color6.toInt = ToInt
Color6.Invert = Invert
Color6.IsDark = IsDark
Color6.IsLight = IsLight
Color6.Rotate = Rotate
Color6.CustomFilter = CustomFilter

return Color6;