
module ConsoleDisplay

  def display
    load_accumulators.first.each { | accumulator |
      accumulator.display
    }
  end

end
