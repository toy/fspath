require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe FSPath do
  it "should inherit from Pathname" do
    FSPath.new('.').should be_kind_of(Pathname)
  end

  it "should use shortcut" do
    FSPath('.').should === FSPath.new('.')
  end

  describe "~" do
    it "should return current user home directory" do
      FSPath.~.should == FSPath(File.expand_path('~'))
    end

    it "should return other user home directory" do
      FSPath.~('root').should == FSPath(File.expand_path('~root'))
    end
  end

  describe "/" do
    it "should join path with string" do
      (FSPath('a') / 'b').should == FSPath('a/b')
    end

    it "should join path with another FSPath" do
      (FSPath('a') / FSPath('b')).should == FSPath('a/b')
    end

    it "should join with path starting with slash" do
      (FSPath('a') / '/b').should == FSPath('a/b')
    end
  end
end
