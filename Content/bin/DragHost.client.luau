--disable
local uiHost = require(workspace.Packages.UiHost);


local exclude = {
	"LevelGui", "HealthbarGui"
}




for _,v in pairs(script.Parent.Parent:GetChildren()) do
	if table.find(exclude, v.Name) then continue end
	local frm = v:FindFirstChildOfClass("Frame")
	if frm then
		uiHost.New(frm):Drag(true);
	end
end