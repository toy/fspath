# fspath

Better than Pathname

Check out [fspath-mac](https://rubygems.org/gems/fspath-mac) and [fspath-xattr](https://rubygems.org/gems/fspath-xattr).

[![Build Status](https://travis-ci.org/toy/fspath.png?branch=master)](https://travis-ci.org/toy/fspath)

## Synopsis

User dir:

    FSPath.~

Other user dir:

    FSPath.~('other')

Common dir for paths:

    FSPath.common_dir('/a/b/c/d/e/f', '/a/b/c/1/hello', '/a/b/c/2/world') # => FSPath('/a/b/c')

Join paths:

    FSPath('a') / 'b' / 'c' # => FSPath('a/b/c')

Write data:

    FSPath('a').write('data')

Append data:

    FSPath('a').append('data')

Escape glob:

    FSPath('trash?/stuff [a,b,c]').escape_glob # => FSPath('trash\?/stuff \[a,b,c\]')

Expand glob:

    FSPath('trash').glob('**', '*')

Ascendants:

    FSPath('a/b/c').ascend # => [FSPath('a/b/c'), FSPath('a/b'), FSPath('a')]

Descendants:

    FSPath('a/b/c').descend # => [FSPath('a'), FSPath('a/b'), FSPath('a/b/c')]

Path parts:

    FSPath('/a/b/c').parts # => ['/', 'a', 'b', 'c']

## Copyright

Copyright (c) 2010-2013 Ivan Kuchin. See LICENSE.txt for details.
