//
//  BillsInputViewController.m
//  itsmApp
//
//  Created by itp on 2016/11/17.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BillsInputViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "EMMLog.h"
#import "TextInputTableViewCell.h"
#import "PictureTableViewCell.h"
#import "VoiceTableViewCell.h"
#import "TimeTableViewCell.h"
#import "AddressTableViewCell.h"
#import "ImagePickerHandler.h"
#import "TimerPickerViewController.h"
#import "VoiceInputViewController.h"
#import "VoiceIndicatorViewController.h"
#import "AudioManager.h"
#import "VoicePlayView.h"
#import "FileUploadHandle.h"
#import "BillsInputFileManager.h"
#import "BillsSubmitHandle.h"
#import "MBProgressHUD.h"

#import "SubmitFinishedViewController.h"

#import "CitySelectionViewController.h"

static int emmLogLevel = EMMLogLevelOff;


@interface BillsInputViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePickerHandlerDelegate,TimerPickerDelegate,VoiceTableViewCellDelegate,AddressTableViewCellDelegate,CityAddressDelegate,TimeTableViewCellDelegate,AudioPlayDelegate,AudioRecordDelegate,VoiceInputDelegate,NetworkHandleDelegate,SubmitFinishedDelegate>
@property (strong, nonatomic)FileUploadHandle *fileUploadHandle;
@property (strong, nonatomic)BillsSubmitHandle *billsSubmitHandle;
@property (strong, nonatomic)ImagePickerHandler *imagePickerHandler;
@property (weak, nonatomic)TimerPickerViewController *timerPickerController;
@property (weak, nonatomic)VoiceInputViewController *voiceInputController;
@property (weak, nonatomic)VoiceIndicatorViewController *voiceIndicatorController;
@property (copy, nonatomic)NSString *tempVoiceFilePath;
@property (copy, nonatomic)NSString *audioDuration;

@property (weak, nonatomic) IBOutlet UITableView *billsInputTableView;

@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *submitFinishedView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timepickerBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceInputBottomConstraint;

@end

@implementation BillsInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.billsInputTableView registerNib:[UINib nibWithNibName:@"TextInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"textInputIdentify"];
    [self.billsInputTableView registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"pictureIdentify"];
    [self.billsInputTableView registerNib:[UINib nibWithNibName:@"VoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"voiceIdentify"];
    [self.billsInputTableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeIdentify"];
    [self.billsInputTableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"addressIdentify"];
    self.imagePickerHandler = [[ImagePickerHandler alloc] init];
    self.imagePickerHandler.viewController = self;
    
    self.fileUploadHandle = [[FileUploadHandle alloc] init];
    self.fileUploadHandle.delegate = self;
    
    self.billsSubmitHandle = [[BillsSubmitHandle alloc] init];
    self.billsSubmitHandle.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)resignFirstResponder
{
    [self hideKeyboard];
    [self hideVoiceInputView];
    [self hideTimerPickerView];
    return [super resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"timepicker"]) {
        self.timerPickerController = (TimerPickerViewController *)segue.destinationViewController;
        self.timerPickerController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"voiceIndicator"])
    {
        self.voiceIndicatorController = (VoiceIndicatorViewController *)segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"voiceInput"])
    {
        self.voiceInputController = (VoiceInputViewController *)segue.destinationViewController;
        self.voiceInputController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"submitFinished"])
    {
        ((SubmitFinishedViewController *)segue.destinationViewController).delegate = self;
    }
}

- (void)prepareBillsSubmitDataWithReceiptDict:(NSDictionary *)receiptDict
{
    self.billsSubmitHandle.location = self.address;
    self.billsSubmitHandle.locationId = self.cityId;
    self.billsSubmitHandle.billsTypeId = self.billsTypeId;
    self.billsSubmitHandle.content = [self textInputContent];
    self.billsSubmitHandle.submitTime = [self orderTime];
    self.billsSubmitHandle.audioDuration = self.audioDuration;
    self.billsSubmitHandle.receiptDict = receiptDict;
    [self.billsSubmitHandle bulidBillsInputData];
}

- (IBAction)submitAction:(id)sender {
    
    if ([self textInputContent].length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入内容";
        [hud hide:YES afterDelay:0.3];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在提交";
    if (self.imagePickerHandler.pictureArray.count > 0 || [self.tempVoiceFilePath length] > 0) {
        self.fileUploadHandle.zipFilePath = [BillsInputFileManager archiveBillsWithPics:self.imagePickerHandler.pictureArray audiosPath:self.tempVoiceFilePath otherFile:nil];
        [self.fileUploadHandle sendRequest];
    }
    else
    {
        [self prepareBillsSubmitDataWithReceiptDict:nil];
        [self.billsSubmitHandle sendRequest];
    }
}

- (void)hideKeyboard
{
    TextInputTableViewCell *textCell = [self textInputTableViewCell];
    [textCell.contentTextView resignFirstResponder];
}

#pragma mark SubmitFinishedDelegate

- (void)showHomePage
{
    [self hideSubmitFinishView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBillsProcessPage
{
    [self hideSubmitFinishView];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
    UIViewController *controller = [storyboard instantiateInitialViewController];
    if (controller)
    {
        [(UINavigationController *)self.mm_drawerController.centerViewController pushViewController:controller animated:YES];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [temp removeObject:self];
        self.navigationController.viewControllers = temp;
    }
}

- (void)showSubmitFinishView
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.submitFinishedView.hidden = NO;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.submitFinishedView];
    }];
    
}

- (void)hideSubmitFinishView
{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.submitFinishedView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:self.submitFinishedView];
    }];
}


#pragma mark NetworkHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == self.fileUploadHandle) {
        [self prepareBillsSubmitDataWithReceiptDict:self.fileUploadHandle.resultDict];
        [AudioManager clearnAudioRecordCache];
        [self.billsSubmitHandle sendRequest];
    }
    else if (handle == self.billsSubmitHandle)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showBillsAlertView];
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (handle == self.fileUploadHandle) {
        
    }
    else if (handle == self.billsSubmitHandle)
    {
        
    }
}

- (void)showBillsAlertView
{
    [self showSubmitFinishView];
}


#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
        {
            count = 2;
        }
            break;
        case 1:
        {
            count = 1;
        }
            break;
        case 2:
        {
            count = 1;
        }
            break;
        case 3:
        {
            count = 1;
        }
            break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TextInputTableViewCell *textInputCell = [tableView dequeueReusableCellWithIdentifier:@"textInputIdentify"];
            cell = textInputCell;
        }
        else if (indexPath.row == 1) {
            PictureTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:@"pictureIdentify"];
            pictureCell.imagePickerHandler = self.imagePickerHandler;
            cell = pictureCell;
        }
    }
    else if (indexPath.section == 1)
    {
        VoiceTableViewCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:@"voiceIdentify"];
        voiceCell.delegate = self;
        cell = voiceCell;
    }
    else if (indexPath.section == 2)
    {
        TimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeIdentify"];
        timeCell.delegate = self;
        if (self.timerPickerController.selectedDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日  HH:mm"];
            timeCell.timeLabel.text = [formatter stringFromDate:self.timerPickerController.selectedDate];
        }
        cell = timeCell;
    }
    else if (indexPath.section == 3)
    {
        AddressTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"addressIdentify"];
        addressCell.scrollAddtress.contentLabel1.text = @"";
        addressCell.delegate = self;
        addressCell.addtress = self.address;
        cell = addressCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = 144.0;
        }
        else if (indexPath.row == 1) {
            height = [PictureTableViewCell cellHeight:self.imagePickerHandler.pictureArray.count];
        }
    }
    else if (indexPath.section == 1) {
        height = 44.0;
    }
    else if (indexPath.section == 2) {
        height = 44.0;
    }
    else if (indexPath.section == 3) {
        height = 44.0;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (TextInputTableViewCell *)textInputTableViewCell
{
    return (TextInputTableViewCell *)[self.billsInputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (PictureTableViewCell *)pictureTableViewCell
{
    return (PictureTableViewCell *)[self.billsInputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

- (VoiceTableViewCell *)voiceTableViewCell
{
    return (VoiceTableViewCell *)[self.billsInputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

- (TimeTableViewCell *)timeTableViewCell
{
    return (TimeTableViewCell *)[self.billsInputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
}

- (NSString *)textInputContent
{
    TextInputTableViewCell *cell = [self textInputTableViewCell];
    return cell.contentTextView.text;
}

- (AddressTableViewCell *)addressTableViewCell
{
    AddressTableViewCell *addressCell = (AddressTableViewCell *)[self.billsInputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    addressCell.scrollAddtress.contentLabel1.text = @"";
    return addressCell;
}

- (NSString *)orderTime
{
    NSString *orderTime = nil;
    if (self.timerPickerController.selectedDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        orderTime = [formatter stringFromDate:self.timerPickerController.selectedDate];
    }
    return orderTime;
}

#pragma mark ImagePickerHandlerDelegate

- (void)didFinishImagePickerHandler:(ImagePickerHandler *)handle
{
    NSIndexPath *pictureIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.billsInputTableView reloadRowsAtIndexPaths:@[pictureIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark VoiceTableViewCellDelegate

- (void)startRecordVoice
{
    [self hideKeyboard];
    [self hideTimerPickerView];
    [self showVoiceInputView];
}

- (void)playVoice:(BOOL)play
{
    if (play) {
        [[AudioManager sharedManager] stopPlaying];
    }else {
        [[AudioManager sharedManager] startPlayingWithPath:self.tempVoiceFilePath delegate:self userinfo:nil continuePlaying:NO];
    }
}

- (void)deleteVoiceRecord
{
    [[AudioManager sharedManager] stopPlaying];
    VoiceTableViewCell *cell = [self voiceTableViewCell];
    [cell hideVoiceRecord];
    [cell stopVoiceAnimation];
    [[NSFileManager defaultManager] removeItemAtPath:self.tempVoiceFilePath error:nil];
    self.tempVoiceFilePath = nil;
}

- (void)voiceDidPlay:(BOOL)play
{
    if (play) {
        if ([self.tempVoiceFilePath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:self.tempVoiceFilePath]) {
            [[AudioManager sharedManager] startPlayingWithPath:self.tempVoiceFilePath delegate:self userinfo:nil continuePlaying:NO];
        }
        else
        {
            VoiceTableViewCell *cell = [self voiceTableViewCell];
            [cell stopVoiceAnimation];
        }
    }
    else
    {
        [[AudioManager sharedManager] stopPlaying];
    }
}

- (void)showVoiceInputView
{
    self.voiceInputBottomConstraint.constant = 0;
}

- (void)hideVoiceInputView
{
    self.voiceInputBottomConstraint.constant = -self.voiceInputController.view.frame.size.height;
}

#pragma mark TimeTableViewCellDelegate

- (void)selectedTime
{
    [self hideKeyboard];
    [self hideVoiceInputView];
    [self hideTimerPickerView];
    [self showTimerPickerView];
}

#pragma mark TimerPickerDelegate

- (void)timerPicker:(TimerPickerViewController *)controller finished:(BOOL)finished
{
    
    if (finished) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日  HH:mm"];
        NSString *dateString = [formatter stringFromDate:controller.selectedDate];
        NSString *msg = [NSString stringWithFormat:@"你确定预约时间为 %@吗？",dateString];
        UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) wself = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wself) strongSelf = wself;
            if (strongSelf) {
                TimeTableViewCell *cell = [strongSelf timeTableViewCell];
                cell.timeLabel.text = dateString;
                [strongSelf hideTimerPickerView];
            }
        }];
        [sheetController addAction:action];

        action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wself) strongSelf = wself;
            if (strongSelf) {
                controller.selectedDate = nil;
                [strongSelf hideTimerPickerView];
            }
        }];
        [sheetController addAction:action];

        [self presentViewController:sheetController animated:YES completion:^{
            
        }];
    }
    else
    {
        [self hideTimerPickerView];
    }
}

- (void)showTimerPickerView
{
    self.timepickerBottomConstraint.constant = 0;
}

- (void)hideTimerPickerView
{
    self.timepickerBottomConstraint.constant = -self.timerPickerController.view.frame.size.height;
}

#pragma mark AddressTableViewCellDelegate

- (void)selectedAddress
{
    CitySelectionViewController *cityView=[[CitySelectionViewController alloc]init];
    cityView.selDelegate = self;
    [self.navigationController pushViewController:cityView animated:YES];
}

#pragma mark CityAddressDelegate

-(void)getSelectCity:(NSDictionary *)cityDict
{
    self.address = cityDict[kAddress];
    self.cityId = cityDict[kCityId];
    AddressTableViewCell *cell = [self addressTableViewCell];
    cell.addtress = self.address;
}

#pragma mark VoiceInputDelegate

- (void)voiceInputDidHide:(VoiceInputViewController *)controller
{
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [self hideVoiceInputView];
}

- (void)voiceRecordingShouldStart {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [[AudioManager sharedManager] stopPlaying];
    
    if ([self.tempVoiceFilePath length] > 0) {
        [self.voiceInputController cancelRecordButtonTouchEvent];
        UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"是否要重新录音？" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) wself = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wself) strongSelf = wself;
            if (strongSelf) {
                [strongSelf deleteVoiceRecord];
            }
        }];
        [sheetController addAction:action];
        
        action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [sheetController addAction:action];
        
        [self presentViewController:sheetController animated:YES completion:nil];
        
    }
    else if (![AudioManager sharedManager].isRecording)
    {
        self.indicatorView.hidden = NO;
        [[AudioManager sharedManager] startRecordingWithDelegate:self];
    }
}

- (void)voicRecordingShouldFinish {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [[AudioManager sharedManager] stopRecording];
    self.indicatorView.hidden = YES;
    [self hideVoiceInputView];
}

- (void)voiceRecordingShouldCancel {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [[AudioManager sharedManager] cancelRecording];
}

- (void)voiceRecordingDidDragoutside {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if ( self.voiceIndicatorController.style != kVoiceIndicatorStyleTooLong)
        [self.voiceIndicatorController setStyle:kVoiceIndicatorStyleCancel];
}

- (void)voiceRecordingDidDraginside {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (self.voiceIndicatorController.style != kVoiceIndicatorStyleTooLong)
        [self.voiceIndicatorController setStyle:kVoiceIndicatorStyleRecord];
}

- (void)voiceRecordingTooShort {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [[AudioManager sharedManager] cancelRecording];
    self.indicatorView.hidden = NO;
    [self.voiceIndicatorController setStyle:kVoiceIndicatorStyleTooShort];
    [UIView animateWithDuration:0.5 animations:^{
        self.indicatorView.hidden = YES;
    }];
}

#pragma mark AudioRecordDelegate

- (void)audioRecordAuthorizationDidGranted {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (self.indicatorView.hidden == NO)
    {
        [self.voiceIndicatorController setStyle:kVoiceIndicatorStyleRecord];
    }
}

//录音开始，此时做一个录音动画
- (void)audioRecordDidStartRecordingWithError:(NSError *)error {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (error) {
        self.indicatorView.hidden = YES;
        return;
    }
}

- (void)audioRecordDidUpdateVoiceMeter:(double)averagePower {
    if (self.indicatorView.hidden == NO) {
        [self.voiceIndicatorController updateMetersValue:averagePower];
    }
}

//移除录音动画
- (void)audioRecordDidFailed {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    if (self.indicatorView.hidden == NO) {
        self.indicatorView.hidden = YES;
    }
}

- (void)audioRecordDidCancelled {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [self audioRecordDidFailed];
}

- (NSTimeInterval)audioRecordMaxRecordTime {
    return 60.0;
}

- (void)audioRecordDurationTooLong {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    [[AudioManager sharedManager] stopRecording];
    
}

//声音录制结束
- (void)audioRecordDidFinishSuccessed:(NSString *)voiceFilePath duration:(CFTimeInterval)duration {
    EMMLogInfo(@"%@",NSStringFromSelector(_cmd));
    self.tempVoiceFilePath = voiceFilePath;
    self.audioDuration = [NSString stringWithFormat:@"%d",(int)duration];
    VoiceTableViewCell *cell = [self voiceTableViewCell];
    [cell showVoiceRecord:[NSString stringWithFormat:@"%ld",(long)duration]];
    if (self.indicatorView.hidden == NO)  {
        if (self.voiceIndicatorController.style == kVoiceIndicatorStyleTooLong) {
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.indicatorView.hidden = YES;
                [strongSelf.voiceInputController cancelRecordButtonTouchEvent];
            });
        }else {
            self.indicatorView.hidden = YES;
        }
    }
    
}

#pragma mark AudioPlayDelegate


- (void)audioPlayDidStarted:(id)userinfo {
    
}

- (void)audioPlayVolumeTooLow {
    [self.voiceIndicatorController setStyle:kVoiceIndicatorStyleVolumeTooLow];
}

- (void)voiceCellDidEndPlaying:(id)userinfo {

    VoiceTableViewCell *cell = [self voiceTableViewCell];
    [cell stopVoiceAnimation];
}

- (void)audioPlayDidFailed:(id)userinfo {
    [self voiceCellDidEndPlaying:userinfo];
}

- (void)audioPlayDidStopped:(id)userinfo {
    [self voiceCellDidEndPlaying:userinfo];
}

- (void)audioPlayDidFinished:(id)userinfo {
    
    [[AudioManager sharedManager] stopPlaying];
    
}

@end
