$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'fspath'

describe FSPath do
  class ZPath < FSPath
  end

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

  describe "common_dir" do
    it "should return dirname if called with one path" do
      FSPath.common_dir('/a/b/c').should == FSPath('/a/b')
    end

    it "should return common path if called with mulpitle paths" do
      FSPath.common_dir('/a/b/c/d/e', '/a/b/c/d/f', '/a/b/c/z').should == FSPath('/a/b/c')
    end

    it "should return nil if there is no common path" do
      FSPath.common_dir('../a', './b').should be_nil
    end
  end

  [FSPath, ZPath].each do |klass|
    describe "#{klass}.temp_file" do
      it "should return Tempfile with path returning instance of #{klass}" do
        klass.temp_file.should be_kind_of(Tempfile)
        klass.temp_file.path.should be_kind_of(klass)
      end

      it "should yield Tempfile with path returning instance of #{klass}" do
        yielded = nil
        klass.temp_file{ |y| yielded = y }
        yielded.should be_kind_of(Tempfile)
        yielded.path.should be_kind_of(klass)
      end

      it "should return result of block" do
        klass.temp_file{ :result }.should == :result
      end

      it "should call appropriate initializer (jruby 1.8 mode bug)" do
        lambda {
          klass.temp_file('abc', '.'){}
        }.should_not raise_error
      end
    end

    describe "#{klass}.temp_file_path" do
      it "should return #{klass} with temporary path" do
        klass.temp_file_path.should be_kind_of(klass)
      end

      it "should not allow GC to finalize TempFile" do
        paths = Array.new(1000){ FSPath.temp_file_path }
        paths.should be_all(&:exist?)
        GC.start
        paths.should be_all(&:exist?)
      end

      it "should yield #{klass} with temporary path" do
        yielded = nil
        klass.temp_file_path{ |y| yielded = y }
        yielded.should be_kind_of(klass)
      end
    end
  end

  describe "temp_dir" do
    it "should return result of running Dir.mktmpdir as FSPath instance" do
      @path = '/tmp/a/b/1'
      Dir.stub(:mktmpdir).and_return(@path)

      FSPath.temp_dir.should == FSPath('/tmp/a/b/1')
    end

    it "should yield path yielded by Dir.mktmpdir as FSPath instance" do
      @path = '/tmp/a/b/2'
      Dir.stub(:mktmpdir).and_yield(@path)

      yielded = nil
      FSPath.temp_dir{ |y| yielded = y }
      yielded.should == FSPath('/tmp/a/b/2')
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

    it "should join simple paths" do
      (FSPath('a') + 'b').should == FSPath('a/b')
    end

    it "should join path starting with slash" do
      (FSPath('a') + '/b').should == FSPath('/b')
    end
  end

  describe "relative_path_from" do
    it "should return instance of FSPath" do
      (FSPath('a').relative_path_from('b')).should be_instance_of(FSPath)
    end

    it "should return relative path" do
      (FSPath('b/a').relative_path_from('b')).should == FSPath('a')
    end
  end

  describe "writing" do
    before do
      @path = FSPath.new('test')
      @file = double(:file)
      @data = double(:data)
      @size = double(:size)

      @path.stub(:open).and_yield(@file)
      @file.stub(:write).and_return(@size)
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

  describe "glob" do
    it "should join with arguments and expand glob" do
      FSPath.should_receive(:glob).with('a/b/c/**/*')
      FSPath('a/b/c').glob('**', '*')
    end

    it "should join with arguments and expand glob" do
      @flags = 12345
      FSPath.should_receive(:glob).with('a/b/c/**/*', @flags)
      FSPath('a/b/c').glob('**', '*', @flags)
    end

    it "should escape glob characters in path itself" do
      FSPath.should_receive(:glob).with('somewhere \[a b c\]/**/*')
      FSPath('somewhere [a b c]').glob('**', '*')
    end
  end

  describe "path parts" do
    describe "ascend" do
      before do
        @path = FSPath('/a/b/c')
        @ascendants = %w[/a/b/c /a/b /a /].map(&method(:FSPath))
      end

      it "should return list of ascendants" do
        @path.ascend.should == @ascendants
      end

      it "should yield and return list of ascendants if called with block" do
        ascendants = []
        @path.ascend do |path|
          ascendants << path
        end.should == @ascendants
        ascendants.should == @ascendants
      end
    end

    describe "descend" do
      before do
        @path = FSPath('/a/b/c')
        @descendants = %w[/ /a /a/b /a/b/c].map(&method(:FSPath))
      end

      it "should return list of descendants" do
        @path.descend.should == @descendants
      end

      it "should yield and return list of descendants if called with block" do
        descendants = []
        @path.descend do |path|
          descendants << path
        end.should == @descendants
        descendants.should == @descendants
      end
    end

    describe "parts" do
      it "should return path parts as strings" do
        FSPath('/a/b/c').parts.should == %w[/ a b c]
      end
    end
  end
end
