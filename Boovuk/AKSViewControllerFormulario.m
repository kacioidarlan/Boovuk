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
#import "AKSUtil.h"
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

@property (strong, nonatomic) IBOutlet UITextField *textFieldISBN13;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescricao;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEditora;

@property BOOL livroSalvo;
@property (strong, nonatomic) NSString *pathCapa;

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
    [self preencherLivroEdicao];
    self.livroSalvo = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) preencherLivroEdicao {
    if (self.livroEditar != NULL) {
        self.textFieldtitulo.text = self.livroEditar.titulo;
        self.textFieldAutor.text = self.livroEditar.autores;
        self.textFieldNumeroPaginas.text = [self.livroEditar.numeroPaginas stringValue];
        self.textFieldISBN.text = self.livroEditar.isbn10;
        self.textFieldISBN13.text = self.livroEditar.isbn13;
        self.textFieldEditora.text = self.livroEditar.editora;
        self.textViewDescricao.text = self.livroEditar.descricao;
        if ( self.livroEditar.thumbnail) {
            NSData  *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.livroEditar.thumbnail]];
            self.imageViewCapa.image = [UIImage imageWithData:data];
        }
        //self.imageViewCapa.image = [UIImage imageWithData:self.livroEditar.foto];
    } else if (self.livroIncluir != NULL){
        self.textFieldtitulo.text = self.livroIncluir.titulo;
        self.textFieldAutor.text = self.livroIncluir.autores;
        self.textFieldNumeroPaginas.text = [self.livroIncluir.numeroPaginas stringValue];
        self.textFieldISBN.text = self.livroIncluir.isbn10;
        self.textFieldISBN13.text = self.livroIncluir.isbn13;
        self.textFieldEditora.text = self.livroIncluir.editora;
        self.textViewDescricao.text = self.livroIncluir.descricao;
        
        NSData  *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.livroIncluir.thumbnail]];
        self.imageViewCapa.image = [UIImage imageWithData:data];
    }
    
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
    Livro *livro;
    NSManagedObjectContext *context;
    if (self.livroEditar != NULL)
    {
        context = self.livroEditar.managedObjectContext;
        self.livroEditar.titulo = self.textFieldtitulo.text;
        self.livroEditar.autores = self.textFieldAutor.text;
        self.livroEditar.editora = self.textFieldEditora.text;
        self.livroEditar.dataCadastro = [NSDate date];
        self.livroEditar.foto = [NSData dataWithData:UIImagePNGRepresentation(self.imageViewCapa.image)];
        self.livroEditar.isbn10 = self.textFieldISBN.text;
        self.livroEditar.isbn13 = self.textFieldISBN13.text;
        self.livroEditar.descricao = self.textViewDescricao.text;
        
    }
    else if (self.livroIncluir != NULL)
    {
        context = self.managedObjectContext;
        self.livroIncluir.titulo = self.textFieldtitulo.text;
        self.livroIncluir.autores = self.textFieldAutor.text;
        self.livroIncluir.editora = self.textFieldEditora.text;
        self.livroIncluir.dataCadastro = [NSDate date];
        self.livroIncluir.foto = [NSData dataWithData:UIImagePNGRepresentation(self.imageViewCapa.image)];
        self.livroIncluir.isbn10 = self.textFieldISBN.text;
        self.livroIncluir.isbn13 = self.textFieldISBN13.text;
        self.livroIncluir.descricao = self.textViewDescricao.text;
    }
    else
    {
        context = self.managedObjectContext;
        livro = (Livro *)[NSEntityDescription insertNewObjectForEntityForName:@"Livro" inManagedObjectContext:self.managedObjectContext];
        livro.titulo = self.textFieldtitulo.text;
        livro.autores = self.textFieldAutor.text;
        livro.editora = self.textFieldEditora.text;
        livro.dataCadastro = [NSDate date];
        livro.foto = [NSData dataWithData:UIImagePNGRepresentation(self.imageViewCapa.image)];
        livro.isbn10 = self.textFieldISBN.text;
        livro.isbn13 = self.textFieldISBN13.text;
        livro.descricao = self.textViewDescricao.text;
    }
    
    
    NSString *mensagem = @"";
    
    //salva o contexto no banco e loga erro caso ocorra
    NSError *error = NULL;
    if (![context save:&error]) {
        NSLog(@"ERROR: %@, %@", error, [error userInfo]);
        
        mensagem = @"Ocorreu um erro ao inserir o Livro.";
    }
    else
    {
        mensagem = @"Livro incluído com sucesso";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            AKSDetailViewController *detailViewController = [self.navigationController.viewControllers firstObject];
            if (self.livroEditar != nil) {
                detailViewController.detailItem = self.livroEditar;
            }
            else {
                detailViewController.detailItem = livro;
            }
            
            [self.navigationController popToViewController:(UIViewController *)detailViewController animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    [AKSUtil exibirMensagemToast:mensagem navigationController:self.navigationController];
    
    self.livroSalvo = TRUE;
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

-(void) viewWillDisappear:(BOOL)animated{
    //excluir livro se não foi adicionado
    if (!self.livroSalvo && self.livroIncluir != NULL) {
        [self.managedObjectContext deleteObject:self.livroIncluir];
        NSFileManager *fileManager = [ NSFileManager defaultManager];
        [fileManager removeItemAtURL:[NSURL URLWithString:self.livroIncluir.thumbnail] error:nil];
        [fileManager removeItemAtURL:[NSURL URLWithString:self.livroIncluir.smallThumbnail] error:nil];
    }
}

#pragma mark - Salvar Imagem
- (NSString *)saveImage:(NSData *)image {
    
    NSError *error;
    // a extensão do arquivo
    NSString *type       = [self contentTypeForImageData:image];
    // pega o diretório da aplicação
    NSURL *documentsPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    // monta o nome do arquivo
    NSURL *fileName      = [documentsPath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [[NSUUID UUID] UUIDString], type]];
    
    if ( [type isEqualToString:@"jpg"] ) {
        [UIImageJPEGRepresentation([UIImage imageWithData:image], 1.0) writeToURL:fileName options:NSAtomicWrite error:&error];
    } else if ( [type isEqualToString:@"png"] ) {
        [UIImagePNGRepresentation([UIImage imageWithData:image]) writeToURL:fileName options:NSAtomicWrite error:&error];
    } else {
        return nil;
    }
    
    return [fileName absoluteString];
}

- (NSString *)contentTypeForImageData:(NSData*)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tif";
    }
    return nil;
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
