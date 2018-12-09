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
crossbit.temp          #=> 13_u8
crossbit.psi           #=> 342_u16
crossbit.power         #=> 1_u8
crossbit.lights        #=> 3_u8
crossbit.to_slice      #=> Bytes[109, 121, 110, 97, 109, 245]
crossbit.to_s          #=> "|\e[38;2;255;255;0mlights\e[0m|\e[38;2;0;255;0mpower\e[0m|\e[38;2;0;0;255mpsi\e[0m|\e[38;2;75;0;130mtemp\e[0m|\e[38;2;148;0;211mrpms\e[0m|\n|\e[38;2;255;255;0m11\e[0m|\e[38;2;0;255;0m1\e[0m|\e[38;2;0;0;255m101010110\e[0m|\e[38;2;75;0;130m1101\e[0m|\e[38;2;148;0;211m01100001011011100111100101101101\e[0m|"
crossbit.power = 0     #=> 0_u8
crossbit.to_slice      #=> Bytes[109, 121, 110, 97, 109, 245]
```

## Contributing

1. Fork it (<https://github.com/elorest/bitfields/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Isaac Sloan](https://github.com/elorest) - creator and maintainer
