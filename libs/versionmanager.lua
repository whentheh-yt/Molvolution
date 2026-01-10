local VersionManager = {}

VersionManager.currentVersion = nil
VersionManager.remoteVersion = nil
VersionManager.updateAvailable = false
VersionManager.checking = false
VersionManager.lastCheck = 0
VersionManager.checkInterval = 3600 -- Check once per hour
VersionManager.updateURL = "https://www.github.com/whentheh-yt/Molvolution/libs"
VersionManager.notificationDismissed = false

function VersionManager.load()
    if love.filesystem.getInfo(".version") then
        VersionManager.currentVersion = love.filesystem.read(".version"):match("^%s*(.-)%s*$")
    else
        local config = require("config")
        VersionManager.currentVersion = config.game.version
    end
    
    local success, http = pcall(require, "socket.http")
    if success then
        VersionManager.http = http
        VersionManager.canCheckUpdates = true
    else
        print("Note: luasocket not found - version checking disabled")
        VersionManager.canCheckUpdates = false
    end
end

function VersionManager.checkForUpdates(callback)
    if not VersionManager.canCheckUpdates then
        print("Version checking not available (luasocket not installed)")
        return
    end
    
    if VersionManager.checking then return end
    
    VersionManager.checking = true
    
    local success, response = pcall(function()
        local body, code = VersionManager.http.request(VersionManager.updateURL .. ".version")
        if code == 200 then
            return body
        else
            return nil
        end
    end)
    
    VersionManager.checking = false
    
    if success and response then
        VersionManager.remoteVersion = response:match("^%s*(.-)%s*$")
        VersionManager.updateAvailable = VersionManager.compareVersions(
            VersionManager.remoteVersion, 
            VersionManager.currentVersion
        ) > 0
        
        if VersionManager.updateAvailable then
            print("Update available: " .. VersionManager.remoteVersion)
        end
    else
        print("Version check failed - couldn't reach server")
    end
end

function VersionManager.update(dt)
    -- Check if it's time for periodic update check
    if not VersionManager.canCheckUpdates then return end
    
    VersionManager.lastCheck = VersionManager.lastCheck + dt
    if VersionManager.lastCheck >= VersionManager.checkInterval then
        VersionManager.lastCheck = 0
        VersionManager.checkForUpdates()
    end
end

function VersionManager.compareVersions(v1, v2)
    -- Parse version strings like "New Years 2026 Build 1.2.168"
    local function parseVersion(v)
        local major, minor, patch = v:match("Build (%d+)%.(%d+)%.(%d+)")
        if not major then
            -- Fallback parsing
            major, minor, patch = v:match("(%d+)%.(%d+)%.(%d+)")
        end
        return {
            major = tonumber(major) or 0,
            minor = tonumber(minor) or 0,
            patch = tonumber(patch) or 0
        }
    end
    
    local ver1 = parseVersion(v1)
    local ver2 = parseVersion(v2)
    
    if ver1.major ~= ver2.major then
        return ver1.major - ver2.major
    elseif ver1.minor ~= ver2.minor then
        return ver1.minor - ver2.minor
    else
        return ver1.patch - ver2.patch
    end
end

function VersionManager.downloadUpdate()
    print("Opening download page...")
    love.system.openURL(VersionManager.updateURL)
end

function VersionManager.draw()
    if VersionManager.updateAvailable and not VersionManager.notificationDismissed then
        local width = love.graphics.getWidth()
        local message = "Update available: " .. VersionManager.remoteVersion
        local textWidth = love.graphics.getFont():getWidth(message)
        
        love.graphics.setColor(0.2, 0.6, 1.0, 0.9)
        love.graphics.rectangle("fill", width - textWidth - 40, 10, textWidth + 30, 50, 5, 5)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(message, width - textWidth - 30, 17)
        
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.print("Click to download", width - textWidth - 30, 35, 0, 0.7, 0.7)
        
        love.graphics.setColor(1, 0.5, 0.5)
        love.graphics.print("X", width - 20, 15, 0, 0.8, 0.8)
    end
end

function VersionManager.mousepressed(x, y, button)
    if not VersionManager.updateAvailable or VersionManager.notificationDismissed then 
        return false 
    end
    
    local width = love.graphics.getWidth()
    local message = "Update available: " .. VersionManager.remoteVersion
    local textWidth = love.graphics.getFont():getWidth(message)
    
    local boxX = width - textWidth - 40
    local boxY = 10
    local boxW = textWidth + 30
    local boxH = 50
    
    if x >= width - 25 and x <= width - 10 and y >= 10 and y <= 30 then
        VersionManager.notificationDismissed = true
        return true
    end
    
    if x >= boxX and x <= boxX + boxW and y >= boxY and y <= boxY + boxH then
        VersionManager.downloadUpdate()
        return true
    end
    
    return false
end

return VersionManager