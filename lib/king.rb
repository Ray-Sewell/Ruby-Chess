require_relative("token.rb")

class King < Token
    def legal_moves?
        moves = {}
        MOVE_MAP[@type].each do |move|
            move = merge_move(move, @pos)
            next if !within_bounds?(move)
            next if check?(move)
            target = @@board.get_token(move)
            if target.nil?
                moves[move] = false
            elsif target.team != @team
                moves[move] = target
            end
        end
        return moves
    end
    def check?(move=@pos)
        in_check = false
        replace_self = false
        target = @@board.get_token(move)
        if target == self
            replace_self = true
            remove_target(self)
        else
            remove_target(self)
            remove_target(target)
        end
        tokens = @@board.tokens
        tokens.each do |token|
            next if token == self
            next if token.team == @team
            if token.type == :pawn
                if token.potential_capture_moves?.keys.include?(move)
                    in_check = true
                end
            else
                if token.legal_moves?.keys.include?(move)
                    in_check = true
                end
            end
        end
        if replace_self
            replace_target(self)
        else
            replace_target(self)
            replace_target(target)
        end
        return in_check
    end
    def simulate_check?(token, move)
        in_check = false
        original_pos = token.pos
        target = @@board.get_token(move)
        remove_target(target)
        token.set_pos_temp(move)
        if check?
            in_check = true
        end
        token.set_pos_temp(original_pos)
        replace_target(target)
        return in_check
    end
    def checkmate?
        tokens = @@board.tokens
        queue = []
        tokens.each do |token|
            next if token == self
            next if token.team != @team
            queue.append(token)
        end
        if legal_moves?.empty?
            return !save_king?(queue)
        else
            return false
        end
    end
    def save_king?(tokens)
        if tokens.empty?
            return false
        end
        token = tokens.shift
        original_pos = token.pos
        token.legal_moves?.keys.each do |move|
            target = @@board.get_token(move)
            remove_target(target)
            token.set_pos_temp(move)
            unless check?
                token.set_pos_temp(original_pos)
                replace_target(target)
                return true
            end
            token.set_pos_temp(original_pos)
            replace_target(target)
        end
        save_king?(tokens)
    end
    def remove_target(token)
        unless token.nil?
            @@board.remove_token(token)
        end
    end
    def replace_target(token)
        unless token.nil?
            @@board.add_token(token)
        end
    end
end