local ELEMENT_COLORS = {
 -- Period 1
    H = {1.0, 1.0, 1.0},           -- Hydrogen: White
		D = {0.9, 0.9, 1.0},           -- Deuterium: Very light blue
		T = {0.8, 1.0, 1.0},           -- Tritium: Light cyan
    He = {0.85, 1.0, 1.0},         -- Helium: Cyan
    
 -- Period 2
    Li = {0.8, 0.5, 1.0},          -- Lithium: Violet
    Be = {0.76, 1.0, 0.0},         -- Beryllium: Dark green
    B = {1.0, 0.71, 0.71},         -- Boron: Peach
    C = {0.56, 0.56, 0.56},        -- Carbon: Grey
    N = {0.19, 0.31, 0.97},        -- Nitrogen: Blue
    O = {1.0, 0.05, 0.05},         -- Oxygen: Red
    F = {0.56, 0.88, 0.31},        -- Fluorine: Green
    Ne = {0.7, 0.89, 0.96},        -- Neon: Very light cyan
    
	-- Period 3
    Na = {0.67, 0.36, 0.95},       -- Sodium: Violet
    Mg = {0.54, 1.0, 0.0},         -- Magnesium: Forest green
    Al = {0.75, 0.65, 0.65},       -- Aluminum: Dark grey
    Si = {0.94, 0.78, 0.63},       -- Silicon: Golden
    P = {1.0, 0.5, 0.0},           -- Phosphorus: Orange
    S = {1.0, 1.0, 0.19},          -- Sulfur: Yellow
    Cl = {0.12, 0.94, 0.12},       -- Chlorine: Green
    Ar = {0.5, 0.82, 0.89},        -- Argon: Medium cyan
    
 -- Period 4
    K = {0.56, 0.25, 0.83},        -- Potassium: Violet
    Ca = {0.24, 1.0, 0.0},         -- Calcium: Dark green
    Sc = {0.9, 0.9, 0.9},          -- Scandium: Light grey
    Ti = {0.75, 0.76, 0.78},       -- Titanium: Grey
    V = {0.65, 0.65, 0.67},        -- Vanadium: Grey
    Cr = {0.54, 0.6, 0.78},        -- Chromium: Steel grey
    Mn = {0.61, 0.48, 0.78},       -- Manganese: Grey violet
    Fe = {0.88, 0.4, 0.2},         -- Iron: Orange
    Co = {0.94, 0.56, 0.63},       -- Cobalt: Pink
    Ni = {0.31, 0.82, 0.31},       -- Nickel: Green
    Cu = {0.78, 0.5, 0.2},         -- Copper: Brown
    Zn = {0.49, 0.5, 0.69},        -- Zinc: Blue grey
    Ga = {0.76, 0.56, 0.56},       -- Gallium: Red grey
    Ge = {0.4, 0.56, 0.56},        -- Germanium: Grey
    As = {0.74, 0.5, 0.89},        -- Arsenic: Violet
    Se = {1.0, 0.63, 0.0},         -- Selenium: Orange
    Br = {0.65, 0.16, 0.16},       -- Bromine: Dark red
    Kr = {0.36, 0.72, 0.82},       -- Krypton: Light cyan
    
 -- Period 5
    Rb = {0.44, 0.18, 0.69},       -- Rubidium: Dark violet
    Sr = {0.0, 1.0, 0.0},          -- Strontium: Bright green
    Y = {0.58, 1.0, 1.0},          -- Yttrium: Cyan
    Zr = {0.58, 0.88, 0.88},       -- Zirconium: Cyan
    Nb = {0.45, 0.76, 0.79},       -- Niobium: Blue grey
    Mo = {0.33, 0.71, 0.71},       -- Molybdenum: Grey cyan
    Tc = {0.23, 0.62, 0.62},       -- Technetium: Dark grey
    Ru = {0.14, 0.56, 0.56},       -- Ruthenium: Teal
    Rh = {0.04, 0.49, 0.55},       -- Rhodium: Steel blue
    Pd = {0.0, 0.41, 0.52},        -- Palladium: Dark teal
    Ag = {0.75, 0.75, 0.75},       -- Silver: Light grey
    Cd = {1.0, 0.85, 0.56},        -- Cadmium: Golden
    In = {0.65, 0.46, 0.45},       -- Indium: Grey
    Sn = {0.4, 0.5, 0.5},          -- Tin: Grey
    Sb = {0.62, 0.39, 0.71},       -- Antimony: Violet
    Te = {0.83, 0.48, 0.0},        -- Tellurium: Orange
    I = {0.58, 0.0, 0.58},         -- Iodine: Dark violet
    Xe = {0.26, 0.62, 0.69},       -- Xenon: Dark cyan
    
 -- Period 6
    Cs = {0.34, 0.09, 0.56},       -- Cesium: Dark violet
    Ba = {0.0, 0.79, 0.0},         -- Barium: Green
    La = {0.44, 0.83, 1.0},        -- Lanthanum: Light blue
    Ce = {1.0, 1.0, 0.78},         -- Cerium: Light yellow
    Pr = {0.85, 1.0, 0.78},        -- Praseodymium: Light green
    Nd = {0.78, 1.0, 0.78},        -- Neodymium: Light green
    Pm = {0.64, 1.0, 0.78},        -- Promethium: Green
    Sm = {0.56, 1.0, 0.78},        -- Samarium: Green
    Eu = {0.38, 1.0, 0.78},        -- Europium: Green
    Gd = {0.27, 1.0, 0.78},        -- Gadolinium: Green
    Tb = {0.19, 1.0, 0.78},        -- Terbium: Green
    Dy = {0.12, 1.0, 0.78},        -- Dysprosium: Green
    Ho = {0.0, 1.0, 0.61},         -- Holmium: Green
    Er = {0.0, 0.9, 0.46},         -- Erbium: Green
    Tm = {0.0, 0.83, 0.32},        -- Thulium: Green
    Yb = {0.0, 0.75, 0.22},        -- Ytterbium: Green
    Lu = {0.0, 0.67, 0.14},        -- Lutetium: Green
    Hf = {0.3, 0.76, 1.0},         -- Hafnium: Light blue
    Ta = {0.3, 0.65, 1.0},         -- Tantalum: Light blue
    W = {0.13, 0.58, 0.84},        -- Tungsten: Steel blue
    Re = {0.15, 0.49, 0.67},       -- Rhenium: Blue grey
    Os = {0.15, 0.4, 0.59},        -- Osmium: Blue grey
    Ir = {0.09, 0.33, 0.53},       -- Iridium: Dark blue
    Pt = {0.82, 0.82, 0.88},       -- Platinum: Light grey
    Au = {1.0, 0.82, 0.14},        -- Gold: Golden
    Hg = {0.72, 0.72, 0.82},       -- Mercury: Light grey
    Tl = {0.65, 0.33, 0.3},        -- Thallium: Brown grey
    Pb = {0.34, 0.35, 0.38},       -- Lead: Dark grey
    Bi = {0.62, 0.31, 0.71},       -- Bismuth: Violet
    Po = {0.67, 0.36, 0.0},        -- Polonium: Brown
    At = {0.46, 0.31, 0.27},       -- Astatine: Dark brown
    Rn = {0.26, 0.51, 0.59},       -- Radon: Dark cyan
    
 -- Period 7
    Fr = {0.26, 0.0, 0.4},         -- Francium: Dark violet
    Ra = {0.0, 0.49, 0.0},         -- Radium: Dark green
    Ac = {0.44, 0.67, 0.98},       -- Actinium: Light blue
    Th = {0.0, 0.73, 1.0},         -- Thorium: Light blue
    Pa = {0.0, 0.63, 1.0},         -- Protactinium: Light blue
    U = {0.0, 0.56, 1.0},          -- Uranium: Light blue
    Np = {0.0, 0.5, 1.0},          -- Neptunium: Light blue
    Pu = {0.0, 0.42, 1.0},         -- Plutonium: Blue
    Am = {0.33, 0.36, 0.95},       -- Americium: Blue violet
    Cm = {0.47, 0.36, 0.89},       -- Curium: Violet
    Bk = {0.54, 0.31, 0.89},       -- Berkelium: Violet
    Cf = {0.63, 0.21, 0.83},       -- Californium: Violet
    Es = {0.7, 0.12, 0.83},        -- Einsteinium: Violet
    Fm = {0.7, 0.12, 0.73},        -- Fermium: Violet
    Md = {0.7, 0.05, 0.65},        -- Mendelevium: Violet
    No = {0.74, 0.05, 0.53},       -- Nobelium: Red violet
    Lr = {0.78, 0.0, 0.4},          -- Lawrencium: Red violet
	
 -- Miscellaneous
	Ps = {1.0, 0.2, 1.0}           -- Positronium: Bright magenta
}

function generateAlkaneStructure(carbonCount)
    local structure = {
        atoms = {},
        bonds = {}
    }
    
    local spacing = 20
    local totalWidth = (carbonCount - 1) * spacing
    local startX = -totalWidth / 2
    
    for i = 1, carbonCount do
        local x = startX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end
    
    for i = 1, carbonCount - 1 do
        table.insert(structure.bonds, {i, i + 1})
    end
    
    local hIndex = carbonCount + 1
    for i = 1, carbonCount do
        local x = startX + (i - 1) * spacing
        local numH = 2
		
        if i == 1 or i == carbonCount then
            numH = 3
        end
        
        if numH == 3 then
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -5 or 5),
                y = -12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -5 or 5),
                y = 12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -10 or 10),
                y = 0,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        else
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = -12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = 12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
    end
    
    return structure
end

function generateCarboxylicAcidStructure(carbonCount)
    local structure = {
        atoms = {},
        bonds = {}
    }
    
    local spacing = 20
    local totalWidth = (carbonCount - 1) * spacing
    local startX = -totalWidth / 2

    for i = 1, carbonCount do
        local x = startX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end

    for i = 1, carbonCount - 1 do
        table.insert(structure.bonds, {i, i + 1})
    end

    local lastCarbonIndex = carbonCount
    local carboxylCarbonIndex = carbonCount + 1
    local lastX = startX + (carbonCount - 1) * spacing

    table.insert(structure.atoms, {
        element = "C",
        x = lastX + 20,
        y = 0,
        color = ELEMENT_COLORS.C
    })
    table.insert(structure.bonds, {lastCarbonIndex, carboxylCarbonIndex})

    table.insert(structure.atoms, {
        element = "O",
        x = lastX + 20,
        y = -15,
        color = ELEMENT_COLORS.O
    })
    table.insert(structure.bonds, {carboxylCarbonIndex, carboxylCarbonIndex + 1, double = true})

    table.insert(structure.atoms, {
        element = "O",
        x = lastX + 32,
        y = 8,
        color = ELEMENT_COLORS.O
    })
    table.insert(structure.bonds, {carboxylCarbonIndex, carboxylCarbonIndex + 2})
    
    table.insert(structure.atoms, {
        element = "H",
        x = lastX + 42,
        y = 8,
        color = ELEMENT_COLORS.H
    })
    table.insert(structure.bonds, {carboxylCarbonIndex + 2, carboxylCarbonIndex + 3})
    
    local hIndex = carboxylCarbonIndex + 4
    for i = 1, carbonCount do
        local x = startX + (i - 1) * spacing
        local numH = 2
        
        if i == 1 then
            numH = 3
        elseif i == carbonCount then
            numH = 0
        end
        
        if numH >= 1 then
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = -12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
        
        if numH >= 2 then
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = 12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
        
        if numH >= 3 then
            table.insert(structure.atoms, {
                element = "H",
                x = x - 10,
                y = 0,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
    end
    
    return structure
end

function generateEsterStructure(leftCarbons, rightCarbons)
    local structure = {
        atoms = {},
        bonds = {}
    }
    
    local spacing = 20
    local leftWidth = (leftCarbons - 1) * spacing
    local startX = -leftWidth / 2 - 20

    for i = 1, leftCarbons do
        local x = startX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end
    
    for i = 1, leftCarbons - 1 do
        table.insert(structure.bonds, {i, i + 1})
    end

    local carbonylIndex = leftCarbons + 1
    local carbonylX = startX + leftCarbons * spacing
    table.insert(structure.atoms, {
        element = "C",
        x = carbonylX,
        y = 0,
        color = ELEMENT_COLORS.C
    })
    table.insert(structure.bonds, {leftCarbons, carbonylIndex})

    table.insert(structure.atoms, {
        element = "O",
        x = carbonylX,
        y = -15,
        color = ELEMENT_COLORS.O
    })
    table.insert(structure.bonds, {carbonylIndex, carbonylIndex + 1, double = true})

    local esterOIndex = carbonylIndex + 2
    table.insert(structure.atoms, {
        element = "O",
        x = carbonylX + 12,
        y = 8,
        color = ELEMENT_COLORS.O
    })
    table.insert(structure.bonds, {carbonylIndex, esterOIndex})

    local rightStartIndex = esterOIndex + 1
    local rightStartX = carbonylX + 24
    for i = 1, rightCarbons do
        local x = rightStartX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end
    
    table.insert(structure.bonds, {esterOIndex, rightStartIndex})
    for i = 1, rightCarbons - 1 do
        table.insert(structure.bonds, {rightStartIndex + i - 1, rightStartIndex + i})
    end

    local hIndex = rightStartIndex + rightCarbons

    for i = 1, leftCarbons do
        local x = startX + (i - 1) * spacing
        local numH = (i == 1) and 3 or 2
        
        if i == 1 then
            table.insert(structure.atoms, {element = "H", x = x - 10, y = 0, color = ELEMENT_COLORS.H})
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
        
        table.insert(structure.atoms, {element = "H", x = x, y = -12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {i, hIndex})
        hIndex = hIndex + 1
        
        table.insert(structure.atoms, {element = "H", x = x, y = 12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {i, hIndex})
        hIndex = hIndex + 1
    end

    for i = 1, rightCarbons do
        local idx = rightStartIndex + i - 1
        local x = rightStartX + (i - 1) * spacing
        local numH = (i == rightCarbons) and 3 or 2
        
        table.insert(structure.atoms, {element = "H", x = x, y = -12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {idx, hIndex})
        hIndex = hIndex + 1
        
        table.insert(structure.atoms, {element = "H", x = x, y = 12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {idx, hIndex})
        hIndex = hIndex + 1
        
        if i == rightCarbons then
            table.insert(structure.atoms, {element = "H", x = x + 10, y = 0, color = ELEMENT_COLORS.H})
            table.insert(structure.bonds, {idx, hIndex})
            hIndex = hIndex + 1
        end
    end
    
    return structure
end

function generateEtherStructure(leftCarbons, rightCarbons)
    local structure = {
        atoms = {},
        bonds = {}
    }
    
    local spacing = 20
    local totalCarbons = leftCarbons + rightCarbons
    local totalWidth = totalCarbons * spacing + 12
    local startX = -totalWidth / 2

    for i = 1, leftCarbons do
        local x = startX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end
    
    for i = 1, leftCarbons - 1 do
        table.insert(structure.bonds, {i, i + 1})
    end

    local oIndex = leftCarbons + 1
    local oX = startX + leftCarbons * spacing
    table.insert(structure.atoms, {
        element = "O",
        x = oX,
        y = 0,
        color = ELEMENT_COLORS.O
    })
    table.insert(structure.bonds, {leftCarbons, oIndex})

    local rightStartIndex = oIndex + 1
    local rightStartX = oX + 12
    for i = 1, rightCarbons do
        local x = rightStartX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "C",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.C
        })
    end
    
    table.insert(structure.bonds, {oIndex, rightStartIndex})
    for i = 1, rightCarbons - 1 do
        table.insert(structure.bonds, {rightStartIndex + i - 1, rightStartIndex + i})
    end

    local hIndex = rightStartIndex + rightCarbons

    for i = 1, leftCarbons do
        local x = startX + (i - 1) * spacing
        local numH = (i == 1) and 3 or 2
        
        if i == 1 then
            table.insert(structure.atoms, {element = "H", x = x - 10, y = 0, color = ELEMENT_COLORS.H})
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
        
        table.insert(structure.atoms, {element = "H", x = x, y = -12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {i, hIndex})
        hIndex = hIndex + 1
        
        table.insert(structure.atoms, {element = "H", x = x, y = 12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {i, hIndex})
        hIndex = hIndex + 1
    end

    for i = 1, rightCarbons do
        local idx = rightStartIndex + i - 1
        local x = rightStartX + (i - 1) * spacing
        local numH = (i == rightCarbons) and 3 or 2
        
        table.insert(structure.atoms, {element = "H", x = x, y = -12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {idx, hIndex})
        hIndex = hIndex + 1
        
        table.insert(structure.atoms, {element = "H", x = x, y = 12, color = ELEMENT_COLORS.H})
        table.insert(structure.bonds, {idx, hIndex})
        hIndex = hIndex + 1
        
        if i == rightCarbons then
            table.insert(structure.atoms, {element = "H", x = x + 10, y = 0, color = ELEMENT_COLORS.H})
            table.insert(structure.bonds, {idx, hIndex})
            hIndex = hIndex + 1
        end
    end
    
    return structure
end

function generateSilaneStructure(siliconCount)
    local structure = {
        atoms = {},
        bonds = {}
    }
    
    local spacing = 22
    local totalWidth = (siliconCount - 1) * spacing
    local startX = -totalWidth / 2

    for i = 1, siliconCount do
        local x = startX + (i - 1) * spacing
        table.insert(structure.atoms, {
            element = "Si",
            x = x,
            y = 0,
            color = ELEMENT_COLORS.Si
        })
    end
    
    for i = 1, siliconCount - 1 do
        table.insert(structure.bonds, {i, i + 1})
    end
    
    local hIndex = siliconCount + 1
    for i = 1, siliconCount do
        local x = startX + (i - 1) * spacing
        local numH = 2
        
        if i == 1 or i == siliconCount then
            numH = 3
        end
        
        if numH == 3 then
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -7 or 7),
                y = -12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -7 or 7),
                y = 12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x + (i == 1 and -14 or 14),
                y = 0,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        else
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = -12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
            
            table.insert(structure.atoms, {
                element = "H",
                x = x,
                y = 12,
                color = ELEMENT_COLORS.H
            })
            table.insert(structure.bonds, {i, hIndex})
            hIndex = hIndex + 1
        end
    end
    
    return structure
end

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
	
	undecane = generateAlkaneStructure(11),
    dodecane = generateAlkaneStructure(12),
    tridecane = generateAlkaneStructure(13),
    tetradecane = generateAlkaneStructure(14),
    pentadecane = generateAlkaneStructure(15),
    hexadecane = generateAlkaneStructure(16),
    heptadecane = generateAlkaneStructure(17),
    octadecane = generateAlkaneStructure(18),
    nonadecane = generateAlkaneStructure(19),
    icosane = generateAlkaneStructure(20),
	
    formic_acid = generateCarboxylicAcidStructure(1),
    acetic_acid = generateCarboxylicAcidStructure(2),
    propionic_acid = generateCarboxylicAcidStructure(3),
    butyric_acid = generateCarboxylicAcidStructure(4),
    valeric_acid = generateCarboxylicAcidStructure(5),
    caproic_acid = generateCarboxylicAcidStructure(6),
	enanthic_acid = generateCarboxylicAcidStructure(7),
    caprylic_acid = generateCarboxylicAcidStructure(8),
    pelargonic_acid = generateCarboxylicAcidStructure(9),
    capric_acid = generateCarboxylicAcidStructure(10),
	
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
    },
	
	xenon = {
        atoms = {{element = "Xe", x = 0, y = 0, color = ELEMENT_COLORS.Xe}},
        bonds = {}
    },
    
    krypton = {
        atoms = {{element = "Kr", x = 0, y = 0, color = ELEMENT_COLORS.Kr}},
        bonds = {}
    },
    
    neon = {
        atoms = {{element = "Ne", x = 0, y = 0, color = ELEMENT_COLORS.Ne}},
        bonds = {}
    },
    
    argon = {
        atoms = {{element = "Ar", x = 0, y = 0, color = ELEMENT_COLORS.Ar}},
        bonds = {}
    },
    
    xenon_atom = {
        atoms = {{element = "Xe", x = 0, y = 0, color = ELEMENT_COLORS.Xe}},
        bonds = {}
    },
    
    krypton_atom = {
        atoms = {{element = "Kr", x = 0, y = 0, color = ELEMENT_COLORS.Kr}},
        bonds = {}
    },
    
    neon_atom = {
        atoms = {{element = "Ne", x = 0, y = 0, color = ELEMENT_COLORS.Ne}},
        bonds = {}
    },
    
    argon_atom = {
        atoms = {{element = "Ar", x = 0, y = 0, color = ELEMENT_COLORS.Ar}},
        bonds = {}
    },
    
    -- NOBLE GAS COMPOUNDS (The forbidden chemistry!)
    xenon_difluoride = {
        atoms = {
            {element = "Xe", x = 0, y = 0, color = ELEMENT_COLORS.Xe},
            {element = "F", x = -18, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 18, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}},
        linear = true,
        noble_gas_compound = true
    },
    
    xenon_tetrafluoride = {
        atoms = {
            {element = "Xe", x = 0, y = 0, color = ELEMENT_COLORS.Xe},
            {element = "F", x = 0, y = -18, color = ELEMENT_COLORS.F},
            {element = "F", x = 18, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 0, y = 18, color = ELEMENT_COLORS.F},
            {element = "F", x = -18, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        square_planar = true,
        noble_gas_compound = true
    },
    
    krypton_difluoride = {
        atoms = {
            {element = "Kr", x = 0, y = 0, color = ELEMENT_COLORS.Kr},
            {element = "F", x = -17, y = 0, color = ELEMENT_COLORS.F},
            {element = "F", x = 17, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}},
        linear = true,
        extremely_unstable = true,
        noble_gas_compound = true
    },
	positronium_hydride = {
        atoms = {
            {element = "Ps", x = -6, y = 0, color = ELEMENT_COLORS.Ps},
            {element = "H", x = 6, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, weak = true}},
        antimatter = true,
        unstable = true
    },
	dipositronium = {
        atoms = {
            {element = "Ps", x = -8, y = 0, color = ELEMENT_COLORS.Ps},
            {element = "Ps", x = 8, y = 0, color = ELEMENT_COLORS.Ps}
        },
        bonds = {{1, 2, weak = true}},  -- VERY weak bond
        antimatter = true,
        unstable = true,
        double_annihilation = true
    },
	
	-- Cubanes
    cubane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 5, color = ELEMENT_COLORS.C},
            {element = "H", x = -18, y = -18, color = ELEMENT_COLORS.H},
            {element = "H", x = 18, y = -18, color = ELEMENT_COLORS.H},
            {element = "H", x = 18, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = -18, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -23, color = ELEMENT_COLORS.H},
            {element = "H", x = 23, y = -23, color = ELEMENT_COLORS.H},
            {element = "H", x = 23, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {5, 6}, {6, 7}, {7, 8}, {8, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
            {1, 9}, {2, 10}, {3, 11}, {4, 12},
            {5, 13}, {6, 14}, {7, 15}, {8, 16}
        },
        extremely_strained = true
    },
    
    octanitrocubane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 5, color = ELEMENT_COLORS.C},
			
            -- NO2 groups instead of H (simplified as single N atoms)
            {element = "N", x = -20, y = -20, color = ELEMENT_COLORS.N},
            {element = "N", x = 20, y = -20, color = ELEMENT_COLORS.N},
            {element = "N", x = 20, y = 20, color = ELEMENT_COLORS.N},
            {element = "N", x = -20, y = 20, color = ELEMENT_COLORS.N},
            {element = "N", x = -12, y = -25, color = ELEMENT_COLORS.N},
            {element = "N", x = 25, y = -25, color = ELEMENT_COLORS.N},
            {element = "N", x = 25, y = 12, color = ELEMENT_COLORS.N},
            {element = "N", x = -12, y = 12, color = ELEMENT_COLORS.N}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {5, 6}, {6, 7}, {7, 8}, {8, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
            {1, 9}, {2, 10}, {3, 11}, {4, 12},
            {5, 13}, {6, 14}, {7, 15}, {8, 16}
        },
        extremely_explosive = true
    },
    hexanitrocubane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 5, color = ELEMENT_COLORS.C},
			
            -- Six NO2 groups (nitro groups as nitrogen atoms)
            {element = "N", x = -20, y = -20, color = ELEMENT_COLORS.N},
            {element = "N", x = 20, y = -20, color = ELEMENT_COLORS.N},
            {element = "N", x = 20, y = 20, color = ELEMENT_COLORS.N},
            {element = "N", x = -12, y = -25, color = ELEMENT_COLORS.N},
            {element = "N", x = 25, y = -25, color = ELEMENT_COLORS.N},
            {element = "N", x = 25, y = 12, color = ELEMENT_COLORS.N},
			
            -- Two remaining hydrogens (on bottom corners)
            {element = "H", x = -20, y = 20, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {5, 6}, {6, 7}, {7, 8}, {8, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
            {1, 9}, {2, 10}, {3, 11}, {5, 12}, {6, 13}, {7, 14},
            {4, 15}, {8, 16}
        },
        extremely_strained = true,
        explosive = true
    },
    
    fluorocubane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 5, color = ELEMENT_COLORS.C},
			
            -- ONE fluorine (top front corner)
            {element = "F", x = -20, y = -20, color = ELEMENT_COLORS.F},
			
            -- Seven hydrogens
            {element = "H", x = 18, y = -18, color = ELEMENT_COLORS.H},
            {element = "H", x = 18, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = -18, y = 18, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = -23, color = ELEMENT_COLORS.H},
            {element = "H", x = 23, y = -23, color = ELEMENT_COLORS.H},
            {element = "H", x = 23, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {5, 6}, {6, 7}, {7, 8}, {8, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
            {1, 9},
            {2, 10}, {3, 11}, {4, 12}, {5, 13}, {6, 14}, {7, 15}, {8, 16}
        },
        extremely_strained = true,
        fluorinated = true
    },
    
    octafluorocubane = {
        atoms = {
            {element = "C", x = -10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -10, y = 10, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -15, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 5, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 5, color = ELEMENT_COLORS.C},
			
            -- Eight fluorines (all corners)
            {element = "F", x = -18, y = -18, color = ELEMENT_COLORS.F},
            {element = "F", x = 18, y = -18, color = ELEMENT_COLORS.F},
            {element = "F", x = 18, y = 18, color = ELEMENT_COLORS.F},
            {element = "F", x = -18, y = 18, color = ELEMENT_COLORS.F},
            {element = "F", x = -10, y = -23, color = ELEMENT_COLORS.F},
            {element = "F", x = 23, y = -23, color = ELEMENT_COLORS.F},
            {element = "F", x = 23, y = 10, color = ELEMENT_COLORS.F},
            {element = "F", x = -10, y = 10, color = ELEMENT_COLORS.F}
        },
        bonds = {
            {1, 2}, {2, 3}, {3, 4}, {4, 1},
            {5, 6}, {6, 7}, {7, 8}, {8, 5},
            {1, 5}, {2, 6}, {3, 7}, {4, 8},
            {1, 9}, {2, 10}, {3, 11}, {4, 12},
            {5, 13}, {6, 14}, {7, 15}, {8, 16}
        },
        extremely_strained = true,
        fluorinated = true,
        inert = true
    },
	
	hydrogen_sulfide = {
        atoms = {
            {element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S},
            {element = "H", x = -10, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}}
    },
    sulfur_trioxide = {
        atoms = {
            {element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S},
            {element = "O", x = 0, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 13, y = 7.5, color = ELEMENT_COLORS.O},
            {element = "O", x = -13, y = 7.5, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}, {1, 4, double = true}}
    },
    phosphoric_acid = {
        atoms = {
            {element = "P", x = 0, y = 0, color = ELEMENT_COLORS.P},
            {element = "O", x = 0, y = -16, color = ELEMENT_COLORS.O},
            {element = "O", x = 16, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = -8, y = 14, color = ELEMENT_COLORS.O},
            {element = "O", x = -8, y = -14, color = ELEMENT_COLORS.O},
            {element = "H", x = 24, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = 22, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = -22, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {1, 3}, {1, 4}, {1, 5}, {3, 6}, {4, 7}, {5, 8}}
    },
    sodium_chloride = {
        atoms = {
            {element = "Na", x = -8, y = 0, color = ELEMENT_COLORS.Na},
            {element = "Cl", x = 8, y = 0, color = ELEMENT_COLORS.Cl}
        },
        bonds = {{1, 2}},
        ionic = true
    },
    potassium_permanganate = {
        atoms = {
            {element = "K", x = 0, y = 20, color = ELEMENT_COLORS.K},
            {element = "Mn", x = 0, y = -5, color = ELEMENT_COLORS.Mn},
            {element = "O", x = 0, y = -18, color = ELEMENT_COLORS.O},
            {element = "O", x = 13, y = -9, color = ELEMENT_COLORS.O},
            {element = "O", x = -13, y = -9, color = ELEMENT_COLORS.O},
            {element = "O", x = 0, y = 8, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 6}, {2, 3, double = true}, {2, 4, double = true}, {2, 5, double = true}, {2, 6}}
    },
    chlorine_trifluoride = {
        atoms = {
            {element = "Cl", x = 0, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "F", x = 0, y = -16, color = ELEMENT_COLORS.F},
            {element = "F", x = 14, y = 8, color = ELEMENT_COLORS.F},
            {element = "F", x = -14, y = 8, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}}
    },
    white_phosphorus = {
        atoms = {
            {element = "P", x = 0, y = -10, color = ELEMENT_COLORS.P},
            {element = "P", x = -10, y = 5, color = ELEMENT_COLORS.P},
            {element = "P", x = 10, y = 5, color = ELEMENT_COLORS.P},
            {element = "P", x = 0, y = 8, color = ELEMENT_COLORS.P}
        },
        bonds = {{1, 2}, {2, 3}, {3, 1}, {1, 4}, {2, 4}, {3, 4}},
        tetrahedral = true
    },
    red_phosphorus = {
        atoms = {
            {element = "P", x = -12, y = 0, color = ELEMENT_COLORS.P},
            {element = "P", x = 0, y = -10, color = ELEMENT_COLORS.P},
            {element = "P", x = 12, y = 0, color = ELEMENT_COLORS.P},
            {element = "P", x = 0, y = 10, color = ELEMENT_COLORS.P}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}, {4, 1}},
        polymeric = true
    },
    sodium_atom = {
        atoms = {{element = "Na", x = 0, y = 0, color = ELEMENT_COLORS.Na}},
        bonds = {}
    },
    potassium_atom = {
        atoms = {{element = "K", x = 0, y = 0, color = ELEMENT_COLORS.K}},
        bonds = {}
    },
    sulfur_atom = {
        atoms = {{element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S}},
        bonds = {}
    },
    phosphorus_atom = {
        atoms = {{element = "P", x = 0, y = 0, color = ELEMENT_COLORS.P}},
        bonds = {}
    },
	
	astatine_atom = {
        atoms = {{element = "At", x = 0, y = 0, color = ELEMENT_COLORS.At}},
        bonds = {},
        radioactive = true
    },
    
    astatine = {
        atoms = {
            {element = "At", x = -10, y = 0, color = ELEMENT_COLORS.At},
            {element = "At", x = 10, y = 0, color = ELEMENT_COLORS.At}
        },
        bonds = {{1, 2}},
        radioactive = true
    },
    
    astatidomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "At", x = 0, y = -20, color = ELEMENT_COLORS.At},
            {element = "H", x = 15, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = 13, color = ELEMENT_COLORS.H},
            {element = "H", x = -7.5, y = -13, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        radioactive = true
    },
    
    diastatidomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "At", x = 0, y = -21, color = ELEMENT_COLORS.At},
            {element = "At", x = 0, y = 21, color = ELEMENT_COLORS.At},
            {element = "H", x = -13, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 13, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        heavy = true,
        radioactive = true
    },
    
    triastatidomethane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "At", x = 0, y = -21, color = ELEMENT_COLORS.At},
            {element = "At", x = 18, y = 10.5, color = ELEMENT_COLORS.At},
            {element = "At", x = -18, y = 10.5, color = ELEMENT_COLORS.At},
            {element = "H", x = 0, y = 18, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        unstable = true,
        heavy = true,
        radioactive = true
    },
    
    carbon_tetrastatide = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "At", x = 0, y = -22, color = ELEMENT_COLORS.At},
            {element = "At", x = 22, y = 0, color = ELEMENT_COLORS.At},
            {element = "At", x = 0, y = 22, color = ELEMENT_COLORS.At},
            {element = "At", x = -22, y = 0, color = ELEMENT_COLORS.At}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}},
        explosive = true,
        unstable = true,
        heavy = true,
        radioactive = true
    },
    
    hydrogen_astatide = {
        atoms = {
            {element = "At", x = 3, y = 0, color = ELEMENT_COLORS.At},
            {element = "H", x = -3, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}},
        radioactive = true
    },
	
	fluoroantimonic_acid = {
        atoms = {
            {element = "H", x = 0, y = -15, color = ELEMENT_COLORS.H},
            {element = "F", x = -12, y = -8, color = ELEMENT_COLORS.F},
            {element = "F", x = 12, y = -8, color = ELEMENT_COLORS.F},
            {element = "Sb", x = 0, y = 5, color = ELEMENT_COLORS.Sb},
            {element = "F", x = -15, y = 12, color = ELEMENT_COLORS.F},
            {element = "F", x = 0, y = 15, color = ELEMENT_COLORS.F},
            {element = "F", x = 15, y = 12, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {2, 4}, {3, 4}, {4, 5}, {4, 6}, {4, 7}},
        superacid = true
    },
	
	glycine = {
        atoms = {
            {element = "N", x = -20, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -26, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -26, y = 8, color = ELEMENT_COLORS.H},
            {element = "C", x = -8, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -8, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -8, y = 12, color = ELEMENT_COLORS.H},
            {element = "C", x = 8, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 16, y = -10, color = ELEMENT_COLORS.O},
            {element = "O", x = 16, y = 10, color = ELEMENT_COLORS.O},
            {element = "H", x = 24, y = 14, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {4, 5}, {4, 6}, {4, 7},
            {7, 8, double = true}, {7, 9}, {9, 10}
        }
    },
    alanine = {
        atoms = {
            {element = "N", x = -24, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -30, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -30, y = 8, color = ELEMENT_COLORS.H},
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -10, y = -12, color = ELEMENT_COLORS.H},
            {element = "C", x = -10, y = 16, color = ELEMENT_COLORS.C},
            {element = "H", x = -18, y = 20, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 26, color = ELEMENT_COLORS.H},
            {element = "H", x = -2, y = 20, color = ELEMENT_COLORS.H},
            {element = "C", x = 6, y = 0, color = ELEMENT_COLORS.C},
            {element = "O", x = 14, y = -10, color = ELEMENT_COLORS.O},
            {element = "O", x = 14, y = 10, color = ELEMENT_COLORS.O},
            {element = "H", x = 22, y = 14, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {4, 5}, {4, 6}, {6, 7}, {6, 8}, {6, 9},
            {4, 10}, {10, 11, double = true}, {10, 12}, {12, 13}
        }
    },
	
	boron_atom = {
        atoms = {{element = "B", x = 0, y = 0, color = ELEMENT_COLORS.B}},
        bonds = {}
    },
    
    diborane = {  -- B2H6
        atoms = {
            {element = "B", x = -10, y = 0, color = ELEMENT_COLORS.B},
            {element = "B", x = 10, y = 0, color = ELEMENT_COLORS.B},
            {element = "H", x = -15, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = -15, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 3}, {1, 4}, {2, 5}, {2, 6},
            {1, 7}, {2, 7}, -- Three-center bonds
            {1, 8}, {2, 8}
        },
        pyrophoric = true,
        three_center_bonds = true
    },
    
    tetrahydrodiborane = {  -- B2H4
        atoms = {
            {element = "B", x = -10, y = 0, color = ELEMENT_COLORS.B},
            {element = "B", x = 10, y = 0, color = ELEMENT_COLORS.B},
            {element = "H", x = -18, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -18, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 3}, {1, 4},
            {1, 5}, {2, 5}, -- Three-center bond
            {1, 6}, {2, 6}
        },
        pyrophoric = true,
        extremely_unstable = true
    },
    
    dihydrodiborane = {  -- B2H2
        atoms = {
            {element = "B", x = -10, y = 0, color = ELEMENT_COLORS.B},
            {element = "B", x = 10, y = 0, color = ELEMENT_COLORS.B},
            {element = "H", x = 0, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = 8, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2},
            {1, 3}, {2, 3}, -- Three-center bond
            {1, 4}, {2, 4}
        },
        pyrophoric = true,
        extremely_unstable = true
    },
    
    boron_trifluoride = {
        atoms = {
            {element = "B", x = 0, y = 0, color = ELEMENT_COLORS.B},
            {element = "F", x = 0, y = -16, color = ELEMENT_COLORS.F},
            {element = "F", x = 14, y = 8, color = ELEMENT_COLORS.F},
            {element = "F", x = -14, y = 8, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        trigonal_planar = true,
        lewis_acid = true
    },
    
    boron_trichloride = {
        atoms = {
            {element = "B", x = 0, y = 0, color = ELEMENT_COLORS.B},
            {element = "Cl", x = 0, y = -17, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 15, y = 8.5, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = -15, y = 8.5, color = ELEMENT_COLORS.Cl}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        trigonal_planar = true,
        lewis_acid = true
    },
    
    borax = {
        atoms = {
            {element = "Na", x = -20, y = -15, color = ELEMENT_COLORS.Na},
            {element = "Na", x = -20, y = 15, color = ELEMENT_COLORS.Na},
            {element = "B", x = 0, y = -10, color = ELEMENT_COLORS.B},
            {element = "B", x = 0, y = 10, color = ELEMENT_COLORS.B},
            {element = "O", x = -10, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = -10, y = 15, color = ELEMENT_COLORS.O},
            {element = "O", x = 10, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 10, y = 15, color = ELEMENT_COLORS.O},
            {element = "O", x = 20, y = 0, color = ELEMENT_COLORS.O},
            {element = "H", x = 30, y = -5, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 5, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 5}, {2, 6}, {3, 5}, {3, 7}, {4, 6}, {4, 8},
            {3, 4}, {7, 9}, {8, 9}, {9, 10}, {9, 11}
        },
        salt = true
    },
    
    boric_acid = {
        atoms = {
            {element = "B", x = 0, y = 0, color = ELEMENT_COLORS.B},
            {element = "O", x = 0, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 13, y = 7.5, color = ELEMENT_COLORS.O},
            {element = "O", x = -13, y = 7.5, color = ELEMENT_COLORS.O},
            {element = "H", x = 0, y = -25, color = ELEMENT_COLORS.H},
            {element = "H", x = 22, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -22, y = 12, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {2, 5}, {3, 6}, {4, 7}},
        weak_acid = true
    },
	propylene = {
        atoms = {
            {element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -20, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 0, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {2, 3}, {1, 4}, {1, 5}, {2, 6}, {3, 7}, {3, 8}}
    },
    
    butene = {
        atoms = {
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 25, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -25, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -5, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 10, y = -12, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, double = true}, {2, 3}, {3, 4}, {1, 5}, {1, 6}, {2, 7}, {3, 8}, {4, 9}, {4, 10}}
    },
    
    acetylene = {
        atoms = {
            {element = "C", x = -10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -20, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 20, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2, triple = true}, {1, 3}, {2, 4}}
    },
    
    propyne = {
        atoms = {
            {element = "C", x = -15, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -20, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3, triple = true}, {1, 4}, {1, 5}, {1, 6}, {3, 7}}
    },
    
    butyne = {
        atoms = {
            {element = "C", x = -20, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = -5, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 10, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 25, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -25, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 30, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 35, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {2, 3, triple = true}, {3, 4}, {1, 5}, {1, 6}, {1, 7}, {4, 8}, {4, 9}, {4, 10}}
    },
	
	nitrogen_triiodide = {
        atoms = {
            {element = "N", x = 0, y = 0, color = ELEMENT_COLORS.N},
            {element = "I", x = 0, y = -22, color = ELEMENT_COLORS.I},
            {element = "I", x = 19, y = 11, color = ELEMENT_COLORS.I},
            {element = "I", x = -19, y = 11, color = ELEMENT_COLORS.I}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}},
        extremely_unstable = true,
        explosive = true
    },
    
    dioxygen_difluoride = {
        atoms = {
            {element = "F", x = -20, y = 0, color = ELEMENT_COLORS.F},
            {element = "O", x = -8, y = 0, color = ELEMENT_COLORS.O},
            {element = "O", x = 8, y = 0, color = ELEMENT_COLORS.O},
            {element = "F", x = 20, y = 0, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {2, 3}, {3, 4}},
        worse_than_foof = true
    },
    
    chlorine_pentafluoride = {
        atoms = {
            {element = "Cl", x = 0, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "F", x = 0, y = -18, color = ELEMENT_COLORS.F},
            {element = "F", x = 17, y = -6, color = ELEMENT_COLORS.F},
            {element = "F", x = 11, y = 15, color = ELEMENT_COLORS.F},
            {element = "F", x = -11, y = 15, color = ELEMENT_COLORS.F},
            {element = "F", x = -17, y = -6, color = ELEMENT_COLORS.F}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}},
        square_pyramidal = true
    },
    
    hydrazine = {
        atoms = {
            {element = "N", x = -6, y = 0, color = ELEMENT_COLORS.N},
            {element = "N", x = 6, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -12, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -12, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = 12, y = 10, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {2, 5}, {2, 6}}
    },
    
    dimethylmercury = {
        atoms = {
            {element = "Hg", x = 0, y = 0, color = ELEMENT_COLORS.Hg},
            {element = "C", x = -18, y = 0, color = ELEMENT_COLORS.C},
            {element = "C", x = 18, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = -25, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = -25, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = -28, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = -8, color = ELEMENT_COLORS.H},
            {element = "H", x = 25, y = 8, color = ELEMENT_COLORS.H},
            {element = "H", x = 28, y = 0, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {2, 4}, {2, 5}, {2, 6}, {3, 7}, {3, 8}, {3, 9}}
    },
    
    chlorine_dioxide = {
        atoms = {
            {element = "Cl", x = 0, y = 0, color = ELEMENT_COLORS.Cl},
            {element = "O", x = -12, y = -8, color = ELEMENT_COLORS.O},
            {element = "O", x = 12, y = -8, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2, double = true}, {1, 3, double = true}},
        bent = true
    },
    
    sulfur_mustard = {
        atoms = {
            {element = "S", x = 0, y = 0, color = ELEMENT_COLORS.S},
            {element = "C", x = -15, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = 15, y = -10, color = ELEMENT_COLORS.C},
            {element = "C", x = -25, y = -18, color = ELEMENT_COLORS.C},
            {element = "C", x = 25, y = -18, color = ELEMENT_COLORS.C},
            {element = "Cl", x = -35, y = -25, color = ELEMENT_COLORS.Cl},
            {element = "Cl", x = 35, y = -25, color = ELEMENT_COLORS.Cl},
            {element = "H", x = -15, y = 2, color = ELEMENT_COLORS.H},
            {element = "H", x = 15, y = 2, color = ELEMENT_COLORS.H}
        },
        bonds = {{1, 2}, {1, 3}, {2, 4}, {3, 5}, {4, 6}, {5, 7}, {2, 8}, {3, 9}}
    },
    
    ammonium_nitrate = {
        atoms = {
            {element = "N", x = -15, y = 0, color = ELEMENT_COLORS.N},
            {element = "H", x = -20, y = -10, color = ELEMENT_COLORS.H},
            {element = "H", x = -20, y = 10, color = ELEMENT_COLORS.H},
            {element = "H", x = -27, y = 0, color = ELEMENT_COLORS.H},
            {element = "H", x = -10, y = 0, color = ELEMENT_COLORS.H},
            {element = "N", x = 15, y = 0, color = ELEMENT_COLORS.N},
            {element = "O", x = 15, y = -15, color = ELEMENT_COLORS.O},
            {element = "O", x = 25, y = 8, color = ELEMENT_COLORS.O},
            {element = "O", x = 5, y = 8, color = ELEMENT_COLORS.O}
        },
        bonds = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {6, 7, double = true}, {6, 8, double = true}, {6, 9}},
        ionic = true
    },
	protonated_methane = {
        atoms = {
            {element = "C", x = 0, y = 0, color = ELEMENT_COLORS.C},
            {element = "H", x = 0, y = -15, color = ELEMENT_COLORS.H},
            {element = "H", x = 14, y = -5, color = ELEMENT_COLORS.H},
            {element = "H", x = 9, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -9, y = 12, color = ELEMENT_COLORS.H},
            {element = "H", x = -14, y = -5, color = ELEMENT_COLORS.H}
        },
        bonds = {
            {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}
        },
        ion = true,
        charge = 1,
        fluxional = true,
        interstellar = true
    },
	methyl_formate = generateEsterStructure(1, 1),
    ethyl_acetate = generateEsterStructure(2, 2),
    methyl_acetate = generateEsterStructure(2, 1),
    propyl_propanoate = generateEsterStructure(3, 3),
    butyl_acetate = generateEsterStructure(2, 4),

    dimethyl_ether = generateEtherStructure(1, 1),
    diethyl_ether = generateEtherStructure(2, 2),
    methyl_ethyl_ether = generateEtherStructure(1, 2),
    dipropyl_ether = generateEtherStructure(3, 3),
    dibutyl_ether = generateEtherStructure(4, 4),

    silane = generateSilaneStructure(1),
    disilane = generateSilaneStructure(2),
    trisilane = generateSilaneStructure(3),
    tetrasilane = generateSilaneStructure(4),
    pentasilane = generateSilaneStructure(5),
    
    silicon_atom = {
        atoms = {{element = "Si", x = 0, y = 0, color = ELEMENT_COLORS.Si}},
        bonds = {}
    },
}

return {
    ELEMENT_COLORS = ELEMENT_COLORS,
    structures = structures
}