local config = {}

config.game = {
    title = "Molvolution",
    version = "December 2025 Build 0.1.15300",
    window = {
        width = 1200,
        height = 800,
        fullscreen = false,
        vsync = true
    }
}

config.world = {
    width = 40000,
    height = 2000
}

config.camera = {
    minZoom = 0.3,
    maxZoom = 2.0,
    defaultZoom = 1.0,
    moveSpeed = 300
}

config.gameplay = {
    detectionRange = 150,
    huntSpeed = 80,
    fleeSpeed = 100,
    wanderSpeed = 40
}

config.molecules = {
    methane = {
        health = 100,
        radius = 20,
        spawnKey = "space"
    },
    -- FLUOROMETHANES
    fluoromethane = {
        health = 110,
        radius = 21,
        speedMultiplier = 1.05,
        fluorinated = true
    },
    difluoromethane = {
        health = 120,
        radius = 22,
        speedMultiplier = 1.1,
        fluorinated = true
    },
    trifluoromethane = {
        health = 130,
        radius = 23,
        speedMultiplier = 1.15,
        fluorinated = true
    },
    carbon_tetrafluoride = {
        health = 150,
        radius = 24,
        speedMultiplier = 1.2,
        fluorinated = true,
        inert = true
    },
    -- CHLOROMETHANES
    chloromethane = {
        health = 105,
        radius = 22,
        speedMultiplier = 0.95
    },
    dichloromethane = {
        health = 115,
        radius = 23,
        speedMultiplier = 0.9
    },
    chloroform = {
        health = 125,
        radius = 24,
        speedMultiplier = 0.85,
        anesthetic = true
    },
    carbon_tetrachloride = {
        health = 140,
        radius = 26,
        speedMultiplier = 0.8,
        toxic = true
    },
	
    -- BROMOMETHANES
    bromomethane = {
        health = 100,
        radius = 23,
        speedMultiplier = 0.85
    },
    dibromomethane = {
        health = 110,
        radius = 25,
        speedMultiplier = 0.75
    },
    tribromomethane = {
        health = 120,
        radius = 27,
        speedMultiplier = 0.7,
        anesthetic = true
    },
    carbon_tetrabromide = {
        health = 135,
        radius = 29,
        speedMultiplier = 0.65,
        heavy = true
    },
	
    -- IODOMETHANES
    iodomethane = {
        health = 95,
        radius = 25,
        speedMultiplier = 0.75
    },
    diiodomethane = {
        health = 105,
        radius = 28,
        speedMultiplier = 0.65,
        heavy = true
    },
    triiodomethane = {
        health = 115,
        radius = 31,
        speedMultiplier = 0.6,
        unstable = true,
        anesthetic = true
    },
    carbon_tetraiodide = {
        health = 80,
        radius = 34,
        speedMultiplier = 0.5,
        explosive = true,
        unstable = true,
        heavy = true
    },
	
	
    -- MIXED HALOMETHANES (the fun ones!)
    chlorofluoromethane = {
        health = 115,
        radius = 22,
        speedMultiplier = 1.0,
        refrigerant = true
    },
    dichlorofluoromethane = {
        health = 125,
        radius = 23,
        speedMultiplier = 0.95,
        refrigerant = true
    },
    chlorodifluoromethane = {
        health = 130,
        radius = 23,
        speedMultiplier = 1.0,
        refrigerant = true
    },
    bromochloromethane = {
        health = 110,
        radius = 24,
        speedMultiplier = 0.85
    },
    bromodichloromethane = {
        health = 120,
        radius = 25,
        speedMultiplier = 0.8,
        toxic = true
    },
    dibromochloromethane = {
        health = 125,
        radius = 26,
        speedMultiplier = 0.75,
        toxic = true
    },
    bromofluoromethane = {
        health = 108,
        radius = 23,
        speedMultiplier = 0.9
    },
    chloroiodomethane = {
        health = 105,
        radius = 25,
        speedMultiplier = 0.8
    },
    bromoiodomethane = {
        health = 100,
        radius = 27,
        speedMultiplier = 0.7,
        heavy = true
    },
    fluoroiodomethane = {
        health = 95,
        radius = 26,
        speedMultiplier = 0.85,
        unstable = true
    },
	
	-- This chemical doesn't even exist. I don't know why I added this.
	bromochloroflouroidiomethane = {
        health = 125,
        radius = 32,
        speedMultiplier = 0.75,
    },
    propane = {
        health = 140,
        radius = 28,
        speedMultiplier = 0.85
    },
    butane = {
        health = 160,
        radius = 32,
        speedMultiplier = 0.80
    },
    pentane = {
        health = 180,
        radius = 36,
        speedMultiplier = 0.75
    },
    hexane = {
        health = 200,
        radius = 40,
        speedMultiplier = 0.70
    },
    heptane = {
        health = 220,
        radius = 44,
        speedMultiplier = 0.65
	},
    octane = {
         health = 240,
        radius = 48,
        speedMultiplier = 0.60,
        fuel = true  -- Gasoline component!
    },
    nonane = {
        health = 260,
         radius = 52,
        speedMultiplier = 0.55
    },
    decane = {
        health = 280,
        radius = 56,
        speedMultiplier = 0.50,
        waxy = true  -- Starting to get waxy at this length
    },

    cyclopropane = {
        health = 80,
        radius = 18,
        speedMultiplier = 1.1,
        strained = true
    },
	nitric_acid = {
        health = 65,
        radius = 19,
        damage = 75,
        speedMultiplier = 1.05,
        detectionMultiplier = 1.2,
        acid = true
    },
    nitrous_oxide = {
        health = 55,
        radius = 17,
        speedMultiplier = 1.3,
        anesthetic = true,
        laughing_gas = true
    },
    cyanide = {
        health = 25,
        radius = 10,
        damage = 150,
        speedMultiplier = 1.4,
        detectionMultiplier = 1.8,
        toxic = true,
        ion = true,
        charge = -1
    },
    hydrogen_cyanide = {
        health = 45,
        radius = 16,
        damage = 120,
        speedMultiplier = 1.2,
        toxic = true,
        volatile = true
    },
    sulfur_dioxide = {
        health = 60,
        radius = 18,
        damage = 55,
        speedMultiplier = 1.1,
        toxic = true
    },
    nitroglycerin = {
        health = 80,
        radius = 32,
        speedMultiplier = 0.6,
        explosive = true,
        unstable = true
    },
    cyclopropenylidene = {
        health = 50,
        radius = 14,
        speedMultiplier = 1.3,
        carbene = true,
        strained = true
    },
    cyclobutane = {
        health = 90,
        radius = 19,
        speedMultiplier = 1.05,
        strained = true
    },
    cyclobutene = {
        health = 70,
        radius = 17,
        speedMultiplier = 1.15,
        strained = true
    },
    cyclopentane = {
        health = 110,
        radius = 21,
        speedMultiplier = 0.95
    },
    benzene = {
        health = 180,
        radius = 25,
        speedMultiplier = 0.8,
        aromatic = true
    },
    ethylene = {
        health = 120,
        radius = 22,
        speedMultiplier = 0.9
    },
    ethanol = {
        health = 110,
        radius = 24,
        speedMultiplier = 0.88
    },
    ammonia = {
        health = 60,
        radius = 16,
        speedMultiplier = 1.0
    },
    acetylcarnitine = {
        health = 200,
        radius = 35,
        speedMultiplier = 0.7
    },
    caffeine = {
        health = 180,
        radius = 32,
        speedMultiplier = 1.15
    },
    tnt = {
        health = 150,
        radius = 30,
        speedMultiplier = 0.75,
        explosive = true
    },
    acetone = {
        health = 90,
        radius = 20,
        speedMultiplier = 0.95
    },
	miau = {
        health = 110,
        radius = 35,
        speedMultiplier = 0.95
    },
    helium_dimer = {
        health = 30,
        radius = 26,
        speedMultiplier = 1.2
    },
	helium_trimer = {
        health = 45,
        radius = 50,
        speedMultiplier = 1.15
    },
    squaric_acid = {
        health = 110,
        radius = 35,
        speedMultiplier = 0.9,
        aromatic = true,
        acidic = true
    },
    tetrafluoroethylene = {
        health = 130,
        radius = 22,
        speedMultiplier = 1.05,
        fluorinated = true,
        unsaturated = true
    },
    oxygen = {
        health = 50,
        radius = 15,
        damage = 50
    },
    ozone = {
        health = 60,
        radius = 18,
        damage = 70,
        speedMultiplier = 1.2,
        detectionMultiplier = 1.3,
        prefersEthylene = true
    },
	formaldehyde = {
        health = 65,
        radius = 21,
        damage = 65,
        speedMultiplier = 1.1,
        detectionMultiplier = 1.05,
    },
    chlorine = {
        health = 70,
        radius = 17,
        damage = 65,
        speedMultiplier = 1.1,
        detectionMultiplier = 1.2
    },
    fluorine = {
        health = 80,
        radius = 16,
        damage = 90,
        speedMultiplier = 1.3,
        detectionMultiplier = 1.5
    },
    hydrogen_peroxide = {
        health = 60,
        radius = 14,
        damage = 55,
        speedMultiplier = 1.15,
        detectionMultiplier = 1.1
    },
    sulfuric_acid = {
        health = 70,
        radius = 18,
        damage = 80,
        speedMultiplier = 0.9,
        detectionMultiplier = 1.4
    },
	hypobromous_acid = {
        health = 50,
        radius = 16,
        damage = 68,
        speedMultiplier = 1.07,
        detectionMultiplier = 1.12
    },
    hydrochloric_acid = {
        health = 50,
        radius = 13,
        damage = 55,
        speedMultiplier = 1.0,
        detectionMultiplier = 1.1
    },
    lithium_hydroxide = {
        health = 80,
        radius = 16,
        damage = 40,
        speedMultiplier = 0.95,
        detectionMultiplier = 1.2,
        cleaner = true
    },
    sodium_hydroxide = {
        health = 70,
        radius = 15,
        damage = 35,
        speedMultiplier = 1.0,
        detectionMultiplier = 1.3,
        cleaner = true
    },
    water = {
        health = 30,
        radius = 12,
        speedMultiplier = 0.7,
        peaceful = true
    },
	helium_hydride = {
        health = 15,
        radius = 12,
        speedMultiplier = 1.8,
        peaceful = true
    },
    co2 = {
        health = 40,
        radius = 14,
        speedMultiplier = 0.75,
        peaceful = true
    },
    hydroxide = {
        health = 25,
        radius = 10,
        damage = 60,
        speedMultiplier = 1.1,
        detectionMultiplier = 1.5,
        ion = true,
        charge = -1,
        base = true
    },
    hydronium = {
        health = 35,
        radius = 12,
        damage = 55,
        speedMultiplier = 1.05,
        detectionMultiplier = 1.4,
        ion = true,
        charge = 1,
        acid = true
    },
    uranyl = {
        health = 120,
        radius = 22,
        speedMultiplier = 0.85,
        ion = true,
        charge = 2,
        radioactive = true,
        damage = 45
    },
    uranium_hexafluoride = {
        health = 180,
        radius = 32,
        speedMultiplier = 0.75,
        radioactive = true,
        damage = 60,
        detectionMultiplier = 1.8
    },
    perchloric_acid = {
        health = 360,
        radius = 24,
        speedMultiplier = 1.25,
        damage = 120,
        detectionMultiplier = 3.6
    },
    helium = {
        health = 20,
        radius = 8,
        speedMultiplier = 1.5,
        peaceful = true,
        noble = true
    },
    hydrogen_atom = {
        health = 10,
        radius = 6,
        speedMultiplier = 1.4,
        peaceful = true,
        atom = true,
        valence = 1
    },
    carbon_atom = {
        health = 15,
        radius = 8,
        speedMultiplier = 1.1,
        peaceful = true,
        atom = true,
        valence = 4
    },
    oxygen_atom = {
        health = 15,
        radius = 7,
        speedMultiplier = 1.2,
        peaceful = true,
        atom = true,
        valence = 2
    },
    nitrogen_atom = {
        health = 15,
        radius = 7,
        speedMultiplier = 1.15,
        peaceful = true,
        atom = true,
        valence = 3
    },
    nitrogen_positive1_atom = {
        health = 12,
        radius = 7,
        speedMultiplier = 1.2,
        peaceful = true,
        atom = true,
        ion = true,
        charge = 1,
        valence = 3
    },
    fluorine_atom = {
        health = 12,
        radius = 6,
        speedMultiplier = 1.3,
        peaceful = true,
        atom = true,
        valence = 1
    },
    chlorine_atom = {
        health = 13,
        radius = 7,
        speedMultiplier = 1.2,
        peaceful = true,
        atom = true,
        valence = 1
    },
    bromine_atom = {
        health = 14,
        radius = 8,
        speedMultiplier = 1.0,
        peaceful = true,
        atom = true,
        valence = 1
    },
    iodine_atom = {
        health = 16,
        radius = 9,
        speedMultiplier = 0.9,
        peaceful = true,
        atom = true,
        valence = 1
    },
    uranium_atom = {
        health = 40,
        radius = 12,
        speedMultiplier = 0.8,
        peaceful = true,
        atom = true,
        valence = 6,
        radioactive = true
    },
    phosgene = {
        health = 90,
        radius = 18,
        damage = 100,
        speedMultiplier = 1.1,
        detectionMultiplier = 1.4,
        toxic = true,
        war_crime = true  -- Geneva Convention disapproves
    },
    carbonic_acid = {
        health = 50,
        radius = 16,
        speedMultiplier = 0.8,
        unstable = true,
        peaceful = true,
        fizzy = true
    },
    foof = {
        health = 120,
        radius = 17,
        damage = 180,
        speedMultiplier = 1.4,
        detectionMultiplier = 2.5,
        explosive = true,
        burns_everything = true,  -- Yes, even water
    },
    chlorine_monofluoride = {
        health = 40,
        radius = 12,
        damage = 70,
        speedMultiplier = 1.2,
        unstable = true,
        probably_shouldnt_exist = true
    },
    hydrogen_fluoride = {
        health = 55,
        radius = 11,
        damage = 75,
        speedMultiplier = 1.15,
        toxic = true,
        etches_glass = true,
        dissolves_bones = true,  -- Not a joke
        why_did_we_make_this = true
    },
    methanol = {
        health = 80,
        radius = 18,
        speedMultiplier = 0.9,
        toxic = true,
    },
    nitrogen = {
        health = 60,
        radius = 13,
        speedMultiplier = 1.0,
        peaceful = true,
        inert = true
    },
    bromine = {
        health = 65,
        radius = 16,
        damage = 60,
        speedMultiplier = 1.05
    },
    iodine = {
        health = 70,
        radius = 18,
        damage = 55,
        speedMultiplier = 0.95
    },
	
	-- INTERSTELLAR MOLECULES
    trihydrogen_cation = {
        health = 25,
        radius = 11,
        damage = 40,
        speedMultiplier = 1.6,
        ion = true,
        charge = 1,
        interstellar = true,
        electron_hungry = true
    },
    tricarbon = {
        health = 45,
        radius = 15,
        speedMultiplier = 1.3,
        interstellar = true,
        reactive = true,
        chain = true
    },
    cyanoacetylene = {
        health = 70,
        radius = 20,
        speedMultiplier = 1.1,
        interstellar = true,
        nitrile = true
    },
    ethynyl_radical = {
        health = 35,
        radius = 12,
        damage = 50,
        speedMultiplier = 1.4,
        interstellar = true,
        radical = true,
        reactive = true
    },
    formyl_cation = {
        health = 30,
        radius = 10,
        damage = 45,
        speedMultiplier = 1.5,
        ion = true,
        charge = 1,
        interstellar = true
    },
    acetonitrile = {
        health = 85,
        radius = 19,
        speedMultiplier = 1.0,
        interstellar = true,
        nitrile = true
    },
    buckminsterfullerene = {
        health = 400,
        radius = 45,
        speedMultiplier = 0.4,
        interstellar = true,
        fullerene = true,
        soccer_ball = true,
        extremely_stable = true
    },
	polonium_atom = {
        health = 50,
        radius = 11,
        speedMultiplier = 0.7,
        peaceful = true,
        atom = true,
        valence = 2,
        radioactive = true,
        extremely_radioactive = true,
        alpha_emitter = true
    },
    radium_atom = {
        health = 45,
        radius = 13,
        speedMultiplier = 0.75,
        peaceful = true,
        atom = true,
        valence = 2,
        radioactive = true,
        glows_in_dark = true
    },
    plutonium_atom = {
        health = 55,
        radius = 13,
        speedMultiplier = 0.7,
        peaceful = true,
        atom = true,
        valence = 4,
        radioactive = true,
        fissile = true
    },
    polonium_dioxide = {
        health = 90,
        radius = 20,
        speedMultiplier = 0.8,
        radioactive = true,
        extremely_radioactive = true,
        volatile = true
    },
    radium_chloride = {
        health = 100,
        radius = 22,
        speedMultiplier = 0.85,
        radioactive = true,
        salt = true,
        soluble = true
    },
    plutonium_dioxide = {
        health = 150,
        radius = 24,
        speedMultiplier = 0.7,
        radioactive = true,
        oxide = true,
        stable_form = true
    },
    strontium_90 = {
        health = 60,
        radius = 14,
        speedMultiplier = 0.9,
        radioactive = true,
        bone_seeker = true,
        beta_emitter = true
    },
    cesium_137 = {
        health = 55,
        radius = 15,
        speedMultiplier = 1.0,
        radioactive = true,
        gamma_emitter = true,
        medical_use = true
    },
    tritium = {
        health = 25,
        radius = 7,
        speedMultiplier = 1.6,
        radioactive = true,
        peaceful = true,
        hydrogen_isotope = true,
        glows_green = true
    },
    radon = {
        health = 35,
        radius = 12,
        speedMultiplier = 1.3,
        radioactive = true,
        noble = true,
        gas = true,
        basement_hazard = true
    }
}

config.initialSpawns = {
    methane = 20,

    -- Fluoromethanes (stable)
    fluoromethane = 8,
    difluoromethane = 6,
    trifluoromethane = 5,
    carbon_tetrafluoride = 4,

    -- Chloromethanes
    chloromethane = 8,
    dichloromethane = 6,
    chloroform = 5,
    carbon_tetrachloride = 4,

    -- Bromomethanes
    bromomethane = 6,
    dibromomethane = 4,
    tribromomethane = 3,
    carbon_tetrabromide = 2,

    -- Iodomethanes (unstable!)
    iodomethane = 5,
    diiodomethane = 3,
    triiodomethane = 2,
    carbon_tetraiodide = 1,

    -- Mixed halomethanes
    chlorofluoromethane = 6,
    dichlorofluoromethane = 5,
    chlorodifluoromethane = 5,
    bromochloromethane = 4,
    bromodichloromethane = 3,
    dibromochloromethane = 3,
    bromofluoromethane = 4,
    chloroiodomethane = 3,
    bromoiodomethane = 2,
    fluoroiodomethane = 2,

    -- Normal molecules
    propane = 12,
    cyclopropane = 8,
    cyclopropenylidene = 3,
    cyclobutane = 8,
    cyclobutene = 5,
    cyclopentane = 10,
    benzene = 10,
    ethylene = 12,
    ethanol = 10,
    ammonia = 15,
    acetylcarnitine = 5,
    caffeine = 8,
    tnt = 2,
    acetone = 10,
    helium_dimer = 12,
    squaric_acid = 6,
    tetrafluoroethylene = 8,
    oxygen = 10,
    ozone = 5,
    chlorine = 5,
    fluorine = 3,
    hydrogen_peroxide = 5,
    sulfuric_acid = 2,
    hydrochloric_acid = 8,
    lithium_hydroxide = 5,
    sodium_hydroxide = 5,
    water = 15,
    co2 = 12,
    hydroxide = 10,
    hydronium = 10,
    helium = 8,
    uranyl = 2,
    uranium_hexafluoride = 1,
    perchloric_acid = 1,
	formaldehyde = 5,
    hypobromous_acid = 5,
	butane = 10,
    pentane = 8,
    hexane = 7,
    octane = 6,
    nonane = 4,
    decane = 3,
	nitric_acid = 4,
    nitrous_oxide = 6,
    hydrogen_cyanide = 3,
    sulfur_dioxide = 5,
    nitroglycerin = 2,
	
	-- Interstellar molecules
	trihydrogen_cation = 8,
    tricarbon = 6,
    cyanoacetylene = 5,
    ethynyl_radical = 7,
    formyl_cation = 6,
    acetonitrile = 4,
    buckminsterfullerene = 1,
	
	-- Radioactive stuff
	polonium_atom = 3,
    radium_atom = 3,
    plutonium_atom = 2,
    polonium_dioxide = 2,
    radium_chloride = 2,
    plutonium_dioxide = 1,
    strontium_90 = 3,
    cesium_137 = 2,
    tritium = 5,
    radon = 4
}

config.visual = {
    backgroundColor = {0.05, 0.05, 0.08},
    gridColor = {0.1, 0.1, 0.15},
    gridSize = 100,
    bondWidth = 2
}

config.controls = {
    moveUp = "up",
    moveDown = "down",
    moveLeft = "left",
    moveRight = "right",
    zoomIn = "+",
    zoomOut = "-",
    resetZoom = "0",
    showDebug = "d"
}

config.debug = {
    showDetectionRanges = false,
    showFPS = true
}

return config