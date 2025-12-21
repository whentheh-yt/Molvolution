local TimeSlider = {}

TimeSlider.scale = 1.0
TimeSlider.x = 10
TimeSlider.y = 780
TimeSlider.width = 200
TimeSlider.height = 20
TimeSlider.min = 0.1
TimeSlider.max = 3.0
TimeSlider.dragging = false

function TimeSlider.draw()
    local y = TimeSlider.y
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Time Scale: " .. string.format("%.1fx", TimeSlider.scale), TimeSlider.x, y - 20)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", TimeSlider.x, y, TimeSlider.width, TimeSlider.height, 5, 5)
    
    local fillWidth = ((TimeSlider.scale - TimeSlider.min) / (TimeSlider.max - TimeSlider.min)) * TimeSlider.width
    if TimeSlider.scale < 1.0 then
        love.graphics.setColor(0.3, 0.6, 1.0)
    elseif TimeSlider.scale > 1.0 then
        love.graphics.setColor(1.0, 0.5, 0.2)
    else
        love.graphics.setColor(0.5, 0.8, 0.5)
    end
    love.graphics.rectangle("fill", TimeSlider.x, y, fillWidth, TimeSlider.height, 5, 5)
    
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", TimeSlider.x, y, TimeSlider.width, TimeSlider.height, 5, 5)
    
    local normalPos = ((1.0 - TimeSlider.min) / (TimeSlider.max - TimeSlider.min)) * TimeSlider.width
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.line(TimeSlider.x + normalPos, y, TimeSlider.x + normalPos, y + TimeSlider.height)
    
    local handleX = TimeSlider.x + fillWidth
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", handleX, y + TimeSlider.height / 2, 8)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.circle("line", handleX, y + TimeSlider.height / 2, 8)
end

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