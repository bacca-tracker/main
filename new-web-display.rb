
require_relative 'colours.rb'

####################
# Public Interface #
####################

def new_display_html(accumulators, games)
  table = DisplayTable.new(accumulators, games)
  viewer = Viewer.new(table)
  viewer.dump_to_stdout
end

#############
# Internals #
#############

class DisplayTable

  attr_reader :game_rows
  attr_reader :game_cols

  def initialize(accumulators, games)
    # @game_rows is a { Game => [Bet,..] }
    @game_rows = {}

    # @game_cols is a { Accumulator => [Bet,..] }
    @game_cols = {}

    games.each { | game |
      @game_rows[game] = []
      accumulators.each { | acc |
        @game_cols[acc] = [] if @game_cols[acc].nil?
        bet = acc.get_bet(game)
        @game_cols[acc].push(bet)
        @game_rows[game].push(bet)
      }
    }
  end

end

# A game is critical, if every accumulator has bet the same way on that game.
def is_critical?(bet_arr)
  team = bet_arr[0].bet_on
  return false if team.nil? # Not everyone has bet on this game.
  bet_arr.each {
  | bet |
    if (bet.bet_on != team)
      return false
    end
  }
  return true
end

CRITICAL_TEXT = "<img src=\"http://upload.wikimedia.org/wikipedia/commons/a/af/Radioactivity_symbol.png\" height=\"20\">"

class Viewer

  # Parameters for debug
  ROW_ALT_1 = WHITE
  ROW_ALT_2 = LIGHT_GRAY
  SCALE = 4
  LOCATION_OF_SINGLE_VIEW = "acca-tracker3"

  def initialize(display_table)
    @html_str = header_boiler_plate
    @html_str += table_header(display_table)
    @html_str += table_body(display_table)
    @html_str += footer_boiler_plate
  end

  def dump_to_stdout
    puts @html_str
  end

private

 def header_boiler_plate
    str = ""
    str += "Content-type: text/html\n\n"
    str += "<html>\n"
    str += "<head>\n"
    str += "<title>NFL Betting Results</title>\n"
    str += "<style>\n"
    str += "body {font-family:Arial,Helvetica,sans-serif;}\n"
    str += "</style>\n"
    str += "</head>\n"
    str += "<body>\n"
    str += "<h1>Results</h1>\n"
    str += "<hr>\n"
    return str
  end

  def format_name(name)
    str = ""
    str += "<td width=100></td>\n"
    str += "<td width=30 colspan='3' align='center'>\n"
    location = LOCATION_OF_SINGLE_VIEW + "?Name=" + name
    str += "<a href=\"#{location}\">\n"
    str += "<h2>#{name}</h2>\n"
    str += "</a>\n"
    str += "</td>\n"
    return str
  end

  def row_alt_colour(index)
    index.even? ? ROW_ALT_1 : ROW_ALT_2
  end

  def table_header(dispaly_table)
    str = ""
    str += "<table style=\"border-collapse: collapse;\">\n"
    str += "<thead>\n"

    str += "<tr>\n"
    str += "<td></td>\n"
    str += "<td align='center' colspan='5'></td>\n"
    dispaly_table.game_cols.each do
    | acc, _ |
      str += format_name(acc.name)
    end
    str += "</tr>\n"

    str += "<tr bgcolor=\"#{row_alt_colour(-1)}\">\n"
    str += "<td></td>\n"
    str += "<td align='center' colspan='5'><b>Game</b></td>\n"
    dispaly_table.game_cols.each do
      str += "<td width=100></td>\n"
      str += "<td><b>Bet on</b></td>\n"
      str += "<td width=30></td>\n"
      str += "<td><b>Status</b></td>\n"
    end
    str += "</tr>\n"

    str += "</thead>\n"
    return str
  end

  def get_status_simple(bet)
    "<td bgcolor=\"#{bet.get_colour}\"><center>&nbsp#{bet.display_status}&nbsp</center></td>"
  end

  def table_one_row(game, bets)
    str = ""
    if (is_critical?(bets))
      str += "<td>#{CRITICAL_TEXT}</td>"
    else
      str += "<td></td>"
    end
    away_team_display = token_to_display_name(game.away_team)
    home_team_display = token_to_display_name(game.home_team)
    str += "<td align='right'>#{away_team_display}</td><td align='right'>#{game.away_score}</td><td><b>@</b></td><td>#{game.home_score}</td><td>#{home_team_display}</td>"

    bets.each do
    | bet |
      if !bet.nil? && !bet.bet_on.nil?
        str += "<td></td>"
        bet_on_str = token_to_display_name(bet.bet_on)
        bet_on_str += "(#{bet.display_spread})" if bet.spread != 0
        str += "<td>#{bet_on_str}</td>"
        str += "<td></td>"
        str += get_status_simple(bet)
      else
        str += "<td></td>"
        str += "<td></td>"
        str += "<td></td>"
        str += "<td></td>"
      end
    end
    return str
  end

  def table_body(display_table)
    str = ""
    index = 0
    display_table.game_rows.each do
    | game, bets |
      str += "<tr bgcolor=\"#{row_alt_colour(index)}\">"
      str += table_one_row(game, bets)
      str += "</tr>"
      index += 1
    end
    str += "</tbody>"
    str += "</table>"
    return str
  end

  def footer_boiler_plate
    str = ""
    str += "<hr>\n"
    str += "<i>Generated: #{Time.now} by NewWebDisplay</i>\n"
    str += "</body>\n</html>"
    return str
  end

end
