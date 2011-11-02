//
//  IEGeometryController.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGeometryController.h"

typedef struct
{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Vertex3D, Normal3D;

typedef struct
{
    GLfloat s;
    GLfloat t;
} Texture3D;

typedef struct
{
    ushort v1;
    ushort v2;
    ushort v3;
    ushort t1;
    ushort t2;
    ushort t3;
    ushort n1;
    ushort n2;
    ushort n3;
} Face3D;

@interface IEGeometryController ()
{
    
}
@property (nonatomic) Vertex3D *vertices;
@property (nonatomic) Texture3D *textures;
@property (nonatomic) Normal3D *normals;
@property (nonatomic) Face3D *faces;
@property (nonatomic) ushort vertexCount;
@property (nonatomic) ushort normalCount;
@property (nonatomic) ushort textureCount;
@property (nonatomic) ushort faceCount;

- (void)parseObjFileWithName:(NSString *)name;
- (void)createVertexDataforShapeNode:(IEShapeNode*)node;
- (void)freeSourceData;

@end

@implementation IEGeometryController

@synthesize geometry = _geometry;
@synthesize vertices = _vertices;
@synthesize textures = _textures;
@synthesize normals = _normals;
@synthesize faces = _faces;
@synthesize vertexCount = _vertexCount;
@synthesize normalCount = _normalCount;
@synthesize textureCount = _textureCount;
@synthesize faceCount = _faceCount;

- (id)initGeometryNamed:(NSString *)file forShapeNode:(IEShapeNode*)node
{
    self = [super init];
    
    _geometry = [[IEGeometry alloc] init];
    
    [self parseObjFileWithName:file];
    [self createVertexDataforShapeNode:(IEShapeNode*)node];
    
    return self;
}

/*
 Parse data using the following interpretation
 
 Vertices:
 v -2.513752 0.664635 -2.320141
 x         y        z
 
 Textures:
 vt 0.492577 0.667442
 s         t 
 
 Normals:
 vn 0.000000 -1.000000 0.000000
 x         y        z
 
 Faces:
 f 1/1/1 2/2/1 3/2/1
 --> means 3 vertices, 3 textures and 3 normals
 --> vertice 1 (x, y, z), vertice 2 (x, y, z), vertice 3 (x, y, z)
 --> texture 1 (s, t), texture 2 (s, t), texture 2 (s, t)
 --> normal 1 (x, y, z), normal 1 (x, y, z), normal 1 (x, y, z)
 
 12 faces with 3 vertices makes 36 vertices! that's it :)
 */
- (void)parseObjFileWithName:(NSString *)name
{
    NSString *contents;
    contents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"obj"] encoding:NSUTF8StringEncoding error:nil];
    
    //NSLog(contents);
    
    NSArray *lines = [[NSArray alloc] initWithArray:[contents componentsSeparatedByString:@"\n"]];
    NSString *line;
    
    self.vertexCount = 0;
    self.textureCount = 0;
    self.normalCount = 0;
    self.faceCount   = 0;
    
    // count lines
    for (line in lines)
    {
        if ([line hasPrefix:@"v "])
        {
            self.vertexCount++;
        }
        else if ([line hasPrefix:@"vt "])
        {
            self.textureCount++;
        }
        else if ([line hasPrefix:@"vn "])
        {
            self.normalCount++;
        }
        else if ([line hasPrefix:@"f "])
        {
            self.faceCount++;
        }
    }
    
    // init arrays
    self.vertices = malloc(sizeof(Vertex3D) * self.vertexCount);
    self.textures = malloc(sizeof(Texture3D) * self.textureCount);
    self.normals  = malloc(sizeof(Normal3D) * self.normalCount);
    self.faces    = malloc(sizeof(Face3D) * self.faceCount);
    
    uint vIndex = 0;
    uint vtIndex = 0;
    uint vnIndex = 0;
    uint fIndex = 0;
    
    // parse lines
    for (line in lines)
    {
        if ([line hasPrefix:@"v "])
        {
            //NSLog(line);
            NSArray *verticePoints = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.vertices[vIndex].x = [[verticePoints objectAtIndex:1] floatValue];
            self.vertices[vIndex].y = [[verticePoints objectAtIndex:2] floatValue];
            self.vertices[vIndex].z = [[verticePoints objectAtIndex:3] floatValue];
            vIndex++;
        }
        else if ([line hasPrefix:@"vn "])
        {
            //NSLog(line);
            NSArray *normalPoints = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.normals[vnIndex].x = [[normalPoints objectAtIndex:1] floatValue];
            self.normals[vnIndex].y = [[normalPoints objectAtIndex:2] floatValue];
            self.normals[vnIndex].z = [[normalPoints objectAtIndex:3] floatValue];
            vnIndex++;
        }
        else if ([line hasPrefix:@"vt "])
        {
            //NSLog(line);
            NSArray *normalPoints = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.textures[vtIndex].s = [[normalPoints objectAtIndex:1] floatValue];
            self.textures[vtIndex].t = [[normalPoints objectAtIndex:2] floatValue];
            vtIndex++;
        }
        else if ([line hasPrefix:@"f "])
        {
            //NSLog(line);
            NSArray *faceInfoGroups = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            // group 1
            NSString *group = [faceInfoGroups objectAtIndex:1];
            NSArray *groupParts = [group componentsSeparatedByString:@"/"];
            self.faces[fIndex].v1 = [[groupParts objectAtIndex:0] intValue] -1;
            self.faces[fIndex].t1 = [[groupParts objectAtIndex:1] intValue] -1;
            self.faces[fIndex].n1 = [[groupParts objectAtIndex:2] intValue] -1;
            
            // group 2
            group = [faceInfoGroups objectAtIndex:2];
            groupParts = [group componentsSeparatedByString:@"/"];
            self.faces[fIndex].v2 = [[groupParts objectAtIndex:0] intValue] -1;
            self.faces[fIndex].t2 = [[groupParts objectAtIndex:1] intValue] -1;
            self.faces[fIndex].n2 = [[groupParts objectAtIndex:2] intValue] -1;
            
            // group 3
            group = [faceInfoGroups objectAtIndex:3];
            groupParts = [group componentsSeparatedByString:@"/"];
            self.faces[fIndex].v3 = [[groupParts objectAtIndex:0] intValue] -1;
            self.faces[fIndex].t3 = [[groupParts objectAtIndex:1] intValue] -1;
            self.faces[fIndex].n3 = [[groupParts objectAtIndex:2] intValue] -1;
            
            fIndex++;
        }
    }
}


- (void)createVertexDataforShapeNode:(IEShapeNode*)node
{
    _geometry.dataLength = self.faceCount * 3; // 3 vertices per face
    _geometry.dataSize   = sizeof(GLfloat) * self.faceCount * 24; // 24 floats per face
    _geometry.vertexData = malloc(_geometry.dataSize);
    
    // prepare bounding box
    IEBoundingBox boundingBox;
    boundingBox.min.x = 0.0f;
    boundingBox.min.y = 0.0f;
    boundingBox.min.z = 0.0f;
    boundingBox.max.x = 0.0f;
    boundingBox.max.y = 0.0f;
    boundingBox.max.z = 0.0f;
    
    for (ushort faceIndex = 0; faceIndex < self.faceCount; faceIndex++)
    {
        _geometry.vertexData[(faceIndex * 24) + 0] = self.vertices[self.faces[faceIndex].v1].x;
        _geometry.vertexData[(faceIndex * 24) + 1] = self.vertices[self.faces[faceIndex].v1].y;
        _geometry.vertexData[(faceIndex * 24) + 2] = self.vertices[self.faces[faceIndex].v1].z;
        _geometry.vertexData[(faceIndex * 24) + 3] = self.textures[self.faces[faceIndex].t1].s;
        _geometry.vertexData[(faceIndex * 24) + 4] = self.textures[self.faces[faceIndex].t1].t;
        _geometry.vertexData[(faceIndex * 24) + 5] = self.normals[self.faces[faceIndex].n1].x;
        _geometry.vertexData[(faceIndex * 24) + 6] = self.normals[self.faces[faceIndex].n1].y;
        _geometry.vertexData[(faceIndex * 24) + 7] = self.normals[self.faces[faceIndex].n1].z;
        
        _geometry.vertexData[(faceIndex * 24) + 8] = self.vertices[self.faces[faceIndex].v2].x;
        _geometry.vertexData[(faceIndex * 24) + 9] = self.vertices[self.faces[faceIndex].v2].y;
        _geometry.vertexData[(faceIndex * 24) + 10] = self.vertices[self.faces[faceIndex].v2].z;
        _geometry.vertexData[(faceIndex * 24) + 11] = self.textures[self.faces[faceIndex].t2].s;
        _geometry.vertexData[(faceIndex * 24) + 12] = self.textures[self.faces[faceIndex].t2].t;
        _geometry.vertexData[(faceIndex * 24) + 13] = self.normals[self.faces[faceIndex].n2].x;
        _geometry.vertexData[(faceIndex * 24) + 14] = self.normals[self.faces[faceIndex].n2].y;
        _geometry.vertexData[(faceIndex * 24) + 15] = self.normals[self.faces[faceIndex].n2].z;
        
        _geometry.vertexData[(faceIndex * 24) + 16] = self.vertices[self.faces[faceIndex].v3].x;
        _geometry.vertexData[(faceIndex * 24) + 17] = self.vertices[self.faces[faceIndex].v3].y;
        _geometry.vertexData[(faceIndex * 24) + 18] = self.vertices[self.faces[faceIndex].v3].z;
        _geometry.vertexData[(faceIndex * 24) + 19] = self.textures[self.faces[faceIndex].t3].s;
        _geometry.vertexData[(faceIndex * 24) + 20] = self.textures[self.faces[faceIndex].t3].t;
        _geometry.vertexData[(faceIndex * 24) + 21] = self.normals[self.faces[faceIndex].n3].x;
        _geometry.vertexData[(faceIndex * 24) + 22] = self.normals[self.faces[faceIndex].n3].y;
        _geometry.vertexData[(faceIndex * 24) + 23] = self.normals[self.faces[faceIndex].n3].z;
    }
    
    // compute the bounding box
    for (int vIndex = 0; vIndex < self.vertexCount; vIndex++)
    {
        // min
        if (self.vertices[vIndex].x < boundingBox.min.x)
        {
            boundingBox.min.x = self.vertices[vIndex].x;
        }
        if (self.vertices[vIndex].y < boundingBox.min.y)
        {
            boundingBox.min.y = self.vertices[vIndex].y;
        }
        if (self.vertices[vIndex].z < boundingBox.min.z)
        {
            boundingBox.min.z = self.vertices[vIndex].z;
        }
        
        // max
        if (self.vertices[vIndex].x > boundingBox.max.x)
        {
            boundingBox.max.x = self.vertices[vIndex].x;
        }
        if (self.vertices[vIndex].y > boundingBox.max.y)
        {
            boundingBox.max.y = self.vertices[vIndex].y;
        }
        if (self.vertices[vIndex].z > boundingBox.max.z)
        {
            boundingBox.max.z = self.vertices[vIndex].z;
        }
    }
    
    node.geometry = _geometry;
    
    [self freeSourceData];
    
    /*for (ushort i = 0; i < (self.faceCount * 18); i++)
     {
     NSLog([NSString stringWithFormat:@"%f", self.vertexData[i]]);
     }*/
}

- (void)freeSourceData
{
    free(_vertices);
    free(_textures);
    free(_normals);
    free(_faces);
}

- (void)dealloc
{
    //[self freeSourceData];
    self.geometry = nil;
}

@end
