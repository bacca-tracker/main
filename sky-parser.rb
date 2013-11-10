# This doesn't work, as sky don't update these scores live :(

require_relative 'game.rb'

require 'open-uri'

class SkyParser

LOCAL = "index.html"
REMOTE = "http://www1.skysports.com/nfl/index.html"

  def ss_parser
    side_ones = []
    results_one = []
    side_twos = []
    results_two = []

    next_line_is_result = false
    f = open(REMOTE)
    f.each_line {
    | line |
      if next_line_is_result
        next_line_is_result = false
        throw unless line =~ /(\d+) - (\d+)/
        results_one.push($1)
        results_two.push($2)
      end
      if line =~ /\"score-side1\"\>(.+)\</
        side_ones.push($1)
      elsif line =~ /\"score-side2\"\>(.+)\</
        side_twos.push($1)
      elsif (line =~ /score-status score-post/)
        next_line_is_result = true
      end
    }

    games = []
    number_of_games = side_ones.length
    number_of_games.times { | i |
      g = Game.new(side_ones[i], side_twos[i], results_one[i], results_two[i])
      games.push(g)
    }
    return games
  end

  # Yucky, just for a bit of temporary debug
  def local_ss_parser
    side_ones = []
    results_one = []
    side_twos = []
    results_two = []

    next_line_is_result = false
    f = File.open(LOCAL)
    f.each_line {
    | line |
      if next_line_is_result
        next_line_is_result = false
        throw unless line =~ /(\d+) - (\d+)/
        results_one.push($1)
        results_two.push($2)
      end
      if line =~ /\"score-side1\"\>(.+)\</
        side_ones.push($1)
      elsif line =~ /\"score-side2\"\>(.+)\</
        side_twos.push($1)
      elsif (line =~ /score-status score-post/)
        next_line_is_result = true
      end
    }
    games = []
    number_of_games = side_ones.length
    number_of_games.times { | i |
      g = Game.new(side_ones[i], side_twos[i], results_one[i], results_two[i])
      games.push(g)
    }
    return games
  end

  def parse
#    ss_parser
    local_ss_parser
  end

end
