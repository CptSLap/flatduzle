-- 'flat' for turtles
-- Made by ryanv09

-- Place the turtle at southwest corner of desired surface

arg = {...}

length = arg[1]
width = arg[2]


-- Change this value to reflect how many total slots the turtle has
-- This is the slot that is checked for empty()
slots = 16


-- Usage
if (length == nil or width == nil) then
  print ("Usage: flat <length> <width>")
  return
end


-- Checks if the turtle is empty
-- If empty, pauses turtle until last slot has resources
function empty()
  if (turtle.getItemCount(slots) == 0) then
	print(string.format("I am empty. Please load more materials in slot %d to continue.", slots))
    while (turtle.getItemCount(slots) == 0) do
	  sleep(1)
    end  
  end
end


for i=0,(width - 1),1 do

  for j=1,(length - 1),1 do
    empty()
	turtle.forward()
    turtle.placeDown()
  end

  
  if (i % 2 == 0) then
    
    if (i ~= width - 1) then
      turtle.turnRight()
      turtle.forward()
      turtle.turnRight()
      empty()	
      turtle.placeDown()
    end
  else  
    if (i ~= width - 1) then
      turtle.turnLeft()
      turtle.forward()
      turtle.turnLeft()
      empty()
      turtle.placeDown()
    end
  end

  if (j ~= length - 1) then
    empty()
    turtle.placeDown()
  end
end

print("\nSurface complete.")
