//
//  NormalMapped.fsh
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

uniform sampler2D textureSampler;
uniform sampler2D normalMapSampler;

uniform lowp mat3 normalMatrix;

//varying lowp vec4 colorVarying;
varying lowp vec3 normalVarying;
varying lowp vec2 textureVarying;
varying lowp vec3 tangentVarying;

void main()
{
    // Extract the normal from the normal map  
    lowp vec3 normal = normalize(texture2D(normalMapSampler, textureVarying.st).rgb * 2.0 - 1.0); 
    
    lowp vec3 eyeNormal = normalize(normalMatrix * normal);
    lowp vec3 eyeNormal2 = normalize(normalMatrix * normalVarying);
    eyeNormal = normalize(eyeNormal);
    lowp vec3 lightPosition = vec3(0.0, 0.8, 0.3);
    lowp vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    lowp float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    lowp vec4 color = diffuseColor * nDotVP;
    
    lowp vec4 textureColor = texture2D(textureSampler, textureVarying.st);
    //gl_FragColor =  textureColor * color;
    gl_FragColor = vec4((tangentVarying + 1.0) / 2.0, 1.0);
}
