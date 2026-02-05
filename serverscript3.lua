-- Script del Servidor para generar árboles terroríficos MEJORADOS
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

-- Árbol MEJORADO
local TRUNK_HEIGHT_MIN = 35
local TRUNK_HEIGHT_MAX = 55
local TRUNK_BASE_WIDTH_MIN = 6
local TRUNK_BASE_WIDTH_MAX = 10

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
    
    proximityPrompt.Triggered:Connect(function(player)
        hitCount = hitCount + 1
        
        local hitSound = Instance.new("Sound")
        hitSound.SoundId = "rbxassetid://6881026094"
        hitSound.Volume = 0.8
        hitSound.Parent = promptPart
        hitSound:Play()
        game:GetService("Debris"):AddItem(hitSound, 3)
        
        proximityPrompt.ObjectText = string.format("🌲 %d/%d", hitCount, HITS_TO_DESTROY)
        
        if hitCount >= HITS_TO_DESTROY then
            proximityPrompt.Enabled = false
            
            if _G.AddWood then
                _G.AddWood(player, WOOD_PER_TREE)
            end
            
            woodEvent:FireClient(player, WOOD_PER_TREE)
            
            trunk.Anchored = false
            trunk.CanCollide = true
            
            local fallDirection = Vector3.new(randFloat(-1, 1), 0, randFloat(-1, 1)).Unit
            trunk:ApplyImpulse(fallDirection * 6000 + Vector3.new(0, 2000, 0))
            
            task.wait(DESPAWN_DELAY)
            
            for _, part in pairs(treeModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    task.spawn(function()
                        pcall(function()
                            TweenService:Create(part, TweenInfo.new(1.5), {Transparency = 1}):Play()
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

-- ===================== ÁRBOL COMPLETAMENTE REDISEÑADO =====================
local function createTree(position)
    local treeModel = Instance.new("Model")
    treeModel.Name = "TerrifyingTree"
    
    local trunkHeight = randFloat(TRUNK_HEIGHT_MIN, TRUNK_HEIGHT_MAX)
    local baseWidth = randFloat(TRUNK_BASE_WIDTH_MIN, TRUNK_BASE_WIDTH_MAX)
    
    -- TRONCO VERTICAL
    local trunk = Instance.new("Part")
    trunk.Name = "Trunk"
    trunk.Size = Vector3.new(baseWidth, trunkHeight, baseWidth)
    trunk.Position = position + Vector3.new(0, trunkHeight/2, 0)
    trunk.CFrame = CFrame.new(trunk.Position)
    applyTerrifyingStyle(trunk, false)
    trunk.CanCollide = true
    trunk.Anchored = true
    trunk.Parent = treeModel
    
    -- RAMAS SIMPLES
    for level = 1, 3 do
        local heightPercent = 0.5 + (level * 0.15)
        for i = 1, 4 do
            local branch = Instance.new("Part")
            branch.Name = "Branch"
            branch.Size = Vector3.new(2.5, 8, 2.5)
            
            local angle = math.rad((360 / 4) * i)
            local branchY = position.Y + (trunkHeight * heightPercent)
            
            branch.CFrame = CFrame.new(position.X, branchY, position.Z) *
            CFrame.Angles(0, angle, 0) *
            CFrame.Angles(math.rad(45), 0, 0) *
            CFrame.new(0, 4, 0)
            
            applyTerrifyingStyle(branch, true)
            branch.Anchored = true
            branch.Parent = treeModel
        end
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
    
    print("✅ Árboles generados: " .. treesCreated)
end

generateTrees()
