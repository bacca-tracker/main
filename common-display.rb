
module CommonDisplay
=begin
  def load_accumulators
    accumulators = []
    Dir.chdir(ACC_DIR) do
      Dir.foreach(".") { | file |
        next if file == "."
        next if file == ".."
        accumulators.push(YAML.load_file(file))
      }
    end
    return accumulators
  end
=end
end
