/*******************************************************************************
 * Copyright (c) 2012 by Adrien Fischer.
 * This content is released under the MIT License.
 * For questions mail me at adrien[at]revolugame[dot]com
 ******************************************************************************/

package com.revolugame.hxSpriter;

import haxe.xml.Fast;

/**
 * ...
 * @author Adrien Fischer
 */
class DataFrameSprite implements haxe.Public
{
	static inline var SPRITES_DIR : String = 'sprites/';

	var image : String;
	var color : Int;
	var opacity : Float;
	var angle : Float;
	var xflip : Bool;
	var yflip : Bool;
	var width : Float;
	var height : Float;
	var x : Float;
	var y : Float;
	
	public function new (source: Fast) 
	{
		image = source.node.image.innerData;
		image = SPRITES_DIR + StringTools.replace(image, '\\', '/');
		
		color = Std.parseInt( source.node.color.innerData );
		
		opacity = Std.parseFloat( source.node.opacity.innerData ) * 0.01;
		
		angle = Std.parseFloat( source.node.angle.innerData );
		if(angle == 360) angle = 0;
		
		xflip = source.node.xflip.innerData == "1";
		yflip = source.node.yflip.innerData == "1";
		
		width = Std.parseInt( source.node.width.innerData );
		height = Std.parseInt( source.node.height.innerData );
		x = Std.parseInt( source.node.x.innerData );
		y = Std.parseInt( source.node.y.innerData );
	}		

}
