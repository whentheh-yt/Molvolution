--      _     ___   ____
--     | |   / _ \ / ___|
--     | |  | | | | |  _
--     | |__| |_| | |_| |
--     |_____\___/ \____|
--
-- ----------------------- -
-- December 20 2025 12:52  - Started. Finally. Hooray. (December 2025 Build 0.1.14779)
-- December 20 2025 13:39  - Fixed subscript bug for hydroxide. (December 2025 Build 0.1.14783)
-- December 20 2025 14:29  - Added uranium compounds, fixed love:draw and fragmentationRules, and other stuff. (December 2025 Build 0.1.14897)
-- December 20 2025 15:21  - Added atom attractions. (December 2025 Build 0.1.15012)
-- December 20 2025 16:15  - HALOMETHANE EDITION - Added ALL the halomethanes! (December 2025 Build 0.1.15050)
-- ----------------------- -
-- December 21 2025 11:01  - Added 3 secret molecules and a console. (December 2025 Build 0.1.15102)
-- December 21 2025 15:31  - Added more alkanes, added sound and revamped death. Also main.lua hit 100KB. (December 2025 Build 0.1.15223)
-- December 21 2025 20:31  - Added interstellar molecules. (December 2025 Build 0.1.15256)
-- December 21 2025 20:53  - Added a time slider, fixed the camera zooming and added .\libs. (December 2025 Build 0.1.15279)
-- ----------------------- -
-- December 22 2025 10:16  - Added a secret molecule reccomended by my sister and a few more radioactive shit. (December 2025 Build 0.1.15300)
-- December 22 2025 18:54  - Added deuterium compounds. (December 2025 Build 0.1.15326)
-- ----------------------- -
-- December 23 2025 16:29  - Added more chemicals ^_^ (December 2025 Build 0.1.15379)
-- December 23 2025 19:52  - Changed molecule colours to fit with CPK colors (December 2025 Build 0.1.15384)
-- ----------------------- - 
-- December 24 2025 13:58  - Added Positronium Hydrite as a funny (December 2025 Build 0.1.15403)
-- December 24 2025 18:41  - Added Dipositronium as another funny (December 2025 Build 0.1.15441)
-- December 24 2025 20:31  - Added a geiger-like click the more radioactive molecules are on screen (December 2025 Build 0.1.15450)
-- ----------------------- -
-- December 25 2025 17:09  - Revamped the positronium graphics (December 2025 Build 0.1.15476)
-- ----------------------- -
-- December 26 2025 12:21  - Added some cubanes (December 2025 Build 0.1.15500)
-- ----------------------- -
-- January 1 2026 00:00    - Added a ton of stuff, including but not limited to:
--                         -    • Astatine compounds
--                         -    • A programming language for it (RXN)
--                         -    • Fluoroantimonic acid
--                         -    • Changed buckminsterfullerene's resistance from 90% > 99%
--                         - (New Years 2026 Build 1.2.100)
-- January 1 2026 12:30    - Added radiation damage and fixed death mechanic (New Years 2026 Build 1.2.127)
-- ----------------------- -
-- January 2 2026 21:38    - Added population graph (New Years 2026 Build 1.2.154)
-- ----------------------- -
-- January 8 2026 13:24    - Fixed debug detection circles and nitroglycerin (New Years 2026 Build 1.2.168)
-- ----------------------- -
-- January 10 2026 17:39   - Added autoupdate (New Years 2026 Build 1.2.184)
-- January 10 2026 17:45   - Fixed crash because I incorrectly deleted MusicManager. (New Years 2026 Build 1.2.185)
-- January 10 2026 22:16   - Fixed boron compounds and autoupdate. (New Years 2026 Build 1.2.197)
-- ----------------------- -
-- January 11 2026 20:31   - Fixed spin. (New Years 2026 Build 1.2.200)
-- ----------------------- -
-- January 14 2026 20:26   - Added alkenes and alkynes. (New Years 2026 Build 1.2.216)
-- ----------------------- -
-- January 23 2026 23:10   - Revamped radioactive damage system. (New Years 2026 Build 1.2.247)
-- ----------------------- -
-- January 24 2026 15:25   - Revamped camera system. (New Years 2026 Build 1.2.256)
-- January 24 2026 15:25   - Added 8 new molecules. (New Years 2026 Build 1.2.301)
-- ----------------------- -
-- January 26 2026 20:11   - Added undecane-icosane and moved structures to libs/structures.lua. (New Years 2026 Build 1.2.326)
-- ----------------------- -
-- January 27 2026 15:00   - A small update even for being sick: added protonated methane. (New Years 2026 Build 1.2.333)
-- January 27 2026 21:17   - No longer sick - and added MORE carboxyl acids!!! (New Years 2026 Build 1.2.351)

local config = require("config")
local Console = require("libs/console")
local TimeSlider = require("libs/timeslider")
local structureData = require("libs/structures")

function love.mousereleased(x, y, button)
    TimeSlider.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    TimeSlider.mousemoved(x, y, dx, dy)
end

local hoveredMolecule = nil
local pilotedMolecule = nil
local maxHistoryLength = 300
local historyUpdateTimer = 0
local historyUpdateInterval = 0.1
local showGraph = true
local radiationGridSize = 300
local radiationGridDirty = true
local ELEMENT_COLORS = structureData.ELEMENT_COLORS
local structures = structureData.structures
local populationHistory = {}
local radiationGrid = {}
local molecules = {}
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
        basePitch = 440
    elseif moleculeType:match("iodo") or moleculeType == "carbon_tetraiodide" then
        basePitch = 110
    elseif moleculeType == "benzene" or moleculeType == "caffeine" then
        basePitch = 165
    elseif moleculeType:match("methane") then
        basePitch = 330
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
    H = {C = 1.5, O = 2.0, N = 1.3, H = 0.5, F = 1.0, Cl = 1.2, Br = 1.1, I = 1.0, At = 0.9},
	He = {C = 1.2, O = 1.2, N = 1.3, H = 3.0, F = 0.9, Cl = 0.7, Br = 0.9, I = 0.1},
    C = {C = 0.8, H = 1.5, O = 1.8, N = 1.2, F = 1.0, Cl = 1.0, Br = 0.9, I = 0.8, At = 0.7, S = 1.3},
    O = {C = 1.8, H = 2.0, O = 0.2, N = 1.0, F = 1.5},
    N = {C = 1.2, H = 1.3, O = 1.0, N = 0.3, F = 0.8},
    F = {C = 1.0, H = 1.0, F = 0.1, U = 1.5, O = 1.5, Cl = 1.3},
    Cl = {C = 1.0, H = 1.2, Cl = 0.2, F = 1.3, O = 1.2},
    Br = {C = 0.9, H = 1.1, Br = 0.2},
    I = {C = 0.8, H = 1.0, I = 0.1},
	At = {C = 0.7, H = 0.9, At = 0.1}
}

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
    {atoms = {"C", "C", "H"}, product = "ethynyl_radical", probability = 0.7},
	
	{atoms = {"Xe", "F", "F"}, product = "xenon_difluoride", probability = 0.3},
    {atoms = {"Xe", "F", "F", "F", "F"}, product = "xenon_tetrafluoride", probability = 0.15},
    {atoms = {"Kr", "F", "F"}, product = "krypton_difluoride", probability = 0.05},
	
	-- Astatine bonding 'cuz we needa be inclusive
	{atoms = {"At", "At"}, product = "astatine", probability = 0.8},
    {atoms = {"H", "At"}, product = "hydrogen_astatide", probability = 0.85},
    {atoms = {"C", "H", "H", "H", "At"}, product = "astatidomethane", probability = 0.65}
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
	
	undecane = {
        {type = "pentane", count = 1},
        {type = "hexane", count = 1}
    },
    dodecane = {
        {type = "hexane", count = 2}
    },
    tridecane = {
        {type = "hexane", count = 1},
        {type = "heptane", count = 1}
    },
    tetradecane = {
        {type = "heptane", count = 2}
    },
    pentadecane = {
        {type = "heptane", count = 1},
        {type = "octane", count = 1}
    },
    hexadecane = {
        {type = "octane", count = 2}
    },
    heptadecane = {
        {type = "octane", count = 1},
        {type = "nonane", count = 1}
    },
    octadecane = {
        {type = "nonane", count = 2}
    },
    nonadecane = {
        {type = "nonane", count = 1},
        {type = "decane", count = 1}
    },
    icosane = {
        {type = "decane", count = 2}
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
    xenon_difluoride = {
        {type = "xenon", count = 1},
        {type = "fluorine", count = 1}
    },
    
    xenon_tetrafluoride = {
        {type = "xenon", count = 1},
        {type = "fluorine", count = 2}
    },
    
    krypton_difluoride = {
        {type = "krypton", count = 1},
        {type = "fluorine", count = 1}
    },
	positronium_hydride = {
        {type = "hydrogen_atom", count = 1},
        -- The positronium annihilates into pure energy (gamma rays)
        -- We can't represent photons, so it just releases the hydrogen
    },
	dipositronium = {
        {type = "hydrogen_atom", count = 2},
        -- Pure energy release, so we only get a couple atoms back
	    -- (WHY IS ANTIMATTER SO DAMN CONFUSING!?!??!?)
    },
	
	cubane = {
        {type = "cyclobutane", count = 2},
        {type = "carbon_atom", count = 2},
        {type = "hydrogen_atom", count = 4}
    },
    octanitrocubane = {
        {type = "nitrogen", count = 8},
        {type = "co2", count = 8},
        {type = "carbon_atom", count = 4},
        {type = "oxygen_atom", count = 8}
    },
    hexanitrocubane = {
        {type = "nitrogen", count = 6},
        {type = "co2", count = 6},
        {type = "cubane", count = 0.5},
        {type = "oxygen_atom", count = 6}
    },
    fluorocubane = {
        {type = "cubane", count = 0.5},
        {type = "fluorine_atom", count = 1},
        {type = "carbon_atom", count = 2}
    },
    octafluorocubane = {
        {type = "fluorocubane", count = 1},
        {type = "fluorine_atom", count = 4},
        {type = "carbon_atom", count = 2}
    },
	
	    hydrogen_sulfide = {
        {type = "sulfur_atom", count = 1},
        {type = "hydrogen_atom", count = 2}
    },
    sulfur_trioxide = {
        {type = "sulfur_dioxide", count = 1},
        {type = "oxygen_atom", count = 1}
    },
    phosphoric_acid = {
        {type = "phosphorus_atom", count = 1},
        {type = "oxygen_atom", count = 4},
        {type = "hydrogen_atom", count = 3}
    },
    sodium_chloride = {
        {type = "sodium_atom", count = 1},
        {type = "chlorine_atom", count = 1}
    },
    potassium_permanganate = {
        {type = "potassium_atom", count = 1},
        {type = "oxygen", count = 2},
        {type = "oxygen_atom", count = 1}
    },
    chlorine_trifluoride = {
        {type = "chlorine_atom", count = 1},
        {type = "fluorine_atom", count = 3}
    },
    white_phosphorus = {
        {type = "phosphorus_atom", count = 4}
    },
    red_phosphorus = {
        {type = "phosphorus_atom", count = 4}
    },
	
	astatine = {
        {type = "astatine_atom", count = 2}
    },
    
    astatidomethane = {
        {type = "methane", count = 1},
        {type = "astatine_atom", count = 1}
    },
    
    diastatidomethane = {
        {type = "methane", count = 1},
        {type = "astatine_atom", count = 2}
    },
    
    triastatidomethane = {
        {type = "methane", count = 1},
        {type = "astatine_atom", count = 3}
    },
    
    carbon_tetrastatide = {
        {type = "carbon_atom", count = 1},
        {type = "astatine_atom", count = 4}
    },
    
    hydrogen_astatide = {
        {type = "hydrogen_atom", count = 1},
        {type = "astatine_atom", count = 1}
    },
	
	glycine = {
        {type = "nitrogen_atom", count = 1},
        {type = "carbon_atom", count = 2},
        {type = "oxygen_atom", count = 2},
        {type = "hydrogen_atom", count = 5}
    },
    alanine = {
        {type = "nitrogen_atom", count = 1},
        {type = "carbon_atom", count = 3},
        {type = "oxygen_atom", count = 2},
        {type = "hydrogen_atom", count = 7}
    },
	
	diborane = {
        {type = "tetrahydrodiborane", count = 1},
        {type = "hydrogen", count = 1}
    },
    
    tetrahydrodiborane = {
        {type = "dihydrodiborane", count = 1},
        {type = "hydrogen", count = 1}
    },
    
    dihydrodiborane = {
        {type = "boron_atom", count = 2},
        {type = "hydrogen_atom", count = 2}
    },
    
    boron_trifluoride = {
        {type = "boron_atom", count = 1},
        {type = "fluorine_atom", count = 3}
    },
    
    boron_trichloride = {
        {type = "boron_atom", count = 1},
        {type = "chlorine_atom", count = 3}
    },
    
    borax = {
        {type = "sodium_atom", count = 2},
        {type = "boron_atom", count = 2},
        {type = "oxygen_atom", count = 5},
        {type = "water", count = 5}
    },
    
    boric_acid = {
        {type = "boron_atom", count = 1},
        {type = "oxygen_atom", count = 3},
        {type = "hydrogen_atom", count = 3}
    },
	
	neptunium_trioxide = {
        {type = "neptunium_atom", count = 1},
        {type = "oxygen_atom", count = 3}
    },
    	propylene = {
        {type = "ethylene", count = 0.5},
        {type = "methane", count = 0.5},
        {type = "carbon_atom", count = 1}
    },
    
    butene = {
        {type = "ethylene", count = 2}
    },
    
    acetylene = {
        {type = "carbon_atom", count = 2},
        {type = "hydrogen_atom", count = 2}
    },
    
    propyne = {
        {type = "acetylene", count = 0.5},
        {type = "methane", count = 0.5},
        {type = "carbon_atom", count = 1}
    },
    
    butyne = {
        {type = "acetylene", count = 1},
        {type = "ethylene", count = 1}
    },
	
	nitrogen_triiodide = {
        {type = "nitrogen_atom", count = 1},
        {type = "iodine_atom", count = 3}
    },
    
    dioxygen_difluoride = {
        {type = "oxygen", count = 1},
        {type = "fluorine", count = 1}
    },
    
    chlorine_pentafluoride = {
        {type = "chlorine_atom", count = 1},
        {type = "fluorine_atom", count = 5}
    },
    
    hydrazine = {
        {type = "nitrogen", count = 1},
        {type = "hydrogen", count = 2}
    },
    
    dimethylmercury = {
        {type = "methane", count = 2},
        {type = "hydrogen_atom", count = 2}
    },
    
    chlorine_dioxide = {
        {type = "chlorine_atom", count = 1},
        {type = "oxygen_atom", count = 2}
    },
    
    sulfur_mustard = {
        {type = "sulfur_atom", count = 1},
        {type = "chlorine", count = 1},
        {type = "ethylene", count = 1}
    },
    
    ammonium_nitrate = {
        {type = "nitrogen", count = 2},
        {type = "water", count = 2},
        {type = "oxygen", count = 0.5}
    },
	protonated_methane = {
        {type = "methane", count = 1},
        {type = "hydrogen_atom", count = 1}
    },
	formic_acid = {
        {type = "co2", count = 1},
        {type = "hydrogen_atom", count = 2}
    },
    
    acetic_acid = {
        {type = "co2", count = 1},
        {type = "methane", count = 0.5},
        {type = "water", count = 0.5}
    },
    
    propionic_acid = {
        {type = "co2", count = 1},
        {type = "ethylene", count = 0.5},
        {type = "water", count = 0.5}
    },
    
    butyric_acid = {
        {type = "co2", count = 1},
        {type = "propane", count = 0.5},
        {type = "water", count = 0.5}
    },
    
    valeric_acid = {
        {type = "co2", count = 1},
        {type = "butane", count = 0.5},
        {type = "water", count = 0.5}
    },
    
    caproic_acid = {
        {type = "co2", count = 1},
        {type = "pentane", count = 0.5},
        {type = "water", count = 0.5}
    },
}

local spawnFragments
local Molecule = {}
Molecule.__index = Molecule

function Molecule:new(type, x, y)
    local molConfig = config.molecules[type]
	
	if not molConfig then
        print("Warning: Tried to create unknown molecule type: " .. tostring(type))
        return nil
    end
	
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
    local molConfig = config.molecules[self.type]
    if not self.alive then
        return
    end
    
    if pilotedMolecule == self then
        self.rotation = self.rotation + self.rotationSpeed * dt
        self.x = self.x + self.vx * dt
        self.y = self.y + self.vy * dt
        
        if self.x < 0 then self.x = WORLD_WIDTH end
        if self.x > WORLD_WIDTH then self.x = 0 end
        if self.y < 0 then self.y = WORLD_HEIGHT end
        if self.y > WORLD_HEIGHT then self.y = 0 end
        
        return
    end
    	
    local radiationDamage = 0
    local radiationRange = 200
    
    local gridX = math.floor(self.x / radiationGridSize)
    local gridY = math.floor(self.y / radiationGridSize)

    for dx = -1, 1 do
        for dy = -1, 1 do
            local key = (gridX + dx) .. "," .. (gridY + dy)
            local sources = radiationGrid[key]
            
            if sources then
                for _, source in ipairs(sources) do
                    local dx = source.x - self.x
                    local dy = source.y - self.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    
                    if dist < radiationRange then
                        local intensity = 1 - (dist / radiationRange)
                        local damage = 5 * intensity * source.intensity * dt
                        radiationDamage = radiationDamage + damage
                    end
                end
            end
        end
    end
    
    if radiationDamage > 0 then
        if self.type == "fluoroantimonic_acid" then
            self.health = self.health - radiationDamage * 5
        elseif not (self.type:match("atom") or config.molecules[self.type].radioactive) then
            self.health = self.health - radiationDamage * 0.5
        end
    end

    if self.type == "positronium_hydride" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 0.5 then
            self.health = 0
            self.alive = false
        end
    end

    if self.type == "carbon_tetraiodide" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 5 then
            self.health = self.health - 20 * dt
        end
        if self.health <= 0 then
            self.alive = false
        end
    end
	
	if self.type == "carbon_tetrastatide" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 3 then
            self.health = self.health - 25 * dt
        end
        if self.health <= 0 then
            self.alive = false
        end
    end
    
    if self.type == "triastatidomethane" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 10 then
            self.health = self.health - 8 * dt
        end
        if self.health <= 0 then
            self.alive = false
        end
    end
	
    if self.type == "cubane" or self.type == "fluorocubane" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 10 then
            self.health = self.health - 5 * dt
        end
    end
    
    if self.type == "octanitrocubane" or self.type == "hexanitrocubane" then
        self.unstableTimer = self.unstableTimer + dt
        local speed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
        if speed > 15 then
            self.health = self.health - speed * 2 * dt
        end
        if self.unstableTimer > 8 then
            self.health = self.health - 10 * dt
        end
    end

    if self.type == "triiodomethane" then
        self.unstableTimer = self.unstableTimer + dt
        if self.unstableTimer > 15 then
            self.health = self.health - 5 * dt
        end
        if self.health <= 0 then
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
        self.rotation = self.rotation + self.rotationSpeed * dt
	elseif self.type == "diborane" or self.type == "tetrahydrodiborane" or 
           self.type == "dihydrodiborane" then
        local preyTypes = {"oxygen", "ozone", "water"}
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.3
        
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
            self.rotationSpeed = 4
            
            if dist < self.radius + closest.radius then
                self.health = 0
                closest.health = closest.health - 80 * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * 1.2)
            self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * 1.2)
            self.rotationSpeed = 2
        end
    elseif self.type == "boron_trifluoride" or self.type == "boron_trichloride" then
        local preyTypes = {"ammonia", "water", "hydroxide", "ethanol", "acetone"}
        
        if self.type == "boron_trichloride" then
            preyTypes = {"water", "ammonia", "hydroxide", "ethanol"}
        end
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.2
        
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
            
            local damage = self.type == "boron_trichloride" and 60 or 45
            if dist < self.radius + closest.radius then
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.06
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.4
        end
    
    elseif self.type == "borax" or self.type == "boric_acid" then
        local speedMult = molConfig.speedMultiplier or 1
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
        self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * speedMult)
        self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * speedMult)
        self.rotationSpeed = 0.3
    elseif self.type:match("methane") and self.type ~= "methane" then
        local threats = {"oxygen", "ozone", "chlorine", "fluorine", "hydrogen_peroxide"}
        
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
	elseif self.type == "nitroglycerin" then
        local speed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
        
        if speed > 50 then
            self.unstableTimer = self.unstableTimer + dt * (speed / 50)
            self.health = self.health - (speed * 0.1 * dt)
        end
        
        local targets = {}
        for _, mol in ipairs(molecules) do
            if mol ~= self and mol.alive then
                local dx = mol.x - self.x
                local dy = mol.y - self.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < DETECTION_RANGE * 1.2 then
                    table.insert(targets, {mol = mol, dist = dist})
                end
            end
        end
        
        if #targets > 0 then
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.3
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 0.6
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 0.6
            self.rotationSpeed = 4
            
            for _, target in ipairs(targets) do
                if target.dist < self.radius + target.mol.radius then
                    if speed > 100 or math.random() < 0.1 then
                        self.health = 0
                        self.alive = false
                        break
                    end
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 0.6
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 0.6
            self.rotationSpeed = 1
        end
    elseif self.type == "oxygen" or self.type == "ozone" or self.type == "chlorine" or 
           self.type == "fluorine" or self.type == "hydrogen_peroxide" or
           self.type == "sulfuric_acid" or self.type == "hydrochloric_acid" or
           self.type == "hydronium" or self.type == "formaldehyde" or
           self.type == "hypobromous_acid" or self.type == "ethynyl_radical" or
           self.type == "trihydrogen_cation" or self.type == "formyl_cation" then
        local preyTypes = {"methane", "ethylene", "propylene", "butene", 
                           "acetylene", "propyne", "butyne",
                           "propane", "cyclopropane", "acetylcarnitine",  
                           "ethanol", "benzene", "ammonia", "caffeine", "tnt", "acetone",
                           "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene",
                           "helium_dimer", "helium_trimer", "tetrafluoroethylene", 
                           "fluoromethane", "difluoromethane", "trifluoromethane",
                           "chloromethane", "dichloromethane", "chloroform", "carbon_tetrachloride",
                           "bromomethane", "dibromomethane", "tribromomethane", "carbon_tetrabromide",
                           "iodomethane", "diiodomethane", "triiodomethane",
                           "butane", "pentane", "hexane", "heptane", "octane", "nonane", "decane",
                           "astatidomethane", "diastatidomethane", "triastatidomethane", "carbon_tetrastatide",
                           "glycine", "alanine", "diborane", "tetrahydrodiborane", "dihydrodiborane",
						   "undecane", "dodecane", "tridecane", "tetradecane", "pentadecane",
                           "hexadecane", "heptadecane", "octadecane", "nonadecane", "icosane"}

        if molConfig.prefersEthylene then
            preyTypes = {"ethylene", "tetrafluoroethylene", "cyclopropane", "benzene", "tnt", 
                        "acetylcarnitine", "methane", "propane", "glycine", "alanine"}
        elseif self.type == "fluorine" then
            preyTypes = {"methane", "ethylene", "propane", "cyclopropane", "acetylcarnitine",
                        "ethanol", "benzene", "ammonia", "water", "caffeine", "tnt", "acetone",
                        "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene",
                        "helium_dimer", "helium_trimer", "helium", "chloromethane", "dichloromethane", "chloroform",
                        "carbon_tetrachloride", "bromomethane", "dibromomethane", "tribromomethane",
                        "carbon_tetrabromide", "iodomethane", "diiodomethane", "triiodomethane",
                        "carbon_tetraiodide", "helium_hydride", "glycine", "alanine",
						"undecane", "dodecane", "tridecane", "tetradecane", "pentadecane",
                        "hexadecane", "heptadecane", "octadecane", "nonadecane", "icosane"}
        elseif self.type == "perchloric_acid" then
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
                    damageMultiplier = 0.01
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
    elseif self.type == "xenon" or self.type == "krypton" or 
           self.type == "neon" or self.type == "argon" then
        local nearestFluorine = nil
        local nearestDist = DETECTION_RANGE
        
        for _, mol in ipairs(molecules) do
            if (mol.type == "fluorine" or mol.type == "fluorine_atom") and mol.alive then
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
            local speedMult = molConfig.speedMultiplier or 1
            local speed = FLEE_SPEED * speedMult
            
            if self.type == "neon" or self.type == "argon" then
                speed = speed * 1.3
            end
            
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 6
        else
            local speedMult = molConfig.speedMultiplier or 1
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.06
            self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * speedMult)
            self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * speedMult)
            
            if self.type == "neon" then
                self.rotationSpeed = 3
            elseif self.type == "argon" or self.type == "krypton" then
                self.rotationSpeed = 2
            else
                self.rotationSpeed = 1.5
            end
        end
    elseif self.type == "hydrogen_sulfide" or self.type == "sulfur_trioxide" or
           self.type == "phosphoric_acid" or self.type == "potassium_permanganate" or
           self.type == "chlorine_trifluoride" or self.type == "white_phosphorus" then
        
        local preyTypes = {"methane", "ethylene", "propane", "ethanol", "ammonia"}
        
        if self.type == "chlorine_trifluoride" then
            preyTypes = {"methane", "ethylene", "propane", "water", "co2", "ammonia",
                        "benzene", "ethanol", "sodium_chloride", "helium"}
        elseif self.type == "white_phosphorus" then
            preyTypes = {"oxygen", "ozone", "water", "fluoroantimonic_acid"}
        elseif self.type == "sulfur_trioxide" then
            preyTypes = {"water", "ammonia", "ethanol"}
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
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.4
        end
	elseif self.type == "fluoroantimonic_acid" then
        local preyTypes = {}
        for molType, _ in pairs(config.molecules) do
            if molType ~= "fluoroantimonic_acid" then
                table.insert(preyTypes, molType)
            end
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
                closest.health = closest.health - damage * dt
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
    elseif self.type == "xenon_difluoride" or self.type == "xenon_tetrafluoride" or
           self.type == "krypton_difluoride" then
        
        if self.type == "krypton_difluoride" then
            self.unstableTimer = (self.unstableTimer or 0) + dt
            if self.unstableTimer > 8 then
                self.health = self.health - 15 * dt
            end
            if self.health <= 0 then
                self.alive = false
            end
        end
        
        local preyTypes = {"methane", "ethylene", "propane", "ethanol", "ammonia",
                          "benzene", "caffeine", "acetone", "water",
                          "fluoromethane", "chloromethane", "bromomethane",
                          "cyclopropane", "cyclobutane", "cyclopentane"}
        
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
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.4
        end
    elseif self.type == "propane" or self.type == "cyclopropane" or 
           self.type == "ethylene" or self.type == "propylene" or self.type == "butene" or
           self.type == "acetylene" or self.type == "propyne" or self.type == "butyne" or self.type == "cyclopropenylidene" or
           self.type == "cyclobutane" or self.type == "cyclobutene" or self.type == "cyclopentane" or
           self.type == "benzene" or self.type == "ethylene" or self.type == "ethanol" or
           self.type == "ammonia" or self.type == "caffeine" or self.type == "tnt" or
           self.type == "acetone" or self.type == "acetylcarnitine" or self.type == "helium_dimer" or
           self.type == "tetrafluoroethylene" or self.type == "tricarbon" or self.type == "helium_trimer" or
           self.type == "cyanoacetylene" or self.type == "acetonitrile" then
        local threats = {"oxygen", "ozone", "chlorine", "fluorine", "hydrogen_peroxide", 
                        "sulfuric_acid", "hydrochloric_acid", "perchloric_acid", "formaldehyde",
                        "hypobromous_acid", "trihydrogen_cation", "formyl_cation", "ethynyl_radical",
						"fluoroantimonic_acid"}
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
	elseif self.type == "nitrogen_triiodide" then
        for _, mol in ipairs(molecules) do
            if mol ~= self and mol.alive then
                local dx = self.x - mol.x
                local dy = self.y - mol.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < self.radius + mol.radius + 5 then
                    self.health = 0
                    self.alive = false
                    break
                end
            end
        end
    elseif self.type == "ammonium_nitrate" then
        local explosiveTypes = {"tnt", "nitroglycerin", "nitrogen_triiodide", 
                                "azidoazide_azide", "carbon_tetraiodide"}
        for _, mol in ipairs(molecules) do
            if mol.alive then
                for _, expType in ipairs(explosiveTypes) do
                    if mol.type == expType then
                        local dx = self.x - mol.x
                        local dy = self.y - mol.y
                        local dist = math.sqrt(dx * dx + dy * dy)
                        if dist < 100 then
                            self.health = self.health - 50 * dt
                            if self.health <= 0 then
                                self.alive = false
                            end
                        end
                    end
                end
            end
        end
    elseif self.type == "nitrogen_triiodide" then
        self.unstableTimer = self.unstableTimer + dt
		
        if self.unstableTimer > 3 then
            self.health = self.health - 30 * dt
        end
        
        for _, mol in ipairs(molecules) do
            if mol ~= self and mol.alive then
                local dx = self.x - mol.x
                local dy = self.y - mol.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < self.radius + mol.radius + 10 then
                    self.health = 0
                    self.alive = false
                    mol.health = mol.health - 100
                    if mol.health <= 0 then
                        mol.alive = false
                    end
                    break
                end
            end
        end
        
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.15
        self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.rotationSpeed = 8
    elseif self.type == "dioxygen_difluoride" then
        local preyTypes = {}
        for molType, _ in pairs(config.molecules) do
            if molType ~= "dioxygen_difluoride" then
                table.insert(preyTypes, molType)
            end
        end
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 2.8
        
        for _, mol in ipairs(molecules) do
            if mol.type ~= "dioxygen_difluoride" and mol.alive then
                local dx = mol.x - self.x
                local dy = mol.y - self.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < closestDist then
                    closest = mol
                    closestDist = dist
                end
            end
        end
        
        if closest then
            local dx = closest.x - self.x
            local dy = closest.y - self.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local speed = HUNT_SPEED * 1.5
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 3
            
            if dist < self.radius + closest.radius then
                closest.health = closest.health - 200 * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.12
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.5
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.5
            self.rotationSpeed = 0.5
        end
    elseif self.type == "chlorine_pentafluoride" then
        local preyTypes = {"methane", "ethylene", "propane", "water", "co2", "ammonia",
                           "benzene", "ethanol", "sodium_chloride", "helium", "nitrogen",
                           "cyclopropane", "caffeine", "tnt", "acetone", "ice", "sand",
                           "concrete", "your_hopes_and_dreams"}
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 2.2
        
        for _, mol in ipairs(molecules) do
            if mol.type ~= "chlorine_pentafluoride" and mol.alive then
                local dx = mol.x - self.x
                local dy = mol.y - self.y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < closestDist then
                    closest = mol
                    closestDist = dist
                end
            end
        end
        
        if closest then
            local dx = closest.x - self.x
            local dy = closest.y - self.y
            local dist = math.sqrt(dx * dx + dy * dy)
            local speed = HUNT_SPEED * 1.3
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 2.5
            
            if dist < self.radius + closest.radius then
                closest.health = closest.health - 170 * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.1
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.3
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.3
            self.rotationSpeed = 0.4
        end
    elseif self.type == "hydrazine" then
        local preyTypes = {"oxygen", "ozone", "hydrogen_peroxide", "nitric_acid",
                           "nitrogen_tetroxide", "fluorine", "chlorine"}
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.2
        
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
            local speed = HUNT_SPEED * 0.95
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 2
            
            if dist < self.radius + closest.radius then
                self.health = 0
                closest.health = 0
                self.alive = false
                closest.alive = false
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.06
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 0.95
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 0.95
            self.rotationSpeed = 0.3
        end
    elseif self.type == "dimethylmercury" then
        local preyTypes = {"methane", "ethylene", "propane", "water", "ammonia",
                           "ethanol", "benzene", "caffeine", "acetone", "cyclopropane"}
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.4
        
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
            local speed = HUNT_SPEED * 1.1
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 1.5
            
            if dist < self.radius + closest.radius then
                closest.health = closest.health - 120 * dt
                if closest.type == "buckminsterfullerene" then
                    closest.health = closest.health - 50 * dt
                end
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.1
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.1
            self.rotationSpeed = 0.4
        end
    elseif self.type == "chlorine_dioxide" then
        self.unstableTimer = self.unstableTimer + dt
        
        if self.unstableTimer > 8 then
            self.health = self.health - 15 * dt
        end
        
        local preyTypes = {"methane", "ethylene", "propane", "ammonia", "ethanol",
                           "benzene", "cyclopropane", "acetone"}
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.3
        
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
            local speed = HUNT_SPEED * 1.25
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 2
            
            if dist < self.radius + closest.radius then
                closest.health = closest.health - 85 * dt
                if math.random() < 0.05 * dt then
                    self.health = 0
                    self.alive = false
                end
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.09
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.25
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.25
            self.rotationSpeed = 0.5
        end
    elseif self.type == "sulfur_mustard" then
        local preyTypes = {"methane", "ethylene", "water", "ammonia", "ethanol",
                           "benzene", "caffeine", "acetone", "propane", "cyclopropane",
                           "hydrogen_atom", "carbon_atom", "oxygen_atom", "nitrogen_atom"}
        
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.5
        
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
            local speed = HUNT_SPEED * 0.8
            self.vx = (dx / dist) * speed
            self.vy = (dy / dist) * speed
            self.rotationSpeed = 1
            
            for _, mol in ipairs(molecules) do
                if mol ~= self and mol.alive then
                    local mdx = mol.x - self.x
                    local mdy = mol.y - self.y
                    local mdist = math.sqrt(mdx * mdx + mdy * mdy)
                    if mdist < 80 then
                        mol.health = mol.health - 30 * dt * (1 - mdist / 80)
                        if mol.health <= 0 then
                            mol.alive = false
                        end
                    end
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 0.8
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 0.8
            self.rotationSpeed = 0.2
        end
    elseif self.type == "ammonium_nitrate" then
        local explosiveTypes = {"tnt", "nitroglycerin", "nitrogen_triiodide", 
                                "azidoazide_azide", "carbon_tetraiodide",
                                "octanitrocubane", "hexanitrocubane"}
        local triggered = false
        for _, mol in ipairs(molecules) do
            if mol.alive then
                for _, expType in ipairs(explosiveTypes) do
                    if mol.type == expType then
                        local dx = self.x - mol.x
                        local dy = self.y - mol.y
                        local dist = math.sqrt(dx * dx + dy * dy)
                        if dist < 120 then
                            self.health = self.health - 40 * dt
                            triggered = true
                            self.rotationSpeed = 5
                            break
                        end
                    end
                end
                if triggered then break end
            end
        end
        
        if not triggered then
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.04
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 0.7
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 0.7
            self.rotationSpeed = 0.2
    	end
	elseif self.type == "protonated_methane" then
        local preyTypes = {"hydroxide", "ammonia", "water", "methane", "ethylene",
                           "nitrogen_atom", "oxygen_atom", "fluorine_atom"}
        
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
            self.rotationSpeed = 6  -- Spins fast!
            
            local damage = molConfig.damage or 50
            if dist < self.radius + closest.radius then
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.12
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED * 1.3
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED * 1.3
            self.rotationSpeed = 3
        end
	elseif self.type:match("ic_acid$") then
        local preyTypes = {"ammonia", "hydroxide", "sodium_hydroxide", "lithium_hydroxide",
                           "methane", "ethylene", "propane", "ethanol", "benzene"}
        
        local detectionMult = molConfig.detectionMultiplier or 1.0
        if self.type == "formic_acid" then
            detectionMult = 1.1
        elseif self.type == "acetic_acid" then
            detectionMult = 1.05
        end
        
        local closest = nil
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
            self.rotationSpeed = 1.5
            
            local damage = molConfig.damage or 45
            if dist < self.radius + closest.radius then
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.06
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.4
        end
    elseif self.type == "buckminsterfullerene" then
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.02
        self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * 0.4)
        self.rotationSpeed = 0.1
    else
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
        self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
        self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
        self.rotationSpeed = 0.5
    end

    self.rotation = self.rotation + self.rotationSpeed * dt
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
	
	if radiationDamage and radiationDamage > 0 then
        local pulse = (math.sin(love.timer.getTime() * 8) + 1) * 0.5
        love.graphics.setColor(0, 1, 0, 0.2 + pulse * 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius + 8)
    end
	
	if self.type == "protonated_methane" and struct.fluxional then
        local time = love.timer.getTime() * 8 + (self.x + self.y) * 0.01
        
        for i = 2, 6 do
            local baseAngle = ((i - 2) / 5) * math.pi * 2
            local wobble = math.sin(time * (i * 0.7)) * 0.3
            local angle = baseAngle + wobble
            local distance = 15 + math.sin(time * i * 1.3) * 2
            
            struct.atoms[i].x = math.cos(angle) * distance
            struct.atoms[i].y = math.sin(angle) * distance
        end
    end
	
	if self.type == "sulfur_mustard" then
        local pulse = (math.sin(love.timer.getTime() * 1) + 1) * 0.5
        love.graphics.setColor(0.6, 0.7, 0.2, 0.2 + pulse * 0.15)
        love.graphics.circle("fill", self.x, self.y, self.radius + 25)
        love.graphics.setColor(0.5, 0.6, 0.1, 0.1)
        love.graphics.circle("fill", self.x, self.y, 80)
    end
	
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
	
	if self.type == "chlorine_trifluoride" then
        local pulse = (math.sin(love.timer.getTime() * 4) + 1) * 0.5
        love.graphics.setColor(1, 0.5, 0, 0.2 + pulse * 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 12)
        for i = 1, 3 do
            love.graphics.setColor(1, 0.3, 0, 0.3)
            love.graphics.circle("line", self.x, self.y, self.radius + i * 7)
        end
    end
    
    if self.type == "white_phosphorus" then
        local pulse = (math.sin(love.timer.getTime() * 3) + 1) * 0.5
        love.graphics.setColor(1, 1, 0.5, 0.15 + pulse * 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius + 8)
    end
    
    if self.type == "potassium_permanganate" then
        love.graphics.setColor(0.6, 0, 0.6, 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius + 5)
    end
	
	if self.type == "xenon" or self.type == "krypton" or 
       self.type == "neon" or self.type == "argon" then
        local pulse = (math.sin(love.timer.getTime() * 1.5) + 1) * 0.5
        
        if self.type == "xenon" then
            love.graphics.setColor(0.4, 0.6, 0.9, 0.15 + pulse * 0.1)
        elseif self.type == "krypton" then
            love.graphics.setColor(0.7, 0.8, 0.9, 0.12 + pulse * 0.08)
        elseif self.type == "neon" then
            love.graphics.setColor(0.9, 0.4, 0.3, 0.2 + pulse * 0.15)
        elseif self.type == "argon" then
            love.graphics.setColor(0.6, 0.7, 0.9, 0.1 + pulse * 0.08)
        end
        
        love.graphics.circle("fill", self.x, self.y, self.radius + 4)
    end
    

    if self.type == "xenon_difluoride" or self.type == "xenon_tetrafluoride" or
       self.type == "krypton_difluoride" then
        local pulse = (math.sin(love.timer.getTime() * 2.5) + 1) * 0.5
        
        love.graphics.setColor(0.8, 0.4, 0.9, 0.15 + pulse * 0.2)
        love.graphics.circle("fill", self.x, self.y, self.radius + 8)
        
        for i = 1, 2 do
            love.graphics.setColor(0.7, 0.5, 0.9, 0.2)
            love.graphics.circle("line", self.x, self.y, self.radius + i * 6)
        end
    end
    
    if self.type == "krypton_difluoride" and (self.unstableTimer or 0) > 8 then
        local pulse = (math.sin(love.timer.getTime() * 4) + 1) * 0.5
        love.graphics.setColor(0.9, 0.3, 0.9, 0.2 + pulse * 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 6)
    end
	
	if self.type == "azidoazide_azide" then
        local pulse = (math.sin(love.timer.getTime() * 10) + 1) * 0.5
        love.graphics.setColor(1, 0, 0, 0.3 + pulse * 0.4)
        love.graphics.circle("fill", self.x, self.y, self.radius + 15)
        for i = 1, 5 do
            love.graphics.setColor(1, 0.2, 0, 0.4)
            love.graphics.circle("line", self.x, self.y, self.radius + i * 10)
        end
    end
	
	if self.type == "octanitrocubane" or self.type == "hexanitrocubane" then
        local pulse = (math.sin(love.timer.getTime() * 8) + 1) * 0.5
        local speed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
        local speedFactor = math.min(speed / 30, 1)
        
        love.graphics.setColor(1, 0.2, 0, 0.2 + pulse * 0.3 + speedFactor * 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 12)
        
        for i = 1, 4 do
            love.graphics.setColor(1, 0.5, 0, 0.3)
            love.graphics.circle("line", self.x, self.y, self.radius + i * 8)
        end
    end
    
    if self.type:match("cubane") then
        local pulse = (math.sin(love.timer.getTime() * 4) + 1) * 0.5
        love.graphics.setColor(0.8, 0.2, 0.8, 0.1 + pulse * 0.15)
        love.graphics.circle("fill", self.x, self.y, self.radius + 6)
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

	
	-- Positronium is VERY FUCKING unstable
    if self.type == "positronium_hydride" or self.type == "dipositronium" then
        local molConfig = config.molecules[self.type]
        local grbIntensity = molConfig.grb or 8
        local pulse = (math.sin(love.timer.getTime() * 15) + 1) * 0.5
        local decayProgress = self.unstableTimer / 0.5
        
        for i = 1, 6 do
            local ringRadius = self.radius + (i * 10) + (decayProgress * i * 15)
            local alpha = (0.4 - i * 0.05) * (1 + pulse * 0.3)
            love.graphics.setColor(1, 0.2, 1, alpha)
            love.graphics.setLineWidth(2 + decayProgress * 2)
            love.graphics.circle("line", self.x, self.y, ringRadius)
        end
        
        local glowIntensity = 0.3 + (grbIntensity / 10) * 0.4 + decayProgress * 0.4
        love.graphics.setColor(1, 0.2, 1, glowIntensity)
        love.graphics.circle("fill", self.x, self.y, self.radius + 15)
        
        if decayProgress > 0.3 then
            local rayCount = math.floor(4 + grbIntensity + decayProgress * 8)
            for i = 1, rayCount do
                local angle = (i / rayCount) * math.pi * 2 + love.timer.getTime() * 5 + math.random() * 0.5
                local length = (10 + grbIntensity * 2) + pulse * (5 + grbIntensity) + decayProgress * 20
                love.graphics.setColor(1, 1, 1, 0.4 + (grbIntensity / 10) * 0.3 + pulse * 0.4)
                love.graphics.line(
                    self.x, self.y,
                    self.x + math.cos(angle) * length,
                    self.y + math.sin(angle) * length
                )
            end
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
	
	if pilotedMolecule == self then
        love.graphics.setColor(0, 1, 1, 0.4)
        love.graphics.circle("fill", self.x, self.y, self.radius + 15)
        local arrowDist = self.radius + 25
        love.graphics.setLineWidth(2)
        love.graphics.setColor(0, 1, 1, 0.6)
        love.graphics.line(self.x, self.y - arrowDist, self.x, self.y - arrowDist - 10)
        love.graphics.line(self.x, self.y + arrowDist, self.x, self.y + arrowDist + 10)
        love.graphics.line(self.x - arrowDist, self.y, self.x - arrowDist - 10, self.y)
        love.graphics.line(self.x + arrowDist, self.y, self.x + arrowDist + 10, self.y)
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
		elseif bond.triple then
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.line(atom1.x, atom1.y - 3, atom2.x, atom2.y - 3)
            love.graphics.line(atom1.x, atom1.y, atom2.x, atom2.y)
            love.graphics.line(atom1.x, atom1.y + 3, atom2.x, atom2.y + 3)
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
        local molConfig = config.molecules[self.type]
        local detectionMult = molConfig.detectionMultiplier or 1
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.circle("line", self.x, self.y, DETECTION_RANGE * detectionMult)
        
        if detectionMult ~= 1 then
            love.graphics.setColor(1, 1, 0, 0.5)
            love.graphics.print(string.format("×%.1f", detectionMult), self.x + 5, self.y - 20)
        end
        
        if molConfig.radioactive then
            local radiationRange = 200
            
            for i = 1, 5 do
                local radius = radiationRange * (i / 5)
                local alpha = 0.05 * (6 - i)
                love.graphics.setColor(0, 1, 0, alpha)
                love.graphics.setLineWidth(1)
                love.graphics.circle("line", self.x, self.y, radius)
            end
            
            if molConfig.extremely_radioactive then
                love.graphics.setColor(1, 0, 0, 0.8)
                love.graphics.print("Radioactive", self.x + 5, self.y + 10)
            else
                love.graphics.setColor(0, 1, 0, 0.8)
                love.graphics.print("Radioactive", self.x + 5, self.y + 10)
            end
        end
    end

    if self.element then
        love.graphics.setColor(0, 1, 0, 0.1)
        love.graphics.circle("line", self.x, self.y, BONDING_DISTANCE)
    end
end

function love.load()
    love.window.setTitle(config.game.title)
    love.window.setMode(config.game.window.width, config.game.window.height)
    
    -- Spawn initial molecules
    for molType, count in pairs(config.initialSpawns) do
        for i = 1, count do
            table.insert(molecules, Molecule:new(molType, 
                math.random(100, WORLD_WIDTH - 100), 
                math.random(100, WORLD_HEIGHT - 100)))
        end
    end
	

    camera.x = WORLD_WIDTH / 2 - love.graphics.getWidth() / 2
    camera.y = WORLD_HEIGHT / 2 - love.graphics.getHeight() / 2
    
    if love.filesystem.getInfo("autoexec.rxn") then
        print("Found AUTOEXEC.RXN, executing...")
        local Console = require("libs/console")
        local context = {
            molecules = molecules,
            camera = camera,
            config = config,
            Molecule = Molecule
        }
        Console.executeRXN("autoexec.rxn", context)
    end
end

function buildRadiationGrid()
    radiationGrid = {}
    for _, mol in ipairs(molecules) do
        if mol.alive then
            local molConfig = config.molecules[mol.type]
            if molConfig and molConfig.radioactive then
                local gridX = math.floor(mol.x / radiationGridSize)
                local gridY = math.floor(mol.y / radiationGridSize)
                local key = gridX .. "," .. gridY
                
                if not radiationGrid[key] then
                    radiationGrid[key] = {}
                end
                
                table.insert(radiationGrid[key], {
                    x = mol.x,
                    y = mol.y,
                    intensity = molConfig.extremely_radioactive and 3 or 1
                })
            end
        end
    end
    radiationGridDirty = false
end

function love.update(dt)
    dt = dt * TimeSlider.scale
	buildRadiationGrid()
    
    historyUpdateTimer = historyUpdateTimer + dt
	
    historyUpdateTimer = historyUpdateTimer + dt
    if historyUpdateTimer >= historyUpdateInterval then
        historyUpdateTimer = 0
        
        local counts = {}
        for _, mol in ipairs(molecules) do
            if mol.alive then
                counts[mol.type] = (counts[mol.type] or 0) + 1
            end
        end
        
        table.insert(populationHistory, {
            time = love.timer.getTime(),
            counts = counts
        })
        
        if #populationHistory > maxHistoryLength then
            table.remove(populationHistory, 1)
        end
    end
	
	local screenX, screenY = camera.x, camera.y
    local screenW = love.graphics.getWidth() / camera.zoom
    local screenH = love.graphics.getHeight() / camera.zoom
    local mouseX, mouseY = love.mouse.getPosition()
    local worldX = camera.x + mouseX / camera.zoom
    local worldY = camera.y + mouseY / camera.zoom

    hoveredMolecule = nil
    local closestDist = 30 / camera.zoom
	
    local radioactiveCount = 0
    
    for _, mol in ipairs(molecules) do
        if mol.alive then
            mol:update(dt)
            local struct = structures[mol.type]
            if struct and struct.radioactive then
                if mol.x > screenX and mol.x < screenX + screenW and
                   mol.y > screenY and mol.y < screenY + screenH then
                    radioactiveCount = radioactiveCount + 1
                end
            end
        end
    end
    
    if radioactiveCount > 0 then
        geigerTimer = (geigerTimer or 0) + dt
        local interval = 0.5 / (radioactiveCount ^ 0.7) 
        
        if geigerTimer > interval then
            local click = generateSound(2450, 0.02, 0.15)
            click:play()
            geigerTimer = 0
        end
    end

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
	
	for i = #molecules, 1, -1 do
        local mol = molecules[i]
        if mol.alive and mol.type == "positronium_hydride" then
            for j = #molecules, 1, -1 do
                if i ~= j and molecules[j].alive then
                    local other = molecules[j]
                    local dx = mol.x - other.x
                    local dy = mol.y - other.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    local minDist = mol.radius + other.radius
                    
                    if dist < minDist then
                        mol.alive = false
                        other.alive = false
                        
                        local burstCount = 8
                        for k = 1, burstCount do
                            local angle = (k / burstCount) * math.pi * 2
                            local speed = 150 + math.random() * 100
                            
                            if math.random() < 0.5 then
                                local fragment = Molecule:new("hydrogen_atom", 
                                    mol.x + math.cos(angle) * 40,
                                    mol.y + math.sin(angle) * 40)
                                fragment.vx = math.cos(angle) * speed
                                fragment.vy = math.sin(angle) * speed
                                table.insert(molecules, fragment)
                            end
                        end
                        
                        break
                    end
                end
            end
		end
    end
	
    for i = #molecules, 1, -1 do
        local mol = molecules[i]
        if mol.alive and mol.type == "dipositronium" then
            for j = #molecules, 1, -1 do
                if i ~= j and molecules[j].alive then
                    local other = molecules[j]
                    local dx = mol.x - other.x
                    local dy = mol.y - other.y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    local minDist = mol.radius + other.radius
                    
                    if dist < minDist then
                        mol.alive = false
                        other.alive = false
                        
                        local burstCount = 16
                        for k = 1, burstCount do
                            local angle = (k / burstCount) * math.pi * 2
                            local speed = 200 + math.random() * 150
                            
                            local atomTypes = {"hydrogen_atom", "hydrogen_atom", "helium"}
                            local atomType = atomTypes[math.random(1, #atomTypes)]
                            
                            local fragment = Molecule:new(atomType, 
                                mol.x + math.cos(angle) * 60,
                                mol.y + math.sin(angle) * 60)
                            fragment.vx = math.cos(angle) * speed
                            fragment.vy = math.sin(angle) * speed
                            table.insert(molecules, fragment)
                        end
                        
                        break
                    end
                end
            end
        end
    end

    for i = #molecules, 1, -1 do
        if not molecules[i].alive or molecules[i].health <= 0 then
            if camera.followTarget == molecules[i] then
                camera.followTarget = nil
            end
            playDeathSound(molecules[i].type)
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
	
    if pilotedMolecule and pilotedMolecule.alive then
        local molConfig = config.molecules[pilotedMolecule.type]
        local speedMult = molConfig.speedMultiplier or 1
        local controlSpeed = WANDER_SPEED * speedMult
        
        if love.keyboard.isDown("up") then pilotedMolecule.vy = pilotedMolecule.vy - controlSpeed * dt end
        if love.keyboard.isDown("down") then pilotedMolecule.vy = pilotedMolecule.vy + controlSpeed * dt end
        if love.keyboard.isDown("left") then pilotedMolecule.vx = pilotedMolecule.vx - controlSpeed * dt end
        if love.keyboard.isDown("right") then pilotedMolecule.vx = pilotedMolecule.vx + controlSpeed * dt end
        
        local friction = 0.95
        pilotedMolecule.vx = pilotedMolecule.vx * friction
        pilotedMolecule.vy = pilotedMolecule.vy * friction
        
        local targetX = pilotedMolecule.x - love.graphics.getWidth() / (2 * camera.zoom)
        local targetY = pilotedMolecule.y - love.graphics.getHeight() / (2 * camera.zoom)
        camera.x = camera.x + (targetX - camera.x) * 5 * dt
        camera.y = camera.y + (targetY - camera.y) * 5 * dt
    end
end

function drawPopulationGraph()
    if not showGraph or #populationHistory < 2 then return end
    
    local graphX = love.graphics.getWidth() - 410
    local graphY = 10
    local graphWidth = 400
    local graphHeight = 200
    local padding = 40

    love.graphics.setColor(0.1, 0.1, 0.15, 0.95)
    love.graphics.rectangle("fill", graphX, graphY, graphWidth, graphHeight, 5, 5)
    love.graphics.setColor(0.3, 0.3, 0.4)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", graphX, graphY, graphWidth, graphHeight, 5, 5)

    local maxPop = 0
    for _, entry in ipairs(populationHistory) do
        local total = 0
        for _, count in pairs(entry.counts) do
            total = total + count
        end
        if total > maxPop then maxPop = total end
    end
    
    if maxPop == 0 then return end

    love.graphics.setColor(0.2, 0.2, 0.25)
    for i = 1, 4 do
        local y = graphY + padding + (graphHeight - padding * 2) * (i / 5)
        love.graphics.line(graphX + padding, y, graphX + graphWidth - 10, y)
    end
    
    local typeTotals = {}
    for _, entry in ipairs(populationHistory) do
        for molType, count in pairs(entry.counts) do
            typeTotals[molType] = (typeTotals[molType] or 0) + count
        end
    end
    
    local topTypes = {}
    for molType, total in pairs(typeTotals) do
        table.insert(topTypes, {type = molType, total = total})
    end
    table.sort(topTypes, function(a, b) return a.total > b.total end)
    
    local colors = {
        {1, 0.3, 0.3},    -- Red
        {0.3, 0.8, 1},    -- Blue
        {0.3, 1, 0.3},    -- Green
        {1, 1, 0.3},      -- Yellow
        {1, 0.5, 0.3},    -- Orange
    }
    
    local typeColors = {}
    for i = 1, math.min(5, #topTypes) do
        typeColors[topTypes[i].type] = colors[i]
    end
    
    for molType, color in pairs(typeColors) do
        love.graphics.setColor(color)
        love.graphics.setLineWidth(2)
        
        local points = {}
        for i, entry in ipairs(populationHistory) do
            local count = entry.counts[molType] or 0
            local x = graphX + padding + ((i - 1) / (#populationHistory - 1)) * (graphWidth - padding - 10)
            local y = graphY + graphHeight - padding - (count / maxPop) * (graphHeight - padding * 2)
            table.insert(points, x)
            table.insert(points, y)
        end
        
        if #points >= 4 then
            love.graphics.line(points)
        end
    end
    
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(graphX + padding, graphY + padding, 
                      graphX + padding, graphY + graphHeight - padding)
    love.graphics.line(graphX + padding, graphY + graphHeight - padding, 
                      graphX + graphWidth - 10, graphY + graphHeight - padding)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Population", graphX + 5, graphY + 5, 0, 0.8, 0.8)
    love.graphics.print(maxPop, graphX + 5, graphY + padding, 0, 0.7, 0.7)
    love.graphics.print("0", graphX + 5, graphY + graphHeight - padding - 5, 0, 0.7, 0.7)
    
    local legendY = graphY + graphHeight - padding - 90
    for i, entry in ipairs(topTypes) do
        if i > 5 then break end
        local color = typeColors[entry.type]
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", graphX + padding + 5, legendY + (i - 1) * 18, 10, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(entry.type, graphX + padding + 20, legendY + (i - 1) * 18 - 2, 0, 0.7, 0.7)
    end
end

function love.draw()
    drawWorld()
    drawUI()
    drawPopulationGraph()
    TimeSlider.draw()
    if hoveredMolecule then
        drawMoleculeTooltip(hoveredMolecule)
    end
    Console.draw()
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

    love.graphics.print("Scroll: Zoom  |  ESC: Release control | G: Graph | D: Debug | 0: Reset zoom", 10, y)
    y = y + 20
    love.graphics.print("Right-click: Pilot molecule (Arrows)  |  Middle-click: Follow  |  ` : Console", 10, y)
end

function drawMoleculeTooltip(molecule)
    if TimeSlider.mousepressed(x, y, button) then
        return
    end
    local mouseX, mouseY = love.mouse.getPosition()
    local lines = {}

    table.insert(lines, "Type: " .. molecule.type)
    table.insert(lines, "Health: " .. math.floor(molecule.health) .. "/" .. molecule.maxHealth)

    if molecule.type:match("fluoro") or molecule.type == "carbon_tetrafluoride" then
        table.insert(lines, "Fluorinated - resistant to attack")
    elseif molecule.type:match("chloro") or molecule.type == "carbon_tetrachloride" then
        table.insert(lines, "Chlorinated")
    elseif molecule.type:match("bromo") or molecule.type == "carbon_tetrabromide" then
        table.insert(lines, "Brominated - heavy")
    elseif molecule.type:match("iodo") or molecule.type == "carbon_tetraiodide" or molecule.type == "astatidomethane" or molecule.type == "diastatidomethane" or molecule.type == "triastatidomethane" then
        table.insert(lines, "Iodinated - UNSTABLE!")
        if molecule.type == "carbon_tetraiodide" then
            table.insert(lines, "PURPLE EXPLOSIVE!")
            if molecule.unstableTimer > 0 then
                table.insert(lines, string.format("Time to decay: %.1fs", math.max(0, 5 - molecule.unstableTimer)))
            end
        end
	elseif molecule.type:match("ic_acid$") then
        table.insert(lines, "[Carboxylic acid]")
        table.insert(lines, "Organic acid with -COOH group")
	elseif molecule.type == "xenon" then
        table.insert(lines, "Noble gas - anesthetic properties")
        table.insert(lines, "Can form compounds with fluorine!")
    elseif molecule.type == "krypton" then
        table.insert(lines, "Noble gas - mostly inert")
        table.insert(lines, "Rarely forms compounds")
    elseif molecule.type == "neon" then
        table.insert(lines, "Noble gas - completely inert")
        table.insert(lines, "Famous for orange glow")
    elseif molecule.type == "argon" then
        table.insert(lines, "Noble gas - totally inert")
        table.insert(lines, "Most common noble gas")
	elseif molecule.type == "positronium_hydride" then
        table.insert(lines, "Annihilates in <1 nanosecond!")
        if molecule.unstableTimer > 0 then
            table.insert(lines, string.format("Annihilation in: %.2fs", math.max(0, 0.5 - molecule.unstableTimer)))
        end
        table.insert(lines, "Releases gamma ray burst!")
	elseif molecule.type == "dipositronium" then
        table.insert(lines, "Annihilates in <0.3 nanoseconds!")
        if molecule.unstableTimer > 0 then
            table.insert(lines, string.format("Annihilation in: %.2fs", math.max(0, 0.3 - molecule.unstableTimer)))
        end
        table.insert(lines, "Releases MASSIVE gamma ray burst!")
        table.insert(lines, "[GRB Intensity: 15]")
    elseif molecule.type == "xenon_difluoride" then
        table.insert(lines, "FORBIDDEN CHEMISTRY!")
        table.insert(lines, "Noble gas compound - shouldn't exist!")
        table.insert(lines, "Strong oxidizing agent")
    elseif molecule.type == "xenon_tetrafluoride" then
        table.insert(lines, "EVEN MORE FORBIDDEN!")
        table.insert(lines, "Square planar geometry")
        table.insert(lines, "Very strong oxidizer")
    elseif molecule.type == "krypton_difluoride" then
        table.insert(lines, "EXTREMELY FORBIDDEN!")
        table.insert(lines, "Decomposes at room temperature")
        table.insert(lines, "One of the rarest compounds")
        if (molecule.unstableTimer or 0) > 0 then
            table.insert(lines, string.format("Time to decay: %.1fs", math.max(0, 8 - (molecule.unstableTimer or 0))))
        end
	elseif molecule.type == "butane" then
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
	elseif molecule.type == "deuterium" or molecule.type == "deuterium_atom" then
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
    elseif molecule.type == "cyclopropane" or molecule.type == "cyclopropenylidene" or 
       molecule.type == "cyclobutane" or molecule.type == "cyclobutene" then
        table.insert(lines, "Ring strain - unstable!")
    elseif molecule.type == "benzene" then
        table.insert(lines, "Aromatic - very stable")
    elseif molecule.type == "caffeine" then
        table.insert(lines, "Stimulant - speeds things up!")
    elseif molecule.type == "tnt" then
        table.insert(lines, "EXPLOSIVE!")
    elseif molecule.type == "helium_dimer" then
        table.insert(lines, "Weakly bound - very fragile")
	elseif molecule.type == "helium_trimer" then
        table.insert(lines, "More weakly bound - even more fragile than helium dimer")
    elseif molecule.type == "helium" then
        table.insert(lines, "Noble gas - inert")
    elseif molecule.type == "acetylcarnitine" then
        table.insert(lines, "Large biomolecule")
    elseif molecule.type == "ethanol" then
        table.insert(lines, "Alcohol - flammable")
    elseif molecule.type == "ammonia" then
        table.insert(lines, "Base - pungent smell")
    elseif molecule.type == "squaric_acid" then
        table.insert(lines, "Aromatic acid - square!")
    elseif molecule.type == "cyclopentane" then
        table.insert(lines, "Five-membered ring - stable")
    elseif molecule.type == "propane" then
        table.insert(lines, "Simple alkane - fuel")
    elseif molecule.type == "methane" then
        table.insert(lines, "Simplest alkane - natural gas")
    elseif molecule.type == "ethylene" then
        table.insert(lines, "Alkene - plant hormone")
    elseif molecule.type == "acetone" then
        table.insert(lines, "Ketone - solvent")
    elseif molecule.type == "tetrafluoroethylene" then
        table.insert(lines, "Precursor to Teflon")
    elseif molecule.type == "water" then
        table.insert(lines, "Universal solvent")
	elseif molecule.type == "helium_hydride" then
        table.insert(lines, "One of the lightest molecules")
    elseif molecule.type == "co2" then
        table.insert(lines, "Carbon dioxide - greenhouse gas")
    elseif molecule.type == "oxygen" then
        table.insert(lines, "Oxidizer - essential for life")
    elseif molecule.type == "ozone" then
        table.insert(lines, "Triatomic oxygen - UV shield")
        table.insert(lines, "Prefers alkenes!")
    elseif molecule.type == "chlorine" then
        table.insert(lines, "Diatomic halogen - reactive")
	elseif molecule.type == "propylene" then
        table.insert(lines, "C3 alkene - propene")
        table.insert(lines, "Plastic precursor")
    elseif molecule.type == "butene" then
        table.insert(lines, "C4 alkene - 1-butene")
        table.insert(lines, "Used in polymer production")
    elseif molecule.type == "acetylene" then
        table.insert(lines, "C2 alkyne - HIGHLY reactive")
        table.insert(lines, "Welding fuel - burns HOT!")
    elseif molecule.type == "propyne" then
        table.insert(lines, "C3 alkyne - methylacetylene")
        table.insert(lines, "Reactive triple bond")
    elseif molecule.type == "butyne" then
        table.insert(lines, "C4 alkyne - 1-butyne")
        table.insert(lines, "Industrial chemical")
    elseif molecule.type == "fluorine" then
        table.insert(lines, "MOST reactive element!")
        table.insert(lines, "Attacks everything!")
    elseif molecule.type == "hydrogen_peroxide" then
        table.insert(lines, "Oxidizer - bleaching agent")
    elseif molecule.type == "sulfuric_acid" then
        table.insert(lines, "Strong acid - corrosive")
	elseif molecule.type == "hypobromous_acid" then
        table.insert(lines, "Strong acid - corrosive")
	elseif molecule.type == "formaldehyde" then
        table.insert(lines, "Simplest aldehyde")
    elseif molecule.type == "hydrochloric_acid" then
        table.insert(lines, "Weak acid")
    elseif molecule.type == "perchloric_acid" then
        table.insert(lines, "SUPERACID - strongest!")
        table.insert(lines, "Hunts EVERYTHING!")
    elseif molecule.type == "lithium_hydroxide" then
        table.insert(lines, "Strong base - CO2 scrubber")
    elseif molecule.type == "sodium_hydroxide" then
        table.insert(lines, "Strong base - lye")
    elseif molecule.type == "hydroxide" then
        table.insert(lines, "Base ion - OH⁻")
        table.insert(lines, "Neutralizes acids!")
    elseif molecule.type == "hydronium" then
        table.insert(lines, "Acid ion - H3O⁺")
        table.insert(lines, "Neutralizes bases!")
	elseif molecule.type == "miau" then
        table.insert(lines, "My sister requested I add this.")
        table.insert(lines, "I just couldn't say no.")
    elseif molecule.type == "uranyl" then
        table.insert(lines, "Uranium(VI) ion - UO2²⁺")
        table.insert(lines, "Soluble, seeks hydroxide")
    elseif molecule.type == "uranium_hexafluoride" then
        table.insert(lines, "Enrichment compound")
        table.insert(lines, "Highly reactive and toxic")
    elseif molecule.type == "uranium_atom" then
        table.insert(lines, "Actinide - fissile")
    elseif molecule.type == "hydrogen_atom" then
        table.insert(lines, "Most abundant element")
    elseif molecule.type == "carbon_atom" then
        table.insert(lines, "Basis of organic chemistry")
    elseif molecule.type == "oxygen_atom" then
        table.insert(lines, "Essential for combustion")
    elseif molecule.type == "nitrogen_atom" then
        table.insert(lines, "78% of atmosphere")
    elseif molecule.type == "nitrogen_positive1_atom" then
        table.insert(lines, "Nitrogen cation - N⁺")
    elseif molecule.type == "fluorine_atom" then
        table.insert(lines, "Most electronegative")
    elseif molecule.type == "chlorine_atom" then
        table.insert(lines, "Halogen - reactive")
    elseif molecule.type == "bromine_atom" then
        table.insert(lines, "Heavy halogen")
    elseif molecule.type == "iodine_atom" then
        table.insert(lines, "Heaviest stable halogen")
        table.insert(lines, "Purple!")
    elseif config.molecules[molecule.type].refrigerant then
        table.insert(lines, "Refrigerant (CFC)")
    elseif config.molecules[molecule.type].anesthetic then
        table.insert(lines, "Anesthetic properties")
    elseif config.molecules[molecule.type].toxic then
        table.insert(lines, "TOXIC")
    elseif config.molecules[molecule.type].inert then
        table.insert(lines, "INERT - super stable!")
    elseif config.molecules[molecule.type].radioactive then
        table.insert(lines, "[!] RADIOACTIVE [!]")
	elseif config.molecules[molecule.type].pyrophoric then
        table.insert(lines, "[PYROPHORIC - ignites in air]")
    elseif config.molecules[molecule.type].hypergolic then
        table.insert(lines, "[HYPERGOLIC - spontaneous ignition]")
    elseif config.molecules[molecule.type].extremely_reactive then
        table.insert(lines, "[EXTREMELY REACTIVE]")
    elseif config.molecules[molecule.type].smells_horrible then
        table.insert(lines, "[Smells like rotten eggs]")
    elseif config.molecules[molecule.type].burns_everything then
        table.insert(lines, "[!!! BURNS EVERYTHING !!!]")
    elseif config.molecules[molecule.type].very_stable then
        table.insert(lines, "[Very stable - hard to break]")
    elseif config.molecules[molecule.type].purple then
        table.insert(lines, "[Purple color]")
    elseif config.molecules[molecule.type].alkali_metal then
        table.insert(lines, "[Alkali metal - highly reactive]")
    elseif config.molecules[molecule.type].salt then
        table.insert(lines, "[Ionic salt compound]")
    elseif config.molecules[molecule.type].oxidizer then
        table.insert(lines, "[Strong oxidizer]")
    elseif molecule.type == "trihydrogen_cation" then
        table.insert(lines, "Most abundant ion in space!")
        table.insert(lines, "Electron hungry - hunts atoms")
    elseif molecule.type == "tricarbon" then
        table.insert(lines, "Linear carbon chain")
        table.insert(lines, "Found in molecular clouds")
    elseif molecule.type == "cyanoacetylene" then
        table.insert(lines, "Common in space")
        table.insert(lines, "Precursor to complex organics")
    elseif molecule.type == "ethynyl_radical" then
        table.insert(lines, "Highly reactive radical")
        table.insert(lines, "Key in interstellar chemistry")
    elseif molecule.type == "formyl_cation" then
        table.insert(lines, "2nd most abundant ion")
        table.insert(lines, "Proton affinity marker")
    elseif molecule.type == "acetonitrile" then
        table.insert(lines, "Complex organic")
        table.insert(lines, "Found near star-forming regions")
    elseif molecule.type == "buckminsterfullerene" then
        table.insert(lines, "Extremely stable fullerene")
        table.insert(lines, "Found in planetary nebulae!")
        table.insert(lines, "[90% damage resistance]")
	elseif molecule.type == "hydrogen_sulfide" then
        table.insert(lines, "H2S - Rotten egg gas")
        table.insert(lines, "Toxic and flammable")
        table.insert(lines, "Smells HORRIBLE")
    elseif molecule.type == "sulfur_trioxide" then
        table.insert(lines, "SO3 - Extremely reactive")
        table.insert(lines, "Reacts violently with water")
        table.insert(lines, "Forms sulfuric acid")
    elseif molecule.type == "phosphoric_acid" then
        table.insert(lines, "H3PO4 - Weaker acid")
        table.insert(lines, "Used in soft drinks")
        table.insert(lines, "Rust remover")
    elseif molecule.type == "sodium_chloride" then
        table.insert(lines, "NaCl - Table salt")
        table.insert(lines, "Very stable ionic compound")
        table.insert(lines, "Essential for life")
    elseif molecule.type == "potassium_permanganate" then
        table.insert(lines, "KMnO4 - Purple crystals")
        table.insert(lines, "Strong oxidizing agent")
        table.insert(lines, "Used as disinfectant")
    elseif molecule.type == "chlorine_trifluoride" then
        table.insert(lines, "ClF3 - NIGHTMARE FUEL")
        table.insert(lines, "Sets EVERYTHING on fire")
        table.insert(lines, "Burns water, sand, concrete")
        table.insert(lines, "Attacks ALL molecules!")
    elseif molecule.type == "white_phosphorus" then
        table.insert(lines, "P4 - Pyrophoric")
        table.insert(lines, "Spontaneously combusts in air")
        table.insert(lines, "Extremely toxic")
        table.insert(lines, "Used in incendiary weapons")
    elseif molecule.type == "red_phosphorus" then
        table.insert(lines, "P4 - Stable form")
        table.insert(lines, "Used in matches")
        table.insert(lines, "Much safer than white")
    elseif molecule.type == "sodium_atom" then
        table.insert(lines, "Alkali metal - very reactive")
        table.insert(lines, "Explodes in water")
    elseif molecule.type == "potassium_atom" then
        table.insert(lines, "Alkali metal - MORE reactive")
        table.insert(lines, "Purple flame in water")
    elseif molecule.type == "sulfur_atom" then
        table.insert(lines, "Yellow nonmetal")
        table.insert(lines, "Forms many compounds")
    elseif molecule.type == "phosphorus_atom" then
        table.insert(lines, "Essential for life")
        table.insert(lines, "Found in DNA and ATP")
	elseif molecule.type == "fluoroantimonic_acid" then
        table.insert(lines, "STRONGEST SUPERACID!")
        table.insert(lines, "20 quintillion times stronger than H₂SO₄")
        table.insert(lines, "Dissolves glass, flesh, everything")
		table.insert(lines, "Vulnerable to radiation; 5x damage from radioactive molecules")
        table.insert(lines, "Hunts: EVERYTHING except itself")
	elseif molecule.type == "glycine" then
        table.insert(lines, "[Amino acid]")
		table.insert(lines, "Smallest amino acid - no side chain")
	elseif molecule.type == "alanine" then
        table.insert(lines, "[Amino acid]")
		table.insert(lines, "2nd smallest amino acid behind glycine - methane side chain")
	elseif molecule.type == "nitrogen_triiodide" then
        table.insert(lines, "NI₃ - EXPLODES IF TOUCHED!")
        table.insert(lines, "Don't breathe near it")
        table.insert(lines, "Purple crystals of DOOM")
        if molecule.unstableTimer and molecule.unstableTimer > 0 then
            table.insert(lines, string.format("Decay timer: %.1fs", molecule.unstableTimer))
        end
    elseif molecule.type == "dioxygen_difluoride" then
        table.insert(lines, "Burns things at -180°C")
        table.insert(lines, "Hunts: EVERYTHING")
    elseif molecule.type == "chlorine_pentafluoride" then
        table.insert(lines, "5 fluorines of fury")
        table.insert(lines, "Square pyramidal nightmare")
    elseif molecule.type == "hydrazine" then
        table.insert(lines, "Hypergolic with oxidizers")
        table.insert(lines, "Toxic + carcinogenic")
    elseif molecule.type == "dimethylmercury" then
        table.insert(lines, "Penetrates latex gloves")
        table.insert(lines, "Kills slowly and surely")
        table.insert(lines, "Even damages buckyballs!")
    elseif molecule.type == "chlorine_dioxide" then
        table.insert(lines, "Used to purify water somehow")
        table.insert(lines, "Decays over time")
    elseif molecule.type == "sulfur_mustard" then
        table.insert(lines, "Blistering agent")
        table.insert(lines, "Leaves toxic zone (80 radius)")
        table.insert(lines, "[Geneva Convention violation]")
    elseif molecule.type == "ammonium_nitrate" then
        table.insert(lines, "NH₄NO₃ - Innocent fertilizer")
        table.insert(lines, "...until it meets explosives")
	elseif molecule.type == "protonated_methane" then
        table.insert(lines, "Fluxional carbocation")
        table.insert(lines, "5 hydrogens scrambling constantly!")
        table.insert(lines, "Found in interstellar space")
        table.insert(lines, "Hunts electrons desperately")
	elseif molecule.type == "formic_acid" then
        table.insert(lines, "HCOOH - Simplest carboxylic acid")
        table.insert(lines, "Found in ant venom!")
    elseif molecule.type == "acetic_acid" then
        table.insert(lines, "Vinegar!")
        table.insert(lines, "5% solution = table vinegar")
    elseif molecule.type == "butyric_acid" then
        table.insert(lines, "Used in stink bombs")
    elseif molecule.type == "valeric_acid" then
        table.insert(lines, "Even WORSE than butyric")
    elseif molecule.type == "caproic_acid" then
        table.insert(lines, "Named after 'caper' = goat!")
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
    elseif molecule.type:match("methane") or molecule.type == "ethylene" or molecule.type == "benzene" or
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
    elseif molecule.type == "helium" then
        table.insert(info.huntedBy, "F2 (only!)")
    elseif molecule.type == "water" or molecule.type == "co2" then
        table.insert(info.huntedBy, "bases")
	elseif molecule.type == "buckminsterfullerene" then
        table.insert(info.huntedBy, "almost nothing!")
	elseif molecule.type == "hydrogen_sulfide" then
        table.insert(info.hunts, "organics")
        table.insert(info.huntedBy, "oxidizers")
    elseif molecule.type == "sulfur_trioxide" then
        table.insert(info.hunts, "water")
        table.insert(info.hunts, "alcohols")
    elseif molecule.type == "phosphoric_acid" then
        table.insert(info.hunts, "bases")
        table.insert(info.huntedBy, "strong bases")
    elseif molecule.type == "potassium_permanganate" then
        table.insert(info.hunts, "organics")
        table.insert(info.hunts, "reducing agents")
    elseif molecule.type == "chlorine_trifluoride" then
        table.insert(info.hunts, "LITERALLY EVERYTHING")
        table.insert(info.hunts, "water, CO2, sand, asbestos")
    elseif molecule.type == "white_phosphorus" then
        table.insert(info.hunts, "oxygen")
        table.insert(info.huntedBy, "air itself")
    elseif molecule.type == "red_phosphorus" then
        table.insert(info.huntedBy, "strong oxidizers")
    elseif molecule.type == "sodium_chloride" then
        table.insert(info.huntedBy, "almost nothing")
    elseif molecule.type == "sodium_chloride" then
        table.insert(info.huntedBy, "strong acids (slowly)")
    elseif molecule.type == "red_phosphorus" then
        table.insert(info.huntedBy, "strong oxidizers only")
    elseif molecule.type == "diborane" or molecule.type == "tetrahydrodiborane" or 
        molecule.type == "dihydrodiborane" then
        table.insert(info.hunts, "oxygen")
        table.insert(info.hunts, "water")
        table.insert(info.huntedBy, "oxidizers")
    elseif molecule.type == "boron_trifluoride" or molecule.type == "boron_trichloride" then
        table.insert(info.hunts, "bases")
        table.insert(info.hunts, "nucleophiles")
    elseif molecule.type == "borax" or molecule.type == "boric_acid" then
        table.insert(info.huntedBy, "strong acids")
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

    local molConfig = config.molecules[molecule.type]
    local grbIntensity = molConfig.grb or 0
    
    if grbIntensity > 0 then
        local burstParticles = math.floor(grbIntensity * 4)
        for i = 1, burstParticles do
            local angle = (i / burstParticles) * math.pi * 2
        end
    end

    for _, rule in ipairs(fragmentation) do
        for i = 1, rule.count do
            local distance = 30 + math.random() * 20
            
            if grbIntensity > 0 then
                distance = distance + (grbIntensity * 10)
            end
            
            local x = molecule.x + math.cos(currentAngle) * distance
            local y = molecule.y + math.sin(currentAngle) * distance
            
            -- CREATE WITH SAFETY CHECK
            local fragment = Molecule:new(rule.type, x, y)
            
            -- Only add if fragment was successfully created
            if fragment then
                local explosionSpeed = 80 + math.random() * 40
                
                if grbIntensity > 0 then
                    explosionSpeed = explosionSpeed * (1 + (grbIntensity * 0.3))
                end
                
                fragment.vx = math.cos(currentAngle) * explosionSpeed
                fragment.vy = math.sin(currentAngle) * explosionSpeed
                table.insert(molecules, fragment)
            end
            
            currentAngle = currentAngle + angleStep
        end
    end
    
    if grbIntensity >= 5 then
        local gammaRays = math.floor(grbIntensity * 2)
        for i = 1, gammaRays do
            local angle = math.random() * math.pi * 2
            local speed = 200 + math.random() * 100
        end
    end
end

function love.keypressed(key)
    local context = {
        molecules = molecules,
        camera = camera,
        config = config,
        Molecule = Molecule
    }
    
    if Console.keypressed(key, context) then
        return
    end
    
    if key == "escape" then
        camera.followTarget = nil
		pilotedMolecule = nil
    end
    if key == "0" then
        camera.zoom = config.camera.defaultZoom
    end
    if key == "g" then
        showGraph = not showGraph
    end
end

function love.wheelmoved(x, y)
    local zoomSpeed = 0.15
    local oldZoom = camera.zoom
    
    if y > 0 then
        camera.zoom = math.min(camera.zoom * 1.1, camera.maxZoom)
    elseif y < 0 then
        camera.zoom = math.max(camera.zoom * 0.9, camera.minZoom)
    end

    if camera.zoom ~= oldZoom then
        local mouseX, mouseY = love.mouse.getPosition()
        local worldX = camera.x + mouseX / oldZoom
        local worldY = camera.y + mouseY / oldZoom
        camera.x = worldX - mouseX / camera.zoom
        camera.y = worldY - mouseY / camera.zoom
    end
end

function love.textinput(text)
    Console.textinput(text)
end

function love.mousepressed(x, y, button)
    if TimeSlider.mousepressed(x, y, button) then
        return
    end
	
	if button == 2 then
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
            if pilotedMolecule == closest then
                pilotedMolecule = nil
            else
                pilotedMolecule = closest
                camera.followTarget = closest
                playTrackSound()
            end
        else
            pilotedMolecule = nil
        end
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
                playTrackSound()
            end
        else
            camera.followTarget = nil
        end
    end
end