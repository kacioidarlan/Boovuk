//
//  BookSearch.h
//  Boovuk
//
//  Created by Solli Honorio on 01/04/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Livro.h"

@interface BookSearch : NSObject

+ (void) searchByISBN:(NSString*)ISBN context:(id)context sucess:(void (^)(Livro * book))sucess fail:(void (^)(NSString *error))fail;

@end
