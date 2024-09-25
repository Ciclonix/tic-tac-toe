# frozen_string_literal: true

class Grid
  attr_accessor :symbols

  def initialize
    @symbols = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
  end

  def add_symbol(row, col, symbol, is_human)
    if (row.between? 0, 2) && (col.between? 0, 2)
      if symbols[row][col] == " "
        symbols[row][col] = symbol
        return true
      end
      puts "Error: Coordinates already used" if is_human
    elsif is_human
      puts "Error: Invalid coordinates"
    end
    return false
  end

  def print_grid
    i = 0
    3.times do
      puts "---|---|---" unless i.zero?
      puts " #{symbols[i][0]} | #{symbols[i][1]} | #{symbols[i][2]} "
      i += 1
    end
  end

  def line_tris?
    symbols.each_index do |i|
      return true if (symbols[i].uniq.size == 1 && symbols[i][0] != " ") ||
                     (symbols[0][i] != " " &&
                     [symbols[0][i], symbols[1][i], symbols[2][i]].uniq.size == 1)
    end
    return false
  end

  def diagonal_tris?
    return symbols[1][1] != " " &&
           ([symbols[0][0], symbols[1][1], symbols[2][2]].uniq.size == 1 ||
           [symbols[0][2], symbols[1][1], symbols[2][0]].uniq.size == 1)
  end

  def win?
    return line_tris? || diagonal_tris?
  end

  def full?
    symbols.each { |row| return false if row.include? " " }
    return true
  end
end


class Player
  attr_accessor :symbol, :grid, :is_human

  def initialize(symbol, grid, is_human)
    @symbol = symbol
    @grid = grid
    @is_human = is_human
  end

  def turn
    is_human ? human_turn : computer_turn
  end

  def human_turn
    print "Choose the next coordinates (row,col): "
    row, col = gets.chomp.split(",").map(&:to_i)
    raise ArgumentError unless grid.add_symbol(row, col, symbol, is_human)
  rescue ArgumentError
    puts "Error: Invalid coordinates"
    retry
  end

  def computer_turn
    loop do
      break if grid.add_symbol(rand(3), rand(3), symbol, is_human)
    end
  end
end


class Game
  attr_accessor :grid

  def start_game
    @grid = Grid.new
    winner = play
    if winner.nil?
      puts "\nDraw!"
    else
      puts "\nPlayer #{winner.symbol} won!"
    end
  end

  def input_players
    print "How many is_human players? (0, 1, 2): "
    players_num = gets.chomp
    case players_num
    when "0"
      p1_is_human = false
      p2_is_human = false
    when "1"
      p1_is_human = true
      p2_is_human = false
    when "2"
      p1_is_human = true
      p2_is_human = true
    else
      raise ArgumentError
    end
    return [Player.new("x", grid, p1_is_human), Player.new("o", grid, p2_is_human)]
  rescue ArgumentError
    puts "Error: Invalid number"
    retry
  end

  def play
    players = input_players
    grid.print_grid
    loop do
      players.each do |p|
        puts "\nPlayer #{p.symbol} turn:"
        p.turn
        grid.print_grid
        return p if grid.win?
        return nil if grid.full?
      end
    end
  end
end


# Game.new.start_game
