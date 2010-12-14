require 'xattr'

Xattr.class_eval do
  # Accept follow_symlinks as second attribute
  def initialize(path, follow_symlinks = true)
    @path = path
    @follow_symlinks = follow_symlinks
  end
  alias_method :[], :get
  alias_method :[]=, :set
end

class FSPath < Pathname
  # Xattr instance for path
  def xattr
    Xattr.new(@path)
  end

  # Xattr instance for path which doesn't follow symlinks
  def lxattr
    Xattr.new(@path, false)
  end
end
