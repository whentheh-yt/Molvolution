local Console = {}

Console.open = false
Console.input = ""
Console.history = {}
Console.historyIndex = 0
Console.output = {}
Console.maxOutput = 10

function Console.log(message)
    table.insert(Console.output, message)
    if #Console.output > Console.maxOutput then
        table.remove(Console.output, 1)
    end
end

function Console.execute(cmd, context)
    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word)
    end
    
    if #args == 0 then return end
    
    local command = args[1]:lower()
    
    -- SPAWN command: spawn <molecule_type> [count]
    if command == "spawn" then
        if #args < 2 then
            Console.log("Usage: spawn <type> [count]")
            return
        end
        
        local molType = args[2]
        local count = tonumber(args[3]) or 1
        
        if not context.config.molecules[molType] then
            Console.log("Unknown molecule: " .. molType)
            return
        end
        
        local mouseX, mouseY = love.mouse.getPosition()
        local worldX = context.camera.x + mouseX / context.camera.zoom
        local worldY = context.camera.y + mouseY / context.camera.zoom
        
        for i = 1, count do
            local offsetX = (math.random() - 0.5) * 100
            local offsetY = (math.random() - 0.5) * 100
            table.insert(context.molecules, context.Molecule:new(molType, worldX + offsetX, worldY + offsetY))
        end
        
        Console.log("Spawned " .. count .. "x " .. molType)
    
    -- CLEAR command: clear <molecule_type> or clear all
    elseif command == "clear" then
        if #args < 2 then
            Console.log("Usage: clear <type|all>")
            return
        end
        
        local target = args[2]:lower()
        local removed = 0
        
        if target == "all" then
            removed = #context.molecules
            for i = #context.molecules, 1, -1 do
                table.remove(context.molecules, i)
            end
            Console.log("Cleared all molecules (" .. removed .. ")")
        else
            for i = #context.molecules, 1, -1 do
                if context.molecules[i].type == target then
                    table.remove(context.molecules, i)
                    removed = removed + 1
                end
            end
            Console.log("Cleared " .. removed .. "x " .. target)
        end
    
    -- EXPLODE command: explode <molecule_type|all>
    elseif command == "explode" then
        if #args < 2 then
            Console.log("Usage: explode <type|all>")
            return
        end
        
        local target = args[2]:lower()
        local exploded = 0
        
        for i = #context.molecules, 1, -1 do
            if target == "all" or context.molecules[i].type == target then
                context.molecules[i].alive = false
                exploded = exploded + 1
            end
        end
        
        Console.log("Exploded " .. exploded .. " molecules")
    
    -- COUNT command: count molecules
    elseif command == "count" then
        if #args < 2 then
            Console.log("Total molecules: " .. #context.molecules)
        else
            local molType = args[2]
            local count = 0
            for _, mol in ipairs(context.molecules) do
                if mol.type == molType then
                    count = count + 1
                end
            end
            Console.log(molType .. ": " .. count)
        end
    
    -- LIST command: list all molecule types
    elseif command == "list" then
        local types = {}
        for molType, _ in pairs(context.config.molecules) do
            table.insert(types, molType)
        end
        table.sort(types)
        Console.log("Available molecules (" .. #types .. " types):")
        local line = "  "
        for i, t in ipairs(types) do
            line = line .. t .. ", "
            if i % 3 == 0 then
                Console.log(line)
                line = "  "
            end
        end
        if line ~= "  " then
            Console.log(line:sub(1, -3)) -- Remove trailing comma
        end
    
    -- NUKE command: kill everything instantly
    elseif command == "nuke" then
        local count = #context.molecules
        for i = #context.molecules, 1, -1 do
            context.molecules[i].alive = false
        end
        Console.log("💥 NUKED " .. count .. " molecules!")
    
    -- CHAOS command: spawn random molecules
    elseif command == "chaos" then
        local count = tonumber(args[2]) or 50
        local types = {}
        for molType, _ in pairs(context.config.molecules) do
            table.insert(types, molType)
        end
        
        for i = 1, count do
            local molType = types[math.random(#types)]
            local x = math.random(100, context.config.world.width - 100)
            local y = math.random(100, context.config.world.height - 100)
            table.insert(context.molecules, context.Molecule:new(molType, x, y))
        end
        
        Console.log("🌀 CHAOS! Spawned " .. count .. " random molecules")
    
    -- HELP command
    elseif command == "help" then
        Console.log("=== CONSOLE COMMANDS ===")
        Console.log("spawn <type> [count] - Spawn at mouse")
        Console.log("clear <type|all> - Remove molecules")
        Console.log("explode <type|all> - Kill with fragments")
        Console.log("count [type] - Count molecules")
        Console.log("list - List all types")
        Console.log("nuke - Kill everything")
        Console.log("chaos [count] - Spawn random")
        Console.log("help - Show this")
    
    else
        Console.log("Unknown: '" .. command .. "' (type 'help')")
    end
    
    -- Add to history
    if cmd ~= "" then
        table.insert(Console.history, cmd)
        Console.historyIndex = #Console.history + 1
    end
end

function Console.draw()
    if not Console.open then return end
    
    local width = love.graphics.getWidth()
    local height = 300
    local y = love.graphics.getHeight() - height
    
    -- Background
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0, y, width, height)
    
    -- Border
    love.graphics.setColor(0.3, 0.8, 0.3)
    love.graphics.setLineWidth(2)
    love.graphics.line(0, y, width, y)
    
    -- Output history
    love.graphics.setColor(0.8, 0.8, 0.8)
    local outputY = y + 10
    for i, line in ipairs(Console.output) do
        love.graphics.print(line, 10, outputY)
        outputY = outputY + 20
    end
    
    -- Input line
    love.graphics.setColor(0.3, 0.8, 0.3)
    love.graphics.print("> ", 10, y + height - 30)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(Console.input .. "_", 30, y + height - 30)
    
    -- Help hint
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.print("Press ` to close | Type 'help' for commands", 10, y + height - 10, 0, 0.8, 0.8)
end

function Console.textinput(text)
    if Console.open then
        Console.input = Console.input .. text
    end
end

function Console.keypressed(key, context)
    if key == "`" or key == "~" then
        Console.open = not Console.open
        if Console.open then
            Console.log("=== CONSOLE OPENED ===")
            Console.log("Type 'help' for commands")
        end
        return true
    end
    
    if not Console.open then return false end
    
    if key == "return" then
        if Console.input ~= "" then
            Console.log("> " .. Console.input)
            Console.execute(Console.input, context)
            Console.input = ""
        end
    elseif key == "backspace" then
        Console.input = Console.input:sub(1, -2)
    elseif key == "up" then
        if Console.historyIndex > 1 then
            Console.historyIndex = Console.historyIndex - 1
            Console.input = Console.history[Console.historyIndex] or ""
        end
    elseif key == "down" then
        if Console.historyIndex <= #Console.history then
            Console.historyIndex = Console.historyIndex + 1
            Console.input = Console.history[Console.historyIndex] or ""
        end
    elseif key == "escape" then
        Console.open = false
    end
    
    return true
end

return Console