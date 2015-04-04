//
//  CoreDataEntity.h
//  EasyCoreData
//
//  Created by mti on 4/4/13.
//  Copyright (c) 2013 vlad orby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EasyCoreDataFramework.h"


@interface CoreDataEntity : EasyCoreData

@property (nonatomic, retain) NSDate   * dateStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * keyString;

@end
