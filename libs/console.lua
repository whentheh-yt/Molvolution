local libconfig = require("libs/libconfig")
local cfg = libconfig.console

local Console = {}

Console.open = false
Console.input = ""
Console.history = {}
Console.historyIndex = 0
Console.output = {}
Console.maxOutput = cfg.maxOutput
Console.rxnMode = false
Console.variables = {}

function Console.parseRXN(contents)
    contents = contents:gsub(":=:.-:=:", "")
    
    local lines = {}
    for line in contents:gmatch("[^\r\n]+") do
        line = line:gsub("%-%-.*$", "")
        line = line:match("^%s*(.-)%s*$")
        
        if line ~= "" then
            table.insert(lines, line)
        end
    end
    
    return lines
end

function Console.executeRXN(filename, context)
    if not love.filesystem.getInfo(filename) then
        Console.log("File not found: " .. filename)
        Console.log("Place .rxn files in: " .. love.filesystem.getSaveDirectory())
        return
    end
    
    local contents = love.filesystem.read(filename)
    local lines = Console.parseRXN(contents)
    
    Console.log("=== Executing: " .. filename .. " ===")
    Console.rxnMode = true
    
    for i, line in ipairs(lines) do
        Console.execute(line, context)
    end
    
    Console.rxnMode = false
    Console.log("=== Script complete! ===")
end

function Console.exportRXN(filename, context)
    local content = {}
    
    table.insert(content, ":=:")
    table.insert(content, "Auto-generated Molvolution snapshot")
    table.insert(content, "Created: " .. os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(content, "Total molecules: " .. #context.molecules)
    table.insert(content, ":=:")
    table.insert(content, "")
    
    table.insert(content, "-- Camera settings")
    table.insert(content, string.format("zoom %.2f", context.camera.zoom))
    table.insert(content, "")
    
    local TimeSlider = require("libs/timeslider")
    table.insert(content, "-- Time scale")
    table.insert(content, string.format("speed %.2f", TimeSlider.scale))
    table.insert(content, "")
    
    local counts = {}
    for _, mol in ipairs(context.molecules) do
        if mol.alive then
            counts[mol.type] = (counts[mol.type] or 0) + 1
        end
    end
    
    table.insert(content, "-- Molecules")
    local types = {}
    for molType, _ in pairs(counts) do
        table.insert(types, molType)
    end
    table.sort(types)
    
    for _, molType in ipairs(types) do
        table.insert(content, string.format("spawn %s %d", molType, counts[molType]))
    end
    
    local success = love.filesystem.write(filename, table.concat(content, "\n"))
    
    if success then
        Console.log("Exported to: " .. filename)
        Console.log("Location: " .. love.filesystem.getSaveDirectory())
    else
        Console.log("Failed to export file")
    end
end

function Console.createRXN(filename)
    local template = [[
:=:
RXN Script Template
Created: ]] .. os.date("%Y-%m-%d %H:%M:%S") .. [[

Author: Your Name
Description: Describe what this script does
:=:

-- Settings
speed 1.0
zoom 1.0

-- Spawn some molecules
spawn methane 10
spawn oxygen 10

-- Your code here...
]]

    local success = love.filesystem.write(filename, template)
    
    if success then
        Console.log("Created: " .. filename)
        Console.log("Location: " .. love.filesystem.getSaveDirectory())
        Console.log("Edit it and run with: run " .. filename)
    else
        Console.log("Failed to create file")
    end
end

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
    
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, y, width, height)
    love.graphics.setColor(colors.border)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, y, width, y)
    
    love.graphics.setColor(colors.text)
    local outputY = y + text.padding
    for i, line in ipairs(Console.output) do
        love.graphics.print(line, text.padding, outputY)
        outputY = outputY + text.lineHeight
    end
    
    love.graphics.setColor(colors.prompt)
    love.graphics.print(text.prompt, text.padding, y + height - 30)
    love.graphics.setColor(colors.input)
    love.graphics.print(Console.input .. "_", text.inputOffset, y + height - 30)
    
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
    local text = cfg.text  -- ADDED THIS LINE TO FIX THE GODDAMN BUG THATS BEEN ANNOYING ME FOR FUCKING DAYS
    
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
        Console.log("  list [category] - List molecule types")
        Console.log("  find <type> - Highlight molecules")
        Console.log("  freeze - Toggle pause")
        Console.log("  explode <x> <y> <radius> - Detonate area")
        Console.log("  nuke - Kill 90% of molecules")
        Console.log("  stats - Show detailed statistics")
        
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
        local clearFragments = args[2] == "-c"
        local killed = 0
        
        for i = #context.molecules, 1, -1 do
            if context.molecules[i].alive then
                if clearFragments then
                    if context.camera.followTarget == context.molecules[i] then
                        context.camera.followTarget = nil
                    end
                    table.remove(context.molecules, i)
                else
                    context.molecules[i].alive = false
                end
                killed = killed + 1
            end
        end
        
        Console.log("Killed all " .. killed .. " molecules" .. 
                    (clearFragments and " (no fragments)" or ""))
    
    elseif cmd == "wait" then
        if not Console.rxnMode then
            Console.log("'wait' command only works in RXN scripts")
            return
        end
        
        local seconds = tonumber(args[2]) or 1
        love.timer.sleep(seconds)
        Console.log("Waited " .. seconds .. " seconds")
    
    elseif cmd == "until" then
        if not Console.rxnMode then
            Console.log("'until' command only works in RXN scripts")
            return
        end
        
        local countCmd = args[2]
        local molType = args[3]
        local operator = args[4]
        local threshold = tonumber(args[5])
        
        if countCmd ~= "count" or not operator or not threshold then
            Console.log("Usage: until count <type> <operator> <value>")
            Console.log("Example: until count oxygen > 10")
            return
        end
        
        local maxWait = 30
        local elapsed = 0
        local checkInterval = 0.1
        
        while elapsed < maxWait do
            local count = 0
            if molType == "*" then
                for _, mol in ipairs(context.molecules) do
                    if mol.alive then count = count + 1 end
                end
            else
                for _, mol in ipairs(context.molecules) do
                    if mol.type == molType and mol.alive then
                        count = count + 1
                    end
                end
            end
            
            local conditionMet = false
            if operator == ">" then conditionMet = count > threshold
            elseif operator == "<" then conditionMet = count < threshold
            elseif operator == "=" or operator == "==" then conditionMet = count == threshold
            elseif operator == ">=" then conditionMet = count >= threshold
            elseif operator == "<=" then conditionMet = count <= threshold
            end
            
            if conditionMet then
                Console.log("Condition met: count " .. molType .. " " .. operator .. " " .. threshold)
                return
            end
            
            love.timer.sleep(checkInterval)
            elapsed = elapsed + checkInterval
        end
        
        Console.log("Timeout: condition not met after " .. maxWait .. " seconds")
    
    elseif cmd == "repeat" then
        if not Console.rxnMode then
            Console.log("'repeat' command only works in RXN scripts")
            return
        end
        
        Console.log("Note: 'repeat' requires multi-line parsing - use 'cycle' in future version")
    
    elseif cmd == "let" then
        if not Console.rxnMode then
            Console.log("'let' command only works in RXN scripts")
            return
        end
        
        local varName = args[2]
        local equals = args[3]
        
        if not varName or equals ~= "=" then
            Console.log("Usage: let varname = value")
            return
        end
        
        local value = table.concat(args, " ", 4)
        
        if value:match("^count ") then
            local molType = value:match("^count (.+)")
            local count = 0
            for _, mol in ipairs(context.molecules) do
                if mol.type == molType and mol.alive then
                    count = count + 1
                end
            end
            Console.variables[varName] = count
            Console.log("let " .. varName .. " = " .. count)
        else
            local num = tonumber(value)
            if num then
                Console.variables[varName] = num
            else
                Console.variables[varName] = value
            end
            Console.log("let " .. varName .. " = " .. value)
        end
        
    elseif cmd == "spawn" then
        local molType = args[2]
        local count = tonumber(args[3]) or 1
        
        if Console.rxnMode and molType and molType:match("^%$") then
            local varName = molType:sub(2)  -- Remove $
            molType = Console.variables[varName]
        end
        if Console.rxnMode and type(count) == "string" and count:match("^%$") then
            local varName = count:sub(2)
            count = tonumber(Console.variables[varName]) or 1
        end
        
        local atIndex = nil
        for i, arg in ipairs(args) do
            if arg == "at" then
                atIndex = i
                break
            end
        end
        
        if molType == "*" then
            local spawned = 0
            local failed = 0
            
            for moleculeType, _ in pairs(context.config.molecules) do
                for i = 1, count do
                    local x, y
                    if atIndex then
                        local locType = args[atIndex + 1]
                        if locType == "center" then
                            x = context.config.world.width / 2
                            y = context.config.world.height / 2
                        elseif locType == "random" then
                            x = math.random(100, context.config.world.width - 100)
                            y = math.random(100, context.config.world.height - 100)
                        elseif locType == "circle" then
                            local cx = tonumber(args[atIndex + 2]) or 500
                            local cy = tonumber(args[atIndex + 3]) or 500
                            local radius = tonumber(args[atIndex + 4]) or 100
                            local angle = math.random() * math.pi * 2
                            local dist = math.random() * radius
                            x = cx + math.cos(angle) * dist
                            y = cy + math.sin(angle) * dist
                        elseif locType == "grid" then
                            local sx = tonumber(args[atIndex + 2]) or 100
                            local sy = tonumber(args[atIndex + 3]) or 100
                            local spacing = tonumber(args[atIndex + 4]) or 50
                            x = sx + (i % 10) * spacing
                            y = sy + math.floor(i / 10) * spacing
                        else
                            x = tonumber(args[atIndex + 1]) or math.random(100, context.config.world.width - 100)
                            y = tonumber(args[atIndex + 2]) or math.random(100, context.config.world.height - 100)
                        end
                    else
                        x = math.random(100, context.config.world.width - 100)
                        y = math.random(100, context.config.world.height - 100)
                    end
                    
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
        
        if not molType then
            Console.log("Usage: spawn <type> [count] [at <location>]")
            return
        end
        
        if not context.config.molecules[molType] then
            Console.log("Unknown molecule type: " .. molType)
            return
        end
        
        local spawned = 0
        local failed = 0
        
        for i = 1, count do
            local x, y
            if atIndex then
                local locType = args[atIndex + 1]
                if locType == "center" then
                    x = context.config.world.width / 2
                    y = context.config.world.height / 2
                elseif locType == "random" then
                    x = math.random(100, context.config.world.width - 100)
                    y = math.random(100, context.config.world.height - 100)
                elseif locType == "circle" then
                    local cx = tonumber(args[atIndex + 2]) or 500
                    local cy = tonumber(args[atIndex + 3]) or 500
                    local radius = tonumber(args[atIndex + 4]) or 100
                    local angle = math.random() * math.pi * 2
                    local dist = math.random() * radius
                    x = cx + math.cos(angle) * dist
                    y = cy + math.sin(angle) * dist
                elseif locType == "grid" then
                    local sx = tonumber(args[atIndex + 2]) or 100
                    local sy = tonumber(args[atIndex + 3]) or 100
                    local spacing = tonumber(args[atIndex + 4]) or 50
                    x = sx + ((i - 1) % 10) * spacing
                    y = sy + math.floor((i - 1) / 10) * spacing
                else
                    x = tonumber(args[atIndex + 1]) or math.random(100, context.config.world.width - 100)
                    y = tonumber(args[atIndex + 2]) or math.random(100, context.config.world.height - 100)
                end
            else
                x = math.random(100, context.config.world.width - 100)
                y = math.random(100, context.config.world.height - 100)
            end
            
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
    
    elseif cmd == "alert" then
        if not Console.rxnMode then
            Console.log("'alert' command only works in RXN scripts")
            return
        end
        
        local message = table.concat(args, " ", 2)
        Console.log(">>> " .. message .. " <<<")
            
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
        local category = args[2]
        
        if category == "acids" then
            Console.log("Acids: nitric_acid, sulfuric_acid, hydrochloric_acid, perchloric_acid, phosphoric_acid, hydrogen_fluoride, carbonic_acid, formic_acid")
        elseif category == "bases" then
            Console.log("Bases: ammonia, hydroxide, lithium_hydroxide, sodium_hydroxide")
        elseif category == "halogens" then
            Console.log("Halogens: fluorine, chlorine, bromine, iodine")
        elseif category == "noble" then
            Console.log("Noble gases: helium, neon, argon, krypton, xenon")
        elseif category == "radioactive" then
            Console.log("Radioactive: polonium_atom, radium_atom, plutonium_atom, uranium_atom, tritium, radon, strontium_90, cesium_137, uranyl, uranium_hexafluoride")
        elseif category == "explosive" then
            Console.log("Explosives: tnt, nitroglycerin, carbon_tetraiodide, azidoazide_azide, foof")
        else
            Console.log("Categories: acids, bases, halogens, noble, radioactive, explosive")
            Console.log("Or use 'list' without arguments for all types:")
            local types = {}
            for molType, _ in pairs(context.config.molecules) do
                table.insert(types, molType)
            end
            table.sort(types)
            local count = 0
            local line = "  "
            for _, molType in ipairs(types) do
                if count > 0 and count % 5 == 0 then
                    Console.log(line)
                    line = "  "
                end
                line = line .. molType .. ", "
                count = count + 1
            end
            if line ~= "  " then
                Console.log(line:sub(1, -3))
            end
        end
        
    elseif cmd == "find" then
        local molType = args[2]
        if not molType then
            Console.log("Usage: find <type>")
            return
        end
        
        local found = 0
        for _, mol in ipairs(context.molecules) do
            if mol.type == molType and mol.alive then
                found = found + 1
            end
        end
        Console.log("Found " .. found .. " " .. molType .. " molecules")
        -- TODO: Add visual highlighting
        
    elseif cmd == "freeze" then
        context.frozen = not context.frozen
        Console.log(context.frozen and "Simulation frozen" or "Simulation resumed")
        
    elseif cmd == "explode" then
        local x = tonumber(args[2])
        local y = tonumber(args[3])
        local radius = tonumber(args[4]) or 100
        
        if not x or not y then
            Console.log("Usage: explode <x> <y> [radius]")
            return
        end
        
        local killed = 0
        for i = #context.molecules, 1, -1 do
            local mol = context.molecules[i]
            if mol.alive then
                local dx = mol.x - x
                local dy = mol.y - y
                local dist = math.sqrt(dx * dx + dy * dy)
                if dist < radius then
                    mol.alive = false
                    killed = killed + 1
                end
            end
        end
        Console.log("Explosion at (" .. x .. ", " .. y .. ") killed " .. killed .. " molecules")
        
    elseif cmd == "nuke" then
        local killed = 0
        local total = 0
        for i = #context.molecules, 1, -1 do
            if context.molecules[i].alive then
                total = total + 1
                if math.random() < 0.9 then
                    context.molecules[i].alive = false
                    killed = killed + 1
                end
            end
        end
        Console.log("Nuclear annihilation: " .. killed .. "/" .. total .. " molecules destroyed")
        
    elseif cmd == "stats" then
        local stats = {}
        local total = 0
        for _, mol in ipairs(context.molecules) do
            if mol.alive then
                total = total + 1
                stats[mol.type] = (stats[mol.type] or 0) + 1
            end
        end
        
        Console.log("=== STATISTICS ===")
        Console.log("Total alive: " .. total)
        
        local sorted = {}
        for molType, count in pairs(stats) do
            table.insert(sorted, {type = molType, count = count})
        end
        table.sort(sorted, function(a, b) return a.count > b.count end)
        
        Console.log("Top 5:")
        for i = 1, math.min(5, #sorted) do
            Console.log("  " .. sorted[i].type .. ": " .. sorted[i].count)
        end
	elseif cmd == "run" then
        local filename = args[2]
        if not filename then
            Console.log("Usage: run <file.rxn>")
            return
        end
        
        if not filename:match("%.rxn$") then
            filename = filename .. ".rxn"
        end
        
        Console.executeRXN(filename, context)
    elseif cmd == "export" then
        local filename = args[2] or "snapshot.rxn"
        if not filename:match("%.rxn$") then
            filename = filename .. ".rxn"
        end
        
        Console.exportRXN(filename, context)
    elseif cmd == "new" then
        local filename = args[2]
        if not filename then
            Console.log("Usage: new <filename.rxn>")
            return
        end
        
        if not filename:match("%.rxn$") then
            filename = filename .. ".rxn"
        end
        
        Console.createRXN(filename)
	else
        Console.log("Unknown command: " .. cmd)
        Console.log("Type 'help' for available commands")
    end
end

return Console