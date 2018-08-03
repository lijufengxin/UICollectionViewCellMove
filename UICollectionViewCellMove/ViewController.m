//
//  ViewController.m
//  UICollectionViewCellMove
//
//  Created by fengxin on 2018/8/3.
//  Copyright © 2018年 fengxin. All rights reserved.
//

#import "ViewController.h"
#import "FXCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.array =  [NSMutableArray arrayWithObjects:@"tag1", @"tag2", @"tag3", @"tag4",
     @"tag5", @"tag6", @"tag7", @"tag8",
     @"tag9", @"tag10", @"tag11", @"tag12",@"tag13", @"tag14", @"tag15", @"tag16",
     @"tag17", @"tag18", @"tag19", @"tag20",  nil];
    [self.view addSubview:self.collectionView];
    
    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
            FXCollectionViewCell *cell = (FXCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
            cell.deleteButton.hidden = NO;
            cell.deleteButton.tag = selectIndexPath.item;
            [cell.deleteButton  addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
            [_collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            
        }
            break;
           case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            [self.collectionView  cancelInteractiveMovement];
            break;
    }
}



- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0){
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0){
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
    // 找到当前的cell
    FXCollectionViewCell *cell = (FXCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
    cell.deleteButton.hidden = YES;
    id objc = [self.array objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.array removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [self.array insertObject:objc atIndex:destinationIndexPath.item];
    [self.collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
    
}

#pragma mark---UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentiifer" forIndexPath:indexPath];
    cell.markLabel.text = self.array[indexPath.item];
    cell.deleteButton.hidden = YES;
    
    return cell;
}


#pragma mark---UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.array[indexPath.item]);
}




//懒加载
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.frame.size.width/4 - 10, 55);
        layout.footerReferenceSize = CGSizeMake(0, 0);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.height - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        [_collectionView registerClass:[FXCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentiifer"];
    }
    return _collectionView;
}


- (void)btnDelete:(UIButton *)btn{
    //cell的隐藏删除设置
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
    // 找到当前的cell
    FXCollectionViewCell *cell = (FXCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
    cell.deleteButton.hidden = NO;
    //取出源item数据
    id objc = [self.array objectAtIndex:btn.tag];
    //从资源数组中移除该数据
    [self.array removeObject:objc];
    [self.collectionView reloadData];
    
}


@end
