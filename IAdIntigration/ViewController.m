//
//  ViewController.m
//  IAdIntigration
//
//  Created by Manju Sj on 5/12/16.
//  Copyright (c) 2016 Manju Sj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize bannerView,addressBook;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    bannerView = [[ADBannerView alloc]initWithFrame:
                  CGRectMake(0, 0, 320, 50)];
    // Optional to set background color to clear color
    [bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: bannerView];
    
    CFErrorRef error = NULL;
    switch (ABAddressBookGetAuthorizationStatus()){
        case kABAuthorizationStatusAuthorized:{
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            /* Do your work and once you are finished ... */
            if (addressBook != NULL){
                CFRelease(addressBook);
            }
            break;
        }
        case kABAuthorizationStatusDenied:{
            //[self displayMessage:kDenied];
            break;
        }
        case kABAuthorizationStatusNotDetermined:{
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion
            (addressBook, ^(bool granted, CFErrorRef error) {
                if (granted){
                    NSLog(@"Access was granted");
                    [self useAddressBook:addressBook];
                    [self readFromAddressBook:addressBook];
                } else {
                    NSLog(@"Access was not granted");
                }
                if (addressBook != NULL){
                    CFRelease(addressBook);
                }
            });
            break;
        }
        case kABAuthorizationStatusRestricted:{
           // [self displayMessage:kRestricted];
            break;
        }
    }
}
- (void) useAddressBook:(ABAddressBookRef)paramAddressBook{
    /* Work with the address book here */
    /* Let's see whether we have made any changes to the
     address book or not, before attempting to save it */
    if (ABAddressBookHasUnsavedChanges(paramAddressBook)){
        /* Now decide if you want to save the changes to
         the address book */
        NSLog(@"Changes were found in the address book.");
        BOOL doYouWantToSaveChanges = YES;
        /* We can make a decision to save or revert the
         address book back to how it was before */
        if (doYouWantToSaveChanges){
            CFErrorRef saveError = NULL;
            if (ABAddressBookSave(paramAddressBook, &saveError)){
                /* We successfully saved our changes to the
                 address book */
            } else {
                /* We failed to save the changes. You can now
                 access the [saveError] variable to find out
                 what the error is */
            }
        } else {
            /* We did NOT want to save the changes to the address
             book so let's revert it to how it was before */
            ABAddressBookRevert(paramAddressBook);
        }
    } else {
        /* We have not made any changes to the address book */
        NSLog(@"No changes to the address book.");
    }
}

- (void) readFromAddressBook:(ABAddressBookRef)paramAddressBook{
    NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *)
    ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    NSUInteger peopleCounter = 0;
    for (peopleCounter = 0;
         peopleCounter < [arrayOfAllPeople count];
         peopleCounter++){
        ABRecordRef thisPerson =
        (__bridge ABRecordRef)
        [arrayOfAllPeople objectAtIndex:peopleCounter];
        NSString *firstName = (__bridge_transfer NSString *)
        ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)
        ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);
        NSString *email = (__bridge_transfer NSString *)
        ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
        NSLog(@"First Name = %@", firstName);
        NSLog(@"Last Name = %@", lastName);
        NSLog(@"Address = %@", email);
        /* Use the [thisPerson] address book record */
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AdViewDelegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}
@end
