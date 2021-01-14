-- Helper function for looping over a range
function range(limit)
     local function seq(state, x)
         if (x >= limit) then 
             return nil
         else
             return x + 1
         end
     end
     return seq, nil, 0
end

-- Cover an area
function coverArea(w)
     local X,Y = w.size.x,w.size.y

     -- Prepare for first row
     w.forward()
     w.right()

     -- Loop over each row
     for y in range(Y) do
         -- Loop over each column
         for x in range(X) do
             -- Do the callback for each point
             w.callback()

             -- Unless we have completed the row
             if x ~= X then
                 -- Move forward
                 w.forward()
             end
         end
         
         -- Unless we have completed all rows
         if y ~= Y then
             -- Move to next row
             if y%2 == 1 then
                 w.left()
                 w.forward()
                 w.left()
             else
                 w.right()
                 w.forward()
                 w.right()
             end
         end
     end

     -- Move back to starting point
     if Y%2 == 1 then
         w.left()
         w.left()
         for x in range(X) do w.forward() end
     end
     w.left()
     for y in range(Y) do w.forward() end
     w.right()
     w.right()
end

-- Persistent forward function
function forward()
     while not turtle.forward() do
         sleep(0.5)
         turtle.dig()
     end
end

-- Level wherever the turtle is
function level()
     -- How far down we have gone
     local depth = 0

     -- Make sure we have an empty slot for picking up junk
     -- This is an attempt to not mess up the convention by
     -- the blocks we dig that are picked up. Not 100%
     -- reliable still...
     turtle.select(9)
     turtle.drop()

     -- Move down to first block we can find
     while not turtle.detectDown() and turtle.down() do
         depth = depth + 1
     end

     -- Remove top block
     turtle.digDown()
     turtle.down()
     depth = depth + 1

     -- Dig down to first non-dirt block we can find
     turtle.select(1)
     while (turtle.compareDown() and turtle.digDown() and turtle.down()) or turtle.down() do
         depth = depth + 1
     end

     -- Start filling
     while depth > 0 do
         -- Until we move up 1 successfully
         while not turtle.up() do
             -- Try dig upwards and wait a bit
             turtle.digUp()
             sleep(0.5)
         end
         depth = depth - 1
         
         -- As long as we have something to place
         if selectSource(depth) > 0 then
             -- Place it below us
             turtle.placeDown()
         end
     end
end

-- Returns the count of an appropriate slot
function selectSource(depth)
     -- If we're at the top
     if depth==1 then
         -- Select slot 1 and return its count
         turtle.select(1)
         return turtle.getItemCount(1)
     -- Otherwise
     else
         -- Move through the rest of the slots
         for i=2,9 do
             turtle.select(i)
             local count = turtle.getItemCount(i)
             -- Until we find one with something in it
             if count > 0 then
                 return count
             end
         end
     end
     return 0
end

-- Program starter
local arg = {...}
if #arg == 2 then
     coverArea({
         size = {
             x = tonumber(arg[1]),
             y = tonumber(arg[2]),
             },
         forward = forward,
         left = turtle.turnLeft,
         right = turtle.turnRight,
         callback = level,
     })
else
     print("Usage: level x y")
end
