# PWInfiniteScroll
Simple Infinite UICollectionView Paging!

It might seem like second nature to consult all the various "infinite uicollectionview" resources out there on google, but the answer to
this problem is pretty simple (as long as we are using paging and cell sizes that take up the entire width of the screen).  
All we have to do is create a copy of the first and last elements of our array.  Then we append the first element to the array
and insert the last element to the front of the array.

We can now use these two "fake" elements as "auto scroll markers".  Meaning when we hit a contentOffset.x of zero or collectionView.contentView.frame.width - pageWidth,
we can autoscroll the user to the "real" version of the first or last element.  With no animation this is very seemless.

# Diagram Support
![Diagram Support](https://raw.githubusercontent.com/pmwiseman/PWInfiniteScroll/master/PWInfiniteCollectionView/Assets.xcassets/Infinite_Paging_UICollectionView.imageset/Infinite_Paging_UICollectionView.png)
