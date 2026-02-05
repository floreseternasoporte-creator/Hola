-- SERVIDOR - SISTEMA DE CORTE DE LIANAS
-- ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Esperar evento
local cutEvent = ReplicatedStorage:WaitForChild("CutViineEvent")

-- Sonido de corte
local CUT_SOUND_ID = "rbxassetid://6881026094"

cutEvent.OnServerEvent:Connect(function(player, vinePart)
    if not vinePart or not vinePart:IsA("BasePart") then return end
    if not vinePart.Parent then return end
    
    -- Verificar que sea una liana
    local elianaNetwork = workspace:FindFirstChild("Eliana_Network")
    if not elianaNetwork or not vinePart:IsDescendantOf(elianaNetwork) then return end
    
    print("✂️ " .. player.Name .. " cortó una liana")
    
    -- Sonido de corte
    local sound = Instance.new("Sound")
    sound.SoundId = CUT_SOUND_ID
    sound.Volume = 0.8
    sound.Parent = vinePart
    sound:Play()
    Debris:AddItem(sound, 2)
    
    -- Partículas de corte
    for i = 1, 8 do
        local particle = Instance.new("Part")
        particle.Size = Vector3.new(0.3, 0.3, 0.3)
        particle.Position = vinePart.Position + Vector3.new(
            math.random(-2, 2),
            math.random(-1, 1),
            math.random(-2, 2)
        )
        particle.Material = Enum.Material.Plastic
        particle.Color = vinePart.Color
        particle.Anchored = false
        particle.CanCollide = true
        particle.TopSurface = Enum.SurfaceType.Studs
        particle.Parent = workspace
        
        -- Velocidad aleatoria
        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(5000, 5000, 5000)
        velocity.Velocity = Vector3.new(
            math.random(-20, 20),
            math.random(10, 30),
            math.random(-20, 20)
        )
        velocity.Parent = particle
        
        Debris:AddItem(velocity, 0.3)
        
        -- Fade out
        task.delay(1, function()
            if particle and particle.Parent then
                TweenService:Create(particle, TweenInfo.new(1), {Transparency = 1}):Play()
                Debris:AddItem(particle, 1)
            end
        end)
    end
    
    -- Animación de ruptura de la liana
    local originalSize = vinePart.Size
    local originalCFrame = vinePart.CFrame
    
    -- Hacer que la liana se rompa en 2 partes
    vinePart.Anchored = false
    vinePart.CanCollide = true
    
    -- Aplicar fuerza
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
    bodyVelocity.Velocity = Vector3.new(
        math.random(-10, 10),
        math.random(-5, 5),
        math.random(-10, 10)
    )
    bodyVelocity.Parent = vinePart
    
    -- Rotación
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(5000, 5000, 5000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(
        math.random(-5, 5),
        math.random(-5, 5),
        math.random(-5, 5)
    )
    bodyAngularVelocity.Parent = vinePart
    
    -- Limpiar fuerzas
    task.delay(0.5, function()
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity:Destroy()
        end
        if bodyAngularVelocity and bodyAngularVelocity.Parent then
            bodyAngularVelocity:Destroy()
        end
    end)
    
    -- Fade out y destruir
    task.delay(3, function()
        if vinePart and vinePart.Parent then
            TweenService:Create(vinePart, TweenInfo.new(2), {Transparency = 1}):Play()
            task.wait(2)
            if vinePart and vinePart.Parent then
                vinePart:Destroy()
            end
        end
    end)
end)

print("✅ Sistema de corte de lianas del servidor cargado")
