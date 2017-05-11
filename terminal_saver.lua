repeat wait() until game.StarterGui:FindFirstChild("ui")
while wait(1) do
	pcall(function()
		game:GetService("AssetService"):SavePlaceAsync()
	end)
end