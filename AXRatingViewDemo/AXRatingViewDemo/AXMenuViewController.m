//
//  AXMenuViewController.m
//  AXRatingViewDemo
//

#import "AXMenuViewController.h"
#import "AXPropertiesViewController.h"
#import "AXOnTheCellViewController.h"

@interface AXMenuViewController ()

@end

@implementation AXMenuViewController {
  NSArray *_menuTitles;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"AXRatingView Demo";
  
  _menuTitles =
  @[
    @"Properties",
    @"on the UITableViewCell",
    ];
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
  return _menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  [cell.textLabel setText:_menuTitles[indexPath.row]];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0: {
      // Properties
      AXPropertiesViewController *propertiesViewCon = [[AXPropertiesViewController alloc] init];
      [self.navigationController pushViewController:propertiesViewCon animated:YES];
      break;
    }
    case 1: {
      // on the UITableViewCell
      AXOnTheCellViewController *onTheCellViewCon = [[AXOnTheCellViewController alloc] init];
      [self.navigationController pushViewController:onTheCellViewCon animated:YES];
      break;
    }
    default:
      // nothing
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      break;
  }
}

@end
