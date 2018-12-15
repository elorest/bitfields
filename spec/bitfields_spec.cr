require "./spec_helper"

class CrossBit < BitFields
  bf rpms : UInt32, 32
  bf temp : UInt8, 4 
  bf psi : UInt16, 9 
  bf power : UInt8, 1 
  bf lights : UInt8, 2 
  bf v1 : UInt16, 16 
  bf v2 : UInt8, 4
  bf v3 : UInt8, 8 
  bf v4 : UInt8, 4 
  bf v5 : UInt8, 8
end

describe BitFields do
  describe "Class" do
    describe "byte_length" do
      it "should return 1" do
        BitFields.byte_len(32, 8).should eq 1
      end
      it "should return 2" do
        BitFields.byte_len(32, 16).should eq 2
      end
      it "should return 2" do
        BitFields.byte_len(32, 12).should eq 2
      end
      it "should return 2" do
        BitFields.byte_len(36, 8).should eq 2
      end
      it "should return 2" do
        BitFields.byte_len(36, 12).should eq 2
      end
      it "should return 3" do
        BitFields.byte_len(36, 16).should eq 3
      end
      it "should return 3" do
        BitFields.byte_len(36, 15).should eq 3
      end
      it "should return 3" do
        BitFields.byte_len(36, 17).should eq 3
      end
    end
  end

  describe "Instance" do
    bytes = Bytes[109, 121, 110, 97, 221, 181, 220, 0, 28, 252, 105]
    crossbit = CrossBit.new(bytes)

    it "should read 32 bits into a UInt32" do
      crossbit.rpms.should eq 1634629997
      crossbit.rpms.class.should eq UInt32
    end

    it "should read first 4 bits into a UInt8" do
      crossbit.temp.should eq 13 
      crossbit.temp.class.should eq UInt8
    end

    it "should read the next 9 bits from across bytes into a UInt16" do
      crossbit.psi.should eq 349 
      crossbit.psi.class.should eq UInt16
    end

    it "should read the next bit into UInt8" do
      crossbit.power.should eq 1 
      crossbit.power.class.should eq UInt8
    end

    it "should read the next 2 bits to end of byte into UInt8" do
      crossbit.lights.should eq 2
      crossbit.lights.class.should eq UInt8
    end

    it "should read v1 correctly" do
      crossbit.v1.should eq 220 
    end

    it "should read v2 correctly" do
      crossbit.v2.should eq 12 
    end

    it "should read v3 correctly" do
      crossbit.v3.should eq 193 
    end

    it "should read v4 correctly" do
      crossbit.v4.should eq 15 
    end

    it "should read v5 correctly" do
      crossbit.v5.should eq 105 
    end

    it "should output modified bytes if values are modified" do
      crossbit.lights = 1
      crossbit.psi = 319
      crossbit.v1 = 225 
      crossbit.v2 = 13 
      crossbit.v3 = 173 
      crossbit.v4 = 14 
      crossbit.v5 = 115 
      new_bytes = Bytes[109, 121, 110, 97, 253, 115, 225, 0, 221, 234, 115]
      crossbit.to_slice.should eq new_bytes
    end

    it "should read in new bytes and print out correct values" do
      c2 = CrossBit.new(crossbit.to_slice)

      crossbit.lights.should eq 1
      crossbit.psi.should eq 319
      crossbit.v1.should eq 225 
      crossbit.v2.should eq 13 
      crossbit.v3.should eq 173 
      crossbit.v4.should eq 14 
      crossbit.v5.should eq 115 
    end

    it "should return string printout" do
      str = "rpms -- Binary:01100001011011100111100101101101 Hex:616E796D Decimal:1634629997\ntemp -- Binary:1101 Hex:D Decimal:13\npsi -- Binary:100111111 Hex:13F Decimal:319\npower -- Binary:1 Hex:1 Decimal:1\nlights -- Binary:01 Hex:1 Decimal:1\nv1 -- Binary:0000000011100001 Hex:E1 Decimal:225\nv2 -- Binary:1101 Hex:D Decimal:13\nv3 -- Binary:10101101 Hex:AD Decimal:173\nv4 -- Binary:1110 Hex:E Decimal:14\nv5 -- Binary:01110011 Hex:73 Decimal:115"
      crossbit.to_s.should eq str 
    end

    it "should return tuple" do
      t =  {rpms: {value: 1634629997_u32, length: 32}, temp: {value: 13_u8, length: 4}, psi: {value: 319_u16, length: 9}, power: {value: 1_u8, length: 1}, lights: {value: 1_u8, length: 2}, v1: {value: 225_u16, length: 16}, v2: {value: 13_u8, length: 4}, v3: {value: 173_u8, length: 8}, v4: {value: 14_u8, length: 4}, v5: {value: 115_u8, length: 8}}
      crossbit.to_t.should eq t 
      #{name: {value: "isaac", length: 5}}
    end
  end
end
