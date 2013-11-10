
require_relative 'game.rb'
require_relative 'team-names.rb'

require 'open-uri'

class LeagueParser

  LOCAL = "scorestrip.json"
  REMOTE = "http://www.nfl.com/liveupdate/scorestrip/scorestrip.json"

  def strip_to_comma_seperated_arrays(str)
    str[8..-4] # Hack
  end

  def common_parser(page_text)
    stripped_str = strip_to_comma_seperated_arrays(page_text)
    arr = stripped_str.split("],[")
    games = []
    arr.each {
    | game_str |
      game_arr = game_str.gsub('"',"").split(",")
      # If we can't find the team in the conversion array, just use the initials
      away_team = CODE_TO_NAME[game_arr[4]] || game_arr[4]
      home_team = CODE_TO_NAME[game_arr[6]] || game_arr[6]
      # Replace score "" with nil
      away_score = game_arr[5] == "" ? nil : game_arr[5]
      home_score = game_arr[7] == "" ? nil : game_arr[7]
      final = (game_arr[2] == "Final")
      game = Game.new(home_team, away_team, home_score, away_score, final)
      games.push(game)
    }
    return games
  end

  def local_parser
    common_parser(File.open(LOCAL).read)
  end

  def remote_parser
    common_parser(open(REMOTE).read)
  end

  def parse
#    local_parser
    remote_parser
  end

end
