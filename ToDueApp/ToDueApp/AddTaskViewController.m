//
//  AddTaskViewController.m
//  ToDueApp
//
//  Created by Jacob Ulrich on 1/30/13.
//  Copyright (c) 2013 Jacob Ulrich. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.taskNameInput) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        self.task = self.taskNameInput.text;
    }
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

@end