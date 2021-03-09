require 'json'

module Save_Game
    def list_saves
        saves = []
        Dir.children("/saves").each do |save|
            saves.append(save)
        end
        puts saves
    end
    def save_menu(args)
        puts "  What would you like to name your new save?"
        puts
        input = gets.chomp.to_s
        puts
        unless input.empty?
            if File.exist?("saves/#{input}.json")
                puts
                puts "  #{input} already exists! Would you like to overwrite? y/n"
                puts
                choice = gets.chomp.to_s.downcase
                puts
                case choice[0]
                when "y"
                    puts "  Saving #{input}!"
                    name = input
                    save(args, name)
                else
                    puts
                    puts "  Cancelled save. Press enter to continue."
                    gets
                end
            else
                puts "  Saving #{input}!"
                name = input
                save(args, name)
            end
        else
            puts "  Please enter a save name! Press enter to continue"
            gets
        end
    end
    def save(args, name="Default")
        save_file = File.new("saves/#{name}.json", "w")
        save_file.puts(args.to_json)
        save_file.close
        puts "  #{name}.json made! Press enter to continue"
        gets
    end
end