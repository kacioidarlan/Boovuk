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
#import "AKSUtil.h"

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
    [self becomeFirstResponder];
    //    TODO : Remover depois
    //    Exemplo de todo utilizar o booksearch
    if (![self.textViewISBN.text isEqualToString:@""]) {
        [BookSearch searchByISBN:self.textViewISBN.text context:self.managedObjectContext sucess:^(Livro *livro) {
            NSLog(@"Ok :");
            if (livro.titulo != NULL) {
                [self performSegueWithIdentifier:@"segueFormulario" sender:livro];
            }
        } fail:^(NSString *error) {
            NSLog(@"Error : %@", error);
            [AKSUtil exibirMensagemToast:error navigationController:self.navigationController];
        }];
    } else {
        NSString *mensagem = @"Código ISBN não localizado";
        [AKSUtil exibirMensagemToast:mensagem navigationController:self.navigationController];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueFormulario"]) {
        AKSViewControllerFormulario *formularioViewController = (AKSViewControllerFormulario *)[segue destinationViewController];
        formularioViewController.managedObjectContext = self.managedObjectContext;
        formularioViewController.livroIncluir = sender;
    }
}

#pragma mark - EsconderTeclado
//Método responsável por esconder o teclado ao tocar em algum local da tela
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
@end
