
game.ReplicatedStorage:ClearAllChildren()
game.StarterGui:ClearAllChildren()

local assets = game:GetService("InsertService"):LoadAsset(770273765)

for _, v in pairs (assets.storage:GetChildren()) do
	v.Parent = game.ReplicatedStorage
end
for _, v in pairs(assets.ui:GetChildren()) do
	v.Parent = game.StarterGui
end

assets:Destroy()