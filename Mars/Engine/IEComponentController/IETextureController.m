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
- (IETexture*)createTexture;
- (void)freeImage;

@end

@implementation IETextureController

@synthesize shapeNode = _shapeNode;
@synthesize image = _image;

- (id)initTextureNamed:(NSString *)name forShapeNode:(IEShapeNode *)shapeNode
{
    self = [super init];
    
    _shapeNode = shapeNode;
    
    [self loadImage:name];
    _shapeNode.texture = [self createTexture];
    
    [self freeImage];
    
    return self;
}

- (void)loadNormalMapNamed:(NSString *)name
{
    [self loadImage:name];
    _shapeNode.normalMap = [self createTexture];
    
    [self freeImage];
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

- (IETexture *)createTexture
{
    CGImageRef cgImage;
    CGContextRef context;
    CGColorSpaceRef	colorSpace;
    
    IETexture *texture = [[IETexture alloc] init];
    
    // Sets the CoreGraphic Image to work on it.
    cgImage = [self.image CGImage];
    
    // Sets the image's size.
    texture.width = CGImageGetWidth(cgImage);
    texture.height = CGImageGetHeight(cgImage);
    
    // Extracts the pixel informations and place it into the data.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    texture.imageData = malloc(texture.width * texture.height * 4);
    context = CGBitmapContextCreate(texture.imageData, texture.width, texture.height, 8, 4 * texture.width, colorSpace,
                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // Adjusts position and invert the image.
    // The OpenGL uses the image data upside-down compared commom image files.
    CGContextTranslateCTM(context, 0, texture.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Clears and ReDraw the image into the context.
    CGContextClearRect(context, CGRectMake(0, 0, texture.width, texture.height));
    CGContextDrawImage(context, CGRectMake(0, 0, texture.width, texture.height), cgImage);
    
    // Releases the context.
    CGContextRelease(context);
    
    return texture;
}

- (void)freeImage
{
    self.image = nil;
}

- (void)dealloc
{
    self.shapeNode = nil;
    [self freeImage];
}

@end
