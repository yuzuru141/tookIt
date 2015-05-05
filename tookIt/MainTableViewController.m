//
//  MainTableViewController.m
//  tookIt
//
//  Created by 石井嗣 on 2015/05/05.
//  Copyright (c) 2015年 YuZ. All rights reserved.
//

#import "MainTableViewController.h"
#import "UrlViewController.h"

@interface MainTableViewController (){
    NSString *wordString;
    NSString* titleString;
    NSString* urlString;
    NSString *bodyString;
    NSMutableArray *dataSource;
    NSMutableArray *cellArray;
    NSMutableDictionary *cellDictionary;
    NSInteger cellNumber;
}

@end

@implementation MainTableViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self firstLoad];
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self firstLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)firstLoad{
    
//    dataSource = [[NSArray alloc]initWithObjects:
//                  @"add1", @"add2", @"add3",@"add4", @"add5", @"add6", nil];
    // deselect cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    // update dataSource
    [self updateDataSource];
    // update visible cells
    [self updateVisibleCells];
    
    
}

-(void)loadUserDefault{
    
    dataSource = [[NSMutableArray alloc]init];
    cellArray = [[NSMutableArray alloc]init];
    cellDictionary = [[NSMutableDictionary alloc]init];
    
    NSUserDefaults *mydefault = [NSUserDefaults standardUserDefaults];
//    if (!([mydefault stringForKey:@"TITLE"]==nil)) {
//        titleString = [mydefault stringForKey:@"TITLE"];
//        urlString = [mydefault stringForKey:@"URL"];
//        wordString = [mydefault stringForKey:@"SEARCHWORD"];
//        NSLog(@"titleString=%@, urlString=%@, wordString=%@",titleString,urlString,wordString);
//    }
//    else{
//        titleString = @"add";
//        urlString = nil;
//        wordString = nil;
//        NSLog(@"情報無し");
//    }
//    [cellDictionary setValue:titleString forKey:@"TITLE"];
//    [cellDictionary setValue:urlString forKey:@"URL"];
//    [cellDictionary setValue:wordString forKey:@"SEARCHWORD"];
    

    
    //Arrayの中にDictionary情報を格納する
    cellArray = [mydefault objectForKey:@"CELLS"];
    NSLog(@"cellArray=%@",[cellArray description]);
    NSLog(@"cellDictionary=%@",[cellDictionary description]);
    //今あるものを消してまた入れると次でなぜか止まる
    [cellArray addObject:cellDictionary];
    
    if (cellArray==nil) {
        titleString = @"add";
        urlString = nil;
        wordString = nil;
//        [cellDictionary setValue:titleString forKey:@"TITLE"];
//        [cellDictionary setValue:urlString forKey:@"URL"];
//        [cellDictionary setValue:wordString forKey:@"SEARCHWORD"];
        NSLog(@"情報無し");
        [dataSource addObject:titleString];
    }else{
        for (int i=0; i<[cellArray count]-1; i++) {
            NSLog(@"count=%d",[cellArray count]);
            cellDictionary = [cellArray objectAtIndex:i];
            titleString = [cellDictionary objectForKey:@"TITLE"];
            NSLog(@"TITLE=%@",titleString);
            [dataSource addObject:titleString];
        }
        [dataSource addObject:@"add"];
    }

    NSLog(@"datasource=%d",[dataSource count]);
}


#pragma mark - Table view data source

- (void)updateDataSource {
    
    
    [self loadUserDefault];
    
//    if ([titleString  isEqual: @"add"]) {
//        dataSource = [NSArray arrayWithObjects:@"add", nil];
//    }else{
//        //Dictionaryの中に入れる必要
//        dataSource = [NSArray arrayWithObjects:titleString, urlString, wordString, nil];
//    }
    
    
//    for (int i=0; i<[cellArray count]; i++) {
//        cellDictionary = [cellArray objectAtIndex:i];
//        titleString = [cellDictionary objectForKey:@"TITLE"];
//        NSLog(@"TITLE=%@",titleString);
//        [dataSource addObject:titleString];
//    }
}

#pragma mark - Cell Operation
- (void)updateVisibleCells {
    // 見えているセルの表示更新
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

// Update Cells
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // imageView
//    cell.imageView.image = [UIImage imageNamed:@"no_image.png"];
    cell.imageView.image = [UIImage imageNamed:@"right.png"];
    // textLabel
    NSString *text = [dataSource objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = text;
//    NSString *detailText = @"詳細のtextLabel";
//    cell.detailTextLabel.text = detailText;
    // arrow accessoryView
    UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
    cell.accessoryView = [[UIImageView alloc] initWithImage:arrowImage];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataSource count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
//    cell.textLabel.text = [NSString stringWithFormat:@"add"];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self updateCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"「%@」が選択されました", [dataSource objectAtIndex:indexPath.row]);
    cellNumber = indexPath.row;
    NSLog(@"cellNumber=%d",cellNumber);
    NSUserDefaults* mydefault = [NSUserDefaults standardUserDefaults];
    [mydefault setInteger:cellNumber forKey:@"NUMBER"];
    [mydefault synchronize];
    
    //セグエ移動メソッド不要
//    [self performSegueWithIdentifier:@"tableViewToView" sender:self];
    
    // ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
