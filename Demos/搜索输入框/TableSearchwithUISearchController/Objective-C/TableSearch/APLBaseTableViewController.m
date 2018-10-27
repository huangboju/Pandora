/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base or common view controller to share a common UITableViewCell prototype between subclasses.
 */

#import "APLBaseTableViewController.h"
#import "APLProduct.h"

NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"TableCell";

@implementation APLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // We use a nib which contains the cell's view and this class as the files owner.
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil]
		 forCellReuseIdentifier:kCellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell forProduct:(APLProduct *)product {
    cell.textLabel.text = product.title;
    
    // Build the price and year string.
    // Use NSNumberFormatter to get the currency format out of this NSNumber (product.introPrice).
    //
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *priceString = [numberFormatter stringFromNumber:product.introPrice];
    
    NSString *detailedStr =
		[NSString stringWithFormat:@"%@ | %@", priceString, (product.yearIntroduced).stringValue];
    cell.detailTextLabel.text = detailedStr;
}

@end
