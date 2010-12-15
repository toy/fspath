# fspath

Better than Pathname

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

### Extended attributes (using xattr gem)

Get extended attribute:

    FSPath('/a/b/c').xattr['com.macromates.caret']

Set extended attribute:

    FSPath('/a/b/c').xattr['good'] = 'bad'

### OS X stuff

Move to trash:

    FSPath('a').move_to_trash

Get finder label (one of :none, :orange, :red, :yellow, :blue, :purple, :green and :gray):

    FSPath('a').finder_label

Set finder label (:grey is same as :gray, nil or false as :none):

    FSPath('a').finder_label = :red

Get spotlight comment:

    FSPath('a').spotlight_comment

Set spotlight comment:

    FSPath('a').spotlight_comment = 'a file'

## Copyright

Copyright (c) 2010 Ivan Kuchin. See LICENSE.txt for details.
