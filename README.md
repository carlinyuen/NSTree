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

## Benchmarks
On par with Core Data and generic NSArray for performance in terms of insertion,
search, and deletion (note that we are requiring sorted order), especially when
in the higher order of number of elements (>10,000). 

When with fewer than 100 elements, insertion into the NSTree is marginally slower 
than Core Data. When using over 1,000,000 elements, the NSTree performs very well 
compared to Core Data. 

Unit tests are available to see the details of testing the creation / load time
of the various data structures from empty, as well as insertion / deletion
/ search within preloaded data structures.

### License
MIT

