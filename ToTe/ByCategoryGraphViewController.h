//
//  ByWeekGraphViewController.h
//  ToTe
//
//  Created by Pol on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByCategoryGraphViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *ExpendPlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;
@property (nonatomic) int ID;
@property (nonatomic) int categoryID;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
//-(void)configureLegend;
-(void)hideAnnotation:(CPTGraph *)graph;
//-(NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index;
@end
