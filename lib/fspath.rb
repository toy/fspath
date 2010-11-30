class FSPath < Pathname
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end
