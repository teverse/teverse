return {
    titleDesc = function(title, description)
        return {
            type = "titleDesc",
            title = title,
            description = description
        }
    end,
    titleDescCode = function(title, description, code, validator)
        return {
            type = "titleDescCode",
            title = title,
            description = description,
            code = code,
            validator = validator
        }
    end
}