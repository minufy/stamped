Bag = {"i", "o", "t", "s", "z", "j", "l"}

local spawn = {
    i = {x = 5, y = 18},
    o = {x = 5, y = 19},
    t = {x = 5, y = 19},
    s = {x = 5, y = 19},
    z = {x = 5, y = 19},
    j = {x = 5, y = 19},
    l = {x = 5, y = 19}
}

local cells = {
    i = {
        [0] = {{-1, 0}, {0, 0}, {1, 0}, {2, 0}},
        [1] = {{1, 1}, {1, 0}, {1, -1}, {1, -2}},
        [2] = {{-1, -1}, {0, -1}, {1, -1}, {2, -1}},
        [3] = {{0, 1}, {0, 0}, {0, -1}, {0, -2}}
    },
    o = {
        [0] = {{0, 0}, {1, 0}, {0, -1}, {1, -1}},
        [1] = {{0, 0}, {1, 0}, {0, -1}, {1, -1}},
        [2] = {{0, 0}, {1, 0}, {0, -1}, {1, -1}},
        [3] = {{0, 0}, {1, 0}, {0, -1}, {1, -1}}
    },
    t = {
        [0] = {{-1, 0}, {0, 0}, {1, 0}, {0, -1}},
        [1] = {{0, 1}, {0, 0}, {0, -1}, {1, 0}},
        [2] = {{-1, 0}, {0, 0}, {1, 0}, {0, 1}},
        [3] = {{0, 1}, {0, 0}, {0, -1}, {-1, 0}}
    },
    s = {
        [0] = {{-1, 0}, {0, 0}, {0, -1}, {1, -1}},
        [1] = {{0, -1}, {0, 0}, {1, 0}, {1, 1}},
        [2] = {{-1, 1}, {0, 1}, {0, 0}, {1, 0}},
        [3] = {{-1, -1}, {-1, 0}, {0, 0}, {0, 1}}
    },
    z = {
        [0] = {{-1, -1}, {0, -1}, {0, 0}, {1, 0}},
        [1] = {{1, -1}, {1, 0}, {0, 0}, {0, 1}},
        [2] = {{-1, 0}, {0, 0}, {0, 1}, {1, 1}},
        [3] = {{0, -1}, {0, 0}, {-1, 0}, {-1, 1}}
    },
    j = {
        [0] = {{-1, -1}, {-1, 0}, {0, 0}, {1, 0}},
        [1] = {{0, -1}, {1, -1}, {0, 0}, {0, 1}},
        [2] = {{-1, 0}, {0, 0}, {1, 0}, {1, 1}},
        [3] = {{0, -1}, {0, 0}, {0, 1}, {-1, 1}}
    },
    l = {
        [0] = {{-1, 0}, {0, 0}, {1, 0}, {1, -1}},
        [1] = {{0, -1}, {0, 0}, {0, 1}, {1, 1}},
        [2] = {{-1, 1}, {-1, 0}, {0, 0}, {1, 0}},
        [3] = {{-1, -1}, {0, -1}, {0, 0}, {0, 1}}
    }
}

local jlstz_kick = {
    ["01"] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}},
    ["10"] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
    ["12"] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
    ["21"] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}},
    ["23"] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
    ["32"] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
    ["30"] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
    ["03"] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
    ["02"] = {{0, 0}, {0, 1}, {1, 1}, {-1, 1}, {1, 0}, {-1, 0}},
    ["13"] = {{0, 0}, {1, 0}, {1, 2}, {1, 1}, {0, 2}, {0, 1}},
    ["20"] = {{0, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 0}, {1, 0}},
    ["31"] = {{0, 0}, {-1, 0}, {-1, 2}, {-1, 1}, {0, 2}, {0, 1}},
}

local i_kick = {
    ["01"] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}},
    ["10"] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}},
    ["12"] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}},
    ["21"] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}},
    ["23"] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}},
    ["32"] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}},
    ["30"] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}},
    ["03"] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}},
    ["02"] = {{0, 0}, {0, 1}, {0, -1}, {1, 0}, {-1, 0}},
    ["13"] = {{0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1}},
    ["20"] = {{0, 0}, {0, -1}, {0, 1}, {-1, 0}, {1, 0}},
    ["31"] = {{0, 0}, {-1, 0}, {1, 0}, {0, 1}, {0, -1}},
}

local srs = {
    i = i_kick,
    o = {
        ["01"] = {{0, 0}},
        ["10"] = {{0, 0}},
        ["12"] = {{0, 0}},
        ["21"] = {{0, 0}},
        ["23"] = {{0, 0}},
        ["32"] = {{0, 0}},
        ["30"] = {{0, 0}},
        ["03"] = {{0, 0}},
        ["02"] = {{0, 0}},
        ["20"] = {{0, 0}},
        ["13"] = {{0, 0}},
        ["31"] = {{0, 0}},
    },
    t = jlstz_kick,
    s = jlstz_kick,
    z = jlstz_kick,
    j = jlstz_kick,
    l = jlstz_kick
}

local Mino = Object:extend()

function Mino:new(type)
    self.type = type
    local pos = spawn[self.type]
    self.x = pos.x
    self.y = pos.y
    self.r = 0
end

function Mino:draw(bx, by)
    self.draw_mino(bx, by, self.type, self.r, self.x-1, self.y-BUFFER_H-1)
end

function Mino.draw_mino(bx, by, mino_type, r, sx, sy)
    for i = 1, 4 do
        local cx, cy = unpack(cells[mino_type][r][i])
        local x = sx+cx
        local y = sy+cy
        love.graphics.draw(Image[mino_type], bx+x*TILE_SIZE, by+y*TILE_SIZE)
    end
end

function Mino:move(dx, dy, board)
    local old_x, old_y = self.x, self.y
    self.x = self.x+dx
    self.y = self.y+dy
    if self:check_collision(board) then
        self.x = old_x
        self.y = old_y
    end
end

function Mino:rotate(dir, board)
    local old_r = self.r
    local old_x, old_y = self.x, self.y
    self.r = (self.r+dir)%4
    local key = tostring(old_r)..tostring(self.r)
    for i, kick in ipairs(srs[self.type][key]) do
        local dx, dy = unpack(kick)
        self.x = old_x+dx
        self.y = old_y-dy
        if not self:check_collision(board) then
            return
        end
    end
    self.r = old_r
    self.x = old_x
    self.y = old_y
end

function Mino:check_collision(board)
    for i = 1, 4 do
        local cx, cy = unpack(cells[self.type][self.r][i])
        local x = self.x+cx
        local y = self.y+cy
        if 1 <= x and x <= BOARD_W and 1 <= y and y <= BUFFER_H+BOARD_H then
            if board.grid[y][x] ~= nil then
                return true
            end
        else
            return true
        end
    end
    return false
end

function Mino:lock(board)
    for i = 1, 4 do
        local cx, cy = unpack(cells[self.type][self.r][i])
        local x = self.x+cx
        local y = self.y+cy
        board.grid[y][x] = self.type
    end
end

return Mino
