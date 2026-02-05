-- TECHO ÉPICO DEL UPSIDE DOWN CON RAYOS Y NUBES
-- ServerScriptService

local TweenService = game:GetService("TweenService")

-- CONFIGURACIÓN
local MAP_SIZE = 2048
local CEILING_HEIGHT = 1000  -- Altura donde está el techo
local CEILING_THICKNESS = 50

print("🌩️ Generando techo épico del Upside Down...")

-- CREAR TECHO BASE (INVISIBLE)
local ceiling = Instance.new("Part")
ceiling.Name = "UpsideDownCeiling"
ceiling.Size = Vector3.new(MAP_SIZE, CEILING_THICKNESS, MAP_SIZE)
ceiling.Position = Vector3.new(0, CEILING_HEIGHT, 0)
ceiling.Anchored = true
ceiling.CanCollide = true
ceiling.Material = Enum.Material.ForceField
ceiling.Color = Color3.fromRGB(80, 40, 40)
ceiling.Transparency = 0.95  -- Casi invisible
ceiling.Parent = workspace

print("✅ Techo base creado")

-- NUBES ROJAS GIGANTES
local function createClouds()
    print("☁️ Creando nubes rojas...")
    
    for i = 1, 40 do
        local cloud = Instance.new("Part")
        cloud.Name = "Cloud"
        cloud.Size = Vector3.new(
            math.random(100, 250),
            math.random(30, 60),
            math.random(100, 250)
        )
        cloud.Position = Vector3.new(
            math.random(-MAP_SIZE/2, MAP_SIZE/2),
            CEILING_HEIGHT - math.random(10, 40),
            math.random(-MAP_SIZE/2, MAP_SIZE/2)
        )
        cloud.Anchored = true
        cloud.CanCollide = false
        cloud.Material = Enum.Material.Neon
        cloud.Color = Color3.fromRGB(
            math.random(80, 120),
            math.random(30, 50),
            math.random(30, 50)
        )
        cloud.Transparency = 0.6
        cloud.Parent = ceiling
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Scale = Vector3.new(1, 0.4, 1)
        mesh.Parent = cloud
        
        -- Movimiento lento
        task.spawn(function()
            while cloud and cloud.Parent do
                local duration = math.random(20, 40)
                TweenService:Create(cloud, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                    Position = cloud.Position + Vector3.new(
                        math.random(-100, 100),
                        math.random(-10, 10),
                        math.random(-100, 100)
                    ),
                    Transparency = math.random(50, 80) / 100
                }):Play()
                task.wait(duration)
            end
        end)
    end
end

-- RAYOS CAYENDO DEL TECHO (MUCHOS)
local function createLightningSystem()
    print("⚡ Activando sistema de rayos...")
    
    task.spawn(function()
        while ceiling and ceiling.Parent do
            task.wait(math.random(1, 3))
            
            -- Posición aleatoria
            local x = math.random(-MAP_SIZE/2 + 100, MAP_SIZE/2 - 100)
            local z = math.random(-MAP_SIZE/2 + 100, MAP_SIZE/2 - 100)
            
            -- Rayo principal
            local lightning = Instance.new("Part")
            lightning.Name = "Lightning"
            lightning.Size = Vector3.new(4, CEILING_HEIGHT - 50, 4)
            lightning.Position = Vector3.new(x, CEILING_HEIGHT/2, z)
            lightning.Anchored = true
            lightning.CanCollide = false
            lightning.Material = Enum.Material.Neon
            lightning.Color = Color3.fromRGB(255, 100, 100)
            lightning.Transparency = 0.2
            lightning.Parent = workspace
            
            -- Luz intensa
            local light = Instance.new("PointLight")
            light.Brightness = 20
            light.Color = Color3.fromRGB(255, 80, 80)
            light.Range = 200
            light.Parent = lightning
            
            -- Ramificaciones del rayo
            for i = 1, math.random(2, 4) do
                local branch = Instance.new("Part")
                branch.Size = Vector3.new(2, math.random(100, 300), 2)
                branch.Position = Vector3.new(
                    x + math.random(-30, 30),
                    math.random(CEILING_HEIGHT/2, CEILING_HEIGHT - 100),
                    z + math.random(-30, 30)
                )
                branch.Anchored = true
                branch.CanCollide = false
                branch.Material = Enum.Material.Neon
                branch.Color = Color3.fromRGB(255, 120, 120)
                branch.Transparency = 0.4
                branch.Orientation = Vector3.new(
                    math.random(-30, 30),
                    math.random(0, 360),
                    math.random(-30, 30)
                )
                branch.Parent = lightning
            end
            
            -- Sonido de trueno
            local thunder = Instance.new("Sound")
            thunder.SoundId = "rbxassetid://130818250"
            thunder.Volume = 0.6
            thunder.Parent = lightning
            thunder:Play()
            
            -- Animación de parpadeo
            for i = 1, 8 do
                lightning.Transparency = 0.1
                task.wait(0.04)
                lightning.Transparency = 0.8
                task.wait(0.04)
            end
            
            lightning:Destroy()
        end
    end)
end

-- VÓRTICES ROJOS GIRATORIOS
local function createVortexes()
    print("🌀 Creando vórtices...")
    
    for i = 1, 15 do
        local vortex = Instance.new("Part")
        vortex.Name = "Vortex"
        vortex.Size = Vector3.new(80, 5, 80)
        vortex.Position = Vector3.new(
            math.random(-MAP_SIZE/2, MAP_SIZE/2),
            CEILING_HEIGHT - 20,
            math.random(-MAP_SIZE/2, MAP_SIZE/2)
        )
        vortex.Anchored = true
        vortex.CanCollide = false
        vortex.Material = Enum.Material.Neon
        vortex.Color = Color3.fromRGB(200, 80, 80)
        vortex.Transparency = 0.5
        vortex.Shape = Enum.PartType.Cylinder
        vortex.Parent = ceiling
        
        -- Rotación constante
        task.spawn(function()
            while vortex and vortex.Parent do
                vortex.Orientation = vortex.Orientation + Vector3.new(0, 5, 0)
                task.wait(0.05)
            end
        end)
        
        -- Pulso
        task.spawn(function()
            while vortex and vortex.Parent do
                TweenService:Create(vortex, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                    Transparency = 0.3,
                    Size = Vector3.new(90, 5, 90)
                }):Play()
                task.wait(2)
                TweenService:Create(vortex, TweenInfo.new(2, Enum.EasingStyle.Sine), {
                    Transparency = 0.7,
                    Size = Vector3.new(70, 5, 70)
                }):Play()
                task.wait(2)
            end
        end)
    end
end

-- GRIETAS CON LUZ ROJA
local function createCracks()
    print("💥 Creando grietas luminosas...")
    
    for i = 1, 60 do
        local crack = Instance.new("Part")
        crack.Name = "Crack"
        crack.Size = Vector3.new(
            math.random(2, 5),
            math.random(50, 150),
            math.random(2, 5)
        )
        crack.Position = Vector3.new(
            math.random(-MAP_SIZE/2, MAP_SIZE/2),
            CEILING_HEIGHT - 25,
            math.random(-MAP_SIZE/2, MAP_SIZE/2)
        )
        crack.Anchored = true
        crack.CanCollide = false
        crack.Material = Enum.Material.Neon
        crack.Color = Color3.fromRGB(255, 50, 50)
        crack.Transparency = 0.3
        crack.Orientation = Vector3.new(
            math.random(-45, 45),
            math.random(0, 360),
            math.random(-45, 45)
        )
        crack.Parent = ceiling
        
        -- Luz
        local light = Instance.new("PointLight")
        light.Brightness = 5
        light.Color = Color3.fromRGB(255, 80, 80)
        light.Range = 60
        light.Parent = crack
        
        -- Parpadeo
        task.spawn(function()
            while crack and crack.Parent do
                TweenService:Create(crack, TweenInfo.new(0.5), {
                    Transparency = 0.1
                }):Play()
                task.wait(0.5)
                TweenService:Create(crack, TweenInfo.new(0.5), {
                    Transparency = 0.6
                }):Play()
                task.wait(0.5)
            end
        end)
    end
end

-- PARTÍCULAS CAYENDO DEL TECHO
local function createFallingParticles()
    print("🌫️ Creando partículas cayendo...")
    
    for i = 1, 30 do
        local emitter = Instance.new("Part")
        emitter.Size = Vector3.new(1, 1, 1)
        emitter.Position = Vector3.new(
            math.random(-MAP_SIZE/2, MAP_SIZE/2),
            CEILING_HEIGHT - 10,
            math.random(-MAP_SIZE/2, MAP_SIZE/2)
        )
        emitter.Anchored = true
        emitter.CanCollide = false
        emitter.Transparency = 1
        emitter.Parent = ceiling
        
        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxassetid://6073894699"
        particles.Rate = 15
        particles.Lifetime = NumberRange.new(8, 12)
        particles.Speed = NumberRange.new(10, 20)
        particles.SpreadAngle = Vector2.new(10, 10)
        particles.Color = ColorSequence.new(Color3.fromRGB(200, 100, 100))
        particles.Size = NumberSequence.new(3, 6)
        particles.Transparency = NumberSequence.new(0.4, 0.9)
        particles.LightEmission = 0.5
        particles.Acceleration = Vector3.new(0, -20, 0)
        particles.Parent = emitter
    end
end

-- LUCES PULSANTES EN EL TECHO
local function createPulsingLights()
    print("💡 Creando luces pulsantes...")
    
    for i = 1, 50 do
        local lightPart = Instance.new("Part")
        lightPart.Name = "CeilingLight"
        lightPart.Size = Vector3.new(6, 6, 6)
        lightPart.Shape = Enum.PartType.Ball
        lightPart.Position = Vector3.new(
            math.random(-MAP_SIZE/2, MAP_SIZE/2),
            CEILING_HEIGHT - math.random(20, 50),
            math.random(-MAP_SIZE/2, MAP_SIZE/2)
        )
        lightPart.Anchored = true
        lightPart.CanCollide = false
        lightPart.Material = Enum.Material.Neon
        lightPart.Color = Color3.fromRGB(255, 80, 80)
        lightPart.Transparency = 0.4
        lightPart.Parent = ceiling
        
        local light = Instance.new("PointLight")
        light.Brightness = 10
        light.Color = Color3.fromRGB(255, 100, 100)
        light.Range = 100
        light.Parent = lightPart
        
        -- Pulso
        task.spawn(function()
            while lightPart and lightPart.Parent do
                TweenService:Create(lightPart, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    Transparency = 0.2,
                    Size = Vector3.new(8, 8, 8)
                }):Play()
                TweenService:Create(light, TweenInfo.new(1), {
                    Brightness = 15
                }):Play()
                task.wait(1)
                TweenService:Create(lightPart, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    Transparency = 0.6,
                    Size = Vector3.new(6, 6, 6)
                }):Play()
                TweenService:Create(light, TweenInfo.new(1), {
                    Brightness = 5
                }):Play()
                task.wait(1)
            end
        end)
    end
end

-- EJECUTAR TODO
createClouds()
task.wait(0.2)

createLightningSystem()
task.wait(0.2)

createVortexes()
task.wait(0.2)

createCracks()
task.wait(0.2)

createFallingParticles()
task.wait(0.2)

createPulsingLights()

print("========================================")
print("✅ ¡TECHO ÉPICO COMPLETADO!")
print("☁️ 40 nubes rojas en movimiento")
print("⚡ Sistema de rayos constantes")
print("🌀 15 vórtices giratorios")
print("💥 60 grietas luminosas")
print("🌫️ 30 emisores de partículas")
print("💡 50 luces pulsantes")
print("========================================")
