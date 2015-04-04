# EasyCoreData
CoreData wrapper eliminating most of unnecessary verbose
 
# What for?

ObjC CoreData verbose is too much to bear. There must have been a better way.

# Installation

 
run git clone git://github.com/vladorby/EasyCoreData.git
 
Usage

 
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  
  [EasyCoreData setContext:self.managedObjectContext];
 
}

Call framework methods on instances subclassed with EasyCoreData  
 

See the test for typical use scenarios


License

See the LICENSE.

