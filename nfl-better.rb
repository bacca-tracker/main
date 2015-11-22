#!/usr/bin/ruby1.9.1

require_relative 'accumulator.rb'
require_relative 'display/console-display.rb'
require_relative 'include-parsers.rb'
require_relative 'input-bet.rb'
require_relative 'mechanize-get-bets.rb'
require_relative 'text-add-bet.rb'
require_relative 'display/new-web-display.rb'
require_relative 'display/blocky-web-display.rb'

require 'getoptlong'
require 'yaml'

INTERNAL_DIR = "internals"
ACC_DIR = "#{INTERNAL_DIR}/accs"

module Common

  def get_parser
    LeagueParser.new
  end

  def parse_games_to_yaml
    games = get_parser.parse
    Dir.mkdir(INTERNAL_DIR) unless File.exists?(INTERNAL_DIR)
    File.open("#{INTERNAL_DIR}/games.yml", "w") {
    | file |
      YAML.dump(games, file)
    }
    `chmod -R 777 #{INTERNAL_DIR}`
    return games
  end

  def load_games_from_yaml
    YAML.load_file("#{INTERNAL_DIR}/games.yml")
  end

end

module Setup
  include Common

  def get_name
    puts "Display Name:"
    $stdin.gets.strip
  end

  def input_bets_to_yaml(mode)
    case mode
    when 0
      BetInput.new
    when 1
      TextAddBet.new.parse_from_cli
    when 2
      AutoGetBets.new
    end
  end

end

module RunOptions
  include Setup

  def setup
    parse_games_to_yaml
  end

  def add_bets(mode)
    input_bets_to_yaml(mode)
  end

  def help
    puts "Usage: ./nfl-better.rb [OPTION]"
    puts "  where OPTION is one of:" # TODO enforce this!
    puts "    --help, -h             Display this help."
    puts "    --display, -d          Output a display, for DEBUG purposes."
    puts "    --setup, -s            Run the setup for the week."
    puts ""
    puts "  there are mutiple ways to add bets, once a week has been setup:"
    puts "    --manual-add, -m       Add a bet using responses to the CLI."
    puts "    --text-add, -t         Uses the text from your open bets."
    puts "    --auto-add, -a         Script automatically logs into your betting account, and gets your bets."
    puts ""
    puts "  web only options, I don't even know why I'm documenting these:"
    puts "    --web-display <mode>   Output HTML for a given mode:"
    puts "                           - 1 is the classic view."
    puts "                           - 2 is the blockier view."
  end

  def canonical_numeric_value(acc)
    acc.name =~ /\d/ ? 1 : -1
  end

  def common_load_accumulators(games)
    accumulators = []
    Dir.mkdir(ACC_DIR) unless File.exists?(ACC_DIR)
    Dir.chdir(ACC_DIR) do
      Dir.foreach(".") { | file |
        next if file == "."
        next if file == ".."
        acc = YAML.load_file(file)
        acc.update_with_new_scores(games)
        accumulators.push(acc)
      }
    end
    # Bets whose name contains a number are considered secondary in importance,
    # and will therefore be pushed off towards the right of the screen.
    accumulators.sort! { | lhs, rhs |
      canonical_numeric_value(lhs) <=> canonical_numeric_value(rhs)
    }
    return accumulators, games
  end

  def refreshing_load_accumulators
    common_load_accumulators(parse_games_to_yaml)
  end

  def non_refreshing_load_one_from_CGI
    name = CGI.new.params['Name'][0]
    all_accs, games = common_load_accumulators(load_games_from_yaml)
    interesting_acc = all_accs.find { | a | a.name == name }
    ret = interesting_acc.nil? ? [] : [interesting_acc]
    return ret, games
  end

  def display
    # Refresh game scores, then display versus stored accumulators
    parse_games_to_yaml
    include ConsoleDisplay
    display
  end

  def web_display(mode)
    # Refresh game scores, compare with stored accumulators, output HTML
    accumulators, games = refreshing_load_accumulators
    if (mode = 1.to_s)
      new_display_html(accumulators, games)
    elsif (mode = 2.to_s)
      blocky_display_html(accumulators, games)
    else
      raise "Unknown web display mode = '#{mode}'"
    end
  end

end

include RunOptions

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--display', '-d', GetoptLong::NO_ARGUMENT ],
  [ '--setup', '-s', GetoptLong::NO_ARGUMENT],
  [ '--manual-add', '-m', GetoptLong::NO_ARGUMENT ],
  [ '--text-add', '-t', GetoptLong::NO_ARGUMENT ],
  [ '--auto-add', '-a', GetoptLong::NO_ARGUMENT ],
  [ '--web-display', '-w', GetoptLong::REQUIRED_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
    when '--help'
      help
    when '--display'
      display
    when '--setup'
      setup
    when '--manual-add'
      add_bets(0)
    when '--text-add'
      add_bets(1)
    when '--auto-add'
      add_bets(2)
    when '--web-display'
      web_display(arg)
  end
end
