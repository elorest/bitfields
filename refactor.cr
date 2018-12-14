annotation BitField
end

class BitFields
  @bytes : Bytes

  def initialize(b : Bytes)
    @bytes = b.clone
  end

  macro bf(field, length)
    @[BitField(length: "{{field.var}}_{{length}}")]
    def {{field.var}}
      range = ranges("{{field.var}}")
      puts range.inspect
      buffer = 0_u64
      @bytes[range[:sbyte], range[:byte_count]].each.with_index do |b, i|
        buffer ^= (b.to_u64 << i*8)
      end
      buffer >>= (range[:sbit] % 8)
      buffer &= (2**{{length}}-1)
      {{field.type}}.new(buffer)
    end
  end

  def fields
    fields = Hash(String, Int32).new
    {% for ivar in @type.methods %}
      {% if ann = ivar.annotation(BitField) %}
        f, l = {{ann[:length]}}.split("_")
        fields[f] = l.to_i
      {% end %}
    {% end %}
    fields
  end

  def lengths
    fields.values
  end

  def ranges(f)
    index = fields.keys.index(f) || 0
    s_bit = lengths[0...index].sum
    e_bit = lengths[index] + s_bit
    {sbit: s_bit, ebit: e_bit, sbyte: s_bit/8, byte_count: (lengths[index]/8.0).ceil.to_i}
  end
end

class CrossBit < BitFields
  bf rpms : UInt32, 32
  bf temp : UInt8, 4 
  bf psi : UInt16, 9 
  bf power : UInt8, 1 
  bf lights : UInt8, 2 
end

crossbit = CrossBit.new(Bytes[109, 121, 110, 97, 109, 245])
puts crossbit.temp          #=> 13_u8
puts crossbit.psi           #=> 342_u16
puts crossbit.power         #=> 1_u8
puts crossbit.lights        #=> 3_u8
puts crossbit.rpms
# crossbit.to_slice      #=> Bytes[109, 121, 110, 97, 109, 245]

# class TestB < BitFields
#   bf f1 : UInt16, 10
#   bf f2 : UInt8, 2
#   bf f3 : UInt8, 4
# end
#
# b = TestB.new(Bytes[234, 201])
#
# # puts b.f1
# # puts b.f2
# # puts b.f3
# puts b.f1
# puts b.fields
# # puts b.bit_range("f3")
# # puts b.byte_range("f3")
