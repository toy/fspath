require 'pathname'

class FSPath < Pathname
  class << self
    # Return current user home path if called without argument.
    # If called with argument return specified user home path.
    def ~(name = nil)
      new(File.expand_path("~#{name}"))
    end
  end

  # Join paths using File.join
  def /(other)
    self.class.new(File.join(@path, other.to_s))
  end

  unless (new('a') + 'b').is_a?(self)
    # Fixing Pathname.+
    def +(part)
      self.class.new(super + part)
    end
  end

  # Write data to file
  def write(data)
    open('wb') do |f|
      f.write(data)
    end
  end

  # Append data to file
  def append(data)
    open('ab') do |f|
      f.write(data)
    end
  end

  # Escape characters in glob pattern
  def escape_glob
    self.class.new(@path.gsub(/([\*\?\[\]\{\}])/, '\\\\\1'))
  end

  # Expand glob
  def glob(*args, &block)
    flags = args.last.is_a?(Fixnum) ? args.pop : nil
    args = [File.join(self, *args)]
    args << flags if flags
    self.class.glob(*args, &block)
  end

  # Iterates over and yields each element in the given path in ascending order
  def ascend(&block)
    ascendants = []
    path = @path
    ascendants << self
    while r = chop_basename(path)
      path, name = r
      break if path.empty?
      ascendants << self.class.new(del_trailing_separator(path))
    end
    if block
      ascendants.each(&block)
    end
    ascendants
  end

  # Iterates over and yields each element in the given path in descending order
  def descend(&block)
    descendants = ascend.reverse
    if block
      descendants.each(&block)
    end
    descendants
  end

  # Returns path parts
  def parts(&block)
    split_names(@path).flatten
  end
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end

require 'fspath/xattr'
if RUBY_PLATFORM.downcase.include?('darwin')
  require 'fspath/darwin'
end
