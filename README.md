NSTree
======

B-Tree data structure implementation for iOS without using CFTree. 
Keywords: iOS, tree, algorithms, data structures, b-trees, unit tests.

## Features
 - Customizable Node Capacity (max # children per node).
 - Binary Search within Nodes for faster data search.
 - Flexible traversal function to iterate through tree contents while executing
   user-defined block on each element.
 - Multiple traversal algorithms: inorder, preorder, postorder, breadth first.
 - Fast Enumeration implementation so you can "for (id obj in tree)".
 - Easy way to print out tree representations for debugging.
 - Maintains cache of data in an NSArray for quick lookups using objectAtIndex.

### License
MIT

