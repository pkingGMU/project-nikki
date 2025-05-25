WorldState = {
    Level1 = {
        default = {
          objects = {
            { class = "Enemy", type = "Enemy" , persistent = true},
            { class = "Enemy", type = "Enemy", x = 20, y = 20, h = 500, w = 100, persistent = true }
            }
        },
        current = {
            objects = {
                
            }
        }
    },
    Level2 = {
        default = {
            objects = {
            }
        },
        current = {
            objects = {}
        }
    }
}

return WorldState
