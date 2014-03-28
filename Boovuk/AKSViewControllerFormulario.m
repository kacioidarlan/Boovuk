//
//  AKSViewControllerFormulario.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 27/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import "AKSViewControllerFormulario.h"
#import "Livro.h"

@interface AKSViewControllerFormulario ()
@property (strong, nonatomic) IBOutlet UITextField *textFieldtitulo;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAutor;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNumeroPaginas;
@property (strong, nonatomic) IBOutlet UITextField *textFieldISBN;
- (IBAction)buttonSalvar:(id)sender;

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
    
    //salva o contexto no banco e loga erro caso ocorra
    NSError *error = NULL;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"ERROR: %@, %@", error, [error userInfo]);
    }
}
@end
