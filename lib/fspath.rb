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

  if RUBY_PLATFORM.downcase.include?('darwin')
    begin
      require 'appscript'

      # Move to trash using finder
      def move_to_trash
        mac_finder_alias.delete
      end

      FINDER_LABEL_COLORS = [:none, :orange, :red, :yellow, :blue, :purple, :green, :gray].freeze
      FINDER_LABEL_COLOR_ALIASES = {:grey => :gray}.freeze
      def finder_label
        FINDER_LABEL_COLORS[mac_finder_alias.label_index.get]
      end
      def finder_label=(color)
        color = FINDER_LABEL_COLOR_ALIASES[color] || color || :none
        index = FINDER_LABEL_COLORS.index(color)
        raise "Unknown label #{color.inspect}" unless index
        mac_finder_alias.label_index.set(index)
      end

      def spotlight_comment
        mac_finder_alias.comment.get
      end

      def spotlight_comment=(comment)
        mac_finder_alias.comment.set(comment.to_s)
      end

      # MacTypes::Alias for path
      def mac_alias
        MacTypes::Alias.path(@path)
      end

      # MacTypes::FileURL for path
      def mac_file_url
        MacTypes::FileURL.path(@path)
      end

      # Finder item for path through mac_alias
      def mac_finder_alias
        Appscript.app('Finder').items[mac_alias]
      end

      # Finder item for path through mac_alias
      def mac_finder_file_url
        Appscript.app('Finder').items[mac_file_url]
      end
    rescue LoadError
      warn "Can't load appscript"
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
