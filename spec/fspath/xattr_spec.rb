require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Xattr do
  describe "new" do
    it "should accept follow_symlinks as second attribute" do
      Xattr.new('a', true).follow_symlinks.should == true
      Xattr.new('a', false).follow_symlinks.should == false
    end

    it "should alias get/set as []" do
      Xattr.instance_method(:[]).should == Xattr.instance_method(:get)
      Xattr.instance_method(:[]=).should == Xattr.instance_method(:set)
    end
  end
end

describe FSPath do
  before do
    @file_path = 'with_xattr'
  end

  describe "xattr" do
    before do
      @xattr = FSPath(@file_path).xattr
    end

    it "should return instance of Xattr" do
      @xattr.should be_kind_of(Xattr)
    end

    it "should follow_symlinks" do
      @xattr.follow_symlinks.should be_true
    end

    it "should point to same path" do
      @xattr.instance_variable_get(:@path).should == @file_path
    end
  end

  describe "lxattr" do
    before do
      @lxattr = FSPath(@file_path).lxattr
    end

    it "should return instance of Xattr" do
      @lxattr.should be_kind_of(Xattr)
    end

    it "should not follow_symlinks" do
      @lxattr.follow_symlinks.should be_false
    end

    it "should point to same path" do
      @lxattr.instance_variable_get(:@path).should == @file_path
    end
  end
end
