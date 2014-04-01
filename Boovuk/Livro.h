//
//  Livro.h
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 31/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Livro : NSManagedObject

@property (nonatomic, retain) NSString * autores;
@property (nonatomic, retain) NSDate * dataCadastro;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSData * foto;
@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSNumber * numeroPaginas;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * editora;

@end
