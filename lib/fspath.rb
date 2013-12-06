require 'pathname'
require 'tempfile'
require 'tmpdir'

class FSPath < Pathname
  class Tempfile < ::Tempfile
    def initialize(path_klass, *args)
      raise ArgumentError.new("#{path_klass.inspect} is not a class") unless path_klass.is_a?(Class)
      @path_klass = path_klass
      super(*args)
    end

    def path
      @path_klass.new(super)
    end

    def self.open(*args)
      tempfile = new(*args)

      if block_given?
        begin
          yield(tempfile)
        ensure
          tempfile.close
        end
      else
        tempfile
      end
    end
  end

  class << self
    # Return current user home path if called without argument.
    # If called with argument return specified user home path.
    def ~(name = nil)
      new(File.expand_path("~#{name}"))
    end

    # Returns common dir for paths
    def common_dir(*paths)
      paths.map do |path|
        new(path).dirname.ascend
      end.inject(:&).first
    end

    # Returns or yields temp file created by Tempfile.new with path returning FSPath
    def temp_file(*args, &block)
      args = %w[f] if args.empty?
      Tempfile.open(self, *args, &block)
    end

    # Returns or yields path as FSPath of temp file created by Tempfile.new
    # WARNING: loosing reference to returned object will remove file on nearest GC run
    def temp_file_path(*args)
      if block_given?
        temp_file(*args) do |file|
          yield file.path
        end
      else
        file = temp_file(*args)
        file.close
        path = file.path
        path.instance_variable_set(:@__temp_file, file)
        path
      end
    end

    # Returns or yields FSPath with temp directory created by Dir.mktmpdir
    def temp_dir(*args)
      if block_given?
        Dir.mktmpdir(*args) do |dir|
          yield new(dir)
        end
      else
        new(Dir.mktmpdir(*args))
      end
    end
  end

  # Join paths using File.join
  def /(other)
    self.class.new(File.join(@path, other.to_s))
  end

  unless (new('a') + 'b').is_a?(self)
    # Fixing Pathname.+
    def +(other)
      self.class.new(plus(@path, other.to_s))
    end
  end

  # Fixing Pathname.relative_path_from
  def relative_path_from(other)
    self.class.new(super(self.class.new(other)))
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
    self.class.new(escape_glob_string)
  end

  # Expand glob
  def glob(*args, &block)
    flags = args.last.is_a?(Fixnum) ? args.pop : nil
    args = [File.join(escape_glob_string, *args)]
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

private

  def escape_glob_string
    @path.gsub(/([\*\?\[\]\{\}])/, '\\\\\1')
  end
end

module Kernel
  # FSPath(path) method
  def FSPath(path)
    FSPath.new(path)
  end
  private :Pathname
end
