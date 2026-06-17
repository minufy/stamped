local Player = Object:extend()

function Player:new(board)
    self.board = board
    self.arr = 0
    self.das = 0
    self.sdarr = 0
    self.ix = 0
end

function Player:update(dt)
    local time = love.timer.getTime()*1000

    if Input.right.pressed then
        self.ix = 1
        self.board:move_current(1, 0)
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
        self.board:move_current(-1, 0)
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
                self.board:move_current(self.ix, 0)
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
            self.board:move_current(0, 1)
        end
    end

    if Input.cw.pressed then
        self.board:rotate_current(1)
    end
    if Input.ccw.pressed then
        self.board:rotate_current(-1)
    end
    if Input.flip.pressed then
        self.board:rotate_current(2)
    end

    if Input.hard_drop.pressed then
        self.board:hard_drop()
    end

    if Input.hold.pressed then
        self.board:hold()
    end
end

return Player