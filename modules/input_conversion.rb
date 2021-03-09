module Input_Conversions
    CHARACTER_CONVERSIONS = {
        a:0,
        b:1,
        c:2,
        d:3,
        e:4,
        f:5,
        g:6,
        h:7
    }
    def convert_input(pos)
        converted_pos = [8 - pos[1].to_i, CHARACTER_CONVERSIONS[pos[0].downcase.to_sym].to_i]
    end
    def readable_convert(pos)
        i = nil
        CHARACTER_CONVERSIONS.keys.each do |char|
            if CHARACTER_CONVERSIONS[char] == pos[1]
                i = char
                break
            end
        end
        return "#{i}#{8 - pos[0]}"
    end
end