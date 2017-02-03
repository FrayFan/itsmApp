//
//  SecondVoiceCell.m
//  itsmApp
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "SecondVoiceCell.h"
#import "GetDownLoadHandle.h"
#import "AudioManager.h"

@interface SecondVoiceCell ()<NSURLSessionDownloadDelegate,AudioPlayDelegate>

@property (strong,nonatomic) GetDownLoadHandle *voiceLoadHandle;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *record;
@property (copy,nonatomic) NSString *voiceFilePath;
@property (assign,nonatomic) BOOL isPlay;

- (IBAction)playVoice:(id)sender;

@end

@implementation SecondVoiceCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopVoicePlay" object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_playButton setBackgroundImage:[UIImage imageNamed:@"voiceBg"] forState:UIControlStateNormal];
    _record.animationImages = @[[UIImage imageNamed:@"VoiceNodePlaying001"],
                                      [UIImage imageNamed:@"VoiceNodePlaying002"],
                                      [UIImage imageNamed:@"VoiceNodePlaying003"]];
    _record.animationDuration = 1;
    
    _isPlay = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingVoice) name:@"StopVoicePlay" object:nil];
}

- (void)sendVoiceRequest
{
    //发送下载语音请求
    _voiceLoadHandle = [[GetDownLoadHandle alloc]init];
    
    if ([_voiceDetailModel.voidceURL isKindOfClass:[NSArray class]]) {
        NSDictionary *voiceDic = _voiceDetailModel.voidceURL[0];
        _voiceLoadHandle.filePath = [voiceDic valueForKey:@"audio"];
        NSString *voiceURL = [self getAllPathWithBaseURL:_voiceLoadHandle.dataPath];
        [self downLoadVoiceTaskWithURL:voiceURL];
    }
    
}


- (void)downLoadVoiceTaskWithURL:(NSString *)URL
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",location);
        
        NSString *filePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/voice%@.amr",_voiceDetailModel.receiptId]];
        NSURL *toURL = [NSURL fileURLWithPath:filePath];
        
        //将文件拷贝到指定的文件路径下
        BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtURL:location toURL:toURL error:nil];
        
        if (isSuccess) {
            
            NSLog(@"文件下载保存成功");
        }else{
            
            NSLog(@"保存失败");
        }
        
    }];
    
    [task resume];
    
}

#pragma mark  NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}


-(void)setVoiceDetailModel:(DetailModel *)voiceDetailModel
{
    _voiceDetailModel = voiceDetailModel;
    _timeLable.text = [NSString stringWithFormat:@"%@\"",_voiceDetailModel.voiceDuration];
    
    if (_voiceDetailModel&&!_voiceFilePath) {
        
        NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *docDir = [paths objectAtIndex:0];
        _voiceFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"voice%@.amr",_voiceDetailModel.receiptId]];
        
        [self sendVoiceRequest];
    }
}

- (NSString *)getAllPathWithBaseURL:(NSString *)dataPath
{
    NetworkingManager *netManager = [NetworkingManager share];
    NSString *dataURL = [NSString stringWithFormat:@"%@/%@",netManager.httpManager.internetBaseURL,dataPath];
    return dataURL;
}

- (IBAction)playVoice:(id)sender {
    
     AudioManager *manager = [AudioManager sharedManager];
    
    if (_isPlay) {
        [manager startPlayingWithPath:_voiceFilePath delegate:self userinfo:nil continuePlaying:YES];
        [_record startAnimating];
        
    }else{
        [manager stopPlaying];
        [_record stopAnimating];
    }
    _isPlay = !_isPlay;
}

#pragma mark - AudioPlayDelegate
- (void)audioPlayDidFinished:(id)userinfo
{
    if (!_isPlay == YES) {
        _isPlay = YES;
        [_record stopAnimating];
    }
    
}

- (void)stopPlayingVoice
{
    if (!_isPlay) {
        [self playVoice:_playButton];
    }
}


@end
