//
//  IETextureController.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IETextureController.h"

@interface IETextureController ()
{
    
}
@property (nonatomic, strong) UIImage *image;

- (void)loadImage:(NSString *)file;
- (void)createImageDataForShapeNode:(IEShapeNode*)shapeNode;
- (void)freeImage;

@end

@implementation IETextureController

@synthesize texture = _texture;
@synthesize image = _image;

- (id)initTextureNamed:(NSString *)name forShapeNode:(IEShapeNode *)shapeNode
{
    self = [super init];
    
    [self loadImage:name];
    [self createImageDataForShapeNode:shapeNode];
    
    [self freeImage];
    
    return self;
}

- (void)loadImage:(NSString *)file
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"png"];
    self.image = [[UIImage alloc] initWithContentsOfFile:path]; 
    
    if (self.image == nil)
    {
        NSLog(@"Error loading image");
    }
}

- (void)createImageDataForShapeNode:(IEShapeNode *)shapeNode
{
    CGImageRef cgImage;
    CGContextRef context;
    CGColorSpaceRef	colorSpace;
    
    _texture = [[IETexture alloc] init];
    
    // Sets the CoreGraphic Image to work on it.
    cgImage = [self.image CGImage];
    
    // Sets the image's size.
    _texture.width = CGImageGetWidth(cgImage);
    _texture.height = CGImageGetHeight(cgImage);
    
    // Extracts the pixel informations and place it into the data.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    _texture.imageData = malloc(_texture.width * _texture.height * 4);
    context = CGBitmapContextCreate(_texture.imageData, _texture.width, _texture.height, 8, 4 * _texture.width, colorSpace,
                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // Adjusts position and invert the image.
    // The OpenGL uses the image data upside-down compared commom image files.
    CGContextTranslateCTM(context, 0, _texture.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Clears and ReDraw the image into the context.
    CGContextClearRect(context, CGRectMake(0, 0, _texture.width, _texture.height));
    CGContextDrawImage(context, CGRectMake(0, 0, _texture.width, _texture.height), cgImage);
    
    // Releases the context.
    CGContextRelease(context);
    
    shapeNode.texture = _texture;
}

- (void)freeImage
{
    self.image = nil;
}

- (void)dealloc
{
    self.texture = nil;
    [self freeImage];
}

@end
