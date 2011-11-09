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
    ushort v1;
    ushort v2;
    ushort v3;
    ushort t1;
    ushort t2;
    ushort t3;
    ushort n1;
    ushort n2;
    ushort n3;
    GLKVector3 tangent;
    ushort tangent1;
    ushort tangent2;
    ushort tangent3;
} Face3D;

@interface IEGeometryController ()
{
    
}
@property (nonatomic) GLKVector3 *vertices;
@property (nonatomic) GLKVector2 *textures;
@property (nonatomic) GLKVector3 *normals;
@property (nonatomic) GLKVector3 *tangents;
@property (nonatomic) Face3D *faces;
@property (nonatomic) ushort vertexCount;
@property (nonatomic) ushort normalCount;
@property (nonatomic) ushort textureCount;
@property (nonatomic) ushort faceCount;

- (void)parseObjFileWithName:(NSString *)name;
- (void)createVertexDataforShapeNode:(IEShapeNode*)node;
- (void)computeTangents;
- (void)freeSourceData;

@end

@implementation IEGeometryController

@synthesize geometry = _geometry;
@synthesize vertices = _vertices;
@synthesize textures = _textures;
@synthesize normals = _normals;
@synthesize tangents = _tangents;
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
    self.vertices = malloc(sizeof(GLKVector3) * self.vertexCount);
    self.textures = malloc(sizeof(GLKVector2) * self.textureCount);
    self.normals  = malloc(sizeof(GLKVector3) * self.normalCount);
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
    _geometry.dataSize   = sizeof(GLfloat) * self.faceCount * 33; // 33 floats per face
    _geometry.vertexData = malloc(_geometry.dataSize);
    
    // prepare bounding box
    IEBoundingBox boundingBox;
    boundingBox.min.x = 0.0f;
    boundingBox.min.y = 0.0f;
    boundingBox.min.z = 0.0f;
    boundingBox.max.x = 0.0f;
    boundingBox.max.y = 0.0f;
    boundingBox.max.z = 0.0f;
    
    // compute tangents
    [self computeTangents];
    
    for (ushort faceIndex = 0; faceIndex < self.faceCount; faceIndex++)
    {
        _geometry.vertexData[(faceIndex * 33) + 0]  = self.vertices[self.faces[faceIndex].v1].x;
        _geometry.vertexData[(faceIndex * 33) + 1]  = self.vertices[self.faces[faceIndex].v1].y;
        _geometry.vertexData[(faceIndex * 33) + 2]  = self.vertices[self.faces[faceIndex].v1].z;
        _geometry.vertexData[(faceIndex * 33) + 3]  = self.textures[self.faces[faceIndex].t1].s;
        _geometry.vertexData[(faceIndex * 33) + 4]  = self.textures[self.faces[faceIndex].t1].t;
        _geometry.vertexData[(faceIndex * 33) + 5]  = self.normals[self.faces[faceIndex].n1].x;
        _geometry.vertexData[(faceIndex * 33) + 6]  = self.normals[self.faces[faceIndex].n1].y;
        _geometry.vertexData[(faceIndex * 33) + 7]  = self.normals[self.faces[faceIndex].n1].z;
        _geometry.vertexData[(faceIndex * 33) + 8]  = self.tangents[self.faces[faceIndex].tangent1].x;
        _geometry.vertexData[(faceIndex * 33) + 9]  = self.tangents[self.faces[faceIndex].tangent1].y;
        _geometry.vertexData[(faceIndex * 33) + 10] = self.tangents[self.faces[faceIndex].tangent1].z;
        
        _geometry.vertexData[(faceIndex * 33) + 11] = self.vertices[self.faces[faceIndex].v2].x;
        _geometry.vertexData[(faceIndex * 33) + 12] = self.vertices[self.faces[faceIndex].v2].y;
        _geometry.vertexData[(faceIndex * 33) + 13] = self.vertices[self.faces[faceIndex].v2].z;
        _geometry.vertexData[(faceIndex * 33) + 14] = self.textures[self.faces[faceIndex].t2].s;
        _geometry.vertexData[(faceIndex * 33) + 15] = self.textures[self.faces[faceIndex].t2].t;
        _geometry.vertexData[(faceIndex * 33) + 16] = self.normals[self.faces[faceIndex].n2].x;
        _geometry.vertexData[(faceIndex * 33) + 17] = self.normals[self.faces[faceIndex].n2].y;
        _geometry.vertexData[(faceIndex * 33) + 18] = self.normals[self.faces[faceIndex].n2].z;
        _geometry.vertexData[(faceIndex * 33) + 19] = self.tangents[self.faces[faceIndex].tangent2].x;
        _geometry.vertexData[(faceIndex * 33) + 20] = self.tangents[self.faces[faceIndex].tangent2].y;
        _geometry.vertexData[(faceIndex * 33) + 21] = self.tangents[self.faces[faceIndex].tangent2].z;
        
        _geometry.vertexData[(faceIndex * 33) + 22] = self.vertices[self.faces[faceIndex].v3].x;
        _geometry.vertexData[(faceIndex * 33) + 23] = self.vertices[self.faces[faceIndex].v3].y;
        _geometry.vertexData[(faceIndex * 33) + 24] = self.vertices[self.faces[faceIndex].v3].z;
        _geometry.vertexData[(faceIndex * 33) + 25] = self.textures[self.faces[faceIndex].t3].s;
        _geometry.vertexData[(faceIndex * 33) + 26] = self.textures[self.faces[faceIndex].t3].t;
        _geometry.vertexData[(faceIndex * 33) + 27] = self.normals[self.faces[faceIndex].n3].x;
        _geometry.vertexData[(faceIndex * 33) + 28] = self.normals[self.faces[faceIndex].n3].y;
        _geometry.vertexData[(faceIndex * 33) + 29] = self.normals[self.faces[faceIndex].n3].z;
        _geometry.vertexData[(faceIndex * 33) + 30] = self.tangents[self.faces[faceIndex].tangent3].x;
        _geometry.vertexData[(faceIndex * 33) + 31] = self.tangents[self.faces[faceIndex].tangent3].y;
        _geometry.vertexData[(faceIndex * 33) + 32] = self.tangents[self.faces[faceIndex].tangent3].z;
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

/*
 see http://www.terathon.com/code/tangent.html
*/
- (void)computeTangents
{
    // compute face tangents
    for (ushort faceIndex = 0; faceIndex < self.faceCount; faceIndex++)
    {
        Face3D face = self.faces[faceIndex];
        
        GLKVector3 q1 = GLKVector3Subtract(self.vertices[face.v2], self.vertices[face.v1]);
        GLKVector3 q2 = GLKVector3Subtract(self.vertices[face.v3], self.vertices[face.v1]);
    
        GLKVector2 st1 = GLKVector2Subtract(self.textures[face.t2], self.textures[face.t1]);
        GLKVector2 st2 = GLKVector2Subtract(self.textures[face.t3], self.textures[face.t1]);
    
        GLKMatrix3 qMatrix = GLKMatrix3Make(q1.x, q1.y, q1.z, q2.x, q2.y, q2.z, 0.0f, 0.0f, 0.0f);
        GLKMatrix3 stMatrix = GLKMatrix3Make(st1.s, st1.t, 0.0f, st2.s, st2.t, 0.0f, 0.0f, 0.0f, 0.0f);
    
        BOOL* isInvertible = malloc(sizeof(BOOL));
        GLKMatrix3 stMatrixInverted = GLKMatrix3Invert(stMatrix, isInvertible);
    
        if (!isInvertible)
        {
            NSLog(@"Error: stMatrix was NOT invertible");
        }
    
        GLKMatrix3 tangentMatrix = GLKMatrix3Multiply(stMatrixInverted, GLKMatrix3Multiply(stMatrix, qMatrix));
    
        self.faces[faceIndex].tangent = GLKVector3Make(tangentMatrix.m00, tangentMatrix.m01, tangentMatrix.m02);
    }
    
    self.tangents = malloc(sizeof(GLKVector3) * self.textureCount);
    
    ushort vertexIndex = 0;
    for (ushort faceIndex1 = 0; faceIndex1 < self.faceCount; faceIndex1++)
    {
        Face3D face1 = self.faces[faceIndex1];
        
        // average face tangets for vertex1
        uint facesCount = 0;
        GLKVector3 vertexTangent = GLKVector3Make(0.0f, 0.0f, 0.0f);
        for (ushort faceIndex2 = 0; faceIndex2 < self.faceCount; faceIndex2++)
        {
            Face3D face2 = self.faces[faceIndex2];
            
            if ((face1.v1 == face2.v1 && face1.t1 == face2.t1)
                || (face1.v1 == face2.v2 && face1.t1 == face2.t2)
                || (face1.v1 == face2.v3 && face1.t1 == face2.t3))
            {
                vertexTangent = GLKVector3Add(vertexTangent, face2.tangent);
                facesCount++;
            }
        }
        vertexTangent = GLKVector3Normalize(GLKVector3DivideScalar(vertexTangent, facesCount));
        self.tangents[vertexIndex] = vertexTangent;
        face1.tangent1 = vertexIndex;
        vertexIndex++;
        
        // average face tangets for vertex2
        facesCount = 0;
        vertexTangent = GLKVector3Make(0.0f, 0.0f, 0.0f);
        for (ushort faceIndex2 = 0; faceIndex2 < self.faceCount; faceIndex2++)
        {
            Face3D face2 = self.faces[faceIndex2];
            
            if ((face1.v2 == face2.v1 && face1.t2 == face2.t1)
                || (face1.v2 == face2.v2 && face1.t2 == face2.t2)
                || (face1.v2 == face2.v3 && face1.t2 == face2.t3))
            {
                vertexTangent = GLKVector3Add(vertexTangent, face2.tangent);
                facesCount++;
            }
        }
        vertexTangent = GLKVector3Normalize(GLKVector3DivideScalar(vertexTangent, facesCount));
        self.tangents[vertexIndex] = vertexTangent;
        face1.tangent2 = vertexIndex;
        vertexIndex++;
        
        // average face tangets for vertex3
        facesCount = 0;
        vertexTangent = GLKVector3Make(0.0f, 0.0f, 0.0f);
        for (ushort faceIndex2 = 0; faceIndex2 < self.faceCount; faceIndex2++)
        {
            Face3D face2 = self.faces[faceIndex2];
            
            if ((face1.v3 == face2.v1 && face1.t3 == face2.t1)
                || (face1.v3 == face2.v2 && face1.t3 == face2.t2)
                || (face1.v3 == face2.v3 && face1.t3 == face2.t3))
            {
                vertexTangent = GLKVector3Add(vertexTangent, face2.tangent);
                facesCount++;
            }
        }
        vertexTangent = GLKVector3Normalize(GLKVector3DivideScalar(vertexTangent, facesCount));
        self.tangents[vertexIndex] = vertexTangent;
        face1.tangent3 = vertexIndex;
        vertexIndex++;
    }
}

- (void)freeSourceData
{
    free(_vertices);
    free(_textures);
    free(_normals);
    free(_tangents);
    free(_faces);
}

- (void)dealloc
{
    //[self freeSourceData];
    self.geometry = nil;
}

@end
