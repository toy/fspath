require 'fspath'
require 'ffi-xattr'

class FSPath < Pathname
  # Xattr instance for path
  def xattr
    Xattr.new(@path)
  end

  # Xattr instance for path which doesn't follow symlinks
  def lxattr
    Xattr.new(@path, :no_follow => true)
  end
end
