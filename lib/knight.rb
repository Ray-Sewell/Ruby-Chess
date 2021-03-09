require_relative("token.rb")

class Knight < Token
    def legal_moves?
        moves = {}
        MOVE_MAP[@type].each do |move|
            move = merge_move(move, @pos)
            next if !within_bounds?(move)
            target = @@board.get_token(move)
            if target.nil?
                moves[move] = false
            elsif target.team != @team
                moves[move] = target
            end
        end
        return moves
    end
end