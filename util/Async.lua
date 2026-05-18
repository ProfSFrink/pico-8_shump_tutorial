-- Start a new asynchronous routine.
-- param func: the function to run as a routine.
function async(func)
    add(routines, cocreate(func))
end

-- Wait for a number of frames.
-- param f: number of frames to wait.
function wait(f)
    for i = 1, f do
        yield()
    end
end