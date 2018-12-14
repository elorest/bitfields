require "./spec_helper"

class CrossBit < BitFields
  bf rpms : UInt32, 32
  bf temp : UInt8, 4 
  bf psi : UInt16, 9 
  bf power : UInt8, 1 
  bf lights : UInt8, 2 
  bf v1 : UInt16, 16 
  bf v2 : UInt8, 4
  bf v3 : UInt8, 4 
  bf v4 : UInt8, 8 
  bf v5 : UInt8, 8
end

describe Bitfields do
  bytes = Bytes[109, 121, 110, 97, 109, 245, 57, 50, 56, 51, 52, 55, 56, 57, 50, 51, 56, 52, 55, 50, 57, 51, 56, 55, 50, 57, 51, 56, 52, 55]
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
    crossbit.psi.should eq 342 
    crossbit.psi.class.should eq UInt16
  end

  it "should read the next bit into UInt8" do
    crossbit.power.should eq 1 
    crossbit.power.class.should eq UInt8
  end

  it "should read the next 2 bits to end of byte into UInt8" do
    crossbit.lights.should eq 3
    crossbit.lights.class.should eq UInt8
  end

  it "should output the same Bytes which were read in" do
    crossbit.to_slice.should eq bytes 
  end

  it "should output modified bytes if values are modified" do
    crossbit.lights = 2
    crossbit.psi = 349
    crossbit.v1 = 220 
    crossbit.v2 = 97 
    crossbit.v3 = 193 
    crossbit.v5 = 38
    crossbit.v4 = 105 
    crossbit.to_s
    puts crossbit.to_slice
    new_bytes = Bytes[109, 121, 110, 97, 221, 181] 
    c2 = CrossBit.new(Bytes[109, 121, 110, 97, 221, 181, 220, 0, 113, 101, 38])
    puts c2.to_s 
    crossbit.to_slice.should eq new_bytes
  end
end
