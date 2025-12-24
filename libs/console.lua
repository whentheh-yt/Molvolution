local libconfig = require("libs/libconfig")
local cfg = libconfig.console

local Console = {}

Console.open = false
Console.input = ""
Console.history = {}
Console.historyIndex = 0
Console.output = {}
Console.maxOutput = cfg.maxOutput

function Console.log(message)
    table.insert(Console.output, message)
    if #Console.output > Console.maxOutput then
        table.remove(Console.output, 1)
    end
end

function Console.draw()
    if not Console.open then return end
    
    local width = love.graphics.getWidth()
    local height = cfg.height
    local y = love.graphics.getHeight() - height
    local colors = cfg.colors
    local text = cfg.text
    
    -- Background
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, y, width, height)
    
    -- Border
    love.graphics.setColor(colors.border)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, y, width, y)
    
    -- Output history
    love.graphics.setColor(colors.text)
    local outputY = y + text.padding
    for i, line in ipairs(Console.output) do
        love.graphics.print(line, text.padding, outputY)
        outputY = outputY + text.lineHeight
    end
    
    -- Input line
    love.graphics.setColor(colors.prompt)
    love.graphics.print(text.prompt, text.padding, y + height - 30)
    love.graphics.setColor(colors.input)
    love.graphics.print(Console.input .. "_", text.inputOffset, y + height - 30)
    
    -- Help hint
    love.graphics.setColor(colors.help)
    love.graphics.print(text.helpText or "Press ` to close | Type 'help' for commands", 
                       text.padding, y + height + text.helpY, 0, text.helpScale, text.helpScale)
end

function Console.textinput(text)
    if Console.open then
        Console.input = Console.input .. text
    end
end

function Console.keypressed(key, context)
    local keys = cfg.keys
    local messages = cfg.messages
    local text = cfg.text  -- ADDED THIS LINE TO FIX THE BUG
    
    if key == keys.toggle or key == keys.toggleAlt then
        Console.open = not Console.open
        if Console.open then
            Console.log(messages.opened)
            Console.log(messages.help)
        end
        return true
    end
    
    if not Console.open then return false end
    
    if key == keys.submit then
        if Console.input ~= "" then
            Console.log(text.prompt .. Console.input)  -- Now 'text' is defined
            Console.execute(Console.input, context)
            table.insert(Console.history, Console.input)
            Console.historyIndex = #Console.history + 1
            Console.input = ""
        end
    elseif key == keys.backspace then
        Console.input = Console.input:sub(1, -2)
    elseif key == keys.historyUp then
        if Console.historyIndex > 1 then
            Console.historyIndex = Console.historyIndex - 1
            Console.input = Console.history[Console.historyIndex] or ""
        end
    elseif key == keys.historyDown then
        if Console.historyIndex <= #Console.history then
            Console.historyIndex = Console.historyIndex + 1
            Console.input = Console.history[Console.historyIndex] or ""
        end
    elseif key == keys.close then
        Console.open = false
    end
    
    return true
end

function Console.execute(command, context)
    local args = {}
    for word in command:gmatch("%S+") do
        table.insert(args, word)
    end
    
    local cmd = args[1]
    if not cmd then return end
    
    if cmd == "help" then
        Console.log("Available commands:")
        Console.log("  help - Show this message")
        Console.log("  clear - Clear console output")
        Console.log("  spawn <type> [count] - Spawn molecules")
        Console.log("  kill <type> - Kill all molecules of type")
        Console.log("  killall - Kill all molecules")
        Console.log("  count [type] - Count molecules")
        Console.log("  zoom <level> - Set camera zoom")
        Console.log("  speed <multiplier> - Set time scale")
        Console.log("  list - List all molecule types")
        
    elseif cmd == "clear" then
        Console.output = {}
        
        elseif cmd == "spawn" then
        local molType = args[2]
        local count = tonumber(args[3]) or 1
        
        if not molType then
            Console.log("Usage: spawn <type> [count] or spawn * [count]")
            return
        end
        
        if molType == "*" then
            local spawned = 0
            local failed = 0
            
            for moleculeType, _ in pairs(context.config.molecules) do
                for i = 1, count do
                    local x = math.random(100, context.config.world.width - 100)
                    local y = math.random(100, context.config.world.height - 100)
                    local mol = context.Molecule:new(moleculeType, x, y)
                    
                    if mol then
                        table.insert(context.molecules, mol)
                        spawned = spawned + 1
                    else
                        failed = failed + 1
                    end
                end
            end
            
            Console.log("Spawned " .. spawned .. " molecules (" .. count .. " of each type)")
            if failed > 0 then
                Console.log("Failed to spawn " .. failed .. " molecules")
            end
            return
        end
        
        if not context.config.molecules[molType] then
            Console.log("Unknown molecule type: " .. molType)
            return
        end
        
        local spawned = 0
        local failed = 0
        
        for i = 1, count do
            local x = math.random(100, context.config.world.width - 100)
            local y = math.random(100, context.config.world.height - 100)
            local mol = context.Molecule:new(molType, x, y)
            
            if mol then
                table.insert(context.molecules, mol)
                spawned = spawned + 1
            else
                failed = failed + 1
            end
        end
        
        Console.log("Spawned " .. spawned .. " " .. molType)
        if failed > 0 then
            Console.log("Failed to spawn " .. failed .. " " .. molType)
        end
        
    elseif cmd == "kill" then
        local molType = args[2]
        
        if not molType then
            Console.log("Usage: kill <type>")
            return
        end
        
        local killed = 0
        for i = #context.molecules, 1, -1 do
            if context.molecules[i].type == molType and context.molecules[i].alive then
                context.molecules[i].alive = false
                killed = killed + 1
            end
        end
        
        Console.log("Killed " .. killed .. " " .. molType .. " molecules")
        
    elseif cmd == "killall" then
        local killed = 0
        for i = #context.molecules, 1, -1 do
            if context.molecules[i].alive then
                context.molecules[i].alive = false
                killed = killed + 1
            end
        end
        Console.log("Killed all " .. killed .. " molecules")
        
    elseif cmd == "count" then
        local molType = args[2]
        
        if molType then
            local count = 0
            for _, mol in ipairs(context.molecules) do
                if mol.type == molType and mol.alive then
                    count = count + 1
                end
            end
            Console.log(molType .. ": " .. count)
        else
            local aliveCount = 0
            for _, mol in ipairs(context.molecules) do
                if mol.alive then
                    aliveCount = aliveCount + 1
                end
            end
            Console.log("Total molecules: " .. aliveCount)
        end
        
    elseif cmd == "zoom" then
        local level = tonumber(args[2])
        
        if not level then
            Console.log("Usage: zoom <level>")
            return
        end
        
        context.camera.zoom = math.max(context.camera.minZoom, math.min(level, context.camera.maxZoom))
        Console.log("Zoom set to " .. context.camera.zoom)
        
    elseif cmd == "speed" then
        local speed = tonumber(args[2])
        
        if not speed then
            Console.log("Usage: speed <multiplier>")
            return
        end
        
        local TimeSlider = require("libs/timeslider")
        TimeSlider.scale = math.max(TimeSlider.min, math.min(speed, TimeSlider.max))
        Console.log("Time scale set to " .. TimeSlider.scale .. "x")
        
    elseif cmd == "list" then
        Console.log("Available molecule types:")
        local types = {}
        for molType, _ in pairs(context.config.molecules) do
            table.insert(types, molType)
        end
        table.sort(types)
        for _, molType in ipairs(types) do
            Console.log("  " .. molType)
        end
        
    else
        Console.log("Unknown command: " .. cmd)
        Console.log("Type 'help' for available commands")
    end
end

return Console