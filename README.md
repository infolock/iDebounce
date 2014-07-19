iDebounce
=========

One method I love that [underscorejs](http://underscorejs.org) provides is [_.debounce()](http://underscorejs.org/debounce).  Just recently, I needed the same functionality in an iOS project, so enter `iDebounce`.

iDebounce is useful when you need to control how often a method is called in x amount of time.  A good example of this would be when working with data that is being displayed within a UICollectionView.  If you happen to use an NSFetchedResultsController to manage this, then a convienence you get is that the CollectionView is updated as your model changes.

However, if your model changes too frequently before the NSFetchedController is able to finish preparing and displaying your data, then you can run into issues where your app terminates due to an index out of bounds error.

In this instance, it would be cool if we could intervene and have our method (that's updating our model) only be called one every x seconds ( rather than 20 times within a single second ).

Debouncing to the rescue!  A 10,000 foot view is that, when you debounce a method, you are saying "I'm going to pass a method to you ( iDebounce debounce ) that I want to have executed - but I _only_ want to allow it to be executed __once__ every __wait__ amount of seconds.

## Method Signature Information

Here is a brief summary of the params of `debounce`:

_@param_ (`iDebounceBlock`) `iDebounceBlock`  This is the completion block that should be debounced.

_@param_ (`NSString *`) `identifier`  This `identifier` is used by `iDebounce` to track that a given `iDebounceBlock` has been registered for execution

_@param_ (`NSTimeInterval`) `seconds`  The number of seconds that must pass by before the next `iDebounceBlock` can be registered and executed.


#### Basic Usage:

```objc

[iDebounce debounce:( ^{
    // The code you want to have debounced here
} idetnfier:@"Some Identifier" wait:0.3];

```

## Real World(ish) Example

```objc
// Only showing the .m as this is the only thing that really matters here...

#import "iDebounce.h"

// Assume this is a method that gets called multiple times - and is out of your control ( like required delegate method )
-(void)someReoccurringMethod:(NSArray *)withSomeData {

    __weak typeof( self ) weakSelf = self;
    __block NSArray *dataCopy = [withSomeData copy];

    [iDebounce debounce:^{
        // Using the main queue here as we are representing a method that will interact with Core Data...
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleData:dataCopy];
        });

    } withIdentifier:@"Some Unique Name for our handleData - this is just for reference within the iDebounceBlockMap" wait:2.0];

}


-(void)handleData:(NSArray *)withSomeData {
  // Safely handle your core data model(s) here
  
    NSLog( @"handleData was called!" );
}

```


## Seeing the difference

To see the difference, try to create a simple while loop that loops say 30 times.  To test what happens without using iDebounce, just comment out the iDebounce usage above, and simply call `[self handleData:withSomeData]` - and notice that it will get called 30 times.  I'm sure there are more clever ways of showing the point here, but this is good enough.


Now, comment out the above and use the code in the example above ( which uses iDebounce ).  Set the wait to be like 0.1 or something, and notice how each time you increment it that our handleData method is gradually called less.



