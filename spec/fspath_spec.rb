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

  describe "+" do
    it "should return instance of FSPath" do
      (FSPath('a') + 'b').should be_instance_of(FSPath)
    end
  end

  describe "writing" do
    before do
      @path = FSPath.new('test')
      @file = mock(:file)
      @data = mock(:data)
      @size = mock(:size)

      @path.stub!(:open).and_yield(@file)
      @file.stub!(:write).and_return(@size)
    end

    describe "write" do
      it "should open file for writing" do
        @path.should_receive(:open).with('wb')
        @path.write(@data)
      end

      it "should write data" do
        @file.should_receive(:write).with(@data)
        @path.write(@data)
      end

      it "should return result of write" do
        @path.write(@data).should == @size
      end
    end

    describe "append" do
      it "should open file for writing" do
        @path.should_receive(:open).with('ab')
        @path.append(@data)
      end

      it "should write data" do
        @file.should_receive(:write).with(@data)
        @path.append(@data)
      end

      it "should return result of write" do
        @path.append(@data).should == @size
      end
    end
  end

  describe "escape_glob" do
    it "should escape glob pattern characters" do
      FSPath('*/**/?[a-z]{abc,def}').escape_glob.should == FSPath('\*/\*\*/\?\[a-z\]\{abc,def\}')
    end
  end

end
