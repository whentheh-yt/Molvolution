local libconfig = require("libs/libconfig")
local cfg = libconfig.timeslider

local TimeSlider = {}

TimeSlider.scale = cfg.scale
TimeSlider.x = cfg.x
TimeSlider.y = cfg.y
TimeSlider.width = cfg.width
TimeSlider.height = cfg.height
TimeSlider.min = cfg.min
TimeSlider.max = cfg.max
TimeSlider.dragging = false

function TimeSlider.draw()
    local y = TimeSlider.y
    local colors = cfg.colors
    local text = cfg.text
    
    love.graphics.setColor(colors.text or {1, 1, 1})
    love.graphics.print(text.label .. string.format(text.format, TimeSlider.scale), TimeSlider.x, y + text.offsetY)
    
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", TimeSlider.x, y, TimeSlider.width, TimeSlider.height, 5, 5)
    
    local fillWidth = ((TimeSlider.scale - TimeSlider.min) / (TimeSlider.max - TimeSlider.min)) * TimeSlider.width
    if TimeSlider.scale < 1.0 then
        love.graphics.setColor(colors.slow)
    elseif TimeSlider.scale > 1.0 then
        love.graphics.setColor(colors.fast)
    else
        love.graphics.setColor(colors.normal)
    end
    love.graphics.rectangle("fill", TimeSlider.x, y, fillWidth, TimeSlider.height, 5, 5)
    
    love.graphics.setColor(colors.border)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", TimeSlider.x, y, TimeSlider.width, TimeSlider.height, 5, 5)
    
    local normalPos = ((1.0 - TimeSlider.min) / (TimeSlider.max - TimeSlider.min)) * TimeSlider.width
    love.graphics.setColor(colors.normalLine)
    love.graphics.line(TimeSlider.x + normalPos, y, TimeSlider.x + normalPos, y + TimeSlider.height)
    
    local handleX = TimeSlider.x + fillWidth
    love.graphics.setColor(colors.handle)
    love.graphics.circle("fill", handleX, y + TimeSlider.height / 2, 8)
    love.graphics.setColor(colors.handleBorder)
    love.graphics.circle("line", handleX, y + TimeSlider.height / 2, 8)
end

-- Rest of TimeSlider functions remain the same...
function TimeSlider.mousepressed(x, y, button)
    if button == 1 then
        if x >= TimeSlider.x and x <= TimeSlider.x + TimeSlider.width and
           y >= TimeSlider.y and y <= TimeSlider.y + TimeSlider.height then
            TimeSlider.dragging = true
            local t = (x - TimeSlider.x) / TimeSlider.width
            TimeSlider.scale = TimeSlider.min + t * (TimeSlider.max - TimeSlider.min)
            TimeSlider.scale = math.max(TimeSlider.min, math.min(TimeSlider.max, TimeSlider.scale))
            return true
        end
    end
    return false
end

function TimeSlider.mousereleased(x, y, button)
    if button == 1 then
        TimeSlider.dragging = false
    end
end

function TimeSlider.mousemoved(x, y, dx, dy)
    if TimeSlider.dragging then
        local t = (x - TimeSlider.x) / TimeSlider.width
        TimeSlider.scale = TimeSlider.min + t * (TimeSlider.max - TimeSlider.min)
        TimeSlider.scale = math.max(TimeSlider.min, math.min(TimeSlider.max, TimeSlider.scale))
    end
end

return TimeSlider