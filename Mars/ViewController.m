//
//  ViewController.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {

}
@property (strong, nonatomic) Game *game;

- (void)tearDownGL;
@end

@implementation ViewController

@synthesize game = _game;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _game = [[Game alloc] init];
    [_game setupWithView:(GLKView *)self.view];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    /*[self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return NO;
    }
}

- (void)tearDownGL
{
    /*[EAGLContext setCurrentContext:self.context];
     
     glDeleteBuffers(1, &_vertexBuffer);
     glDeleteVertexArraysOES(1, &_vertexArray);
     
     self.effect = nil;
     
     if (_program) {
     glDeleteProgram(_program);
     _program = 0;
     }*/
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [_game update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [_game render:self.timeSinceLastDraw];
}

@end
