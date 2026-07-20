game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAppearanceLoaded:Connect(function(char)
		for _, children in pairs(char:GetChildren()) do
			if children:IsA("CharacterMesh") then
				children:Destroy()
			end
		end
	end)
end)