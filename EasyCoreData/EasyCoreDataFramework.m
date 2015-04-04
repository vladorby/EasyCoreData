//
//  CoreDataEntity.m
//  EasyCoreData
//
//  Created by mti on 4/4/13.
//  Copyright (c) 2013 vlad orby. All rights reserved.
//
#import "EasyCoreDataFramework.h"

static NSManagedObjectContext *EasyCoreDataContext = nil;

@interface EasyCoreData (private)
+ (NSMutableArray *)_searchResults:(NSFetchRequest *)request;
+ (NSNumber *)_countResults:(NSFetchRequest *)request;
+ (NSArray *)_sortDescriptorsFromsorted:(NSString *)sorted;
@end

@implementation EasyCoreData

+ (void)setContext:(NSManagedObjectContext *)newContext {
  EasyCoreDataContext = newContext;
}
+ (NSManagedObjectContext *)context {
  return EasyCoreDataContext;
}
- (NSManagedObjectContext *)context {
  return [self.class context];
}


+ (NSString *)name {
  return [NSString stringWithCString:object_getClassName(self) encoding:NSUTF8StringEncoding];
}

+ (id)new {
  NSEntityDescription *description = [NSEntityDescription entityForName:[self name] inManagedObjectContext:[self context]];
  return [[self alloc] initWithEntity:description insertIntoManagedObjectContext:[self context]];
}

+ (id)new:(NSDictionary *)dictionary {
  id instance = [self new];
  NSString *propertyName;
  for (propertyName in dictionary) {
    [instance setValue:[dictionary objectForKey:propertyName] forKey:propertyName];
  }
  return instance;
}

+ (NSFetchRequest *)fetchRequestByEnumeration:(NSString *)sorted queryString:(NSString* )queryString, ... {
  NSFetchRequest *request = [self defaultFetchRequest];
  if ([sorted length] > 0) [request setSortDescriptors:[self _sortDescriptorsFromsorted:sorted]];
  
  if ([queryString length] > 0) {
    va_list argumentList;
    va_start(argumentList, queryString);
    NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
    [request setPredicate:[NSPredicate predicateWithFormat:sqlString]];
  }
  
  return request;
}

+ (NSFetchRequest *)fetchRequestByEnumeration:(NSString *)sorted {
  return [self fetchRequestByEnumeration:sorted queryString:@""];
}

+ (NSFetchRequest *)fetchRequest:(NSString* )queryString, ... {
  va_list argumentList;
  va_start(argumentList, queryString);
  NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  return [self fetchRequestByEnumeration:@"" queryString:sqlString];
}

+ (NSFetchRequest *)defaultFetchRequest {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:[self name] inManagedObjectContext:[self context]];
  [request setEntity:entity];
  return request;
}


+ (NSMutableArray *)searchByEnumeration:(NSString *)sorted queryString:(NSString *)queryString, ... {
  va_list argumentList;
	va_start(argumentList, queryString);
	NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  
  return [self _searchResults:[self fetchRequestByEnumeration:sorted queryString:sqlString]];
}

+ (NSMutableArray *)searchByEnumeration:(NSString *)sorted {
  return [self _searchResults:[self fetchRequestByEnumeration:sorted]];
}

+ (NSMutableArray *)search:(NSString *)queryString, ... {
  va_list argumentList;
	va_start(argumentList, queryString);
	NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  
  return [self _searchResults:[self fetchRequest:sqlString]];
}

+ (NSMutableArray *)searchByKey:(NSString *)key withValue:(id)value {
  NSString *sqlString;
  if ([value isKindOfClass:[NSDate class]]) sqlString = [NSString stringWithFormat:@"%@ = %@", key, value];
  else sqlString = [NSString stringWithFormat:@"%@ = '%@'", key, value];
  NSLog(@"sql = %@", sqlString);
  return [self search:sqlString];
}

+ (NSMutableArray *)all {
  return [self _searchResults:[self defaultFetchRequest]];
}


+ (id)searchOrderedByEnumeration:(NSString *)sorted queryString:(NSString *)queryString, ... {
  va_list argumentList;
	va_start(argumentList, queryString);
	NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  
  NSMutableArray *objects = [self searchByEnumeration:sorted queryString:sqlString];
  if ([objects count] > 0) return [objects objectAtIndex:0];
	else return  nil;
}

+ (id)searchOrderedByEnumeration:(NSString *)sorted {
  return [self searchByEnumeration:sorted queryString:@""];
}

+ (id)searchOrdered:(NSString *)queryString, ... {
  va_list argumentList;
	va_start(argumentList, queryString);
	NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  
  NSMutableArray *objects = [self search:sqlString];
  if ([objects count] > 0) return [objects objectAtIndex:0];
	else return  nil;
}

+ (id)searchOrderedByKey:(NSString *)key withValue:(id)value {
  NSArray *objects = [self searchByKey:key withValue:value];
  if ([objects count] > 0) return [objects objectAtIndex:0];
	else return  nil;
}

+ (id)search {
  NSMutableArray *objects = [self all];
  if ([objects count] > 0) return [objects objectAtIndex:0];
	else return  nil;
}

+ (id)searchByID:(NSManagedObjectID *)objectID {
  return [[self context] objectRegisteredForID:objectID];
}


+ (NSNumber *)count:(NSString *)queryString, ... {
  va_list argumentList;
	va_start(argumentList, queryString);
	NSString *sqlString = [[NSString alloc] initWithFormat:queryString arguments:argumentList];
  return [self _countResults:[self fetchRequest:sqlString]];
}

+ (NSNumber *)count {
  return [self _countResults:[self defaultFetchRequest]];
}



+ (void)deleteAll {
  for (id object in self.all) [self.context deleteObject:object];
  
  NSError *error = nil;
  if (![[self context] save:&error]) {
    
  }
}


+ (NSMutableArray *)_searchResults:(NSFetchRequest *)request {
  NSError *error = nil;
  NSMutableArray *mutableFetchResults = [[[self context] executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) {

  }
  
  
  return mutableFetchResults;
}

+ (NSNumber *)_countResults:(NSFetchRequest *)request {
  NSError *error = nil;
  int number = (int)[[self context] countForFetchRequest:request error:&error];
  return [NSNumber numberWithInt:number];
}

+ (NSArray *)_sortDescriptorsFromsorted:(NSString *)sorted {
  NSArray *orderComponents = [sorted componentsSeparatedByString:@" "];
  NSString *order = [orderComponents objectAtIndex:0];
  
  BOOL ascending = YES;
  if ([orderComponents count] > 1) {
    NSString *direction = [orderComponents objectAtIndex:1];
    if ([direction isEqualToString:@"desc"]) ascending = NO;
  }
  
  NSArray *result = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:order ascending:ascending]];
 
  return result;
}

- (BOOL)saveData {
  NSError *error = nil;
  BOOL success = YES;
  
  if (![[self context] save:&error]) {
    NSLog(@" Error : %@", error);
    success = NO;
  }
  
  [[self context] refreshObject:self mergeChanges:NO];
  
  return success;
}

- (BOOL)destroyData {
  NSError *error = nil;
  BOOL success = YES;
  NSManagedObjectContext *context = [self context];
  
  [context deleteObject:self];
  if (![context save:&error]) {
    NSLog(@"Error : %@", error);
    success = NO;
  }
  
  return success;
}

- (int)persistenceID {
  NSArray *components = [[[[self objectID] URIRepresentation] path] componentsSeparatedByString:@"/"];
  NSCharacterSet *charSet = [NSCharacterSet decimalDigitCharacterSet];
  NSScanner *scanner = [NSScanner scannerWithString:[components objectAtIndex:[components count]-1]];
  [scanner scanUpToCharactersFromSet:charSet intoString:nil];
  int pID;
  [scanner scanInt:&pID];
  return pID;
}
@end
