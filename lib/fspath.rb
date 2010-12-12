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

  # Fixing Pathname.+
  def +(part)
    self.class.new(super + part)
  end

  if RUBY_PLATFORM.downcase.include?('darwin')
    def darwin!
      p :darwin
    end
  end
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end
