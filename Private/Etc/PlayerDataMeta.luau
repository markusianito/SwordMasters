export type Dato = (number|string|boolean)?

local module = {}

function module._Goods(info: {item: string, val: any}, profileData: {})
	profileData.Goods[info.item] = info.val;
end

function module._EquippedSkin(info: {val: string}, profileData: {})
	profileData.EquippedSkin = info.val;
end
function module._EquippedSword(info: {val: string}, profileData: {})
	profileData.EquippedSword = info.val;
end
function module._EquippedAbilities(info: {index: number, val: Dato}, profileData: {})
	profileData.EquippedAbilities[(info.index or info.item) or 1] = info.val;
end



return module
