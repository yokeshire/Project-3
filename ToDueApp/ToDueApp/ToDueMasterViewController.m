//
//  ToDueMasterViewController.m
//  ToDueApp
//
//  Created by Jacob Ulrich on 1/30/13.
//  Copyright (c) 2013 Jacob Ulrich. All rights reserved.
//

#import "ToDueMasterViewController.h"

#import "AddTaskViewController.h"

@interface ToDueMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation ToDueMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    
    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        _objects = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertNewTask:(NSString *)myTaskName
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects count] inSection:0];
    NSMutableDictionary *myTask = [[NSMutableDictionary alloc] initWithObjectsAndKeys:myTaskName,@"Name",@"NO",@"Done",nil];
    [_objects insertObject:myTask atIndex:[_objects count]];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *object = _objects[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"Name"];
    if ([[object objectForKey:@"Done"] isEqualToString:@"NO"]) {
        cell.textLabel.textColor = [UIColor blackColor];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[object objectForKey:@"Name"]];
        cell.textLabel.attributedText = attrText;
        
        
    }
    else if ([[object objectForKey:@"Done"] isEqualToString:@"YES"])
    {
        cell.textLabel.textColor = [UIColor redColor];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        //borrowed from http://stackoverflow.com/questions/2489530/strike-through-font-in-objective-c
        NSDictionary* attributes = @{
    NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
        };
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[object objectForKey:@"Name"] attributes:attributes];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}

- (IBAction)changeCheck:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *myCell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    myCell.textLabel.textColor = [UIColor redColor];
    
    
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        AddTaskViewController *addController = [segue sourceViewController];
        if(addController.task)
        {
            [self insertNewTask:addController.task];
            
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelInput"])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *item = _objects[indexPath.row];
    
    if([[item objectForKey:@"Done"] isEqualToString:@"NO"])
    {
        [item setValue:@"YES" forKey:@"Done"];
    }
    else
    {
        [item setValue:@"NO" forKey:@"Done"];
    }
    [tableView reloadData];
    
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"Entering Background");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    [NSKeyedArchiver archiveRootObject:_objects toFile:plistPath];
    
    //[[NSDictionary dictionaryWithObjectsAndKeys: _objects,@"task", nil] writeToFile:plistPath atomically:YES];
}

@end