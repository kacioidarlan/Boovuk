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

+ (Livro*) parseResponse:(id) responseObject context:(id) context;

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

+ (Livro*) parseResponse:(id) responseObject context:(id) context {
    
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

//    book[@"thumbnailLink"] = (NSString *) [[[item objectForKeyedSubscript:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"smallThumbnail"];
//    
//    book[@"smallThumbnailLink"] = (NSString *) [[[item objectForKeyedSubscript:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"smallThumbnail"];
//    
    
    return book;
}

@end
