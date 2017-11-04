This is a mirror of http://www.vim.org/scripts/script.php?script_id=474

Call me lazy but I wanted to be able to tab-complete words while typing in a search and I have always been up to a challange.  After learning a lot more about vim and key mapping then I ever knew before, this is the result, working tab completion inside a search.

## Some Fix

1. Only bind / in normal mode

2. Also support complete in backward search (?)


### emersonrp change:

Explicitly map &lt;Up&gt; and &lt;Down&gt; so they work inside search mode to walk up and
down the search history.
