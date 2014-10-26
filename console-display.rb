
module ConsoleDisplay

  def display
    refreshing_load_accumulators.first.each { | accumulator |
      accumulator.display
    }
  end

end
