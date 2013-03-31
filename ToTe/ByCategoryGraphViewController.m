//
//  ByWeekGraphViewController.m
//  ToTe
//
//  Created by Pol on 13/2/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "ByCategoryGraphViewController.h"
#import "CPDStockPriceStore.h"
#import "CPDConstants.h"
#import "Category.h"

@interface ByCategoryGraphViewController ()
{
    NSMutableArray *categoryList;
    Category *c;
}

@end

@implementation ByCategoryGraphViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 1.0f;

@synthesize hostView    = hostView_;
@synthesize ExpendPlot = ExpendPlot_;
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
    c = [[Category alloc]init];
    categoryList = [[NSMutableArray alloc]init];
    
    for(Category *cc in [c SelectAllCategory])
    {
        if(cc.category_id == self.categoryID)
        {
            c = cc;
        }
        
        [categoryList addObject:cc];
    }
    
    NSLog(@"%d", self.categoryID);
    NSLog(@"%@", c.category_name);
}

-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    //[self configureLegend];
}

-(void)configureGraph
{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    graph.paddingBottom = 25.0f;
    graph.paddingLeft  = 25.0f;
    graph.paddingTop    = 25.0f;
    graph.paddingRight  = 25.0f;
    
    
    // 2 - Set graph title
    NSString *title = c.category_name;
    graph.title = title;
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:10.0f];
    [graph.plotAreaFrame setPaddingBottom:10.0f];
    [graph.plotAreaFrame setPaddingTop:10.0f];
    
    // 5 - Set up plot space
    //CGFloat xMin = 0.0f;
    //CGFloat xMax = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    
    //CGFloat yMin = 0.0f;
    //CGFloat yMax = 1000.0f;  // should determine dynamically based on max price
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    /*
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(0.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(0.0f)];
    */
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(2.0f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(600.0f)];
    plotSpace.yRange = yRange;
}
/*
-(CGPoint)plotSpace:(CPTXYPlotSpace *)space willDisplaceBy:(CGPoint)proposedDisplacementVector
{
    CGFloat x = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    
    return CGPointMake(x, 0);
}
*/

-(void)configurePlots
{
    //CPTGraph *graph = self.hostView.hostedGraph;
    //CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    // 1 - Set up the three plots
    //self.aaplPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:0.888 green:0.207 blue:0.271 alpha:1] horizontalBars:NO];
    self.ExpendPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor cyanColor] horizontalBars:NO];
    self.ExpendPlot.identifier = CPDTickerSymbolCategoryExpend;
    self.ExpendPlot.title = @"Category Expend";
    /*
    self.googPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    self.googPlot.identifier = CPDTickerSymbolGOOG;
    self.msftPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    self.msftPlot.identifier = CPDTickerSymbolMSFT;
    */
    
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor whiteColor];
    barLineStyle.lineWidth = 0.5;
    
    // 3 - Add plots to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    
    NSArray *plots = [NSArray arrayWithObjects:self.ExpendPlot,
                      nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        //plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
}

-(void)configureAxes
{
    // 1 - Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    //CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    //axisLineStyle.lineWidth = 1.0f;
    //axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    //Important!
    
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = @"Weeks";
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 160.0f;
    //axisSet.xAxis.axisLineStyle = axisLineStyle;
    
    CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 1;
    for (NSString *date in [[CPDStockPriceStore sharedInstance] EightWeek:self.ID]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:axisSet.xAxis.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = axisSet.xAxis.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    axisSet.xAxis.axisLabels = xLabels;
    axisSet.xAxis.majorTickLocations = xLocations;
    
    // 4 - Configure the y-axis
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.title = @"Price (in dollar)";
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 80.0f;
    //axisSet.yAxis.axisLineStyle = axisLineStyle;
    NSInteger majorIncrement = 50;
    NSInteger minorIncrement = 10;
    //get the highest amount
    CGFloat yMax = 0;
    
    NSDecimalNumber *a3 = 0;
    NSDecimalNumber *b3 = 0;
    NSArray *checkAmount3 = [[CPDStockPriceStore sharedInstance] weeklyExpendByCategory:CPDTickerSymbolCategoryExpend :self.ID:self.categoryID ];
    if(checkAmount3.count != 0)
    {
        for (NSInteger i = 0; i < checkAmount3.count; i ++) {
            //check
            b3 = [checkAmount3 objectAtIndex:i];
            if(a3 < b3)
            {
                a3 = b3;
            }
        }
        
        yMax = [a3 doubleValue]*20;
    }
    else
    {
        yMax = 100.0f;
    }
    
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
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:axisSet.yAxis.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = axisSet.yAxis.majorTickLength -axisSet.yAxis.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    axisSet.yAxis.axisLabels = yLabels;
    axisSet.yAxis.majorTickLocations = yMajorLocations;
    axisSet.yAxis.minorTickLocations = yMinorLocations;
}

-(void)hideAnnotation:(CPTGraph *)graph {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    switch (fieldEnum) {
        case CPTBarPlotFieldBarTip:
            if ([plot.identifier isEqual:CPDTickerSymbolCategoryExpend]) {
                
                return [[[CPDStockPriceStore sharedInstance] weeklyExpendByCategory:CPDTickerSymbolCategoryExpend :self.ID:self.categoryID] objectAtIndex:index];
            }
            break;
    }
    
    return [NSDecimalNumber zero];

    /*
    if (fieldEnum == CPTBarPlotFieldBarTip)
    {
        if(index < [[[CPDStockPriceStore sharedInstance] EightWeek:self.ID] count]) {
            
            return [NSDecimalNumber numberWithUnsignedInteger:index];
        }
        
        if ([plot.identifier isEqual:CPDTickerSymbolCategoryExpend]) {
            
        return [[[CPDStockPriceStore sharedInstance] weeklyExpendByCategory:CPDTickerSymbolCategoryExpend :self.ID:self.categoryID] objectAtIndex:index];
        }
    }
    
    return [NSDecimalNumber zero];
     */
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    // 1 - Is the plot hidden?
    if (plot.isHidden == YES) {
        return;
    }
    // 2 - Create style, if necessary
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color= [CPTColor whiteColor];
        style.fontSize = 15.0f;
        style.fontName = @"Helvetica-Bold";
    }
    // 3 - Create annotation, if necessary
    NSNumber *price = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
    if (!self.priceAnnotation) {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.priceAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    }
    // 4 - Create number formatter, if needed
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
    }
    
    // 5 - Create text layer for annotation
    NSString *priceValue = [formatter stringFromNumber:price];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:priceValue style:style];
    self.priceAnnotation.contentLayer = textLayer;
    
    // 6 - Get plot index based on identifier
    NSInteger plotIndex = 0;
    if ([plot.identifier isEqual:CPDTickerSymbolCategoryExpend] == YES) {
        plotIndex = 0;
    }
    /*else if ([plot.identifier isEqual:CPDTickerSymbolGOOG] == YES) {
        plotIndex = 1;
    }
    else if ([plot.identifier isEqual:CPDTickerSymbolMSFT] == YES) {
        plotIndex = 2;
    }*/
    
    // 7 - Get the anchor point for annotation
    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [price floatValue] + 40.0f;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.priceAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    // 8 - Add the annotation 
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.priceAnnotation];
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
/*
-(NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    if ([barPlot.identifier isEqual:CPDTickerSymbolCategoryExpend] ==YES) {
        
        //return [[[CPDStockPriceStore sharedInstance] weeklyExpendByCategory:CPDTickerSymbolCategoryExpend :self.ID:self.categoryID] objectAtIndex:index];
        return @"Expend";
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
 */
@end
