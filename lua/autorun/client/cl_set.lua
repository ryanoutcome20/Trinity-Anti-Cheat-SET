-----------------------
-- Server Exec Tool --
-----------------------

/*
    This is a tool I (ryanoutcome20) use to debug stuff in various
    servers that are willing to give me access to their server exec.
    
    You don't have to run this and it doesn't run by default.
*/

local SET = { }

function SET.Run()
    local Local = LocalPlayer()

    if not Local:IsSuperAdmin() then
        return
    end

    concommand.Add("set_run_cl", function(Player, Command, Arguments, Data)
        RunString(Data)
    end)
    
    concommand.Add("set_run", function(Player, Command, Arguments, Data)
        net.Start("SET.Run")
            net.WriteBool(true)
            net.WriteString(Data)
        net.SendToServer()
    end)

    concommand.Add("set_run_command", function(Player, Command, Arguments, Data)
        net.Start("SET.Run")
            net.WriteBool(false)
            net.WriteString(Data)
        net.SendToServer()
    end)

end

concommand.Add("set_refresh", SET.Run)