//
//  CenterViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/15.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "CenterViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PickerContainerViewController.h"
#import "BillsInputViewController.h"

#import "GesturePasswordManager.h"
#import "GesturePasswordController.h"

#import "CitySelectionViewController.h"

#import "GetServiceHandle.h"
#import "ServiceCatalogTableViewCell.h"
#import "UIColor+HEX.h"

#import "RefreshInfoHandle.h"

#import "UserFeedbackHandle.h"

#import "GetCityWorkingHandle.h"
#import "GetHotCityWorkingHandle.h"

@interface CenterViewController ()<NetworkHandleDelegate,PickerContainerDelegate,UITableViewDelegate,UITableViewDataSource,ServiceCatalogTableViewDelegate,CityAddressDelegate>
@property (nonatomic,strong)NSArray *corlors;
@property (nonatomic,strong)GetServiceHandle *getServiceHandle;
@property (nonatomic,weak)PickerContainerViewController *pickerContainerController;
@property (nonatomic,weak)ServiceCatalog *currentServiceCatalog;
@property (nonatomic,weak)ServiceCatalog *selectedServiceCatalog;
@property (nonatomic,strong)RefreshInfoHandle *refreshInfoHandle;
@property (nonatomic,strong)UserFeedbackHandle *feedbackHandle;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *cityId;
@property (nonatomic,strong)GetCityWorkingHandle *getCityWorkingHandle;
@property (nonatomic,strong)GetHotCityWorkingHandle *getHotCityWorkingHandle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerContainerBottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *servicesTableView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (assign, nonatomic) BOOL showGesturePassword;

- (IBAction)leftAction:(id)sender;

- (IBAction)locationAction:(id)sender;

- (IBAction)refreshAction:(id)sender;

@property (nonatomic,strong)UIView *unreadView;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.corlors = @[@"af89f5",@"14c5ff",@"00d582",@"bbdc3a",@"c7c7c7"];
    self.getServiceHandle = [[GetServiceHandle alloc] init];
    self.getServiceHandle.delegate = self;
    [self.getServiceHandle sendRequest];
    
    self.address = [CitySelectionViewController latestAddress];
    self.city = [CitySelectionViewController latestCity];
    self.cityId = [CitySelectionViewController latestCityId];
    
    self.refreshInfoHandle = [[RefreshInfoHandle alloc] init];
    self.refreshInfoHandle.delegate = self;
    [self.refreshInfoHandle sendRequest];
    
    self.getCityWorkingHandle = [[GetCityWorkingHandle alloc] init];
    self.getCityWorkingHandle.delegate = self;
    [self.getCityWorkingHandle sendRequest];
    
    self.getHotCityWorkingHandle = [[GetHotCityWorkingHandle alloc] init];
    self.getHotCityWorkingHandle.delegate = self;
    [self.getHotCityWorkingHandle sendRequest];
    
    UIView *customView = self.navigationItem.leftBarButtonItem.customView;
    self.unreadView = [[UIView alloc] initWithFrame:CGRectMake(customView.frame.size.width, 0, 6, 6)];
    self.unreadView.backgroundColor = [UIColor redColor];
    self.unreadView.layer.cornerRadius = 3.0;
    [customView addSubview:self.unreadView];
    
    [self unreadMessageDidChange];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadMessageDidChange) name:UnReadMessageDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UnReadMessageDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidEnterBackground
{
    if (!self.showGesturePassword) {
        self.showGesturePassword = YES;
    }
}

- (void)applicationDidBecomeActive
{
    if (self.showGesturePassword) {
        GesturePasswordController *gesturePasswordController = [[GesturePasswordController alloc] initWithNibName:@"GesturePasswordController" bundle:nil];
        gesturePasswordController.type = GesturePasswordTypeLockOrSuspendVerify;
        __weak typeof(self) wself = self;
        gesturePasswordController.completionBlock = ^{
            [wself dismissViewControllerAnimated:YES completion:nil];
            wself.showGesturePassword = NO;
        };
        if (self.navigationController.topViewController.presentedViewController) {
            [self.navigationController.topViewController dismissViewControllerAnimated:NO completion:nil];
        }
        [self.mm_drawerController presentViewController:gesturePasswordController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pickerViewController"]) {
        self.pickerContainerController = (PickerContainerViewController *)segue.destinationViewController;
        self.pickerContainerController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"billsinput"]) {
        BillsInputViewController *billsInputController = (BillsInputViewController *)segue.destinationViewController;
        billsInputController.billsTypeId = self.selectedServiceCatalog.serviceId;
        billsInputController.address = self.address;
        billsInputController.cityId = self.cityId;
        billsInputController.title = self.selectedServiceCatalog.name;
    }
}


- (IBAction)leftAction:(id)sender {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self hidePickerContainerView];
}

- (IBAction)locationAction:(id)sender {
    
    [self hidePickerContainerView];
    CitySelectionViewController *cityView=[[CitySelectionViewController alloc]init];
    cityView.selDelegate = self;
    [self.navigationController pushViewController:cityView animated:YES];
}

- (IBAction)refreshAction:(id)sender {
    [self hidePickerContainerView];
    [self.refreshInfoHandle updateRefreshTime];
    [self.refreshInfoHandle sendRequest];
    
}

- (void)unreadMessageDidChange
{
    if ([UnreadMessage share].unreadCount > 0) {
        self.unreadView.hidden = NO;
    }
    else
    {
        self.unreadView.hidden = YES;
    }
}

- (void)setCity:(NSString *)city
{
    if (_city == city) {
        return;
    }
    _city = [city copy];
    self.locationLabel.text = _city;
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getServiceHandle.serviceCatalogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCatalogTableViewCell *cell = (ServiceCatalogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceCatalogIdentify"];
    cell.delegate = self;
    ServiceCatalog *serviceCatalog = self.getServiceHandle.serviceCatalogs[indexPath.row];
    [cell.serviceCatalogButton setTitle:serviceCatalog.name forState:UIControlStateNormal];
    [cell.serviceCatalogButton setBackgroundColor:[UIColor getColor:self.corlors[indexPath.row%self.corlors.count]]];
    return cell;
}

#pragma mark NetworkingHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == self.getServiceHandle) {
        [self.servicesTableView reloadData];
    }
    else if (handle == self.refreshInfoHandle) {
        
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    if (handle == self.getServiceHandle) {
        
    }
    else if (handle == self.refreshInfoHandle) {
        
    }
}

#pragma mark CityAddressDelegate

- (void)getSelectCity:(NSDictionary *)cityDict
{
    self.address = cityDict[kAddress];
    self.city = cityDict[kCity];
    self.cityId = cityDict[kCityId];
}

#pragma mark ServiceCatalogTableViewCellDelegate

- (void)selectServiceCatalog:(ServiceCatalogTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.servicesTableView indexPathForCell:cell];
    [self showPickerContainerViewWithServiceType:self.getServiceHandle.serviceCatalogs[indexPath.row]];
}

#pragma mark PickerContainerDelegate

- (void)pickerContainer:(PickerContainerViewController *)controller finished:(BOOL)finished
{
    [self hidePickerContainerView];
    if (finished) {
        self.selectedServiceCatalog = self.currentServiceCatalog.sc[controller.selectedRow];
        [self performSegueWithIdentifier:@"billsinput" sender:nil];
    }
}

- (NSInteger)numberOfComponent
{
    return self.currentServiceCatalog.sc.count;
}

- (NSString *)titleForRow:(NSInteger)row
{
    return self.currentServiceCatalog.sc[row].name;
}

- (void)showPickerContainerViewWithServiceType:(ServiceCatalog *)serviceCatalog
{
    self.currentServiceCatalog = serviceCatalog;
    self.pickerContainerController.serviceName = serviceCatalog.name;
    [self.pickerContainerController reloadPickerData];
    self.pickerContainerBottomConstraint.constant = 0.0;
}

- (void)hidePickerContainerView
{
    self.pickerContainerBottomConstraint.constant = -self.pickerContainerController.view.frame.size.height;
}
- (IBAction)showMyOrderAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
    UIViewController *controller = [storyboard instantiateInitialViewController];
    if (controller)
    {
        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:controller animated:YES];
    }
}

@end
