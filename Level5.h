//
//  Level5.h
//  ASD_Game
//  Previously Level4
//
//  Created by Matthew Perez on 3/20/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//


#ifndef ASD_Game_Level5_h
#define ASD_Game_Level5_h


#import <SpriteKit/SpriteKit.h>
//import transition to final screen?

//Voice Synthesis imports
#import <AVFoundation/AVFoundation.h>


@interface Level5 : SKScene {}


@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;


@end


#endif