//
//  Level2.h
//  ASD_Game
//
//  Created by Kim Forbes on 2/8/15.
//  Copyright (c) 2015 Kim Forbes. All rights reserved.
//


#ifndef ASD_Game_Level2_h
#define ASD_Game_Level2_h


#import <SpriteKit/SpriteKit.h>
#import "Level3.h" //transitions to level 3 of train game

//Voice Synthesis imports
#import <AVFoundation/AVFoundation.h>


@interface Level2 : SKScene{}


@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


@end


#endif
