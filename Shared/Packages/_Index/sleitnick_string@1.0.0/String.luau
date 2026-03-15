-- String Util
-- Stephen Leitnick
-- December 3, 2019

--[[

	String.Trim(String str)
	String.TrimStart(String str)
	String.TrimEnd(String str)
	String.EqualsIgnoreCase(String str, String compare)
	String.RemoveWhitespace(String str)
	String.RemoveExcessWhitespace(String str)
	String.EndsWith(String str, String endsWith)
	String.StartsWith(String str, String startsWith)
	String.Contains(String str, String contains)
	String.ToCharArray(String str)
	String.ToByteArray(String str)
	String.ByteArrayToString(Table bytes)
	String.ToCamelCase(String str)
	String.ToPascalCase(String str)
	String.ToSnakeCase(String str [, uppercase])
	String.ToKebabCase(String str [, uppercase])
	String.Escape(str)
	String.StringBuilder()

	EXAMPLES:

		Trim:

			Trims whitespace from the start and end of the string.

			String.Trim("  hello world  ") == "hello world"


		TrimStart:

			The same as Trim, but only trims the start of the string.

			String.TrimStart("  hello world  ") == "hello world  "


		TrimEnd:

			The same as Trim, but only trims the end of the string.

			String.TrimEnd("  hello world  ") == "  hello world"


		EqualsIgnoreCase:

			Checks if two strings are equal, but ignores their case.

			String.EqualsIgnoreCase("HELLo woRLD", "hEllo wORLd") == true


		RemoveWhitespace:

			Removes all whitespace from a string.

			String.RemoveWhitespace("  hello World!\n") == "helloWorld!"


		RemoveExcessWhitespace:

			Replaces all whitespace with a single space. This does not trim the string.

			String.RemoveExcessWhitespace("This     is    a   \n  test") == "This is a test"


		EndsWith:

			Checks if a string ends with a certain string.

			String.EndsWith("Hello world", "rld") == true


		StartsWith:

			Checks if a string starts with a certain string.

			String.StartsWith("Hello world", "He") == true


		Contains:

			Checks if a string contains another string.

			String.Contains("Hello world", "lo wor") == true


		ToCharArray:

			Returns a table of all the characters in the string.

			String.ToCharArray("Hello") >>> {"H","e","l","l","o"}


		ToByteArray:

			Returns a table of all the bytes of each character in the string.

			String.ToByteArray("Hello") >>> {72,101,108,108,111}


		ByteArrayToString:

			Transforms an array of bytes into a string.

			String.ByteArrayToString({97, 98, 99}) == "abc"


		ToCamelCase:
		
			Returns a string in camelCase.

			String.ToCamelCase("Hello_world-abc") == "helloWorldAbc"


		ToPascalCase:
		
			Returns a string in PascalCase.

			String.ToPascalCase("Hello_world-abc") == "HelloWorldAbc"


		ToSnakeCase:
		
			Returns a string in snake_case or SNAKE_CASE.

			String.ToPascalCase("Hello_world-abc") == "hello_world_abc"
			String.ToPascalCase("Hello_world-abc", true) == "HELLO_WORLD_ABC"


		ToKebabCase:
		
			Returns a string in kebab-case or KEBAB-CASE.

			String.ToKebabCase("Hello_world-abc") == "hello-world-abc"
			String.ToKebabCase("Hello_world-abc", true) == "HELLO-WORLD-ABC"


		Escape:

			Escapes a string from pattern characters. In other words, it prefixes
			any special pattern characters with a %. For example, the dollar
			sign $ would become %$. See the example below.

			String.Escape("Hello. World$ ^-^") == "Hello%. World%$ %^%-%^"


		StringBuilder:

			Creates a StringBuilder object that can be used to build a string. This
			is useful when a large string needs to be concatenated. Traditional
			concatenation of a string using ".." can be a performance issue, and thus
			StringBuilders can be used to store the pieces of the string in a table
			and then concatenate them all at once.

			local builder = String.StringBuilder()

			builder:Append("world")
			builder:Prepend("Hello ")
			builder:ToString() == "Hello world"
			tostring(builder)  == "Hello world"

--]]


local String = {}

local MAX_TUPLE = 7997


function String.Escape(str)
	local escaped = str:gsub("([%.%$%^%(%)%[%]%+%-%*%?%%])", "%%%1")
	return escaped
end


function String.Trim(str)
	return str:match("^%s*(.-)%s*$")
end


function String.TrimStart(str)
	return str:match("^%s*(.+)")
end


function String.TrimEnd(str)
	return str:match("(.-)%s*$")
end


function String.RemoveExcessWhitespace(str)
	return str:gsub("%s+", " ")
end


function String.RemoveWhitespace(str)
	return str:gsub("%s+", "")
end


function String.EndsWith(str, ends)
	return str:match(String.Escape(ends) .. "$") ~= nil
end


function String.StartsWith(str, starts)
	return str:match("^" .. String.Escape(starts)) ~= nil
end


function String.Contains(str, contains)
	return str:find(contains) ~= nil
end


function String.StringBuilder()
	local sb = {}
	local str = {}
	function sb:Append(s)
		str[#str + 1] = s
	end
	function sb:Prepend(s)
		table.insert(str, 1, s)
	end
	function sb:ToString()
		return table.concat(str, "")
	end
	setmetatable(sb, {__tostring=sb.ToString})
	return sb
end


function String.ToCharArray(str)
	local len = #str
	local chars = table.create(len)
	for i = 1,len do
		chars[i] = str:sub(i, i)
	end
	return chars
end


function String.ToByteArray(str)
	local len = #str
	if (len == 0) then return {} end
	if (len <= MAX_TUPLE) then
		return table.pack(str:byte(1, #str))
	end
	local bytes = table.create(len)
	for i = 1,len do
		bytes[i] = str:sub(i, i):byte()
	end
	return bytes
end


function String.ByteArrayToString(bytes)
	local size = #bytes
	if (size <= MAX_TUPLE) then
		return string.char(table.unpack(bytes))
	end
	local numChunks = math.ceil(size / MAX_TUPLE)
	local stringBuild = table.create(numChunks)
	for i = 1, numChunks do
		local chunk = string.char(table.unpack(bytes, ((i - 1) * MAX_TUPLE) + 1, math.min(size, ((i - 1) * MAX_TUPLE) + MAX_TUPLE)))
		stringBuild[i] = chunk
	end
	return table.concat(stringBuild, "")
end


function String.EqualsIgnoreCase(str1, str2)
	return (str1:lower() == str2:lower())
end


function String.ToCamelCase(str)
	str = str:gsub("[%-_]+([^%-_])", function(s) return s:upper() end)
	return str:sub(1, 1):lower() .. str:sub(2)
end


function String.ToPascalCase(str)
	str = String.ToCamelCase(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end


function String.ToSnakeCase(str, uppercase)
	str = str:gsub("[%-_]+", "_"):gsub("([^%u%-_])(%u)", function(s1, s2) return s1 .. "_" .. s2:lower() end)
	if (uppercase) then str = str:upper() else str = str:lower() end
	return str
end


function String.ToKebabCase(str, uppercase)
	str = str:gsub("[%-_]+", "-"):gsub("([^%u%-_])(%u)", function(s1, s2) return s1 .. "-" .. s2:lower() end)
	if (uppercase) then str = str:upper() else str = str:lower() end
	return str
end

String.split = string.split
String.match = string.match
String.gmatch = string.gmatch
String.upper = string.upper
String.gsub = string.gsub
String.format = string.format
String.lower = string.lower
String.sub = string.sub
String.pack = string.pack
String.find = string.find
String.char = string.char
String.packsize = string.packsize
String.reverse = string.reverse
String.byte = string.byte
String.unpack = string.unpack
String.rep = string.rep
String.len = string.len


setmetatable(String, {__index = string})


return String