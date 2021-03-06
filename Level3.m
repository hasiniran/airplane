//
//  Level3.m
//  ASD_Game
//
//  Created by Matthew Perez on 2/23/15.
//  Copyright (c) 2015 Hasini Yatawatte. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Level3.h"


@implementation Level3 {
    SKSpriteNode *train;
    SKSpriteNode *station;
    SKSpriteNode *rail;
    SKSpriteNode *blueBoy;
    SKSpriteNode *yellowBoy;
    SKSpriteNode *purpleBoy;
    SKSpriteNode *head;
    SKSpriteNode *arrow;
    SKNode *_bgLayer;
    SKNode *_HUDLayer;
    SKNode *_gameLayer;
    SKNode *text;
    SKNode *button;
    SKLabelNode *skip;
    SKLabelNode *nextButton;
    SKLabelNode *level;
    SKLabelNode *display;
    SKLabelNode *tryAgainButton;
    NSTimer *instructionTimer;
    double speed;
    int count;
    int check; //keep track of train states -- check 0 = moving, check 1 = stop, check 2 = moving, check 4 display
    int count2;
    int chances;
    int textDisplay;
}


-(id)initWithSize:(CGSize)size {
    speed = 1;
    count = 0;
    check = 0;
    chances = 3; //lives
    textDisplay = 0;
    
    if(self = [super initWithSize:size]) {
        //initialize synthesizer
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //add layers
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _HUDLayer = [SKNode node];
        [self addChild: _HUDLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        text = [SKNode node];
        [self addChild:text];
        
        //add background
        [self addMountain];
        [self addClouds];
        
        //add objects
        [self ScrollingForeground]; //scolling tracks speed is 0
        [self train];
        [self station];
        [self blueBoy];
        [self yellowBoy];
        [self purpleBoy];
        
        //declare physics bodies
        [station.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [yellowBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [blueBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        [purpleBoy.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        
        //skip button
        skip = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        skip.text = @"SKIP";
        skip.name = @"Skip";
        skip.fontSize = 40;
        skip.fontColor = [SKColor orangeColor];
        skip.position = CGPointMake(850,600);
        skip.zPosition = 50;
        [_HUDLayer addChild:skip];
        
        level = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        level.name = @"levelname";
        level.fontSize = 40;
        level.fontColor = [SKColor redColor];
        level.position = CGPointMake(500,500);
        level.zPosition = 50;
        level.text = @"Level 3";
        [text addChild:level];
    }
    return self;
}


-(void)addMountain {
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"background_mount.png"];
    
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:2];
        sprite.zPosition=-30;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 100);
        [_HUDLayer addChild:sprite];
    }
}


-(void)addClouds {
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];
    
    for (int i=0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [_bgLayer addChild:sprite];
    }
}


-(void)ScrollingForeground { //Scrolling tracks
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"Rail.png"];
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*speed*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width);i++) { //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:1];
        sprite.zPosition = 10;
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(i*sprite.size.width, 0);
        [sprite runAction:moveGroundSpriteForever];
        [_bgLayer addChild:sprite];
    }
}


-(void)ScrollingBackground {   //scrolling background function
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];        //reuse sky image
    SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width y:0 duration: 0.1*speed*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    
    for(int i =0; i<2+self.frame.size.width/(backgroundTexture.size.width*2); i++) { //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
    }
}


-(void)nextLevel {
    nextButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    nextButton.text = @"Go to Level 4";
    nextButton.fontColor = [SKColor redColor];
    nextButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    nextButton.name = @"level4";
    [text addChild:nextButton];
    
    AVSpeechUtterance *next = [[AVSpeechUtterance alloc] initWithString:@"Good Job! Continue on to level 4."];
    next.rate = AVSpeechUtteranceMinimumSpeechRate;
    next.pitchMultiplier = 1.5;
    [self.synthesizer speakUtterance:next];
}


-(void)stopTrain {
    if(check == 0) {
        check++;
        speed = 0;
        
        [_bgLayer removeFromParent];
        [_gameLayer removeFromParent];
        
        _bgLayer = [SKNode node];
        [self addChild: _bgLayer];
        _gameLayer = [SKNode node];
        [self addChild: _gameLayer];
        
        AVSpeechUtterance *instruction2a = [[AVSpeechUtterance alloc] initWithString:@"Level 3"];
        instruction2a.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction2a.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction2a];

        [self ScrollingForeground];
        [self train];
        [self station];
        station.position = CGPointMake(620, 160);
        [self rail];
        [self addClouds];
        [self blueBoy];
        [self yellowBoy];
        [self purpleBoy];
        [self hint];
        [self timer];
    }
}


-(void)hint {
    arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    
    if(check == 1)
        arrow.position = CGPointMake(850, 250);
    else if(check == 2)
        arrow.position = CGPointMake(750, 250);
    else if(check == 3)
        arrow.position = CGPointMake(650, 250);
    
    arrow.zPosition = 100;
    [arrow setScale:.5];
    [text addChild:arrow];
}


-(void)blueBoy {
    blueBoy = [SKSpriteNode spriteNodeWithImageNamed:@"BlueBoy.png"];
    blueBoy.name = @"blueBoy";
    
    if(check == 0)
        blueBoy.position=CGPointMake(930, 167);
    else if(check == 1)
        blueBoy.position = CGPointMake(700, 167);
    
    blueBoy.zPosition = 30;
    [blueBoy setScale:.5];
    blueBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    blueBoy.physicsBody.affectedByGravity = NO;
    blueBoy.physicsBody.allowsRotation = NO;
    blueBoy.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:blueBoy];
}


-(void)purpleBoy {
    purpleBoy = [SKSpriteNode spriteNodeWithImageNamed:@"PurpleBoy.png"];
    purpleBoy.name = @"purpleBoy";
    
    if(check == 0)
        purpleBoy.position=CGPointMake(1020, 170);
    else
        purpleBoy.position = CGPointMake(800, 170);

    purpleBoy.zPosition = 30;
    [purpleBoy setScale:.5];
    purpleBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    purpleBoy.physicsBody.affectedByGravity = NO;
    purpleBoy.physicsBody.allowsRotation = NO;
    purpleBoy.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:purpleBoy];
}


-(void)yellowBoy {
    yellowBoy = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBoy.png"];
    yellowBoy.name = @"yellowBoy";
    
    if(check == 0)
        yellowBoy.position = CGPointMake(840, 170);
    else
        yellowBoy.position = CGPointMake(600, 170);
        
    yellowBoy.zPosition = 31;
    [yellowBoy setScale:.5];
    yellowBoy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    yellowBoy.physicsBody.affectedByGravity = NO;
    yellowBoy.physicsBody.allowsRotation = NO;
    yellowBoy.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:yellowBoy];
}


-(void)station {
    station = [SKSpriteNode spriteNodeWithImageNamed:@"Station2.png"];
    station.position = CGPointMake(850, 160);
    station.zPosition = 0;
    station.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    station.physicsBody.affectedByGravity = NO;
    station.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:station];
}


-(void)train { //Moving object
    train = [SKSpriteNode spriteNodeWithImageNamed:@"Train.png"];
    train.position = CGPointMake(250, 100);
    train.zPosition = 50;
    train.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    train.physicsBody.dynamic = YES;
    train.physicsBody.affectedByGravity = NO;
    train.physicsBody.allowsRotation = NO;
    [_gameLayer addChild:train];
}


-(void)rail {
    rail = [SKSpriteNode spriteNodeWithImageNamed:@"Rail.png"];
    rail.position = CGPointMake(917, 36);
    [_bgLayer addChild:rail];
}


-(void)addHeadToTrain {
    [text removeFromParent];
    
    if(check == 1) {
        head = [SKSpriteNode spriteNodeWithImageNamed:@"purpHead.png"];
        head.position = CGPointMake(330, 120);
        [head setScale:.7];
    }
    else if(check == 2) {
        head = [SKSpriteNode spriteNodeWithImageNamed:@"blueHead.png"];
        head.position = CGPointMake(280, 120);
        [head setScale:.5];
    }
    else if(check == 3) {
        head = [SKSpriteNode spriteNodeWithImageNamed:@"yellowHead.png"];
        head.position = CGPointMake(170, 120);
        [head setScale:.5];
    }
    
    head.zPosition = 60;
    head.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 20)];
    head.physicsBody.affectedByGravity = NO;
    head.physicsBody.allowsRotation = NO;
    head.physicsBody.collisionBitMask = NO;
    [_gameLayer addChild:head];
    
    check++;
}


-(void)timer { //keep accessing displayText until child starts playing
    instructionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incorrect) userInfo:nil repeats:YES];
}


-(void)incorrect {
    textDisplay++;
    
    display = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    display.position = CGPointMake(self.size.width/2, self.size.height/2);
    if (textDisplay == 1) {
        [text removeFromParent];
        text = [SKNode node];
        [self addChild:text];
        
        display.text = @"Tell this passenger to HOP ON.";
        AVSpeechUtterance *instruction3 = [[AVSpeechUtterance alloc] initWithString:@"Tell this passenger to HOP ON"];
        instruction3.rate = AVSpeechUtteranceMinimumSpeechRate;
        instruction3.pitchMultiplier = 1.5;
        [self.synthesizer speakUtterance:instruction3];
    }
    else if (textDisplay == 12) {
        [text removeFromParent];   //clear text
        text = [SKNode node];  //re init text
        [self addChild:text];
        
        if(check == 1) {
            display.text = @"Pick up this passenger by saying HOP ON PURPLE";
            AVSpeechUtterance *instruction4p = [[AVSpeechUtterance alloc] initWithString:@"Pick up this passenger by saying HOP ON PURPLE"];
            instruction4p.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4p.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4p];
        }
        else if(check == 2) {
            display.text = @"Pick up this passenger by saying HOP ON BLUE";
            AVSpeechUtterance *instruction4b = [[AVSpeechUtterance alloc] initWithString:@"Pick up this passenger by saying HOP ON BLUE"];
            instruction4b.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4b.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4b];
        }
        else if(check == 3) {
            display.text = @"Pick up this passenger by saying HOP ON YELLOW";
            AVSpeechUtterance *instruction4y = [[AVSpeechUtterance alloc] initWithString:@"Pick up this passenger by saying HOP ON YELLOW"];
            instruction4y.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction4y.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction4y];
        }
    }
    else if (textDisplay == 20) {
        [text removeFromParent];   //clear text
        text = [SKNode node];  //re init text
        [self addChild:text];
        
        if(check == 1) {
            display.text = @"Say HOP ON PURPLE";
            AVSpeechUtterance *instruction5p = [[AVSpeechUtterance alloc] initWithString:@"Say HOP ON PURPLE"];
            instruction5p.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction5p.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction5p];
        }
        else if(check == 2) {
            display.text = @"Say HOP ON BLUE";
            AVSpeechUtterance *instruction5b = [[AVSpeechUtterance alloc] initWithString:@"Say HOP ON BLUE"];
            instruction5b.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction5b.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction5b];
        }
        else if(check == 3) {
            display.text = @"Say HOP ON YELLOW";
            AVSpeechUtterance *instruction5y = [[AVSpeechUtterance alloc] initWithString:@"Say HOP ON YELLOW"];
            instruction5y.rate = AVSpeechUtteranceMinimumSpeechRate;
            instruction5y.pitchMultiplier = 1.5;
            [self.synthesizer speakUtterance:instruction5y];
        }
    }
    else if (textDisplay == 30) {
        textDisplay = 0; //start instructions over
    }
    
    if(check == 1)
        display.fontColor = [SKColor purpleColor];
    else if(check == 2)
        display.fontColor = [SKColor blueColor];
    else if(check == 3)
        display.fontColor = [SKColor yellowColor];

    [display removeFromParent];
    [text addChild:display];

    if(chances > 0) {
        [self hint];
    }
    else if(chances == 0) {
        [self tryAgain];
    }
}


-(void)tryAgain { //replay level 3 if not completed
    [text removeFromParent];   //clear text
    text = [SKNode node];
    [self addChild:text];
    
    AVSpeechUtterance *againSpeech = [[AVSpeechUtterance alloc] initWithString:@"Let's try Level 3 again"];
    againSpeech.rate = AVSpeechUtteranceMinimumSpeechRate;
    againSpeech.pitchMultiplier = 1.5;
    [self.synthesizer speakUtterance:againSpeech];

    tryAgainButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tryAgainButton.text = @"Try Again";
    tryAgainButton.fontColor = [SKColor blueColor];
    tryAgainButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    tryAgainButton.name = @"level3";
    [text addChild:tryAgainButton];
    
    chances--; //try again declared only once
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    button = [self nodeAtPoint:location];
    
    if (chances > 0) { //disable people clicks after using up all 3 tries
        if(check == 1 && [button.name  isEqual: @"purpleBoy"]) {
            speed = 1;
            [purpleBoy removeFromParent];
            [self addHeadToTrain];
            count2 = 0;
            textDisplay = 0; //restart instructions
        }
        else if(check == 2 && [button.name  isEqual: @"blueBoy"]) { //blue chck
            [blueBoy removeFromParent];
            [self addHeadToTrain];
            count2 = 0;
            textDisplay = 0; //restart instructions
        }
        else if(check == 3 && [button.name  isEqual: @"yellowBoy"]) {
            [yellowBoy removeFromParent];
            [self addHeadToTrain];
        
            [_bgLayer removeFromParent];
            _bgLayer = [SKNode node];
            [self addChild: _bgLayer];
        
            [self ScrollingForeground];
            [self ScrollingBackground];
        
            [station.physicsBody applyImpulse:CGVectorMake(-2, 0)]; //"train" starts moving again so station has to move away
        
            count2 = 0;
            count = 0;
        }
        else {
            chances--;
        }
    }
    
    //clicks to level transitions
    if ([button.name isEqual: @"level4"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level4 *scene = [Level4 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if ([button.name isEqual: @"level3"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level3 *scene = [Level3 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
    }
    else if ([button.name isEqualToString:@"Skip"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        Level4 *scene = [Level4 sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
        //stop repeating instructions
        [instructionTimer invalidate];
        instructionTimer = nil;
    }
}


-(void)update:(NSTimeInterval)currentTime {
    count++;
    if (count2 == 0) {
        if(check == 2) {//purple head in train
            count2++;
        
            [text removeFromParent];   //clear text
            text = [SKNode node];  //re init text
            [self addChild:text];
        
            [self hint];
        }
    
        else if(check == 3) { //blue and purp in train
            count2++;
            
            [text removeFromParent];   //clear text
            text = [SKNode node];
            [self addChild:text];

            [self hint];
        }
    
        else if(check == 4) {
            //stop repeating instructions
            [instructionTimer invalidate];
            instructionTimer = nil;
            
            if(count >= 30) {
                count2++;
            
                [text removeFromParent]; //erase and re-add text
                text = [SKNode node];
                [self addChild:text];
            
                [self nextLevel];
            }
        }
        else if(count >= 28) { //call next level function once train reaches right side of screen
                [self stopTrain];
        }
    }
}


@end
