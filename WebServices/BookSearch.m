//
//  BookSearch.m
//  Boovuk
//
//  Created by Solli Honorio on 01/04/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//
//
//  BookSearch.m
//  lixo
//
//  Created by Usuário Convidado on 27/03/14.
//  Copyright (c) 2014 Usuário Convidado. All rights reserved.
//

#import "BookSearch.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "Livro.h"

static NSString * const kURIServices = @"https://www.googleapis.com/books/v1/volumes";

@interface BookSearch()

+ (Livro    *) parseResponse:(id) responseObject context:(id) context;
+ (NSString *) saveImage:(NSData *)image;
+ (NSString *) contentTypeForImageData:(NSData*)data;

@end

@implementation BookSearch

+ (void) searchByISBN:(NSString*)ISBN context:(id)context sucess:(void (^)(Livro * book))sucess fail:(void (^)(NSString *error))fail {
    
    // validar se o ISBN é válido
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    if ( [ISBN rangeOfCharacterFromSet:numbers].location == NSNotFound ) {
        fail(@"O ISBN informado é inválido.");
    }
    if (! (( ISBN.length == 10 ) || ( ISBN.length == 13 )) ) {
        fail(@"O ISBN informado é inválido.");
    }
    
    AFHTTPRequestOperationManager *manager = [ AFHTTPRequestOperationManager manager];
    
    // desativa a validação do certificado no simulador
#if (TARGET_IPHONE_SIMULATOR)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
#endif
    
    NSString *uri = [[NSString stringWithFormat:@"%@?q=isbn:%@", kURIServices, ISBN] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( sucess ) {
            sucess( [self parseResponse:responseObject context:context] );
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( fail ) {
            fail(@"Falha!");
        }
    }];
}

+(Livro*) parseResponse:(id) responseObject context:(id) context {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    Livro *book = (Livro *)[NSEntityDescription insertNewObjectForEntityForName:@"Livro" inManagedObjectContext:context];
    
    NSDictionary *item = [[(NSDictionary *) responseObject objectForKey:@"items"] objectAtIndex:0];
    
    [book setTitulo:(NSString *)  [[item objectForKey:@"volumeInfo"] objectForKey:@"title"]];
    [book setIdioma:(NSString *) [[item objectForKey:@"volumeInfo"] objectForKey:@"language"]];
    [book setEditora:(NSString *) [[item objectForKey:@"volumeInfo"] objectForKey:@"publisher"]];
    [book setDescricao:(NSString *)[[item objectForKey:@"volumeInfo"] objectForKey:@"description"]];
    [book setNumeroPaginas:(NSNumber *) [[item objectForKey:@"volumeInfo"] objectForKey:@"pageCount"]];
    [book setAutores:(NSString *) [[[item objectForKey:@"volumeInfo"] objectForKey:@"authors"] componentsJoinedByString:@";"]];
    [book setCategorias:(NSString *) [[[item objectForKey:@"volumeInfo"] objectForKey:@"categories"] componentsJoinedByString:@";"]];
    [book setDataPublicacao: (NSDate *) [formatter dateFromString:[[item objectForKey:@"volumeInfo"] objectForKey:@"publishedDate"]]];
    [book setRatingCount:(NSNumber *) [[item objectForKey:@"volumeInfo"] objectForKey:@"ratingsCount"]];

    [book setRating:(NSNumber *) [[item objectForKey:@"volumeInfo"] objectForKey:@"averageRating"]];

    for ( NSDictionary *identifiers in [[item objectForKey:@"volumeInfo"] objectForKey:@"industryIdentifiers"] ){
        if ( [[identifiers objectForKey:@"type"] isEqualToString:@"ISBN_10"] ) {
            [book setIsbn10:(NSString *)[identifiers objectForKey:@"identifier"]];
        } else if ( [[identifiers objectForKey:@"type"] isEqualToString:@"ISBN_13"] ) {
            [book setIsbn13:(NSString *)[identifiers objectForKey:@"identifier"]];
        }
    }

    // Pega a imagem da internet                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    NSData *imageThumbnail = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *) [[[item objectForKeyedSubscript:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"thumbnail"]]];
    NSData *imageSmallThumbnail = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *) [[[item objectForKeyedSubscript:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"smallThumbnail"]]];

    // grava a imagem no diretório e o nome no coredata
    [book setThumbnail:[self saveImage:imageThumbnail]];
    [book setSmallThumbnail:[self saveImage:imageSmallThumbnail]];
    
    return book;
}

+ (NSString *)saveImage:(NSData *)image {

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

+ (NSString *)contentTypeForImageData:(NSData*)data {
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


@end
