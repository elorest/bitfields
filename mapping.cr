# module BitFields
#   macro mapping(properties, strict = false)
#     # {% for key, value in properties %}
#     #   def {{key.var}}
#     #     puts {{value}}
#     #     puts "{{key.type}}"
#     #   end
#     # {% end %}
#   end
# end

class BFTest
  @@hello = Array(Int32).new
  # @@hello = ""
  @@hello << 12 
  puts @@hello
  @@hello << 4
  puts @@hello
  @@hello << 8 
  puts @@hello
  @@hello << 4
  puts @@hello
  @@hello << 4
  puts @@hello

  # BitFields.mapping(
  #   name : UInt8 => 5,
  #   house : UInt8 => 3,
  # )
  def self.hello
    @@hello
  end
end

puts BFTest.hello
