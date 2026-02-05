-- Script del MURO de Stranger Things (Temporada 5) - VERSIÓN MEJORADA
-- Coloca este script dentro de una Part en Roblox
-- Lianas DELGADAS y PEGADAS a la pared

local part = script.Parent

-- ⚙️ CONFIGURACIÓN DEL MURO 
local wallHeight = 400       -- MUY ALTO (400 studs) ⬆️⬆️⬆️
local wallWidth = 2000       -- Ancho para cubrir el mapa
local wallThickness = 12     -- Grosor del muro

-- Colores del Upside Down
local wallColor = Color3.fromRGB(30, 22, 25)
local vineColor1 = Color3.fromRGB(65, 40, 35)
local vineColor2 = Color3.fromRGB(75, 45, 40)
local vineColor3 = Color3.fromRGB(85, 50, 45)

-- Función para aplicar STUDS
local function applyStuds(p)
    p.TopSurface = Enum.SurfaceType.Studs
    p.BottomSurface = Enum.SurfaceType.Studs
    p.LeftSurface = Enum.SurfaceType.Studs
    p.RightSurface = Enum.SurfaceType.Studs
    p.FrontSurface = Enum.SurfaceType.Studs
    p.BackSurface = Enum.SurfaceType.Studs
end

-- Crear MURO PRINCIPAL (respetando posición Y rotación del bloque)
local function createMainWall()
    local wall = Instance.new("Part")
    wall.Name = "UpsideDownWall"
    wall.Size = Vector3.new(wallWidth, wallHeight, wallThickness)
    
    -- USAR LA POSICIÓN EXACTA Y ROTACIÓN DEL BLOQUE
    wall.CFrame = part.CFrame  -- Esto copia posición Y rotación
    
    wall.Anchored = true
    wall.CanCollide = true
    wall.Material = Enum.Material.Plastic
    wall.Color = wallColor
    wall.Parent = workspace
    applyStuds(wall)
    return wall
end

-- Crear liana DELGADA pegada a la pared (respetando rotación)
local function createVine(wall, xPos, yPos, length, thickness, color)
    local vine = Instance.new("Part")
    vine.Name = "Vine"
    vine.Size = Vector3.new(thickness, length, thickness)
    
    -- Calcular posición relativa al muro (respetando rotación)
    local offset = Vector3.new(xPos, yPos, wallThickness/2 + thickness/2 + 0.5)
    vine.CFrame = wall.CFrame * CFrame.new(offset)
    
    vine.Anchored = true
    vine.CanCollide = true
    vine.Material = Enum.Material.Plastic
    vine.Color = color
    vine.Parent = wall
    applyStuds(vine)
    
    return vine
end

-- LIANAS VERTICALES largas y delgadas
local function addVerticalVines(wall)
    print("🌿 Añadiendo lianas verticales delgadas...")
    
    -- Muchas lianas delgadas distribuidas por todo el muro
    for i = 1, 80 do
        local xPos = math.random(-wallWidth/2 + 20, wallWidth/2 - 20)
        local length = math.random(wallHeight * 0.4, wallHeight * 0.9)
        local yPos = math.random(-wallHeight/4, wallHeight/4)
        local thickness = math.random(1, 3)  -- DELGADAS (1-3 studs)
        
        -- Elegir color
        local colors = {vineColor1, vineColor2, vineColor3}
        local color = colors[math.random(1, 3)]
        
        local vine = createVine(wall, xPos, yPos, length, thickness, color)
        
        -- Pequeña rotación para variedad
        vine.Orientation = Vector3.new(0, 0, math.random(-5, 5))
    end
end

-- LIANAS HORIZONTALES delgadas
local function addHorizontalVines(wall)
    print("🌿 Añadiendo lianas horizontales delgadas...")
    
    for i = 1, 50 do
        local yPos = math.random(-wallHeight/2 + 30, wallHeight/2 - 30)
        local length = math.random(100, 400)
        local xPos = math.random(-wallWidth/2 + 100, wallWidth/2 - 100)
        local thickness = math.random(1, 3)  -- DELGADAS
        
        local colors = {vineColor1, vineColor2, vineColor3}
        local color = colors[math.random(1, 3)]
        
        -- Crear horizontalmente con rotación respetada
        local vine = Instance.new("Part")
        vine.Name = "VineHorizontal"
        vine.Size = Vector3.new(length, thickness, thickness)
        
        -- Posición relativa al muro
        local offset = Vector3.new(xPos, yPos, wallThickness/2 + thickness/2 + 0.5)
        vine.CFrame = wall.CFrame * CFrame.new(offset) * CFrame.Angles(0, 0, math.rad(math.random(-8, 8)))
        
        vine.Anchored = true
        vine.CanCollide = true
        vine.Material = Enum.Material.Plastic
        vine.Color = color
        vine.Parent = wall
        applyStuds(vine)
    end
end

-- LIANAS DIAGONALES delgadas
local function addDiagonalVines(wall)
    print("🌿 Añadiendo lianas diagonales...")
    
    for i = 1, 40 do
        local xPos = math.random(-wallWidth/2 + 50, wallWidth/2 - 50)
        local yPos = math.random(-wallHeight/2 + 50, wallHeight/2 - 50)
        local length = math.random(50, 150)
        local thickness = math.random(1, 2)  -- MUY DELGADAS
        
        local vine = createVine(wall, xPos, yPos, length, thickness, vineColor2)
        
        -- Rotación diagonal (relativa al muro)
        local angle = math.random(20, 70)
        if math.random() > 0.5 then angle = -angle end
        vine.CFrame = vine.CFrame * CFrame.Angles(0, 0, math.rad(angle))
    end
end

-- Añadir RACIMOS pequeños de lianas
local function addVineClusters(wall)
    print("🌿 Añadiendo racimos de lianas...")
    
    for cluster = 1, 20 do
        local centerX = math.random(-wallWidth/2 + 80, wallWidth/2 - 80)
        local centerY = math.random(-wallHeight/2 + 80, wallHeight/2 - 80)
        
        -- Crear 5-8 lianas alrededor del centro
        for i = 1, math.random(5, 8) do
            local offsetX = math.random(-15, 15)
            local offsetY = math.random(-15, 15)
            local length = math.random(20, 60)
            local thickness = math.random(1, 2)
            
            local vine = createVine(
            wall,
            centerX + offsetX,
            centerY + offsetY,
            length,
            thickness,
            vineColor3
            )
            
            -- Rotación relativa
            vine.CFrame = vine.CFrame * CFrame.Angles(0, 0, math.rad(math.random(-30, 30)))
        end
    end
end

-- Añadir TENTÁCULOS delgados que salen ligeramente
local function addTentacles(wall)
    print("🦑 Añadiendo tentáculos...")
    
    for i = 1, 60 do
        local xPos = math.random(-wallWidth/2 + 40, wallWidth/2 - 40)
        local yPos = math.random(-wallHeight/2 + 40, wallHeight/2 - 40)
        local length = math.random(10, 30)
        local thickness = math.random(1, 3)  -- Delgados
        
        local tentacle = Instance.new("Part")
        tentacle.Name = "Tentacle"
        tentacle.Size = Vector3.new(thickness, length, thickness)
        
        -- Posición relativa al muro con ligera salida
        local zOffset = math.random(2, 5)
        local offset = Vector3.new(xPos, yPos, wallThickness/2 + zOffset)
        tentacle.CFrame = wall.CFrame * CFrame.new(offset)
        
        tentacle.Anchored = true
        tentacle.CanCollide = true
        tentacle.Material = Enum.Material.Plastic
        tentacle.Color = Color3.fromRGB(
        math.random(60, 90),
        math.random(35, 55),
        math.random(30, 50)
        )
        tentacle.Parent = wall
        applyStuds(tentacle)
        
        -- Orientación variada (relativa al muro)
        tentacle.CFrame = tentacle.CFrame * CFrame.Angles(
        math.rad(math.random(-40, 40)),
        math.rad(math.random(0, 360)),
        math.rad(math.random(-30, 30))
        )
    end
end

-- Añadir MANCHAS oscuras en la pared
local function addDarkPatches(wall)
    print("🎨 Añadiendo manchas orgánicas...")
    
    for i = 1, 50 do
        local patch = Instance.new("Part")
        patch.Name = "Patch"
        patch.Size = Vector3.new(
        math.random(10, 40),
        math.random(10, 40),
        0.5
        )
        
        -- Posición relativa al muro
        local xPos = math.random(-wallWidth/2 + 10, wallWidth/2 - 10)
        local yPos = math.random(-wallHeight/2 + 10, wallHeight/2 - 10)
        local offset = Vector3.new(xPos, yPos, wallThickness/2 + 0.3)
        patch.CFrame = wall.CFrame * CFrame.new(offset)
        
        patch.Anchored = true
        patch.CanCollide = false
        patch.Material = Enum.Material.Plastic
        patch.Color = Color3.fromRGB(
        math.random(20, 40),
        math.random(15, 28),
        math.random(18, 30)
        )
        patch.Transparency = math.random(2, 5) / 10
        patch.Parent = wall
        applyStuds(patch)
    end
end

-- Añadir VENAS delgadas semi-transparentes
local function addVeins(wall)
    print("💉 Añadiendo venas...")
    
    for i = 1, 45 do
        local vein = Instance.new("Part")
        vein.Name = "Vein"
        vein.Size = Vector3.new(
        1,  -- MUY delgada (1 stud)
        math.random(50, 150),
        1
        )
        
        -- Posición relativa al muro
        local xPos = math.random(-wallWidth/2 + 30, wallWidth/2 - 30)
        local yPos = math.random(-wallHeight/2 + 30, wallHeight/2 - 30)
        local offset = Vector3.new(xPos, yPos, wallThickness/2 + 0.6)
        vein.CFrame = wall.CFrame * CFrame.new(offset) * CFrame.Angles(0, 0, math.rad(math.random(-45, 45)))
        
        vein.Anchored = true
        vein.CanCollide = false
        vein.Material = Enum.Material.Plastic
        vein.Color = Color3.fromRGB(110, 50, 45)
        vein.Transparency = 0.5
        vein.Parent = wall
        applyStuds(vein)
    end
end

-- Iluminación sutil
local function addLighting(wall)
    print("💡 Añadiendo iluminación...")
    
    for i = 1, 12 do
        local light = Instance.new("PointLight")
        light.Brightness = 0.4
        light.Color = Color3.fromRGB(160, 70, 50)
        light.Range = 30
        
        local lightHolder = Instance.new("Part")
        lightHolder.Size = Vector3.new(2, 2, 2)
        
        -- Posición relativa al muro
        local xPos = math.random(-wallWidth/2, wallWidth/2)
        local yPos = math.random(-wallHeight/2, wallHeight/2)
        local offset = Vector3.new(xPos, yPos, wallThickness/2 + 6)
        lightHolder.CFrame = wall.CFrame * CFrame.new(offset)
        
        lightHolder.Anchored = true
        lightHolder.CanCollide = false
        lightHolder.Transparency = 1
        lightHolder.Parent = wall
        light.Parent = lightHolder
    end
end

-- 🚀 CONSTRUCCIÓN DEL MURO
print("========================================")
print("🌑 GENERANDO MURO DE STRANGER THINGS")
print("========================================")

-- Crear muro base
local mainWall = createMainWall()
print("✓ Muro creado: " .. wallWidth .. " x " .. wallHeight .. " studs")

wait(0.2)

-- Añadir capa trasera oscura
local backLayer = Instance.new("Part")
backLayer.Name = "BackLayer"
backLayer.Size = Vector3.new(wallWidth + 4, wallHeight + 4, 2)

-- Posicionar detrás del muro (respetando rotación)
local backOffset = Vector3.new(0, 0, -wallThickness/2 - 2)
backLayer.CFrame = mainWall.CFrame * CFrame.new(backOffset)

backLayer.Anchored = true
backLayer.CanCollide = true
backLayer.Material = Enum.Material.Plastic
backLayer.Color = Color3.fromRGB(18, 14, 16)
backLayer.Parent = mainWall
applyStuds(backLayer)

wait(0.1)

-- AÑADIR TODOS LOS ELEMENTOS
addVerticalVines(mainWall)
wait(0.1)

addHorizontalVines(mainWall)
wait(0.1)

addDiagonalVines(mainWall)
wait(0.1)

addVineClusters(mainWall)
wait(0.1)

addTentacles(mainWall)
wait(0.1)

addDarkPatches(mainWall)
wait(0.1)

addVeins(mainWall)
wait(0.1)

addLighting(mainWall)

-- Ocultar part original
part.Transparency = 1
part.CanCollide = false

print("========================================")
print("✅ ¡MURO COMPLETADO!")
print("========================================")
print("📏 Altura: " .. wallHeight .. " studs (MUY ALTO)")
print("🌿 Lianas: DELGADAS y PEGADAS")
print("🎨 Material: Plastic + Studs")
print("========================================")
