//
//  AKSViewControllerFormulario.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 27/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import "AKSViewControllerFormulario.h"
#import "AKSDetailViewController.h"
#import "Livro.h"
#import "MBProgressHUD.h"

@interface AKSViewControllerFormulario ()
@property (strong, nonatomic) IBOutlet UITextField *textFieldtitulo;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAutor;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNumeroPaginas;
@property (strong, nonatomic) IBOutlet UITextField *textFieldISBN;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCapa;
- (IBAction)buttonSalvar:(id)sender;
- (IBAction)buttonTirarFoto:(id)sender;
- (IBAction)buttonPegarGaleria:(id)sender;

@end

@implementation AKSViewControllerFormulario

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

- (IBAction)buttonSalvar:(id)sender {
    Livro *livro = (Livro *)[NSEntityDescription insertNewObjectForEntityForName:@"Livro" inManagedObjectContext:self.managedObjectContext];;
    livro.titulo = self.textFieldtitulo.text;
    livro.autores = self.textFieldAutor.text;
    livro.dataCadastro = [NSDate date];
    livro.isbn13 = self.textFieldISBN.text;
    livro.foto = [NSData dataWithData:UIImagePNGRepresentation(self.imageViewCapa.image)];
    
    NSString *mensagem = @"";
    
    //salva o contexto no banco e loga erro caso ocorra
    NSError *error = NULL;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: %@, %@", error, [error userInfo]);
        
        mensagem = @"Ocorreu um erro ao inserir o Livro.";
    }
    else{
        mensagem = @"Livro incluído com sucesso";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            AKSDetailViewController *detailViewController = [self.navigationController.viewControllers firstObject];
            detailViewController.detailItem = livro;
            [self.navigationController popToViewController:(UIViewController *)detailViewController animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = mensagem;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

- (IBAction)buttonTirarFoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Câmera"
                                                           message:@"Este dispositivo não possui câmera"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
        
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)buttonPegarGaleria:(id)sender {
    //instância de UIImagePickerController qeu apresenta navegação na biblioteca
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    //definimos o tipo da UIImagePickerController, no caso será PhotoLibrary (biblioteca de imagens)
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    //apresentamos a UIImagePickerController na tela
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //pegar imagem selecionada
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    self.imageViewCapa.image = image;
    
    //fechar a ViewController da biblioteca
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //fechar a ViewController da biblioteca
    [self dismissViewControllerAnimated:YES completion:NULL];
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
