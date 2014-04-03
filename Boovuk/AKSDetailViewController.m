//
//  AKSDetailViewController.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 26/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import "AKSDetailViewController.h"
#import "AKSViewControllerFormulario.h"
#import "Livro.h"

@interface AKSDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelTitulo;
@property (strong, nonatomic) IBOutlet UILabel *labelAutores;
@property (strong, nonatomic) IBOutlet UILabel *labelEditora;
@property (strong, nonatomic) IBOutlet UILabel *labelISBN;
@property (strong, nonatomic) IBOutlet UILabel *labelNrPag;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescricao;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCapa;
- (IBAction)buttonEditar:(id)sender;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation AKSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"titulo"] description];
        Livro *livro = self.detailItem;
        self.labelTitulo.text = livro.titulo;
        self.labelAutores.text = livro.autores;
        self.labelEditora.text = livro.editora;
        self.labelNrPag.text = [livro.numeroPaginas stringValue];
        self.labelISBN.text = livro.isbn13;
        self.textViewDescricao.text = livro.descricao;
        self.imageViewCapa.image = [UIImage imageWithData:livro.foto];        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonEditar:(id)sender {
    [self performSegueWithIdentifier:@"segueFormulario" sender:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueFormulario"]) {
        AKSViewControllerFormulario *formularioViewController = (AKSViewControllerFormulario *)[segue destinationViewController];
        formularioViewController.managedObjectContext = self.managedObjectContext;
        formularioViewController.livroEditar = self.detailItem;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
