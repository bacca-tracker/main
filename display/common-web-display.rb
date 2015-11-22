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
  return false if bet_arr[0].nil?
  team = bet_arr[0].bet_on
  return false if team.nil? # Not everyone has bet on this game.
  bet_arr.each {
  | bet |
    return false if bet.nil?
    if (bet.bet_on != team)
      return false
    end
  }
  return true
end

CRITICAL_TEXT = "<img src=\"http://upload.wikimedia.org/wikipedia/commons/a/af/Radioactivity_symbol.png\" height=\"20\">"

ROW_ALT_1 = WHITE
ROW_ALT_2 = LIGHT_GRAY
LOCATION_OF_SINGLE_VIEW = "acca-tracker3"
