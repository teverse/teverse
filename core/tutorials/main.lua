local containerNegativePadding = teverse.construct("guiFrame", {
    parent = teverse.interface,
    size = guiCoord(1, 0, 1, 100),
    position = guiCoord(0, 0, 0, -50)
})

local container = teverse.construct("guiScrollView", {
    parent = containerNegativePadding,
    size = guiCoord(1, 0, 1, -100),
    position = guiCoord(0, 0, 0, 50),
    canvasSize = guiCoord(1, 0, 1, 0),
    backgroundAlpha = 0,
})

teverse.construct("guiTextBox", {
    parent = container,
    size = guiCoord(1.0, -20, 0, 48),
    position = guiCoord(0, 10, 0, 10),
    backgroundAlpha = 0,
    text = "Learn Code",
    textSize = 48,
    textAlign = "middleLeft"
})

local y = 70

local function loadTutorialPage(tutorial, pagei, lessonFrame)
    lessonFrame:destroyChildren()
    local page = tutorial.pages[pagei]
    local allowContinue = true
    local btn = nil
    
    if page.type == "titleDesc" then
        teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(1.0, -20, 0, 32),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = page.title,
            textSize = 32,
            textAlign = "middleLeft",
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(1.0, -20, 1, -50),
            position = guiCoord(0, 10, 0, 42),
            backgroundAlpha = 0,
            text = page.description,
            textSize = 18,
            textAlign = "topLeft",
            textWrap = true
        })
    elseif page.type == "titleDescCode" then
        teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(1.0, -20, 0, 32),
            position = guiCoord(0, 10, 0, 10),
            backgroundAlpha = 0,
            text = page.title,
            textSize = 32,
            textAlign = "middleLeft",
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        local desc = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(1.0, -20, 1, -50),
            position = guiCoord(0, 10, 0, 42),
            backgroundAlpha = 0,
            text = page.description,
            textSize = 18,
            textAlign = "topLeft",
            textWrap = true
        })

        local textDimensions = desc.textDimensions.y
        desc.size = guiCoord(1, -20, 0, textDimensions)

        local output, outputtxt = require("tevgit:core/tutorials/output.lua").create()
        output.parent = lessonFrame
        output.position = guiCoord(0.5, 10, 0, textDimensions + 52)
        output.size = guiCoord(0.5, -20, 1, -(textDimensions + 102))

        local editor, editortxt = require("tevgit:core/editor/editor.lua").create()
        editor.parent = lessonFrame
        editor.position = guiCoord(0, 10, 0, textDimensions + 52)
        editor.size = guiCoord(0.5, -20, 1, -(textDimensions + 102))
        editortxt.text = page.code

        teverse.guiHelper.bind(editor, "xs", {
            size = guiCoord(1.0, -20, 0.5, -52)
        }).bind(editor, "md", {
            size = guiCoord(0.5, -20, 1, -(textDimensions + 102))
        })

        teverse.guiHelper.bind(output, "xs", {
            size = guiCoord(1.0, -20, 0.5, -(textDimensions + 60)),
            position = guiCoord(0, 10, 0.5, textDimensions + 10)
        }).bind(output, "md", {
            size = guiCoord(0.5, -20, 1, -(textDimensions + 102)),
            position = guiCoord(0.5, 10, 0, textDimensions + 52)
        })

        local run = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 90, 0, 30),
            position = guiCoord(1, -235, 1, -35),
            text = "Run",
            textSize = 24,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = colour.rgb(74, 140, 122),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })
        teverse.guiHelper.hoverColour(run, colour.rgb(235, 187, 83))

        local reset = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 90, 0, 30),
            position = guiCoord(1, -340, 1, -35),
            text = "Reset",
            textSize = 24,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = colour.rgb(74, 140, 122),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })
        teverse.guiHelper.hoverColour(reset, colour.rgb(235, 187, 83))
        allowContinue = false

        run:on("mouseLeftUp", function()
            outputtxt.text = ""
            local f, msg = loadstring(editortxt.text)
            if not f then
                outputtxt.text = "Error when running your code:\n"..msg
            else
                local success, result = pcall(f)
                if not success then
                    outputtxt.text = "Error when running your code:\n"..result
                else
                    if page.validator then
                        allowContinue = page.validator(editortxt, outputtxt)
                    else
                        allowContinue = true
                    end

                    if allowContinue and btn then
                        btn.backgroundColour = colour.rgb(235, 187, 83)
                    end
                end
            end
        end)
        
        reset:on("mouseLeftUp", function()
            outputtxt.text = ""
            editortxt.text = page.code
        end)
    elseif page.type == "exampleCode" then
        local editor, editortxt = require("tevgit:core/editor/editor.lua").create()
        editor.parent = lessonFrame
        editor.position = guiCoord(0, 10, 0, 10)
        editor.size = guiCoord(0.5, -20, 1, -20)
        editortxt.text = page.code
        editortxt.textEditable = false

        teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0.5, -20, 0, 32),
            position = guiCoord(0.5, 10, 0, 10),
            backgroundAlpha = 0,
            text = page.title,
            textSize = 32,
            textAlign = "middleLeft",
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        local desc = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0.5, -20, 1, -100),
            position = guiCoord(0.5, 10, 0, 42),
            backgroundAlpha = 0,
            text = page.description,
            textSize = 18,
            textAlign = "topLeft",
            textWrap = true,
            active = false
        })

        if page.output then
            local descDimensions = desc.textDimensions
            local output, outputtxt = require("tevgit:core/tutorials/output.lua").create(true)
            outputtxt.text = page.output
            output.parent = lessonFrame
            output.position = guiCoord(0.5, 10, 0, descDimensions.y + 45)
            output.size = guiCoord(0.5, -20, 0, outputtxt.textDimensions.y + 44)
        end
        allowContinue = true
    end

    if pagei == #tutorial.pages then
        btn = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 90, 0, 30),
            position = guiCoord(1, -140, 1, -35),
            text = "Finished",
            textSize = 20,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = colour.rgb(122, 122, 122),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })
    else
        btn = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 80, 0, 30),
            position = guiCoord(1, -130, 1, -35),
            text = "Next",
            textSize = 24,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = allowContinue and colour.rgb(74, 140, 122) or colour.rgb(122, 122, 122),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })

        btn:on("mouseLeftUp", function()
            if allowContinue then
                loadTutorialPage(tutorial, pagei + 1, lessonFrame)
            end
        end)

        btn:on("mouseEnter", function()
            if allowContinue then
                btn.backgroundColour = colour.rgb(235, 187, 83)
            else
                btn.backgroundColour = colour.rgb(122, 122, 122)
            end
        end)

        btn:on("mouseExit", function()
            if allowContinue then
                btn.backgroundColour = colour.rgb(74, 140, 122)
            end
        end)
    end
end

local function loadTutorial(tutorial)
    container:destroyChildren()

    local lessonFrame = teverse.construct("guiFrame", {
        parent = container,
        size = guiCoord(1.0, -20, 1, 0),
        position = guiCoord(0, 10, 0, 0),
        backgroundAlpha = 0,
    })

    --[[teverse.construct("guiIcon", {
        parent = container,
        size = guiCoord(0, 30, 0, 30),
        position = guiCoord(1, -40, 0, 10),
        iconType = "faSolid",
        iconId = "arrow-circle-left",
        iconColour = colour.black(),
        iconMax = 20,
        backgroundAlpha = 0.05,
        backgroundColour = colour.black(),
        strokeRadius = 4
    })]]

    loadTutorialPage(tutorial, 1, lessonFrame)
end

for i,v in pairs(require("tevgit:core/tutorials/lessons.lua")) do
    local lesson = teverse.construct("guiFrame", {
        parent = container,
        position = guiCoord(0, 10, 0, y),
        size = guiCoord(1, -20, 0, 50),
        backgroundColour = colour.rgb(245, 245, 245),
        dropShadowAlpha = 0.2,
        strokeRadius = 3
    })

    teverse.guiHelper.hoverColour(lesson, colour.white())
    lesson:on("mouseLeftUp", function()
        loadTutorial(v)
    end)

    teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(0, 40, 1, -10),
        position = guiCoord(0, 5, 0, 5),
        backgroundAlpha = 0,
        text = string.format("%02d", i),
        textSize = 32,
        textAlign = "middle",
        textFont = "tevurl:fonts/firaCodeMedium.otf",
        textColour = colour.rgb(211, 54, 130),
        active = false
    })

    teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(1.0, -60, 0, 22),
        position = guiCoord(0, 50, 0, 5),
        backgroundAlpha = 0,
        text = v.name,
        textSize = 22,
        textAlign = "middleLeft",
        textFont = "tevurl:fonts/openSansBold.ttf",
        active = false
    })

    local desc = teverse.construct("guiTextBox", {
        parent = lesson,
        size = guiCoord(1.0, -60, 1, -25),
        position = guiCoord(0, 50, 0, 25),
        backgroundAlpha = 0,
        text = v.description,
        textSize = 18,
        textAlign = "topLeft",
        textWrap = true,
        active = false
    })

    lesson.size = guiCoord(1, -20, 0, 29 + desc.textDimensions.y)

    y = y + 25 + desc.textDimensions.y + 15
end