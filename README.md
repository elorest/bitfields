# Bit Fields for Crystal-Lang

Pure [Crystal](https://crystal-lang.org/) implementation of Bit Fields. Handles encoding/decoding of bytes.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  bitfields:
    github: elorest/bitfields
```
2. Run `shards install`

## Usage

```crystal
require "bitfields"

class CrossBit < BitFields
  bf rpms : UInt32, 32
  bf temp : UInt8, 4 
  bf psi : UInt16, 9 
  bf power : UInt8, 1 
  bf lights : UInt8, 2 
end

crossbit = CrossBit.new(Bytes[109, 121, 110, 97, 109, 245])
puts crossbit.temp
puts crossbit.psi
puts crossbit.power
puts crossbit.lights
puts crossbit.to_slice
puts crossbit.to_s
puts crossbit.power = 1
puts crossbit.to_slice
```

## Contributing

1. Fork it (<https://github.com/elorest/bitfields/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Isaac Sloan](https://github.com/elorest) - creator and maintainer
