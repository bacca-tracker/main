
module WebDisplay

  module Modes
    STANDARD = "1"
    GRAPH    = "2"
    NON_REFRESHING_SINGLE = "3"
  end

  # Constants
  RED = "#FF0000"
  YELLOW = "#FFFF00"
  GREEN = "#00FF00"
  WHITE = "#FFFFFF"
  LIGHT_GRAY = "#D3D3D3"

  # Parameters for debug
  ROW_ALT_1 = WHITE
  ROW_ALT_2 = LIGHT_GRAY
  SCALE = 4
  LOCATION_OF_SINGLE_VIEW = "acca-tracker2"
  TABLE_WIDTH = nil
#  TABLE_WIDTH = "150"

  def row_alt_colour(index)
    index.even? ? ROW_ALT_1 : ROW_ALT_2
  end

  def get_status_graph(bet)
    game = bet.game
    home_spread, away_spread = bet.get_home_and_away_spread
    spread_colour = YELLOW
    home_colour, away_colour = ""
    if bet.bet_on_home_team?
      home_colour, away_colour = GREEN, RED
    else
      home_colour, away_colour = RED, GREEN
    end
    str = "<td>\n"
    str += "<div style=\"float: left; width: #{home_spread*SCALE}px; background-color:#{spread_colour}\">&nbsp</div>"
    str += "<div style=\"float: left; width: #{game.home_score*SCALE}px; background-color:#{home_colour}\">#{game.home_score}</div>"
    str += "<br>"
    str += "<div style=\"float: left; width: #{away_spread*SCALE}px; background-color:#{spread_colour}\">&nbsp</div>"
    str += "<div style=\"float: left; width: #{game.away_score*SCALE}px; background-color:#{away_colour}\">#{game.away_score}</div>"
    str += "</td>"
  end

  def get_status_simple(bet)
    "<td bgcolor=\"#{bet.get_colour}\"><center>&nbsp#{bet.display_status}&nbsp</center></td>"
  end

  def get_status_cell(bet, mode)
    if (mode == Modes::STANDARD)
      get_status_simple(bet)
    else
      get_status_graph(bet)
    end
  end

  def puts_name(name)
    puts "<td width=100></td>"
    puts "<td width=30 colspan='3' align='center'>"
    location = LOCATION_OF_SINGLE_VIEW + "?Name=" + name
    puts "<a href=\"#{location}\">"
    puts "<h2>#{name}</h2>"
    puts "</a>"
    puts "</td>"
  end

  def display_html(accumulators, games, mode)
    puts "Content-type: text/html\n\n"
    puts "<html>"
    puts "<head>"
    puts "<title>NFL Betting Results</title>"
    puts "<style>"
    puts "body {font-family:Arial,Helvetica,sans-serif;}"
    puts "</style>"
    puts "<head>"
    puts "<body>"
    puts "<h1>Results</h1>"
    puts "<hr>"
    if TABLE_WIDTH
      puts "<table style=\"border-collapse: collapse; width: #{TABLE_WIDTH}%;\">"
    else
      puts "<table style=\"border-collapse: collapse;\">"
    end
    puts "<thead>"

    puts "<tr>"
    puts "<td align='center' colspan='5'></td>"
    accumulators.each do
    | acc |
      puts_name(acc.name)
    end
    puts "</tr>"

    puts "<tr bgcolor=\"#{row_alt_colour(-1)}\">"
    puts "<td align='center' colspan='5'><b>Game</b></td>"
    accumulators.each do
      puts "<td width=100></td>"
      puts "<td><b>Bet on</b></td>"
      puts "<td width=30></td>"
      puts "<td><b>Status</b></td>"
    end
    puts "</tr>"

    puts "</thead>"
    puts "<tbody>"
    index = 0
    games.each do
    | game |
      puts "<tr bgcolor=\"#{row_alt_colour(index)}\">"
      puts "<td align='right'>#{game.away_team}</td><td align='right'>#{game.away_score}</td><td><b>@</b></td><td>#{game.home_score}</td><td>#{game.home_team}</td>"
      accumulators.each do
      | acc |
        bet = acc.get_bet(game)
        if bet
          puts "<td></td>"
          bet_on_str = bet.bet_on
          bet_on_str += "(#{bet.display_spread})" if bet.spread != 0
          puts "<td>#{bet_on_str}</td>"
          puts "<td></td>"
          puts get_status_cell(bet, mode)
        else
          puts "<td></td>"
          puts "<td></td>"
          puts "<td></td>"
          puts "<td></td>"
        end
      end
      puts "</tr>"
      index += 1
    end
    puts "</tbody>"
    puts "</table>"
    puts "<hr>"
    puts "<i>Generated: #{Time.now} - Mode: #{mode}</i>"
    puts "</body>\n</html>"
  end

end
