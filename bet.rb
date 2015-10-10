
require_relative 'colours.rb'
require_relative 'game.rb'

class Bet

  attr_reader :bet_on, :spread
  attr_accessor :game

  def initialize(game,bet_on, spread)
   @game = game
   @bet_on = bet_on
   @spread = spread
  end

  def active?
    return game.active?
  end

  def get_home_and_away_spread
    if (spread < 0)
      aspread = spread.abs
      if bet_on_home_team?
        return 0, aspread
      else
        return aspread, 0
      end
    else
      if bet_on_home_team?
        return spread, 0
      else
        return 0, spread
      end
    end
  end

  def bet_on_home_team?
    bet_on == game.home_team
  end

  def winning?
    if (bet_on_home_team?)
      return ((game.home_score + spread) > game.away_score)
    else
      return ((game.away_score + spread) > game.home_score)
    end
  end

  def display_spread
    spread < 0 ? spread.to_s : "+#{spread}"
  end

  def display_status
    if bet_on.nil?
      return "No Bet"
    elsif !game.active?
      return "NS"
    elsif winning?
      return game.final ? "Won" : "Winning"
    else
      return game.final ? "Lost" : "Losing"
    end
  end

  def get_colour
    if bet_on.nil?
      return ""
    elsif !game.active?
      return ""
    elsif winning?
      return GREEN
    else
      return RED
    end
  end

end
