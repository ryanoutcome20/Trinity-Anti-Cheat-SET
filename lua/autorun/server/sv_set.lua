-----------------------
-- Server Exec Tool --
-----------------------

/*
    This is a tool I (ryanoutcome20) use to debug stuff in various
    servers that are willing to give me access to their server exec.
    
    You don't have to run this and it doesn't run by default.
*/

SET = { }

function SET.Print(Text, ...)
    Text = string.format(Text, ...)

    for k, Player in ipairs(player.GetAll()) do
        if Player:IsSuperAdmin() then
            Player:ChatPrint(Text)
        end
    end
end

function SET.AddNetworkWrapper(Name, Callback)
    util.AddNetworkString(Name)

    net.Receive(Name, function(Length, Player)
        if not Player:IsSuperAdmin() then
            return SET.Print("! Failed to exec: `%` (%s has no privileges)", Name, Player:Name())
        end

        Callback(Player)
    end)
end 

function SET.Run(Player)
    local Data = {}

    if net.ReadBool() then
        Data = { CompileString(net.ReadString())() }
    else
        Data = string.Split(net.ReadString(), " ")
        RunConsoleCommand(Data[1], Data[2])
        Data = {}
    end

    if #Data == 0 then return end

    SET.Print("! SET.Run Output: ")

    for k,v in pairs(Data) do 
        SET.Print("     `%s` -> %s", tostring(v), type(v))
    end
end

SET.AddNetworkWrapper("SET.Run", SET.Run)