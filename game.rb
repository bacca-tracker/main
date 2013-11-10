NOT_STARTED_SCORE = "NS"

class Game

  attr_reader :home_team, :away_team, :home_score, :away_score, :final

  def initialize(home_team, away_team, home_score, away_score, final=false)
    @home_team = home_team.to_s
    @away_team = away_team.to_s
    @home_score = home_score.to_i
    @away_score = away_score.to_i
    @active = home_score && away_score
    @final = final
  end

  def active?
    return @active
  end

  def winner
    if (@away_score > @home_score)
      return @away_team
    else
      return @home_team
    end
  end

  def inspect
    str = ""
    str += @home_team
    str += " "
    str += active? ? @home_score.to_s : NOT_STARTED_SCORE
    str += " - "
    str += active? ? @away_score.to_s : NOT_STARTED_SCORE
    str += " "
    str += @away_team
    str += " ("
    str += @final ? "F)" : "L)"
    return str
  end

  def headline
    return "#{@away_team} @ #{@home_team}"
  end

  def teams_match?(away_team, home_team)
    (away_team == @away_team) && (home_team == @home_team)
  end

end
