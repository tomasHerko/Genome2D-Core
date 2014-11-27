/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.textures;

import com.genome2d.context.IContext;
import com.genome2d.geom.GRectangle;

class GCharTexture extends GTexture {
    private var g2d_xoffset:Float = 0;
    #if swc @:extern #end
    public var xoffset(get, set):Float;
    #if swc @:getter(xoffset) #end
    inline private function get_xoffset():Float {
        return g2d_xoffset*scaleFactor;
    }
    #if swc @:setter(xoffset) #end
    inline private function set_xoffset(p_value:Float):Float {
        g2d_xoffset = p_value/scaleFactor;
        return g2d_xoffset;
    }

    private var g2d_yoffset:Float = 0;
    #if swc @:extern #end
    public var yoffset(get, set):Float;
    #if swc @:getter(yoffset) #end
    inline private function get_yoffset():Float {
        return g2d_yoffset*scaleFactor;
    }
    #if swc @:setter(yoffset) #end
    inline private function set_yoffset(p_value:Float):Float {
        g2d_yoffset = p_value/scaleFactor;
        return g2d_yoffset;
    }

    private var g2d_xadvance:Float = 0;
    #if swc @:extern #end
    public var xadvance(get, set):Float;
    #if swc @:getter(xadvance) #end
    inline private function get_xadvance():Float {
        return g2d_xadvance*scaleFactor;
    }
    #if swc @:setter(xadvance) #end
    inline private function set_xadvance(p_value:Float):Float {
        g2d_xadvance = p_value/scaleFactor;
        return g2d_xadvance;
    }
}