//
//  ViewController.m
//  TESTT_mac
//
//  Created by sycf_ios on 2017/3/29.
//  Copyright © 2017年 shibiao. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSClipView *clipView;
/**
 480
 270
 */
@property (weak) IBOutlet NSView *floatView;
@property (weak) IBOutlet NSTableView *floatTableView;
@property (weak) IBOutlet NSScroller *oneScroller;

@property (weak) IBOutlet NSScrollView *floatScrollView;

@property (nonatomic,strong) NSTableRowView *row1;
@property (nonatomic,strong) NSTableRowView *row2;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setPostsFrameChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsDidChangeNotification:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[_scrollView contentView]];
    [self.floatScrollView setPostsFrameChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(floatBoundsDidChangeNotification:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[_floatScrollView contentView]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScroll:) name:NSScrollViewDidLiveScrollNotification object:nil];
    [self.view.window setContentSize:NSMakeSize(800, 600)];
    [self.oneScroller setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.oneScroller positioned:NSWindowAbove relativeTo:self.view];
    [self.oneScroller.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
    self.floatTableView.intercellSpacing = NSMakeSize(0, 0);
    self.tableView.intercellSpacing = self.floatTableView.intercellSpacing;
    
}
-(void)viewWillAppear{
    [super viewWillAppear];
    self.floatView.wantsLayer = YES;
    self.floatView.layer.backgroundColor = [NSColor colorWithRed:0.58 green:0.57 blue:0.58 alpha:0.8].CGColor;
    self.floatScrollView.frame = NSMakeRect(self.floatTableView.frame.origin.x, 0, self.floatTableView.frame.size.width, self.floatTableView.frame.size.height);
    self.scrollView.frame = NSMakeRect(self.tableView.frame.origin.x, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void)boundsDidChangeNotification:(NSNotification*) notification
{
    NSRect visibleRect = [[_scrollView contentView] documentVisibleRect];
    NSPoint currentScrollPosition = visibleRect.origin;
    [self.floatScrollView.contentView scrollToPoint:NSMakePoint(self.floatScrollView.frame.origin.x, currentScrollPosition.y)];
    
}
-(void)floatBoundsDidChangeNotification:(NSNotification *)notification{
    NSRect floatVisibleRect = self.floatScrollView.contentView.documentVisibleRect;
    NSPoint floatScrollPosition = floatVisibleRect.origin;
    [self.scrollView.contentView scrollToPoint:floatScrollPosition];
}
-(void)tableViewScroll:(NSNotification *)notification{
        
//    NSLog(@"%@",NSStringFromSize(self.scrollView.contentSize));
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 15;
}
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"shi"]) {
        return [NSString stringWithFormat:@"%ld",(long)row];
    }
    return [NSString stringWithFormat:@"%ld",(long)row];
}
- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes{
    self.row1.backgroundColor = [NSColor clearColor];
    self.row2.backgroundColor = [NSColor clearColor];
    NSLog(@"return proposedSelectionIndexes:%@", proposedSelectionIndexes);
    if ([tableView isEqual: self.tableView]) {
        [self.floatTableView selectRowIndexes:proposedSelectionIndexes byExtendingSelection:NO];
        self.row1 = [self.floatTableView viewAtColumn:0 row:proposedSelectionIndexes.firstIndex makeIfNecessary:YES];
        self.row1.backgroundColor = [NSColor colorWithRed:0.06 green:0.42 blue:0.84 alpha:1.00];
        self.row2 = [self.floatTableView viewAtColumn:1 row:proposedSelectionIndexes.firstIndex makeIfNecessary:YES];
        self.row2.backgroundColor = [NSColor colorWithRed:0.06 green:0.42 blue:0.84 alpha:1.00];
        return proposedSelectionIndexes;
    }
    [self.tableView selectRowIndexes:proposedSelectionIndexes byExtendingSelection:NO];
    return proposedSelectionIndexes;
}
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
