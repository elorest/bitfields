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
      getter {{name.id}} : {{type.id}} 
    {% end %}       

    def initialize(@bytes : Bytes)
      %bytes = @bytes
      %len = %mod = 0
      {% for name, type, index in FIELDS %}
        unshift? = (%mod > 0 && {{LENGTHS[index]}} > 8 - %mod)
        %bytes[0] <<= %mod if unshift? 
        %val = IO::ByteFormat::LittleEndian.decode({{type.id}}, %bytes)
        %val >>= %mod if unshift? 
        %val &= (2**{{LENGTHS[index]}}-1)
        @{{name.id}} = %val

        %len, %mod = ({{LENGTHS[index]}}+(%mod > 0 && unshift? ? 8-%mod : 0)).divmod(8)
        %bytes = %bytes[%len, %bytes.size - %len] if %len > 0
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
# |psi       |temp|
# |0100110111|1011|

class CrossBit < BitFields
  bf temp : UInt8, 4 
  bf psi : UInt16, 8 
  bf power : UInt8, 1 
  bf lights : UInt8, 3 
end

cross = CrossBit.new(Bytes[123, 179])
puts cross.temp
puts cross.psi
puts cross.power
puts cross.lights
puts cross.to_slice
puts CrossBit::BYTE_COUNT.inspect
puts CrossBit::BIT_COUNT.inspect
puts cross.to_s

# |mde|hue  |rpms                            |
# |101|10110|10100111000101111010000100110111|
class BTest < BitFields
  bf rpms : UInt32, 32 
  bf hue : UInt8, 5 
  bf mode : UInt8, 3
end

vm = BTest.new(Bytes[55, 161, 23, 167, 182])
puts vm.rpms
puts vm.hue
puts vm.mode
