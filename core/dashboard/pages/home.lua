local function newFeedItem(pfp, name, date, body)
    local item = teverse.construct("guiFrame", {
        size = guiCoord(1, -20, 0, 48),
        position = guiCoord(0, 10, 0, 40),
        backgroundAlpha = 0,
        name = "feedItem"
    })

    teverse.construct("guiImage", {
        name = "profilePicture",
        size = guiCoord(0, 30, 0, 30),
        position = guiCoord(0, 0, 0, 5),
        image = pfp,
        parent = item,
        strokeRadius = 15,
        strokeAlpha = 0.04
    })

    local name = teverse.construct("guiTextBox", {
        name = "username",
        size = guiCoord(1, -40, 0, 20),
        position = guiCoord(0, 40, 0, 3),
        backgroundAlpha = 0,
        parent = item,
        text = name,
        textSize = 20,
        textAlpha = 0.6,
        textFont = "tevurl:fonts/openSansBold.ttf"
    })
    
    teverse.construct("guiTextBox", {
        name = "date",
        size = guiCoord(1, -50, 0, 14),
        position = guiCoord(0, 40, 0, 3),
        backgroundAlpha = 0,
        parent = item,
        text = date,
        textAlign = enums.align.middleRight,
        textSize = 14,
        textAlpha = 0.4,
        textWrap = true
    })
    
    teverse.construct("guiTextBox", {
        name = "body",
        size = guiCoord(1, -50, 1, -28),
        position = guiCoord(0, 40, 0, 22),
        backgroundAlpha = 0,
        parent = item,
        text = body,
        textWrap = true,
        textAlign = enums.align.topLeft,
        textSize = 16
    })

    return item
end

return {
    name = "Home",
    iconId = "sliders-h",
    iconType = "faSolid",
    setup = function(page)
        page.backgroundAlpha = 1.0

        local feed = teverse.construct("guiScrollView", {
            parent = page,
            size = guiCoord(1, 0, 1, 50),
            position = guiCoord(0, 0, 0, -50),
            backgroundAlpha = 0,
            strokeRadius = 3
        })

        teverse.guiHelper
            .bind(feed, "xs", {
                size = guiCoord(1, 0, 1, 50),
                position = guiCoord(0, 0, 0, -50)
            })
            .bind(feed, "lg", {
                size = guiCoord(1, 0, 1, 0),
                position = guiCoord(0, 0, 0, 0)
            })

        local tevs = teverse.construct("guiFrame", {
            parent = feed,
            size = guiCoord(1/3, -20, 0, 70),
            position = guiCoord(0, 10, 0, 0),
            backgroundColour = colour.rgb(74, 140, 122),
            strokeRadius = 3
        })

        teverse.guiHelper
            .bind(tevs, "xs", {
                size = guiCoord(1, -20, 0, 70),
                position = guiCoord(0, 10, 0, 50)
            })
            .bind(tevs, "sm", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(0, 10, 0, 50)
            })
            .bind(tevs, "lg", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(0, 10, 0, 0)
            })

        local tevCoins = teverse.construct("guiTextBox", {
            parent = tevs,
            size = guiCoord(0.5, 0, 0, 40),
            position = guiCoord(0.5, 0, 0.5, -15),
            backgroundAlpha = 0,
            text = "",
            textSize = 34,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        teverse.construct("guiTextBox", {
            parent = tevs,
            size = guiCoord(0.5, -10, 0, 18),
            position = guiCoord(0.5, 0, 0.5, -24),
            backgroundAlpha = 0,
            text = "Tevs",
            textSize = 18,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansLight.ttf"
        })

        teverse.construct("guiIcon", {
            parent = tevs,
            size = guiCoord(0, 40, 0, 40),
            position = guiCoord(0.5, -60, 0.5, -20),
            iconMax = 40,
            iconColour = colour(1, 1, 1),
            iconType = "faSolid",
            iconId = "coins",
            iconAlpha = 0.9
        })

        local membership = teverse.construct("guiFrame", {
            parent = feed,
            size = guiCoord(1/3, -20, 0, 70),
            position = guiCoord(1/3, 10, 0, 0),
            backgroundColour = colour.rgb(235, 187, 83),
            strokeRadius = 3
        })

        teverse.guiHelper
            .bind(membership, "xs", {
                size = guiCoord(1, -20, 0, 70),
                position = guiCoord(0, 10, 0, 80 + 50)
            })
            .bind(membership, "sm", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(1/3, 10, 0, 50)
            })
            .bind(membership, "lg", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(1/3, 10, 0, 0)
            })

        teverse.construct("guiTextBox", {
            parent = membership,
            size = guiCoord(0.5, -5, 0, 18),
            position = guiCoord(0.5, 0, 0.5, -24),
            backgroundAlpha = 0,
            text = "Membership",
            textSize = 18,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansLight.ttf"
        })

        local membershipText = teverse.construct("guiTextBox", {
            parent = membership,
            size = guiCoord(0.5, 0, 0, 40),
            position = guiCoord(0.5, 0, 0.5, -15),
            backgroundAlpha = 0,
            textSize = 34,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        local membertype = teverse.networking.localClient.membership
        if membership == "plus" then
            membershipText.text = "Plus"
        elseif membership == "pro" then
            membershipText.text = "Pro"
        else
            membershipText.text = "Free"
        end

        teverse.construct("guiIcon", {
            parent = membership,
            size = guiCoord(0, 40, 0, 40),
            position = guiCoord(0.5, -60, 0.5, -20),
            iconMax = 40,
            iconColour = colour(1, 1, 1),
            iconType = "faSolid",
            iconId = "crown",
            iconAlpha = 0.9
        })

        local version = teverse.construct("guiFrame", {
            parent = feed,
            size = guiCoord(1/3, -20, 0, 70),
            position = guiCoord(2/3, 10, 0, 0),
            backgroundColour = colour.rgb(216, 100, 89),
            strokeRadius = 3
        })

        teverse.guiHelper
            .bind(version, "xs", {
                size = guiCoord(1, -20, 0, 70),
                position = guiCoord(0, 10, 0, 160 + 50)
            })
            .bind(version, "sm", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(2/3, 10, 0, 50)
            })
            .bind(version, "lg", {
                size = guiCoord(1/3, -20, 0, 70),
                position = guiCoord(2/3, 10, 0, 0)
            })

        teverse.construct("guiTextBox", {
            parent = version,
            size = guiCoord(0.5, -5, 0, 18),
            position = guiCoord(0.5, 0, 0.5, -24),
            backgroundAlpha = 0,
            text = "Build",
            textSize = 18,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansLight.ttf"
        })

        teverse.construct("guiTextBox", {
            parent = version,
            size = guiCoord(0.5, 0, 0, 40),
            position = guiCoord(0.5, 0, 0.5, -15),
            backgroundAlpha = 0,
            text = _TEV_BUILD,
            textSize = 34,
            textAlign = "middleLeft",
            textColour = colour(1, 1, 1),
            textFont = "tevurl:fonts/openSansBold.ttf"
        })

        teverse.construct("guiIcon", {
            parent = version,
            size = guiCoord(0, 40, 0, 40),
            position = guiCoord(0.5, -60, 0.5, -20),
            iconMax = 40,
            iconColour = colour(1, 1, 1),
            iconType = "faSolid",
            iconId = "code-branch",
            iconAlpha = 0.9
        })

        teverse.http:get("https://teverse.com/api/users/me/tevs", {
            ["Authorization"] = "BEARER " .. teverse.userToken
        }, function(code, body)
            if code == 200 then
                tevCoins.text = body
            end
        end)

        local feedItems = teverse.construct("guiFrame", {
            parent = feed,
            backgroundAlpha = 1,
            clip = true
        })

        teverse.guiHelper
            .bind(feedItems, "xs", {
                size = guiCoord(1, -20, 1, -(240 + 50)),
                position = guiCoord(0, 10, 0, 240 + 50)
            })
            .bind(feedItems, "sm", {
                size = guiCoord(1, -20, 1, -(70 + 60)),
                position = guiCoord(0, 10, 0, 70 + 60)
            })
            .bind(feedItems, "lg", {
                size = guiCoord(1/3, -20, 1, -80),
                position = guiCoord(0, 10, 0, 80)
            })

        local input = teverse.construct("guiTextBox", {
            parent = feedItems,
            size = guiCoord(1, -20, 0, 30),
            position = guiCoord(0, 10, 0, 10),
            strokeAlpha = 0.15,
            strokeRadius = 3,
            textEditable = true,
            textAlign = "topLeft"
        })

        local newestFeed = ""
        local lastRefresh = 0 

        local function refresh()
            lastRefresh = os.clock()
            teverse.http:get("https://teverse.com/api/feed", {
                ["Authorization"] = "BEARER " .. teverse.userToken
            }, function(code, body)
                if code == 200 then
                    lastRefresh = os.clock()
                    local json = teverse.json:decode(body)
                    if #json > 0 then
                        if json[1].id == newestFeed then
                            -- no change from last refresh
                            return nil
                        else
                            -- may require refactoring
                            for _,v in pairs(feedItems.children) do
                                if v.name == "feedItem" then
                                    v:destroy()
                                end
                            end
                        end
                        newestFeed = json[1].id
                        local y = 50
                        for _,v in pairs(json) do
                            local date = os.date("%d/%m/%Y %H:%M", os.parseISO8601(v.postedAt))
                            local item = newFeedItem("tevurl:asset/user/" .. v.postedBy.id, v.postedBy.username, date, v.message)
                            item.parent = feedItems
                            local dy = item:child("body").textDimensions.y
                            item.size = guiCoord(1, -20, 0, dy + 28)
                            item.position = guiCoord(0, 10, 0, y)
                            y = y + dy + 28
                        end

                        feed.canvasSize = guiCoord(1, 0, 0, feedItems.absolutePosition.y + y + 100)
                    else
                        feed.canvasSize = guiCoord(1, 0, 0, 0)
                    end
                end
            end)
        end

        local submitting = false
        input:on("keyUp", function(keycode)
            if keycode == "KEY_RETURN" and not submitting then
                submitting = true
                input.textEditable = false
                input.textAlpha = 0.5
                local payload = teverse.json:encode({ message = input.text }) 
                teverse.http:post("https://teverse.com/api/feed", payload, {
                    ["Authorization"] = "BEARER " .. teverse.userToken,
                    ["Content-Type"] = "application/json"
                }, function(code, body)
                    refresh()
                    input.text = ""
                    input.textEditable = true
                    input.textAlpha = 1.0
                    submitting = false
                end)
            end
        end)

        refresh()
        spawn(function()
            while sleep(2.5) do
                if page.Visible and os.clock() - lastRefresh > 2 then
                    refresh()
                end
            end
        end)
    end
}