//
//  Shader.fsh
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

uniform sampler2D textureSampler;

varying lowp vec4 colorVarying;
varying lowp vec2 textureVarying;

void main()
{
    //gl_FragColor = colorVarying;
    lowp vec4 textureColor = texture2D(textureSampler, textureVarying.st);
    gl_FragColor = textureColor * colorVarying;
}
