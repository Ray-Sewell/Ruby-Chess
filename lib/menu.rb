require_relative("board.rb")
require_relative("player.rb")
require("./modules/save_game.rb")

class Menu
    include Save_Game
    def initialize
        @board = nil
        @p1 = nil
        @p2 = nil
        @turn = nil
        menu
    end
    def menu
        while true
            puts `clear`
            puts "     ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
    ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
    ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
    ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌          
    ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ 
    ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
    ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌
    ▐░▌          ▐░▌       ▐░▌▐░▌                    ▐░▌          ▐░▌
    ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌
    ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
     ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ "
            puts
            puts "  START a new game (Player vs Player)"
            puts "  LOAD a previous game"
            puts "  EXIT to close the program"
            puts 
            input = gets.chomp.downcase
            case input
            when "start"
                new_game
                play_game
            when "load"
                if load_game
                    play_game
                end
            when "exit"
                break
            end
        end
    end
    def play_game
        refresh_board
        while true
            case @turn
            when :p1
                until @p1.turn
                end
            when :p2
                until @p2.turn
                end
            end
            @board.update
            case @turn
            when :exit
                puts "  Returning to menu! Press enter to continue"
                gets
                break
            when :end
                refresh_board
                puts "  Press enter to return to menu"
                gets
                break
            when :p1
                @turn = :p2
            when :p2
                @turn = :p1
            end
        end
    end
    def new_game
        @board = Board.new(self)
        @board.initialize_tokens
        @p1 = Player.new(@board, :white)
        @p2 = Player.new(@board, :black)
        @turn = :p1
    end
    def save_game
        args = {
            tokens: @board.save_tokens,
            move_log: @board.move_log,
            turn: @turn
        }
        save_menu(args)
        refresh_board
    end
    def exit_game
        @turn = :exit
    end
    def set_turn(turn)
        @turn = turn
    end
    def refresh_board
        @board.refresh
    end
    def load_game
        while true
            saves = {}
            Dir.children("saves/").each_with_index {|name, i| saves[:"#{i}"] = name.gsub(".json", "")}
            puts `clear`
            puts "  Please type the number of the save you wish to load!"
            puts "  DELETE to delete a file"
            puts "  EXIT to leave this menu"
            puts
            saves.each {|i, name| puts "    #{i}: #{name}"}
            puts
            case input = gets.chomp.downcase
            when "delete"
                puts
                puts "  Enter the number of the save you wish to delete"
                puts
                input = gets.chomp.downcase
                puts
                if File.exist?("saves/#{saves[:"#{input}"]}.json")
                    puts "  Are you sure you wish to delete #{saves[:"#{input}"]}? y/n"
                    temp = input
                    input = gets.chomp.downcase
                    puts
                    if input == "y"
                        File.delete("saves/#{saves[:"#{temp}"]}.json")
                        puts "#{saves[:"#{temp}"]} deleted!"
                    else
                        puts "  Deletion cancelled. Press enter to continue"
                        gets
                    end
                else
                    puts "  #{input} is not a valid save selection! Press enter to continue"
                    gets
                end
            when "exit"
                break
            else
                if File.exist?("saves/#{saves[:"#{input}"]}.json")
                    puts "  Attempting to load #{saves[:"#{input}"]}"
                    translated_save = JSON.parse(File.read("saves/#{saves[:"#{input}"]}.json"))
                    @board = Board.new(self)
                    @board.load_tokens(translated_save["tokens"])
                    @board.load_log(translated_save["move_log"])
                    @p1 = Player.new(@board, :white)
                    @p2 = Player.new(@board, :black)
                    @turn = translated_save["turn"].to_sym
                    return true
                else
                    puts "  #{input} is not a valid save selection! Press enter to continue"
                    gets
                end
            end
        end
    end
end

Menu.new