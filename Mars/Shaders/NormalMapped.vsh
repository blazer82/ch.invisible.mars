//
//  NormalMapped.vsh
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texture;
attribute vec3 tangent;

//varying lowp vec4 colorVarying;
varying lowp vec3 normalVarying;
varying lowp vec2 textureVarying;
varying lowp vec3 tangentVarying;

varying lowp vec3 lightVarying;
varying lowp vec3 eyeVarying;
varying lowp vec3 halfVarying;

uniform lowp mat4 modelViewProjectionMatrix;
uniform lowp mat3 normalMatrix;

void main()
{
    vec3 lightPosition = vec3(10.0, 5.0, 100.0);
    
    // Building the matrix Eye Space -> Tangent Space
    vec3 n = normalize(normalMatrix * normal);
    vec3 t = normalize(normalMatrix * tangent);
    vec3 b = cross(n, t);
    
    vec4 vertexPosition = modelViewProjectionMatrix * position;
    vec3 lightDir = normalize(lightPosition - vertexPosition.xyz);
    
    // transform light and half angle vectors by tangent basis
    vec3 v;
    v.x = dot(lightDir, t);
    v.y = dot(lightDir, b);
    v.z = dot(lightDir, n);
    lightVarying = normalize(v);
    
    v.x = dot(vertexPosition.xyz, t);
    v.y = dot(vertexPosition.xyz, b);
    v.z = dot(vertexPosition.xyz, n);
    eyeVarying = normalize(v);
    
    vertexPosition = normalize(vertexPosition);
    
    // Normalize the halfVector to pass it to the fragment shader
    
    // No need to divide by two, the result is normalized anyway.
	// vec3 halfVector = normalize((vertexPosition + lightDir) / 2.0); 
	vec3 halfVector = normalize(vertexPosition.xyz + lightDir);
	v.x = dot(halfVector, t);
	v.y = dot(halfVector, b);
	v.z = dot(halfVector, n);
    
    halfVarying = v;
    
    // Pass texture coordinate to the FSH
    normalVarying = normal;
    textureVarying = texture;
    tangentVarying = tangent;
    
    gl_Position = vertexPosition;
    
    
    
    
    
    // old stuff
    
    //vec3 eyeNormal = normalize(normalMatrix * normal);
    
    //vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    //float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    //colorVarying = diffuseColor * nDotVP;
    
    //gl_Position = modelViewProjectionMatrix * position;
}
