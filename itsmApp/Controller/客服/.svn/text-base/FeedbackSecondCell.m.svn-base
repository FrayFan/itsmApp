//
//  FeedbackSecondCell.m
//  itsmApp
//
//  Created by admin on 2016/12/14.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FeedbackSecondCell.h"
#import "UIView+ViewController.h"
#import "UIView+Additions.h"
#import "ImageViewCollectionViewCell.h"
#import "common.h"
#define Gap 15

#define MaxImage 3

#define MAX_LIMIT_NUMS 180

@interface FeedbackSecondCell ()<UIActionSheetDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation FeedbackSecondCell

+ (CGFloat)collectionViewCellHeight
{
    CGFloat height = (KScreenWidth-4*Gap)/3;
    
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _collectionView = [self viewWithTag:540];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"COLLECTVIEWCELL"];
    [_collectionView reloadData];
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideWaterLable:) name:UIKeyboardWillShowNotification object:nil];
}

//隐藏水印文字
- (void)hideWaterLable:(NSNotification *)notification
{
    _promptLable.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.lbNums.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *picArray = self.imagePickerHandler.pictureArray;
    if (picArray.count < MaxImage) {
        
        return picArray.count+1;
    }else{
        
        for (int a = 0; a< picArray.count; a++) {
            
            if (a>2) {
                [picArray removeObject:picArray[a]];
            }
    }
        return MIN(picArray.count, MaxImage);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCollectionViewCell *cell = (ImageViewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"COLLECTVIEWCELL" forIndexPath:indexPath];
    
    if (indexPath.row == self.imagePickerHandler.pictureArray.count) {
        cell.picutreImageView.image = [UIImage imageNamed:@"add_bigPic"];
    }
    else
    {
        cell.picutreImageView.image = self.imagePickerHandler.pictureArray[indexPath.row];
    }
    
    
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.feedbackTextView resignFirstResponder];
    if (indexPath.row == self.imagePickerHandler.pictureArray.count) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
        [sheet showInView:self.viewController.view];
    } else { // preview photos or video / 预览照片或者视频
        [self.imagePickerHandler previewPictureAtIndex:indexPath.row];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // take photo / 去拍照
        [self.imagePickerHandler takePhoto];
    } else if (buttonIndex == 1) {
        [self.imagePickerHandler pushImagePickerController];
    }
    
}

-(void)setImagePickerHandler:(ImagePickerHandler *)imagePickerHandler
{
    _imagePickerHandler = imagePickerHandler;
    
    NSMutableArray *picArray = _imagePickerHandler.pictureArray;
    for (int a = 0; a< picArray.count; a++) {
        
        if (a>2) {
            [picArray removeObject:picArray[a]];
        }

    }
    _imagePickerHandler.pictureArray = picArray;
    [_collectionView reloadData];
}


@end
