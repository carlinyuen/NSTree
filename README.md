NSTree
======

B-Tree data structure implementation for iOS / objective-c without using CFTree. Can be used as a storage mechanism or to index large sets of data. Performs fairly well compared to Core Data and regular NSArrays.
Keywords: iOS, tree, algorithms, data structures, binary, b-trees, core data, storage, unit tests, benchmarks.

Note: working on a database layer that uses the NSTree; feel free to check it out and contribute to it here: [NSTreeDatabase](https://github.com/carlinyuen/NSTreeDatabase).

## Features
 - Customizable Node Capacity (max # children per node).
 - Binary Search within Nodes for faster data search.
 - Flexible traversal function to iterate through tree contents while executing
   user-defined block on each element.
 - Multiple traversal algorithms: inorder, preorder, postorder, breadth first.
 - Fast Enumeration implementation so you can "for (id obj in tree)".
 - Easy way to print out tree representations for debugging.
 - Maintains cache of data in an NSArray for quick lookups using objectAtIndex.

## TODO
 - Build in some file management for persistent storage.
 - Add features to make tree more practical as a storage system.

## Interesting Things I Learned
 - Core Data is super slow when using in-memory store, use SQLite store instead
   (strangely enough, the sqlite version is still slow in the LoadBenchmarks).
 - Significant performance boost when using bulk methods on NSArray and NSDict
   for adding & removal.
 - Tree node capacity to total number of elements ratio is important to performance.
   So far, with limited testing, keeping it on the order of 1:1000 seems ok?

## Benchmarks
On par with Core Data and generic NSArray for performance in terms of insertion,
search, and deletion (note that we are requiring sorted order), especially when
in the higher order of number of elements (>10,000). 

When with fewer than 100 elements, insertion into the NSTree is marginally slower 
than Core Data. When using over 1,000,000 elements, the NSTree performs very well 
compared to Core Data. 

Unit tests are available to see the details of testing the creation / load time
of the various data structures from empty, as well as insertion / deletion
/ search within preloaded data structures. Sample output:

	2013-12-20 06:27:26.667 NSTreeExample[64628:a0b] Application windows are expected to have a root view controller at the end of application launch
	Test Suite 'All tests' started at 2013-12-20 11:27:26 +0000
	Test Suite 'NSTreeExampleFunctionBenchmarks.xctest' started at 2013-12-20 11:27:26 +0000
	2013-12-20 06:27:26.725 NSTreeExample[64628:a0b] # to Search / Delete / Insert: 100
	2013-12-20 06:27:26.727 NSTreeExample[64628:a0b] Creating Trees
	2013-12-20 06:27:26.732 NSTreeExample[64628:a0b] Tree3 Count: 1000
	2013-12-20 06:27:26.733 NSTreeExample[64628:a0b] Tree30 Count: 1000
	2013-12-20 06:27:26.734 NSTreeExample[64628:a0b] Tree300 Count: 1000
	2013-12-20 06:27:26.735 NSTreeExample[64628:a0b] Creating Array
	2013-12-20 06:27:26.735 NSTreeExample[64628:a0b] Array Count: 1000
	2013-12-20 06:27:26.736 NSTreeExample[64628:a0b] Creating Dict
	2013-12-20 06:27:26.744 NSTreeExample[64628:a0b] Dict Count: 1000
	2013-12-20 06:27:26.745 NSTreeExample[64628:a0b] Creating Core Data
	2013-12-20 06:27:26.855 NSTreeExample[64628:a0b] Core Data Entry Count: 1000
	2013-12-20 06:27:26.856 NSTreeExample[64628:a0b] Setup Time Completion: 0.130921
	Test Suite 'NSTreeExampleFunctionBenchmarks' started at 2013-12-20 11:27:26 +0000
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteArray]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteArray]' passed (0.016 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteArrayBulk]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteArrayBulk]' passed (0.000 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteCoreData]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteCoreData]' passed (0.039 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteCoreDataBulk]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteCoreDataBulk]' passed (0.007 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteDict]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteDict]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteDictBulk]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteDictBulk]' passed (0.000 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree3]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree3]' passed (0.002 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree30]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree30]' passed (0.002 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree300]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testDeleteTree300]' passed (0.013 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertArray]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertArray]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertCoreData]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertCoreData]' passed (0.005 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertDict]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertDict]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree3]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree3]' passed (0.005 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree30]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree30]' passed (0.002 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree300]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testInsertTree300]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchArray]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchArray]' passed (0.008 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchCoreData]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchCoreData]' passed (0.026 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchCoreDataBulk]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchCoreDataBulk]' passed (0.006 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchDict]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchDict]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree3]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree3]' passed (0.002 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree30]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree30]' passed (0.001 seconds).
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree300]' started.
	Test Case '-[NSTreeExampleFunctionBenchmarks testSearchTree300]' passed (0.001 seconds).
	Test Suite 'NSTreeExampleFunctionBenchmarks' finished at 2013-12-20 11:27:27 +0000.
	Executed 22 tests, with 0 failures (0 unexpected) in 0.140 (0.155) seconds
	2013-12-20 06:27:27.013 NSTreeExample[64628:a0b] Successful cleanup of Core Data Store
	Test Suite 'NSTreeExampleFunctionBenchmarks.Program ended with exit code: 0

### License
MIT

