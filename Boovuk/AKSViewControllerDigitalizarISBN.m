//
//  AKSViewControllerDigitalizarISBN.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 27/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AKSViewControllerDigitalizarISBN.h"
#import "AKSViewControllerFormulario.h"
#import "BookSearch.h"
#import "Livro.h"
#import "AKSUtil.h"

@interface AKSViewControllerDigitalizarISBN () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelISBN;
@property (weak, nonatomic) IBOutlet UIView *previewOutput;

@end

@implementation AKSViewControllerDigitalizarISBN
{
    //  Variáveis do scanner de barcode
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureMetadataOutput *_metadataOutput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _isRunning;
}

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
    [self startCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated{
    if ( _isRunning == false) {
        [_captureSession startRunning];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_captureSession stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segueFormulario"]) {
        AKSViewControllerFormulario *formularioViewController = (AKSViewControllerFormulario *)[segue destinationViewController];
        formularioViewController.managedObjectContext = self.managedObjectContext;
        formularioViewController.livroIncluir = sender;
    }
}

#pragma mark - Captura de Video

-(void) startCaptureSession {
    
    // se já estiver iniciado a sessão, cai fora !
    if ( _captureSession ) {
        return;
    }
    
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (! _videoDevice) {
        self.previewOutput.backgroundColor = [UIColor blackColor];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Câmera"
                                                           message:@"Este dispositivo não possui câmera"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
         [alertView show];
         return;
    }

    _captureSession = [[AVCaptureSession alloc] init];
    _videoInput     = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];

    if ( [_captureSession canAddInput:_videoInput] ) {
        [_captureSession addInput:_videoInput];
    }

    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:dispatch_get_main_queue()];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }

    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
    _previewLayer.frame = _previewOutput.bounds;
    [_previewOutput.layer addSublayer:_previewLayer];
    _isRunning = true;
}

#pragma mark - Processamento do código capturado

- (void) processaPesquisa:(NSString *) isbn {
    
    [BookSearch searchByISBN:isbn context:self.managedObjectContext sucess:^(Livro *book) {
        [self performSegueWithIdentifier:@"segueFormulario" sender:book];
        
    } fail:^(NSString *error) {
        NSLog(@"Error : %@", error);
        [AKSUtil exibirMensagemToast:error navigationController:self.navigationController];
    }];
}


#pragma mark - Função Delegada

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[ AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code ];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[ _previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [_captureSession stopRunning];
            _isRunning = false;
            [self processaPesquisa:detectionString];
            break;
        }
    }
}

@end
