


-- This is the script in which you will write any of your own custom code. I'm going to include a couple of code snippets here beforehand that you will want to keep.
-- There is going to be a LOT of green writing here from me. This is because I will be assuming you know nothing about scripting prior to this, and I want to provide as much information as possible.
-- DO NOT FEEL THAT YOU MUST READ EVERYTHING. A LOT OF THIS WILL BE EXPLANATIONS FOR WHAT THINGS ARE / WHAT THINGS DO. YOU WONT NECESSARILY NEED AN EXPLANATION FOR EVERYTHING, A LOT IS SELF EXPLANATORY.





-- CODE SNIPPET #1: VANILLA MODEL VISIBILITY
    -- This is where you can make your regular vanilla model invisible. Currently, every part of the vanilla model is set to be invisible. If you want to keep certain parts visible by default, simply remove the
    -- necessary line of code (if you want your vanilla legs to be visible, delete or put -- before the lines 'vanilla_model.LEFT_LEG:setVisible(false)' and 'vanilla_model.RIGHT_LEG:setVisible(false)').
            vanilla_model.LEFT_ARM:setVisible(false)

            vanilla_model.RIGHT_ARM:setVisible(false)

            vanilla_model.LEFT_LEG:setVisible(false)

            vanilla_model.RIGHT_LEG:setVisible(false)

            vanilla_model.HEAD:setVisible(false)

            vanilla_model.BODY:setVisible(false)

            vanilla_model.ELYTRA:setVisible(false)

            vanilla_model.ARMOR:setVisible(false)

            --vanilla_model.PLAYER:setVisible(false)          -- <- This will set your entire vanilla model to be invisible. It just does what the lines above it do, but in one single line of code. I have included
                                                                    -- the individual lines of code in the assumption that people may want to customise what is and is not visible by default. If you want to use this,
                                                                    -- just get rid of the two dashes in front of it.





                                                                    


 -- CODE SNIPPET #2: VOICECHAT MOD COMPATIBILITY 
    -- In your model, include an animation labeled 'talk' by default. You do not have to do anything with this animation, it can be any loop mode and doesn't have to have any keyframes.
    -- You only need the animation in order to prevent the script from erroring, as the code below will look for an animation named 'talk' in your blockbench model. If it doesn't find one, it errors.
    -- You will also need to swap out 'model' to whatever you have named your blockbench model. If your blockbench model file is still called 'model' then that is fine. Just don't change the code.
            local microphoneOffTime = 0
            local isMicrophoneOn = false

            function pings.talking(state)
                animations.model.talk:setPlaying(state)     -- <----- HERE IS WHERE YOU MAY NEED TO SWAP OUT THE WORD 'model' FOR YOUR BLOCKBENCH MODEL NAME!
            end

            function events.tick()
                local previousMicState = isMicrophoneOn

                microphoneOffTime = microphoneOffTime + 1
                isMicrophoneOn = microphoneOffTime <= 2 

                if previousMicState ~= isMicrophoneOn then
                    pings.talking(isMicrophoneOn)
                end
            end

            if client:isModLoaded("figurasvc") and host:isHost() then
                function events.HOST_MICROPHONE(pcm)
                    microphoneOffTime = 0
                end
            end






        
-- CODE SNIPPET #3: ACTION WHEEL

        local anims = require("EZAnims")   -- YOU WILL WANT THE EZANIMS SCRIPT DOWNLOADED TOO. YOU JUST WILL. YOU ALWAYS WILL. ALSO JUST LEAVE THESE 3 LINES PLEASE
        local customAnimPlaying = nil
        local animToRestart = nil

-- PAGES SECTION
        -- This is where you can make a custom Action Wheel. I have already included code (mostly written by people other than myself) as an example. I will help explain what it all does.
        -- This section specifically is where you can add pages to your action wheel. 

            local mainPage = action_wheel:newPage()    -- this is where you add more pages
            local secondPage = action_wheel:newPage()

            action_wheel:setPage(mainPage)    -- this is where you say what the default page is

            local toSecond = mainPage:newAction()       -- this is where you create actions that let you click between pages IN GAME.
                :title("Secondary Page Example")
                :item("minecraft:stick")
                :onLeftClick(function()
                log("Swapped to the second page")
                action_wheel:setPage(secondPage)
            end)

            local toMain = secondPage:newAction()
                :title("Main Page Example")
                :item("minecraft:grass_block")
                :onLeftClick(function()
                log("Swapped to the main page")
                action_wheel:setPage(mainPage)
                end)

        -- If you want to add another page, you would add 'local thirdPage = action_wheel:newPage()' under the line 'local secondPage = action_wheel:newPage'
            -- Then, you would add this:
                    -- local toThird = secondPage:newAction()
                        -- :title("Third Page Example")
                        -- :item("minecraft:furnace")           <-- This can be whatever block you want.
                        -- :onLeftClick(function()              <-- This says that it will activate upon being left-clicked
                        -- log ("Swapped to the third page")    <-- This is just a log function to show you in in-game chat that it worked
                        -- action_wheel:setPage(thirdPage)      <-- This is what it is told to do upon being clicked. In this case, it sets the page to be the third page.





-- PING FUNCTIONS SECTION 
    --('PINGS' ALLOW OTHER PLAYERS TO SEE THE ACTION YOU CLICKED. THESE PINGS ALSO DEFINE WHAT THAT ACTION *IS*.)

        -- PING FUNCTION EXAMPLE #1: Normal Easy Action
                    -- This is generally how an action is formatted. You would put whatever you want to happen inside the function here. Each new function/action should have its own unique name.
                function pings.exampleActionClicked()
                    print("Hello World! If I was an animation that had been told to play, I would be playing now!")
                end

                function pings.exampleStopActionClicked()
                    print("Bye World! If I was an animation that had been told to play, I would stop now!")
                end




        -- PING FUNCTION EXAMPLE #2: Toggle Action
                    -- This action will allow you to toggle something on/off. You can make an action function as a toggle in different ways too, but this is how the ACTUAL toggle action looks.
                    -- Currently this toggle will just turn you visible and invisible.

                function pings.toggling(state)
                    models:setVisible(state)
                    -- animation toggle example (commented out to avoid erroring):
                    -- animations.bbmodelname.animationname:setPlaying(state)
                end




        -- PING FUNCTION EXAMPLE #3: Anim Stop + Restart Action
                    --This action will stop an animation, 'nameOfAnimationToStop',  from playing when 'nameOfAnimationToPlay' is playing, and then restart 'nameOfAnimationToStop' when 'nameOfAnimationToPlay' is done.
                    -- For example, I use this with my Jester Dance animation. I pause my 'idle' animation while 'jesterdance' is playing, and then restart 'idle' when 'jesterdance' is over.
                
                -- function pings.nameOfThisActionActionClicked()
                --    animations.model.nameOfAnimationToPlay:play()
                --    animations.model.nameOfAnimationToStop:stop()
                --    if customAnimPlaying ~= nil then customAnimPlaying:stop()
                --    customAnimPlaying = animations.model.nameOfAnimationToPlay
                --    animToRestart = animations.model.nameOfAnimationToStop
                --end

                    -- Here is what my jesterdance example looked like. (NOTE: you would replace 'model' with whatever you named your model file in Blockbench):

                    -- function pings.jesterActionClicked()                     <--- This defines what action just got clicked. In this case, I called it the jesterActionClicked.
                        -- animations.model.jesterdance:play()                  <--- This part tells Figura what to do when that action gets clicked. AKA, what animation to play.
                        -- animations.model.idle:stop()                         <--- These next 4 lines are part of the code my Dad wrote. This one tells it to stop playing the idle animation when I play 'jesterdance'. 
                        -- if customAnimPlaying ~= nil then customAnimPlaying:stop() end    
                        -- customAnimPlaying = animations.model.jesterdance
                        -- animToRestart = animations.model.idle                <--- This tells it to restart the idle animation once the jesterdance animation has stopped playing.
                    -- end




-- ACTIONS SECTION
        -- This is where you actually create the 'action' on the action wheel - AKA the button to click on in game.
        -- These actions will play the ping functions you write above. Each function will need its own action down here.
        -- To make a new action, just copy the one below and customise it accordingly. The only thing you will need to make sure you change is which ping function the action activate.


                local action = mainPage:newAction()          -- <-- This is where you specify what PAGE you want it to appear on.
                    :title("Example")
                    :item("minecraft:stick")
                    :hoverColor(1, 0, 1)
                    :onLeftClick(pings.exampleActionClicked)       -- <-- Specifies which ping function this action will activate when clicked.
                    :onRightClick(pings.exampleStopActionClicked)


                -- This is the respective action for the toggle ping function above. 
                local toggleAction = secondPage:newAction()
                    --:setToggled(true)             -- <-- If you want the toggle to be ON by default, INCLUDE this line of code.
                    :title("Toggle is Off")
                    :toggleTitle("Toggle is On")
                    :item("red_wool")
                    :toggleItem("green_wool")
                    :setOnToggle(pings.toggling)








-- CUSTOMANIMPLAYING HANDLING + FUNCTIONALITY FOR EZANIMS SCRIPT. LEAVE THIS BIT ALONE PLEASE

                    local function getInfo()
                            if customAnimPlaying ~= nil then
                            if not customAnimPlaying:isPlaying() then
                                animToRestart:play()
                                customAnimPlaying = nil
                            end
                        end
                    end

                    function events.tick()
                        getInfo()
                    end


-- ANY ADDITIONAL / NEW CODE (THAT IS UNRELATED TO CODE SNIPPETS ABOVE) SHOULD GO BELOW HERE!