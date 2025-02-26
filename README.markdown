[![Gem Version](https://img.shields.io/gem/v/fspath?logo=rubygems)](https://rubygems.org/gems/fspath)
[![Check](https://img.shields.io/github/actions/workflow/status/toy/fspath/check.yml?label=check&logo=github)](https://github.com/toy/fspath/actions/workflows/check.yml)
[![Rubocop](https://img.shields.io/github/actions/workflow/status/toy/fspath/rubocop.yml?label=rubocop&logo=rubocop)](https://github.com/toy/fspath/actions/workflows/rubocop.yml)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/toy/fspath?logo=codeclimate)](https://codeclimate.com/github/toy/fspath)
[![Depfu](https://img.shields.io/depfu/toy/fspath)](https://depfu.com/github/toy/fspath)
[![Inch CI](https://inch-ci.org/github/toy/fspath.svg?branch=master)](https://inch-ci.org/github/toy/fspath)

# fspath

Better than Pathname

Check out [fspath-mac](https://rubygems.org/gems/fspath-mac) and [fspath-xattr](https://rubygems.org/gems/fspath-xattr).

## Synopsis

User dir:

    FSPath.~

Other user dir:

    FSPath.~('other')

Common dir for paths:

    FSPath.common_dir('/a/b/c/d/e/f', '/a/b/c/1/hello', '/a/b/c/2/world') # => FSPath('/a/b/c')

Temp file (args are passed to `Tempfile.new`):

    FSPath.temp_file{ |f| …; p f.path; … }

    f = FSPath.temp_file
    …
    f.close

Temp file path (args are passed to `Tempfile.new`):

    FSPath.temp_file_path{ |path| …; p path; … }

    path = FSPath.temp_file_path
    …
    # file will be removed on next GC run if reference to path is lost

Temp directory (args are passed to `Dir.mktmpdir`):

    FSPath.temp_dir{ |dir| …; p dir; …  }

    dir = FSPath.temp_dir
    …
    # the dir is not removed when temp_dir is run without block

Join paths:

    FSPath('a') / 'b' / 'c' # => FSPath('a/b/c')

Read/write:

    FSPath('a.txt').read
    FSPath('b.bin').binread
    FSPath('a.txt').write(text)
    FSPath('b.bin').binwrite(data)
    FSPath('a.txt').append(more_text)
    FSPath('b.bin').binappend(more_data)

Escape glob:

    FSPath('trash?/stuff [a,b,c]').escape_glob # => FSPath('trash\?/stuff \[a,b,c\]')

Expand glob:

    FSPath('trash').glob('**', '*')

Ascendants:

    FSPath('a/b/c').ascendants
    FSPath('a/b/c').ascend # => [FSPath('a/b/c'), FSPath('a/b'), FSPath('a')]

Descendants:

    FSPath('a/b/c').descendants
    FSPath('a/b/c').descend # => [FSPath('a'), FSPath('a/b'), FSPath('a/b/c')]

Path parts:

    FSPath('/a/b/c').parts # => ['/', 'a', 'b', 'c']

Basename and extension:

    FSPath('some/dir/name.ext').prefix_suffix # => [FSPath('name'), '.ext']

## Copyright

Copyright (c) 2010-2019 Ivan Kuchin. See LICENSE.txt for details.
