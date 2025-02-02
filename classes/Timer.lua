local Class = require("libraries.hump-master.class")

Timer = Class()

-- Constructor for the Timer class
function Timer:init(duration)
    self.duration = duration or 5  -- Default duration is 5 seconds
    self.elapsedTime = 0  -- Time that has passed since the timer started
    self.running = false  -- Timer status (running or not)
end

-- Method to start the timer
function Timer:start()
    self.elapsedTime = 0  -- Reset elapsed time
    self.running = true   -- Start the timer
end

-- Method to stop the timer
function Timer:stop()
    self.running = false  -- Stop the timer
end

-- Method to update the timer each frame
function Timer:update(dt)
    if self.elapsedTime >= self.duration then
        self.running = false
    end

    if self.running then
        self.elapsedTime = self.elapsedTime + dt
    end
end

-- Method to get the remaining time of the countdown
function Timer:getRemainingTime()
    return math.max(self.duration - math.floor(self.elapsedTime), 0)  -- Don't go below zero
end

function Timer:getRemainingTimeFloat()
    return math.max(self.duration - self.elapsedTime, 0)
end

-- Method to check if the timer has finished
function Timer:isFinished()
    return self.elapsedTime >= self.duration
end
