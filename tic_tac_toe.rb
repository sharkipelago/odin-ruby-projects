# frozen_string_literal: true

# Get input
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

class Gameboard
  WINNING_SPACES = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7]
  ].freeze

  attr_accessor :is_x_turn, :spaces, :turns

  def initialize
    @spaces = [
      %w[1 2 3],
      %w[4 5 6],
      %w[7 8 9]
    ]
    @is_x_turn = true
    @turns = 0
  end

  def print_board
    Gameboard.print_row(spaces[0])
    puts '---+---+---'
    Gameboard.print_row(spaces[1])
    puts '---+---+---'
    Gameboard.print_row(spaces[2])
  end

  def at_space(int)
    indecies = int_to_indecies(int)
    spaces[indecies[0]][indecies[1]]
  end

  def place_mark(int)
    indecies = int_to_indecies(int)
    puts
    spaces[indecies[0]][indecies[1]] = is_x_turn ? 'X' : 'O'
  end

  def switch_players
    self.is_x_turn = !is_x_turn
  end

  def check_winner
    WINNING_SPACES.each do |spaces|
      space0 = at_space(spaces[0])
      space1 = at_space(spaces[1])
      space2 = at_space(spaces[2])
      if space0 == space1 && space0 == space2
        return space0
      else
        next
      end
    end

    return 'tied' if turns == 9

    nil
  end

  def self.print_row(row)
    print_string = ' '
    row.each_with_index do |space, index|
      colored_space = space
      case space
      when 'X' then colored_space = space.red
      when 'O' then colored_space = space.light_blue
      end

      print_string << if index == 2
                        "#{colored_space} "
                      else
                        "#{colored_space} | "
                      end
    end
    puts print_string
  end

  private

  def int_to_indecies(int)
    index_base = int - 1
    [index_base / 3, index_base % 3]
  end
end

game_is_over = false
board = Gameboard.new

until game_is_over
  board.print_board
  puts 'Please enter the number of an available space!'
  user_input = gets.to_i
  until user_input.between?(1, 9) && board.at_space(user_input).to_i != 0
    puts 'Plese enter a valid input'
    user_input = gets.to_i
  end

  board.place_mark(user_input)
  board.is_x_turn ? (puts "X marked space #{user_input} \n\n") : (puts "O marked space #{user_input} \n\n")
  board.switch_players

  result = board.check_winner
  next unless result

  board.print_board

  if result == 'tied'
    puts 'Tied!'
  else
    puts "#{result} won!"
  end

  game_is_over = true

end
