local config = {}

config.game = {
    title = "Molvolution",
    version = "December 2025 Build 0.1.14783",
    window = {
        width = 1200,
        height = 800,
        fullscreen = false,
        vsync = true
    }
}

config.world = {
    width = 20000,
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
    propane = {
        health = 140,
        radius = 28,
        spawnKey = "p",
        speedMultiplier = 0.85
    },
    cyclopropane = {
        health = 80,
        radius = 18,
        spawnKey = "c",
        speedMultiplier = 1.1,
        strained = true
    },
    cyclopropenylidene = {
        health = 50,
        radius = 14,
        spawnKey = "y",
        speedMultiplier = 1.3,
        carbene = true,
        strained = true
    },
    cyclobutane = {
        health = 90,
        radius = 19,
        spawnKey = "4",
        speedMultiplier = 1.05,
        strained = true
    },
    cyclobutene = {
        health = 70,
        radius = 17,
        spawnKey = "u",
        speedMultiplier = 1.15,
        strained = true
    },
    cyclopentane = {
        health = 110,
        radius = 21,
        spawnKey = "5",
        speedMultiplier = 0.95
    },
    benzene = {
        health = 180,
        radius = 25,
        spawnKey = "b",
        speedMultiplier = 0.8,
        aromatic = true
    },
    ethylene = {
        health = 120,
        radius = 22,
        spawnKey = "e",
        speedMultiplier = 0.9
    },
    ethanol = {
        health = 110,
        radius = 24,
        spawnKey = "t",
        speedMultiplier = 0.88
    },
    ammonia = {
        health = 60,
        radius = 16,
        spawnKey = "n",
        speedMultiplier = 1.0
    },
    acetylcarnitine = {
        health = 200,
        radius = 35,
        spawnKey = "a",
        speedMultiplier = 0.7
    },
    caffeine = {
        health = 180,
        radius = 32,
        spawnKey = "k",
        speedMultiplier = 1.15
    },
    tnt = {
        health = 150,
        radius = 30,
        spawnKey = "x",
        speedMultiplier = 0.75,
        explosive = true
    },
    acetone = {
        health = 90,
        radius = 20,
        spawnKey = "j",
        speedMultiplier = 0.95
    },
    helium_dimer = {
        health = 30,
        radius = 26,
        spawnKey = "g",
        speedMultiplier = 1.2
    },
    squaric_acid = {
        health = 110,
        radius = 21,
        spawnKey = "q",
        speedMultiplier = 0.9,
        aromatic = true,
        acidic = true
    },
    tetrafluoroethylene = {
        health = 130,
        radius = 22,
        spawnKey = "v",
        speedMultiplier = 1.05,
        fluorinated = true,
        unsaturated = true
    },
    
    oxygen = {
        health = 50,
        radius = 15,
        spawnKey = "o",
        damage = 50
    },
    ozone = {
        health = 60,
        radius = 18,
        spawnKey = "z",
        damage = 70,
        speedMultiplier = 1.2,
        detectionMultiplier = 1.3,
        prefersEthylene = true
    },
    chlorine = {
        health = 70,
        radius = 17,
        spawnKey = "l",
        damage = 65,
        speedMultiplier = 1.1,
        detectionMultiplier = 1.2
    },
    fluorine = {
        health = 80,
        radius = 16,
        spawnKey = "f",
        damage = 90,
        speedMultiplier = 1.3,
        detectionMultiplier = 1.5
    },
    hydrogen_peroxide = {
        health = 60,
        radius = 14,
        spawnKey = "h",
        damage = 55,
        speedMultiplier = 1.15,
        detectionMultiplier = 1.1
    },
    sulfuric_acid = {
        health = 70,
        radius = 18,
        spawnKey = "s",
        damage = 80,
        speedMultiplier = 0.9,
        detectionMultiplier = 1.4
    },
    hydrochloric_acid = {
        health = 50,
        radius = 13,
        spawnKey = "i",
        damage = 55,
        speedMultiplier = 1.0,
        detectionMultiplier = 1.1
    },
    
    lithium_hydroxide = {
        health = 80,
        radius = 16,
        spawnKey = "1",
        damage = 40,
        speedMultiplier = 0.95,
        detectionMultiplier = 1.2,
        cleaner = true
    },
    sodium_hydroxide = {
        health = 70,
        radius = 15,
        spawnKey = "3",
        damage = 35,
        speedMultiplier = 1.0,
        detectionMultiplier = 1.3,
        cleaner = true
    },
    
    water = {
        health = 30,
        radius = 12,
        spawnKey = "w",
        speedMultiplier = 0.7,
        peaceful = true
    },
    co2 = {
        health = 40,
        radius = 14,
        spawnKey = "2",
        speedMultiplier = 0.75,
        peaceful = true
    },
    hydroxide = {
        health = 25,
        radius = 10,
        spawnKey = "7",
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
        spawnKey = "8",
        damage = 55,
        speedMultiplier = 1.05,
        detectionMultiplier = 1.4,
        ion = true,
        charge = 1,
        acid = true
    },
    helium = {
        health = 20,
        radius = 8,
        spawnKey = "m",
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
    fluorine_atom = {
        health = 12,
        radius = 6,
        speedMultiplier = 1.3,
        peaceful = true,
        atom = true,
        valence = 1
    }
}

config.initialSpawns = {
    methane = 24,
    propane = 15,
    cyclopropane = 9,
    cyclopropenylidene = 4,
    cyclobutane = 9,
    cyclobutene = 6,
    cyclopentane = 12,
    benzene = 12,
    ethylene = 15,
    ethanol = 12,
    ammonia = 18,
    acetylcarnitine = 6,
    caffeine = 9,
    tnt = 3,
    acetone = 12,
    helium_dimer = 15,
    squaric_acid = 8,
    tetrafluoroethylene = 10,
    oxygen = 12,
    ozone = 6,
    chlorine = 6,
    fluorine = 3,
    hydrogen_peroxide = 6,
    sulfuric_acid = 3,
    hydrochloric_acid = 9,
    lithium_hydroxide = 6,
    sodium_hydroxide = 6,
    water = 18,
    co2 = 15,
    hydroxide = 12,
    hydronium = 12,
    helium = 9
}

config.visual = {
    backgroundColor = {0.05, 0.05, 0.08},
    gridColor = {0.1, 0.1, 0.15},
    gridSize = 100,
    bondWidth = 2,
    showHealthBars = true
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
