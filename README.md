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
crossbit.to_s          #=> |lights|power|psi|temp|rpms|
                       #=> |11|1|101010110|1101|01100001011011100111100101101101|
crossbit.power = 0     #=> 0_u8
crossbit.to_slice      #=> Bytes[109, 121, 110, 97, 109, 213]
```

## Contributing

1. Fork it (<https://github.com/elorest/bitfields/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Isaac Sloan](https://github.com/elorest) - creator and maintainer
