require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fspath/xattr'

describe FSPath do
  let(:path){ 'test.txt' }
  let(:link){ 'link.txt' }

  before do
    File.open(path, 'w'){ |io| io << 'some content' }
    File.symlink(path, link)
  end
  after do
    File.delete(path)
    File.delete(link)
  end

  describe "xattr" do
    let(:xattr){ FSPath(link).xattr }

    it "should return instance of Xattr" do
      xattr.should be_kind_of(Xattr)
    end

    it "should point to same path" do
      xattr.instance_variable_get(:@path).should == link
    end

    it "should set xattr on linked path" do
      FSPath(path).xattr['user.hello'].should be_nil
      xattr['user.hello'] = 'foo'
      xattr['user.hello'].should == 'foo'
      FSPath(path).xattr['user.hello'].should == 'foo'
    end
  end

  describe "lxattr" do
    let(:xattr){ FSPath(link).lxattr }

    it "should return instance of Xattr" do
      xattr.should be_kind_of(Xattr)
    end

    it "should point to same path" do
      xattr.instance_variable_get(:@path).should == link
    end

    it "should set xattr on link itself" do
      FSPath(path).xattr['user.hello'].should be_nil
      xattr['user.hello'] = 'foo'
      xattr['user.hello'].should == 'foo'
      FSPath(path).xattr['user.hello'].should be_nil
    end
  end
end
