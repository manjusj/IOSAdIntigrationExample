//
//  ViewController.h
//  IAdIntigration
//
//  Created by Manju Sj on 5/12/16.
//  Copyright (c) 2016 Manju Sj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AddressBook/AddressBook.h>
NSString *const kDenied = @"Access to address book is denied";
NSString *const kRestricted = @"Access to address book is restricted";

@interface ViewController : UIViewController<ADBannerViewDelegate>
@property(nonatomic,strong)  ADBannerView *bannerView;
@property  ABAddressBookRef addressBook;

@end

