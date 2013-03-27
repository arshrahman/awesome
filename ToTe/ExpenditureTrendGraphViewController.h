//
//  ExpenditureTrendGraphViewController.h
//  ToTe
//
//  Created by user on 21/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenditureTrendGraphViewController : UIViewController<CPTBarPlotDataSource>

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTBarPlot *Plot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *priceAnnotation;
@property (nonatomic) int ID;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)hideAnnotation:(CPTGraph *)graph;

@end
