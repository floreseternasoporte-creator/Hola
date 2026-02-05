-- Script del Servidor para generar árboles terroríficos
-- CON SISTEMA DE MADERA Y RECOMPENSAS
-- Coloca este script en ServerScriptService.

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

math.randomseed(tick())

-- ===================== CONFIGURACIÓN =====================
local TREES_MODEL_NAME = "Terrifying_Studs_Trees"

-- Densidad
local GRID_SPACING = 120
local TREE_SPAWN_PROBABILITY = 0.4
local MIN_DISTANCE_FROM_EDGE = 50

-- Colores terroríficos
local TREE_COLORS = {
Color3.fromRGB(90, 20, 30),
Color3.fromRGB(70, 15, 40),
Color3.fromRGB(105, 25, 25),
Color3.fromRGB(85, 10, 35),
Color3.fromRGB(60, 8, 20),
}

local BRANCH_COLORS = {
Color3.fromRGB(120, 35, 45),
Color3.fromRGB(95, 25, 50),
Color3.fromRGB(110, 30, 35),
}

-- Árbol
local TRUNK_HEIGHT_MIN = 30
local TRUNK_HEIGHT_MAX = 50
local TRUNK_BASE_WIDTH_MIN = 5
local TRUNK_BASE_WIDTH_MAX = 8

-- Sistema de recompensas
local WOOD_PER_TREE = 3
local HITS_TO_DESTROY = 3
local DESPAWN_DELAY = 10

-- Crear RemoteEvent para comunicación con cliente
local woodEvent = Instance.new("RemoteEvent")
woodEvent.Name = "WoodEvent"
woodEvent.Parent = ReplicatedStorage

-- ===================== HELPERS =====================
local function randFloat(a,b) return a + math.random() * (b - a) end

local function randomChoice(tbl)
    return tbl[math.random(1, #tbl)]
end

-- Aplicar estilo
local function applyTerrifyingStyle(part, isBranch)
    part.Material = Enum.Material.Plastic
    part.Color = isBranch and randomChoice(BRANCH_COLORS) or randomChoice(TREE_COLORS)
    part.Anchored = true
    part.CanCollide = false
    
    part.TopSurface = Enum.SurfaceType.Studs
    part.BottomSurface = Enum.SurfaceType.Inlet
    part.LeftSurface = Enum.SurfaceType.Studs
    part.RightSurface = Enum.SurfaceType.Studs
    part.FrontSurface = Enum.SurfaceType.Inlet
    part.BackSurface = Enum.SurfaceType.Inlet
    
    -- Luz ocasional
    if math.random() > 0.8 then
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(150, 30, 40)
        light.Brightness = 0.25
        light.Range = 12
        light.Parent = part
    end
end

-- Detectar mapa
local function obtenerAreaMapa()
    print("🗺️ Detectando límites del mapa...")
    
    local mapBounds = Workspace:FindFirstChild("MapBounds")
    if mapBounds and mapBounds:IsA("BasePart") then
        print("✓ Usando MapBounds")
        return mapBounds.Position, mapBounds.Size
    end
    
    local mapModel = Workspace:FindFirstChild("Map")
    if mapModel and mapModel:IsA("Model") then
        local minX, maxX = math.huge, -math.huge
        local minZ, maxZ = math.huge, -math.huge
        local partsFound = 0
        
        for _, obj in pairs(mapModel:GetDescendants()) do
            if obj:IsA("BasePart") then
                partsFound = partsFound + 1
                local pos = obj.Position
                local size = obj.Size
                minX = math.min(minX, pos.X - size.X/2)
                maxX = math.max(maxX, pos.X + size.X/2)
                minZ = math.min(minZ, pos.Z - size.Z/2)
                maxZ = math.max(maxZ, pos.Z + size.Z/2)
            end
        end
        
        if partsFound > 0 then
            local centerX = (minX + maxX) / 2
            local centerZ = (minZ + maxZ) / 2
            local sizeX = maxX - minX
            local sizeZ = maxZ - minZ
            print("✓ Usando Map: " .. partsFound .. " partes")
            return Vector3.new(centerX, 0, centerZ), Vector3.new(sizeX, 50, sizeZ)
        end
    end
    
    local baseplate = Workspace:FindFirstChild("Baseplate")
    if baseplate and baseplate:IsA("BasePart") then
        print("✓ Usando Baseplate")
        return baseplate.Position, baseplate.Size
    end
    
    print("⚠️ Usando área predeterminada")
    return Vector3.new(0, 0, 0), Vector3.new(500, 20, 500)
end

-- Raycast
local function raycastGroundAt(x, z)
    local origin = Vector3.new(x, 1000, z)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {Workspace:FindFirstChild(TREES_MODEL_NAME)}
    local result = Workspace:Raycast(origin, Vector3.new(0, -2000, 0), params)
    if result then
        return result.Position, true
    end
    return nil, false
end

-- ===================== SISTEMA DE DERRIBO =====================
local function setupTreeChopping(treeModel, trunk, groundPosition)
    -- Crear parte invisible en el suelo para el ProximityPrompt
    local promptPart = Instance.new("Part")
    promptPart.Name = "PromptPart"
    promptPart.Size = Vector3.new(6, 6, 6)
    promptPart.Position = groundPosition + Vector3.new(0, 3, 0)
    promptPart.Anchored = true
    promptPart.CanCollide = false
    promptPart.Transparency = 1
    promptPart.Parent = treeModel
    
    local proximityPrompt = Instance.new("ProximityPrompt")
    proximityPrompt.ActionText = "Cortar árbol"
    proximityPrompt.ObjectText = "🌲 Árbol"
    proximityPrompt.MaxActivationDistance = 12
    proximityPrompt.HoldDuration = 0.5
    proximityPrompt.RequiresLineOfSight = false
    proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    proximityPrompt.Parent = promptPart
    
    local hitCount = 0
    
    -- Efecto de partículas
    local function createHitEffect(position)
        local particles = Instance.new("Part")
        particles.Size = Vector3.new(1, 1, 1)
        particles.Position = position
        particles.Anchored = true
        particles.CanCollide = false
        particles.Transparency = 1
        particles.Parent = Workspace
        
        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        particleEmitter.Color = ColorSequence.new(Color3.fromRGB(139, 69, 19))
        particleEmitter.Size = NumberSequence.new(0.5, 0.1)
        particleEmitter.Lifetime = NumberRange.new(0.5, 1)
        particleEmitter.Rate = 50
        particleEmitter.Speed = NumberRange.new(5, 10)
        particleEmitter.SpreadAngle = Vector2.new(45, 45)
        particleEmitter.Parent = particles
        particleEmitter.Enabled = true
        
        task.delay(0.3, function()
            particleEmitter.Enabled = false
        end)
        
        game:GetService("Debris"):AddItem(particles, 2)
    end
    
    proximityPrompt.Triggered:Connect(function(player)
        hitCount = hitCount + 1
        
        print("🪓 [" .. player.Name .. "] Golpe " .. hitCount .. "/" .. HITS_TO_DESTROY)
        
        -- SONIDO DE GOLPE
        local hitSound = Instance.new("Sound")
        hitSound.SoundId = "rbxassetid://6881026094"
        hitSound.Volume = 0.8
        hitSound.Parent = promptPart
        hitSound:Play()
        game:GetService("Debris"):AddItem(hitSound, 3)
        
        -- EFECTO VISUAL
        createHitEffect(groundPosition + Vector3.new(0, 5, 0))
        
        -- SHAKE
        local originalCFrame = trunk.CFrame
        for i = 1, 3 do
            if trunk and trunk.Parent then
                trunk.CFrame = originalCFrame * CFrame.Angles(
                math.rad(randFloat(-3, 3)),
                0,
                math.rad(randFloat(-3, 3))
                )
                task.wait(0.05)
            end
        end
        if trunk and trunk.Parent then
            trunk.CFrame = originalCFrame
        end
        
        -- Actualizar texto
        proximityPrompt.ObjectText = string.format("🌲 %d/%d", hitCount, HITS_TO_DESTROY)
        
        -- Derribar al tercer golpe
        if hitCount >= HITS_TO_DESTROY then
            proximityPrompt.Enabled = false
            
            print("🌲 [" .. player.Name .. "] ¡Árbol derribado! +3 madera")
            
            -- DAR MADERA AL JUGADOR (usando DataStore)
            if _G.AddWood then
                _G.AddWood(player, WOOD_PER_TREE)
            end
            
            -- Notificar al cliente para animación
            woodEvent:FireClient(player, WOOD_PER_TREE)
            
            -- Destruir TODOS los welds
            for _, descendant in pairs(treeModel:GetDescendants()) do
                if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
                    descendant:Destroy()
                end
            end
            
            task.wait(0.05)
            
            -- Re-soldar TODO al tronco
            for _, part in pairs(treeModel:GetDescendants()) do
                if part:IsA("BasePart") and part ~= trunk and part ~= promptPart then
                    local weld = Instance.new("Weld")
                    weld.Part0 = trunk
                    weld.Part1 = part
                    weld.C0 = trunk.CFrame:Inverse() * part.CFrame
                    weld.Parent = trunk
                end
            end
            
            task.wait(0.1)
            
            -- Física
            trunk.Anchored = false
            trunk.CanCollide = true
            
            -- Caída
            local fallDirection = Vector3.new(randFloat(-1, 1), 0, randFloat(-1, 1)).Unit
            trunk:ApplyImpulse(fallDirection * 6000 + Vector3.new(0, 2000, 0))
            trunk:ApplyAngularImpulse(Vector3.new(randFloat(-8000, 8000), 0, randFloat(-8000, 8000)))
            
            -- Sonido de caída
            local fallSound = Instance.new("Sound")
            fallSound.SoundId = "rbxassetid://9125402735"
            fallSound.Volume = 0.7
            fallSound.Parent = trunk
            fallSound:Play()
            
            -- DESPAWN
            task.wait(DESPAWN_DELAY)
            
            print("💨 Despawneando árbol...")
            
            -- Fade out
            for _, part in pairs(treeModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    task.spawn(function()
                        pcall(function()
                            local tween = TweenService:Create(part, TweenInfo.new(1.5), {Transparency = 1})
                            tween:Play()
                        end)
                    end)
                end
            end
            
            task.wait(2)
            
            if treeModel and treeModel.Parent then
                treeModel:Destroy()
            end
        end
    end)
end

-- ===================== CREACIÓN DE ÁRBOL MEJORADO =====================
local function createTree(position)
    local treeModel = Instance.new("Model")
    treeModel.Name = "TerrifyingTree"
    
    local trunkHeight = randFloat(TRUNK_HEIGHT_MIN, TRUNK_HEIGHT_MAX)
    local baseWidth = randFloat(TRUNK_BASE_WIDTH_MIN, TRUNK_BASE_WIDTH_MAX)
    
    -- TRONCO PRINCIPAL - MÁS NATURAL
    local trunk = Instance.new("Part")
    trunk.Name = "Trunk"
    trunk.Size = Vector3.new(baseWidth, trunkHeight, baseWidth)
    trunk.Position = position + Vector3.new(0, trunkHeight/2, 0)
    trunk.CFrame = trunk.CFrame * CFrame.Angles(
    math.rad(randFloat(-3, 3)),
    math.rad(randFloat(0, 360)),
    math.rad(randFloat(-3, 3))
    )
    applyTerrifyingStyle(trunk, false)
    trunk.CanCollide = true
    trunk.Parent = treeModel
    
    -- RAMAS PRINCIPALES - MÁS DENSAS Y NATURALES
    local numBranches = math.random(18, 28)
    
    for i = 1, numBranches do
        local heightPercent = randFloat(0.35, 0.95)
        local branchLength = randFloat(7, 16)
        local branchThick = randFloat(2, 3.5)
        
        local angleAround = math.rad(randFloat(0, 360))
        local angleOut = math.rad(randFloat(25, 75))
        
        -- Rama principal
        local branch = Instance.new("Part")
        branch.Name = "Branch"
        branch.Size = Vector3.new(branchThick, branchLength, branchThick)
        
        branch.CFrame = CFrame.new(trunk.Position) *
        CFrame.new(0, (heightPercent - 0.5) * trunkHeight, 0) *
        CFrame.Angles(0, angleAround, 0) *
        CFrame.Angles(angleOut, 0, 0) *
        CFrame.Angles(0, 0, math.rad(randFloat(-30, 30))) *
        CFrame.new(0, branchLength/2, 0)
        
        applyTerrifyingStyle(branch, true)
        branch.Parent = treeModel
        
        -- Weld
        local weld = Instance.new("Weld")
        weld.Part0 = trunk
        weld.Part1 = branch
        weld.C0 = trunk.CFrame:Inverse() * branch.CFrame
        weld.Parent = trunk
        
        -- Sub-ramas para más densidad
        if math.random() > 0.4 then
            for j = 1, math.random(1, 3) do
                local subBranch = Instance.new("Part")
                subBranch.Name = "SubBranch"
                local subLength = randFloat(4, 9)
                local subThick = randFloat(1.2, 2.2)
                subBranch.Size = Vector3.new(subThick, subLength, subThick)
                
                subBranch.CFrame = branch.CFrame *
                CFrame.new(0, randFloat(-branchLength/2, branchLength/2), 0) *
                CFrame.Angles(
                math.rad(randFloat(-60, 60)),
                math.rad(randFloat(0, 360)),
                math.rad(randFloat(-60, 60))
                ) *
                CFrame.new(0, subLength/2, 0)
                
                applyTerrifyingStyle(subBranch, true)
                subBranch.Parent = treeModel
                
                -- Weld al tronco
                local subWeld = Instance.new("Weld")
                subWeld.Part0 = trunk
                subWeld.Part1 = subBranch
                subWeld.C0 = trunk.CFrame:Inverse() * subBranch.CFrame
                subWeld.Parent = trunk
            end
        end
    end
    
    -- NUDOS TERRORÍFICOS
    local numKnots = math.random(6, 12)
    for i = 1, numKnots do
        local knot = Instance.new("Part")
        knot.Name = "Knot"
        knot.Shape = Enum.PartType.Ball
        local knotSize = randFloat(2.5, 5)
        knot.Size = Vector3.new(knotSize, knotSize, knotSize)
        
        local knotAngle = math.rad(randFloat(0, 360))
        local knotHeight = randFloat(0.15, 0.85) * trunkHeight
        
        knot.CFrame = CFrame.new(trunk.Position) *
        CFrame.new(0, (knotHeight / trunkHeight - 0.5) * trunkHeight, 0) *
        CFrame.Angles(0, knotAngle, 0) *
        CFrame.new(baseWidth/2 + knotSize/3, 0, 0)
        
        applyTerrifyingStyle(knot, true)
        knot.Parent = treeModel
        
        -- Weld
        local weld = Instance.new("Weld")
        weld.Part0 = trunk
        weld.Part1 = knot
        weld.C0 = trunk.CFrame:Inverse() * knot.CFrame
        weld.Parent = trunk
    end
    
    setupTreeChopping(treeModel, trunk, position)
    
    return treeModel
end

-- ===================== GENERACIÓN =====================
local function generateTrees()
    local existing = Workspace:FindFirstChild(TREES_MODEL_NAME)
    if existing then
        existing:Destroy()
        task.wait()
    end
    
    local model = Instance.new("Model")
    model.Name = TREES_MODEL_NAME
    model.Parent = Workspace
    
    local center, size = obtenerAreaMapa()
    
    local minX = center.X - size.X / 2 + MIN_DISTANCE_FROM_EDGE
    local maxX = center.X + size.X / 2 - MIN_DISTANCE_FROM_EDGE
    local minZ = center.Z - size.Z / 2 + MIN_DISTANCE_FROM_EDGE
    local maxZ = center.Z + size.Z / 2 - MIN_DISTANCE_FROM_EDGE
    
    print("📍 Área: X=" .. minX .. " a " .. maxX .. ", Z=" .. minZ .. " a " .. maxZ)
    
    local treesCreated = 0
    
    for x = minX, maxX, GRID_SPACING do
        for z = minZ, maxZ, GRID_SPACING do
            if math.random() <= TREE_SPAWN_PROBABILITY then
                local spawnX = x + randFloat(-GRID_SPACING/4, GRID_SPACING/4)
                local spawnZ = z + randFloat(-GRID_SPACING/4, GRID_SPACING/4)
                
                local groundPos, hasGround = raycastGroundAt(spawnX, spawnZ)
                
                if hasGround and groundPos then
                    local tree = createTree(groundPos)
                    tree.Parent = model
                    treesCreated = treesCreated + 1
                end
            end
        end
    end
    
    print("╔════════════════════════════════════╗")
    print("║  🌲 ÁRBOLES TERRORÍFICOS          ║")
    print("╠════════════════════════════════════╣")
    print("║  ✓ Generados: " .. treesCreated .. "               ║")
    print("║  ✓ Madera por árbol: 3            ║")
    print("║  ✓ Golpes para derribar: 3        ║")
    print("╚════════════════════════════════════╝")
end

generateTrees()
