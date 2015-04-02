//
//  AXOnTheCellViewController.m
//  AXRatingViewDemo
//

#import "AXOnTheCellViewController.h"
#import <AXRatingView/AXRatingView.h>

@interface AXOnTheCellViewController ()

@end

@implementation AXOnTheCellViewController {
  NSMutableArray *_ratingNumbers;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"on the UITableViewCell";
  
  _ratingNumbers = [NSMutableArray array];
  for (NSUInteger index = 0; index < 64; index++) {
    [_ratingNumbers addObject:@(rand() % 6)];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return _ratingNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"StarCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Set rating view to accessory view.
    AXRatingView *ratingView = [[AXRatingView alloc] init];
    [ratingView setStepInterval:1.0];
    [ratingView addTarget:self action:@selector(changeRate:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = ratingView;
    [cell.accessoryView sizeToFit];
  }
  [cell.textLabel setText:[NSString stringWithFormat:@"No.%d", (int)(indexPath.row + 1)]];
  
  // Setup rating view for each cell.
  AXRatingView *ratingView = (AXRatingView *)cell.accessoryView;
  ratingView.value = [_ratingNumbers[indexPath.row] floatValue];
  ratingView.tag = indexPath.row;
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)changeRate:(AXRatingView *)sender
{
  // Save rating, because the cell will be reused.
  _ratingNumbers[sender.tag] = @(sender.value);
}

@end
