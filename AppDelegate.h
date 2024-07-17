//
//  AppDelegate.h
//  k10SetupInputAudio
//
//  Created by macbook on 2024-07-16.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

