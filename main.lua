--      _     ___   ____ 
--     | |   / _ \ / ___|
--     | |  | | | | |  _ 
--     | |__| |_| | |_| |
--     |_____\___/ \____|
--                       
-- --------------------------
-- December 20 2025 12:52 - Started. Finally. Hooray.

local config = require("config")

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

local WORLD_WIDTH = config.world.width
local WORLD_HEIGHT = config.world.height
local DETECTION_RANGE = config.gameplay.detectionRange
local HUNT_SPEED = config.gameplay.huntSpeed
local FLEE_SPEED = config.gameplay.fleeSpeed
local WANDER_SPEED = config.gameplay.wanderSpeed

-- What molecules break into
local fragmentationRules = {
    acetylcarnitine = {
        {type = "ethanol", count = 1},
        {type = "ammonia", count = 1},
        {type = "co2", count = 2},
        {type = "water", count = 1}
    },
    benzene = {
        {type = "ethylene", count = 3}
    },
    caffeine = {
        {type = "co2", count = 3},
        {type = "ammonia", count = 2},
        {type = "water", count = 2}
    },
    tnt = {
        {type = "co2", count = 4},
        {type = "water", count = 3},
        {type = "ammonia", count = 2}
    },
    
    propane = {
        {type = "methane", count = 1},
        {type = "ethylene", count = 1}
    },
    ethanol = {
        {type = "methane", count = 1},
        {type = "water", count = 1},
        {type = "co2", count = 1}
    },
    cyclopropane = {
        {type = "ethylene", count = 1},
        {type = "methane", count = 1}
    },
    cyclopropenylidene = {
        {type = "ethylene", count = 1},
        {type = "co2", count = 1}
    },
    tetrafluoroethylene = {
        {type = "fluorine", count = 2},
        {type = "co2", count = 2}
    },
    cyclobutane = {
        {type = "ethylene", count = 2}
    },
    cyclobutene = {
        {type = "ethylene", count = 2}
    },
    cyclopentane = {
        {type = "ethylene", count = 2},
        {type = "methane", count = 1}
    },
    ethylene = {
        {type = "co2", count = 1},
        {type = "water", count = 1}
    },
    acetone = {
        {type = "co2", count = 2},
        {type = "water", count = 2}
    },
    hydrogen_peroxide = {
        {type = "water", count = 2}
    },
    hydrochloric_acid = {
        {type = "water", count = 1},
        {type = "chlorine", count = 1}
    },
    lithium_hydroxide = {
        -- LiOH + CO2 -> Li2CO3 + H2O (simplified as just consuming CO2)
        {type = "water", count = 1}
    },
    sodium_hydroxide = {
        -- NaOH + CO2 -> Na2CO3 + H2O (simplified as just consuming CO2)
        {type = "water", count = 1}
    },
    helium_dimer = {
        {type = "helium", count = 2}
    },
    
    methane = {
        {type = "carbon_atom", count = 1},
        {type = "hydrogen_atom", count = 4}
    },
    ammonia = {
        {type = "nitrogen_atom", count = 1},
        {type = "hydrogen_atom", count = 3}
    },
    water = {
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 2}
    },
    co2 = {
        {type = "carbon_atom", count = 1},
        {type = "oxygen_atom", count = 2}
    },
    oxygen = {
        {type = "oxygen_atom", count = 2}
    },
    fluorine = {
        {type = "fluorine_atom", count = 2}
    },
    hydroxide = {
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 1}
    },
    hydronium = {
        {type = "oxygen_atom", count = 1},
        {type = "hydrogen_atom", count = 3}
    }
}

-- This is no longer needed, but the script demands it.
-- If we dare delete it, it throws a tantrum and breaks.
local spawnFragments

local ELEMENT_COLORS = {
    H = {0.9, 0.9, 0.9},   -- White
    He = {0.8, 0.9, 1.0},  -- Light cyan 
    Li = {0.8, 0.5, 1.0},  -- Light purple
    C = {0.3, 0.3, 0.3},   -- Dark gray/black
    N = {0.2, 0.4, 0.9},   -- Blue
    O = {0.9, 0.2, 0.2},   -- Red
    F = {0.3, 0.9, 0.3},   -- Green
    Na = {1.0, 0.8, 0.2},   -- Gold/orange
    P = {0.9, 0.5, 0.2},   -- Orange
    S = {0.9, 0.9, 0.2},   -- Yellow
    Cl = {0.3, 0.9, 0.6}  -- Cyan/light green
}

-- Molecular structures
local structures = {
    hydroxide = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 8, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}
        },
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
        bonds = {
            {1, 2}, {1, 3}, {1, 4}
        },
        ion = true,
        charge = 1
    },
    methane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -15, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 15, color = ELEMENT_COLORS.H},
            {element = "H", x = -15, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}
        }
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
        bonds = {
            {1, 2}, {2, 3},
            {1, 4}, {1, 5}, {2, 6}, {2, 7}, {3, 8}, {3, 9}
        }
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
        bonds = {
            {1, 2}, {2, 3}, {3, 1},
            {1, 4}, {1, 5}, {2, 6}, {2, 7}, {3, 8}, {3, 9}
        },
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
        bonds = {
            {1, 2}, {2, 3}, {3, 1},
            {2, 4}, {3, 5}
        },
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
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {1, 5}, {1, 6}, {2, 7}, {2, 8}, {3, 9}, {3, 10}, {4, 11}, {4, 12}
        },
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
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 1}, 
            {1, 6}, {1, 7}, {2, 8}, {2, 9}, {3, 10}, {3, 11}, {4, 12}, {4, 13}, {5, 14}, {5, 15}
        }
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
        bonds = {
            {1, 2, double = true}, {2, 3}, {3, 4}, {4, 1},
            {1, 5}, {2, 6}, {3, 7}, {4, 8}, {4, 9}, {3, 10}
        },
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
        bonds = {
            {1, 2, resonance = true}, {2, 3, resonance = true}, 
            {3, 4, resonance = true}, {4, 5, resonance = true}, 
            {5, 6, resonance = true}, {6, 1, resonance = true},
            {1, 7}, {2, 8}, {3, 9}, {4, 10}, {5, 11}, {6, 12}
        },
        aromatic = true
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
        bonds = {
            {1, 2}, {2, 3}, {3, 4},
            {1, 5}, {1, 6}, {2, 7}, {2, 8}
        }
    },
    acetylcarnitine = {
        atoms = {
            -- Main carnitine chain
            {element = "C", x = -30, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 0, color = ELEMENT_COLORS.C},
      
            -- Nitrogen (quaternary ammonium)
            {element = "N", x = 0, y = -15, color = ELEMENT_COLORS.N},
      
            -- Carboxyl group
            {element = "C", x = 30, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 35, y = -10, color = ELEMENT_COLORS.O},
            {element = "O", x = 35, y = 10, color = ELEMENT_COLORS.O},
      
            -- Acetyl group
            {element = "C", x = -15, y = 15, color = ELEMENT_COLORS.C},
            {element = "O", x = -20, y = 25, color = ELEMENT_COLORS.O},
      
            -- Hydrogens (selective)
            {element = "H", x = -35, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -35, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 6},      -- Carbon chain
            {3, 5},                              -- N attached to C3
            {6, 7}, {6, 8},                      -- Carboxyl
            {2, 9}, {9, 10},                     -- Acetyl group
            {1, 11}, {1, 12}, {4, 13}, {4, 14},  -- Some H's
            {9, 10, double = true}               -- C=O in acetyl
        }
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
        bonds = {
            {1, 2, double = true},
            {1, 3}, {1, 4}, {2, 5}, {2, 6}
        }
    },
    co2 = {
        atoms = {
            {element = "O", x = -12, y = 0, color = ELEMENT_COLORS.O},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 12, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2, double = true},
            {2, 3, double = true}
        }
    },
    ammonia = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 6, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}
        }
    },
    oxygen = {
        atoms = {
            {element = "O", x = -8, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 8, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2, double = true}
        }
    },
    ozone = {
        atoms = {
            {element = "O", x = -12, y = 6, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = -8, color = ELEMENT_COLORS.O},
            {element = "O", x = 12, y = 6, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2, resonance = true},
            {2, 3, resonance = true}
        }
    },
    chlorine = {
        atoms = {
            {element = "Cl", x = -10, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 10, y = 0, color = ELEMENT_COLORS.Cl}
        },
        bonds = {
            {1, 2}
        }
    },
    fluorine = {
        atoms = {
            {element = "F", x = -8, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 8, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {
            {1, 2}
        }
    },
    water = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = -10, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}
        }
    },
    caffeine = {
        atoms = {
            -- First ring
            {element = "C", x = -15, y = -15, color = ELEMENT_COLORS.C},
            {element = "N", x = -8, y = -25, color = ELEMENT_COLORS.N},
            {element = "C", x = 5, y = -20, color = ELEMENT_COLORS.C},
            {element = "N", x = 8, y = -8, color = ELEMENT_COLORS.N},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
      
            -- Second fused ring
            {element = "C", x = -10, y = -5, color = ELEMENT_COLORS.C},
            {element = "N", x = -18, y = 5, color = ELEMENT_COLORS.N},
            {element = "C", x = -20, y = -8, color = ELEMENT_COLORS.C},
      
            -- Oxygens
            {element = "O", x = 15, y = -25, color = ELEMENT_COLORS.O},
            {element = "O", x = 5, y = 10, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 1},
            {6, 7}, {7, 8}, {8, 1},
            {3, 9, double = true}, {5, 10, double = true}
        }
    },
    tnt = {
        atoms = {
            -- Benzene ring
            {element = "C", x = 0, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = -7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 15, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = 7.5, color = ELEMENT_COLORS.C},
            {element = "C", x = -13, y = -7.5, color = ELEMENT_COLORS.C},
      
            -- Nitro groups (NO2)
            {element = "N", x = 0, y = -28, color = ELEMENT_COLORS.N},
            {element = "O", x = -8, y = -35, color = ELEMENT_COLORS.O},
            {element = "O", x = 8, y = -35, color = ELEMENT_COLORS.O},
            {element = "N", x = 23, y = 12, color = ELEMENT_COLORS.N},
            {element = "O", x = 30, y = 5, color = ELEMENT_COLORS.O},
            {element = "N", x = -23, y = 12, color = ELEMENT_COLORS.N},
            {element = "O", x = -30, y = 5, color = ELEMENT_COLORS.O}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 5}, {5, 6}, {6, 1},
            {1, 7}, {7, 8}, {7, 9},
            {3, 10}, {10, 11},
            {5, 12}, {12, 13}
        },
        explosive = true
    },
    hydrogen_peroxide = {
        atoms = {
            {element = "O", x = -6, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = -12, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {2, 4}
        }
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
        bonds = {
            {1, 2}, {2, 3}, {2, 4, double = true},
            {1, 5}, {1, 6}, {3, 7}, {3, 8}
        }
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
        bonds = {
            {1, 2, double = true}, {1, 3}, {1, 4, double = true}, {1, 5},
            {3, 6}, {5, 7}
        }
    },
    helium_dimer = {
        atoms = {
            {element = "He", x = -26, y = 0, color = ELEMENT_COLORS.He},
            {element = "He", x = 26, y = 0, color = ELEMENT_COLORS.He}
        },
        bonds = {
            {1, 2, weak = true}
        }
    },
    helium = {
        atoms = {
            {element = "He", x = 0, y = 0, color = ELEMENT_COLORS.He}
        },
        bonds = {}
    },
    hydrochloric_acid = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 4.9, y = -7.2, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.7, y = 0.1, color = ELEMENT_COLORS.H},
            {element = "H", x = 4.5, y = 6.6, color = ELEMENT_COLORS.H},
            {element = "Cl", x = 18.9, y = -1.1, color = ELEMENT_COLORS.Cl},
        },
        bonds = {
            {1, 2},
            {1, 3},
            {1, 4}
        }
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
        bonds = {
            {1, 2, double = true},
            {1, 3}, {1, 4}, {2, 5}, {2, 6}
        }
    },
    lithium_hydroxide = {
        -- LiOH: Lithium hydroxide
        atoms = {
            {element = "Li", x = -10, y = 0, color = ELEMENT_COLORS.Li},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 16, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}
        }
    },
    sodium_hydroxide = {
        atoms = {
            {element = "Na", x = -12, y = 0, color = ELEMENT_COLORS.Na},
            {element = "O", x = 6, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 16, y = 6, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}
        }
    },
  
    hydrogen_atom = {
        atoms = {
            {element = "H", x = 0, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {}
    },
    carbon_atom = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C}
        },
        bonds = {}
    },
    oxygen_atom = {
        atoms = {
            {element = "O", x = 0, y = 0, color = ELEMENT_COLORS.O}
        },
        bonds = {}
    },
    nitrogen_atom = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N}
        },
        bonds = {}
    },
    fluorine_atom = {
        atoms = {
            {element = "F", x = 0, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {}
    }
}

local Molecule = {}
Molecule.__index = Molecule

-- What atoms can combine into
local bondingRules = {
    {atoms = {H = 2}, product = "hydrogen_peroxide", priority = 1}, -- H2 (placeholder as H2O2 for now)
    {atoms = {O = 2}, product = "oxygen", priority = 2},
    {atoms = {F = 2}, product = "fluorine", priority = 2},
    {atoms = {N = 2}, product = "ammonia", priority = 1},

  -- Small atom formation
    {atoms = {H = 2, O = 1}, product = "water", priority = 10},
    {atoms = {C = 1, O = 2}, product = "co2", priority = 8},
    {atoms = {N = 1, H = 3}, product = "ammonia", priority = 7},
    {atoms = {C = 1, H = 4}, product = "methane", priority = 9},
  
  -- Small ion formation
    {atoms = {H = 1, O = 1}, product = "hydroxide", priority = 12},
    {atoms = {O = 1, H = 3}, product = "hydronium", priority = 12}
}

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
        rotationSpeed = (math.random() - 0.5) * 0.5
    }
    setmetatable(mol, Molecule)
    return mol
end

function Molecule:update(dt)
    if not self.alive then return end
    
    if math.abs(self.vx) > WANDER_SPEED * 2 or math.abs(self.vy) > WANDER_SPEED * 2 then
        self.vx = self.vx * 0.95  -- Damping
        self.vy = self.vy * 0.95
    end
    
    self.rotation = self.rotation + self.rotationSpeed * dt
    
    -- Predator behaviors
    if self.type == "oxygen" or self.type == "ozone" or self.type == "chlorine" 
       or self.type == "fluorine" or self.type == "hydrogen_peroxide" or self.type == "sulfuric_acid" 
       or self.type == "hydrochloric_acid" or self.type == "hydronium" then
        local molConfig = config.molecules[self.type]
        local preyTypes = {"methane", "ethylene", "propane", "cyclopropane", "acetylcarnitine", 
                          "ethanol", "benzene", "ammonia", "caffeine", "tnt", "acetone",
                          "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene", "helium_dimer", "tetrafluoroethylene"}
        
        if molConfig.prefersEthylene then
            preyTypes = {"ethylene", "tetrafluoroethylene", "cyclopropane", "benzene", "tnt", "acetylcarnitine", 
                        "methane", "propane", "ethanol", "ammonia", "caffeine", "acetone",
                        "cyclopropenylidene", "cyclobutene", "cyclobutane", "cyclopentane", "helium_dimer"}
        elseif self.type == "fluorine" then
            -- Fluorine is SUPER aggressive, attacks everything including noble gases.
            -- EXCEPT fluorinated compounds like tetrafluoroethylene (resists fluorine)
            preyTypes = {"methane", "ethylene", "propane", "cyclopropane", "acetylcarnitine", 
                        "ethanol", "benzene", "ammonia", "water", "caffeine", "tnt", "acetone",
                        "cyclopropenylidene", "cyclobutane", "cyclopentane", "cyclobutene", "helium_dimer", "helium"}
        elseif self.type == "chlorine" then
            preyTypes = {"methane", "propane", "ethylene", "cyclopropane", "ethanol", 
                        "benzene", "acetylcarnitine", "ammonia", "caffeine", "tnt", "acetone",
                        "cyclobutane", "cyclopentane", "cyclobutene", "cyclopropenylidene", "helium_dimer", "tetrafluoroethylene"}
        elseif self.type == "sulfuric_acid" then
            preyTypes = {"benzene", "tnt", "caffeine", "acetylcarnitine", "ethanol", 
                        "propane", "methane", "cyclopropane", "ethylene", "acetone", "ammonia",
                        "cyclobutane", "cyclopentane", "cyclobutene", "cyclopropenylidene", "helium_dimer", "tetrafluoroethylene"}
        elseif self.type == "hydrochloric_acid" then
            preyTypes = {"methane", "ethylene", "propane", "ethanol", "ammonia",
                        "cyclopropane", "cyclobutane", "cyclopentane", "acetone", "benzene",
                        "cyclopropenylidene", "cyclobutene", "caffeine", "tnt", "acetylcarnitine", "helium_dimer", "tetrafluoroethylene"}
        end
        
        local closest = nil
        local detectionMult = molConfig.detectionMultiplier or 1
        local closestDist = DETECTION_RANGE * detectionMult
        
        for _, mol in ipairs(molecules) do
            for _, preyType in ipairs(preyTypes) do
                if mol.type == preyType and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
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
            local dist = math.sqrt(dx*dx + dy*dy)
            local speedMult = molConfig.speedMultiplier or 1
            local speed = HUNT_SPEED * speedMult
            self.vx = (dx/dist) * speed
            self.vy = (dy/dist) * speed
            
            self.rotationSpeed = 2
            
            -- Attack if close enough
            local damage = molConfig.damage or 50
            if dist < self.radius + closest.radius then
                closest.health = closest.health - damage * dt
                if closest.health <= 0 then
                    closest.alive = false
                end
            end
        else
            -- Wander AI
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.1
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 0.3
        end
        
    -- Cleaner behaviors (hunt CO2 and water)
    elseif self.type == "lithium_hydroxide" or self.type == "sodium_hydroxide"
        or self.type == "hydroxide" then
        local molConfig = config.molecules[self.type]
        local targetTypes = {"co2", "water"}
        local closest = nil
        local detectionMult = molConfig.detectionMultiplier or 1
        local closestDist = DETECTION_RANGE * detectionMult
        
        for _, mol in ipairs(molecules) do
            for _, targetType in ipairs(targetTypes) do
                if mol.type == targetType and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
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
            local dist = math.sqrt(dx*dx + dy*dy)
            local speedMult = molConfig.speedMultiplier or 1
            local speed = HUNT_SPEED * speedMult
            self.vx = (dx/dist) * speed
            self.vy = (dy/dist) * speed
      
            self.rotationSpeed = 1.5
            
            -- "Consume" CO2 or water if close enough
            local damage = molConfig.damage or 40
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
            self.rotationSpeed = 0.5
        end

    elseif self.type == "hydroxide" then
        local targetTypes = {"hydronium", "hydrochloric_acid", "sulfuric_acid"}
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.5
        
        for _, mol in ipairs(molecules) do
            for _, targetType in ipairs(targetTypes) do
                if mol.type == targetType and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
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
            local dist = math.sqrt(dx*dx + dy*dy)
            local speed = HUNT_SPEED * 1.1
            self.vx = (dx/dist) * speed
            self.vy = (dy/dist) * speed
            self.rotationSpeed = 3
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.08
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            self.rotationSpeed = 1.5
        end
        
    elseif self.type == "hydronium" then
        local targetTypes = {"hydroxide", "lithium_hydroxide", "sodium_hydroxide", "ammonia"}
        local closest = nil
        local closestDist = DETECTION_RANGE * 1.3
        
        for _, mol in ipairs(molecules) do
            for _, targetType in ipairs(targetTypes) do
                if mol.type == targetType and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
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
            local dist = math.sqrt(dx*dx + dy*dy)
            local speed = HUNT_SPEED * 1.2
            self.vx = (dx/dist) * speed
            self.vy = (dy/dist) * speed
            self.rotationSpeed = 2.5
        else
            local preyTypes = {"ammonia", "ethanol", "acetone"}
            local nearestPrey = nil
            local nearestPreyDist = DETECTION_RANGE
            
            for _, mol in ipairs(molecules) do
                for _, preyType in ipairs(preyTypes) do
                    if mol.type == preyType and mol.alive then
                        local dx = mol.x - self.x
                        local dy = mol.y - self.y
                        local dist = math.sqrt(dx*dx + dy*dy)
                        
                        if dist < nearestPreyDist then
                            nearestPrey = mol
                            nearestPreyDist = dist
                        end
                    end
                end
            end
            
            if nearestPrey then
                local dx = nearestPrey.x - self.x
                local dy = nearestPrey.y - self.y
                local dist = math.sqrt(dx*dx + dy*dy)
                self.vx = (dx/dist) * (HUNT_SPEED * 0.8)
                self.vy = (dy/dist) * (HUNT_SPEED * 0.8)
                self.rotationSpeed = 2
            else
                self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.07
                self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * 0.9)
                self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * 0.9)
                self.rotationSpeed = 1
            end
        end
        
    -- Prey behaviors
    elseif self.type == "methane" or self.type == "ethylene" or self.type == "propane" 
           or self.type == "cyclopropane" or self.type == "acetylcarnitine" 
           or self.type == "ethanol" or self.type == "benzene" or self.type == "ammonia"
           or self.type == "caffeine" or self.type == "tnt" or self.type == "acetone"
           or self.type == "cyclopropenylidene" or self.type == "cyclobutane" 
           or self.type == "cyclopentane" or self.type == "cyclobutene" or self.type == "helium_dimer" 
          or self.type == "tetrafluoroethylene" then
        local molConfig = config.molecules[self.type]
        local threats = {"oxygen", "ozone", "chlorine", "fluorine", "hydrogen_peroxide", "sulfuric_acid", "hydrochloric_acid"}
        local nearestThreat = nil
        local nearestDist = DETECTION_RANGE
        
        for _, mol in ipairs(molecules) do
            for _, threat in ipairs(threats) do
                if mol.type == threat and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
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
            local dist = math.sqrt(dx*dx + dy*dy)
            local speedMult = molConfig.speedMultiplier or 1
            local speed = FLEE_SPEED * speedMult
            self.vx = (dx/dist) * speed
            self.vy = (dy/dist) * speed
            
            -- Spin faster when fleeing (strained rings spin REALLY fast)
            if self.type == "cyclopropane" or self.type == "cyclopropenylidene" then
                self.rotationSpeed = 5
            elseif self.type == "cyclobutane" or self.type == "cyclobutene" then
                self.rotationSpeed = 4
            elseif self.type == "helium_dimer" then
                self.rotationSpeed = 6
            elseif self.type == "tetrafluoroethylene" then
                self.rotationSpeed = 3
            else
                self.rotationSpeed = 3
            end
        else
            self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.05
            self.vx = math.cos(self.wanderAngle) * WANDER_SPEED
            self.vy = math.sin(self.wanderAngle) * WANDER_SPEED
            
            if self.type == "benzene" then
                self.rotationSpeed = 0.3
            elseif self.type == "tetrafluoroethylene" then
                self.rotationSpeed = 1.0
            elseif self.type == "cyclopropenylidene" then
                self.rotationSpeed = 3
            elseif self.type == "cyclopropane" or self.type == "cyclobutene" then
                self.rotationSpeed = 2
            elseif self.type == "cyclobutane" then
                self.rotationSpeed = 1.5
            elseif self.type == "cyclopentane" then
                self.rotationSpeed = 0.7
            elseif self.type == "helium_dimer" then
                self.rotationSpeed = 3
            else
                self.rotationSpeed = 0.5
            end
        end
        
    elseif self.type == "water" or self.type == "co2" or self.type == "helium" then
        local molConfig = config.molecules[self.type]
        
        if self.type == "helium" then
            local nearestFluorine = nil
            local nearestDist = DETECTION_RANGE
            
            for _, mol in ipairs(molecules) do
                if mol.type == "fluorine" and mol.alive then
                    local dx = mol.x - self.x
                    local dy = mol.y - self.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
                    if dist < nearestDist then
                        nearestFluorine = mol
                        nearestDist = dist
                    end
                end
            end
            
            if nearestFluorine then
                local dx = self.x - nearestFluorine.x
                local dy = self.y - nearestFluorine.y
                local dist = math.sqrt(dx*dx + dy*dy)
                local speed = FLEE_SPEED * 1.5
                self.vx = (dx/dist) * speed
                self.vy = (dy/dist) * speed
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
    
    -- Atom behaviors - wander and try to bond
    elseif self.type == "hydrogen_atom" or self.type == "carbon_atom" or self.type == "oxygen_atom" 
           or self.type == "nitrogen_atom" or self.type == "fluorine_atom" then
        local molConfig = config.molecules[self.type]
        local speedMult = molConfig.speedMultiplier or 1
        self.wanderAngle = self.wanderAngle + (math.random() - 0.5) * 0.1
        self.vx = math.cos(self.wanderAngle) * (WANDER_SPEED * speedMult)
        self.vy = math.sin(self.wanderAngle) * (WANDER_SPEED * speedMult)
        self.rotationSpeed = 4
    end
    
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    
    if self.x < 0 then self.x = WORLD_WIDTH end
    if self.x > WORLD_WIDTH then self.x = 0 end
    if self.y < 0 then self.y = WORLD_HEIGHT end
    if self.y > WORLD_HEIGHT then self.y = 0 end
end

function Molecule:draw()
    if not self.alive then return end
    
    local struct = structures[self.type]
    if not struct then return end
    
    if camera.followTarget == self then
        love.graphics.setColor(1, 1, 0, 0.3)
        love.graphics.circle("fill", self.x, self.y, self.radius + 10)
    end
    
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    
    -- Draw bonds first (so they appear behind atoms)
    love.graphics.setLineWidth(2)
    for _, bond in ipairs(struct.bonds) do
        local atom1 = struct.atoms[bond[1]]
        local atom2 = struct.atoms[bond[2]]
    
     -- Double bond (like O=O or C=C)
        if bond.double then
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.line(atom1.x, atom1.y - 2, atom2.x, atom2.y - 2)
            love.graphics.line(atom1.x, atom1.y + 2, atom2.x, atom2.y + 2)
     -- Resonance bond (like in ozone) - dashed style
        elseif bond.resonance then
            love.graphics.setColor(0.7, 0.5, 0.9, 0.8)
            local steps = 5
            local dx = (atom2.x - atom1.x) / steps
            local dy = (atom2.y - atom1.y) / steps
            for i = 0, steps - 1 do
                if i % 2 == 0 then
                    love.graphics.line(
                        atom1.x + dx * i, atom1.y + dy * i,
                        atom1.x + dx * (i + 1), atom1.y + dy * (i + 1)
                    )
                end
            end
    -- Weak bond (like in helium dimer) - dotted style
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
         -- Single bond
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.line(atom1.x, atom1.y, atom2.x, atom2.y)
        end
    end
    
    -- Draw atoms with special glow effect
    for _, atom in ipairs(struct.atoms) do
        love.graphics.setColor(atom.color)
        local atomSize = atom.element == "H" and 4 or 6
        
        -- Atoms get a glow... only if the molecule IS an atom
        if self.type:match("_atom$") then
            love.graphics.setColor(atom.color[1], atom.color[2], atom.color[3], 0.3)
            love.graphics.circle("fill", atom.x, atom.y, atomSize + 3)
        end
        
        love.graphics.setColor(atom.color)
        love.graphics.circle("fill", atom.x, atom.y, atomSize)
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.circle("line", atom.x, atom.y, atomSize)
    end

    if struct.ion then
        local chargeText = struct.charge > 0 and "+" .. tostring(struct.charge) or tostring(struct.charge)
        local chargeColor = struct.charge > 0 and {1, 0.5, 0.5} or {0.5, 0.5, 1}
        
        love.graphics.setColor(chargeColor)
        love.graphics.print(chargeText, -8, -25)
        
        love.graphics.setColor(chargeColor[1], chargeColor[2], chargeColor[3], 0.2)
        love.graphics.circle("fill", 0, 0, self.radius + 5)
    end
    
    love.graphics.pop()
    
    if love.keyboard.isDown("d") then
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.circle("line", self.x, self.y, DETECTION_RANGE)
    end
end

function love.load()
    love.window.setTitle(config.game.title)
    love.window.setMode(config.game.window.width, config.game.window.height)
    for molType, count in pairs(config.initialSpawns) do
        for i = 1, count do
            table.insert(molecules, Molecule:new(molType, 
                math.random(100, WORLD_WIDTH-100), 
                math.random(100, WORLD_HEIGHT-100)))
        end
    end
    
    -- Center camera
    camera.x = WORLD_WIDTH / 2 - love.graphics.getWidth() / 2
    camera.y = WORLD_HEIGHT / 2 - love.graphics.getHeight() / 2
end

function love.update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local worldX = camera.x + mouseX / camera.zoom
    local worldY = camera.y + mouseY / camera.zoom
    
    hoveredMolecule = nil
    local closestDist = 30 / camera.zoom
    
    for _, mol in ipairs(molecules) do
        if mol.alive then
            local dx = mol.x - worldX
            local dy = mol.y - worldY
            local dist = math.sqrt(dx*dx + dy*dy)
            
            if dist < mol.radius + closestDist then
                hoveredMolecule = mol
                closestDist = dist
            end
        end
    end
    for _, mol in ipairs(molecules) do
        mol:update(dt)
    end
    
    -- Check if nearby atoms can form molecules
    for i = 1, #molecules do
        local mol1 = molecules[i]
     -- Find nearby atoms within bonding distance
        if mol1.alive and mol1.type:match("_atom$") then
            local nearbyAtoms = {mol1}
            local bondingDistance = 25
            
            for j = i + 1, #molecules do
                local mol2 = molecules[j]
                if mol2.alive and mol2.type:match("_atom$") then
                    local dx = mol2.x - mol1.x
                    local dy = mol2.y - mol1.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    
                    if dist < bondingDistance then
                        table.insert(nearbyAtoms, mol2)
                    end
                end
            end
            
            -- If we have multiple atoms nearby, try to bond them
            if #nearbyAtoms >= 2 then
                local atomCounts = {}
                for _, atom in ipairs(nearbyAtoms) do
                    local element = atom.type:match("^(%w+)_atom$")
                    if element then
                        element = element:sub(1, 1):upper() .. element:sub(2)
                        element = element:gsub("Hydrogen", "H"):gsub("Carbon", "C")
                                        :gsub("Oxygen", "O"):gsub("Nitrogen", "N")
                                        :gsub("Fluorine", "F")
                        atomCounts[element] = (atomCounts[element] or 0) + 1
                    end
                end
                
                -- Check bonding rules (sorted by priority)
                table.sort(bondingRules, function(a, b) return a.priority > b.priority end)
                
                for _, rule in ipairs(bondingRules) do
                    local canBond = true
                    local atomsToRemove = {}
                    
                    for element, count in pairs(rule.atoms) do
                        if (atomCounts[element] or 0) < count then
                            canBond = false
                            break
                        end
                    end
                    
                    if canBond then
                        local atomsUsed = {}
                        for element, count in pairs(rule.atoms) do
                            for _, atom in ipairs(nearbyAtoms) do
                                if not atomsUsed[atom] then
                                    local atomElement = atom.type:match("^(%w+)_atom$")
                                    if atomElement then
                                        atomElement = atomElement:sub(1, 1):upper() .. atomElement:sub(2)
                                        atomElement = atomElement:gsub("Hydrogen", "H"):gsub("Carbon", "C")
                                                                :gsub("Oxygen", "O"):gsub("Nitrogen", "N")
                                                                :gsub("Fluorine", "F")
                                        if atomElement == element then
                                            table.insert(atomsToRemove, atom)
                                            atomsUsed[atom] = true
                                            count = count - 1
                                            if count <= 0 then break end
                                        end
                                    end
                                end
                            end
                        end
                        
                        local avgX, avgY = 0, 0
                        for _, atom in ipairs(atomsToRemove) do
                            avgX = avgX + atom.x
                            avgY = avgY + atom.y
                            atom.alive = false
                        end
                        avgX = avgX / #atomsToRemove
                        avgY = avgY / #atomsToRemove
                        
                        table.insert(molecules, Molecule:new(rule.product, avgX, avgY))
                        break  -- Only one bonding per check
                    end
                end
            end
        end
    end

    for i = #molecules, 1, -1 do
        local mol1 = molecules[i]
        if mol1.alive and (mol1.type == "hydroxide" or mol1.type == "hydronium") then
            for j = i + 1, #molecules do
                local mol2 = molecules[j]
                if mol2.alive and 
                   ((mol1.type == "hydroxide" and mol2.type == "hydronium") or 
                    (mol1.type == "hydronium" and mol2.type == "hydroxide")) then
                    
                    local dx = mol2.x - mol1.x
                    local dy = mol2.y - mol1.y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    local neutralizationRange = 30
                    
                    if dist < neutralizationRange then
                        local waterX = (mol1.x + mol2.x) / 2
                        local waterY = (mol1.y + mol2.y) / 2
                        
                        -- Spawn water
                        table.insert(molecules, Molecule:new("water", waterX, waterY))
                        
                        -- Remove the ions
                        mol1.alive = false
                        mol2.alive = false
                        
                        local waterMol = molecules[#molecules]
                        waterMol.vx = (math.random() - 0.5) * 50
                        waterMol.vy = (math.random() - 0.5) * 50
                        
                        break
                    end
                end
            end
        end
    end
    
    -- Remove dead molecules and spawn fragments
    for i = #molecules, 1, -1 do
        if not molecules[i].alive then
            -- Unfollow if tracking this molecule
            if camera.followTarget == molecules[i] then
                camera.followTarget = nil
            end
            
            spawnFragments(molecules[i])
            table.remove(molecules, i)
        end
    end
    
    -- Camera following
    if camera.followTarget and camera.followTarget.alive then
        local targetX = camera.followTarget.x - love.graphics.getWidth() / (2 * camera.zoom)
        local targetY = camera.followTarget.y - love.graphics.getHeight() / (2 * camera.zoom)
        camera.x = camera.x + (targetX - camera.x) * 5 * dt
        camera.y = camera.y + (targetY - camera.y) * 5 * dt
    else
        local camSpeed = config.camera.moveSpeed / camera.zoom
        if love.keyboard.isDown(config.controls.moveLeft) then camera.x = camera.x - camSpeed * dt end
        if love.keyboard.isDown(config.controls.moveRight) then camera.x = camera.x + camSpeed * dt end
        if love.keyboard.isDown(config.controls.moveUp) then camera.y = camera.y - camSpeed * dt end
        if love.keyboard.isDown(config.controls.moveDown) then camera.y = camera.y + camSpeed * dt end
    end
    
    if love.keyboard.isDown(config.controls.zoomIn) or love.keyboard.isDown("=") then
        camera.zoom = math.min(camera.zoom + 1 * dt, camera.maxZoom)
    end
    if love.keyboard.isDown(config.controls.zoomOut) or love.keyboard.isDown("_") then
        camera.zoom = math.max(camera.zoom - 1 * dt, camera.minZoom)
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x * camera.zoom, -camera.y * camera.zoom)
    love.graphics.scale(camera.zoom, camera.zoom)
    
    love.graphics.setColor(config.visual.backgroundColor)
    love.graphics.rectangle("fill", 0, 0, WORLD_WIDTH, WORLD_HEIGHT)
    
    love.graphics.setColor(config.visual.gridColor)
    for x = 0, WORLD_WIDTH, config.visual.gridSize do
        love.graphics.line(x, 0, x, WORLD_HEIGHT)
    end
    for y = 0, WORLD_HEIGHT, config.visual.gridSize do
        love.graphics.line(0, y, WORLD_WIDTH, y)
    end
    
    for _, mol in ipairs(molecules) do
        mol:draw()
    end
    
    love.graphics.pop()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(config.game.title .. " v" .. config.game.version, 10, 10, 0, 1.5, 1.5)
    
    local y = 40
    if config.debug.showFPS then
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, y)
        y = y + 25
    end
    love.graphics.print("Zoom: " .. string.format("%.1f", camera.zoom) .. "x", 10, y)
    y = y + 25
    
    if camera.followTarget and camera.followTarget.alive then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("Following: " .. camera.followTarget.type, 10, y)
        y = y + 20
        love.graphics.setColor(1, 1, 1)
    end
    
    love.graphics.print("Arrow keys: Move  |  +/- : Zoom  |  ESC: Unfollow", 10, y)
    y = y + 20
    love.graphics.print("Middle-click: Focus on molecule", 10, y)
    
    if hoveredMolecule then
        local mouseX, mouseY = love.mouse.getPosition()
        local tooltipX = mouseX + 15
        local tooltipY = mouseY + 15

        local hunts = {}
        local hunted_by = {}
        local consumes = {}
        
        -- Check what this molecule hunts
        if hoveredMolecule.type == "oxygen" or hoveredMolecule.type == "ozone" or hoveredMolecule.type == "chlorine" 
           or hoveredMolecule.type == "fluorine" or hoveredMolecule.type == "hydrogen_peroxide" 
           or hoveredMolecule.type == "sulfuric_acid" or hoveredMolecule.type == "hydrochloric_acid" 
           or hoveredMolecule.type == "hydronium" then
            hunts = {"methane", "ethylene", "propane", "cyclopropane", "benzene", "ammonia", "etc."}
            
            -- Specific prey for hydronium
            if hoveredMolecule.type == "hydronium" then
                hunts = {"hydroxide", "ammonia", "ethanol", "acetone", "bases"}
            end
            
        elseif hoveredMolecule.type == "hydroxide" then
            hunts = {"hydronium", "hydrochloric_acid", "sulfuric_acid", "acids"}
            consumes = {}  -- Hydroxide doesn't consume like cleaners
        elseif hoveredMolecule.type == "lithium_hydroxide" or hoveredMolecule.type == "sodium_hydroxide" then
            consumes = {"CO2", "water"}
        end
        
        -- Check what hunts this molecule
        if hoveredMolecule.type == "methane" or hoveredMolecule.type == "ethylene" or hoveredMolecule.type == "propane"
           or hoveredMolecule.type == "cyclopropane" or hoveredMolecule.type == "benzene" or hoveredMolecule.type == "ammonia"
           or hoveredMolecule.type == "ethanol" or hoveredMolecule.type == "caffeine" or hoveredMolecule.type == "tnt"
           or hoveredMolecule.type == "acetone" or hoveredMolecule.type == "acetylcarnitine"
           or hoveredMolecule.type == "cyclopropenylidene" or hoveredMolecule.type == "cyclobutane"
           or hoveredMolecule.type == "cyclopentane" or hoveredMolecule.type == "cyclobutene"
           or hoveredMolecule.type == "helium_dimer" or hoveredMolecule.type == "tetrafluoroethylene" then
            hunted_by = {"O2", "O3", "Cl2", "F2", "H2O2", "acids"}
        elseif hoveredMolecule.type == "hydroxide" then
            hunted_by = {"hydronium", "acids"}
        elseif hoveredMolecule.type == "hydronium" then
            hunted_by = {"hydroxide", "bases", "LiOH", "NaOH"}
        elseif hoveredMolecule.type == "co2" or hoveredMolecule.type == "water" then
            hunted_by = {"LiOH", "NaOH"}
        elseif hoveredMolecule.type == "helium" then
            hunted_by = {"F2 (only!)"}
        end
        
        local lines = {}
        table.insert(lines, "Type: " .. hoveredMolecule.type)
        table.insert(lines, "Health: " .. math.floor(hoveredMolecule.health) .. "/" .. hoveredMolecule.maxHealth)
        
        if #hunts > 0 then
            table.insert(lines, "Hunts: " .. table.concat(hunts, ", "))
        end
        if #consumes > 0 then
            table.insert(lines, "Consumes: " .. table.concat(consumes, ", "))
        end
        if #hunted_by > 0 then
            table.insert(lines, "Hunted by: " .. table.concat(hunted_by, ", "))
        end
        if hoveredMolecule.type:match("_atom$") then
            table.insert(lines, "Status: Free atom - can bond!")
        end
        
        if hoveredMolecule.type == "hydroxide" then
            table.insert(lines, "Charge: -1 (base)")
        elseif hoveredMolecule.type == "hydronium" then
            table.insert(lines, "Charge: +1 (acid)")
        end
        
        if hoveredMolecule.type == "hydroxide" or hoveredMolecule.type == "hydronium" then
            table.insert(lines, "Neutralizes with opposite ion → H₂O")
        end
        
        local maxWidth = 0
        for _, line in ipairs(lines) do
            local w = love.graphics.getFont():getWidth(line)
            if w > maxWidth then maxWidth = w end
        end
        
        local tooltipWidth = maxWidth + 20
        local tooltipHeight = #lines * 20 + 10
        
  
        if tooltipX + tooltipWidth > love.graphics.getWidth() then
            tooltipX = mouseX - tooltipWidth - 15
        end
        if tooltipY + tooltipHeight > love.graphics.getHeight() then
            tooltipY = mouseY - tooltipHeight - 15
        end
    
        love.graphics.setColor(0.1, 0.1, 0.15, 0.95)
        love.graphics.rectangle("fill", tooltipX, tooltipY, tooltipWidth, tooltipHeight, 5, 5)
        love.graphics.setColor(0.3, 0.3, 0.4)
        love.graphics.rectangle("line", tooltipX, tooltipY, tooltipWidth, tooltipHeight, 5, 5)
        
        love.graphics.setColor(1, 1, 1)
        for i, line in ipairs(lines) do
            love.graphics.print(line, tooltipX + 10, tooltipY + 5 + (i - 1) * 20)
        end
    end
end

spawnFragments = function(molecule)
    local rules = fragmentationRules[molecule.type]
    if not rules then return end
    
    local fragmentCount = 0
    for _, rule in ipairs(rules) do
        fragmentCount = fragmentCount + rule.count
    end
    
    local angleStep = (math.pi * 2) / fragmentCount
    local currentAngle = math.random() * math.pi * 2
    
    for _, rule in ipairs(rules) do
        for i = 1, rule.count do
            local distance = 30 + math.random() * 20
            local x = molecule.x + math.cos(currentAngle) * distance
            local y = molecule.y + math.sin(currentAngle) * distance
            
            local fragment = Molecule:new(rule.type, x, y)
            
            -- Give it explosion velocity
            local explosionSpeed = 80 + math.random() * 40
            fragment.vx = math.cos(currentAngle) * explosionSpeed
            fragment.vy = math.sin(currentAngle) * explosionSpeed
            
            table.insert(molecules, fragment)
            currentAngle = currentAngle + angleStep
        end
    end
end

function love.keypressed(key)
    local spawnX = camera.x + (love.graphics.getWidth()/2) / camera.zoom + math.random(-50, 50)
    local spawnY = camera.y + (love.graphics.getHeight()/2) / camera.zoom + math.random(-50, 50)
    
    for molType, molConfig in pairs(config.molecules) do
        if molConfig.spawnKey and key == molConfig.spawnKey then
            table.insert(molecules, Molecule:new(molType, spawnX, spawnY))
            return
        end
    end
    
    if key == config.controls.resetZoom then
        camera.zoom = config.camera.defaultZoom
    end
    
    if key == "escape" then
        camera.followTarget = nil
    end
end

function love.mousepressed(x, y, button)
    if button == 3 then
        local worldX = camera.x + x / camera.zoom
        local worldY = camera.y + y / camera.zoom
        
        -- Find closest molecule to click
        local closest = nil
        local closestDist = 50 / camera.zoom
        
        for _, mol in ipairs(molecules) do
            if mol.alive then
                local dx = mol.x - worldX
                local dy = mol.y - worldY
                local dist = math.sqrt(dx*dx + dy*dy)
                
                if dist < closestDist and dist < mol.radius + 20 then
                    closest = mol
                    closestDist = dist
                end
            end
        end
        
        if closest then
            if camera.followTarget == closest then
                camera.followTarget = nil
            else
                camera.followTarget = closest
            end
        else
            camera.followTarget = nil
        end
    end
end

function countType(type)
    local count = 0
    for _, mol in ipairs(molecules) do
        if mol.type == type and mol.alive then
            count = count + 1
        end
    end
    return count
end
