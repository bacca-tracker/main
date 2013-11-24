
require_relative 'bet.rb'

class Accumulator

  attr_accessor :name

  def initialize(name)
    @name = name
    @bets = []
  end

  def same_game(bet, game)
    return ((game.home_team == bet.game.home_team) && (game.away_team == bet.game.away_team))
  end

  def update_with_new_scores(games)
    @bets.each do | bet |
      games.each do | game |
        bet.game = game if same_game(bet, game)
      end
    end
  end

  def add_bet(bet)
    @bets.push(bet) # TODO unless bet is nil or something, maybe
  end

  def get_bet(game)
    @bets.select { | bet | same_game(bet, game) }.first
  end

  def display
    puts "########################################"
    puts @name
    @bets.each { | bet |
      game = bet.game
      puts ""
      puts "Game:   #{game.inspect}"
      puts "Won by: #{game.winner}"
      puts "Bet on: #{bet.bet_on}"
      puts "Status: #{bet.display_status}"
    }
  end

end
