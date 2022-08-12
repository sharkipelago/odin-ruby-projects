# frozen_string_literal: true

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

module Player
  def create_code(code); end

  def take_turn_breaker

  end
end

class Game

  attr_accessor :game_over

  def initialize
    @game_over = false
  end

  def start
    puts "\n\n\n"
    puts 'Welcome to Mastermind!'
    puts 'Do you want to be the code maker(M) or code breaker(B)?'
    input = Game.get_input("Please put a valid input \n 
                            Code Maker - (M) \n 
                            Code Breaker - (B) \n",
                            /\A[MmBb]{1}\Z/)

    input =~ /\A[Mm]{1}\Z/ ? play_maker : play_breaker
  end

  # Defaults to getting code as an input
  def self.get_input(invalid_input_message = "Please chose a valid code", valid_input = /\A[rgybplRGYBPL]{4}\Z/)
    input = gets.chomp
    until input =~ valid_input
      puts "#{invalid_input_message} \n"
      input = gets.chomp
    end
    return input
  end

  def self.print_instructions(input_reason)
    puts "\n\n"
    puts "Please enter a sequence of 4 color codes to #{input_reason}"
    puts "The colors are #{'Red(r)'.red}, #{'Yellow(y)'.yellow}, #{'Green(g)'.green},
          #{'Blue(b)'.blue}, #{'Pink(p)'.pink}, and #{'Light blue(l)'.light_blue}"
    puts 'e.g. rrbb'
  end

  def self.computer_code
    return Array.new(4) { 'rgybpl'.split('').sample }.join
  end

  private

  def play_breaker
    code = Game.computer_code
    board = Board.new(code)
    
    Game.print_instructions("guess the code")

    until board.is_full || game_over
      input = Game.get_input
      is_correct = board.make_guess(input)
      board.print_board
      end_game("Won") if is_correct
    end
    end_game("Lost Miserably") unless game_over
  end

  def play_maker
    puts 'Playing maker!'
    Game.print_instructions("make the code")

    code = Game.get_input
    board = Board.new(code)

    
    until board.is_full || game_over
      puts "Press any button to see computer guess"
      Game.get_input(Game.get_input("", /./))
      computer_guess = Game.computer_code
      is_correct = board.make_guess(computer_guess)
      board.print_board
      end_game("Lost to a bot") if is_correct
    end
    end_game("Beat a hunk of metal") unless game_over
  end

  # Will keep the congrats message even if you lose because it's less coding
  def end_game(message)
    puts "Congratulations you #{message}!!!"
    self.game_over = true
  end


end

class Board
  BORDER = '      +---+---+---+---+'

  attr_accessor :guesses
  attr_reader :answer, :is_full

  # Answer is an array of valid characters
  def initialize(answer)
    @guesses = []
    @answer = answer.split('')
    @is_full = false
  end

  def print_board
    rows = 0
    until rows == 12
      print_row(rows)
      rows += 1
    end
    puts BORDER
  end

  # Takes a 4-char string made of valid color codes
  def make_guess(color_string)
    return nil if is_full

    guess = Guess.new(color_string, answer)
    guesses.push(guess)
    @is_full = guess.pattern.length == 12
    return guess.exact_matches == 4
  end

  private

  def print_row(index)
    puts BORDER
    puts guesses[index] || '      |   |   |   |   | '
  end
end

class Guess
  CODE_TO_COLOR = {
    r: :red,
    g: :green,
    y: :yellow,
    b: :blue,
    p: :pink,
    l: :light_blue
  }.freeze

  attr_reader :pattern, :exact_matches, :near_matches, :non_matches

  # Takes a 4-char string made of valid color codes
  def initialize(code_string, answer)
    @pattern = code_string.split('')
    @exact_matches = get_exact_matches(answer)
    @near_matches = get_near_matches(answer)
    @non_matches = 4 - @exact_matches - @near_matches
  end

  def to_s
    guess_string = "[#{'X' * exact_matches + 'N' * near_matches + ' ' * non_matches}]|"
    pattern.each { |peg| guess_string += " #{color_peg(peg)} |" }
    return guess_string
  end

  private

  def color_peg(peg)
    return 'O'.method(CODE_TO_COLOR[peg.to_sym]).call
  end

  def get_exact_matches(answer)
    return exact_matches || pattern.each_with_index.reduce(0) do |sum, (peg, index)|
      peg == answer[index] ? sum + 1 : sum
    end
  end

  # Pegs that match color but not location (this excludes exact matches)
  # takes exact matches guess as input
  def get_near_matches(answer)
    return near_matches unless near_matches.nil?

    answer_copy = answer.map { |peg| peg }
    all_matches = pattern.reduce(0) do |sum, peg|
      if answer_copy.include?(peg)
        answer_copy.delete_at(answer_copy.index(peg))
        next sum + 1
      end
      sum
    end

    return all_matches - get_exact_matches(answer)
  end

  def get_non_matches(answer)
    4 - get_exact_matches(answer) - get_non_matches(answer)
  end
end

game = Game.new
game.start
