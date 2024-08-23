--
------------------------ Main Function ------------------------
--

function main()
    -- Default chunk dimensions in minecraft are 16 blocks x 16 blocks.
    -- While changing these off of 16 wouldn't make sense,
    -- this would be good for testing!
    CHUNK_LENGTH = 16
    CHUNK_WIDTH = 16

    if (not validateChunkDimensions(CHUNK_LENGTH, CHUNK_WIDTH)) then
        print("The chunk's dimensions are too small. They need to be bigger than 1!")
        return
    end

    print("Beginning the chunk destruction.")

    print("Refueling from slot 1")

    refuelTurtle()

    -- Begin the destruction. The turtle will insert itself
    -- into the ground and the begin destroying blocks
    startDestruction(CHUNK_LENGTH, CHUNK_WIDTH)
    
    print("Turtle has stopped destroying the chunk. Thank you for using Turtle Express. Make sure to refuel me!")
end

--
------------------------ Supporting Functions ------------------------
--

function validateChunkDimensions(CHUNK_LENGTH, CHUNK_WIDTH)
    return (CHUNK_LENGTH > 0 and CHUNK_WIDTH > 0)
end

function refuelTurtle()
    -- Check to see if the turtle has anything in slot 1.
    -- If it does, refuel using it.
    turtle.select(1)

    if (turtle.getItemCount(1) > 0) then
        turtle.refuel()
        print("Turtle successfully refueled")
    else
        print("Turtle cannot refuel from slot 1")
    end
end



function startDestruction(CHUNK_LENGTH, CHUNK_WIDTH)
    -- Repeat this until our turtle cannot destroy an entire row of our chunk.
    while (turtle.getFuelLevel() > (CHUNK_LENGTH * CHUNK_WIDTH)) do

        turtle.digDown()
        assert(turtle.down(), "Turtle could not move down.") -- Add the assert here. If the turtle digs down and cannot move, then there is an unbreakable block.

        for i = 1, CHUNK_WIDTH, 1 do

            -- On the first line, we have dug out the first block on our turtle's descent.
            -- On all the other lines, we have dug out the first block on our turns.
            mineNumOfBlocks(CHUNK_LENGTH - 1)


            -- We do not want to turn our turtle if we are on the end of the chunk.
            if (not (i == CHUNK_WIDTH)) then

                -- For our turn, if we are on an even-numbered row, then we will have to
                -- turn right. Otherwise, we have to turn left.
                if (i % 2 == 1) then
                    turtle.turnRight()
                    turtle.dig()
                    assert(turtle.forward(), "Turtle could not move forward")
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    turtle.dig()
                    assert(turtle.forward(), "Turtle could not move forward")
                    turtle.turnLeft()
                end
            
            -- If we are on the edge, we want to prepare ourselves for the next row of blocks.
            -- Turn the turtle 180 degrees.
            else
                turtle.turnRight()

                -- We need this extra check to handle the different widths of chunks.
                -- The turtle's final orientation on chunks with an even width requires only
                -- 1 turn while odd widths require two turns.
                if (CHUNK_WIDTH % 2 == 1) then
                    turtle.turnRight()
                end
            end

        end
    end
end



-- Simple function that will make the turtle move forward
-- and dig an x amount of blocks where x is the input to the function.
function mineNumOfBlocks(num)
    for j = 1, num, 1 do
        turtle.dig()
        assert(turtle.forward(), "Turtle could not move forward.")
    end
end

--
------------------------ Main Call ------------------------
--

main()