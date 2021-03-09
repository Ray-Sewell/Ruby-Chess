require_relative("token.rb")

class Pawn < Token
    def legal_moves?
        moves = {}
        MOVE_MAP[@type][@team][@state].each do |move|
            move = merge_move(move, @pos)
            next if !within_bounds?(move)
            target = @@board.get_token(move)
            break if target
            moves[move] = false
        end
        MOVE_MAP[@type][@team][:capture].each do |move|
            move = merge_move(move, @pos)
            next if !within_bounds?(move)
            target = @@board.get_token(move)
            next if target.nil? || target.team == @team
            moves[move] = target
        end
        return moves
    end
    def potential_capture_moves?
        moves = {}
        MOVE_MAP[@type][@team][:capture].each do |move|
            move = merge_move(move, @pos)
            next if !within_bounds?(move)
            target = @@board.get_token(move)
            if target.nil?
                moves[move] = false
            else
                next if target.team == @team
                moves[move] = target
            end
        end
        return moves
    end
    def set_pos(pos)
        @pos = pos
        @state = :post
        if @team == :white
            if pos[0] == 0
                promote
            end
        else
            if pos[0] == 7
                promote
            end
        end
    end
    def promote
        puts "  You can promote a pawn!"
        puts "  Enter a number for the token you'd like to choose"
        puts
        puts "  0 - Queen"
        puts "  1 - Bishop"
        puts "  2 - Rook"
        puts "  3 - Knight"
        while true
            puts
            input = gets.chomp
            case input
            when "0"
                replace_self(:queen)
                break
            when "1"
                replace_self(:bishop)
                break
            when "2"
                replace_self(:rook)
                break
            when "3"
                replace_self(:knight)
                break
            else
                puts "  Please enter a number!"
            end
        end
    end
    def replace_self(type)
        @@board.promote(self, type)
    end
end