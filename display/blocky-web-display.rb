
require_relative 'colours.rb'
require_relative 'common-web-display.rb'

####################
# Public Interface #
####################

def blocky_display_html(accumulators, games)
  table = DisplayTable.new(accumulators, games)
  viewer = BlockyViewer.new(table)
  viewer.dump_to_stdout
end

#############
# Internals #
#############

def for_display(token)
  # I think just using the token might be better for the blocky view.
  return token
end

class BlockyViewer

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
    str += "<td width=30 colspan='1' align='center'>\n"
    location = LOCATION_OF_SINGLE_VIEW + "?Name=" + name
    str += "<h2>#{name}</h2>\n"
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
      str += "<td></td>\n"
    end
    str += "</tr>\n"

    str += "</thead>\n"
    return str
  end

  CELL_FONT_SIZE = 5
  def get_status_simple(bet)
    bet_on_str = for_display(bet.bet_on)
    bet_on_str += "&nbsp(#{bet.display_spread})" if bet.spread != 0

    ret_str = "<td bgcolor=\"#{bet.get_colour}\">"
    ret_str += "<font SIZE=#{CELL_FONT_SIZE}>"
    ret_str += "<center>"
    ret_str += "&nbsp#{bet_on_str}&nbsp"
    ret_str += "</center>"
    ret_str += "</font>"
    ret_str += "</td>"
  end

  def table_one_row(game, bets)
    str = ""
    if (is_critical?(bets))
      str += "<td>#{CRITICAL_TEXT}</td>"
    else
      str += "<td></td>"
    end
    away_team_display = for_display(game.away_team)
    home_team_display = for_display(game.home_team)
    str += "<td align='right'>#{away_team_display}</td><td align='right'>#{game.away_score}</td><td><b>@</b></td><td>#{game.home_score}</td><td>#{home_team_display}</td>"

    bets.each do
    | bet |
      if !bet.nil? && !bet.bet_on.nil?
        str += "<td></td>"

        str += get_status_simple(bet)
      else
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
    str += "<i>Generated: #{Time.now} by BlockyWebDisplay</i>\n"
    str += "</body>\n</html>"
    return str
  end

end
