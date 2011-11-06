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

varying lowp vec3 lightVarying;
varying lowp vec3 eyeVarying;
varying lowp vec3 halfVarying;

void main()
{
    // lookup normal from normal map, move from [0,1] to  [-1, 1] range, normalize
	lowp vec3 normal = 2.0 * texture2D(normalMapSampler, textureVarying.st).rgb - 1.0;
	normal = normalize(normal);
    
    // compute diffuse lighting
	lowp float lamberFactor = max(dot(lightVarying, normal), 0.0);
	lowp vec4 diffuseMaterial = vec4(0.0, 0.0, 0.0, 1.0);
	lowp vec4 diffuseLight  = vec4(0.0, 0.0, 0.0, 1.0);
    
    // compute specular lighting
	lowp vec4 specularMaterial;
	lowp vec4 specularLight;
	lowp float shininess;
    
    // compute ambient
	lowp vec4 ambientLight = vec4(0.2, 0.2, 0.2, 1.0);
    
    //if (lamberFactor > 0.0)
	//{
		diffuseMaterial = texture2D(textureSampler, textureVarying.st);
		diffuseLight  = vec4(1.0, 1.0, 1.0, 1.0);
		
		specularMaterial = vec4(0.1, 0.4, 0.1, 1.0);
		specularLight = vec4(0.4, 0.4, 0.4, 1.0);
		shininess = pow(max(dot(halfVarying, normal), 0.0), 2.0);
        
        //gl_FragColor =	diffuseMaterial * diffuseLight;
		gl_FragColor =	diffuseMaterial * diffuseLight * lamberFactor;
		gl_FragColor +=	specularMaterial * specularLight * shininess;				
	//}
    
    gl_FragColor +=	ambientLight;
    
    
    
    // old stuff
    
    // Extract the normal from the normal map  
    //lowp vec3 normal = normalize(texture2D(normalMapSampler, textureVarying.st).rgb * 2.0 - 1.0); 
    
    //lowp vec3 eyeNormal = normalize(normalMatrix * normal);
    //lowp vec3 eyeNormal2 = normalize(normalMatrix * normalVarying);
    //eyeNormal = normalize(eyeNormal);
    //lowp vec3 lightPosition = vec3(0.0, 0.8, 0.3);
    //lowp vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    //lowp float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    //lowp vec4 color = diffuseColor * nDotVP;
    
    //lowp vec4 textureColor = texture2D(textureSampler, textureVarying.st);
    //gl_FragColor =  textureColor * color;
    //gl_FragColor = vec4((tangentVarying + 1.0) / 2.0, 1.0);
}
