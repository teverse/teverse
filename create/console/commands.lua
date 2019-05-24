return  {
    echo = {
        commands = {"echo", "repeat"}; -- Allows for aliases
        arguments = {"textToEcho"};
        description = "Echoes the given text back to you in the console - Used as a test command";
        execute = function(args)
            print(args[1]) --// prints the contents of the first argument
        end;
    };
}