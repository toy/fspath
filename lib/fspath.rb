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

  if RUBY_PLATFORM.downcase.include?('darwin')
  end
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end
