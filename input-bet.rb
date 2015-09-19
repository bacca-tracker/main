
require_relative 'accumulator.rb'

NO_BET = '0'
HOME = '1'
AWAY = '2'

INSTRUCTION = "Enter #{HOME} or #{AWAY} (or #{NO_BET} for no bet)"
SPREAD_INSTRUCTION = "Enter spread (eg +7, -2.5, or 0 for no spread)"

class BetInput

  def initialize
    name = get_name
    accumulator = Accumulator.new(name)
    load_games_from_yaml.each {
    | game |
      bet = ask_bet_for_game(game)
      accumulator.add_bet(bet) unless bet.nil?
    }
    Dir.mkdir(ACC_DIR) unless File.exists?(ACC_DIR)
    File.open("#{ACC_DIR}/#{name}.yml", "w") {
    | file |
      YAML.dump(accumulator, file)
    }
  end

  def ask_bet_for_game(game)
    puts INSTRUCTION
    puts "1. #{token_to_display_name(game.home_team)} vs 2. #{token_to_display_name(game.away_team)}"
    result = $stdin.gets.strip
    if (result == NO_BET)
      return ask_spread_for_game(game, nil)
    elsif (result == HOME)
      return ask_spread_for_game(game, game.home_team)
    elsif (result == AWAY)
      return ask_spread_for_game(game, game.away_team)
    else
      puts INSTRUCTION
      return ask_bet_for_game(game)
    end
  end

  def ask_spread_for_game(game, team)
    puts SPREAD_INSTRUCTION
    spread_str = $stdin.gets.strip
    spread_f = spread_str.to_f
    if (spread_f == 0 && spread_str != "0")
      puts "Please enter a numeric value"
      return ask_spread_for_game(game, team)
    end
    return Bet.new(game, team, spread_f)
  end

end
