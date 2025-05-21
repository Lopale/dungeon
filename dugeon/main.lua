-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Titre de la fenêtre
title = "Dungeon tour"

modeDev = true -- Me permet d'avoir des outils qui ne sont accèssible que pendant le DEV

local sceneDungeon = require("sceneDungeon") -- On charge le module sceneDungeon (Pas besoin d'indiquer l'extension)
local sceneEditor = require("sceneEditor") -- On charge le module sceneEditor (Pas besoin d'indiquer l'extension)


local sceneCourante = sceneDungeon -- La scène courante est celle sur laquelle on est, ici par défaut il s'agit de la scène du dungeon mais il pourrait s'agir d'un menu


function changeScene(key) -- Changer de scene au clavier le temps du dev vers l'editeur de niveau
    if modeDev == true then
        if(key)== "m" then -- m pour map
            sceneCourante = sceneEditor
        end
        if(key)== "d" then -- d pour dungeon
            sceneCourante = sceneDungeon
        end
       
        print("key :",key)
    end
end

function love.load()
    love.window.setTitle( title )
    sceneCourante.load()
end

function love.update(dt)
    sceneCourante.update(dt)
end

function love.draw()
    love.graphics.scale(2,2) -- on agrandit par 2 la taille des éléments affichés
    sceneCourante.draw()
end

function love.keypressed(key)
    changeScene(key)
    sceneCourante.keypressed(key)
end



function love.mousepressed(x, y, button, istouch)
    sceneCourante.mousepressed(x, y, button, istouch)
end