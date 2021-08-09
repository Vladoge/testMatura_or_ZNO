//
//  MainTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "MainTVC.h"

#define numberOfFreeVariants 3

@interface MainTVC ()

@property (strong, nonatomic) NSMutableArray* arrayReduceVariant;
@property (assign, nonatomic) BOOL loadingData;
@property (assign, nonatomic) BOOL isBuyProduct;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation MainTVC

@synthesize isBuyProduct = _isBuyProduct;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initialSetupController];
    
    if ([Utilities isInternetConnection]) {
        [self getReduceVariantsFromServer];
    } else {
        [self reactionToDisconnectFromNetwork:[Utilities isInternetConnection]];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Server

-(void) getReduceVariantsFromServer
{
    
    ANDispatchBlockToMainQueue(^{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.HUD show:YES];
        self.view.userInteractionEnabled = NO;
    });

    [[ServerManager sharedManager] getListReduceVariants:^(NSArray *arrayReduceVariants) {
        [self setupArrReduceVariants:arrayReduceVariants];
        
    } onFailure:^(NSError *errorBlock, NSInteger statusCode, NSArray *localReduceVariants) {
        [self setupArrReduceVariants:localReduceVariants];
    }];
}

#pragma mark - Server Helpers Methods

-(void) setupArrReduceVariants:(NSArray*) arrReduceVar {
    [self fillArrayWithObjectFromServer:arrReduceVar];
    [self.HUD hide:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    ANDispatchBlockAfter(0.35f, ^{
        self.view.userInteractionEnabled = YES;
    });
}

#pragma mark - RefreshControl

- (void) refreshVariants:(UIRefreshControl *)refreshControl {
    [self reloadData];
}

- (void)reloadData
{
    [self.arrayReduceVariant removeAllObjects];
    [self.tableView reloadData];
    
    [self getReduceVariantsFromServer];
    
    // End the refreshing
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Action

- (void) fillArrayWithObjectFromServer:(NSArray*) arrayVariants {
    
    if ([arrayVariants count] > 0) {
        self.arrayReduceVariant = [NSMutableArray new];
        [self.arrayReduceVariant addObjectsFromArray:arrayVariants];
        
        NSMutableArray* newPaths = [NSMutableArray array];
        for (int i = (int)[self.arrayReduceVariant count] - (int)[arrayVariants count]; i < [self.arrayReduceVariant count]; i++){
            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        ANDispatchBlockToMainQueue(^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        });
        self.loadingData = NO;
    }
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayReduceVariant count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if(indexPath.row >= numberOfFreeVariants && self.isBuyProduct == NO)
    {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Buy" actionBlock:^(void) {

            [self allowCommunicationWithTableAndView:NO withAfterTime:0.f];
            [self showPurchaseAlert];
        }];

        UIImage* img = [UIImage imageNamed:@"math(Base)-Icon-180"];
        [alert showCustom:img color:[UIColor flatGreenColor] title:@"Preparing to buy" subTitle:@"Open access to all options?" closeButtonTitle:@"Cancel" duration:0.0f];
     
    } else {
            ReduceVariant* varinantModel = nil;
            
            if (self.arrayReduceVariant[indexPath.row])
                varinantModel = [self.arrayReduceVariant objectAtIndex:indexPath.row];
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            ExecutionTestTVC* executionTVC = (ExecutionTestTVC*)[storyboard instantiateViewControllerWithIdentifier:@"ExecutionTestTVC"];
            executionTVC.linkOnFullVariantModel = varinantModel.linkOnFullVariant;
            [self.navigationController pushViewController:executionTVC animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    ANDispatchBlockToBackgroundQueue(^{
       
        ReduceVariant* varinantModel = nil;
        UIFont* someFont = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.f];
        
        if (self.arrayReduceVariant[indexPath.row]){
            varinantModel = [self.arrayReduceVariant objectAtIndex:indexPath.row];
        }
        
        if (varinantModel) {
            UITableViewCell* varinatCell = (UITableViewCell*)cell;
            ANDispatchBlockToMainQueue(^{
                [varinatCell.textLabel setFont:someFont];
                 varinatCell.textLabel.text = varinantModel.variantName;
                //[self setHiddienStatusAllPropertyCell:NO withCell:cell];
                
                //#warning Color ! - Цвет пока оставим
                if(indexPath.row >= numberOfFreeVariants && self.isBuyProduct == NO){
                    // #EBEBEB
                      varinatCell.backgroundColor = [UIColor colorWithHexString:@"#FAFAF8"];
                      varinatCell.textLabel.textColor = [UIColor lightGrayColor];
                } else {
                    varinatCell.backgroundColor = [UIColor whiteColor];
                    varinatCell.textLabel.textColor = [UIColor blackColor];
                }
            });
        }
        
      
    });
}

-(void) setHiddienStatusAllPropertyCell:(BOOL) isHidden withCell:(id) cell
{
    if([cell isKindOfClass:[UITableViewCell class]]){
        UITableViewCell* varinatCell = (UITableViewCell*)cell;
        varinatCell.textLabel.hidden = isHidden;
    }
}


#pragma mark - Other

-(void) reactionToDisconnectFromNetwork:(BOOL) isConnectToNetwork {
    
    if (!isConnectToNetwork) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        SCLAlertView* alert = [[SCLAlertView alloc] init];

        [alert addButton:@"Ok" target:nil selector:nil];

        [alert addButton:@"Download local copy"
                  target:self
                selector:@selector(getReduceVariantsFromServer)];
        
        [alert showError:self title:@"Error" subTitle:@"Internet connections" closeButtonTitle:nil duration:0.f];
    }
}

-(void) initialSetupController
{
    
    self.loadingData = YES;
    //_isBuyProduct = ([[MKStoreKit sharedKit] isProductPurchased:IAP_AllVariants]) ? YES : NO;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor flatGrayColor];
    self.refreshControl.tintColor       = [UIColor whiteColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshVariants:)
                  forControlEvents:UIControlEventValueChanged];
   
     // Device Orientation
     UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   
    if ((orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self redrawingNavBar:[Utilities getFrameStatusBarWithNavBar:self.navigationController.navigationBar]];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self redrawingNavBar:self.navigationController.navigationBar.bounds];
    }

    UIImage *image = [UIImage imageNamed:@"info"];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(goToInfoTVC:)];

    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = button;

    
    // Initialize the MBProgressHUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.HUD.labelText        = @"Loading Variants...";
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.HUD];
}


- (void) goToInfoTVC:(UIButton*) sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoAppTVC* vc  = (InfoAppTVC*)[storyboard instantiateViewControllerWithIdentifier:@"InfoAppTVC"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) redrawingNavBar:(CGRect) frameForDrawing {
        
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];

    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                          withFrame:frameForDrawing
                          andColors:@[[UIColor flatGreenColor],[UIColor flatGreenColorDark]]];

    
    
    // Устанавливаем противоположенный цвет тектсу в navBar
    NSDictionary* titleTextAttributesDict = @{NSForegroundColorAttributeName : [UIColor colorWithContrastingBlackOrWhiteColorOn: self.navigationController.navigationBar.barTintColor isFlat:NO],
                                              NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:21]};
    [self.navigationController.navigationBar setTitleTextAttributes: titleTextAttributesDict];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ((orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self redrawingNavBar:[Utilities getFrameStatusBarWithNavBar:self.navigationController.navigationBar]];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self redrawingNavBar:self.navigationController.navigationBar.bounds];
    }
    
}

- (void) allowCommunicationWithTableAndView:(BOOL) permission withAfterTime:(CGFloat) timeInSeconds{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = !permission;
    /*
    if(!permission){
        self.HUD.labelText        = @"Подготовка к покупке...";
    } else {
        self.HUD.labelText        = @"Загрузка Вариантов...";
    }
    [self.HUD show:!permission];
    */
    ANDispatchBlockAfter(timeInSeconds, ^{
        self.view.userInteractionEnabled = permission;
    });
}

#pragma mark - Helpers

- (void) showPurchaseAlert
{
    [self presentAlertVCwithTitle:@"Buy premium access?" message:@"Press \"Buy\" to make a purchase" buttonTitle:@"Buy" buttonHandler:^(UIAlertAction *action) {
        self.isBuyProduct = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Premium access is open" message:@"The purchase was successful" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"ок" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self allowCommunicationWithTableAndView:YES withAfterTime:0.1f];
            [self.tableView reloadData];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


- (void) presentAlertVCwithTitle:(NSString*)title
                         message:(nullable NSString*)message
                     buttonTitle:(nullable NSString*)buttonTitle
                   buttonHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self allowCommunicationWithTableAndView:YES withAfterTime:0.1f];
    }];
    [alert addAction:cancel];

    if (buttonTitle){
        UIAlertAction *button = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:handler];
        [alert addAction:button];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getters/Setters

- (BOOL) isBuyProduct
{
    if (_isBuyProduct){
        return _isBuyProduct;
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isBuyProduct"];
}


- (void)setIsBuyProduct:(BOOL)isBuyProduct
{
    _isBuyProduct = isBuyProduct;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isBuyProduct forKey:@"isBuyProduct"];
}



@end
