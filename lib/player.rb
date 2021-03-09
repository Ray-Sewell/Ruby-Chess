require("./modules/input_conversion.rb")

class Player
    include Input_Conversions
    def initialize(board, team)
        @@board = board
        @team = team
        @king = find_king
    end
    def find_king
        @@board.tokens.each do |token|
            next if token.type != :king
            if token.team == @team
                return token
            end
        end
    end
    def validate_input(input)
        if input[0].nil? || input[1].nil?
            puts "  Type a coordinate and press enter!"
            return false
        end
        if CHARACTER_CONVERSIONS.keys.include?(input[0].to_sym) && input[1].to_i.between?(1,8)
            return true
        else
            puts "  Please enter a valid coordinate in the format a1!"
            return false
        end
    end
    def turn
        @@board.refresh
        puts "  #{@team.to_s}'s turn!"
        if @king.check?
            puts "  Your king #{@king.token}  is in check! You must help it this turn"
        end
        puts "  Please enter the coords for the token you wish to move or HELP | LOG | SAVE | EXIT"
        puts
        input = gets.chomp.downcase
        puts
        case input
        when "help"
            puts "  To move a token enter the coordinates to select it as XY, where X is A-H and Y is 1-8"
            puts "  then enter another set of XY coordinates where you wish to move. Valid moves will be"
            puts "  displayed on the board as red."
            puts
            puts "  LOG shows a log of all moves played on this board"
            puts "  SAVE will open the save game menu"
            puts
            puts "  To continue press enter.."
            gets
            return false
        when "log"
            puts "Printing log"
            @@board.print_log
            return false
        when "save"
            @@board.save_game
            return false
        when "exit"
            @@board.exit_game
            return true
        else
            unless validate_input(input)
                return false
            end
            token = @@board.get_token(convert_input(input))
            if token
                if token.team == @team
                    if token.legal_moves?.empty?
                        puts "  #{token.token}  has no legal moves! Press enter to refresh"
                        gets
                        return false
                    end
                    @@board.markers(token.legal_moves?)
                    puts `clear`
                    @@board.pretty_print
                    puts "  Where would you like to move #{token.token} ? Press enter to cancel"
                    puts
                    input = gets.chomp.downcase
                    puts
                    unless validate_input(input)
                        return false
                    end
                    move = convert_input(input)
                    if token.legal_moves?.keys.include?(move)
                        if @king.simulate_check?(token, move)
                            puts "  That would leave your king #{@king.token}  in check! Press enter to refresh"
                            gets
                            return false
                        else
                            @@board.set_move(token, move)
                            return true
                        end
                    else
                        puts "  That move is illegal! Press enter to refresh"
                        gets
                        return false
                    end
                else
                    puts "  You cannot move an enemy token! Press enter to refresh"
                    gets
                    return false
                end
            else
                puts "  There is no token there! Press enter to refresh"
                gets
                return false
            end
        end
    end
end