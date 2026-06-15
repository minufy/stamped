local lume = require("modules.lume")

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

local mino_draw_offset = {
    i = {0, -0.5},
    j = {0.5, 0},
    l = {0.5, 0},
    o = {0, 0},
    s = {0.5, 0},
    t = {0.5, 0},
    z = {0.5, 0},
}

function Board:new()
    self.grid = {}
    self.x = Res.w/2-BOARD_W*TILE_SIZE/2+corner_offest_x/2
    self.y = Res.h/2-BOARD_H*TILE_SIZE/2+corner_offest_y/2
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
    self.arr = 0
    self.das = 0
    self.sdarr = 0
    self.ix = 0
end

function Board:add_next()
    local bag = lume.shuffle(Bag)
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
    local time = love.timer.getTime()*1000

    if Input.right.pressed then
        self.ix = 1
        self.current:move(1, 0, self)
        self.das = time+Config.das
    elseif Input.right.released then
        if Input.left.down then
            self.ix = -1
        else
            self.ix = 0
        end
    end
    if Input.left.pressed then
        self.ix = -1
        self.current:move(-1, 0, self)
        self.das = time+Config.das
    elseif Input.left.released then
        if Input.right.down then
            self.ix = 1
        else
            self.ix = 0
        end
    end
    if Input.soft_drop.pressed then
        self.sdarr = time+Config.sdarr
    end

    if time >= self.das then
        if self.ix ~= 0 then
            for _ = 1, BOARD_W do
                if time >= self.arr then
                    self.arr = self.arr+Config.arr
                else
                    break
                end
                self.current:move(self.ix, 0, self)
            end
        end
    end
    if Input.soft_drop.down then
        for _ = 1, BOARD_H+BUFFER_H do
            if time >= self.sdarr then
                self.sdarr = self.sdarr+Config.sdarr
            else
                break
            end
            self.current:move(0, 1, self)
        end
    end

    if Input.cw.pressed then
        self.current:rotate(1, self)
    end
    if Input.ccw.pressed then
        self.current:rotate(-1, self)
    end
    if Input.flip.pressed then
        self.current:rotate(2, self)
    end

    if Input.hard_drop.pressed then
        self:hard_drop()
    end

    if Input.hold.pressed then
        self:hold()
    end
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

    love.graphics.draw(Image.board, bx, by)
    
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

    self:draw_ghost()

    for y = 1, BUFFER_H+BOARD_H do
        for x = 1, BOARD_W do
            local cell = self.grid[y][x]
            if cell ~= nil then
                love.graphics.draw(Image[cell], self.x+(x-1)*TILE_SIZE, self.y+(y-1-BUFFER_H)*TILE_SIZE)
            end
        end
    end
    
    self.current:draw(self.x, self.y)
end

return Board
