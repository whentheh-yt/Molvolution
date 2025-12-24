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
            Console.log(text.prompt .. Console.input)
            Console.execute(Console.input, context)
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

-- Console.execute remains the same, it's too long to repeat here...

return Console