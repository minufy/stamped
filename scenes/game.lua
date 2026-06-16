Game = {}
local GameBase = require("stuff.game_base")
GameBase(Game)

local Board = require("objects.board")

function Game:init()
    self:base_reload()
    self.objects = {}
    self:add(Board)
end

function Game:update(dt)
    Camera:update(dt)

    if not Edit.editing then
        self.group_names = {}
        for group_name, _ in pairs(self.objects) do
            table.insert(self.group_names, group_name)
        end
        for _, group_name in ipairs(self.group_names) do
            local i = #self.objects[group_name]
            while i > 0 do
                local object = self.objects[group_name][i]
                if object.update then
                    object:update(dt)
                end
                if object.remove then
                    self.lookup[object.key] = nil
                    self.objects[group_name][i] = self.objects[group_name][#self.objects[group_name]]
                    self.objects[group_name][#self.objects[group_name]] = nil
                end
                i = i-1
            end
        end
    end
end

function Game:draw()
    love.graphics.draw(Image.bg)

    Camera:start()
    Outline:start()
    
    for group_name, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.draw then
                object:draw()
            end
        end
    end
    
    Camera:stop()
    Outline:stop()
end

return Game