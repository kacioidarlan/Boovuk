//
//  AKSViewControllerFormulario.h
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 27/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Livro.h"

@interface AKSViewControllerFormulario : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property  (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property  (nonatomic, strong) Livro *livroEditar;
@property  (nonatomic, strong) Livro *livroIncluir;
@end
