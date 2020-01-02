function gAC.GetFormattedGlobalText( displayReason, banTime )
    local banString = (gAC.config.BAN_MESSAGE_SYNTAX or code) .. '\n'
    banString = banString .. displayReason

    banTime = _tonumber( banTime )
    if( banTime == -1 ) then
        banString = banString .. "Type: Kick"
    elseif( banTime >= 0 ) then
        if( banTime == 0 ) then
            banString = banString .. "Type: Permanent Ban\n\nPlease appeal if you believe this is false"
        else
            banString = banString .. "Type: Temporary Ban\n\nPlease appeal if you believe this is false"
        end
    end

    return banString
end

_hook_Add("gAC.CLFilesLoaded", "g-AC_getGlobalInfo", function(ply)
    http.Post( "https://stats.g-ac.dev/api/checkban", { player = ply:SteamID64() }, function( result )
        local resp = util.JSONToTable(result)
        if(resp["success"] == "false") then
            print("[g-AC] Fetching global ban data failed: "..resp["error"])
        else
            if(resp["banned"] == "true") then
                ply:Kick(gAC.GetFormattedGlobalText("Global Ban #"..resp["id"], 0))
            end
        end
    end, function( failed )
        print( "g-AC: Fetching global ban data failed: " .. failed )
    end )
end)