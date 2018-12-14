require "spec"

def byte_len(sbit, bit_length)
  ((bit_length + sbit%8) / 8.0).ceil.to_i
end

describe "byte_length" do
  it "should return 1" do
    byte_len(32, 8).should eq 1
  end
  it "should return 2" do
    byte_len(32, 16).should eq 2
  end
  it "should return 2" do
    byte_len(32, 12).should eq 2
  end
  it "should return 2" do
    byte_len(36, 8).should eq 2
  end
  it "should return 2" do
    byte_len(36, 12).should eq 2
  end
  it "should return 3" do
    byte_len(36, 16).should eq 3
  end
  it "should return 3" do
    byte_len(36, 15).should eq 3
  end
  it "should return 3" do
    byte_len(36, 17).should eq 3
  end
end
