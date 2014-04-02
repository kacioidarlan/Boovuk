//
//  Livro.h
//  Boovuk
//
//  Created by Solli Honorio on 01/04/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Livro : NSManagedObject

@property (nonatomic, retain) NSString * autores;
@property (nonatomic, retain) NSDate * dataCadastro;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSString * editora;
@property (nonatomic, retain) NSData * foto;
@property (nonatomic, retain) NSString * isbn10;
@property (nonatomic, retain) NSString * isbn13;
@property (nonatomic, retain) NSNumber * numeroPaginas;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * smallThumbnail;
@property (nonatomic, retain) NSString * idioma;
@property (nonatomic, retain) NSString * categorias;
@property (nonatomic, retain) NSDate * dataPublicacao;
@property (nonatomic, retain) NSNumber * ratingCount;

@end
