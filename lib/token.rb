require("./modules/token_dictionary")

class Token
    include Token_Dictionary
    attr_reader :type, :team, :state, :pos, :token
    def initialize(args)
        @@board = args[:board]
        @type = args[:type]
        @team = args[:team]
        @state = args[:state]
        @pos = args[:pos]
        @token = TOKEN_MAP[@team][@type]
    end
    def merge_move(i, ii)
        return [i[0] + ii[0], i[1] + ii[1]]
    end
    def set_pos(pos)
        @pos = pos
        @state = :post
    end
    def set_pos_temp(pos)
        @pos = pos
    end
    def set_state(state)
        @state = state
    end
    def legal_moves?
        moves = {}
        MOVE_MAP[@type].each do |initial_move|
            move = merge_move(initial_move, @pos)
            while within_bounds?(move)
                target = @@board.get_token(move)
                if target.nil?
                    moves[move] = false
                elsif target.team != @team
                    moves[move] = target
                    break
                else
                    break
                end
                move = merge_move(initial_move, move)
            end
        end
        return moves
    end
    def within_bounds?(move)
        if move[0].between?(0,7) && move[1].between?(0,7)
            return true
        end
        return false
    end
end