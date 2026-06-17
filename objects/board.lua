local Board = Object:extend()
SetType(Board, "board")

local Mino = require("objects.mino")

NewImage("board")
NewImage("hold")
NewImage("next")
NewImage("g")
NewImage("i")
NewImage("j")
NewImage("l")
NewImage("o")
NewImage("s")
NewImage("t")
NewImage("z")

BOARD_W = 10
BOARD_H = 20
BUFFER_H = 20

local ghost_alpha = 0.6

local corner_offest_x = 3
local corner_offest_y = 0
local gap = 20

local hold_mino_x = 24
local hold_mino_y = 49
local hold_offset_y = -10

local next_mino_x = 24
local next_mino_y = 49
local next_offset_y = -10

local compact_scale = 0.5

local mino_draw_offset = {
    i = {0, -0.5},
    j = {0.5, 0},
    l = {0.5, 0},
    o = {0, 0},
    s = {0.5, 0},
    t = {0.5, 0},
    z = {0.5, 0},
}

function Board:new(seed, x, y, options)
    seed = seed or 1
    x = x or 0
    y = y or 0
    self.rng = love.math.newRandomGenerator(seed)
    self.options = options
    
    self.grid = {}
    local d = 1
    if self.options.compact then
        d = d/compact_scale
    end
    self.x = x*d-BOARD_W*TILE_SIZE/2+corner_offest_x/2
    self.y = y*d-BOARD_H*TILE_SIZE/2+corner_offest_y/2
    for _ = 1, BUFFER_H+BOARD_H do
        local row = {}
        for _ = 1, BOARD_W do
            table.insert(row, nil)
        end
        table.insert(self.grid, row)
    end
    self.next = {}
    self:add_next()
    self.current = self:get_next()
    self.hold_type = nil
    self.hold_used = false
end

function Board:shuffle(t)
    local rtn = {}
    for i = 1, #t do
        local r = self.rng:random(1, i)
        if r ~= i then
            rtn[i] = rtn[r]
        end
        rtn[r] = t[i]
    end
    return rtn
end

function Board:add_next()
    local bag = self:shuffle(Bag)
    for i, mino_type in ipairs(bag) do
        table.insert(self.next, mino_type)
    end
end

function Board:get_next()
    local next_type = table.remove(self.next, 1)
    if #self.next < 5 then
        self:add_next()
    end
    return Mino(next_type)
end

function Board:update(dt)

end

function Board:rotate_current(dir)
    self.current:rotate(dir, self)
end

function Board:move_current(dx, dy)
    self.current:move(dx, dy, self)
end

function Board:hold()
    if self.hold_used then
        return
    end
    self.hold_used = true
    if self.hold_type == nil then
        self.hold_type = self.current.type
        self.current = self:get_next()
    else
        local hold_type = self.hold_type
        self.hold_type = self.current.type
        self.current = Mino(hold_type)
    end
end

function Board:hard_drop()
    for _ = 1, BOARD_H+BUFFER_H do
        self.current:move(0, 1, self)
    end
    self.current:lock(self)
    self.current = self:get_next()
    self.hold_used = false
    self:clear_lines()
end

function Board:draw_mino(x, y ,mino_type)
    local sx, sy = unpack(mino_draw_offset[mino_type])
    Mino.draw_mino(x, y, mino_type, 0, sx, sy)
end

function Board:draw_ghost()
    local ghost = Mino(self.current.type)
    ghost.x = self.current.x
    ghost.y = self.current.y
    ghost.r = self.current.r
    for _ = 1, BOARD_H+BUFFER_H do
        ghost:move(0, 1, self)
    end
    love.graphics.setColor(1, 1, 1, ghost_alpha)
    ghost:draw(self.x, self.y)
    Color.reset()
end

function Board:clear_lines()
    local count = 0
    local y = 1
    while y <= BOARD_H+BUFFER_H do
        local full = true
        for x = 1, BOARD_W do
            if self.grid[y][x] == nil then
                full = false
                break
            end
        end
        if full then
            table.remove(self.grid, y)
            local row = {}
            for _ = 1, BOARD_W do
                table.insert(row, nil)
            end
            table.insert(self.grid, 1, row)
            count = count+1
        else
            y = y+1
        end
    end
    return count
end

function Board:draw()
    local bx, by = self.x-corner_offest_x, self.y-corner_offest_y
    
    if not self.compact then
        local hold_x = self.x-corner_offest_x-gap-Image.hold:getWidth()
        local hold_y = self.y-corner_offest_y+hold_offset_y
        love.graphics.draw(Image.hold, hold_x, hold_y)
        if self.hold_type ~= nil then
            if self.hold_used then
                love.graphics.setColor(1, 1, 1, ghost_alpha)
            end
            self:draw_mino(hold_x+hold_mino_x+gap, hold_y+hold_mino_y+gap, self.hold_type)
            Color.reset()
        end
    
        local next_x = self.x+corner_offest_x+BOARD_W*TILE_SIZE+gap
        local next_y = self.y-corner_offest_y+next_offset_y
        love.graphics.draw(Image.next, next_x, next_y)
        for i = 1, 5 do
            self:draw_mino(next_x+next_mino_x+gap, next_y+next_mino_y+gap+(i-1)*TILE_SIZE*3, self.next[i])
        end
    end

    if self.compact then
        love.graphics.push()
        love.graphics.scale(compact_scale, compact_scale)
    end
    
    love.graphics.draw(Image.board, bx, by)
    for y = 1, BUFFER_H+BOARD_H do
        for x = 1, BOARD_W do
            local cell = self.grid[y][x]
            if cell ~= nil then
                love.graphics.draw(Image[cell], self.x+(x-1)*TILE_SIZE, self.y+(y-1-BUFFER_H)*TILE_SIZE)
            end
        end
    end
    if not self.compact then
        self:draw_ghost()
    end
    
    self.current:draw(self.x, self.y)

    if self.compact then
        love.graphics.pop()
    end
end

return Board
