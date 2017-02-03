//
//  CitySelectionViewController.m
//  itsmApp
//
//  Created by ZTE on 16/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "CitySelectionViewController.h"
#import "HotCityTableViewCell.h"
#import "PlainCityTableViewCell.h"
#import "IWSearchBar.h"
#import "CityListInfo.h"
#import "Common.h"
#import "CityInfo.h"
#import "PinYinString.h"
#import "UIColor+HEX.h"

#define DefaultCity     @"深圳"
#define DefaultCityID   @"133"

@interface CitySelectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,hotCityButtonClickDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UITextField *searchBar;
@property (nonatomic,strong) NSArray *indexArray;

@property (nonatomic,strong) CityInfo *selectedCityInfo;

@property (nonatomic,strong) UILabel *arealab;
@property (nonatomic,weak) UIButton *selectBtn;
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,strong) NSArray *cnCityList;
@property (nonatomic,strong) NSArray *foreignCityList;
@property (nonatomic,strong) NSArray *cityList;
@property (nonatomic,strong) NSArray *hotCityList;
@property (nonatomic,strong) NSString *selectCityStr;
@property (nonatomic,strong) NSString *selectCityId;
@property (nonatomic,assign) BOOL searchCity;
@end

@implementation CitySelectionViewController

+ (NSString *)latestCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kLatestCity];
    return city ?:DefaultCity;
}

+ (NSString *)latestCityId
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kLatestCityId];
    return city ?:DefaultCityID;
}

+ (NSString *)latestAddress
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kLatestAddress];
    return city ?:DefaultCity;
}

- (UIButton *)leftButtonWithTitleAndImage:(NSString *)title {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,80, 44);
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [leftButton setTitleColor:[UIColor getColor:@"080808"] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(11,-8, 11, 47)];
    return leftButton;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadCityData];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"国内",@"海外",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl=segmentedControl;
    segmentedControl.frame = CGRectMake((self.view.frame.size.width-200)/2,0,200,34);
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor =[UIColor getColor:@"3ebdf0"];
    // 有基本四种样式
    self.navigationItem.titleView=segmentedControl;
    
     [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged]; //添加委托方法

    UIButton *leftButton = [self leftButtonWithTitleAndImage:@"返回"];
    [leftButton addTarget:self action:@selector(singleReturn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    [self.view setBackgroundColor:[UIColor getColor:@"f5f5f5"]];
    UIView *searcheView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,KScreenWidth, 48)];
    searcheView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searcheView];
    IWSearchBar *searchBar = [IWSearchBar searchBar];
    // 尺寸
    searchBar.frame = CGRectMake(15, 8, KScreenWidth - 30,32);
    searchBar.delegate=self;
    [searcheView addSubview:searchBar];
    _searchBar=searchBar;
    
    CGRect frame=CGRectMake(0, 112, KScreenWidth, KScreenHeight-112);
    self.myTableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.myTableView.separatorColor = [UIColor getColor:@"dddddd"];
    self.myTableView.backgroundColor = [UIColor clearColor];
    //改变索引的颜色
    self.myTableView.sectionIndexColor = [UIColor getColor:@"3ebdf0"];
    //改变索引选中的背景颜色
    self.myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.myTableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
    
    //[self.myTableView reloadData];
    [self.view addSubview:self.myTableView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //MyColor(122, 206, 237);
    [self loadCityData];

    [self searchCityData:@""];
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    self.selectBtn = nil;
    self.selectedCityInfo = nil;
    self.selectCityId = nil;
    self.selectCityStr = nil;
    [self searchCityData:self.searchBar.text];
}

- (void)loadCityData
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *json_path=[path stringByAppendingPathComponent:@"working_place.json"];
    NSData *data=[NSData dataWithContentsOfFile:json_path];
    if ([data length] == 0) {
        return;
    }
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *cnArray=jsonDict[@"cnData"];
    NSArray *foreignArray=jsonDict[@"foreignData"];
    NSMutableArray *tempCityArray = [[NSMutableArray alloc] initWithCapacity:cnArray.count];
    for (NSDictionary *cnCityDict in cnArray) {
        CityInfo *city = [CityInfo buildCityInfo:cnCityDict];
        [city pinyinProcess];
        [tempCityArray addObject:city];
    }
    self.cnCityList = [NSArray arrayWithArray:tempCityArray];
    
    tempCityArray = [[NSMutableArray alloc] initWithCapacity:foreignArray.count];
    for (NSDictionary *foreignCityDict in foreignArray) {
        CityInfo *city = [CityInfo buildCityInfo:foreignCityDict];
        [city pinyinProcess];
        [tempCityArray addObject:city];
    }
    self.foreignCityList = [NSArray arrayWithArray:tempCityArray];
    
    path=[paths objectAtIndex:0];
    json_path=[path stringByAppendingPathComponent:@"hotworking_place.json"];
    data=[NSData dataWithContentsOfFile:json_path];
    if ([data length] == 0) {
        return;
    }
    jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *hotArray = jsonDict[@"data"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:hotArray.count];
    for (NSDictionary *hotcityDict in hotArray) {
        HotCityInfo *hotCityInfo = [[HotCityInfo alloc] initWithDictionary:hotcityDict];
        [tempArray addObject:hotCityInfo];
    }
    self.hotCityList = [NSArray arrayWithArray:tempArray];
}


-(void)searchCityData:(NSString *)searchStr{
    
    NSArray *sourceArray = self.segmentedControl.selectedSegmentIndex == 0 ? self.cnCityList:self.foreignCityList;
    
    if (sourceArray.count == 0) {
        return;
    }
    
    NSString *lower = [searchStr lowercaseString];
    
    NSMutableArray *tempCityList = [NSMutableArray array];
    
    for (int i=0; i < sourceArray.count; i++) {
        
        CityInfo *city = sourceArray[i];
        
        if( [lower length] > 0 && [city.cityName rangeOfString:searchStr].location == NSNotFound && ![city.cityEnName hasPrefix:lower])
            continue;
        CityListInfo *info;
        int isEsit=NO;
        for (CityListInfo *einfo in tempCityList) {
            if([einfo.firstLetter isEqualToString:city.firstLetter])
            {
                isEsit=YES;
                [einfo.cityList addObject:city];
                break;
            }
        }
        if(!isEsit)
        {
            info =[[CityListInfo alloc]init];
            info.firstLetter = city.firstLetter;
            [info.cityList addObject:city];
            [tempCityList addObject:info];
            
        }
        
    }
    
    [tempCityList sortUsingComparator:^NSComparisonResult(CityListInfo *obj1,CityListInfo *obj2){
        NSString *str1=obj1.firstLetter;
        NSString *str2=obj2.firstLetter;
        return [str1 compare:str2];
    }];
    
    NSMutableArray *tempIndexList = [NSMutableArray array];
    [tempCityList enumerateObjectsUsingBlock:^(CityListInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempIndexList addObject:obj.firstLetter];
    }];
    
    if (self.segmentedControl.selectedSegmentIndex == 0 && [searchStr length] == 0) {
        CityListInfo *hotCityInfo = [[CityListInfo alloc] init];
        hotCityInfo.firstLetter = @"热门城市";
        [hotCityInfo.cityList addObjectsFromArray:self.hotCityList ?:@[]];
        [tempCityList insertObject:hotCityInfo atIndex:0];
        [tempIndexList insertObject:@"热门" atIndex:0];
        
        CityListInfo *latestCityInfo = [[CityListInfo alloc] init];
        latestCityInfo.firstLetter = @"最近访问城市";
        HotCityInfo *latestCity = [[HotCityInfo alloc] init];
        latestCity.cityName = [CitySelectionViewController latestCity];
        latestCity.cityId = [CitySelectionViewController latestCityId];
        [latestCityInfo.cityList addObject:latestCity];
        [tempCityList insertObject:latestCityInfo atIndex:0];
        [tempIndexList insertObject:@"最近" atIndex:0];
        
        self.searchCity = NO;
    }
    else
    {
        self.searchCity = YES;
    }
    
    self.cityList = [NSArray arrayWithArray:tempCityList];
    
    self.indexArray = [NSArray arrayWithArray:tempIndexList];
    
    [self.myTableView reloadData];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self searchCityData:@""];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchBar resignFirstResponder];
    
    if(textField.returnKeyType == UIReturnKeySearch)
    {
        [self searchCityData:textField.text];
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

-(void)singleReturn:(id)senger
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hotCityButtonClick:(UIButton *)btn
{
    self.selectBtn = btn;
    NSString *city = btn.titleLabel.text;
    self.selectedCityInfo = [self cityInfoWithCityName:city];
    self.selectCityStr = self.selectedCityInfo.cityName;
    self.selectCityId = self.selectedCityInfo.cityId;
    if (self.selectedCityInfo) {
        [self createPickview];
    }
}

- (CityInfo *)cityInfoWithCityName:(NSString *)cityName
{
    NSArray *sourceArray = self.segmentedControl.selectedSegmentIndex == 0 ? self.cnCityList:self.foreignCityList;
    
    if (sourceArray.count == 0) {
        return nil;
    }
    CityInfo *hotCityInfo = nil;
    for (CityInfo *city in sourceArray) {
        if ([city.cityName isEqualToString:cityName]) {
            hotCityInfo = city;
            break;
        }
    }
    return hotCityInfo;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.searchCity && (indexPath.section ==0 || indexPath.section == 1)){
        HotCityTableViewCell *cell = [HotCityTableViewCell cellWithTableView:tableView];
        cell.hotDelegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        CityListInfo *info=self.cityList[indexPath.section];
        cell.cityArray=info.cityList;
        return cell;
    }else{
        PlainCityTableViewCell *cell = [PlainCityTableViewCell cellWithTableView:tableView];
        CityListInfo *info=self.cityList[indexPath.section];
        CityInfo *cityInfo = info.cityList[indexPath.row];
        cell.cityName=cityInfo.cityName;
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        return cell;
    }
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityList.count;
}

//返回行数，也就是返回数组中所存储数据，也就是section的元素
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchCity && (section == 0 || section == 1)) {
        return 1;
    }
    else
    {
        CityListInfo *info=self.cityList[section];
        return info.cityList.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = nil;
    if (!self.searchCity && (section == 0 || section == 1)) {
        sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        sectionHeaderView.backgroundColor = [UIColor getColor:@"f5f5f5"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30, 15)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor getColor:@"666666"];
        label.text = ((CityListInfo *)self.cityList[section]).firstLetter;
        [sectionHeaderView addSubview:label];
    }
    else
    {
        sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        sectionHeaderView.backgroundColor = [UIColor getColor:@"f5f5f5"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 7.5, KScreenWidth - 30, 15)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor getColor:@"666666"];
        label.text = ((CityListInfo *)self.cityList[section]).firstLetter;
        [sectionHeaderView addSubview:label];
    }
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.searchCity && (section == 0 || section == 1)) {
        return 40.0;
    }
    else
    {
        return 30.0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.searchCity && (indexPath.section==0 || indexPath.section == 1) )
    {
        CityListInfo *info=self.cityList[indexPath.section];
        NSInteger row = (info.cityList.count+2)/3;
        return row*40 + (row-1)*10;
    }else{
        return 40;
    }
}

//返回索引数组

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (self.searchCity || (!self.searchCity && (indexPath.section >1))) {
        CityListInfo *listInfo = self.cityList[indexPath.section];
        CityInfo *info = listInfo.cityList[indexPath.row];
        self.selectedCityInfo = info;
        self.selectCityStr = self.selectedCityInfo.cityName;
        self.selectCityId = self.selectedCityInfo.cityId;
        [self createPickview];
    }
}




/* chenkq  创建地区选择器（Pickview） begin */

- (void)createPickview
{
    //透明黑
    baseView = [[UIView alloc]initWithFrame:self.view.bounds];
    baseView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    
    UITapGestureRecognizer *baseViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseViewTapAction:)];
    [baseView addGestureRecognizer:baseViewTap];
    [self.view addSubview:baseView];
    
    /*展示试选择地图*/
    _selectShowView = [[UIView alloc] initWithFrame:CGRectMake(0,KScreenHeight-220.0,KScreenWidth, 220.0)];
    _selectShowView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:_selectShowView];
    
    UILabel *labshow=[[UILabel alloc]init];
    labshow.text=@"当前已选";
    labshow.frame=CGRectMake(15, 40.0, 80, 17.0);
    labshow.font=[UIFont systemFontOfSize:17.0];
    labshow.textColor = [UIColor getColor:@"666666"];
    [_selectShowView addSubview:labshow];
    
    UILabel *citylab=[[UILabel alloc]init];
    citylab.text=self.selectedCityInfo.cityName;

    citylab.textColor= [UIColor getColor:@"3ebdf0"];
    citylab.frame=CGRectMake(95.0 + 13.0, 40.0, 100.0, 17.0);
    citylab.font=[UIFont systemFontOfSize:17.0];
    
    [_selectShowView addSubview:citylab];
    
    UILabel *arealab=[[UILabel alloc] initWithFrame:CGRectMake(15.0, 97.0, 280.0, 17.0)];
    arealab.text=@"是否要精确定位到某栋楼层（选项）";
    arealab.lineBreakMode =NSLineBreakByWordWrapping;
    arealab.textColor = [UIColor getColor:@"666666"];
    _arealab=arealab;
    arealab.font=[UIFont systemFontOfSize:17.0];
    
    [_selectShowView addSubview:arealab];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295+30.0, 97.0, 17.0, 17.0)];
    arrowImageView.contentMode = UIViewContentModeCenter;
    arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    [_selectShowView addSubview:arrowImageView];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(295.0, 84.0, KScreenWidth-295.0,44.0);
    [selectBtn addTarget:self action:@selector(pushPickerView) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowView addSubview:selectBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 220.0-48.0, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor getColor:@"dddddd"];
    [_selectShowView addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0, 220.0-48.0, 0.5, 48.0)];
    lineView.backgroundColor = [UIColor getColor:@"dddddd"];
    [_selectShowView addSubview:lineView];
    
    UIButton *cancleBt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBt1.frame = CGRectMake(0, 220.0-48.0, KScreenWidth/2,48.0);
    [cancleBt1 setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBt1 addTarget:self action:@selector(selectCancleAction:) forControlEvents:UIControlEventTouchUpInside];

    [cancleBt1 setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
    [cancleBt1 setTitleColor:[UIColor getColor:@"3ebdf0"] forState:UIControlStateSelected];
    [_selectShowView addSubview:cancleBt1];
    
    //确定
    UIButton *confirmBt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBt1 addTarget:self action:@selector(selectConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmBt1.frame = CGRectMake(KScreenWidth/2,220.0-48.0, KScreenWidth/2, 48.0);
    [confirmBt1 setTitle:@"确定" forState:UIControlStateNormal];
    
    [confirmBt1 setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
    [confirmBt1 setTitleColor:[UIColor getColor:@"3ebdf0"] forState:UIControlStateSelected];
    [_selectShowView addSubview:confirmBt1];
    
    /*展示选择的地点*/
    
    _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0,KScreenHeight-220.0, KScreenWidth, 220.0)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:_pickerView];
    _pickerView.hidden=YES;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 220.0-48.0, KScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor getColor:@"dddddd"];
    [_pickerView addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0, 220.0-48.0, 0.5, 48.0)];
    lineView.backgroundColor = [UIColor getColor:@"dddddd"];
    [_pickerView addSubview:lineView];
    
    //取消
    UIButton *cancleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBt.frame = CGRectMake(0, 220.0-48.0, KScreenWidth/2, 48.0);
    [cancleBt setTitle:@"取消" forState:UIControlStateNormal];
        cancleBt.titleLabel.textAlignment=NSTextAlignmentCenter;
    [cancleBt addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBt setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
    [cancleBt setTitleColor:[UIColor getColor:@"3ebdf0"] forState:UIControlStateSelected];
    [_pickerView addSubview:cancleBt];
    
    //确定
    UIButton *confirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBt addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmBt.frame = CGRectMake(KScreenWidth/2, 220.0-48.0, KScreenWidth/2, 48.0);
    confirmBt.titleLabel.textAlignment=NSTextAlignmentCenter;
    [confirmBt setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBt setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
    [confirmBt setTitleColor:[UIColor getColor:@"3ebdf0"] forState:UIControlStateSelected];
    [_pickerView addSubview:confirmBt];
    
    //picker
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0.0, 0.0, KScreenWidth, 172.0)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow:0 inComponent:0 animated: YES];
    [picker reloadAllComponents];
    [_pickerView addSubview:picker];
}

/* chenkq  创建地区选择器 end */


/*pickerView  选择器事件  begin  */
#pragma mark- Picker Data Source Methods

- (CityInfo *)parentCityInfoWithComponent:(NSInteger)component
{
    if (component == 0) {
        return self.selectedCityInfo;
    }
    else
    {
        CityInfo *info = self.selectedCityInfo;
        for (NSInteger i = 0; i < component; i++) {
            NSInteger selectedRow = [picker selectedRowInComponent:i];
            if (selectedRow == -1) {
                selectedRow = 0;
            }
            CityInfo *selectedCity = info.childs[selectedRow];
            info = selectedCity;
        }
        return info;
    }
    return nil;
}

- (CityInfo *)currentCityInfoWithComponent:(NSInteger)component
{
    CityInfo *info = self.selectedCityInfo;
    for (NSInteger i = 0; i <= component; i++) {
        NSInteger selectedRow = [picker selectedRowInComponent:i];
        if (selectedRow == -1) {
            selectedRow = 0;
        }
        CityInfo *selectedCity = info.childs[selectedRow];
        info = selectedCity;
    }
    return info;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    CityInfo *city = [self parentCityInfoWithComponent:component];
    return city.childs.count;
}
#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CityInfo *parentCity = [self parentCityInfoWithComponent:component];
    if (row < parentCity.childs.count) {
        CityInfo *city = parentCity.childs[row];
        return city.cityName;
    }
    else
    {
        return nil;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.frame = CGRectMake(0, 0, KScreenWidth/3,44.0);
        pickerLabel.numberOfLines = 0;
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0]];
        pickerLabel.textColor = [UIColor getColor:@"666666"];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    
    return KScreenWidth/3;
}
#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if (component == 1) {
        [pickerView reloadComponent:2];
    }
}
/*pickerView  选择器事件  end  */


- (void)cancelSelectedCity
{
    if(self.selectBtn != nil)
    {
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationNone];
        self.selectBtn = nil;
    }
    self.selectCityStr = nil;
    self.selectCityId = nil;
    self.selectedCityInfo = nil;
}

/* 按钮操作 begin */

#pragma mark -UIButton action
//点击屏幕其他地方，移除地址选择试图
- (void)baseViewTapAction:(UITapGestureRecognizer *)tap
{
    [self cancelSelectedCity];
    [baseView removeFromSuperview];
    baseView = nil;
}

//选中城市后，弹出具体楼层选择
-(void)pushPickerView{
    self.selectCityStr = self.selectedCityInfo.cityName;
    if(self.selectedCityInfo.childs.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前所选中城市无下级可选位置" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.delegate=self;
        [alert show];
        return;
    }
    _pickerView.frame=CGRectMake(_pickerView.frame.size.width, _pickerView.frame.origin.y,_pickerView.frame.size.width, _pickerView.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectShowView.frame=CGRectMake(-_selectShowView.frame.size.width, _selectShowView.frame.origin.y,_selectShowView.frame.size.width, _selectShowView.frame.size.height);
        
    } completion:^(BOOL finished) {
        _selectShowView.hidden=YES;
    }];
    _pickerView.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.frame=CGRectMake(0, _pickerView.frame.origin.y,_pickerView.frame.size.width, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


//取消城市地址选择
- (void)selectCancleAction:(UIButton *)sender
{
    [self cancelSelectedCity];
    [baseView removeFromSuperview];
    baseView = nil;
}

#pragma 返回选择城市已经楼层地址代理
//点击确定选择当前选中城市
- (void)selectConfirmAction:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = self.selectedCityInfo.cityName ?:DefaultCity;
    NSString *address = self.selectCityStr ?:DefaultCity;
    NSString *cityId = self.selectCityId ?:DefaultCityID;
    [defaults setObject:address forKey:kLatestAddress];
    [defaults setObject:city forKey:kLatestCity];
    [defaults setObject:cityId forKey:kLatestCityId];
    [defaults synchronize];
    if([self.selDelegate respondsToSelector:@selector(getSelectCity:)]){
        [self.selDelegate getSelectCity:@{kAddress:address,kCity:city,kCityId:cityId}];
    }
    [baseView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


///取消具体楼层选择
- (void)cancleAction:(UIButton *)sender
{
    _selectShowView.frame=CGRectMake(-_selectShowView.frame.size.width, _selectShowView.frame.origin.y,_selectShowView.frame.size.width, _selectShowView.frame.size.height);
    
     _selectShowView.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        _selectShowView.frame=CGRectMake(0, _selectShowView.frame.origin.y,_selectShowView.frame.size.width, _selectShowView.frame.size.height);
        
    } completion:^(BOOL finished) {
       
    }];
    

    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.frame=CGRectMake(_pickerView.frame.size.width, _pickerView.frame.origin.y,_pickerView.frame.size.width, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        _pickerView.hidden=YES;
    }];
    
    //是否要精确定位到某栋楼层（选项）
    NSString *str =@"是否要精确定位到某栋楼层（选项）";
    self.selectCityStr = self.selectedCityInfo.cityName;
    self.selectCityId = self.selectedCityInfo.cityId;
    self.arealab.text=str;
    
}
//确定具体楼层选择
- (void)confirmAction:(UIButton *)sender
{
    _selectShowView.frame=CGRectMake(-_selectShowView.frame.size.width, _selectShowView.frame.origin.y,_selectShowView.frame.size.width, _selectShowView.frame.size.height);
    
    _selectShowView.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        _selectShowView.frame=CGRectMake(0, _selectShowView.frame.origin.y,_selectShowView.frame.size.width, _selectShowView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _pickerView.frame=CGRectMake(_pickerView.frame.size.width, _pickerView.frame.origin.y,_pickerView.frame.size.width, _pickerView.frame.size.height);
    } completion:^(BOOL finished) {
        _pickerView.hidden=YES;
    }];
    
    CityInfo *firstCity = [self currentCityInfoWithComponent:0];
    CityInfo *secondCity = [self currentCityInfoWithComponent:1];
    CityInfo *thirdCity = [self currentCityInfoWithComponent:2];
    
    NSString *str =[NSString stringWithFormat:@"%@%@%@",firstCity.cityName,secondCity.cityName,thirdCity.cityName];
    self.arealab.text=str;
    self.selectCityStr =[NSString stringWithFormat:@"%@%@",self.selectedCityInfo.cityName,str];
    self.selectCityId = thirdCity.cityId;
}

/* 按钮操作 end */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
