//
//  ExpenditureTrendGraphViewController.m
//  ToTe
//
//  Created by user on 21/3/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ExpenditureTrendGraphViewController.h"
#import "CPDStockPriceStore.h"
#import "CPDConstants.h"


@interface ExpenditureTrendGraphViewController ()

@end

@implementation ExpenditureTrendGraphViewController

CGFloat const CPDBarWidth2 = 0.25f;
CGFloat const CPDBarInitialX2 = 0.35f;

@synthesize hostView    = hostView_;
@synthesize Plot = Plot_;
@synthesize priceAnnotation = priceAnnotation_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController lifecycle methods
-(void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:CPDTickerSymbolExpend] == YES) {
                return [[[CPDStockPriceStore sharedInstance] weeklyExpend:CPDTickerSymbolExpend :self.ID] objectAtIndex:index];
            }
            
            else if ([plot.identifier isEqual:CPDTickerSymbolSaving] == YES) {
                return [[[CPDStockPriceStore sharedInstance] weeklySaving:CPDTickerSymbolSaving :self.ID] objectAtIndex:index];
            }
            break;
    }
    return [NSDecimalNumber zero];
}

- (void)viewDidUnload {
    [self setHostView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Check graph");
    [self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self configureLegend];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    graph.paddingBottom = 25.0f;
    graph.paddingLeft  = 25.0f;
    graph.paddingTop    = 25.0f;
    graph.paddingRight  = 25.0f;
    
    // 2 - Set graph title
    //NSString *title = @"";
    //graph.title = title;
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:0.0f];
    [graph.plotAreaFrame setPaddingBottom:0.0f];
    
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(10.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.5f) length:CPTDecimalFromFloat(10.0f)];
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // 2 - Create the three plots
    /*
    CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
    aaplPlot.dataSource = self;
    aaplPlot.identifier = CPDTickerSymbolAAPL;
    CPTColor *aaplColor = [CPTColor redColor];
    [graph addPlot:aaplPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *googPlot = [[CPTScatterPlot alloc] init];
    googPlot.dataSource = self;
    googPlot.identifier = CPDTickerSymbolGOOG;
    CPTColor *googColor = [CPTColor greenColor];
    [graph addPlot:googPlot toPlotSpace:plotSpace];
    */
    CPTScatterPlot *expendPlot = [[CPTScatterPlot alloc] init];
    expendPlot.dataSource = self;
    expendPlot.identifier = CPDTickerSymbolExpend;
    expendPlot.title = @"Expend";
    CPTColor *expendColor = [CPTColor redColor];
    [graph addPlot:expendPlot toPlotSpace:plotSpace];
    
    CPTScatterPlot *savingPlot = [[CPTScatterPlot alloc] init];
    savingPlot.dataSource = self;
    savingPlot.identifier = CPDTickerSymbolSaving;
    savingPlot.title = @"Saving";
    CPTColor *savingColor = [CPTColor greenColor];
    [graph addPlot:savingPlot toPlotSpace:plotSpace];
    
    /*
    CPTScatterPlot *msftPlot = [[CPTScatterPlot alloc] init];
    msftPlot.dataSource = self;
    msftPlot.identifier = CPDTickerSymbolMSFT;
    CPTColor *msftColor = [CPTColor blueColor];
    [graph addPlot:msftPlot toPlotSpace:plotSpace];
     */
    
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:expendPlot,
                                savingPlot,
                                nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(2.5f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.0f)];
    plotSpace.yRange = yRange;
    
    // 4 - Create styles and symbols
    CPTMutableLineStyle *expendLineStyle = [expendPlot.dataLineStyle mutableCopy];
    expendLineStyle.lineWidth = 1.5;
    expendLineStyle.lineColor = expendColor;
    expendPlot.dataLineStyle = expendLineStyle;
    CPTMutableLineStyle *expendSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    expendSymbolLineStyle.lineColor = expendColor;
    CPTPlotSymbol *expendSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    expendSymbol.fill = [CPTFill fillWithColor:expendColor];
    expendSymbol.lineStyle = expendSymbolLineStyle;
    expendSymbol.size = CGSizeMake(6.0f, 6.0f);
    expendPlot.plotSymbol = expendSymbol;
    
    CPTMutableLineStyle *savingLineStyle = [savingPlot.dataLineStyle mutableCopy];
    savingLineStyle.lineWidth = 1.0;
    savingLineStyle.lineColor = savingColor;
    savingPlot.dataLineStyle = savingLineStyle;
    CPTMutableLineStyle *savingSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    savingSymbolLineStyle.lineColor = savingColor;
    CPTPlotSymbol *savingSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    savingSymbol.fill = [CPTFill fillWithColor:savingColor];
    savingSymbol.lineStyle = savingSymbolLineStyle;
    savingSymbol.size = CGSizeMake(6.0f, 6.0f);
    savingPlot.plotSymbol = savingSymbol;
}

-(void)configureAxes {
    
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor redColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor redColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor redColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor redColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Weeks";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = -30.0f;
    //x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    //x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (NSString *date in [[CPDStockPriceStore sharedInstance] EightWeek:self.ID]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Price (in dollar)";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -75.0f;
    //y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    //y.labelTextStyle = axisTextStyle;
    y.labelOffset = 25.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    //get the highest amount
    CGFloat yMax;
    NSDecimalNumber *a = 0;
    NSDecimalNumber *b = 0;
    NSArray *checkAmount = [[CPDStockPriceStore sharedInstance] weeklyExpend:CPDTickerSymbolExpend :self.ID ];
    if(checkAmount.count != 0)
    {
        for (NSInteger i = 0; i < checkAmount.count; i ++) {
            //check
            b = [checkAmount objectAtIndex:i];
            if(a < b)
            {
                a = b;
            }
        }
    }
    
    NSDecimalNumber *a2 = 0;
    NSDecimalNumber *b2 = 0;
    NSArray *checkAmount2 = [[CPDStockPriceStore sharedInstance] weeklySaving:CPDTickerSymbolSaving :self.ID ];
    if(checkAmount2.count != 0)
    {
        for (NSInteger i = 0; i < checkAmount2.count; i ++) {
            //check
            b2 = [checkAmount2 objectAtIndex:i];
            if(a2 < b2)
            {
                a2 = b2;
            }
        }
    }
    NSLog(@"%@ check - ",a);
    NSLog(@"%@ check - ",a2);
    if([a doubleValue] > [a2 doubleValue])
    {
        yMax = [a doubleValue]*10;
        if(yMax > 5000)
        {
            yMax = [a doubleValue] * 2;
        }
    }
    else
    {
        yMax = [a2 doubleValue]*10;
        if(yMax > 5000)
        {
            yMax = [a2 doubleValue] * 2;
        }
    }
    
    NSInteger majorIncrement = 0;
    NSInteger minorIncrement = 0;
    
    if(yMax < 50)
    {
        majorIncrement = 10;
        minorIncrement = 10;
    }
    else if(yMax > 100 && yMax < 500)
    {
        majorIncrement = 50;
        minorIncrement = 10;
    }
    else if(yMax > 500)
    {
        majorIncrement = 100;
        minorIncrement = 50;
    }
    else if(yMax > 1000)
    {
        majorIncrement = 500;
        minorIncrement = 100;
    }
    else if(yMax > 5000)
    {
        majorIncrement = 1000;
        minorIncrement = 500;
    }
    else
    {
        majorIncrement = 100;
        minorIncrement = 50;
    }
    
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

-(NSString *)legendTitle:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index {
    //if (index < [[[CPDStockPriceStore sharedInstance] tickerSymbols] count]) {
        //return [[[CPDStockPriceStore sharedInstance] tickerSymbols] objectAtIndex:index];
    //}
    if ([plot.identifier isEqual:CPDTickerSymbolExpend] == YES) {
        return [[[CPDStockPriceStore sharedInstance] weeklyExpend:CPDTickerSymbolExpend :self.ID] objectAtIndex:index];
    }
    
    else if ([plot.identifier isEqual:CPDTickerSymbolSaving] == YES) {
        return [[[CPDStockPriceStore sharedInstance] weeklySaving:CPDTickerSymbolSaving :self.ID] objectAtIndex:index];
    }
    return @"N/A";
}

-(void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorTopRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / 10);
    graph.legendDisplacement = CGPointMake(legendPadding, -35.0);
}

@end
