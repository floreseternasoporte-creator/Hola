-- UPSIDE DOWN FILTER - STRANGER THINGS
-- LocalScript en StarterPlayer > StarterPlayerScripts

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🌀 Upside Down Filter - Iniciando...")

-- CREAR EFECTOS DE LIGHTING
local function setupLighting()
    -- Color Correction (tono rojo oscuro)
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "UpsideDownColor"
    colorCorrection.Brightness = 0.05
    colorCorrection.Contrast = 0.2
    colorCorrection.Saturation = -0.3
    colorCorrection.TintColor = Color3.fromRGB(200, 140, 140)
    colorCorrection.Parent = Lighting
    
    -- Bloom (resplandor)
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "UpsideDownBloom"
    bloom.Intensity = 0.8
    bloom.Size = 24
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    
    -- Atmosphere (niebla densa)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "UpsideDownAtmosphere"
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.2
    atmosphere.Color = Color3.fromRGB(140, 110, 110)
    atmosphere.Glare = 0.3
    atmosphere.Haze = 1.5
    atmosphere.Parent = Lighting
    
    -- Blur (desenfoque sutil)
    local blur = Instance.new("BlurEffect")
    blur.Name = "UpsideDownBlur"
    blur.Size = 2
    blur.Parent = Lighting
    
    -- DepthOfField (profundidad)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Name = "UpsideDownDOF"
    dof.FarIntensity = 0.3
    dof.FocusDistance = 20
    dof.InFocusRadius = 15
    dof.NearIntensity = 0.5
    dof.Parent = Lighting
    
    -- SunRays (rayos oscuros)
    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Name = "UpsideDownRays"
    sunRays.Intensity = 0.15
    sunRays.Spread = 0.8
    sunRays.Parent = Lighting
    
    -- Ajustar iluminación global (MÁS BRILLANTE)
    Lighting.Ambient = Color3.fromRGB(150, 120, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 140, 140)
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 14
    Lighting.FogColor = Color3.fromRGB(120, 80, 80)
    Lighting.FogEnd = 800
    Lighting.FogStart = 100
    
    print("✅ Lighting configurado")
end

-- CREAR GUI DE ESPORAS Y EFECTOS
local function createUpsideDownGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UpsideDownFilter"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 1
    screenGui.Parent = playerGui
    
    -- VIGNETTE OSCURO
    local vignette = Instance.new("ImageLabel")
    vignette.Name = "Vignette"
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundTransparency = 1
    vignette.Image = "rbxasset://textures/ui/VignetteMask.png"
    vignette.ImageColor3 = Color3.fromRGB(60, 30, 30)
    vignette.ImageTransparency = 0.2
    vignette.ZIndex = 1
    vignette.Parent = screenGui
    
    -- OVERLAY ROJO OSCURO
    local overlay = Instance.new("Frame")
    overlay.Name = "RedOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
    overlay.BackgroundTransparency = 0.85
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 2
    overlay.Parent = screenGui
    
    -- GRADIENTE VERTICAL
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 30, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 20, 20))
    }
    gradient.Rotation = 90
    gradient.Parent = overlay
    
    -- CONTENEDOR DE ESPORAS
    local sporesContainer = Instance.new("Frame")
    sporesContainer.Name = "SporesContainer"
    sporesContainer.Size = UDim2.new(1, 0, 1, 0)
    sporesContainer.BackgroundTransparency = 1
    sporesContainer.ClipsDescendants = false
    sporesContainer.ZIndex = 3
    sporesContainer.Parent = screenGui
    
    -- CREAR ESPORAS FLOTANTES (80 esporas)
    for i = 1, 80 do
        local spore = Instance.new("ImageLabel")
        spore.Name = "Spore" .. i
        
        -- Tamaño aleatorio
        local size = math.random(8, 25)
        spore.Size = UDim2.new(0, size, 0, size)
        
        -- Posición aleatoria
        spore.Position = UDim2.new(
            math.random(0, 100) / 100,
            math.random(-50, 50),
            math.random(0, 100) / 100,
            math.random(-50, 50)
        )
        
        spore.BackgroundTransparency = 1
        spore.Image = "rbxassetid://6073894699" -- Partícula circular
        spore.ImageColor3 = Color3.fromRGB(
            math.random(200, 255),
            math.random(180, 220),
            math.random(150, 200)
        )
        spore.ImageTransparency = math.random(30, 70) / 100
        spore.ZIndex = 3 + math.random(1, 5)
        spore.Parent = sporesContainer
        
        -- Rotación aleatoria
        spore.Rotation = math.random(0, 360)
        
        -- ANIMACIÓN FLOTANTE
        task.spawn(function()
            local duration = math.random(8, 15)
            local delay = math.random(0, 30) / 10
            
            task.wait(delay)
            
            while spore and spore.Parent do
                -- Movimiento flotante
                local targetX = math.random(0, 100) / 100
                local targetY = math.random(0, 100) / 100
                
                local tweenInfo = TweenInfo.new(
                    duration,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                )
                
                local tween = TweenService:Create(spore, tweenInfo, {
                    Position = UDim2.new(
                        targetX,
                        math.random(-50, 50),
                        targetY,
                        math.random(-50, 50)
                    ),
                    Rotation = spore.Rotation + math.random(-180, 180),
                    ImageTransparency = math.random(30, 80) / 100
                })
                
                tween:Play()
                tween.Completed:Wait()
                
                task.wait(0.5)
            end
        end)
    end
    
    -- PARTÍCULAS GRANDES (ceniza)
    for i = 1, 30 do
        local ash = Instance.new("Frame")
        ash.Name = "Ash" .. i
        
        local size = math.random(2, 6)
        ash.Size = UDim2.new(0, size, 0, size)
        ash.Position = UDim2.new(
            math.random(0, 100) / 100,
            0,
            math.random(-20, 120) / 100,
            0
        )
        ash.BackgroundColor3 = Color3.fromRGB(
            math.random(150, 200),
            math.random(140, 180),
            math.random(130, 170)
        )
        ash.BackgroundTransparency = math.random(40, 80) / 100
        ash.BorderSizePixel = 0
        ash.ZIndex = 4
        ash.Parent = sporesContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ash
        
        -- CAÍDA LENTA
        task.spawn(function()
            while ash and ash.Parent do
                local duration = math.random(15, 25)
                
                local tweenInfo = TweenInfo.new(
                    duration,
                    Enum.EasingStyle.Linear
                )
                
                local tween = TweenService:Create(ash, tweenInfo, {
                    Position = UDim2.new(
                        ash.Position.X.Scale + math.random(-10, 10) / 100,
                        0,
                        1.2,
                        0
                    )
                })
                
                tween:Play()
                tween.Completed:Wait()
                
                -- Reiniciar arriba
                ash.Position = UDim2.new(
                    math.random(0, 100) / 100,
                    0,
                    -0.1,
                    0
                )
            end
        end)
    end
    
    -- EFECTO DE PULSO EN OVERLAY
    task.spawn(function()
        while overlay and overlay.Parent do
            TweenService:Create(overlay, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.8
            }):Play()
            task.wait(3)
            TweenService:Create(overlay, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.9
            }):Play()
            task.wait(3)
        end
    end)
    
    -- EFECTO DE PULSO EN VIGNETTE
    task.spawn(function()
        while vignette and vignette.Parent do
            TweenService:Create(vignette, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.1
            }):Play()
            task.wait(4)
            TweenService:Create(vignette, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.3
            }):Play()
            task.wait(4)
        end
    end)
    
    print("✅ GUI del Upside Down creado")
end

-- SONIDO AMBIENTAL
local function createAmbientSound()
    local sound = Instance.new("Sound")
    sound.Name = "UpsideDownAmbient"
    sound.SoundId = "rbxassetid://9114397505" -- Sonido ambiente oscuro
    sound.Volume = 0.3
    sound.Looped = true
    sound.Parent = workspace
    sound:Play()
    
    print("✅ Sonido ambiental activado")
end

-- INICIALIZAR TODO
setupLighting()
createUpsideDownGUI()
createAmbientSound()

print("🌀 Upside Down Filter - ¡ACTIVADO!")
