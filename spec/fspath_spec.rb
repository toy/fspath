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

  if RUBY_PLATFORM.downcase.include?('darwin')
    describe "mac related" do
      describe "move_to_trash" do
        it "should call delete on mac_finder_alias" do
          @path = FSPath('to_delete')
          @finder_alias = mock(:finder_alias)

          @path.should_receive(:mac_finder_alias).and_return(@finder_alias)
          @finder_alias.should_receive(:delete)

          @path.move_to_trash
        end
      end

      describe "labels" do
        describe "getting" do
          it "should call label_index.get on mac_finder_alias" do
            @path = FSPath('to_label')
            @finder_alias = mock(:finder_alias)
            @label_index = mock(:label_index)

            @path.should_receive(:mac_finder_alias).and_return(@finder_alias)
            @finder_alias.should_receive(:label_index).and_return(@label_index)
            @label_index.should_receive(:get).and_return(0)

            @path.label
          end

          it "should return apporitate label" do
            @path = FSPath('to_label')
            @finder_alias = mock(:finder_alias)
            @label_index = mock(:label_index)

            @path.stub!(:mac_finder_alias).and_return(@finder_alias)
            @finder_alias.stub!(:label_index).and_return(@label_index)

            FSPath::LABEL_COLORS.each_with_index do |label, index|
              @label_index.stub!(:get).and_return(index)
              @path.label.should == label
            end
          end
        end

        describe "setting" do
          it "should call label_index.set on mac_finder_alias" do
            @path = FSPath('to_label')
            @finder_alias = mock(:finder_alias)
            @label_index = mock(:label_index)

            @path.should_receive(:mac_finder_alias).and_return(@finder_alias)
            @finder_alias.should_receive(:label_index).and_return(@label_index)
            @label_index.should_receive(:set)

            @path.label = nil
          end

          describe "index" do
            before do
              @path = FSPath('to_label')
              @finder_alias = mock(:finder_alias)
              @label_index = mock(:label_index)

              @path.stub!(:mac_finder_alias).and_return(@finder_alias)
              @finder_alias.stub!(:label_index).and_return(@label_index)
            end

            it "should call label_index.set with apporitate index" do
              FSPath::LABEL_COLORS.each_with_index do |label, index|
                @label_index.should_receive(:set).with(index).ordered
                @path.label = label
              end
            end

            it "should accept aliases" do
              FSPath::LABEL_COLOR_ALIASES.each do |label_alias, label|
                index = FSPath::LABEL_COLORS.index(label)
                @label_index.should_receive(:set).with(index).ordered
                @path.label = label_alias
              end
            end

            it "should set to none when called with nil or false" do
              [nil, false].each do |label|
                @label_index.should_receive(:set).with(0).ordered
                @path.label = label
              end
            end

            it "should raise when called with something else" do
              [true, :shitty, 'hello'].each do |label|
                proc do
                  @path.label = label
                end.should raise_error("Unknown label #{label.inspect}")
              end
            end
          end
        end
      end

      describe "appscript objects" do
        before do
          @file_path = File.expand_path(__FILE__)
        end

        describe "mac_alias" do
          it "should return instance of MacTypes::Alias" do
            FSPath(@file_path).mac_alias.should be_kind_of(MacTypes::Alias)
          end

          it "should point to same path" do
            FSPath(@file_path).mac_alias.path.should == @file_path
          end
        end

        describe "mac_file_url" do
          it "should return instance of MacTypes::FileURL" do
            FSPath(@file_path).mac_file_url.should be_kind_of(MacTypes::FileURL)
          end

          it "should point to same path" do
            FSPath(@file_path).mac_file_url.path.should == @file_path
          end
        end

        describe "mac_finder_alias" do
          it "should return same ref" do
            FSPath(@file_path).mac_finder_alias.should == Appscript.app('Finder').items[FSPath(@file_path).mac_alias]
          end
        end

        describe "mac_finder_file_url" do
          it "should return same ref" do
            FSPath(@file_path).mac_finder_file_url.should == Appscript.app('Finder').items[FSPath(@file_path).mac_file_url]
          end
        end
      end
    end
  end
end
