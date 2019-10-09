require "colorize"

class BitFields
  COLORS = { {148, 0, 211}, {75, 0, 130}, {0, 0, 255}, {0, 255, 0}, {255, 255, 0}, {255, 127, 0}, {255, 0, 0} }

  def self.byte_len(sbit, bit_len)
    ((bit_len + sbit%8)/8.0).ceil.to_i
  end


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

    {% for name, type, index in FIELDS %}
      getter {{name.id}} : {{type.id}}

      def {{name.id}}=(v : {{type.id}})
        @{{name.id}} = (v & {{2u64**LENGTHS[index]-1}})
      end
    {% end %}

    def initialize(bytes : Bytes)
      %bytes = bytes.clone
      %sbit = 0
      {% for name, type, index in FIELDS %}
        %bit_len = LENGTHS[{{index}}]
        %byte_len = self.class.byte_len(%sbit, %bit_len)
        %buffer = 0_u64
        %bytes[%sbit//8, %byte_len].each.with_index do |b, i|
          %buffer ^= (b.to_u64 << i*8)
        end
        %buffer >>= (%sbit % 8)
        %buffer &= (2u64**%bit_len-1)
        %sbit += %bit_len
        @{{name.id}} = {{type.id}}.new(%buffer)
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

    def to_t
      {
      {% for name, type, index in FIELDS %}
        {{name.id}}: {value: @{{name.id}}, length: {{LENGTHS[index]}} },
      {% end %}
      }
    end

    def to_s
      %str_arr = Array(String).new
      {% for name, type, index in FIELDS %}
        %str_arr << "{{name.id}} -- Binary:#{sprintf("%0{{LENGTHS[index]}}b", {{name.id}})} Hex:#{sprintf("%X", {{name.id}})} Decimal:#{ {{name.id}} }"
      {% end %}
      %str_arr.join("\n")
    end
  end
end
