//
//  CoreDataEntity.m
//  EasyCoreData
//
//  Created by mti on 4/4/13.
//  Copyright (c) 2013 vlad orby. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface EasyCoreData : NSManagedObject

- (BOOL)saveData;
- (BOOL)destroyData;
- (int)persistenceID;

+ (void)setContext:(NSManagedObjectContext *)newContext;
+ (NSManagedObjectContext *)context;
- (NSManagedObjectContext *)context;



+ (NSMutableArray *)searchByEnumeration:(NSString *)sorted queryString:(NSString *)queryString, ...;
+ (NSMutableArray *)searchByEnumeration:(NSString *)sorted;
+ (NSMutableArray *)search:(NSString *)queryString, ...;
+ (NSMutableArray *)searchByKey:(NSString *)key withValue:(id)value;
+ (NSMutableArray *)all;

+ (NSString *)name;
+ (NSFetchRequest *)fetchRequestByEnumeration:(NSString *)sorted queryString:(NSString* )queryString, ...;
+ (NSFetchRequest *)fetchRequestByEnumeration:(NSString *)sorted;
+ (NSFetchRequest *)fetchRequest:(NSString* )queryString, ...;
+ (NSFetchRequest *)defaultFetchRequest;


+ (id)searchOrderedByEnumeration:(NSString *)sorted queryString:(NSString *)queryString, ...;
+ (id)searchOrderedByEnumeration:(NSString *)sorted;
+ (id)searchOrdered:(NSString *)queryString, ...;
+ (id)searchOrderedByKey:(NSString *)key withValue:(id)value;
+ (id)searchOrdered;
+ (id)searchByID:(NSManagedObjectID *)objectID;


+ (NSNumber *)count:(NSString *)queryString, ...;
+ (NSNumber *)count;

+ (void)deleteAll;

+ (id)new;
+(id)new:(NSDictionary *)dictionary;



@end


