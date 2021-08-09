//
//  InfoAppTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "InfoAppTVC.h"

@interface InfoAppTVC ()

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) InfoTVC_Model* currentModel;

@end

@implementation InfoAppTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    
    if ([Utilities isInternetConnection]) {
        [self getInfoModelFromServer];
    } else {
        [self reactionToDisconnectFromNetwork:[Utilities isInternetConnection]];
    }
}

#pragma mark - Server

-(void) getInfoModelFromServer
{
    self.currentModel = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.HUD show:YES];
    
    [[ServerManager sharedManager] getInfoModel:^(InfoTVC_Model *modelForTableView) {
        [self setupModelInTable:modelForTableView];
    }
    onFailure:^(NSError *errorBlock, NSInteger statusCode, InfoTVC_Model *modelForTableView) {
        [self setupModelInTable:modelForTableView];
    }];
}


#pragma mark - Init UI

-(void) initialSetupController
{
    // Navigation Setup
    [Utilities setBackButtonInNavigationBarWithController:self withNavigationItem:self.navigationItem sel:@selector(popCurrentViewController)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];

    self.navigationItem.title = @"Info";
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor flatGrayColor];
    self.refreshControl.tintColor       = [UIColor whiteColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshController:)
     // Задать другой Ask another
                  forControlEvents:UIControlEventValueChanged];
    
    // Initialize the MBProgressHUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.HUD.labelText        = @"Downloading...";
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.HUD];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (ImgAndTitleCellInfoTVC *cell in [self.tableView visibleCells]) {
        [cell adjust:(cell.frame.origin.y - scrollView.contentOffset.y)];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (IS_IPAD) ? 100.f : 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StatisticsTVC* statTVC = (StatisticsTVC*)[storyboard instantiateViewControllerWithIdentifier:@"StatisticsTVC"];
        [self.navigationController pushViewController:statTVC animated:YES];
    }
    
    
    // Table Balls Cell
    /*
     При нажатии открывается несколько фото с таблицей балов
     Po kliknięciu otwiera się kilka zdjęć z tabelą wyników
     When you click, several photos with a score table open
    */
    if (indexPath.row == 1){
        
        [self.HUD hide:NO];
        NSMutableArray *photos = [NSMutableArray new];
 
        // 1. Сначала создадим объекты. (Они нужны для создания NYTPhotoViewController) А потом когда скачаем фото, обновим их проперти
        // 1. Najpierw stwórzmy obiekty. (Są potrzebne do stworzenia NYTPhotoViewController) A potem, kiedy pobierzemy zdjęcia, zaktualizujemy je.
        // 1. First, let's create the objects. (They are needed to create NYTPhotoViewController) And then when we download the photos, we will update them.
        
        for (int i = 0; i < self.currentModel.linkOnTableBalls.count; i++) {
            PhotoModel *photo = [PhotoModel new];
            [photos addObject:photo];
        }
        // 2. Создаем контроллер
        // 2. Utwórz kontroler
        // 2. Create a controller
        NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:[photos objectAtIndex:0]];
        
        // 3. Проходимся по циклу и ставим на скачку фото
        // 3. Przejdź przez pętlę i umieść zdjęcie na skoku
        // 3. Go through the loop and put a photo on the jump
        for (int i = 0; i < self.currentModel.linkOnTableBalls.count; i++)
        {
            NSString *photo_url = [self.currentModel.linkOnTableBalls objectAtIndex:i];
            
            // Если есть интерент, то качаем
            // Jeśli jest Internet, pobierz go
            // If there is an Internet, then download it
            if ([Utilities isInternetConnection])
            {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:photo_url]
                                                                      options:SDWebImageDownloaderHighPriority
                                                                     progress:nil
                                                                    completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                        
                                                                        PhotoModel *photo = [photos objectAtIndex:i];
                                                                        photo.image = image;
                                                                        
                                                                        __weak NYTPhotosViewController *weakPhotoVC = photosViewController;
                                                                        ANDispatchBlockToMainQueue(^{
                                                                            [weakPhotoVC updateImageForPhoto:photo];
                                                                        });
                                                                    }];
            } else {
                // Если нет, то берем локальную копию
                // Jeśli nie, weź kopię lokalną
                // If not, then take a local copy
                
                NSData*  data  = [Utilities getFileFromOnLink:self.currentModel.linkOnTableBalls[i]];
                if (data)
                {
                    PhotoModel *photo = [photos objectAtIndex:i];
                    // Вытаскиваем из массива те самые модели фото
                    // Wyodrębnij te same modele zdjęć z tablicy
                    // Extract the same photo models from the array
                    photo.image       = [UIImage imageWithData:data];
                    // При первом создание там был nil, сейчас ставим uiimage
                    // Na pierwszym utworzeniu było zero, teraz umieściliśmy uiimage
                    // At the first creation there was nil, now we put uiimage
                    [photosViewController updateImageForPhoto:photo];
                    // Обновляем данные для контроллера
                    // Zaktualizuj dane dla kontrolera
                    // Update the data for the controller
                }
            }
        }
        // 4. Презентим контроллер
        // 4. Przedstaw kontroler
        // 4. Present the controller
        [self.HUD hide:YES];
        [self presentViewController:photosViewController animated:YES completion:nil];
    }
    
    // VK Cell
    if (indexPath.row == 2) {
        NSURL *url = [NSURL URLWithString:self.currentModel.linkOnWeInVK];
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.currentModel) ? 3 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString* identifier = @"ImgAndTitleCellInfoTVC";
     ImgAndTitleCellInfoTVC *cell = (ImgAndTitleCellInfoTVC*)[tableView dequeueReusableCellWithIdentifier:identifier];
     
     if (!cell) {
          cell = (ImgAndTitleCellInfoTVC*)[[ImgAndTitleCellInfoTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
    
     [self configureCell:cell atIndexPath:indexPath];
     return cell;
}


#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ImgAndTitleCellInfoTVC class]]) {
        
        ImgAndTitleCellInfoTVC* customCell = (ImgAndTitleCellInfoTVC*)cell;
        
        UIFont* lightFont = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.f];
        customCell.myTitleLabel.font = lightFont;

        NSString* nameImage;
        
        if (indexPath.row == 0) {
            nameImage = (IS_IPAD) ? @"Statistics-256" : @"Statistics-128";
            customCell.myTitleLabel.text = self.currentModel.titleForMyStatistics;

        }
        if (indexPath.row == 1) {
            nameImage = (IS_IPAD) ? @"tableIcon1-256" : @"tableIcon1-128";
            customCell.myTitleLabel.text = self.currentModel.titleForTableBalls;
        }
        
        if (indexPath.row == 2) {
            nameImage = (IS_IPAD) ? @"vk-Icon2-256" : @"vk-Icon2-128";
            customCell.myTitleLabel.text = self.currentModel.titleForWeInVK;
        }
        customCell.myImageView.image = [UIImage imageNamed:nameImage];
        customCell.backgroundColor = [UIColor clearColor];
    }
}

- (void) setupModelInTable:(InfoTVC_Model*) model {
    self.currentModel = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.HUD hide:YES];
}


#pragma mark - Action

- (void)popCurrentViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RefreshControl

- (void) refreshController:(UIRefreshControl *)refreshControl {
    [self reloadData];
}

- (void)reloadData
{
    self.currentModel = nil;
    [self.tableView reloadData];
    
    [self getInfoModelFromServer];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Other

-(void) reactionToDisconnectFromNetwork:(BOOL) isConnectToNetwork {
    
    if (!isConnectToNetwork) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        SCLAlertView* alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"Ok" target:nil selector:nil];
        [alert addButton:@"Download a local copy of the information"
                  target:self
                selector:@selector(getInfoModelFromServer)];
        [alert showError:self title:@"Error" subTitle:@"Internet connections" closeButtonTitle:nil duration:0.f];
    }
}

@end
