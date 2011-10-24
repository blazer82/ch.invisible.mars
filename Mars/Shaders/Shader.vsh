//
//  Shader.vsh
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texture;

varying lowp vec4 colorVarying;
varying lowp vec2 textureVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.2, 0.3);
    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    colorVarying = diffuseColor * nDotVP;
    
    // Pass texture coordinate to the FSH
    textureVarying = texture;
    
    gl_Position = modelViewProjectionMatrix * position;
}
