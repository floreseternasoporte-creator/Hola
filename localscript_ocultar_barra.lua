-- OCULTAR BARRA DE VIDA VERDE DE ROBLOX
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Ocultar la barra de vida de Roblox
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

local function hideHealthBar(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Ocultar barra de vida sobre la cabeza
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.HealthDisplayDistance = 0
    humanoid.NameDisplayDistance = 0
end

if player.Character then
    hideHealthBar(player.Character)
end

player.CharacterAdded:Connect(hideHealthBar)

print("✅ Barra de vida verde ocultada")
