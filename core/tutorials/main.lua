local containerNegativePadding = teverse.construct("guiFrame", {
    parent = teverse.interface,
    size = guiCoord(1, 0, 1, 100),
    position = guiCoord(0, 0, 0, -50)
})

local container = teverse.construct("guiScrollView", {
    parent = containerNegativePadding,
    size = guiCoord(1, 0, 1, -100),
    position = guiCoord(0, 0, 0, 50),
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
            size = guiCoord(1.0, -20, 0, 18),
            position = guiCoord(0, 10, 0, 42),
            backgroundAlpha = 0,
            text = page.description,
            textSize = 18,
            textAlign = "middleLeft"
        })
    elseif page.type == "" then

    end

    if pagei == #tutorial.pages then
        teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 90, 0, 30),
            position = guiCoord(1, -110, 1, -50),
            text = "Finished",
            textSize = 20,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = colour.rgb(235, 187, 83),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })
    else
        local btn = teverse.construct("guiTextBox", {
            parent = lessonFrame,
            size = guiCoord(0, 80, 0, 30),
            position = guiCoord(1, -100, 1, -50),
            text = "Next",
            textSize = 24,
            textAlign = "middle",
            textFont = "tevurl:fonts/openSansBold.ttf",
            backgroundColour = colour.rgb(74, 140, 122),
            textColour = colour.white(),
            dropShadowAlpha = 0.2
        })

        btn:on("mouseLeftUp", function()
            loadTutorialPage(tutorial, pagei + 1, lessonFrame)
        end)

        teverse.guiHelper.hoverColour(btn, colour.rgb(235, 187, 83))
    end
end

local function loadTutorial(tutorial)
    container:destroyChildren()
    teverse.construct("guiTextBox", {
        parent = container,
        size = guiCoord(1.0, -20, 0, 48),
        position = guiCoord(0, 10, 0, 10),
        backgroundAlpha = 0,
        text = tutorial.name,
        textSize = 48,
        textAlign = "middleLeft"
    })

    local lessonFrame = teverse.construct("guiFrame", {
        parent = container,
        size = guiCoord(1.0, -20, 1, -70),
        position = guiCoord(0, 10, 0, 60),
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