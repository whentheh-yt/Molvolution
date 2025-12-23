--      _     ___   ____
--     | |   / _ \ / ___|
--     | |  | | | | |  _
--     | |__| |_| | |_| |
--     |_____\___/ \____|
--
-- ------------------------
-- December 20 2025 12:52 - Started. Finally. Hooray. (December 2025 Build 0.1.14779)
-- December 20 2025 13:39 - Fixed subscript bug for hydroxide. (December 2025 Build 0.1.14783)
-- December 20 2025 14:29 - Added uranium compounds, fixed love:draw and fragmentationRules, and other stuff. (December 2025 Build 0.1.14897)
-- December 20 2025 15:21 - Added atom attractions. (December 2025 Build 0.1.15012)
-- December 20 2025 16:15 - HALOMETHANE EDITION - Added ALL the halomethanes! (December 2025 Build 0.1.15050)
-- ---------------------- -
-- December 21 2025 11:01 - Added 3 secret molecules and a console. (December 2025 Build 0.1.15102)
-- December 21 2025 15:31 - Added more alkanes, added sound and revamped death. Also main.lua hit 100KB. (December 2025 Build 0.1.15223)
-- December 21 2025 20:31 - Added interstellar molecules. (December 2025 Build 0.1.15256)
-- December 21 2025 20:53 - Added a time slider, fixed the camera zooming and added .\libs. (December 2025 Build 0.1.15279)
-- ---------------------- -
-- December 22 2025 10:16 - Added a secret molecule reccomended by my sister and a few more radioactive shit. (December 2025 Build 0.1.15300)
-- December 22 2025 18:54 - Added deuterium compounds. (December 2025 Build 0.1.15326)

local config = require("config")
local Console = require("libs/console")
local TimeSlider = require("libs/timeslider")

function love.mousereleased(x, y, button)
    TimeSlider.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    TimeSlider.mousemoved(x, y, dx, dy)
end

local molecules = {}
local hoveredMolecule = nil
local camera = {
    x = 0,
    y = 0,
    zoom = config.camera.defaultZoom,
    minZoom = config.camera.minZoom,
    maxZoom = config.camera.maxZoom,
    followTarget = nil
}

local deathFragments = {
    carbon_tetraiodide = {
        {type = "carbon_atom", count = 1},
        {type = "iodine_atom", count = 4}
    },
    triiodomethane = {
        {type = "iodine_atom", count = 3},
        {type = "hydrogen_atom", count = 1}
    },
    tnt = {
        {type = "nitrogen_atom", count = 3},
        {type = "oxygen_atom", count = 6},
        {type = "carbon_atom", count = 7}
    },
    helium_dimer = {
        {type = "helium", count = 2}
    },
    benzene = {
        {type = "carbon_atom", count = 6},
        {type = "hydrogen_atom", count = 6}
    },
    caffeine = {
        {type = "carbon_atom", count = 8},
        {type = "nitrogen_atom", count = 4},
        {type = "oxygen_atom", count = 2}
    }
}

-- Sound system
local sounds = {}
local spawnFragments
-- ↖Do not touch this. DO NOT EVEN LOOK WEIRD AT IT.

function generateSound(frequency, duration, volume)
    local sampleRate = 44100
    local samples = math.floor(sampleRate * duration)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local envelope = 1 - (i / samples)
        local value = math.sin(2 * math.pi * frequency * t) * envelope * volume
        soundData:setSample(i, value)
    end
    
    local source = love.audio.newSource(soundData)
    source:setPitch(TimeSlider.scale)
    return source
end



function playDeathSound(moleculeType)
    local basePitch = 220
    
    if moleculeType:match("atom") then
        basePitch = 440 -- High pitch for atoms
    elseif moleculeType:match("iodo") or moleculeType == "carbon_tetraiodide" then
        basePitch = 110 -- Deep rumble for iodine compounds
    elseif moleculeType == "benzene" or moleculeType == "caffeine" then
        basePitch = 165 -- Lower for large molecules
    elseif moleculeType:match("methane") then
        basePitch = 330 -- Medium for halomethanes
    end
    
    local sound = generateSound(basePitch, 0.1, 0.3)
    sound:play()
end

function playMergeSound()
    -- Ascending chord for the FORBIDDEN MERGE
    local frequencies = {220, 277, 330, 415}
    for i, freq in ipairs(frequencies) do
        love.timer.sleep((i-1) * 0.05)
        local sound = generateSound(freq, 0.15, 0.2)
        sound:play()
    end
end

function playTrackSound()
    -- Short beep
    local sound = generateSound(880, 0.05, 0.2)
    sound:play()
end

local WORLD_WIDTH = config.world.width
local WORLD_HEIGHT = config.world.height
local DETECTION_RANGE = config.gameplay.detectionRange
local HUNT_SPEED = config.gameplay.huntSpeed
local FLEE_SPEED = config.gameplay.fleeSpeed
local WANDER_SPEED = config.gameplay.wanderSpeed

local ATTRACTION_RANGE = 450
local ATTRACTION_FORCE = 240
local BONDING_DISTANCE = 20

local ELEMENT_ATTRACTION = {
    H = {C = 1.5, O = 2.0, N = 1.3, H = 0.5, F = 1.0, Cl = 1.2, Br = 1.1, I = 1.0},
	He = {C = 1.2, O = 1.2, N = 1.3, H = 3.0, F = 0.9, Cl = 0.7, Br = 0.9, I = 0.1},
    C = {C = 0.8, H = 1.5, O = 1.8, N = 1.2, F = 1.0, Cl = 1.0, Br = 0.9, I = 0.8, S = 1.3},
    O = {C = 1.8, H = 2.0, O = 0.2, N = 1.0, F = 1.5},
    N = {C = 1.2, H = 1.3, O = 1.0, N = 0.3, F = 0.8},
    F = {C = 1.0, H = 1.0, F = 0.1, U = 1.5, O = 1.5, Cl = 1.3},
    Cl = {C = 1.0, H = 1.2, Cl = 0.2, F = 1.3, O = 1.2},
    Br = {C = 0.9, H = 1.1, Br = 0.2},
    I = {C = 0.8, H = 1.0, I = 0.1}
}

-- molecule + molecule → new products!
local fragmentationRules = {
    {
        reactants = {"nitric_acid", "water"},
        products = {
            {type = "hydronium", count = 1},
            {type = "nitrate", count = 1}
        },
        probability = 0.7,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"nitric_acid", "ammonia"},
        products = {
            {type = "ammonium_nitrate", count = 1}
        },
        probability = 0.9,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"hydrogen_cyanide", "water"},
        products = {
            {type = "formic_acid", count = 1},
            {type = "ammonia", count = 1}
        },
        probability = 0.3,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"nitroglycerin", "oxygen"},
        products = {
            {type = "co2", count = 3},
            {type = "water", count = 2.5},
            {type = "nitrogen", count = 1.5}
        },
        probability = 0.15,
        requiresCollision = true,
        requiresHighSpeed = 100,
        soundType = "explosion"
    },
    {
        reactants = {"co2", "chlorine"},
        products = {
            {type = "phosgene", count = 1},
            {type = "oxygen_atom", count = 1}
        },
        probability = 0.08,
        requiresCollision = true,
        soundType = "forbidden"
    },
    {
        reactants = {"co2", "water"},
        products = {
            {type = "carbonic_acid", count = 1}
        },
        probability = 0.02,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"oxygen", "fluorine"},
        products = {
            {type = "foof", count = 1}
        },
        probability = 0.15,
        requiresHighSpeed = 150,
        requiresCollision = true,
        soundType = "explosion"
    },
    {
        reactants = {"chlorine", "fluorine"},
        products = {
            {type = "chlorine_monofluoride", count = 1},
            {type = "fluorine_atom", count = 1},
            {type = "chlorine_atom", count = 1}
        },
        probability = 0.12,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"fluoromethane", "water"},
        products = {
            {type = "hydrogen_fluoride", count = 1},
            {type = "methanol", count = 1}
        },
        probability = 0.05,
        requiresCollision = true,
        soundType = "merge"
    },
	{
        reactants = {"hydroxide", "bromine_atom"},
        products = {
            {type = "hypobromous_acid", count = 1}
        },
        probability = 0.5,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"helium_dimer", "helium"},
        products = {
            {type = "helium_trimer", count = 1}
        },
        probability = 0.5,
        requiresCollision = true,
        soundType = "merge"
    },
	{
        reactants = {"hydroxide", "hydronium"},
        products = {
            {type = "water", count = 2}
        },
        probability = 1,
        requiresCollision = true,
        soundType = "merge"
    },
	
	-- Interstellar reactions
    {
        reactants = {"trihydrogen_cation", "water"},
        products = {
            {type = "hydronium", count = 1},
            {type = "hydrogen", count = 1}
        },
        probability = 0.8,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"ethynyl_radical", "hydrogen_atom"},
        products = {
            {type = "ethylene", count = 0.5},
            {type = "carbon_atom", count = 1}
        },
        probability = 0.6,
        requiresCollision = true,
        soundType = "merge"
    },
    {
        reactants = {"tricarbon", "oxygen"},
        products = {
            {type = "co2", count = 1},
            {type = "carbon_atom", count = 2}
        },
        probability = 0.4,
        requiresCollision = true,
        soundType = "merge"
    }
}

local bondingRecipes = {
    {atoms = {"H", "H"}, product = "hydrogen", probability = 0.8},
	{atoms = {"H", "He"}, product = "helium_hydride", probability = 0.9},
    {atoms = {"He", "He"}, product = "helium_dimer", probability = 1},
    {atoms = {"O", "O"}, product = "oxygen", probability = 0.9},
    {atoms = {"Cl", "Cl"}, product = "chlorine", probability = 0.85},
    {atoms = {"F", "F"}, product = "fluorine", probability = 0.75},
    {atoms = {"Br", "Br"}, product = "bromine", probability = 0.85},
    {atoms = {"I", "I"}, product = "iodine", probability = 0.85},
    {atoms = {"N", "N"}, product = "nitrogen", probability = 0.9},
    {atoms = {"O", "H", "H"}, product = "water", probability = 0.9},
    {atoms = {"C", "O", "O"}, product = "co2", probability = 0.85},
    {atoms = {"N", "H", "H", "H"}, product = "ammonia", probability = 0.8},
    {atoms = {"C", "H", "H", "H", "H"}, product = "methane", probability = 0.85},
    {atoms = {"O", "H"}, product = "hydroxide", probability = 0.7},
    {atoms = {"H", "F"}, product = "hydrogen_fluoride", probability = 0.85},
    {atoms = {"H", "Cl"}, product = "hydrochloric_acid", probability = 0.9},
    {atoms = {"C", "C", "H", "H", "H", "H"}, product = "ethylene", probability = 0.6},
    {atoms = {"C", "H", "H", "H", "F"}, product = "fluoromethane", probability = 0.7},
    {atoms = {"C", "H", "H", "H", "Cl"}, product = "chloromethane", probability = 0.75},
    {atoms = {"C", "F", "F", "F", "F"}, product = "carbon_tetrafluoride", probability = 0.5},
	{atoms = {"N", "O", "O", "O"}, product = "nitric_acid", probability = 0.6},
    {atoms = {"N", "N", "O"}, product = "nitrous_oxide", probability = 0.4},
    {atoms = {"C", "N"}, product = "cyanide", probability = 0.3},
    {atoms = {"H", "C", "N"}, product = "hydrogen_cyanide", probability = 0.5},
    {atoms = {"S", "O", "O"}, product = "sulfur_dioxide", probability = 0.7},
	{atoms = {"D", "D"}, product = "deuterium", probability = 0.85},
    {atoms = {"O", "D", "D"}, product = "heavy_water", probability = 0.9},
    {atoms = {"O", "H", "D"}, product = "semiheavy_water", probability = 0.85},
    {atoms = {"N", "D", "D", "D"}, product = "deuterated_ammonia", probability = 0.8},
    {atoms = {"C", "D", "D", "D", "D"}, product = "deuterated_methane", probability = 0.85},
	
	-- Interstellar bonding
    {atoms = {"H", "H", "H"}, product = "trihydrogen_cation", probability = 0.6},
    {atoms = {"C", "C", "C"}, product = "tricarbon", probability = 0.4},
    {atoms = {"H", "C", "O"}, product = "formyl_cation", probability = 0.5},
    {atoms = {"C", "C", "H"}, product = "ethynyl_radical", probability = 0.7}
}

local deathFragmentations = {
    helium_dimer = {
        {type = "helium", count = 2}
    },
	helium_trimer = {
	    {type = "helium_dimer", count = 1},
        {type = "helium", count = 1}
    },
    hydrogen = {
        {type = "hydrogen_atom", count = 2}
    },
    oxygen = {
        {type = "oxygen_atom", count = 2}
    },
    chlorine = {
        {type = "chlorine_atom", count = 2}
    },
    fluorine = {
        {type = "fluorine_atom", count = 2}
    },
    bromine = {
        {type = "bromine_atom", count = 2}
    },
    iodine = {
        {type = "iodine_atom", count = 2}
    },
    nitrogen = {
        {type = "nitrogen_atom", count = 2}
    },
    
    water = {
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 2}
    },
    
    co2 = {
        {type = "carbon_atom", count = 1},
        {type = "oxygen_atom", count = 2}
    },
    
    ammonia = {
        {type = "nitrogen_atom", count = 1},
        {type = "hydrogen_atom", count = 3}
    },
    
    methane = {
        {type = "carbon_atom", count = 1},
        {type = "hydrogen_atom", count = 4}
    },
    
    propane = {
        {type = "methane", count = 1},
        {type = "ethylene", count = 1}
    },
    
    butane = {
        {type = "ethylene", count = 2}
    },
    
    pentane = {
        {type = "ethylene", count = 1},
        {type = "propane", count = 1}
    },
    
    hexane = {
        {type = "propane", count = 2}
    },
    
    heptane = {
        {type = "propane", count = 1},
        {type = "butane", count = 1}
    },
    
    octane = {
        {type = "butane", count = 2}
    },
    
    nonane = {
        {type = "butane", count = 1},
        {type = "pentane", count = 1}
    },
    
    decane = {
        {type = "pentane", count = 2}
    },
    
    ethanol = {
        {type = "ethylene", count = 1},
        {type = "water", count = 1}
    },
    
    cyclopropane = {
        {type = "propane", count = 1}
    },
    
    cyclobutane = {
        {type = "butane", count = 1}
    },
    
    cyclopentane = {
        {type = "carbon_atom", count = 5},
        {type = "hydrogen_atom", count = 10}
    },
    
    benzene = {
        {type = "carbon_atom", count = 6},
        {type = "hydrogen_atom", count = 6}
    },
    
    fluoromethane = {
        {type = "methane", count = 1},
        {type = "fluorine_atom", count = 1}
    },
    
    difluoromethane = {
        {type = "methane", count = 1},
        {type = "fluorine_atom", count = 2}
    },
    
    trifluoromethane = {
        {type = "methane", count = 1},
        {type = "fluorine_atom", count = 3}
    },
    
    carbon_tetrafluoride = {
        {type = "carbon_atom", count = 1},
        {type = "fluorine_atom", count = 4}
    },
    
    chloromethane = {
        {type = "methane", count = 1},
        {type = "chlorine_atom", count = 1}
    },
    
    dichloromethane = {
        {type = "methane", count = 1},
        {type = "chlorine_atom", count = 2}
    },
    
    chloroform = {
        {type = "methane", count = 1},
        {type = "chlorine_atom", count = 3}
    },
    
    carbon_tetrachloride = {
        {type = "carbon_atom", count = 1},
        {type = "chlorine_atom", count = 4}
    },
    
    bromomethane = {
        {type = "methane", count = 1},
        {type = "bromine_atom", count = 1}
    },
    
    dibromomethane = {
        {type = "methane", count = 1},
        {type = "bromine_atom", count = 2}
    },
    
    tribromomethane = {
        {type = "methane", count = 1},
        {type = "bromine_atom", count = 3}
    },
    
    carbon_tetrabromide = {
        {type = "carbon_atom", count = 1},
        {type = "bromine_atom", count = 4}
    },
    
    iodomethane = {
        {type = "methane", count = 1},
        {type = "iodine_atom", count = 1}
    },
    
    diiodomethane = {
        {type = "methane", count = 1},
        {type = "iodine_atom", count = 2}
    },
    
    triiodomethane = {
        {type = "methane", count = 1},
        {type = "iodine_atom", count = 3}
    },
    
    carbon_tetraiodide = {
        {type = "carbon_atom", count = 1},
        {type = "iodine_atom", count = 4}
    },
    
    tnt = {
        {type = "carbon_atom", count = 7},
        {type = "nitrogen_atom", count = 3},
        {type = "oxygen_atom", count = 6}
    },
    
    ozone = {
        {type = "oxygen", count = 1},
        {type = "oxygen_atom", count = 1}
    },
    
    hydrogen_peroxide = {
        {type = "water", count = 1},
        {type = "oxygen_atom", count = 1}
    },
	nitric_acid = {
        {type = "nitrogen_dioxide", count = 1},
        {type = "water", count = 1},
        {type = "oxygen_atom", count = 1}
    },
    
    nitrous_oxide = {
        {type = "nitrogen", count = 1},
        {type = "oxygen", count = 1}
    },
    
    hydrogen_cyanide = {
        {type = "hydrogen_atom", count = 1},
        {type = "carbon_atom", count = 1},
        {type = "nitrogen_atom", count = 1}
    },
    
    sulfur_dioxide = {
        {type = "sulfur_atom", count = 1},
        {type = "oxygen_atom", count = 2}
    },
    
    nitroglycerin = {
        {type = "co2", count = 3},
        {type = "water", count = 2},
        {type = "nitrogen", count = 1.5},
        {type = "oxygen", count = 0.5}
    },
	azidoazide_azide = {
      {type = "nitrogen", count = 5},
      {type = "nitrogen_atom", count = 4},
      {type = "carbon_atom", count = 2}
    },
	
	-- Interstellar molecules
    trihydrogen_cation = {
        {type = "hydrogen", count = 1},
        {type = "hydrogen_atom", count = 1}
    },
    tricarbon = {
        {type = "carbon_atom", count = 3}
    },
    cyanoacetylene = {
        {type = "hydrogen_cyanide", count = 1},
        {type = "ethylene", count = 0.5},
        {type = "carbon_atom", count = 1}
    },
    ethynyl_radical = {
        {type = "carbon_atom", count = 2},
        {type = "hydrogen_atom", count = 1}
    },
    formyl_cation = {
        {type = "carbon_atom", count = 1},
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 1}
    },
    acetonitrile = {
        {type = "methane", count = 1},
        {type = "cyanide", count = 1}
    },
    buckminsterfullerene = {
        {type = "carbon_atom", count = 20},
        {type = "benzene", count = 3},
        {type = "tricarbon", count = 5}
    },
	deuterium = {
        {type = "deuterium_atom", count = 2}
    },
    heavy_water = {
        {type = "oxygen_atom", count = 1},
        {type = "deuterium_atom", count = 2}
    },
    semiheavy_water = {
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 1},
        {type = "deuterium_atom", count = 1}
    },
    deuterium_oxide_ion = {
        {type = "heavy_water", count = 1},
        {type = "deuterium_atom", count = 1}
    },
    deuterated_ammonia = {
        {type = "nitrogen_atom", count = 1},
        {type = "deuterium_atom", count = 3}
    },
    deuterated_methane = {
        {type = "carbon_atom", count = 1},
        {type = "deuterium_atom", count = 4}
    },
}

local spawnFragments

local ELEMENT_COLORS = {
    H = {0.9, 0.9, 0.9},
	    D = {0.7, 0.9, 1.0},
		T = {0.5, 1.0, 0.5},
    He = {0.8, 0.9, 1.0},
    Li = {0.8, 0.5, 1.0},
    C = {0.3, 0.3, 0.3},
    N = {0.2, 0.4, 0.9},
    O = {0.9, 0.2, 0.2},
    F = {0.3, 0.9, 0.3},
    Na = {1.0, 0.8, 0.2},
    P = {0.9, 0.5, 0.2},
    S = {0.9, 0.9, 0.2},
    Cl = {0.3, 0.9, 0.6},
    Br = {0.6, 0.2, 0.1},
    I = {0.5, 0.0, 0.5},
    U = {0.0, 0.8, 0.0},
	Po = {0.7, 0.0, 0.7},
    Ra = {0.0, 1.0, 0.5},
    Pu = {0.8, 0.6, 0.0},
    Sr = {0.9, 0.9, 0.5},
    Cs = {1.0, 0.8, 0.2},
}

local structures = {
    butane = {
        atoms = {
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -35, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -35, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 35, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 35, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {1, 5}, {1, 6}, {2, 7}, {2, 8}, {3, 9}, {3, 10}, {4, 11}, {4, 12}}
    },
    pentane = {
        atoms = {
            {element = "C", x = -40, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 40, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -45, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -45, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 45, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 45, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {1, 6}, {1, 7}, {2, 8}, {2, 9}, {3, 10}, {3, 11}, {4, 12}, {4, 13}, {5, 14}, {5, 15}}
    },
    hexane = {
        atoms = {
            {element = "C", x = -50, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 50, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -55, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -55, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 55, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 55, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {1, 7}, {1, 8}, {2, 9}, {2, 10}, {3, 11}, {3, 12}, {4, 13}, {4, 14}, {5, 15}, {5, 16}, {6, 17}, {6, 18}}
    },
    heptane = {
        atoms = {
            {element = "C", x = -60, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -40, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 40, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 60, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -65, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -65, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -40, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -40, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 40, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 40, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 65, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 65, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 7}, {1, 8}, {1, 9}, {2, 10}, {2, 11}, {3, 12}, {3, 13}, {4, 14}, {4, 15}, {5, 16}, {5, 17}, {6, 18}, {6, 19}, {7, 20}, {7, 21}}
    },
    octane = {
        atoms = {
            {element = "C", x = -70, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -50, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 50, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 70, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -75, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -75, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -50, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -50, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 50, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 50, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 75, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 75, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 7}, {7, 8}, {1, 9}, {1, 10}, {2, 11}, {2, 12}, {3, 13}, {3, 14}, {4, 15}, {4, 16}, {5, 17}, {5, 18}, {6, 19}, {6, 20}, {7, 21}, {7, 22}, {8, 23}, {8, 24}}
    },
    nonane = {
        atoms = {
            {element = "C", x = -80, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -60, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -40, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 40, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 60, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 80, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -85, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -85, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -60, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -60, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -40, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -40, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 40, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 40, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 60, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 60, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 85, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 85, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 7}, {7, 8}, {8, 9}, {1, 10}, {1, 11}, {2, 12}, {2, 13}, {3, 14}, {3, 15}, {4, 16}, {4, 17}, {5, 18}, {5, 19}, {6, 20}, {6, 21}, {7, 22}, {7, 23}, {8, 24}, {8, 25}, {9, 26}, {9, 27}}
    },
    decane = {
        atoms = {
            {element = "C", x = -90, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -70, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -50, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 50, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 70, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 90, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -95, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -95, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -70, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -70, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -50, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -50, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 50, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 50, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 70, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 70, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 95, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 95, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 7}, {7, 8}, {8, 9}, {9, 10}, {1, 11}, {1, 12}, {2, 13}, {2, 14}, {3, 15}, {3, 16}, {4, 17}, {4, 18}, {5, 19}, {5, 20}, {6, 21}, {6, 22}, {7, 23}, {7, 24}, {8, 25}, {8, 26}, {9, 27}, {9, 28}, {10, 29}, {10, 30}}
    },
	
    -- FLUOROMETHANES
    fluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = 0, y = -15, color = ELEMENT_COLORS.F},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = 13, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = -13, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    difluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = 0, y = -15, color = ELEMENT_COLORS.F},
            {element = "F", x = 0, y = 15, color = ELEMENT_COLORS.F},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    trifluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = 0, y = -15, color = ELEMENT_COLORS.F},
            {element = "F", x = 13, y = 7.5, color = ELEMENT_COLORS.F},
            {element = "F", x = -13, y = 7.5, color = ELEMENT_COLORS.F},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    carbon_tetrafluoride = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = 0, y = -15, color = ELEMENT_COLORS.F},
            {element = "F", x = 15, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 0, y = 15, color = ELEMENT_COLORS.F},
            {element = "F", x = -15, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        inert = true
    },
	
    -- CHLOROMETHANES
    chloromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = 13, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = -13, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    dichloromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 0, y = 16, color = ELEMENT_COLORS.Cl},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    chloroform = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 14, y = 8, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = -14, y = 8, color = ELEMENT_COLORS.Cl},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        anesthetic = true
    },
    carbon_tetrachloride = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 16, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 0, y = 16, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = -16, y = 0, color = ELEMENT_COLORS.Cl}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        toxic = true
    },
    -- BROMOMETHANES
    bromomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -17, color = ELEMENT_COLORS.Br},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = 13, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = -13, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    dibromomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -18, color = ELEMENT_COLORS.Br},
            {element = "Br", x = 0, y = 18, color = ELEMENT_COLORS.Br},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    tribromomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -18, color = ELEMENT_COLORS.Br},
            {element = "Br", x = 16, y = 9, color = ELEMENT_COLORS.Br},
            {element = "Br", x = -16, y = 9, color = ELEMENT_COLORS.Br},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        anesthetic = true
    },
    carbon_tetrabromide = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -18, color = ELEMENT_COLORS.Br},
            {element = "Br", x = 18, y = 0, color = ELEMENT_COLORS.Br},
            {element = "Br", x = 0, y = 18, color = ELEMENT_COLORS.Br},
            {element = "Br", x = -18, y = 0, color = ELEMENT_COLORS.Br}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        heavy = true
    },
	
    -- IODOMETHANES (the wild ones!)
    iodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "I", x = 0, y = -19, color = ELEMENT_COLORS.I},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = 13, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = -13, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
    },
    diiodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "I", x = 0, y = -20, color = ELEMENT_COLORS.I},
            {element = "I", x = 0, y = 20, color = ELEMENT_COLORS.I},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        heavy = true
    },
    triiodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "I", x = 0, y = -20, color = ELEMENT_COLORS.I},
            {element = "I", x = 17, y = 10, color = ELEMENT_COLORS.I},
            {element = "I", x = -17, y = 10, color = ELEMENT_COLORS.I},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        anesthetic = true,
        unstable = true
    },
    carbon_tetraiodide = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "I", x = 0, y = -21, color = ELEMENT_COLORS.I},
            {element = "I", x = 21, y = 0, color = ELEMENT_COLORS.I},
            {element = "I", x = 0, y = 21, color = ELEMENT_COLORS.I},
            {element = "I", x = -21, y = 0, color = ELEMENT_COLORS.I}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        },
        explosive = true,
        unstable = true,
        heavy = true
    },
    hydroxide = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 8, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}},
        ion = true,
        charge = -1
    },
    hydronium = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 10, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -5, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = -5, y = -8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        ion = true,
        charge = 1
    },
	miau = {
	        atoms = {
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = -15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = -15, y = 15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 15, color = ELEMENT_COLORS.C},
			{element = "C", x = 0, y = 15, color = ELEMENT_COLORS.C},
			{element = "C", x = 15, y = 30, color = ELEMENT_COLORS.C},
			{element = "C", x = -15, y = 30, color = ELEMENT_COLORS.C},
			{element = "H", x = -8, y = 6, color = ELEMENT_COLORS.H},
			{element = "H", x = -8, y = -2, color = ELEMENT_COLORS.H},
			{element = "H", x = 6, y = 6, color = ELEMENT_COLORS.H},
			{element = "H", x = 6, y = -2, color = ELEMENT_COLORS.H},
			{element = "H", x = -4, y = -10, color = ELEMENT_COLORS.H},
			{element = "H", x = -10, y = -5, color = ELEMENT_COLORS.H},
			{element = "H", x = 10, y = -5, color = ELEMENT_COLORS.H},
			{element = "H", x = 4, y = -10, color = ELEMENT_COLORS.H},
			{element = "H", x = 0, y = -5, color = ELEMENT_COLORS.H},
        },
        bonds = {{1, 2}, {2, 3}, {4, 1}, {6, 5}, {7, 5}, {6, 4}, {7, 3}, {8, 9}, {10, 11}, {12, 13}, {13, 16}, {16, 15}, {15, 14}}
	},
    methane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -15, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 15, color = ELEMENT_COLORS.H},
            {element = "H", x = -15, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}}
    },
    propane = {
        atoms = {
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -25, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {1, 4}, {1, 5}, {2, 6}, {2, 7}, {3, 8}, {3, 9}}
    },
    water = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = -10, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}}
    },
    co2 = {
        atoms = {
            {element = "O", x = -12, y = 0, color = ELEMENT_COLORS.O},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 12, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {2, 3, double = true}}
    },
	helium_hydride = {
        atoms = {
            {element = "H", x = -6, y = 0, color = ELEMENT_COLORS.H},
            {element = "He", x = 6, y = 0, color = ELEMENT_COLORS.He},
        },
        bonds = {{1, 2}}
    },
    oxygen = {
        atoms = {
            {element = "O", x = -8, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 8, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}}
    },
    chlorine = {
        atoms = {
            {element = "Cl", x = -10, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 10, y = 0, color = ELEMENT_COLORS.Cl}
        },
        bonds = {{1, 2}}
    },
    fluorine = {
        atoms = {
            {element = "F", x = -8, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 8, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}}
    },
    helium = {
        atoms = {{element = "He", x = 0, y = 0, color = ELEMENT_COLORS.He}},
        bonds = {}
    },
    hydrogen_atom = {
        atoms = {{element = "H", x = 0, y = 0, color = ELEMENT_COLORS.H}},
        bonds = {}
    },
    carbon_atom = {
        atoms = {{element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C}},
        bonds = {}
    },
    oxygen_atom = {
        atoms = {{element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O}},
        bonds = {}
    },
    fluorine_atom = {
        atoms = {{element = "F", x = 0, y = 0, color = ELEMENT_COLORS.F}},
        bonds = {}
    },
    chlorine_atom = {
        atoms = {{element = "Cl", x = 0, y = 0, color = ELEMENT_COLORS.Cl}},
        bonds = {}
    },
    bromine_atom = {
        atoms = {{element = "Br", x = 0, y = 0, color = ELEMENT_COLORS.Br}},
        bonds = {}
    },
    iodine_atom = {
        atoms = {{element = "I", x = 0, y = 0, color = ELEMENT_COLORS.I}},
        bonds = {}
    },
	
    -- MIXED HALOMETHANES
    chlorofluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "F", x = 0, y = 16, color = ELEMENT_COLORS.F},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        refrigerant = true
    },
    dichlorofluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = -12, y = -10, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 12, y = -10, color = ELEMENT_COLORS.Cl},
            {element = "F", x = 0, y = 15, color = ELEMENT_COLORS.F},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        refrigerant = true
    },
    chlorodifluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "F", x = -12, y = 10, color = ELEMENT_COLORS.F},
            {element = "F", x = 12, y = 10, color = ELEMENT_COLORS.F},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        refrigerant = true
    },
    bromochloromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -17, color = ELEMENT_COLORS.Br},
            {element = "Cl", x = 0, y = 16, color = ELEMENT_COLORS.Cl},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}}
    },
    bromodichloromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -18, color = ELEMENT_COLORS.Br},
            {element = "Cl", x = -13, y = 10, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 13, y = 10, color = ELEMENT_COLORS.Cl},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        toxic = true
    },
    dibromochloromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = -14, y = -10, color = ELEMENT_COLORS.Br},
            {element = "Br", x = 14, y = -10, color = ELEMENT_COLORS.Br},
            {element = "Cl", x = 0, y = 16, color = ELEMENT_COLORS.Cl},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        toxic = true
    },
    bromofluoromethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -17, color = ELEMENT_COLORS.Br},
            {element = "F", x = 0, y = 15, color = ELEMENT_COLORS.F},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}}
    },
    chloroiodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Cl", x = 0, y = -16, color = ELEMENT_COLORS.Cl},
            {element = "I", x = 0, y = 19, color = ELEMENT_COLORS.I},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}}
    },
    bromoiodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "Br", x = 0, y = -17, color = ELEMENT_COLORS.Br},
            {element = "I", x = 0, y = 20, color = ELEMENT_COLORS.I},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        heavy = true
    },
    fluoroiodomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = 0, y = -15, color = ELEMENT_COLORS.F},
            {element = "I", x = 0, y = 20, color = ELEMENT_COLORS.I},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        unstable = true
    },
	bromochloroflouroidiomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
			{element = "Br", x = 0, y = -15, color = ELEMENT_COLORS.Br},
            {element = "Cl", x = 0, y = 15, color = ELEMENT_COLORS.Cl},
			{element = "F", x = 15, y = 0, color = ELEMENT_COLORS.F},
			{element = "I", x = -15, y = 0, color = ELEMENT_COLORS.I},
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}}
    },
    cyclopropane = {
        atoms = {
            {element = "C", x = 0, y = -12, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 6, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 6, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -22, color = ELEMENT_COLORS.H},
            {element = "H", x = 5, y = -15, color = ELEMENT_COLORS.H},
            {element = "H", x = -18, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 18, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 1}, {1, 4}, {1, 5}, {2, 6}, {2, 7}, {3, 8}, {3, 9}},
        strained = true
    },
    cyclopropenylidene = {
        atoms = {
            {element = "C", x = 0, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = -9, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = 9, y = 5, color = ELEMENT_COLORS.C},
            {element = "H", x = -15, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 1}, {2, 4}, {3, 5}},
        carbene = true,
        strained = true
    },
    cyclobutane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "H", x = -16, y = -16, color = ELEMENT_COLORS.H},
            {element = "H", x = -16, y = -4, color = ELEMENT_COLORS.H},
            {element = "H", x = 16, y = -16, color = ELEMENT_COLORS.H},
            {element = "H", x = 16, y = -4, color = ELEMENT_COLORS.H},
            {element = "H", x = 16, y = 16, color = ELEMENT_COLORS.H},
            {element = "H", x = 16, y = 4, color = ELEMENT_COLORS.H},
            {element = "H", x = -16, y = 16, color = ELEMENT_COLORS.H},
            {element = "H", x = -16, y = 4, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 1}, {1, 5}, {1, 6}, {2, 7}, {2, 8}, {3, 9}, {3, 10}, {4, 11}, {4, 12}},
        strained = true
    },
    cyclopentane = {
        atoms = {
            {element = "C", x = 0, y = -12, color = ELEMENT_COLORS.C},
            {element = "C", x = 11, y = -4, color = ELEMENT_COLORS.C},
            {element = "C", x = 7, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -7, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -11, y = -4, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -22, color = ELEMENT_COLORS.H},
            {element = "H", x = 5, y = -15, color = ELEMENT_COLORS.H},
            {element = "H", x = 19, y = -6, color = ELEMENT_COLORS.H},
            {element = "H", x = 14, y = 3, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 15, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = -14, y = 3, color = ELEMENT_COLORS.H},
            {element = "H", x = -19, y = -6, color = ELEMENT_COLORS.H},
            {element = "H", x = -5, y = -15, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 1}, {1, 6}, {1, 7}, {2, 8}, {2, 9}, {3, 10}, {3, 11}, {4, 12}, {4, 13}, {5, 14}, {5, 15}}
    },
    cyclobutene = {
        atoms = {
            {element = "C", x = -8, y = -8, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = -8, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = 8, color = ELEMENT_COLORS.C},
            {element = "C", x = -8, y = 8, color = ELEMENT_COLORS.C},
            {element = "H", x = -14, y = -14, color = ELEMENT_COLORS.H},
            {element = "H", x = 14, y = -14, color = ELEMENT_COLORS.H},
            {element = "H", x = 14, y = 14, color = ELEMENT_COLORS.H},
            {element = "H", x = -14, y = 14, color = ELEMENT_COLORS.H},
            {element = "H", x = -14, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 14, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {2, 3}, {3, 4}, {4, 1}, {1, 5}, {2, 6}, {3, 7}, {4, 8}, {4, 9}, {3, 10}},
        strained = true
    },
    benzene = {
        atoms = {
            {element = "C", x = 0, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = -7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 15, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = -7.5, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -25, color = ELEMENT_COLORS.H},
            {element = "H", x = 22, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 22, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 25, color = ELEMENT_COLORS.H},
            {element = "H", x = -22, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -22, y = -12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, resonance = true}, {2, 3, resonance = true}, {3, 4, resonance = true}, {4, 5, resonance = true}, {5, 6, resonance = true}, {6, 1, resonance = true}, {1, 7}, {2, 8}, {3, 9}, {4, 10}, {5, 11}, {6, 12}},
        aromatic = true
    },
    ethylene = {
        atoms = {
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -15, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -15, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {1, 3}, {1, 4}, {2, 5}, {2, 6}}
    },
    deuterium_atom = {
        atoms = {{element = "D", x = 0, y = 0, color = ELEMENT_COLORS.D}},
        bonds = {},
        isotope = true
    },
    deuterium = {
        atoms = {
            {element = "D", x = -8, y = 0, color = ELEMENT_COLORS.D},
            {element = "D", x = 8, y = 0, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}},
        isotope = true
    },
    heavy_water = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "D", x = -10, y = 8, color = ELEMENT_COLORS.D},
            {element = "D", x = 10, y = 8, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}, {1, 3}},
        heavy = true,
        moderator = true
    },
    semiheavy_water = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = -10, y = 8, color = ELEMENT_COLORS.H},
            {element = "D", x = 10, y = 8, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}, {1, 3}},
        hybrid = true
    },
    deuterium_oxide_ion = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "D", x = 10, y = 0, color = ELEMENT_COLORS.D},
            {element = "D", x = -5, y = 8, color = ELEMENT_COLORS.D},
            {element = "D", x = -5, y = -8, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        ion = true,
        charge = 1,
        heavy = true
    },
    deuterated_ammonia = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "D", x = 0, y = -12, color = ELEMENT_COLORS.D},
            {element = "D", x = -10, y = 6, color = ELEMENT_COLORS.D},
            {element = "D", x = 10, y = 6, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        deuterated = true
    },
    deuterated_methane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "D", x = 0, y = -15, color = ELEMENT_COLORS.D},
            {element = "D", x = 15, y = 0, color = ELEMENT_COLORS.D},
            {element = "D", x = 0, y = 15, color = ELEMENT_COLORS.D},
            {element = "D", x = -15, y = 0, color = ELEMENT_COLORS.D}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        deuterated = true
    },
    ethanol = {
        atoms = {
            {element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 15, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 25, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {1, 5}, {1, 6}, {2, 7}, {2, 8}}
    },
	nitric_acid = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "O", x = 0, y = 15, color = ELEMENT_COLORS.O},
            {element = "O", x = 15, y = -8, color = ELEMENT_COLORS.O},
            {element = "O", x = -15, y = -8, color = ELEMENT_COLORS.O},
            {element = "H", x = 0, y = 25, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2, double = true},
            {1, 3, double = true},
            {1, 4, resonance = true},
            {4, 5}
        },
        acid = true
    },
    nitrous_oxide = {
        atoms = {
            {element = "N", x = -12, y = 0, color = ELEMENT_COLORS.N},
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "O", x = 12, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2, triple = true},
            {2, 3, double = true}
        },
        anesthetic = true
    },
    cyanide = {
        atoms = {
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "N", x = 8, y = 0, color = ELEMENT_COLORS.N}
        },
        bonds = {
            {1, 2, triple = true}
        },
        toxic = true,
        ion = true,
        charge = -1
    },
    hydrogen_cyanide = {
        atoms = {
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "N", x = 8, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -18, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2, triple = true},
            {1, 3}
        },
        toxic = true,
        volatile = true
    },
    sulfur_dioxide = {
        atoms = {
            {element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S},
            {element = "O", x = -15, y = -8, color = ELEMENT_COLORS.O},
            {element = "O", x = 15, y = -8, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2, double = true},
            {1, 3, double = true}
        },
        toxic = true
    },
    nitroglycerin = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -20, y = -12, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = -12, color = ELEMENT_COLORS.C},
            {element = "O", x = 0, y = 15, color = ELEMENT_COLORS.O},
            {element = "O", x = -30, y = -20, color = ELEMENT_COLORS.O},
            {element = "O", x = 30, y = -20, color = ELEMENT_COLORS.O},
            {element = "N", x = -35, y = -30, color = ELEMENT_COLORS.N},
            {element = "N", x = 35, y = -30, color = ELEMENT_COLORS.N},
            {element = "O", x = -40, y = -40, color = ELEMENT_COLORS.O},
            {element = "O", x = -30, y = -40, color = ELEMENT_COLORS.O},
            {element = "O", x = 30, y = -40, color = ELEMENT_COLORS.O},
            {element = "O", x = 40, y = -40, color = ELEMENT_COLORS.O},
            {element = "H", x = -25, y = 5, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = 5, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {2, 5}, {3, 6}, {5, 7}, {6, 8},
            {7, 9}, {7, 10}, {8, 11}, {8, 12}, {2, 13}, {3, 14}
        },
        explosive = true,
        unstable = true
    },
    ammonia = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 6, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}}
    },
    ozone = {
        atoms = {
            {element = "O", x = -12, y = 6, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = -8, color = ELEMENT_COLORS.O},
            {element = "O", x = 12, y = 6, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, resonance = true}, {2, 3, resonance = true}}
    },
    nitrogen_atom = {
        atoms = {{element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N}},
        bonds = {}
    },
    nitrogen_positive1_atom = {
        atoms = {{element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N}},
        bonds = {},
        ion = true,
        charge = 1
    },
    uranium_atom = {
        atoms = {{element = "U", x = 0, y = 0, color = ELEMENT_COLORS.U}},
        bonds = {},
        radioactive = true
    },
    acetylcarnitine = {
        atoms = {
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 0, color = ELEMENT_COLORS.C},
            {element = "N", x = 0, y = -15, color = ELEMENT_COLORS.N},
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 35, y = -10, color = ELEMENT_COLORS.O},
            {element = "O", x = 35, y = 10, color = ELEMENT_COLORS.O},
            {element = "C", x = -15, y = 15, color = ELEMENT_COLORS.C},
            {element = "O", x = -20, y = 25, color = ELEMENT_COLORS.O},
            {element = "H", x = -35, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -35, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 6}, {3, 5}, {6, 7}, {6, 8}, {2, 9}, {9, 10}, {1, 11}, {1, 12}, {4, 13}, {4, 14}, {9, 10, double = true}}
    },
    caffeine = {
        atoms = {
            {element = "C", x = -15, y = -15, color = ELEMENT_COLORS.C},
            {element = "N", x = -8, y = -25, color = ELEMENT_COLORS.N},
            {element = "C", x = 5, y = -20, color = ELEMENT_COLORS.C},
            {element = "N", x = 8, y = -8, color = ELEMENT_COLORS.N},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = -5, color = ELEMENT_COLORS.C},
            {element = "N", x = -18, y = 5, color = ELEMENT_COLORS.N},
            {element = "C", x = -20, y = -8, color = ELEMENT_COLORS.C},
            {element = "O", x = 15, y = -25, color = ELEMENT_COLORS.O},
            {element = "O", x = 5, y = 10, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 1}, {6, 7}, {7, 8}, {8, 1}, {3, 9, double = true}, {5, 10, double = true}}
    },
    tnt = {
        atoms = {
            {element = "C", x = 0, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = -7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 15, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = -7.5, color = ELEMENT_COLORS.C},
            {element = "N", x = 0, y = -28, color = ELEMENT_COLORS.N},
            {element = "O", x = -8, y = -35, color = ELEMENT_COLORS.O},
            {element = "O", x = 8, y = -35, color = ELEMENT_COLORS.O},
            {element = "N", x = 23, y = 12, color = ELEMENT_COLORS.N},
            {element = "O", x = 30, y = 5, color = ELEMENT_COLORS.O},
            {element = "N", x = -23, y = 12, color = ELEMENT_COLORS.N},
            {element = "O", x = -30, y = 5, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 1}, {1, 7}, {7, 8}, {7, 9}, {3, 10}, {10, 11}, {5, 12}, {12, 13}},
        explosive = true
    },
    hydrogen_peroxide = {
        atoms = {
            {element = "O", x = -6, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = -12, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {2, 4}}
    },
    acetone = {
        atoms = {
            {element = "C", x = -18, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 18, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 0, y = -15, color = ELEMENT_COLORS.O},
            {element = "H", x = -25, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {2, 4, double = true}, {1, 5}, {1, 6}, {3, 7}, {3, 8}}
    },
    sulfuric_acid = {
        atoms = {
            {element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S},
            {element = "O", x = 0, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 15, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = 15, color = ELEMENT_COLORS.O},
            {element = "O", x = -15, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 22, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -22, y = -8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {1, 3}, {1, 4, double = true}, {1, 5}, {3, 6}, {5, 7}}
    },
    helium_dimer = {
        atoms = {
            {element = "He", x = -26, y = 0, color = ELEMENT_COLORS.He},
            {element = "He", x = 26, y = 0, color = ELEMENT_COLORS.He}
        },
        bonds = {{1, 2, weak = true}}
    },
	helium_trimer = {
        atoms = {
            {element = "He", x = -38, y = 0, color = ELEMENT_COLORS.He},
            {element = "He", x = 38, y = 0, color = ELEMENT_COLORS.He},
			{element = "He", x = 0, y = 16, color = ELEMENT_COLORS.He}
        },
        bonds = {{1, 2, weak = true}, {1, 3, weak = true}, {2, 3, weak = true}}
    },
	hypobromous_acid = {
        atoms = {
            {element = "Br", x = -8, y = 0, color = ELEMENT_COLORS.Br},
            {element = "O", x = -2, y = 0, color = ELEMENT_COLORS.O},
			{element = "H", x = 2, y = 5, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}}
    },
	formaldehyde = {
        atoms = {
            {element = "O", x = -8, y = 0, color = ELEMENT_COLORS.O},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
			{element = "H", x = 14, y = 5, color = ELEMENT_COLORS.H},
			{element = "H", x = 14, y = -5, color = ELEMENT_COLORS.H},
        },
        bonds = {{1, 2, double = true}, {2, 3}, {2, 4}}
    },
    hydrochloric_acid = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 4.9, y = -7.2, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.7, y = 0.1, color = ELEMENT_COLORS.H},
            {element = "H", x = 4.5, y = 6.6, color = ELEMENT_COLORS.H},
            {element = "Cl", x = 18.9, y = -1.1, color = ELEMENT_COLORS.Cl}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}}
    },
    tetrafluoroethylene = {
        atoms = {
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
            {element = "F", x = -15, y = -10, color = ELEMENT_COLORS.F},
            {element = "F", x = -15, y = 10, color = ELEMENT_COLORS.F},
            {element = "F", x = 15, y = -10, color = ELEMENT_COLORS.F},
            {element = "F", x = 15, y = 10, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2, double = true}, {1, 3}, {1, 4}, {2, 5}, {2, 6}}
    },
    lithium_hydroxide = {
        atoms = {
            {element = "Li", x = -10, y = 0, color = ELEMENT_COLORS.Li},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 16, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}}
    },
    sodium_hydroxide = {
        atoms = {
            {element = "Na", x = -12, y = 0, color = ELEMENT_COLORS.Na},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 16, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}}
    },
    uranyl = {
        atoms = {
            {element = "U", x = 0, y = 0, color = ELEMENT_COLORS.U},
            {element = "O", x = -15, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 15, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}},
        ion = true,
        charge = 2,
        radioactive = true
    },
    uranium_hexafluoride = {
        atoms = {
            {element = "U", x = 0, y = 0, color = ELEMENT_COLORS.U},
            {element = "F", x = 0, y = -20, color = ELEMENT_COLORS.F},
            {element = "F", x = 0, y = 20, color = ELEMENT_COLORS.F},
            {element = "F", x = 20, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = -20, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 14, y = 14, color = ELEMENT_COLORS.F},
            {element = "F", x = -14, y = -14, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}},
        radioactive = true,
        octahedral = true
    },
    perchloric_acid = {
        atoms = {
            {element = "Cl", x = 0, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "O", x = -15, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 15, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = 15, color = ELEMENT_COLORS.O},
            {element = "H", x = 7.5, y = 22.5, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}, {1, 4, double = true}, {1, 5}, {5, 6}}
    },
    squaric_acid = {
        atoms = {
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "O", x = -25, y = -25, color = ELEMENT_COLORS.O},
			{element = "O", x = -25, y = 25, color = ELEMENT_COLORS.O},
			{element = "H", x = -32.5, y = 17.5, color = ELEMENT_COLORS.H},
			{element = "H", x = -32.5, y = -17.5, color = ELEMENT_COLORS.H},
			{element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
			{element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
			{element = "O", x = 20, y = -20, color = ELEMENT_COLORS.O},
			{element = "O", x = 20, y = 20, color = ELEMENT_COLORS.O},
        },
        bonds = {{1, 2, double = true}, {2, 3}, {1, 4}, {3, 6}, {4, 5}, {1, 7}, {2, 8}, {7, 8}, {9, 8, double = true}, {10, 7, double = true}},
		aromantic = true,
    },
	phosgene = {
        atoms = {
		    {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
			{element = "Cl", x = -10, y = -5, color = ELEMENT_COLORS.Cl},
			{element = "Cl", x = 10, y = -5, color = ELEMENT_COLORS.Cl},
			{element = "O", x = 0, y = 10, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}}
    },
    carbonic_acid = {
        atoms = {
		    {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
			{element = "O", x = 0, y = 17, color = ELEMENT_COLORS.O},
			{element = "O", x = 20, y = -5, color = ELEMENT_COLORS.O},
			{element = "O", x = -20, y = -5, color = ELEMENT_COLORS.O},
			{element = "H", x = -32, y = 5, color = ELEMENT_COLORS.H},
			{element = "H", x = 32, y = 5, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {1, 3}, {1, 4}, {4, 5}, {3, 6}}
    },
	foof = {
        atoms = {
		    {element = "O", x = -8, y = 0, color = ELEMENT_COLORS.O},
		    {element = "O", x = 8, y = 0, color = ELEMENT_COLORS.O},
			{element = "F", x = 21, y = 7.5, color = ELEMENT_COLORS.F},
			{element = "F", x = -21, y = 7.5, color = ELEMENT_COLORS.F},
        },
        bonds = {{1, 2}, {1, 4}, {2, 3}}
    },
	chlorine_monofluoride = {
        atoms = {
		    {element = "Cl", x = -6, y = 0, color = ELEMENT_COLORS.Cl},
			{element = "F", x = 6, y = 0, color = ELEMENT_COLORS.F},
        },
        bonds = {{1, 2}}
    },
	hydrogen_fluoride = {
        atoms = {
			{element = "F", x = 3, y = 0, color = ELEMENT_COLORS.F},
			{element = "H", x = -3, y = 0, color = ELEMENT_COLORS.H},
        },
        bonds = {{1, 2}}
    },
	methanol = {
        atoms = {
			{element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
			{element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
			{element = "H", x = -25, y = 0, color = ELEMENT_COLORS.H},
			{element = "H", x = -20, y = 7.5, color = ELEMENT_COLORS.H},
			{element = "H", x = -20, y = -7.5, color = ELEMENT_COLORS.H},
			{element = "H", x = 10, y = 7.5, color = ELEMENT_COLORS.H},
        },
        bonds = {{1, 2}, {2, 3}, {2, 4}, {2, 5}, {1, 6}}
    },
	trihydrogen_cation = {
        atoms = {
            {element = "H", x = 0, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -8.7, y = 5, color = ELEMENT_COLORS.H},
            {element = "H", x = 8.7, y = 5, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3}, {3, 1}},
        ion = true,
        charge = 1,
        interstellar = true
    },
    tricarbon = {
        atoms = {
            {element = "C", x = -12, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 12, y = 0, color = ELEMENT_COLORS.C}
        },
        bonds = {{1, 2, double = true}, {2, 3, double = true}},
        interstellar = true,
        chain = true
    },
    cyanoacetylene = {
        atoms = {
            {element = "H", x = -24, y = 0, color = ELEMENT_COLORS.H},
            {element = "C", x = -16, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -4, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
            {element = "N", x = 18, y = 0, color = ELEMENT_COLORS.N}
        },
        bonds = {{1, 2}, {2, 3, triple = true}, {3, 4}, {4, 5, triple = true}},
        interstellar = true
    },
    ethynyl_radical = {
        atoms = {
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -18, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, triple = true}, {1, 3}},
        radical = true,
        interstellar = true
    },
    formyl_cation = {
        atoms = {
            {element = "H", x = -10, y = 0, color = ELEMENT_COLORS.H},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 10, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2}, {2, 3, triple = true}},
        ion = true,
        charge = 1,
        interstellar = true
    },
    acetonitrile = {
        atoms = {
            {element = "C", x = -12, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "N", x = 12, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -17, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -17, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = -19, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3, triple = true}, {1, 4}, {1, 5}, {1, 6}},
        interstellar = true
    },
    buckminsterfullerene = {
        atoms = {
            -- Simplified C60 representation; i ain't doing the whole thing
            {element = "C", x = 0, y = -35, color = ELEMENT_COLORS.C},
            {element = "C", x = -12, y = -30, color = ELEMENT_COLORS.C},
            {element = "C", x = 12, y = -30, color = ELEMENT_COLORS.C},
            {element = "C", x = -18, y = -18, color = ELEMENT_COLORS.C},
            {element = "C", x = 18, y = -18, color = ELEMENT_COLORS.C},
            {element = "C", x = -28, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = -30, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = 28, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 30, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -25, y = 18, color = ELEMENT_COLORS.C},
            {element = "C", x = 25, y = 18, color = ELEMENT_COLORS.C},
            {element = "C", x = -15, y = 28, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 28, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 35, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = -20, color = ELEMENT_COLORS.C},
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 20, color = ELEMENT_COLORS.C}
        },
        bonds = {
            {1, 2}, {1, 3}, {2, 4}, {3, 5}, {4, 6}, {5, 8},
            {6, 7}, {8, 9}, {7, 10}, {9, 11}, {10, 12}, {11, 13},
            {12, 14}, {13, 14}, {2, 15}, {3, 15}, {4, 16}, {6, 16},
            {5, 17}, {8, 17}, {10, 18}, {12, 18}, {11, 18}, {13, 18},
            {1, 15}, {15, 16}, {15, 17}, {16, 18}, {17, 18}, {7, 16}
        },
        fullerene = true,
        interstellar = true
    },
	
	azidoazide_azide = {
      atoms = {
          -- Central carbons
          {element = "C", x = -6, y = 0, color = ELEMENT_COLORS.C},
          {element = "C", x = 6, y = 0, color = ELEMENT_COLORS.C},
          -- Left azide chain
          {element = "N", x = -18, y = 0, color = ELEMENT_COLORS.N},
          {element = "N", x = -30, y = 0, color = ELEMENT_COLORS.N},
          {element = "N", x = -42, y = 0, color = ELEMENT_COLORS.N},
          -- Right azide chain
          {element = "N", x = 18, y = 0, color = ELEMENT_COLORS.N},
          {element = "N", x = 30, y = 0, color = ELEMENT_COLORS.N},
          {element = "N", x = 42, y = 0, color = ELEMENT_COLORS.N},
          -- Top azide chains (left side)
          {element = "N", x = -6, y = -12, color = ELEMENT_COLORS.N},
          {element = "N", x = -6, y = -24, color = ELEMENT_COLORS.N},
          {element = "N", x = -6, y = -36, color = ELEMENT_COLORS.N},
          -- Top azide chains (right side)
          {element = "N", x = 6, y = -12, color = ELEMENT_COLORS.N},
          {element = "N", x = 6, y = -24, color = ELEMENT_COLORS.N},
          {element = "N", x = 6, y = -36, color = ELEMENT_COLORS.N}
      },
      bonds = {
          {1, 2}, -- C-C bond
          {1, 3}, {3, 4}, {4, 5}, -- Left azide
          {2, 6}, {6, 7}, {7, 8}, -- Right azide
          {1, 9}, {9, 10}, {10, 11}, -- Top left azide
          {2, 12}, {12, 13}, {13, 14} -- Top right azide
      },
      explosive = true,
      unstable = true
    },
	
	-- Radioactive stuff
	polonium_atom = {
        atoms = {{element = "Po", x = 0, y = 0, color = ELEMENT_COLORS.Po}},
        bonds = {},
        radioactive = true
    },
    radium_atom = {
        atoms = {{element = "Ra", x = 0, y = 0, color = ELEMENT_COLORS.Ra}},
        bonds = {},
        radioactive = true
    },
    plutonium_atom = {
        atoms = {{element = "Pu", x = 0, y = 0, color = ELEMENT_COLORS.Pu}},
        bonds = {},
        radioactive = true
    },
    polonium_dioxide = {
        atoms = {
            {element = "Po", x = 0, y = 0, color = ELEMENT_COLORS.Po},
            {element = "O", x = -12, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 12, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}},
        radioactive = true
    },
    radium_chloride = {
        atoms = {
            {element = "Ra", x = 0, y = 0, color = ELEMENT_COLORS.Ra},
            {element = "Cl", x = -15, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 15, y = 0, color = ELEMENT_COLORS.Cl}
        },
        bonds = {{1, 2}, {1, 3}},
        radioactive = true
    },
    plutonium_dioxide = {
        atoms = {
            {element = "Pu", x = 0, y = 0, color = ELEMENT_COLORS.Pu},
            {element = "O", x = -12, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 12, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}},
        radioactive = true
    },
    strontium_90 = {
        atoms = {{element = "Sr", x = 0, y = 0, color = ELEMENT_COLORS.Sr}},
        bonds = {},
        radioactive = true
    },
    cesium_137 = {
        atoms = {{element = "Cs", x = 0, y = 0, color = ELEMENT_COLORS.Cs}},
        bonds = {},
        radioactive = true
    },
    tritium = {
        atoms = {{element = "T", x = 0, y = 0, color = ELEMENT_COLORS.T}},
        bonds = {},
        radioactive = true
    },
    radon = {
        atoms = {{element = "Rn", x = 0, y = 0, color = ELEMENT_COLORS.Ra}},
        bonds = {},
        radioactive = true
    }
}

local Molecule = {}
Molecule.__index = Molecule

function Molecule:new(type, x, y)
    local molConfig = config.molecules[type]
    local mol = {
        type = type,
        x = x,
        y = y,
        vx = 0,
        vy = 0,
        radius = molConfig.radius or 15,
        health = molConfig.health or 50,
        maxHealth = molConfig.health or 50,
        target = nil,
        wanderAngle = math.random() * math.pi * 2,
        alive = true,
        rotation = math.random() * math.pi * 2,
        rotationSpeed = (math.random() - 0.5) * 0.5,
        element = type:match("^(%w+)_atom$") or nil,
        attractionForce = 0,
        unstableTimer = 0  -- For carbon tetraiodide decay
    }
    setmetatable(mol, Molecule)
    return mol
end

function Molecule:update(dt)
    if not self.alive then
        return
    end

    -- Carbon tetraiodide slowly decomposes!
    if self.type == "carbon_tetraiodide" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 5 then  -- Decompose after 5 seconds
            self.health = self.health - 20 * dt
            
        end
		if self.health >= 0 then
		    self.alive = false
	    end
    end

    -- Triiodomethane also unstable but slower
    if self.type == "triiodomethane" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 15 then
            self.health = self.health - 5 * dt
        end
		if self.health >= 0 then
		    self.alive = false
	    end
    end
	
	if self.type == "azidoazide_azide" then
        self.unstableTimer = self.unstableTimer + dt
        if math.random() < 0.02 * dt then
            self.health = 0
            self.alive = false
        end
        local speed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
        if speed > 20 then
            self.health = self.health - speed * 0.5 * dt
        end
        self.health = self.health - 2 * dt
    end

    self.rotation = self.rotation + self.rotationSpeed * dt

    -- Predator/prey AI (keeping original logic + halomethanes)
    local molConfig = config.molecules[self.type]
    
    -- Halomethanes flee from halogens and oxidizers
    if self.type:match("methane") and self.type ~= "methane" then
        local threats = {"oxygen", "ozone", "chlorine", "fluorine", "hydrogen_peroxide"}
        
        -- Carbon tetrafluoride is basically inert - it doesn't flee much
        if self.type == "carbon_tetrafluoride" then
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.03
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.2
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.2
            self.rotationSpeed = 0.2
        else
            local nearestThreat = nil
            local nearestDist = DETECTION_RANGE

            for _, mol in ipairs(molecules) do
                for _, threat in ipairs(threats) do
                    if mol.type == threat and mol.alive then
                        local dx = mol.x - self.x
                        local dy = mol.y - self.y
                        local dist = math.sqrt(dx * dx + dy * dy)
                        if dist < nearestDist then
                            nearestThreat = mol
                            nearestDist = dist
                        end
                    end
                end
            end

            if nearestThreat then
                local dx = self.x - nearestThreat.x
                local dy = self.y - nearestThreat.y
                local dist = math.sqrt(dx * dx + dy * dy)
                local speedMult = molConfig.speedMultiplier or 1
                local speed = FLEE_SPEED * speedMult
                self.vx = (dx / dist) * speed
                self.vy = (dy / dist) * speed
                self.rotationSpeed = 2
            else
                self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
                self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
                self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
                self.rotationSpeed = 0.5
            end
        end
    elseif self.type == "oxygen" or self.type == "ozone" or self.type == "chlorine" or 
           self.type == "fluorine" or self.type == "hydrogen_peroxide" or
           self.type == "sulfuric_acid" or self.type == "hydrochloric_acid" or
           self.type == "hydronium" or self.type == "formaldehyde" or
           self.type == "hypobromous_acid" or self.type == "ethynyl_radical" or
           self.type == "trihydrogen_cation" or self.type == "formyl_cation" then
        local preyTypes = {"methane", "ethylene", "propane", "cyclopropane", "acetylcarnitine", 
                          "ethanol", "benzene", "ammonia", "caffeine", "tnt", "acetone",
                          "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene",
                          "helium_dimer", "helium_trimer", "tetrafluoroethylene", 
                          "fluoromethane", "difluoromethane", "trifluoromethane",
                          "chloromethane", "dichloromethane", "chloroform", "carbon_tetrachloride",
                          "bromomethane", "dibromomethane", "tribromomethane", "carbon_tetrabromide",
                          "iodomethane", "diiodomethane", "triiodomethane",
						  "butane", "pentane", "hexane", "heptane", "octane", "nonane", "decane"}

        if molConfig.prefersEthylene then
            preyTypes = {"ethylene", "tetrafluoroethylene", "cyclopropane", "benzene", "tnt", 
                        "acetylcarnitine", "methane", "propane"}
        elseif self.type == "fluorine" then
            -- Fluorine attacks EVERYTHING except fully fluorinated compounds
            preyTypes = {"methane", "ethylene", "propane", "cyclopropane", "acetylcarnitine",
                        "ethanol", "benzene", "ammonia", "water", "caffeine", "tnt", "acetone",
                        "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene",
                        "helium_dimer", "helium_trimer", "helium", "chloromethane", "dichloromethane", "chloroform",
                        "carbon_tetrachloride", "bromomethane", "dibromomethane", "tribromomethane",
                        "carbon_tetrabromide", "iodomethane", "diiodomethane", "triiodomethane",
                        "carbon_tetraiodide", "helium_hydride"}
        elseif self.type == "perchloric_acid" then
            -- Still hunts everything
            preyTypes = {}
            for molType, _ in pairs(config.molecules) do
                if molType ~= "perchloric_acid" then
                    table.insert(preyTypes, molType)
                end
            end
        end
		
		if self.type == "trihydrogen_cation" or self.type == "formyl_cation" then
            preyTypes = {"hydrogen_atom", "carbon_atom", "oxygen_atom", "nitrogen_atom",
                        "fluorine_atom", "chlorine_atom", "bromine_atom", "iodine_atom",
                        "helium", "water", "ammonia", "methane"}
        elseif self.type == "ethynyl_radical" then
            preyTypes = {"hydrogen_atom", "methane", "ethylene", "water", "ammonia",
                        "fluoromethane", "chloromethane"}
        end

        local closest = nil
        local detectionMult = molConfig.detectionMultiplier or 1
        local closestDist = DETECTION_RANGE * detectionMult

        for _, mol in ipairs(molecules) do
            for _, preyType in ipairs(preyTypes) do
                if mol.type == preyType and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < closestDist then
                        closest = mol
                        closestDist = dist
                        break
                    end
                end
            end
        end

        if closest then
            local dx = closest.x - self.x
            local dy = closest.y - self.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local speedMult = molConfig.speedMultiplier or 1
            local speed = HUNT_SPEED * speedMult
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 2

            local damage = molConfig.damage or 50
            if dist < self.radius + closest.radius then
                local damageMultiplier = 1.0
                if closest.type == "buckminsterfullerene" then
                    damageMultiplier = 0.1
                end
                
                closest.health = closest.health - (damage * damageMultiplier * dt)
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.1
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.3
        end
    elseif self.type == "propane" or self.type == "cyclopropane" or self.type == "cyclopropenylidene" or
           self.type == "cyclobutane" or self.type == "cyclobutene" or self.type == "cyclopentane" or
           self.type == "benzene" or self.type == "ethylene" or self.type == "ethanol" or
           self.type == "ammonia" or self.type == "caffeine" or self.type == "tnt" or
           self.type == "acetone" or self.type == "acetylcarnitine" or self.type == "helium_dimer" or
           self.type == "tetrafluoroethylene" or self.type == "tricarbon" or self.type == "helium_trimer" or
           self.type == "cyanoacetylene" or self.type == "acetonitrile" then
        local threats = {"oxygen", "ozone", "chlorine", "fluorine", "hydrogen_peroxide", 
                        "sulfuric_acid", "hydrochloric_acid", "perchloric_acid", "formaldehyde",
                        "hypobromous_acid", "trihydrogen_cation", "formyl_cation", "ethynyl_radical"}
        local nearestThreat = nil
        local nearestDist = DETECTION_RANGE

        for _, mol in ipairs(molecules) do
            for _, threat in ipairs(threats) do
                if mol.type == threat and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < nearestDist then
                        nearestThreat = mol
                        nearestDist = dist
                    end
                end
            end
        end

        if nearestThreat then
            local dx = self.x - nearestThreat.x
            local dy = self.y - nearestThreat.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local speedMult = molConfig.speedMultiplier or 1
            local speed = FLEE_SPEED * speedMult
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            
            if self.type == "cyclopropane" or self.type == "cyclopropenylidene" then
                self.rotationSpeed = 5
            elseif self.type == "cyclobutane" or self.type == "cyclobutene" then
                self.rotationSpeed = 4
            elseif self.type == "helium_dimer" then
                self.rotationSpeed = 6
		    elseif self.type == "helium_trimer" then
                self.rotationSpeed = 5.5
            else
                self.rotationSpeed = 3
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            
            if self.type == "benzene" then
                self.rotationSpeed = 0.3
            elseif self.type == "cyclopropenylidene" then
                self.rotationSpeed = 3
            elseif self.type == "cyclopropane" or self.type == "cyclobutene" then
                self.rotationSpeed = 2
            elseif self.type == "cyclobutane" then
                self.rotationSpeed = 1.5
            else
                self.rotationSpeed = 0.5
            end
        end
    elseif self.type == "water" or self.type == "co2" or self.type == "helium" or 
           self.type == "helium_hydride" or self.type == "buckminsterfullerene" then
        if self.type == "helium" then
            local nearestFluorine = nil
            local nearestDist = DETECTION_RANGE
            for _, mol in ipairs(molecules) do
                if mol.type == "fluorine" and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < nearestDist then
                        nearestFluorine = mol
                        nearestDist = dist
                    end
                end
            end
            if nearestFluorine then
                local dx = self.x - nearestFluorine.x
                local dy = self.y - nearestFluorine.y
                local dist = math.sqrt(dx * dx + dy * dy)
                local speed = FLEE_SPEED * 1.5
                self.vx = (dx / dist) * speed
                self.vy = (dy / dist) * speed
                self.rotationSpeed = 8
            else
                local speedMult = molConfig.speedMultiplier or 1
                self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
                self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * speedMult)
                self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * speedMult)
                self.rotationSpeed = 2
            end
        else
            local speedMult = molConfig.speedMultiplier or 1
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * speedMult)
            self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * speedMult)
            self.rotationSpeed = 0.3
        end
    elseif self.type == "buckminsterfullerene" then
        -- C60 is extremely stable and barely moves
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.02
        self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.rotationSpeed = 0.1
    else
        -- Default wander for everything else
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
        self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
        self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
        self.rotationSpeed = 0.5
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- World wrapping
    if self.x < 0 then self.x = WORLD_WIDTH end
    if self.x > WORLD_WIDTH then self.x = 0 end
    if self.y < 0 then self.y = WORLD_HEIGHT end
    if self.y > WORLD_HEIGHT then self.y = 0 end
end

function Molecule:draw()
    if not self.alive then return end
    local struct = structures[self.type]
    if not struct then return end
	
    if struct.interstellar then
        local pulse = (math.sin(love.timer.getTime() * 2) + 1) * 0.5
        
        if self.type == "trihydrogen_cation" or self.type == "formyl_cation" then
            love.graphics.setColor(0.3, 0.5, 1, 0.15 + pulse * 0.15)
            love.graphics.circle("fill", self.x, self.y, self.radius + 8)
            for i = 1, 2 do
                love.graphics.circle("line", self.x, self.y, self.radius + i * 6)
            end
        elseif self.type == "ethynyl_radical" or self.type == "tricarbon" then
            love.graphics.setColor(0.7, 0.3, 0.8, 0.1 + pulse * 0.1)
            love.graphics.circle("fill", self.x, self.y, self.radius + 6)
        elseif self.type == "buckminsterfullerene" then
            -- Golden cosmic glow for our beloved buckyball
            love.graphics.setColor(0.9, 0.7, 0.2, 0.15 + pulse * 0.15)
            love.graphics.circle("fill", self.x, self.y, self.radius + 12)
            for i = 1, 4 do
                love.graphics.setColor(0.8, 0.6, 0.1, 0.3)
                love.graphics.circle("line", self.x, self.y, self.radius + i * 7)
            end
        else
            love.graphics.setColor(0.3, 0.8, 0.8, 0.1 + pulse * 0.1)
            love.graphics.circle("fill", self.x, self.y, self.radius + 5)
        end
    end
	
	if self.type == "azidoazide_azide" then
        local pulse = (math.sin(love.timer.getTime() * 10) + 1) * 0.5  -- Fast pulse
        love.graphics.setColor(1, 0, 0, 0.3 + pulse * 0.4)
        love.graphics.circle("fill", self.x, self.y, self.radius + 15)
        for i = 1, 5 do
            love.graphics.setColor(1, 0.2, 0, 0.4)
            love.graphics.circle("line", self.x, self.y, self.radius + i * 10)
        end
    end

    -- Carbon tetraiodide gets purple glow when unstable
    if self.type == "carbon_tetraiodide" and self.unstableTimer > 5 then
        local pulse = (math.sin(love.timer.getTime() * 5) + 1) * 0.5
        love.graphics.setColor(0.5, 0, 0.5, 0.2 + pulse * 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 10)
        for i = 1, 3 do
            love.graphics.circle("line", self.x, self.y, self.radius + i * 8)
        end
    end

    -- Triiodomethane also gets a weaker glow
    if self.type == "triiodomethane" and self.unstableTimer > 15 then
        local pulse = (math.sin(love.timer.getTime() * 3) + 1) * 0.5
        love.graphics.setColor(0.5, 0, 0.5, 0.1 + pulse * 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius + 5)
    end

    if camera.followTarget == self then
        love.graphics.setColor(1, 1, 0, 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 10)
    end

    -- Atom attraction visualization
    if self.element and self.attractionForce > 0 then
        local intensity = math.min(self.attractionForce / 50, 0.3)
        love.graphics.setColor(0.3, 0.8, 1, intensity * 0.3)
        love.graphics.circle("line", self.x, self.y, ATTRACTION_RANGE)
    end

    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)

    -- Draw bonds
    love.graphics.setLineWidth(2)
    for _, bond in ipairs(struct.bonds) do
        local atom1 = struct.atoms[bond[1]]
        local atom2 = struct.atoms[bond[2]]
        
        if bond.double then
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.line(atom1.x, atom1.y - 2, atom2.x, atom2.y - 2)
            love.graphics.line(atom1.x, atom1.y + 2, atom2.x, atom2.y + 2)
        elseif bond.resonance then
            love.graphics.setColor(0.7, 0.5, 0.9, 0.8)
            local steps = 5
            local dx = (atom2.x - atom1.x) / steps
            local dy = (atom2.y - atom1.y) / steps
            for i = 0, steps - 1 do
                if i % 2 == 0 then
                    love.graphics.line(atom1.x + dx * i, atom1.y + dy * i, 
                                     atom1.x + dx * (i + 1), atom1.y + dy * (i + 1))
                end
            end
        elseif bond.weak then
            love.graphics.setColor(0.8, 0.9, 1, 0.5)
            local steps = 12
            local dx = (atom2.x - atom1.x) / steps
            local dy = (atom2.y - atom1.y) / steps
            for i = 0, steps - 1 do
                if i % 3 == 0 then
                    love.graphics.circle("fill", atom1.x + dx * i, atom1.y + dy * i, 1)
                end
            end
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.line(atom1.x, atom1.y, atom2.x, atom2.y)
        end
    end

    -- Draw atoms
    for _, atom in ipairs(struct.atoms) do
        love.graphics.setColor(atom.color)
        local atomSize = 6
        if atom.element == "H" then atomSize = 4 end
        if atom.element == "I" then atomSize = 8 end
        if atom.element == "Br" then atomSize = 7 end
        if atom.element == "Cl" then atomSize = 6.5 end
        if atom.element == "U" then atomSize = 9 end
        
        love.graphics.circle("fill", atom.x, atom.y, atomSize)
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.circle("line", atom.x, atom.y, atomSize)
    end

    -- Ion charge indicator
    if struct.ion then
        local chargeText = struct.charge > 0 and "+" .. tostring(struct.charge) or tostring(struct.charge)
        local chargeColor = struct.charge > 0 and {1, 0.5, 0.5} or {0.5, 0.5, 1}
        love.graphics.setColor(chargeColor)
        love.graphics.print(chargeText, -8, -25)
        love.graphics.setColor(chargeColor[1], chargeColor[2], chargeColor[3], 0.2)
        love.graphics.circle("fill", 0, 0, self.radius + 5)
    end

    -- Radioactive glow
    if struct.radioactive then
        local pulse = (math.sin(love.timer.getTime() * 3) + 1) * 0.5
        local intensity = 0.1
        
        -- Extra glow for extremely radioactive elements
        if self.type == "polonium_atom" or self.type == "polonium_dioxide" then
            intensity = 0.2
            love.graphics.setColor(0.7, 0, 0.7, intensity + pulse * 0.2)
        elseif self.type == "radium_atom" or self.type == "radium_chloride" then
            love.graphics.setColor(0, 1, 0.5, intensity + pulse * 0.15)
        elseif self.type == "tritium" then
            love.graphics.setColor(0.5, 1, 0.5, intensity + pulse * 0.1)
        else
            love.graphics.setColor(0, 1, 0, intensity + pulse * 0.1)
        end
        
        for i = 1, 3 do
            love.graphics.circle("line", 0, 0, self.radius + i * 5)
        end
    end

    love.graphics.pop()

    -- Debug visualization
    if love.keyboard.isDown("d") then
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.circle("line", self.x, self.y, DETECTION_RANGE)
    end

    if self.element then
        love.graphics.setColor(0, 1, 0, 0.1)
        love.graphics.circle("line", self.x, self.y, BONDING_DISTANCE)
    end
end

function love.load()
    love.window.setTitle(config.game.title)
    love.window.setMode(config.game.window.width, config.game.window.height)
    
    for molType, count in pairs(config.initialSpawns) do
        for i = 1, count do
            table.insert(molecules, Molecule:new(molType, 
                math.random(100, WORLD_WIDTH - 100), 
                math.random(100, WORLD_HEIGHT - 100)))
        end
    end

    camera.x = WORLD_WIDTH / 2 - love.graphics.getWidth() / 2
    camera.y = WORLD_HEIGHT / 2 - love.graphics.getHeight() / 2
end

function love.update(dt)
    dt = dt * TimeSlider.scale
    local mouseX, mouseY = love.mouse.getPosition()
    local worldX = camera.x + mouseX / camera.zoom
    local worldY = camera.y + mouseY / camera.zoom

    hoveredMolecule = nil
    local closestDist = 30 / camera.zoom

    for _, mol in ipairs(molecules) do
        if mol.alive then
            local dx = mol.x - worldX
            local dy = mol.y - worldY
            local dist = math.sqrt(dx * dx + dy * dy)

            if dist < mol.radius + closestDist then
                hoveredMolecule = mol
                closestDist = dist
            end
        end
    end

    for _, mol in ipairs(molecules) do
        mol:update(dt)
    end

    -- Remove dead molecules
    for i = #molecules, 1, -1 do
        if not molecules[i].alive then
            if camera.followTarget == molecules[i] then
                camera.followTarget = nil
            end
            playDeathSound(molecules[i].type)  -- SOUND!
            spawnFragments(molecules[i])
            table.remove(molecules, i)
        end
    end
	
	local zoomSpeed = 1
    local oldZoom = camera.zoom

    -- Camera controls
    if camera.followTarget and camera.followTarget.alive then
        local targetX = camera.followTarget.x - love.graphics.getWidth() / (2 * camera.zoom)
        local targetY = camera.followTarget.y - love.graphics.getHeight() / (2 * camera.zoom)
        camera.x = camera.x + (targetX - camera.x) * 5 * dt
        camera.y = camera.y + (targetY - camera.y) * 5 * dt
    else
        local camSpeed = config.camera.moveSpeed / camera.zoom
        if love.keyboard.isDown("left") then camera.x = camera.x - camSpeed * dt end
        if love.keyboard.isDown("right") then camera.x = camera.x + camSpeed * dt end
        if love.keyboard.isDown("up") then camera.y = camera.y - camSpeed * dt end
        if love.keyboard.isDown("down") then camera.y = camera.y + camSpeed * dt end
    end

    if love.keyboard.isDown("+") or love.keyboard.isDown("=") then
        camera.zoom = math.min(camera.zoom + 1 * dt, camera.maxZoom)
    end
    if love.keyboard.isDown("-") or love.keyboard.isDown("_") then
        camera.zoom = math.max(camera.zoom - 1 * dt, camera.minZoom)
    end
	
	if camera.zoom ~= oldZoom then
        local screenCenterX = love.graphics.getWidth() / 2
        local screenCenterY = love.graphics.getHeight() / 2
        local worldCenterX = camera.x + screenCenterX / oldZoom
        local worldCenterY = camera.y + screenCenterY / oldZoom
        camera.x = worldCenterX - screenCenterX / camera.zoom
        camera.y = worldCenterY - screenCenterY / camera.zoom
    end
end

function love.draw()
    drawWorld()
    drawUI()
	TimeSlider.draw()
    if hoveredMolecule then
        drawMoleculeTooltip(hoveredMolecule)
    end
    Console.draw()  -- Draw console on top
end

function drawWorld()
    love.graphics.push()
    love.graphics.translate(-camera.x * camera.zoom, -camera.y * camera.zoom)
    love.graphics.scale(camera.zoom, camera.zoom)

    -- Background
    love.graphics.setColor(config.visual.backgroundColor)
    love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)

    -- Grid
    love.graphics.setColor(config.visual.gridColor)
    for x = 0, WORLD_WIDTH, config.visual.gridSize do
        love.graphics.line(x, 0, x, WORLD_HEIGHT)
    end
    for y = 0, WORLD_HEIGHT, config.visual.gridSize do
        love.graphics.line(0, y, WORLD_WIDTH, y)
    end

    -- Molecules
    for _, mol in ipairs(molecules) do
        mol:draw()
    end

    love.graphics.pop()
end

function drawUI()
    local y = 10

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(config.game.title .. " " .. config.game.version, 10, y, 0, 1.5, 1.5)
    y = y + 40

    if config.debug.showFPS then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, y)
        y = y + 25
    end

    love.graphics.print("Molecules: " .. #molecules, 10, y)
    y = y + 25

    love.graphics.print("Zoom: " .. string.format("%.1f", camera.zoom) .. "x", 10, y)
    y = y + 25

    if camera.followTarget and camera.followTarget.alive then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("Following: " .. camera.followTarget.type, 10, y)
        love.graphics.setColor(1, 1, 1)
        y = y + 20
    end

    love.graphics.print("Arrow keys: Move  |  +/- : Zoom  |  ESC: Unfollow", 10, y)
    y = y + 20
    love.graphics.print("Middle-click: Focus on molecule  |  ` : Console", 10, y)
end

function drawMoleculeTooltip(molecule)
    if TimeSlider.mousepressed(x, y, button) then
        return
    end
    local mouseX, mouseY = love.mouse.getPosition()
    local lines = {}

    -- Basic info
    table.insert(lines, "Type: " .. molecule.type)
    table.insert(lines, "Health: " .. math.floor(molecule.health) .. "/" .. molecule.maxHealth)

    -- Special properties for halomethanes
    if molecule.type:match("fluoro") or molecule.type == "carbon_tetrafluoride" then
        table.insert(lines, "Fluorinated - resistant to attack")
    end
    if molecule.type:match("chloro") or molecule.type == "carbon_tetrachloride" then
        table.insert(lines, "Chlorinated")
    end
    if molecule.type:match("bromo") or molecule.type == "carbon_tetrabromide" then
        table.insert(lines, "Brominated - heavy")
    end
    if molecule.type:match("iodo") or molecule.type == "carbon_tetraiodide" then
        table.insert(lines, "Iodinated - UNSTABLE!")
        if molecule.type == "carbon_tetraiodide" then
            table.insert(lines, "PURPLE EXPLOSIVE!")
            if molecule.unstableTimer > 0 then
                table.insert(lines, string.format("Time to decay: %.1fs", math.max(0, 5 - molecule.unstableTimer)))
            end
        end
    end
	
	if molecule.type == "butane" then
        table.insert(lines, "C4 alkane - lighter fuel")
    elseif molecule.type == "pentane" then
        table.insert(lines, "C5 alkane - volatile liquid")
    elseif molecule.type == "hexane" then
        table.insert(lines, "C6 alkane - common solvent")
    elseif molecule.type == "heptane" then
        table.insert(lines, "C7 alkane - reference fuel")
    elseif molecule.type == "octane" then
        table.insert(lines, "C8 alkane - GASOLINE!")
    elseif molecule.type == "nonane" then
        table.insert(lines, "C9 alkane - diesel component")
    elseif molecule.type == "decane" then
        table.insert(lines, "C10 alkane - getting waxy")
    end
	
	if molecule.type == "deuterium" or molecule.type == "deuterium_atom" then
        table.insert(lines, "Heavy hydrogen isotope - 2H")
    elseif molecule.type == "heavy_water" then
        table.insert(lines, "D2O - neutron moderator")
        table.insert(lines, "Used in nuclear reactors!")
    elseif molecule.type == "semiheavy_water" then
        table.insert(lines, "HDO - mixed isotope water")
    elseif molecule.type == "deuterium_oxide_ion" then
        table.insert(lines, "D3O+ - heavy hydronium")
    elseif molecule.type == "deuterated_ammonia" then
        table.insert(lines, "ND3 - NMR solvent")
    elseif molecule.type == "deuterated_methane" then
        table.insert(lines, "CD4 - deuterated fuel")
    end

    if molecule.type == "cyclopropane" or molecule.type == "cyclopropenylidene" or 
       molecule.type == "cyclobutane" or molecule.type == "cyclobutene" then
        table.insert(lines, "Ring strain - unstable!")
    end
    if molecule.type == "benzene" then
        table.insert(lines, "Aromatic - very stable")
    end
    if molecule.type == "caffeine" then
        table.insert(lines, "Stimulant - speeds things up!")
    end
    if molecule.type == "tnt" then
        table.insert(lines, "EXPLOSIVE!")
    end
    if molecule.type == "helium_dimer" then
        table.insert(lines, "Weakly bound - very fragile")
    end
	if molecule.type == "helium_trimer" then
        table.insert(lines, "More weakly bound - even more fragile than helium dimer")
    end
    if molecule.type == "helium" then
        table.insert(lines, "Noble gas - inert")
    end
    if molecule.type == "acetylcarnitine" then
        table.insert(lines, "Large biomolecule")
    end
    if molecule.type == "ethanol" then
        table.insert(lines, "Alcohol - flammable")
    end
    if molecule.type == "ammonia" then
        table.insert(lines, "Base - pungent smell")
    end
    if molecule.type == "squaric_acid" then
        table.insert(lines, "Aromatic acid - square!")
    end
    if molecule.type == "cyclopentane" then
        table.insert(lines, "Five-membered ring - stable")
    end
    if molecule.type == "propane" then
        table.insert(lines, "Simple alkane - fuel")
    end
    if molecule.type == "methane" then
        table.insert(lines, "Simplest alkane - natural gas")
    end
    if molecule.type == "ethylene" then
        table.insert(lines, "Alkene - plant hormone")
    end
    if molecule.type == "acetone" then
        table.insert(lines, "Ketone - solvent")
    end
    if molecule.type == "tetrafluoroethylene" then
        table.insert(lines, "Precursor to Teflon")
    end
    if molecule.type == "water" then
        table.insert(lines, "Universal solvent")
    end
	if molecule.type == "helium_hydride" then
        table.insert(lines, "One of the lightest molecules")
    end
    if molecule.type == "co2" then
        table.insert(lines, "Carbon dioxide - greenhouse gas")
    end
    if molecule.type == "oxygen" then
        table.insert(lines, "Oxidizer - essential for life")
    end
    if molecule.type == "ozone" then
        table.insert(lines, "Triatomic oxygen - UV shield")
        table.insert(lines, "Prefers alkenes!")
    end
    if molecule.type == "chlorine" then
        table.insert(lines, "Diatomic halogen - reactive")
    end
    if molecule.type == "fluorine" then
        table.insert(lines, "MOST reactive element!")
        table.insert(lines, "Attacks everything!")
    end
    if molecule.type == "hydrogen_peroxide" then
        table.insert(lines, "Oxidizer - bleaching agent")
    end
    if molecule.type == "sulfuric_acid" then
        table.insert(lines, "Strong acid - corrosive")
    end
	if molecule.type == "hypobromous_acid" then
        table.insert(lines, "Strong acid - corrosive")
    end
	if molecule.type == "formaldehyde" then
        table.insert(lines, "Simplest aldehyde")
    end
    if molecule.type == "hydrochloric_acid" then
        table.insert(lines, "Weak acid")
    end
    if molecule.type == "perchloric_acid" then
        table.insert(lines, "SUPERACID - strongest!")
        table.insert(lines, "Hunts EVERYTHING!")
    end
    if molecule.type == "lithium_hydroxide" then
        table.insert(lines, "Strong base - CO2 scrubber")
    end
    if molecule.type == "sodium_hydroxide" then
        table.insert(lines, "Strong base - lye")
    end
    if molecule.type == "hydroxide" then
        table.insert(lines, "Base ion - OH⁻")
        table.insert(lines, "Neutralizes acids!")
    end
    if molecule.type == "hydronium" then
        table.insert(lines, "Acid ion - H3O⁺")
        table.insert(lines, "Neutralizes bases!")
    end
	if molecule.type == "miau" then
        table.insert(lines, "My sister requested I add this.")
        table.insert(lines, "I just couldn't say no.")
    end
    if molecule.type == "uranyl" then
        table.insert(lines, "Uranium(VI) ion - UO2²⁺")
        table.insert(lines, "Soluble, seeks hydroxide")
    end
    if molecule.type == "uranium_hexafluoride" then
        table.insert(lines, "Enrichment compound")
        table.insert(lines, "Highly reactive and toxic")
    end
    if molecule.type == "uranium_atom" then
        table.insert(lines, "Actinide - fissile")
    end
    if molecule.type == "hydrogen_atom" then
        table.insert(lines, "Most abundant element")
    end
    if molecule.type == "carbon_atom" then
        table.insert(lines, "Basis of organic chemistry")
    end
    if molecule.type == "oxygen_atom" then
        table.insert(lines, "Essential for combustion")
    end
    if molecule.type == "nitrogen_atom" then
        table.insert(lines, "78% of atmosphere")
    end
    if molecule.type == "nitrogen_positive1_atom" then
        table.insert(lines, "Nitrogen cation - N⁺")
    end
    if molecule.type == "fluorine_atom" then
        table.insert(lines, "Most electronegative")
    end
    if molecule.type == "chlorine_atom" then
        table.insert(lines, "Halogen - reactive")
    end
    if molecule.type == "bromine_atom" then
        table.insert(lines, "Heavy halogen")
    end
    if molecule.type == "iodine_atom" then
        table.insert(lines, "Heaviest stable halogen")
        table.insert(lines, "Purple!")
    end

    if config.molecules[molecule.type].refrigerant then
        table.insert(lines, "Refrigerant (CFC)")
    end
    if config.molecules[molecule.type].anesthetic then
        table.insert(lines, "Anesthetic properties")
    end
    if config.molecules[molecule.type].toxic then
        table.insert(lines, "TOXIC")
    end
    if config.molecules[molecule.type].inert then
        table.insert(lines, "INERT - super stable!")
    end
    if config.molecules[molecule.type].radioactive then
        table.insert(lines, "[!] RADIOACTIVE [!]")
    end
	
    if molecule.type == "trihydrogen_cation" then
        table.insert(lines, "Most abundant ion in space!")
        table.insert(lines, "Electron hungry - hunts atoms")
    end
    if molecule.type == "tricarbon" then
        table.insert(lines, "Linear carbon chain")
        table.insert(lines, "Found in molecular clouds")
    end
    if molecule.type == "cyanoacetylene" then
        table.insert(lines, "Common in space")
        table.insert(lines, "Precursor to complex organics")
    end
    if molecule.type == "ethynyl_radical" then
        table.insert(lines, "Highly reactive radical")
        table.insert(lines, "Key in interstellar chemistry")
    end
    if molecule.type == "formyl_cation" then
        table.insert(lines, "2nd most abundant ion")
        table.insert(lines, "Proton affinity marker")
    end
    if molecule.type == "acetonitrile" then
        table.insert(lines, "Complex organic")
        table.insert(lines, "Found near star-forming regions")
    end
    if molecule.type == "buckminsterfullerene" then
        table.insert(lines, "Extremely stable fullerene")
        table.insert(lines, "Found in planetary nebulae!")
        table.insert(lines, "[90% damage resistance]")
    end

    -- Atom info
    if molecule.element then
        table.insert(lines, "Free atom - can bond!")
        local valence = config.molecules[molecule.type].valence
        if valence then
            table.insert(lines, "Valence: " .. valence)
        end
    end

    -- Behavior info
    local behaviorInfo = getMoleculeBehaviorInfo(molecule)
    if behaviorInfo.hunts and #behaviorInfo.hunts > 0 then
        table.insert(lines, "Hunts: " .. table.concat(behaviorInfo.hunts, ", "))
    end
    if behaviorInfo.huntedBy and #behaviorInfo.huntedBy > 0 then
        table.insert(lines, "Hunted by: " .. table.concat(behaviorInfo.huntedBy, ", "))
    end

    -- Calculate tooltip size
    local maxWidth = 0
    for _, line in ipairs(lines) do
        local w = love.graphics.getFont():getWidth(line)
        if w > maxWidth then
            maxWidth = w
        end
    end

    local tooltipWidth = maxWidth + 20
    local tooltipHeight = #lines * 20 + 10
    local tooltipX = mouseX + 15
    local tooltipY = mouseY + 15

    -- Keep on screen
    if tooltipX + tooltipWidth > love.graphics.getWidth() then
        tooltipX = mouseX - tooltipWidth - 15
    end
    if tooltipY + tooltipHeight > love.graphics.getHeight() then
        tooltipY = mouseY - tooltipHeight - 15
    end

    -- Draw background
    love.graphics.setColor(0.1, 0.1, 0.15, 0.95)
    love.graphics.rectangle("fill", tooltipX, tooltipY, tooltipWidth, tooltipHeight, 5, 5)
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.rectangle("line", tooltipX, tooltipY, tooltipWidth, tooltipHeight, 5, 5)

    -- Draw text
    love.graphics.setColor(1, 1, 1)
    for i, line in ipairs(lines) do
        love.graphics.print(line, tooltipX + 10, tooltipY + 5 + (i - 1) * 20)
    end
end

function getMoleculeBehaviorInfo(molecule)
    local info = {hunts = {}, huntedBy = {}}

    if molecule.type == "oxygen" or molecule.type == "ozone" or molecule.type == "chlorine" or
       molecule.type == "fluorine" or molecule.type == "hydrogen_peroxide" or
       molecule.type == "sulfuric_acid" or molecule.type == "hydrochloric_acid" or
	   molecule.type == "formaldehyde" or molecule.type == "hypobromous_acid" then
        table.insert(info.hunts, "hydrocarbons")
        table.insert(info.hunts, "halomethanes")
        if molecule.type == "fluorine" then
            table.insert(info.hunts, "noble gases")
        end
	elseif molecule.type == "trihydrogen_cation" or molecule.type == "formyl_cation" then
        table.insert(info.hunts, "atoms")
        table.insert(info.hunts, "electrons")
    elseif molecule.type == "ethynyl_radical" then
        table.insert(info.hunts, "hydrogen")
        table.insert(info.hunts, "small molecules")
    elseif molecule.type == "perchloric_acid" then
        table.insert(info.hunts, "EVERYTHING")
    elseif molecule.type == "hydroxide" then
        table.insert(info.hunts, "acids")
        table.insert(info.huntedBy, "hydronium")
    elseif molecule.type == "hydronium" then
        table.insert(info.hunts, "bases")
        table.insert(info.huntedBy, "hydroxide")
    elseif molecule.type == "lithium_hydroxide" or molecule.type == "sodium_hydroxide" then
        table.insert(info.hunts, "CO2")
        table.insert(info.hunts, "water")
		table.insert(info.hunts, "helium hydride")
    elseif molecule.type == "uranium_hexafluoride" then
        table.insert(info.hunts, "water")
        table.insert(info.hunts, "organics")
    elseif molecule.type == "uranyl" then
        table.insert(info.hunts, "hydroxide")
    end

    if molecule.type:match("methane") or molecule.type == "ethylene" or molecule.type == "benzene" or
       molecule.type == "cyclopropane" or molecule.type == "cyclopentane" or
       molecule.type == "cyclobutane" or molecule.type == "cyclobutene" or
       molecule.type == "propane" or molecule.type == "ethanol" or
       molecule.type == "ammonia" or molecule.type == "caffeine" or
       molecule.type == "tnt" or molecule.type == "acetone" or
       molecule.type == "acetylcarnitine" or molecule.type == "helium_dimer" or
       molecule.type == "tricarbon" or molecule.type == "cyanoacetylene" or 
       molecule.type == "acetonitrile" or molecule.type == "helium_trimer" then
        table.insert(info.huntedBy, "O2")
        table.insert(info.huntedBy, "O3")
        table.insert(info.huntedBy, "Cl2")
        table.insert(info.huntedBy, "F2")
        table.insert(info.huntedBy, "acids")
        table.insert(info.huntedBy, "radicals")
    end

    if molecule.type == "helium" then
        table.insert(info.huntedBy, "F2 (only!)")
    end

    if molecule.type == "water" or molecule.type == "co2" then
        table.insert(info.huntedBy, "bases")
    end
	
	if molecule.type == "buckminsterfullerene" then
        table.insert(info.huntedBy, "almost nothing!")
    end

    return info
end

spawnFragments = function(molecule)
    local fragmentation = deathFragmentations[molecule.type]
    if not fragmentation then return end

    local fragmentCount = 0
    for _, rule in ipairs(fragmentation) do
        fragmentCount = fragmentCount + rule.count
    end

    local angleStep = (math.pi * 2) / fragmentCount
    local currentAngle = math.random() * math.pi * 2

    for _, rule in ipairs(fragmentation) do
        for i = 1, rule.count do
            local distance = 30 + math.random() * 20
            local x = molecule.x + math.cos(currentAngle) * distance
            local y = molecule.y + math.sin(currentAngle) * distance
            local fragment = Molecule:new(rule.type, x, y)
            local explosionSpeed = 80 + math.random() * 40
            
            -- Bigger explosion for unstable molecules
            if molecule.type == "carbon_tetraiodide" or molecule.type == "tnt" or 
               molecule.type == "triiodomethane" then
                explosionSpeed = explosionSpeed * 2
            end
            
            fragment.vx = math.cos(currentAngle) * explosionSpeed
            fragment.vy = math.sin(currentAngle) * explosionSpeed
            table.insert(molecules, fragment)
            currentAngle = currentAngle + angleStep
        end
    end
end

function love.keypressed(key)
    -- Console gets first priority
    local context = {
        molecules = molecules,
        camera = camera,
        config = config,
        Molecule = Molecule
    }
    
    if Console.keypressed(key, context) then
        return  -- Console handled it
    end
    
    -- Normal game keys
    if key == "escape" then
        camera.followTarget = nil
    end
    if key == "0" then
        camera.zoom = config.camera.defaultZoom
    end
end

function love.textinput(text)
    Console.textinput(text)
end

function love.mousepressed(x, y, button)
    if TimeSlider.mousepressed(x, y, button) then
        return
    end
    if button == 3 then
        local worldX = camera.x + x / camera.zoom
        local worldY = camera.y + y / camera.zoom
        local closest = nil
        local closestDist = 50 / camera.zoom

        for _, mol in ipairs(molecules) do
            if mol.alive then
                local dx = mol.x - worldX
                local dy = mol.y - worldY
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < closestDist and dist < mol.radius + 20 then
                    closest = mol
                    closestDist = dist
                end
            end
        end

        if closest then
            camera.followTarget = (camera.followTarget == closest) and nil or closest
            if camera.followTarget == closest then
                playTrackSound()  -- SOUND when locking on!
            end
        else
            camera.followTarget = nil
        end
    end
end