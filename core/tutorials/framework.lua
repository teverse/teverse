return {
    titleDesc = function(title, description)
        return {
            type = "titleDesc",
            title = title,
            description = description
        }
    end,
    interactiveCode = function(title, description, code, validator)
        return {
            type = "titleDescCode",
            title = title,
            description = description,
            code = code,
            validator = validator
        }
    end,
    exampleCode = function(title, description, code, exampleOutput)
        return {
            type = "exampleCode",
            title = title,
            description = description,
            code = code,
            output = exampleOutput
        }
    end
}