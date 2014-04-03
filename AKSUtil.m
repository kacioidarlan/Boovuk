//
//  AKSUtil.m
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 02/04/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import "AKSUtil.h"
#import "MBProgressHUD.h"

@implementation AKSUtil

+(void) exibirMensagemToast:(NSString *)mensagem navigationController:(UINavigationController *) navigationController {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = mensagem;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

@end
