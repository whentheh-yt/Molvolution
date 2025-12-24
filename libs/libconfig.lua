local libconfig = {}

-- Time Slider Configuration
libconfig.timeslider = {
    scale = 1.0,
    x = 10,
    y = 780,
    width = 200,
    height = 20,
    min = 0.1,
    max = 3.0,
    
    colors = {
        background = {0.2, 0.2, 0.2},
        slow = {0.3, 0.6, 1.0},      -- Blue for < 1.0x
        normal = {0.5, 0.8, 0.5},     -- Green for 1.0x
        fast = {1.0, 0.5, 0.2},       -- Orange for > 1.0x
        border = {0.5, 0.5, 0.5},
        normalLine = {1, 1, 1, 0.5},
        handle = {1, 1, 1},
        handleBorder = {0.2, 0.2, 0.2},
        text = {1, 1, 1}  -- Added missing text color
    },
    
    text = {
        label = "Time Scale: ",
        format = "%.1fx",
        offsetY = -20,
        helpOffsetY = -10,
        helpText = "Press ` to close | Type 'help' for commands",
        helpScale = 0.8
    }
}

-- Console Configuration
libconfig.console = {
    maxOutput = 10,
    height = 300,
    
    colors = {
        background = {0, 0, 0, 0.9},
        border = {0.3, 0.8, 0.3},
        text = {0.8, 0.8, 0.8},
        prompt = {0.3, 0.8, 0.3},
        input = {1, 1, 1},
        help = {0.5, 0.5, 0.5}
    },
    
    text = {
        prompt = "> ",
        promptOffset = 10,
        inputOffset = 30,
        lineHeight = 20,
        padding = 10,
        helpY = 5,  -- Changed from -10 to 5 to position below console
        helpScale = 0.8,
        helpText = "Press ` to close | Type 'help' for commands"  -- Added here for consistency
    },
    
    keys = {
        toggle = "`",
        toggleAlt = "~",
        submit = "return",
        backspace = "backspace",
        historyUp = "up",
        historyDown = "down",
        close = "escape"
    },
    
    messages = {
        opened = "=== CONSOLE OPENED ===",
        help = "Type 'help' for commands"
    }
}

return libconfig