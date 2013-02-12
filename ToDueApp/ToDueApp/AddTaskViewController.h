//
//  AddTaskViewController.h
//  ToDueApp
//
//  Created by Jacob Ulrich on 1/30/13.
//  Copyright (c) 2013 Jacob Ulrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskNameInput;


@property (strong, nonatomic) NSString *task;


@end
