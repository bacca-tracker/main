
require_relative 'text-add-bet.rb'

require 'rubygems'
require 'highline/import'
require 'mechanize'
require 'nokogiri'

OPEN_BET_PAGE = "https://www.skybet.com/secure/account?action=GoShowUnsettledBets"

def local_body
  f = File.open("inspect.html")
  f.read
end

def get_username
  print "Username: "
  $stdin.gets.strip
end

def get_pin
  ask("PIN: ") {|q| q.echo = false}
end

class LoginFailureException < RuntimeError

end

def construct_identifier(row_text)
  bet_type = row_text[1]
  receipt  = row_text[2]
  stake    = row_text[3]

  receipt.gsub!("\t", "")
  receipt.gsub!("\n", "")

  bet_type + " (" + receipt + ") with " + stake + " stake." # Hints for user to identify this acc.
end

class AutoGetBets

  def initialize
    parse_body_to_bets(login_and_get_open_bets)
#    parse_body_to_bets(local_body)
  end

  def login_and_get_open_bets
    puts("Enter SkyBet Credentials")
    username = get_username
    pin = get_pin

    mech_agent = Mechanize.new { | agent |
      agent.follow_meta_refresh = true
    }
    mech_agent.get("https://www.skybet.com/secure/identity/auth?consumer=skybet") do | home_page |
      # Login
      user_home = home_page.form_with(:name => nil) do | form |
        form.username = username
        form.pin = pin
      end.submit
      if (login_failed(user_home))
        puts "Login failed"
        raise LoginFailureException
      end

      raw_bodies = ""
      # Try to get the bet page
      mech_agent.get(OPEN_BET_PAGE) do | bet_page |
        raw_bodies += bet_page.body

        while true do
          older_transactions_link = bet_page.link_with(:text => /Older transactions/)
          break if older_transactions_link.nil?
          bet_page = mech_agent.click(older_transactions_link)
          raw_bodies += bet_page.body
        end

        return raw_bodies

      end
    end
  end

  def login_failed(user_home)
    user_home.body.include?("We couldn't recognise the details you entered. Please try again")
  end

  def parse_body_to_bets(raw_body)
    # Sometimes Sky wil display part of a bet on one page, and then the whole thing on the new one.
    # Over-writing any partial bets with their full equivalents solves this.
    accs_hash = {}
    body = Nokogiri::HTML::DocumentFragment.parse(raw_body)
    body.css('tr').map do | row |

      row_text = row.xpath('./td').map(&:text)
      bet_data = row_text[4]
      next unless (bet_data)

      bet_data.gsub!("\t", "")
      str = ""
      bet_data.each_line { | line |
        next if line == "\n"
        str += line.strip
        str += "\n"
      }

      accs_hash[construct_identifier(row_text)] = str
    end

    accs_hash.each do
    | identifier, string |
      puts ""
      puts "Found #{identifier}"
      begin
        TextAddBet.new.parse_from_str(get_name, string)
      rescue FailedToParseException => e
        puts e.message
        puts "Moving to next bet, if one exists..."
      end
    end

  end

end
