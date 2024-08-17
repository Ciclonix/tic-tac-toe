class Grid
    attr_accessor :symbols

    def initialize
        @symbols = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
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
end