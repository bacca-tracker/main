
####################
# Public Interface #
####################
def token_to_display_name(tok)
  TOKEN_TO_DISPLAY_NAME[tok]
end

def string_to_token(str)
  ret = TEAM_TOKENIZER[str]
  # This lookup should never fail.
  raise(FailedToParseException.new, "Failed to find: '#{str}'") if ret.nil?
  return ret
end

#############
# Internals #
#############
class TeamStringNotFoundException < RuntimeError

end

# Abstract the strings that various sites use to refer to teams into tokens for our internal use.
TEAM_TOKENIZER = {
  "Buffalo Bills" => "BUF",
  "Buffalo"       => "BUF",
  "BUF"           => "BUF",

  "Cleveland Browns" => "CLE",
  "Cleveland"        => "CLE",
  "CLE"              => "CLE",

  "New Orleans Saints"  => "NO",
  "New Orleans"         => "NO",
  "NO"                  => "NO",

  "New England"          => "NE",
  "New England Patriots" => "NE",
  "NE"                   => "NE",

  "Detroit Lions" => "DET",
  "Detroit"       => "DET",
  "DET"           => "DET",

  "Green Bay Packers" => "GB",
  "Green Bay"         => "GB",
  "GB"                => "GB",

  "Seattle Seahawks" => "SEA",
  "Seattle"          => "SEA",
  "SEA"              => "SEA",

  "Baltimore Ravens" => "BAL",
  "Baltimore"        => "BAL",
  "BAL"              => "BAL",

  "Miami Dolphins" => "MIA",
  "Miami"          => "MIA",
  "MIA"            => "MIA",

  "Minnesota Vikings" => "MIN",
  "Minnesota"         => "MIN",
  "MIN"               => "MIN",

  "Cincinnati Bengals" => "CIN",
  "Cincinnati"         => "CIN",
  "CIN"                => "CIN",

  "Philadelphia Eagles" => "PHI",
  "Philadelphia"        => "PHI",
  "PHI"                 => "PHI",

  "Pittsburgh Steelers" => "PIT",
  "Pittsburgh"          => "PIT",
  "PIT"                 => "PIT",

  "Chicago Bears" => "CHI",
  "Chicago"       => "CHI",
  "CHI"           => "CHI",

  "Indianapolis Colts" => "IND",
  "Indianapolis"       => "IND",
  "IND"                => "IND",

  "New York Giants"   => "NYG",
  "NY Giants"         => "NYG",
  "N.Y. Giants"       => "NYG",
  "NYG"               => "NYG",

  "Jacksonville Jaguars" => "JAC",
  "Jacksonville"         => "JAC",
  "JAC"                  => "JAC",

  "St. Louis Rams" => "STL",
  "St Louis Rams"  => "STL",
  "St. Louis"      => "STL",
  "St Louis"       => "STL",
  "STL"            => "STL",

  "Kansas City Chiefs" => "KC",
  "Kansas City"        => "KC",
  "KC"                 => "KC",

  "Tennessee Titans" => "TEN",
  "Tennessee"        => "TEN",
  "TEN"              => "TEN",

  "Carolina Panthers" => "CAR",
  "Carolina"          => "CAR",
  "CAR"               => "CAR",

  "Arizona Cardinals" => "ARI",
  "Arizona"           => "ARI",
  "ARI"               => "ARI",

  "Denver Broncos" => "DEN",
  "Denver"         => "DEN",
  "DEN"            => "DEN",

  "Dallas Cowboys" => "DAL",
  "Dallas"         => "DAL",
  "DAL"            => "DAL",

  "Houston Texans" => "HOU",
  "Houston"        => "HOU",
  "HOU"            => "HOU",

  "San Francisco 49'ers" => "SF",
  "San Francisco 49ers"  => "SF",
  "San Francisco"        => "SF",
  "SF"                   => "SF",

  "San Diego Chargers" => "SD",
  "San Diego"          => "SD",
  "SD"                 => "SD",

  "Oakland Raiders" => "OAK",
  "Oakland"         => "OAK",
  "OAK"             => "OAK",

  "New York Jets"   => "NYJ",
  "NY Jets"         => "NYJ",
  "N.Y. Jets"       => "NYJ",
  "NYJ"             => "NYJ",

  "Washington Redskins" => "WAS",
  "Washington"          => "WAS",
  "WAS"                 => "WAS",

  "Tampa Bay Buccaneers" => "TB",
  "Tampa Bay Buccs"      => "TB",
  "Tampa Bay"            => "TB",
  "TB"                   => "TB",

  "Atlanta Falcons" => "ATL",
  "Atlanta"         => "ATL",
  "ATL"             => "ATL",
}


# Tokens to something I prefer to read
TOKEN_TO_DISPLAY_NAME = {
  "BUF" => "Buffalo",
  "CLE" => "Cleveland",
  "NO"  => "New Orleans",
  "NE"  => "New England",
  "DET" => "Detroit",
  "GB"  => "Green Bay",
  "SEA" => "Seattle",
  "BAL" => "Baltimore",
  "MIA" => "Miami",
  "MIN" => "Minnesota",
  "CIN" => "Cincinnati",
  "PHI" => "Philadelphia",
  "PIT" => "Pittsburgh",
  "CHI" => "Chicago",
  "IND" => "Indianapolis",
  "NYG" => "NY Giants",
  "JAC" => "Jacksonville",
  "STL" => "St. Louis",
  "KC"  => "Kansas City",
  "TEN" => "Tennessee",
  "CAR" => "Carolina",
  "ARI" => "Arizona",
  "DEN" => "Denver",
  "DAL" => "Dallas",
  "HOU" => "Houston",
  "SF"  => "San Francisco",
  "SD"  => "San Diego",
  "OAK" => "Oakland",
  "NYJ" => "NY Jets",
  "WAS" => "Washington",
  "TB"  => "Tampa Bay",
  "ATL" => "Atlanta"
}
