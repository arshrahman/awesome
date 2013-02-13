//
//  ByWeekGraphViewController.h
//  ToTe
//
//  Created by Pol on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByWeekGraphViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *aaplPlot;
@property (nonatomic, strong) CPTBarPlot *googPlot;
@property (nonatomic, strong) CPTBarPlot *msftPlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)hideAnnotation:(CPTGraph *)graph;
@end
