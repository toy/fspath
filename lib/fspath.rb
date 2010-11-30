class FSPath < Pathname
  class << self
    # return current user home dir path if called without argument
    # if called with argument return specified user home dir path
    def ~(name = nil)
      new(File.expand_path("~#{name}"))
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
