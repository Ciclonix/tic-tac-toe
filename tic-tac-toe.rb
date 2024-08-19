class Grid
    attr_accessor :symbols

    def initialize
        @symbols = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    end

    def add_symbol(row, col, symbol, human)
        if (row.between? 0,2) && (col.between? 0,2)
            if symbols[col][row] == " "
                symbols[col][row] = symbol
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

    def check_win
        symbols.each do |row|
            return true if row.uniq.size == 1 && row[0] != " "
        end
        col = 0
        3.times do
            return true if [symbols[0][col], symbols[1][col], symbols[2][col]].uniq.size == 1 && symbols[0][col] != " "
            col += 1
        end
        return true if symbols[1][1] != " " && \
                       ([symbols[0][0], symbols[1][1], symbols[2][2]].uniq.size == 1 || \
                       [symbols[0][2], symbols[1][1], symbols[2][0]].uniq.size == 1)
        return false
    end

    def full?
        symbols.each do |row|
            return false if row.include? " "
        end
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
        return if grid.full?
        human ? human_turn : computer_turn
    end

    def human_turn
        loop do
            print "Choose the next coordinates (row,col): "
            row, col = gets.chomp.split(",")
            begin
                row = Integer(row)
                col = Integer(col)
            rescue ArgumentError
                puts "Error: Invalid coordinates"
            else
                break if grid.add_symbol(row, col, symbol, human)
            end
        end
    end

    def computer_turn
        loop do
            break if grid.add_symbol(rand(3), rand(3), symbol, human)
        end
    end
end


def start_game
    grid = Grid.new
    winner = p1 = p2 = nil
    loop do
        print "How many human players? (0, 1, 2): "
        num_of_players = gets.chomp
        case num_of_players
        when "0"
            p1 = Player.new("x", grid, false)
            p2 = Player.new("o", grid, false)
            break
        when "1"
            p1 = Player.new("x", grid, true)
            p2 = Player.new("o", grid, false)
            break
        when "2"
            p1 = Player.new("x", grid, true)
            p2 = Player.new("o", grid, true)
            break
        else
            puts "Error: Invalid number"
        end
    end
    players = [p1, p2]
    grid.print_grid
    loop do
        players.each do |p|
            puts "\nPlayer #{p.symbol} turn:"
            p.turn
            grid.print_grid
            if grid.check_win
                winner = p
                break
            end
            break if grid.full?
        end
        break if grid.full? || grid.check_win
    end
    if winner.nil?
        puts "\nDraw!"
    else
        puts "\nPlayer using #{winner.symbol} won!"
    end
end


start_game()
