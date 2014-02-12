//
//  SearchCityViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "SearchCityViewController.h"
@interface SearchCityViewController ()

@end

@implementation SearchCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVC:(CityViewController *)city{
    cityVC=city;
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
	UIImageView *barImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    barImageview.image=[UIImage imageNamed:@"nav_bar.png"];
    [self.view addSubview:barImageview];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 4, 160, 40)];
    titleLabel.font=[UIFont fontWithName:KdefaultFont size:20];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"选择城市";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    mytable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, __MainScreen_Height-44) style:UITableViewStylePlain];
    mytable.delegate=self;
    mytable.dataSource=self;
    [self.view addSubview:mytable];
    
    sections = @[@"A",@"B",@"C",@"D",@"E",@"F", @"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];

    rows = @[@[@"阿坝",@"阿拉善",@"阿里",@"安康",@"安庆",@"鞍山",@"安顺",@"安阳",@"澳门"],
             @[@"北京",@"白银",@"保定",@"宝鸡",@"保山",@"包头",@"巴中",@"北海",@"蚌埠",@"本溪",@"毕节",@"滨州",@"百色",@"亳州"],
             @[@"重庆",@"成都",@"长沙",@"长春",@"沧州",@"常德",@"昌都",@"长治",@"常州",@"巢湖",@"潮州",@"承德",@"郴州",@"赤峰",@"池州",@"崇左",@"楚雄",@"滁州",@"朝阳"],
             @[@"大连",@"东莞",@"大理",@"丹东",@"大庆",@"大同",@"大兴安岭",@"德宏",@"德阳",@"德州",@"定西",@"迪庆",@"东营"],
             @[@"鄂尔多斯",@"恩施",@"鄂州"],
             @[@"福州",@"防城港",@"佛山",@"抚顺",@"抚州",@"阜新",@"阜阳"],
             @[@"广州",@"桂林",@"贵阳",@"甘南",@"赣州",@"甘孜",@"广安",@"广元",@"贵港",@"果洛"],
             
             @[@"杭州",@"哈尔滨",@"合肥",@"海口",@"呼和浩特",@"海北",@"海东",@"海南",@"海西",@"邯郸",@"汉中",@"鹤壁",@"河池",@"鹤岗",@"黑河",@"衡水",@"衡阳",@"河源",@"贺州",@"红河",@"淮安",@"淮北",@"怀化",@"淮南",@"黄冈",@"黄南",@"黄山",@"黄石",@"惠州",@"葫芦岛",@"呼伦贝尔",@"湖州",@"菏泽"],
             @[@"济南",@"佳木斯",@"吉安",@"江门",@"焦作",@"嘉兴",@"嘉峪关",@"揭阳",@"吉林",@"金昌",@"晋城",@"景德镇",@"荆门",@"荆州",@"金华",@"济宁",@"晋中",@"锦州",@"九江",@"酒泉"],
             @[@"昆明",@"开封"],
             @[@"兰州",@"拉萨",@"来宾",@"莱芜",@"廊坊",@"乐山",@"凉山",@"连云港",@"聊城",@"辽阳",@"辽源",@"丽江",@"临沧",@"临汾",@"临夏",@"临沂",@"林芝",@"丽水",@"六安",@"六盘水",@"柳州",@"陇南",@"龙岩",@"娄底",@"漯河",@"洛阳",@"泸州",@"吕梁"],
             @[@"马鞍山",@"茂名",@"眉山",@"梅州",@"绵阳",@"牡丹江"],
             @[@"南京",@"南昌",@"南宁",@"宁波",@"南充",@"南平",@"南通",@"南阳",@"那曲",@"内江",@"宁德",@"怒江"],
             
             @[@"盘锦",@"攀枝花",@"平顶山",@"平凉",@"萍乡",@"莆田",@"濮阳"],
             @[@"青岛",@"黔东南",@"黔南",@"黔西南",@"庆阳",@"清远",@"秦皇岛",@"钦州",@"齐齐哈尔",@"泉州",@"曲靖",@"衢州"],
             @[@"日喀则",@"日照"],
             @[@"上海",@"深圳",@"苏州",@"沈阳",@"石家庄",@"三门峡",@"三明",@"三亚",@"商洛",@"商丘",@"上饶",@"山南",@"汕头",@"汕尾",@"韶关",@"绍兴",@"邵阳",@"十堰",@"朔州",@"四平",@"绥化",@"遂宁",@"随州",@"宿迁",@"宿州"],
             @[@"天津",@"太原",@"泰安",@"泰州",@"台州",@"唐山",@"天水",@"铁岭",@"铜川",@"通化",@"通辽",@"铜陵",@"铜仁",@"台湾"],
             @[@"武汉",@"乌鲁木齐",@"无锡",@"威海",@"潍坊",@"文山",@"温州",@"乌海",@"芜湖",@"乌兰察布",@"武威",@"梧州"],
             @[@"厦门",@"西安",@"西宁",@"襄樊",@"湘潭",@"湘西",@"咸宁",@"咸阳",@"孝感",@"邢台",@"新乡",@"信阳",@"新余",@"忻州",@"西双版纳",@"宣城",@"许昌",@"徐州",@"香港",@"锡林郭勒",@"兴安"],
             @[@"银川",@"雅安",@"延安",@"延边",@"盐城",@"阳江",@"阳泉",@"扬州",@"烟台",@"宜宾",@"宜昌",@"宜春",@"营口",@"益阳",@"永州",@"岳阳",@"榆林",@"运城",@"云浮",@"玉树",@"玉溪",@"玉林"],
             @[@"杂多县",@"赞皇县",@"枣强县",@"枣阳市",@"枣庄",@"泽库县",@"增城市",@"泽普县",@"泽州县",@"札达县",@"扎赉特旗",@"扎兰屯市",@"扎鲁特旗",@"扎囊县",@"张北县",@"张店",@"章贡",@"张家港",@"张家界",@"张家口",@"漳平市",@"漳浦县",@"章丘市",@"樟树市",@"张湾",@"彰武县",@"漳县",@"张掖",@"漳州",@"长子县",@"湛河",@"湛江",@"站前",@"沾益县",@"诏安县",@"召陵区",@"昭平县",@"肇庆",@"昭通",@"赵县",@"昭阳",@"招远市",@"肇源县",@"肇州县",@"柞水县",@"柘城县",@"镇安县",@"振安区",@"镇巴县",@"正安县",@"正定县",@"正定新区",@"正蓝旗",@"正宁县",@"蒸湘",@"正镶白旗",@"正阳县",@"郑州",@"镇海",@"镇江",@"浈江",@"镇康县",@"镇赉县",@"镇平县",@"振兴",@"镇雄县",@"镇原县",@"志丹县",@"治多县",@"芝罘",@"枝江市",@"芷江侗族自治县",@"织金县",@"中方县",@"中江县",@"钟楼",@"中牟县",@"中宁县",@"中山",@"中山",@"钟山",@"钟山县",@"中卫",@"钟祥市",@"中阳县",@"周村",@"周口",@"周宁县",@"舟曲县",@"舟山",@"周至县",@"庄河市",@"诸城市",@"珠海",@"珠晖",@"诸暨市",@"驻马店",@"准格尔旗",@"涿鹿县",@"卓尼",@"涿州市",@"卓资县",@"珠山",@"竹山县",@"竹溪县",@"株洲",@"株洲县",@"淄博",@"子长县",@"淄川区",@"自贡",@"秭归县",@"紫金县",@"自流井",@"资溪县",@"资兴市",@"资阳"]];
    indexBar=[[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(300, 44, 20, __MainScreen_Height-44)];
    indexBar.delegate = self;
    //indexBar.backgroundColor=[UIColor clearColor];
    [self.view addSubview:indexBar];

}


#pragma mark - UISarchView Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.view.frame = CGRectMake(0, -44, 320, 460);
    //    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.view.frame = CGRectMake(0, 0, 320, 460);
    //    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // NSLog(@"%@",searchBar.text);
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSLog(@"%@",searchString);
    return YES;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [indexBar setIndexes:sections];
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [rows[section] count];


}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   return sections[section];

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"TableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.textLabel setText:rows[indexPath.section][indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    cityVC.cityString=rows[indexPath.section][indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}



#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([mytable numberOfSections] > index && index > -1){   // for safety, should always be YES
        [mytable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
