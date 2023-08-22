-- amazingcdub

-- Matches Container
local MatchesContainer = {
    Matches = {}
};

function MatchesContainer:FindMatchByPlayer(Player : Player)
    for _, Match in ipairs(self.Matches) do
        if (Match.White == Player or Match.Black == Player) then
            return Match
        end
    end
    warn("Did not find player in a match!")
    return nil
end

return MatchesContainer
