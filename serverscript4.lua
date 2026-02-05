-- STRANGER THINGS EPIC POWERS SYSTEM - ENHANCED VERSION
-- SERVER SCRIPT - ServerScriptService
-- Efectos visuales épicos mejorados + Nuevo poder de Rayo Azul
 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
 
-- Crear RemoteEvents
local powerEvents = Instance.new("Folder")
powerEvents.Name = "PowerEvents"
powerEvents.Parent = ReplicatedStorage
 
local telekinesisPower = Instance.new("RemoteEvent")
telekinesisPower.Name = "TelekinesisPower"
telekinesisPower.Parent = powerEvents
 
local explosionPower = Instance.new("RemoteEvent")
explosionPower.Name = "ExplosionPower"
explosionPower.Parent = powerEvents
 
local controlPower = Instance.new("RemoteEvent")
controlPower.Name = "ControlPower"
controlPower.Parent = powerEvents
 
local protectionPower = Instance.new("RemoteEvent")
protectionPower.Name = "ProtectionPower"
protectionPower.Parent = powerEvents
 
local healingPower = Instance.new("RemoteEvent")
healingPower.Name = "HealingPower"
healingPower.Parent = powerEvents
 
local lightningPower = Instance.new("RemoteEvent")
lightningPower.Name = "LightningPower"
lightningPower.Parent = powerEvents
 
-- Configuración mejorada
local POWER_CONFIG = {
Telekinesis = {
Cooldown = 15,
Duration = 8,
Range = 50,
Color = Color3.fromRGB(138, 43, 226),
ActivationSound = "rbxassetid://126822236629098",
LoopSound = "rbxassetid://9125516670"
},
Explosion = {
Cooldown = 20,
Range = 60,
Force = 5000,
Color = Color3.fromRGB(255, 20, 20),
ActivationSound = "rbxassetid://2621689551",
LoopSound = "rbxassetid://9125516670"
},
Control = {
Cooldown = 25,
Duration = 10,
Range = 45,
Color = Color3.fromRGB(255, 140, 0),
ActivationSound = "rbxassetid://136750680626102",
LoopSound = "rbxassetid://9125516670"
},
Protection = {
Cooldown = 60,
Duration = 30,
Color = Color3.fromRGB(255, 10, 10),
ActivationSound = "rbxassetid://814168787",
LoopSound = "rbxassetid://9125516670"
},
Healing = {
Cooldown = 18,
Range = 40,
HealAmount = 50,
Color = Color3.fromRGB(0, 255, 127),
ActivationSound = "rbxassetid://5153438710",
LoopSound = "rbxassetid://9125516670"
},
Lightning = {
Cooldown = 12,
Range = 70,
Damage = 60,
Color = Color3.fromRGB(100, 200, 255),
ActivationSound = "rbxassetid://130767866",
ImpactSound = "rbxassetid://2974249481"
}
}
 
local playerCooldowns = {}
 
local function checkAndSetCooldown(userId, powerName, requiredCooldown)
    if not playerCooldowns[userId] then
        playerCooldowns[userId] = {}
    end
    
    local now = tick()
    if playerCooldowns[userId][powerName] and now - playerCooldowns[userId][powerName] < requiredCooldown then
        return false
    end
    
    playerCooldowns[userId][powerName] = now
    return true
end
 
-- SISTEMA DE SONIDO MEJORADO
local function createPowerSounds(parent, config)
    local activationSound = Instance.new("Sound")
    activationSound.Name = "ActivationSound"
    activationSound.SoundId = config.ActivationSound
    activationSound.Volume = 1.5
    activationSound.Parent = parent
    activationSound:Play()
    
    if config.LoopSound then
        local loopSound = Instance.new("Sound")
        loopSound.Name = "LoopSound"
        loopSound.SoundId = config.LoopSound
        loopSound.Volume = 1
        loopSound.Looped = true
        loopSound.Parent = parent
        
        task.delay(0.3, function()
            if loopSound and loopSound.Parent then
                loopSound:Play()
            end
        end)
        
        return activationSound, loopSound
    end
    
    return activationSound, nil
end
 
-- EFECTOS ÉPICOS MEJORADOS CON MÁS PARTÍCULAS
local function createAdvancedParticles(parent, color, particleType)
    local effects = {}
    
    -- Partícula principal con más intensidad
    for i = 1, 5 do
        local particle = Instance.new("ParticleEmitter")
        particle.Name = "PowerParticle_" .. i
        particle.Parent = parent
        particle.Texture = "rbxassetid://6101261905"
        particle.Color = ColorSequence.new(color)
        particle.LightEmission = 1
        particle.LightInfluence = 0
        
        if i == 1 then
            -- Partículas grandes brillantes
            particle.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(0.5, 3.5),
            NumberSequenceKeypoint.new(1, 0.2)
            })
            particle.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 1)
            })
            particle.Rate = 150
            particle.Speed = NumberRange.new(10, 20)
        elseif i == 2 then
            -- Partículas medianas rápidas
            particle.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.5),
            NumberSequenceKeypoint.new(0.5, 4),
            NumberSequenceKeypoint.new(1, 0.8)
            })
            particle.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
            })
            particle.Rate = 100
            particle.Speed = NumberRange.new(8, 15)
        elseif i == 3 then
            -- Humo colorido
            particle.Texture = "rbxasset://textures/particles/smoke_main.dds"
            particle.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
            })
            particle.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(1, 1)
            })
            particle.Rate = 60
            particle.Speed = NumberRange.new(4, 10)
        elseif i == 4 then
            -- Chispas eléctricas
            particle.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(1, 0)
            })
            particle.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
            })
            particle.Lifetime = NumberRange.new(0.4, 1)
            particle.Rate = 120
            particle.Speed = NumberRange.new(20, 35)
        else
            -- Ondas de energía
            particle.Texture = "rbxassetid://6101261905"
            particle.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 2),
            NumberSequenceKeypoint.new(1, 0.1)
            })
            particle.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.5, 0.3),
            NumberSequenceKeypoint.new(1, 1)
            })
            particle.Rate = 80
            particle.Speed = NumberRange.new(6, 12)
        end
        
        particle.Lifetime = NumberRange.new(1, 3)
        particle.SpreadAngle = Vector2.new(180, 180)
        particle.Rotation = NumberRange.new(0, 360)
        particle.RotSpeed = NumberRange.new(-300, 300)
        particle.Enabled = true
        
        table.insert(effects, particle)
    end
    
    return effects
end
 
local function createEpicBeam(attachment0, attachment1, color)
    local effects = {}
    
    -- Rayo principal ultra brillante
    local mainBeam = Instance.new("Beam")
    mainBeam.Name = "MainBeam"
    mainBeam.Attachment0 = attachment0
    mainBeam.Attachment1 = attachment1
    mainBeam.Color = ColorSequence.new(color)
    mainBeam.Width0 = 3
    mainBeam.Width1 = 3
    mainBeam.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 0)
    })
    mainBeam.FaceCamera = true
    mainBeam.LightEmission = 1
    mainBeam.LightInfluence = 0
    mainBeam.Texture = "rbxassetid://6101261905"
    mainBeam.TextureMode = Enum.TextureMode.Wrap
    mainBeam.TextureSpeed = 4
    mainBeam.TextureLength = 2
    mainBeam.Parent = attachment0.Parent
    table.insert(effects, mainBeam)
    
    -- Rayo exterior pulsante
    local outerBeam = Instance.new("Beam")
    outerBeam.Name = "OuterBeam"
    outerBeam.Attachment0 = attachment0
    outerBeam.Attachment1 = attachment1
    outerBeam.Color = ColorSequence.new(Color3.new(1, 1, 1), color)
    outerBeam.Width0 = 5
    outerBeam.Width1 = 5
    outerBeam.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.4),
    NumberSequenceKeypoint.new(0.5, 0.6),
    NumberSequenceKeypoint.new(1, 0.4)
    })
    outerBeam.FaceCamera = true
    outerBeam.LightEmission = 0.9
    outerBeam.Texture = "rbxasset://textures/particles/smoke_main.dds"
    outerBeam.TextureMode = Enum.TextureMode.Wrap
    outerBeam.TextureSpeed = -3
    outerBeam.Parent = attachment0.Parent
    table.insert(effects, outerBeam)
    
    -- Rayo extra para más grosor
    local thickBeam = Instance.new("Beam")
    thickBeam.Name = "ThickBeam"
    thickBeam.Attachment0 = attachment0
    thickBeam.Attachment1 = attachment1
    thickBeam.Color = ColorSequence.new(color)
    thickBeam.Width0 = 1.5
    thickBeam.Width1 = 1.5
    thickBeam.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 0.1)
    })
    thickBeam.FaceCamera = true
    thickBeam.LightEmission = 1
    thickBeam.Texture = "rbxassetid://6101261905"
    thickBeam.TextureMode = Enum.TextureMode.Wrap
    thickBeam.TextureSpeed = 6
    thickBeam.TextureLength = 1
    thickBeam.Parent = attachment0.Parent
    table.insert(effects, thickBeam)
    
    return effects
end
 
local function createNoseBleed(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Sangrado de nariz más intenso
    local blood = Instance.new("ParticleEmitter")
    blood.Name = "NoseBleed"
    blood.Parent = head
    blood.Texture = "rbxasset://textures/particles/smoke_main.dds"
    blood.Color = ColorSequence.new(Color3.fromRGB(139, 0, 0))
    blood.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.3),
    NumberSequenceKeypoint.new(1, 0.7)
    })
    blood.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
    })
    blood.Lifetime = NumberRange.new(1.5, 3)
    blood.Rate = 25
    blood.Speed = NumberRange.new(2, 6)
    blood.SpreadAngle = Vector2.new(30, 30)
    blood.EmissionDirection = Enum.NormalId.Bottom
    blood.Acceleration = Vector3.new(0, -15, 0)
    blood.Enabled = true
    
    return blood
end
 
local function createScreenDistortion(character, color)
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Luz pulsante más intensa
    local light = Instance.new("PointLight")
    light.Name = "PowerLight"
    light.Parent = head
    light.Color = color
    light.Brightness = 8
    light.Range = 35
    light.Shadows = true
    
    task.spawn(function()
        while light and light.Parent do
            TweenService:Create(light, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Brightness = 12, Range = 45}):Play()
            task.wait(0.25)
            TweenService:Create(light, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Brightness = 8, Range = 35}):Play()
            task.wait(0.25)
        end
    end)
    
    return light
end
 
-- PODER 1: TELEKINESIS ÉPICA (MEJORADA)
-- PODER 1: TELEQUINESIS ULTRA ÉPICA (GRÁFICOS EXTREMOS)
local function useTelekinesis(player, targetPlayer)
    local character = player.Character
    local targetCharacter = targetPlayer.Character
    
    if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
    if not checkAndSetCooldown(player.UserId, "Telekinesis", POWER_CONFIG.Telekinesis.Cooldown) then return end
    
    local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
    if distance > POWER_CONFIG.Telekinesis.Range then return end
    
    local config = POWER_CONFIG.Telekinesis
    
    -- EFECTOS EN USUARIO (MASIVOS)
    local userEffects = createAdvancedParticles(character.Head, config.Color, "telekinesis")
    local noseBleed = createNoseBleed(character)
    local userLight = createScreenDistortion(character, config.Color)
    
    -- EFECTOS EN OBJETIVO (MASIVOS)
    local targetEffects = createAdvancedParticles(targetCharacter.Head, config.Color, "telekinesis")
    local targetLight = createScreenDistortion(targetCharacter, config.Color)
    
    -- RAYOS CONECTORES (MÚLTIPLES)
    local att0 = Instance.new("Attachment", character.Head)
    local att1 = Instance.new("Attachment", targetCharacter.Head)
    local beams = createEpicBeam(att0, att1, config.Color)
    
    -- SONIDOS
    local activationSound, loopSound = createPowerSounds(character.Head, config)
    
    -- ONDAS DE CHOQUE MASIVAS (15 CAPAS)
    for i = 1, 15 do
        task.spawn(function()
            task.wait(i * 0.05)
            local shockwave = Instance.new("Part")
            shockwave.Shape = Enum.PartType.Cylinder
            shockwave.Size = Vector3.new(0.5, 2, 2)
            shockwave.Material = Enum.Material.Neon
            shockwave.Color = config.Color
            shockwave.Anchored = true
            shockwave.CanCollide = false
            shockwave.CFrame = CFrame.new(character.HumanoidRootPart.Position) * CFrame.Angles(0, 0, math.rad(90))
            shockwave.Transparency = 0.1
            shockwave.Parent = workspace
            
            local shockLight = Instance.new("PointLight")
            shockLight.Color = config.Color
            shockLight.Brightness = 15
            shockLight.Range = 30
            shockLight.Shadows = true
            shockLight.Parent = shockwave
            
            TweenService:Create(shockwave, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.5, 60 + (i * 8), 60 + (i * 8)),
            Transparency = 1
            }):Play()
            TweenService:Create(shockLight, TweenInfo.new(0.8), {Brightness = 0}):Play()
            Debris:AddItem(shockwave, 0.8)
        end)
    end
    
    -- PARTÍCULAS ORBITALES MASIVAS
    for i = 1, 50 do
        task.spawn(function()
            local orb = Instance.new("Part")
            orb.Shape = Enum.PartType.Ball
            orb.Size = Vector3.new(2, 2, 2)
            orb.Material = Enum.Material.Neon
            orb.Color = config.Color
            orb.Anchored = true
            orb.CanCollide = false
            orb.Transparency = 0.3
            orb.Parent = workspace
            
            local orbLight = Instance.new("PointLight")
            orbLight.Color = config.Color
            orbLight.Brightness = 10
            orbLight.Range = 15
            orbLight.Parent = orb
            
            local angle = (i / 50) * math.pi * 2
            local radius = 10
            
            for t = 0, config.Duration, 0.05 do
                if orb and orb.Parent then
                    local newAngle = angle + (t * 3)
                    local pos = targetCharacter.HumanoidRootPart.Position + Vector3.new(
                        math.cos(newAngle) * radius,
                        math.sin(t * 5) * 3,
                        math.sin(newAngle) * radius
                    )
                    orb.Position = pos
                end
                task.wait(0.05)
            end
            
            TweenService:Create(orb, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(orbLight, TweenInfo.new(0.3), {Brightness = 0}):Play()
            task.wait(0.3)
            orb:Destroy()
        end)
    end
    
    -- ANILLOS ENERGÉTICOS GIRATORIOS (10 ANILLOS)
    for i = 1, 10 do
        task.spawn(function()
            local ring = Instance.new("Part")
            ring.Shape = Enum.PartType.Cylinder
            ring.Size = Vector3.new(0.3, 15, 15)
            ring.Material = Enum.Material.Neon
            ring.Color = config.Color
            ring.Anchored = true
            ring.CanCollide = false
            ring.Transparency = 0.2
            ring.Parent = workspace
            
            for t = 0, config.Duration, 0.03 do
                if ring and ring.Parent then
                    ring.CFrame = CFrame.new(targetCharacter.HumanoidRootPart.Position) *
                    CFrame.Angles(math.rad(i * 36), math.rad(t * 100), 0)
                end
                task.wait(0.03)
            end
            
            TweenService:Create(ring, TweenInfo.new(0.5), {Transparency = 1, Size = Vector3.new(0.3, 25, 25)}):Play()
            task.wait(0.5)
            ring:Destroy()
        end)
    end
    
    -- RAYOS SECUNDARIOS (20 RAYOS)
    for i = 1, 20 do
        task.spawn(function()
            task.wait(i * 0.1)
            local beam = Instance.new("Part")
            beam.Size = Vector3.new(0.5, 0.5, distance)
            beam.Material = Enum.Material.Neon
            beam.Color = config.Color
            beam.Anchored = true
            beam.CanCollide = false
            beam.Transparency = 0.4
            beam.CFrame = CFrame.new(character.Head.Position, targetCharacter.Head.Position) * CFrame.new(0, 0, -distance/2)
            beam.Parent = workspace
            
            TweenService:Create(beam, TweenInfo.new(0.3), {Transparency = 1}):Play()
            Debris:AddItem(beam, 0.3)
        end)
    end
    
    -- DISTORSIÓN ESPACIAL
    for i = 1, 30 do
        task.spawn(function()
            local distortion = Instance.new("Part")
            distortion.Shape = Enum.PartType.Ball
            distortion.Size = Vector3.new(1, 1, 1)
            distortion.Material = Enum.Material.Glass
            distortion.Color = config.Color
            distortion.Anchored = true
            distortion.CanCollide = false
            distortion.Transparency = 0.7
            distortion.Parent = workspace
            
            local startPos = character.HumanoidRootPart.Position
            local endPos = targetCharacter.HumanoidRootPart.Position
            
            for t = 0, 1, 0.05 do
                if distortion and distortion.Parent then
                    distortion.Position = startPos:Lerp(endPos, t) + Vector3.new(
                        math.random(-5, 5),
                        math.random(-5, 5),
                        math.random(-5, 5)
                    )
                    distortion.Size = Vector3.new(1 + t * 3, 1 + t * 3, 1 + t * 3)
                end
                task.wait(0.05)
            end
            
            distortion:Destroy()
        end)
    end
    
    -- EFECTO DE LEVITACIÓN
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
    if targetHumanoid then
        targetHumanoid.WalkSpeed = 0
        targetHumanoid.JumpPower = 0
        
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Name = "TelekinesisFloat"
        bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
        bodyPosition.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(0, 8, 0)
        bodyPosition.D = 1000
        bodyPosition.Parent = targetCharacter.HumanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
        bodyGyro.D = 1000
        bodyGyro.Parent = targetCharacter.HumanoidRootPart
        
        task.spawn(function()
            local time = 0
            while time < config.Duration and bodyGyro.Parent do
                time = time + 0.1
                bodyGyro.CFrame = CFrame.Angles(math.sin(time * 2), time * 3, math.cos(time * 2))
                bodyPosition.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(
                    math.sin(time * 2) * 2,
                    8 + math.sin(time * 4) * 2,
                    math.cos(time * 2) * 2
                )
                task.wait(0.1)
            end
        end)
        
        task.wait(config.Duration)
        
        targetHumanoid.WalkSpeed = 16
        targetHumanoid.JumpPower = 50
        if bodyPosition then bodyPosition:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
    
    if loopSound then loopSound:Stop() task.delay(0.5, function() loopSound:Destroy() end) end
    
    task.wait(1)
    for _, effect in ipairs(userEffects) do effect:Destroy() end
    for _, effect in ipairs(targetEffects) do effect:Destroy() end
    for _, beam in ipairs(beams) do beam:Destroy() end
    if noseBleed then noseBleed:Destroy() end
    if userLight then userLight:Destroy() end
    if targetLight then targetLight:Destroy() end
    if att0 then att0:Destroy() end
    if att1 then att1:Destroy() end
end
 
-- PODER 2: EXPLOSIÓN MEJORADA
local function useExplosion(player, targetPlayer)
    local character = player.Character
    local targetCharacter = targetPlayer.Character
    
    if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
    if not checkAndSetCooldown(player.UserId, "Explosion", POWER_CONFIG.Explosion.Cooldown) then return end
    
    local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
    if distance > POWER_CONFIG.Explosion.Range then return end
    
    local config = POWER_CONFIG.Explosion
    
    local userEffects = createAdvancedParticles(character.Head, config.Color, "explosion")
    local noseBleed = createNoseBleed(character)
    local userLight = createScreenDistortion(character, config.Color)
    
    local activationSound, loopSound = createPowerSounds(character.Head, config)
    
    -- Esfera de carga más épica
    local chargeSphere = Instance.new("Part")
    chargeSphere.Shape = Enum.PartType.Ball
    chargeSphere.Size = Vector3.new(3, 3, 3)
    chargeSphere.Position = targetCharacter.HumanoidRootPart.Position
    chargeSphere.Anchored = true
    chargeSphere.CanCollide = false
    chargeSphere.Material = Enum.Material.Neon
    chargeSphere.Color = config.Color
    chargeSphere.Transparency = 0.1
    chargeSphere.Parent = workspace
    
    local chargeLight = Instance.new("PointLight")
    chargeLight.Color = config.Color
    chargeLight.Brightness = 15
    chargeLight.Range = 40
    chargeLight.Shadows = true
    chargeLight.Parent = chargeSphere
    
    -- Múltiples capas de partículas de carga
    for i = 1, 3 do
        local chargeParticles = Instance.new("ParticleEmitter")
        chargeParticles.Parent = chargeSphere
        chargeParticles.Texture = "rbxassetid://6101261905"
        chargeParticles.Color = ColorSequence.new(config.Color)
        chargeParticles.Size = NumberSequence.new(1.5 + i * 0.5)
        chargeParticles.Rate = 150 - (i * 30)
        chargeParticles.Speed = NumberRange.new(-30, -10)
        chargeParticles.Lifetime = NumberRange.new(0.5, 1.5)
        chargeParticles.SpreadAngle = Vector2.new(180, 180)
        chargeParticles.LightEmission = 1
    end
    
    TweenService:Create(chargeSphere, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
    Size = Vector3.new(12, 12, 12),
    Transparency = 0
    }):Play()
    TweenService:Create(chargeLight, TweenInfo.new(1.5), {Brightness = 25, Range = 60}):Play()
    
    task.wait(1.5)
    
    for _, child in ipairs(chargeSphere:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false
        end
    end
    
    local explosionSound = Instance.new("Sound")
    explosionSound.SoundId = "rbxassetid://9114397505"
    explosionSound.Volume = 2.5
    explosionSound.Parent = chargeSphere
    explosionSound:Play()
    
    -- Múltiples ondas expansivas épicas
    for i = 1, 8 do
        task.spawn(function()
            task.wait(i * 0.08)
            local wave = Instance.new("Part")
            wave.Shape = Enum.PartType.Ball
            wave.Size = Vector3.new(2, 2, 2)
            wave.Position = chargeSphere.Position
            wave.Anchored = true
            wave.CanCollide = false
            wave.Material = Enum.Material.Neon
            wave.Color = config.Color
            wave.Transparency = 0.2 + (i * 0.08)
            wave.Parent = workspace
            
            local waveLight = Instance.new("PointLight")
            waveLight.Color = config.Color
            waveLight.Brightness = 15
            waveLight.Range = 25
            waveLight.Parent = wave
            
            TweenService:Create(wave, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(50, 50, 50),
            Transparency = 1
            }):Play()
            TweenService:Create(waveLight, TweenInfo.new(1), {Brightness = 0}):Play()
            Debris:AddItem(wave, 1)
        end)
    end
    
    local explosion = Instance.new("Explosion")
    explosion.Position = targetCharacter.HumanoidRootPart.Position
    explosion.BlastPressure = config.Force
    explosion.BlastRadius = 25
    explosion.ExplosionType = Enum.ExplosionType.Craters
    explosion.Parent = workspace
    
    local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
    if targetHumanoid then
        targetHumanoid:TakeDamage(50)
    end
    
    if loopSound then loopSound:Stop() task.delay(0.5, function() loopSound:Destroy() end) end
    
    task.wait(2)
    for _, effect in ipairs(userEffects) do effect:Destroy() end
    if noseBleed then noseBleed:Destroy() end
    if userLight then userLight:Destroy() end
    chargeSphere:Destroy()
end
 
-- PODER 3: CONTROL MENTAL MASIVO (MEJORADO)
local function useControl(player)
    local character = player.Character
    if not character then return end
    if not checkAndSetCooldown(player.UserId, "Control", POWER_CONFIG.Control.Cooldown) then return end
    
    local config = POWER_CONFIG.Control
    
    local userEffects = createAdvancedParticles(character.Head, config.Color, "control")
    local noseBleed = createNoseBleed(character)
    local userLight = createScreenDistortion(character, config.Color)
    
    local activationSound, loopSound = createPowerSounds(character.Head, config)
    
    local layers = {}
    -- Múltiples capas rotatorias más densas
    for i = 1, 5 do
        local zone = Instance.new("Part")
        zone.Shape = Enum.PartType.Cylinder
        zone.Size = Vector3.new(1, config.Range * 2 * (1 + i * 0.15), config.Range * 2 * (1 + i * 0.15))
        zone.Position = character.HumanoidRootPart.Position
        zone.Rotation = Vector3.new(0, 0, 90)
        zone.Anchored = true
        zone.CanCollide = false
        zone.Material = Enum.Material.ForceField
        zone.Color = config.Color
        zone.Transparency = 0.4 + (i * 0.08)
        zone.Parent = workspace
        
        local zoneLight = Instance.new("PointLight")
        zoneLight.Color = config.Color
        zoneLight.Brightness = 8
        zoneLight.Range = config.Range * 1.2
        zoneLight.Parent = zone
        
        task.spawn(function()
            while zone.Parent do
                zone.Rotation = zone.Rotation + Vector3.new(0, 3 * i, 0)
                task.wait(0.02)
            end
        end)
        
        TweenService:Create(zone, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.2 + (i * 0.08)
        }):Play()
        
        table.insert(layers, zone)
    end
    
    local controlledPlayers = {}
    local duration = config.Duration
    local startTime = tick()
    
    local controlLoop
    controlLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if tick() - startTime > duration then
            controlLoop:Disconnect()
            return
        end
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherCharacter = otherPlayer.Character
                if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
                    local dist = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude
                    
                    if dist <= config.Range then
                        if not controlledPlayers[otherPlayer.UserId] then
                            controlledPlayers[otherPlayer.UserId] = true
                            
                            local bodyPosition = Instance.new("BodyPosition")
                            bodyPosition.Name = "ControlFloat"
                            bodyPosition.MaxForce = Vector3.new(50000, 50000, 50000)
                            bodyPosition.D = 1000
                            bodyPosition.Parent = otherCharacter.HumanoidRootPart
                            
                            local bodyGyro = Instance.new("BodyGyro")
                            bodyGyro.Name = "ControlGyro"
                            bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
                            bodyGyro.D = 1000
                            bodyGyro.Parent = otherCharacter.HumanoidRootPart
                            
                            local ctrlEffects = createAdvancedParticles(otherCharacter.Head, config.Color, "control")
                            local ctrlLight = createScreenDistortion(otherCharacter, config.Color)
                            
                            local trail = Instance.new("Trail")
                            local att0 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
                            local att1 = Instance.new("Attachment", otherCharacter.HumanoidRootPart)
                            att1.Position = Vector3.new(0, 2, 0)
                            trail.Attachment0 = att0
                            trail.Attachment1 = att1
                            trail.Color = ColorSequence.new(config.Color)
                            trail.Transparency = NumberSequence.new(0.3, 1)
                            trail.Lifetime = 1.5
                            trail.LightEmission = 1
                            trail.Parent = otherCharacter.HumanoidRootPart
                            
                            local angle = math.random() * math.pi * 2
                            local floatConnection
                            floatConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
                                if otherCharacter and otherCharacter.Parent and bodyPosition and bodyPosition.Parent then
                                    angle = angle + dt * 2
                                    local height = math.sin(angle * 3) * 4 + 12
                                    local radius = 18 + math.cos(angle * 1.5) * 6
                                    bodyPosition.Position = character.HumanoidRootPart.Position + 
                                    Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
                                    bodyGyro.CFrame = CFrame.Angles(math.sin(angle * 2) * 0.6, angle * 3, math.cos(angle * 2) * 0.6)
                                else
                                    floatConnection:Disconnect()
                                end
                            end)
                            
                            task.delay(duration - (tick() - startTime), function()
                                floatConnection:Disconnect()
                                if bodyPosition then bodyPosition:Destroy() end
                                if bodyGyro then bodyGyro:Destroy() end
                                for _, effect in ipairs(ctrlEffects) do effect:Destroy() end
                                if ctrlLight then ctrlLight:Destroy() end
                                if trail then trail:Destroy() end
                                if att0 then att0:Destroy() end
                                if att1 then att1:Destroy() end
                            end)
                        end
                    end
                end
            end
        end
    end)
    
    task.delay(duration, function()
        if loopSound then loopSound:Stop() task.delay(0.5, function() loopSound:Destroy() end) end
    end)
    
    task.wait(duration)
    for _, zone in ipairs(layers) do zone:Destroy() end
    for _, effect in ipairs(userEffects) do effect:Destroy() end
    if noseBleed then noseBleed:Destroy() end
    if userLight then userLight:Destroy() end
end
 
-- PODER 4: PROTECCIÓN (MEJORADA)
local function useProtection(player)
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    if not checkAndSetCooldown(player.UserId, "Protection", POWER_CONFIG.Protection.Cooldown) then return end
    
    local config = POWER_CONFIG.Protection
    
    local userEffects = createAdvancedParticles(character.Head, config.Color, "protection")
    local noseBleed = createNoseBleed(character)
    local userLight = createScreenDistortion(character, config.Color)
    
    local activationSound, loopSound = createPowerSounds(character.Head, config)
    
    -- Múltiples capas de escudo
    local shields = {}
    for i = 1, 3 do
        local shield = Instance.new("Part")
        shield.Shape = Enum.PartType.Ball
        shield.Size = Vector3.new(12 + i * 2, 12 + i * 2, 12 + i * 2)
        shield.Position = character.HumanoidRootPart.Position
        shield.Anchored = true
        shield.CanCollide = false
        shield.Material = i == 1 and Enum.Material.ForceField or Enum.Material.Neon
        shield.Color = config.Color
        shield.Transparency = 0.2 + (i * 0.15)
        shield.Parent = workspace
        
        table.insert(shields, shield)
    end
    
    local shieldLight = Instance.new("PointLight")
    shieldLight.Color = config.Color
    shieldLight.Brightness = 20
    shieldLight.Range = 50
    shieldLight.Shadows = true
    shieldLight.Parent = shields[1]
    
    -- Partículas hexagonales densas
    for i = 1, 2 do
        local hexParticles = Instance.new("ParticleEmitter")
        hexParticles.Parent = shields[1]
        hexParticles.Texture = "rbxassetid://6101261905"
        hexParticles.Color = ColorSequence.new(config.Color)
        hexParticles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2.5),
        NumberSequenceKeypoint.new(1, 4)
        })
        hexParticles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
        })
        hexParticles.Lifetime = NumberRange.new(2, 4)
        hexParticles.Rate = 80
        hexParticles.Speed = NumberRange.new(3, 7)
        hexParticles.Rotation = NumberRange.new(0, 360)
        hexParticles.RotSpeed = NumberRange.new(-150, 150)
        hexParticles.SpreadAngle = Vector2.new(180, 180)
        hexParticles.LightEmission = 1
    end
    
    task.spawn(function()
        while shields[1] and shields[1].Parent do
            for i, shield in ipairs(shields) do
                shield.CFrame = shield.CFrame * CFrame.Angles(0, math.rad(2 * i), math.rad(1 * i))
            end
            task.wait(0.02)
        end
    end)
    
    for i, shield in ipairs(shields) do
        TweenService:Create(shield, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.1 + (i * 0.1),
        Size = Vector3.new(13 + i * 2, 13 + i * 2, 13 + i * 2)
        }):Play()
    end
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if character and character.Parent and shields[1] and shields[1].Parent then
            for _, shield in ipairs(shields) do
                shield.Position = character.HumanoidRootPart.Position
            end
        else
            connection:Disconnect()
        end
    end)
    
    local forceField = Instance.new("ForceField")
    forceField.Visible = false
        forceField.Parent = character
            
            local rayCount = 0
            local damageConnection
            damageConnection = character.Humanoid.HealthChanged:Connect(function(health)
                if health < character.Humanoid.MaxHealth and rayCount < 30 then
                    rayCount = rayCount + 1
                    
                    for j = 1, 2 do
                        task.spawn(function()
                            local ray = Instance.new("Part")
                            ray.Size = Vector3.new(0.4, 0.4, math.random(6, 12))
                            ray.Material = Enum.Material.Neon
                            ray.Color = config.Color
                            ray.Anchored = true
                            ray.CanCollide = false
                            ray.CFrame = CFrame.new(shields[1].Position) * CFrame.Angles(math.random(-180, 180), math.random(-180, 180), 0) * CFrame.new(0, 0, -8)
                            ray.Parent = workspace
                            
                            TweenService:Create(ray, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Transparency = 1,
                            Size = Vector3.new(0.4, 0.4, ray.Size.Z * 2.5)
                            }):Play()
                            
                            Debris:AddItem(ray, 0.25)
                        end)
                    end
                end
            end)
            
            task.wait(config.Duration)
            
            if loopSound then loopSound:Stop() task.delay(0.5, function() loopSound:Destroy() end) end
            
            damageConnection:Disconnect()
            connection:Disconnect()
            if forceField then forceField:Destroy() end
            
            for _, shield in ipairs(shields) do
                local fadeTween = TweenService:Create(shield, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 1,
                Size = shield.Size * 2
                })
                fadeTween:Play()
            end
            
            for _, child in ipairs(shields[1]:GetChildren()) do
                if child:IsA("ParticleEmitter") then
                    child.Enabled = false
                end
            end
            
            task.delay(2, function()
                for _, shield in ipairs(shields) do
                    if shield then shield:Destroy() end
                end
            end)
            
            for _, effect in ipairs(userEffects) do effect:Destroy() end
            if noseBleed then noseBleed:Destroy() end
            if userLight then userLight:Destroy() end
        end
        
        -- PODER 5: CURACIÓN (MEJORADA)
        local function useHealing(player, targetPlayer)
            local character = player.Character
            local targetCharacter = targetPlayer.Character
            
            if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
            if not checkAndSetCooldown(player.UserId, "Healing", POWER_CONFIG.Healing.Cooldown) then return end
            
            local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
            if distance > POWER_CONFIG.Healing.Range then return end
            
            local config = POWER_CONFIG.Healing
            
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            if not targetHumanoid then return end
            
            if targetHumanoid.Health >= targetHumanoid.MaxHealth then
                return
            end
            
            local healerEffects = createAdvancedParticles(character.Head, config.Color, "healing")
            local healerLight = createScreenDistortion(character, config.Color)
            
            local activationSound, loopSound = createPowerSounds(character.Head, config)
            
            local targetEffects = createAdvancedParticles(targetCharacter.Head, config.Color, "healing")
            local targetLight = createScreenDistortion(targetCharacter, config.Color)
            
            local att0 = Instance.new("Attachment", character.Head)
            local att1 = Instance.new("Attachment", targetCharacter.Head)
            local beams = createEpicBeam(att0, att1, config.Color)
            
            -- Múltiples ondas de sanación
            for i = 1, 5 do
                task.spawn(function()
                    task.wait(i * 0.25)
                    local wave = Instance.new("Part")
                    wave.Shape = Enum.PartType.Ball
                    wave.Size = Vector3.new(2, 2, 2)
                    wave.Position = targetCharacter.HumanoidRootPart.Position
                    wave.Anchored = true
                    wave.CanCollide = false
                    wave.Material = Enum.Material.Neon
                    wave.Color = config.Color
                    wave.Transparency = 0.2
                    wave.Parent = workspace
                    
                    TweenService:Create(wave, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(20, 20, 20),
                    Transparency = 1
                    }):Play()
                    Debris:AddItem(wave, 1)
                end)
            end
            
            local healAura = Instance.new("Part")
            healAura.Shape = Enum.PartType.Ball
            healAura.Size = Vector3.new(10, 10, 10)
            healAura.Position = targetCharacter.HumanoidRootPart.Position
            healAura.Anchored = true
            healAura.CanCollide = false
            healAura.Material = Enum.Material.ForceField
            healAura.Color = config.Color
            healAura.Transparency = 0.4
            healAura.Parent = workspace
            
            local healLight = Instance.new("PointLight")
            healLight.Color = config.Color
            healLight.Brightness = 15
            healLight.Range = 35
            healLight.Shadows = true
            healLight.Parent = healAura
            
            -- Múltiples emisores de partículas de curación
            for i = 1, 3 do
                local healParticles = Instance.new("ParticleEmitter")
                healParticles.Parent = healAura
                healParticles.Texture = "rbxassetid://6101261905"
                healParticles.Color = ColorSequence.new(config.Color)
                healParticles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.5),
                NumberSequenceKeypoint.new(1, 3)
                })
                healParticles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 1)
                })
                healParticles.Lifetime = NumberRange.new(2, 3.5)
                healParticles.Rate = 100
                healParticles.Speed = NumberRange.new(6, 12)
                healParticles.SpreadAngle = Vector2.new(40, 40)
                healParticles.EmissionDirection = Enum.NormalId.Top
                healParticles.Rotation = NumberRange.new(0, 360)
                healParticles.LightEmission = 1
            end
            
            -- Símbolos de curación giratorios
            for i = 1, 8 do
                task.spawn(function()
                    local symbol = Instance.new("Part")
                    symbol.Shape = Enum.PartType.Block
                    symbol.Size = Vector3.new(1.5, 4, 0.4)
                    symbol.Position = targetCharacter.HumanoidRootPart.Position + Vector3.new(
                    math.random(-4, 4),
                    math.random(0, 3),
                    math.random(-4, 4)
                    )
                    symbol.Material = Enum.Material.Neon
                    symbol.Color = config.Color
                    symbol.Anchored = true
                    symbol.CanCollide = false
                    symbol.Parent = workspace
                    
                    local symbol2 = symbol:Clone()
                    symbol2.Size = Vector3.new(4, 1.5, 0.4)
                    symbol2.Position = symbol.Position
                    symbol2.Parent = workspace
                    
                    task.wait(i * 0.08)
                    TweenService:Create(symbol, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Position = symbol.Position + Vector3.new(0, 10, 0),
                    Transparency = 1,
                    CFrame = symbol.CFrame * CFrame.Angles(0, math.rad(360), 0)
                    }):Play()
                    TweenService:Create(symbol2, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Position = symbol2.Position + Vector3.new(0, 10, 0),
                    Transparency = 1,
                    CFrame = symbol2.CFrame * CFrame.Angles(0, math.rad(-360), 0)
                    }):Play()
                    
                    Debris:AddItem(symbol, 2.5)
                    Debris:AddItem(symbol2, 2.5)
                end)
            end
            
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if targetCharacter and targetCharacter.Parent and healAura and healAura.Parent then
                    healAura.Position = targetCharacter.HumanoidRootPart.Position
                else
                    connection:Disconnect()
                end
            end)
            
            local healDuration = 2.5
            local healPerTick = config.HealAmount / (healDuration * 10)
            local healTime = 0
            
            local healConnection
            healConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
                healTime = healTime + dt
                
                if healTime >= healDuration or targetHumanoid.Health >= targetHumanoid.MaxHealth then
                    healConnection:Disconnect()
                    return
                end
                
                targetHumanoid.Health = math.min(targetHumanoid.Health + healPerTick, targetHumanoid.MaxHealth)
            end)
            
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Size = UDim2.new(0, 120, 0, 60)
            billboardGui.StudsOffset = Vector3.new(0, 3.5, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = targetCharacter.HumanoidRootPart
            
            local healText = Instance.new("TextLabel")
            healText.Size = UDim2.new(1, 0, 1, 0)
            healText.BackgroundTransparency = 1
            healText.Text = "+ " .. tostring(config.HealAmount)
            healText.Font = Enum.Font.SourceSansBold
            healText.TextSize = 36
            healText.TextColor3 = config.Color
            healText.TextStrokeTransparency = 0
            healText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            healText.Parent = billboardGui
            
            TweenService:Create(billboardGui, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            StudsOffset = Vector3.new(0, 7, 0)
            }):Play()
            TweenService:Create(healText, TweenInfo.new(2.5), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
            }):Play()
            
            Debris:AddItem(billboardGui, 2.5)
            
            task.wait(healDuration)
            
            connection:Disconnect()
            
            if loopSound then loopSound:Stop() task.delay(0.5, function() loopSound:Destroy() end) end
            
            TweenService:Create(healAura, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(20, 20, 20)
            }):Play()
            
            for _, child in ipairs(healAura:GetChildren()) do
                if child:IsA("ParticleEmitter") then
                    child.Enabled = false
                end
            end
            
            task.delay(1.5, function()
                if healAura then healAura:Destroy() end
            end)
            
            for _, effect in ipairs(healerEffects) do effect:Destroy() end
            for _, effect in ipairs(targetEffects) do effect:Destroy() end
            for _, beam in ipairs(beams) do beam:Destroy() end
            if healerLight then healerLight:Destroy() end
            if targetLight then targetLight:Destroy() end
            if att0 then att0:Destroy() end
            if att1 then att1:Destroy() end
        end
        
        -- PODER 6: RAYO AZUL ÉPICO (NUEVO)
        local function useLightning(player, targetPlayer)
            local character = player.Character
            local targetCharacter = targetPlayer.Character
            
            if not character or not targetCharacter or not targetPlayer:IsA("Player") then return end
            if not checkAndSetCooldown(player.UserId, "Lightning", POWER_CONFIG.Lightning.Cooldown) then return end
            
            local distance = (character.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
            if distance > POWER_CONFIG.Lightning.Range then return end
            
            local config = POWER_CONFIG.Lightning
            
            -- Efectos en el lanzador
            local userEffects = createAdvancedParticles(character.Head, config.Color, "lightning")
            local noseBleed = createNoseBleed(character)
            local userLight = createScreenDistortion(character, config.Color)
            
            local activationSound = createPowerSounds(character.Head, config)
            
            -- Carga eléctrica en las manos
            local chargeEffects = {}
            for _, handName in ipairs({"Left Arm", "Right Arm"}) do
                local hand = character:FindFirstChild(handName)
                if hand then
                    local charge = Instance.new("Part")
                    charge.Shape = Enum.PartType.Ball
                    charge.Size = Vector3.new(2, 2, 2)
                    charge.Anchored = false
                    charge.CanCollide = false
                    charge.Material = Enum.Material.Neon
                    charge.Color = config.Color
                    charge.Transparency = 0.3
                    charge.Parent = workspace
                    
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = hand
                    weld.Part1 = charge
                    weld.Parent = charge
                    
                    local chargeLight = Instance.new("PointLight")
                    chargeLight.Color = config.Color
                    chargeLight.Brightness = 12
                    chargeLight.Range = 15
                    chargeLight.Parent = charge
                    
                    local sparks = Instance.new("ParticleEmitter")
                    sparks.Parent = charge
                    sparks.Texture = "rbxassetid://6101261905"
                    sparks.Color = ColorSequence.new(Color3.new(1, 1, 1), config.Color)
                    sparks.Size = NumberSequence.new(0.5, 0)
                    sparks.Transparency = NumberSequence.new(0, 1)
                    sparks.Lifetime = NumberRange.new(0.2, 0.5)
                    sparks.Rate = 200
                    sparks.Speed = NumberRange.new(10, 20)
                    sparks.SpreadAngle = Vector2.new(180, 180)
                    sparks.LightEmission = 1
                    
                    table.insert(chargeEffects, charge)
                end
            end
            
            task.wait(0.5)
            
            -- Lanzar el rayo
            local startPos = character.Head.Position
            local endPos = targetCharacter.Head.Position
            
            -- Sonido de impacto
            local impactSound = Instance.new("Sound")
            impactSound.SoundId = config.ImpactSound
            impactSound.Volume = 2
            impactSound.Parent = targetCharacter.HumanoidRootPart
            impactSound:Play()
            
            -- Crear rayo con segmentos para efecto zigzag épico
            local rayParts = {}
            local segments = 12
            local deviation = 3
            
            local prevPos = startPos
            for i = 1, segments do
                local progress = i / segments
                local nextPos
                
                if i == segments then
                    nextPos = endPos
                else
                    local straightPos = startPos:Lerp(endPos, progress)
                    local randomOffset = Vector3.new(
                    math.random(-deviation, deviation),
                    math.random(-deviation, deviation),
                    math.random(-deviation, deviation)
                    )
                    nextPos = straightPos + randomOffset
                end
                
                local raySegment = Instance.new("Part")
                raySegment.Size = Vector3.new(0.5, 0.5, (prevPos - nextPos).Magnitude)
                raySegment.CFrame = CFrame.new(prevPos, nextPos) * CFrame.new(0, 0, -raySegment.Size.Z / 2)
                raySegment.Anchored = true
                raySegment.CanCollide = false
                raySegment.Material = Enum.Material.Neon
                raySegment.Color = config.Color
                raySegment.Transparency = 0.1
                raySegment.Parent = workspace
                
                local rayLight = Instance.new("PointLight")
                rayLight.Color = config.Color
                rayLight.Brightness = 15
                rayLight.Range = 20
                rayLight.Parent = raySegment
                
                table.insert(rayParts, raySegment)
                prevPos = nextPos
            end
            
            -- Rayo exterior más grueso
            prevPos = startPos
            for i = 1, segments do
                local progress = i / segments
                local nextPos
                
                if i == segments then
                    nextPos = endPos
                else
                    local straightPos = startPos:Lerp(endPos, progress)
                    local randomOffset = Vector3.new(
                    math.random(-deviation, deviation),
                    math.random(-deviation, deviation),
                    math.random(-deviation, deviation)
                    )
                    nextPos = straightPos + randomOffset
                end
                
                local outerRay = Instance.new("Part")
                outerRay.Size = Vector3.new(1.2, 1.2, (prevPos - nextPos).Magnitude)
                outerRay.CFrame = CFrame.new(prevPos, nextPos) * CFrame.new(0, 0, -outerRay.Size.Z / 2)
                outerRay.Anchored = true
                outerRay.CanCollide = false
                outerRay.Material = Enum.Material.Neon
                outerRay.Color = Color3.new(1, 1, 1)
                outerRay.Transparency = 0.6
                outerRay.Parent = workspace
                
                table.insert(rayParts, outerRay)
                prevPos = nextPos
            end
            
            -- Efectos en el objetivo
            local targetEffects = createAdvancedParticles(targetCharacter.Head, config.Color, "lightning")
            local targetLight = createScreenDistortion(targetCharacter, config.Color)
            
            -- Esfera de impacto
            local impactSphere = Instance.new("Part")
            impactSphere.Shape = Enum.PartType.Ball
            impactSphere.Size = Vector3.new(1, 1, 1)
            impactSphere.Position = endPos
            impactSphere.Anchored = true
            impactSphere.CanCollide = false
            impactSphere.Material = Enum.Material.Neon
            impactSphere.Color = config.Color
            impactSphere.Transparency = 0
            impactSphere.Parent = workspace
            
            local impactLight = Instance.new("PointLight")
            impactLight.Color = config.Color
            impactLight.Brightness = 25
            impactLight.Range = 40
            impactLight.Parent = impactSphere
            
            -- Partículas de explosión eléctrica
            for i = 1, 3 do
                local impactParticles = Instance.new("ParticleEmitter")
                impactParticles.Parent = impactSphere
                impactParticles.Texture = "rbxassetid://6101261905"
                impactParticles.Color = ColorSequence.new(config.Color)
                impactParticles.Size = NumberSequence.new(2, 0)
                impactParticles.Transparency = NumberSequence.new(0, 1)
                impactParticles.Lifetime = NumberRange.new(0.5, 1)
                impactParticles.Rate = 300
                impactParticles.Speed = NumberRange.new(20, 40)
                impactParticles.SpreadAngle = Vector2.new(180, 180)
                impactParticles.LightEmission = 1
                impactParticles.Enabled = true
            end
            
            TweenService:Create(impactSphere, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(12, 12, 12),
            Transparency = 1
            }):Play()
            TweenService:Create(impactLight, TweenInfo.new(0.3), {Brightness = 0}):Play()
            
            -- Ondas de choque eléctricas
            for i = 1, 6 do
                task.spawn(function()
                    task.wait(i * 0.05)
                    local shockwave = Instance.new("Part")
                    shockwave.Shape = Enum.PartType.Cylinder
                    shockwave.Size = Vector3.new(0.3, 1, 1)
                    shockwave.Position = endPos
                    shockwave.Rotation = Vector3.new(0, 0, 90)
                    shockwave.Anchored = true
                    shockwave.CanCollide = false
                    shockwave.Material = Enum.Material.Neon
                    shockwave.Color = config.Color
                    shockwave.Transparency = 0.3
                    shockwave.Parent = workspace
                    
                    TweenService:Create(shockwave, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(0.3, 25 + i * 3, 25 + i * 3),
                    Transparency = 1
                    }):Play()
                    Debris:AddItem(shockwave, 0.5)
                end)
            end
            
            -- Daño al objetivo
            local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
            if targetHumanoid then
                targetHumanoid:TakeDamage(config.Damage)
                
                -- Efecto de electrocución
                local stunEffect = Instance.new("BodyVelocity")
                stunEffect.MaxForce = Vector3.new(50000, 50000, 50000)
                stunEffect.Velocity = Vector3.new(0, 0, 0)
                stunEffect.Parent = targetCharacter.HumanoidRootPart
                
                -- Vibración del objetivo
                task.spawn(function()
                    for i = 1, 10 do
                        if targetCharacter and targetCharacter.Parent then
                            local randomOffset = Vector3.new(
                            math.random(-2, 2) * 0.1,
                            math.random(-2, 2) * 0.1,
                            math.random(-2, 2) * 0.1
                            )
                            targetCharacter.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame + randomOffset
                            task.wait(0.05)
                        end
                    end
                end)
                
                task.delay(0.5, function()
                    if stunEffect and stunEffect.Parent then
                        stunEffect:Destroy()
                    end
                end)
            end
            
            -- Parpadeo del rayo
            task.spawn(function()
                for i = 1, 4 do
                    for _, part in ipairs(rayParts) do
                        if part and part.Parent then
                            part.Transparency = 1
                        end
                    end
                    task.wait(0.05)
                    for _, part in ipairs(rayParts) do
                        if part and part.Parent then
                            part.Transparency = part.Size.X > 0.8 and 0.6 or 0.1
                        end
                    end
                    task.wait(0.05)
                end
            end)
            
            -- Limpiar efectos
            task.wait(0.4)
            
            for _, part in ipairs(rayParts) do
                if part and part.Parent then
                    TweenService:Create(part, TweenInfo.new(0.2), {Transparency = 1}):Play()
                end
            end
            
            for _, charge in ipairs(chargeEffects) do
                if charge and charge.Parent then
                    charge:Destroy()
                end
            end
            
            task.delay(0.2, function()
                for _, part in ipairs(rayParts) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
            end)
            
            for _, child in ipairs(impactSphere:GetChildren()) do
                if child:IsA("ParticleEmitter") then
                    child.Enabled = false
                end
            end
            
            task.wait(0.5)
            for _, effect in ipairs(userEffects) do effect:Destroy() end
            for _, effect in ipairs(targetEffects) do effect:Destroy() end
            if noseBleed then noseBleed:Destroy() end
            if userLight then userLight:Destroy() end
            if targetLight then targetLight:Destroy() end
            if impactSphere then impactSphere:Destroy() end
        end
        
        -- Conectar eventos
        telekinesisPower.OnServerEvent:Connect(function(player, targetPlayer)
            if targetPlayer and targetPlayer:IsA("Player") then
                useTelekinesis(player, targetPlayer)
            end
        end)
        
        explosionPower.OnServerEvent:Connect(function(player, targetPlayer)
            if targetPlayer and targetPlayer:IsA("Player") then
                useExplosion(player, targetPlayer)
            end
        end)
        
        controlPower.OnServerEvent:Connect(function(player)
            useControl(player)
        end)
        
        protectionPower.OnServerEvent:Connect(function(player)
            useProtection(player)
        end)
        
        healingPower.OnServerEvent:Connect(function(player, targetPlayer)
            if targetPlayer and targetPlayer:IsA("Player") then
                useHealing(player, targetPlayer)
            end
        end)
        
        lightningPower.OnServerEvent:Connect(function(player, targetPlayer)
            if targetPlayer and targetPlayer:IsA("Player") then
                useLightning(player, targetPlayer)
            end
        end)
        
        print("✓ STRANGER THINGS EPIC POWERS SYSTEM - ENHANCED VERSION")
        print("✓ Efectos visuales ultra épicos con múltiples capas")
        print("✓ Sistema de sonidos mejorado")
        print("✓ Poderes: Telekinesis (Q), Explosión (E), Control (R), Protección (T), Curación (F), Rayo (G)")
        print("✓ Nuevo poder: RAYO AZUL DEVASTADOR")
