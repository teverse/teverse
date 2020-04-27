local controller = {}

controller.setup = function()
    local navBar = teverse.construct("guiFrame", {
        strokeAlpha = 0.1,
        parent = teverse.interface,
        zIndex = 10,
        backgroundColour = colour.rgb(52, 58, 64)
    })

    local navContainer = teverse.construct("guiFrame", {
        parent = navBar,
        backgroundAlpha = 0
    })

    teverse.guiHelper
        .gridConstraint(navContainer, {
            cellSize = guiCoord(0, 40, 0, 40),
            cellMargin = guiCoord(0, 25, 0, 25)
        })
        .bind(navBar, "xs", {
            position = guiCoord(0, -45, 1, -65),
            size = guiCoord(1, 90, 0, 105)
        })
        .bind(navContainer, "xs", {
            position = guiCoord(0, 80, 0.5, -40),
            size = guiCoord(1, -160, 0, 40)
        })
        .bind(navBar, "lg", {
            position = guiCoord(0, 0, 0, 0),
            size = guiCoord(0, 65, 1, 0)
        })
        .bind(navContainer, "lg", {
            position = guiCoord(0.5, -20, 0, 80),
            size = guiCoord(0, 40, 1, -80)
        })

    local profilePictureContainer = teverse.construct("guiFrame", {
        parent = navContainer,
        backgroundAlpha = 0,
        name = "0"
    })

    local profilePicture = teverse.construct("guiImage", {
        size = guiCoord(0, 30, 0, 30),
        position = guiCoord(0.5, -15, 0.5, -15),
        image = "tevurl:asset/user/" .. teverse.networking.localClient.id,
        parent = profilePictureContainer,
        strokeRadius = 30,
        name = "0"
    })
    
    local status = teverse.construct("guiImage", {
        size = guiCoord(0, 8, 0, 8),
        position = guiCoord(1, -8, 1, -8),
        backgroundColour = colour(0, 0.9, 0),
        strokeRadius = 6,
        strokeWidth = 2,
        strokeAlpha = 1,
        strokeColour = colour.rgb(52, 58, 64),
        parent = profilePicture
    })
    
    local body = teverse.construct("guiFrame", {
        size = guiCoord(1, -65, 1, 0),
        position = guiCoord(0, 65, 0, 0),
        parent = teverse.interface,
        backgroundColour = colour.rgb(242, 244, 245)
    })

    teverse.guiHelper
        .bind(body, "xs", {
            size = guiCoord(1, 90, 1, -5),
            position = guiCoord(0, -45, 0, -60)
        })
        .bind(body, "lg", {
            size = guiCoord(1, -65, 1, 0),
            position = guiCoord(0, 65, 0, 0)
        })

    local pages = {}

    local function setupPage(page)
        local container = teverse.construct("guiFrame", {
            parent = body,
            size = guiCoord(1, -40, 1, -80),
            position = guiCoord(0, 10, 0, 80),
            backgroundAlpha = 0,
            strokeRadius = 3,
            visible = false
        })

        teverse.guiHelper
            .bind(container, "xs", {
                size = guiCoord(1, -120, 1, -80),
                position = guiCoord(0, 60, 0, 80)
            })
            .bind(container, "lg", {
                size = guiCoord(1, 0, 1, -10),
                position = guiCoord(0, 0, 0, 10)
            })

        local icon = teverse.construct("guiIcon", {
            name = tostring(#pages + 1),
            size = guiCoord(0, 40, 0, 40),
            position = guiCoord(0.5, -20, 1, -60),
            parent = navContainer,
            iconId = page.iconId,
            iconType = page.iconType,
            iconAlpha = 0.75,
            iconMax = 20,
            backgroundColour = colour(0, 0, 0),
            strokeRadius = 3
        })

        icon:on("mouseLeftUp", function()
            for _,v in pairs(pages) do
                v[1].visible = false
                v[2].iconAlpha = 0.75
                v[2].backgroundAlpha = 0.0
            end

            container.visible = true
            icon.iconAlpha = 1.0
            icon.backgroundAlpha = 0.2
        end)

        page.setup(container)

        if #pages == 0 then
            container.visible = true
            icon.iconAlpha = 1.0
            icon.backgroundAlpha = 0.2
        end

        table.insert(pages, {container, icon})
    end
    setupPage(require("tevgit:core/dashboard/pages/home.lua"))
    setupPage(require("tevgit:core/dashboard/pages/apps.lua"))

    if _DEVICE:sub(0, 6) ~= "iPhone" then
        if _DEVICE:sub(0, 4) == "iPad" then
            --setupPage(require("tevgit:core/dashboard/pages/developTablet.lua"))
        else
            setupPage(require("tevgit:core/dashboard/pages/developDesktop.lua"))
        end
    end
end

return controller