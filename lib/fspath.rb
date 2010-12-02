class FSPath < Pathname
  class << self
    # return current user home path if called without argument
    # if called with argument return specified user home path
    def ~(name = nil)
      new(File.expand_path("~#{name}"))
    end
  end

  # join paths using File.join
  def /(other)
    self.class.new(File.join(@path, other.to_s))
  end

  # fixing Pathname.+
  def +(part)
    self.class.new(super + part)
  end
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end
