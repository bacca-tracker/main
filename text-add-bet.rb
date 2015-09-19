
require_relative 'team-names.rb'

class FailedToParseException < RuntimeError

end

def parse_bet(line)
  odds = /(\d+\/\d+|evens)/
  raise(FailedToParseException.new, "Not a valid bet - #{line}") unless line =~ /^\|([A-Za-z \.]+)\|\s\@\s#{odds}(\s(\+|\-)\S+)?/
  spread = $3 ? $3.strip : 0
  return string_to_token($1), spread
end

def get_bet_text
  puts "Copy the text from your betting account (end with Ctrl-D)"
  $stdin.read
end

class TextAddBet

  def initialize
    @games = load_games_from_yaml
  end

  def parse_from_cli
    parse(get_name, get_bet_text)
  end

  def parse_from_str(name, bet_text)
    parse(name, bet_text)
  end

private
  def parse(name, bet_text)
    accumulator = Accumulator.new(name)
    game_descriptor = true
    this_game = ""
    bet_text.each_line { | line |
      if game_descriptor
        if !(line =~ /^(.*)\sv\s(.*)$/)
          raise(FailedToParseException.new, "Not a valid descriptor - #{line}")
        end
        team1 = string_to_token($1)
        team2 = string_to_token($2)
        raise(FailedToParseException.new, "Not a team1 - #{team1}") unless !team1.nil?
        raise(FailedToParseException.new, "Not a team2 - #{team2}") unless !team2.nil?
        this_game = get_game(team1, team2)
        raise(FailedToParseException.new, "No game for for - #{line}") unless this_game
      else
        bet_on, spread = parse_bet(line)
        bet = Bet.new(this_game, bet_on, spread.to_f)
        accumulator.add_bet(bet)
      end
      game_descriptor = !game_descriptor
    }

    Dir.mkdir(ACC_DIR) unless File.exists?(ACC_DIR)
    `chmod -R 777 #{ACC_DIR}`
    File.open("#{ACC_DIR}/#{name}.yml", "w") {
    | file |
      YAML.dump(accumulator, file)
    }
    puts "\nAdded successfuly"
  end

  def get_game(team1, team2)
    directional_get_game(team1, team2) || directional_get_game(team2, team1)
  end

  def directional_get_game(home_team, away_team)
    @games.select { | game | game.teams_match?(away_team, home_team) }.first
  end

end
