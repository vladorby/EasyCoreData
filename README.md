# EasyCoreData
CoreData wrapper eliminating most of unnecessary verbose
 
# What for?

ObjC CoreData verbose is too much to bear. There must have been a better way.

# Installation

 
run git clone git://github.com/vladorby/EasyCoreData.git
 
Usage

 
1. - (void)applicationDidFinishLaunching:(UIApplication *)application {
  
  [EasyCoreData setContext:self.managedObjectContext];
 
}
2. use framework methods directly on objects subclassed with EasyCoreData  
 

See the test for typical use scenarios

 

License

See the LICENSE.

