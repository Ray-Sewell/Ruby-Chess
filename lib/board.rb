require("./modules/input_conversion.rb")
require_relative("token.rb")
require_relative("king.rb")
require_relative("pawn.rb")
require_relative("knight.rb")

class Board
    include Input_Conversions
    attr_reader :tokens, :move_log
    def initialize(menu)
        @menu = menu
        @board = Array.new(8) {Array.new(8)}
        @tokens = []
        @move_log = []
    end
    def load_tokens(args)
        args.keys.each do |token|
            token_args = {
                board: self,
                type: args[token]["type"].to_sym,
                team: args[token]["team"].to_sym,
                state: args[token]["state"].to_sym,
                pos: args[token]["pos"]
            }
            case token_args[:type]
            when :pawn
                @tokens.append(Pawn.new(token_args))
            when :knight
                @tokens.append(Knight.new(token_args))
            when :king
                @tokens.append(King.new(token_args))
            else
                @tokens.append(Token.new(token_args))
            end
        end
    end
    def load_log(log)
        @move_log = log
    end
    def save_tokens
        tokens = {}
        @tokens.each do |token|
            tokens[token] = {
                team: token.team,
                type: token.type,
                state: token.state,
                pos: token.pos
            }
        end
        return tokens
    end
    def save_game
        puts `clear`
        @menu.save_game
    end
    def end_game
        @menu.set_turn(:end)
    end
    def exit_game
        @menu.exit_game
    end
    def refresh
        puts `clear`
        update
        pretty_print
    end
    def initialize_tokens
        map = [
            [:black,:rook,:knight,:bishop,:queen,:king,:bishop,:knight,:rook],
            [:black,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn],
            [],[],[],[],
            [:white,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn,:pawn],
            [:white,:rook,:knight,:bishop,:queen,:king,:bishop,:knight,:rook]
        ]
        map.each_with_index do |row, i|
            unless row.empty?
                team = row.shift
                row.each_with_index do |token, ii|
                    args = {
                        board: self,
                        team: team,
                        type: token,
                        :state => :initial,
                        pos: [i, ii]
                    }
                    case token
                    when :pawn
                        token = Pawn.new(args)
                    when :knight
                        token = Knight.new(args)
                    when :king
                        token = King.new(args)
                    when nil
                    else
                        token = Token.new(args)
                    end
                    @tokens.append(token)
                end
            end
        end
    end
    def update   
        kings = []
        @board = Array.new(8) {Array.new(8)}
        @tokens.each do |token|
            pos = token.pos
            @board[pos[0]][pos[1]] = token.token
            if token.type == :king
                kings.append(token)
            end
        end
        kings.each do |king|
            if king.checkmate?
                puts "  #{king.team.to_s} lost!"
                puts
                end_game
            end
        end
    end
    def get_token(pos)
        @tokens.each do |token|
            if token.pos == pos
                return token
            end
        end
        return nil
    end
    def remove_token(token)
        @tokens.delete(token)
    end
    def add_token(token)
        @tokens.append(token)
    end
    def set_move(token, move)
        capture = token.legal_moves?[move]
        args = {
            token: token,
            after: move,
            capture: capture
        }
        if capture.nil?
            log_move(args)
            token.set_pos(move)
            return true
        elsif capture
            log_move(args)
            remove_token(capture)
            token.set_pos(move)
            return true
        else
            log_move(args)
            token.set_pos(move)
            return true
        end
    end
    def promote(pawn, type)
        remove_token(pawn)
        args = {
            board: self,
            team: pawn.team,
            type: type,
            :state => :initial,
            pos: pawn.pos
        }
        if type == :knight
            add_token(Knight.new(args))
        else
            add_token(Token.new(args))
        end
    end
    def markers(positions)
        puts `clear`
        positions.keys.each do |pos|
            target = @board[pos[0]][pos[1]]
            if target.nil?
                @board[pos[0]][pos[1]] = "\e[31m*\e[0m"
            else
                @board[pos[0]][pos[1]] = "\e[31m#{target}\e[0m"
            end
        end
    end
    def pretty_print
        puts "   ┬───┬───┬───┬───┬───┬───┬───┬───┐"
        @board.each_with_index do |row, i|
            print " #{8 - i} │"
            row.each do |token|
                if token.nil?
                    print "   │"
                else
                    print " #{token} │"
                end
            end
            puts; puts "   ┼───┼───┼───┼───┼───┼───┼───┼───┤"
        end
        puts "     A   B   C   D   E   F   G   H"
        puts
    end
    def log_move(args)
        token = args[:token]
        if args[:capture]
            @move_log.append([token.token, token.pos, args[:capture].token, args[:capture].pos])
        else
            @move_log.append([token.token, token.pos, args[:after]])
        end
    end
    def print_log
        if @move_log.empty?
            puts "  This game has just started! Press enter to refresh"
        else
            @move_log.each do |line|
                readable_i = readable_convert(line[1])
                if line.length == 4
                    readable_ii = readable_convert(line[3])
                    puts "#{line[0]} #{readable_i} -> #{readable_ii} captured #{line[2]}"
                else
                    readable_ii = readable_convert(line[2])
                    puts "#{line[0]} #{readable_i} -> #{readable_ii}"
                end
            end
            puts
            puts "  Press enter to refresh"
        end
        gets
    end
end