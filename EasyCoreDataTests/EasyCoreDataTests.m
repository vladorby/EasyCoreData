//
//  EasyCoreDataTests.m
//  EasyCoreDataTests
//
//  Created by mti on 4/4/13.
//  Copyright (c) 2013 vlad orby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CoreDataEntity.h"

@interface EasyCoreDataTests : XCTestCase
{
    CoreDataEntity *coreDataEntity;
}

@end

@implementation EasyCoreDataTests


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)setUp {
    [super setUp];
    
    [CoreDataEntity deleteAll];
    coreDataEntity = [CoreDataEntity new];
    coreDataEntity.title = @"Title";
}

- (void)saving {
    XCTAssert([coreDataEntity saveData], @"");
    XCTAssert([[CoreDataEntity all] count] == 1, @"");
    XCTAssert([[CoreDataEntity count] intValue] == 1, @"");
    
    coreDataEntity = [CoreDataEntity new];
    XCTAssertFalse([coreDataEntity saveData], @"");
}

- (void)attributes {
    [coreDataEntity saveData];
    CoreDataEntity *fetchedCoreDataEntity = [[CoreDataEntity all] objectAtIndex:0];
    XCTAssert([fetchedCoreDataEntity.title isEqualToString:@"Title"], @"");
}

- (void)searching {
    [coreDataEntity saveData];
    
    NSMutableArray *coreDataEntitys;
    coreDataEntitys = [CoreDataEntity search:@"name = '%@'", @"Title"];
    XCTAssert([coreDataEntitys count] == 1, @"");
    
    coreDataEntitys = [CoreDataEntity search:@"name = '%@'", @"Name"];
    XCTAssert([coreDataEntitys count] == 0, @"");
    
    XCTAssertEqualObjects(coreDataEntity, [CoreDataEntity search:@"name = 'Title'"], @"");
    XCTAssertNil([CoreDataEntity search:@"name = 'Description'"], @"");
}

- (void)ordering {
    [coreDataEntity saveData];
    CoreDataEntity *otherCoreDataEntity = [CoreDataEntity new];
    otherCoreDataEntity.title = @"Name"; [otherCoreDataEntity saveData];
    
    NSMutableArray *coreDataEntitys;
    coreDataEntitys = [CoreDataEntity searchByEnumeration:@"title"];
    XCTAssertEqualObjects(otherCoreDataEntity, [coreDataEntitys objectAtIndex:0], @"");
    XCTAssertEqualObjects(coreDataEntity, [coreDataEntitys objectAtIndex:1], @"");
    
    coreDataEntitys = [CoreDataEntity searchByEnumeration:@"title desc"];
    XCTAssertEqualObjects(coreDataEntity, [coreDataEntitys objectAtIndex:0], @"");
    XCTAssertEqualObjects(otherCoreDataEntity, [coreDataEntitys objectAtIndex:1], @"");
    
    XCTAssertEqualObjects(otherCoreDataEntity, [CoreDataEntity searchByEnumeration:@"title"], @"");
    XCTAssertEqualObjects(coreDataEntity, [CoreDataEntity searchByEnumeration:@"title desc"], @"");
}

- (void)enumerating {
    [CoreDataEntity deleteAll];
    XCTAssertEqualObjects(@(0), [CoreDataEntity count], @"");
    coreDataEntity = [CoreDataEntity new];
    coreDataEntity.title = @"Title"; [coreDataEntity saveData];
    XCTAssertEqualObjects(@(1), [CoreDataEntity count], @"");
    CoreDataEntity *otherCoreDataEntity = [CoreDataEntity new];
    otherCoreDataEntity.title= @"Name"; [otherCoreDataEntity saveData];
    XCTAssertEqualObjects(@(2), [CoreDataEntity count], @"");
   XCTAssertEqualObjects(@(1), [CoreDataEntity count:@"title = 'Name'"], @"");
}

- (void)destroying {
    [coreDataEntity saveData];
   XCTAssertEqualObjects(@(1), [CoreDataEntity count], @"");
    XCTAssert([coreDataEntity destroyData], @"");
    XCTAssertEqualObjects(@(0), [CoreDataEntity count], @"");
}

- (void)date {
    NSDate *minusOne = [NSDate dateWithTimeIntervalSinceNow:-24*pow(60,2)];
    NSDate *minusTwo = [NSDate dateWithTimeIntervalSinceNow:-24*pow(60,2)];
    
    [CoreDataEntity deleteAll];
    coreDataEntity = [CoreDataEntity new];
    coreDataEntity.title = @"Title";
    coreDataEntity.dateStamp = minusOne;
    CoreDataEntity *otherCoreDataEntity = [CoreDataEntity new];
    otherCoreDataEntity.title= @"Description";
    otherCoreDataEntity.dateStamp = minusTwo;
    
    [coreDataEntity saveData]; [otherCoreDataEntity saveData];
    
    NSMutableArray *coreDataEntitys;
    coreDataEntitys = [CoreDataEntity search:@"dateStamp > %@", minusOne];
    XCTAssert([coreDataEntitys count] == 0, @"");
    coreDataEntitys = [CoreDataEntity search:@"dateStamp > %@", minusTwo];
    XCTAssert(1 == [coreDataEntitys count], @"");
}

- (void)initWithDictionary {
    [CoreDataEntity deleteAll];
    
    coreDataEntity = [CoreDataEntity new:[NSDictionary dictionaryWithObjectsAndKeys:@"Title", @"title", nil]];
    XCTAssert([coreDataEntity.title isEqualToString:@"Title"], @"title is %@", coreDataEntity.title);
}

- (void)idX {
    [coreDataEntity saveData];
    NSString *path = [[[coreDataEntity objectID] URIRepresentation] path];
    NSArray *components = [path componentsSeparatedByString:@"/"];
    XCTAssert([[components objectAtIndex:[components count]-1] isEqualToString:@"p1"], @"");
    XCTAssert([coreDataEntity persistenceID] == 1, @"id is %i", [coreDataEntity persistenceID]);
}

- (void)keyValuesearching {
    NSDate *minusOne = [NSDate dateWithTimeIntervalSinceNow:-24*pow(60,2)];
    NSDate *minusTwo = [NSDate dateWithTimeIntervalSinceNow:-24*pow(60,2)];
    
    [CoreDataEntity deleteAll];
    coreDataEntity = [CoreDataEntity new];
    coreDataEntity.title = @"Title";
    coreDataEntity.dateStamp = minusOne;
    CoreDataEntity *otherCoreDataEntity = [CoreDataEntity new];
    otherCoreDataEntity.title = @"Description";
    otherCoreDataEntity.dateStamp = minusTwo;
    
    [coreDataEntity saveData]; [otherCoreDataEntity saveData];
    
    coreDataEntity = [[CoreDataEntity searchByKey:@"title" withValue:@"Title"] objectAtIndex:0];
    XCTAssert([coreDataEntity.title isEqualToString:@"Title"], @"");
    XCTAssertEqualObjects(coreDataEntity.dateStamp, minusOne, @"");
    
    coreDataEntity = [[CoreDataEntity searchByKey:@"dateStamp" withValue:minusTwo] objectAtIndex:0];
    XCTAssert([coreDataEntity.title isEqualToString:@"Name"], @"");
    XCTAssertEqualObjects(coreDataEntity.dateStamp, minusTwo, @"");
    
    coreDataEntity = [CoreDataEntity searchByKey:@"dateStamp" withValue:minusOne];
    XCTAssert([coreDataEntity.title isEqualToString:@"Title"], @"");
    XCTAssertEqualObjects(coreDataEntity.dateStamp, minusOne, @"");
}




//
@end
