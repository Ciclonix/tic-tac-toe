# frozen_string_literal: true

class Grid
    attr_accessor :symbols

    def initialize
        @symbols = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    end

    def add_symbol(row, col, symbol, human)
        if (row.between? 0,2) && (col.between? 0,2)
            if symbols[row][col] == " "
                symbols[row][col] = symbol
                return true
            end
            puts "Error: Coordinates already used" if human
        elsif human
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

    def line_tris?(symbols, idx)
        return (symbols[idx].uniq.size == 1 && symbols[idx][0] != " ") || \
               (symbols[0][idx] != " " && \
               [symbols[0][idx], symbols[1][idx], symbols[2][idx]].uniq.size == 1)
    end

    def diagonal_tris?(symbols)
        return symbols[1][1] != " " && \
               ([symbols[0][0], symbols[1][1], symbols[2][2]].uniq.size == 1 || \
               [symbols[0][2], symbols[1][1], symbols[2][0]].uniq.size == 1)
    end

    def win?
        symbols.each_index { |i| return true if line_tris?(symbols, i) }
        return diagonal_tris?(symbols)
    end

    def full?
        symbols.each { |row| return false if row.include? " " }
        return true
    end
end


class Player
    attr_accessor :symbol, :grid, :human

    def initialize(symbol, grid, human)
        @symbol = symbol
        @grid = grid
        @human = human
    end

    def turn
        human ? human_turn : computer_turn
    end

    def human_turn
        begin
            print "Choose the next coordinates (row,col): "
            row, col = gets.chomp.split(",")
            row = Integer(row)
            col = Integer(col)
            raise ArgumentError unless grid.add_symbol(row, col, symbol, human)
        rescue ArgumentError
            puts "Error: Invalid coordinates"
            retry
        end
    end

    def computer_turn
        loop do
            break if grid.add_symbol(rand(3), rand(3), symbol, human)
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
        p1 = p2 = nil
        begin
            print "How many human players? (0, 1, 2): "
            players_num = gets.chomp
            case players_num
            when "0"
                p1 = Player.new("x", grid, false)
                p2 = Player.new("o", grid, false)
            when "1"
                p1 = Player.new("x", grid, true)
                p2 = Player.new("o", grid, false)
            when "2"
                p1 = Player.new("x", grid, true)
                p2 = Player.new("o", grid, true)
            else
                raise ArgumentError
            end
        rescue ArgumentError
            puts "Error: Invalid number"
            retry
        end
        return [p1, p2]
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


Game.new.start_game
