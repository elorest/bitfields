require "colorize"

class BitFields
  COLORS = { {148,0,211}, {75,0,130}, {0,0,255}, {0,255,0}, {255,255,0}, {255,127,0}, {255,0,0} }

  macro inherited
    FIELDS = {} of Nil => Nil
    LENGTHS = [] of Int32

    macro finished
      process_fields
    end
  end

  macro bf(field, length)
    {% FIELDS[field.var] = field.type %} 
    {% LENGTHS << length %} 
  end

  macro process_fields
    BIT_COUNT = LENGTHS.sum
    BYTE_COUNT = (BIT_COUNT/8.0).ceil.to_i

    {% for name, type in FIELDS %}
      property {{name.id}} : {{type.id}} 
    {% end %}       

    def initialize(bytes : Bytes)
      %bytes = bytes.clone
      %len = %mod = 0
      {% for name, type, index in FIELDS %}
        %bit_len = {{LENGTHS[index]}}
        unshift? = (%mod > 0 && %bit_len > 8 - %mod)
        %bytes[0] <<= %mod if unshift? 
        %val = IO::ByteFormat::LittleEndian.decode({{type.id}}, %bytes)
        %val >>= %mod if unshift? 
        %val &= (2**%bit_len-1)
        @{{name.id}} = %val

        %byte_len, %mod = (%bit_len+(%mod > 0 && unshift? ? 8-%mod : 0)).divmod(8)
        %bytes = %bytes[%byte_len, %bytes.size - %byte_len] if %byte_len > 0
        %bytes[0] >>= %mod if %mod > 0
      {% end %}
    end

    def to_slice
      %bytes = Bytes.new(BYTE_COUNT)
      %byte_index = 0
      %buffer : UInt64 = 0
      %head = 0 

      {% for name, type, index in FIELDS %}
        %buffer ^= ({{name.id}}.to_u64 << %head)
        %head += {{LENGTHS[index]}}
        while %head > 8
          %bytes[%byte_index] = %buffer.to_u8
          %buffer >>= 8
          %byte_index += 1
          %head -= 8
        end
      {% end %}       
      %bytes[%byte_index] = %buffer.to_u8
      %bytes
    end

    def to_s
      %titles = %bits = "|"
      {% for name, type, index in FIELDS %}
        %color = Colorize::ColorRGB.new(*COLORS[{{index}} % COLORS.size].map(&.to_u8))
        %titles = %(|#{"{{name.id}}".colorize(%color)}#{%titles})
        %bits = %(|#{sprintf("%0{{LENGTHS[index]}}b", {{name.id}}).colorize(%color)}#{%bits})
      {% end %}       
      [%titles, %bits].join("\n")
    end
  end
end
