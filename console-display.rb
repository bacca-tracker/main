
require_relative 'common-display.rb'

module ConsoleDisplay
  include CommonDisplay

  def display
    load_accumulators.first.each { | accumulator |
      accumulator.display
    }
  end

end
