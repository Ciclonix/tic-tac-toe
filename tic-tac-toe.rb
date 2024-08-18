class Grid
    attr_accessor :symbols

    def initialize
        @symbols = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    end

    def add_symbol(x, y, symbol, human)
        if (x.between? 0,2 and y.between? 0,2)
            if symbols[y][x] == " "
                symbols[y][x] = symbol
                return true
            end
            puts "Error: Coordinates already used" if human
        else
            puts "Error: Invalid coordinates" if human
        end
        return false
    end

    def print_grid
        i = 0
        3.times do
            unless i == 0 
                puts "---|---|---"
            end
            puts " #{symbols[i][0]} | #{symbols[i][1]} | #{symbols[i][2]} "
            i += 1
        end
    end

    def check_win
        for row in symbols
            return true if row.uniq.size == 1 and row[0] != " "
        end
        col = 0
        3.times do
            return true if [symbols[0][col], symbols[1][col], symbols[2][col]].uniq.size == 1 and symbols[0][col] != " "
            col += 1
        end
        return true if symbols[1][1] != " " and \
                       ([symbols[0][0], symbols[1][1], symbols[2][2]].uniq.size == 1 or \
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
        unless grid.full?
            human ? human_turn : computer_turn
        end
    end

    def human_turn
        loop do
            print "Choose the next coordinates (x,y): "
            x, y = gets.chomp.split(",")
            begin
                x = Integer(x)
                y = Integer(y)
            rescue ArgumentError
                puts "Error: Invalid coordinates"
            else
                break if grid.add_symbol(x, y, symbol, human)
            end
        end
    end

    def computer_turn
        loop do
            x = rand(3)
            y = rand(3)
            break if grid.add_symbol(x, y, symbol, human)
        end
    end
end


def start_game(players, grid)
    winner = ""
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
        break if grid.full? or grid.check_win
    end
    if winner == ""
        puts "\nDraw!"
    else
        puts "\nPlayer using #{winner.symbol} won!"
    end
end