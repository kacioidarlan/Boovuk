//
//  AKSViewControllerDigitarISBN.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 27/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import "AKSViewControllerDigitarISBN.h"
#import "AKSViewControllerFormulario.h"
#import "MBProgressHUD.h"
#import "BookSearch.h"
#import "Livro.h"

@interface AKSViewControllerDigitarISBN ()

- (IBAction)buttonPesquisar:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textViewISBN;
@end

@implementation AKSViewControllerDigitarISBN

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonPesquisar:(id)sender {
    
    //    TODO : Remover depois
    //    Exemplo de todo utilizar o booksearch
    if (![self.textViewISBN.text isEqualToString:@""]) {
        [BookSearch searchByISBN:self.textViewISBN.text context:self.managedObjectContext sucess:^(Livro *livro) {
            NSLog(@"Ok :");
            [self performSegueWithIdentifier:@"segueFormulario" sender:livro];
        } fail:^(NSString *error) {
            NSLog(@"Error : %@", error);
        }];
    } else {
        NSString *mensagem = @"Código ISBN não localizado";
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = mensagem;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueFormulario"]) {
        AKSViewControllerFormulario *formularioViewController = (AKSViewControllerFormulario *)[segue destinationViewController];
        formularioViewController.managedObjectContext = self.managedObjectContext;
        formularioViewController.livroEditar = sender;
    }
}
@end
