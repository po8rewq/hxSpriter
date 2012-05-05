package com.revolugame.hxSpriter;

import haxe.xml.Fast;
import nme.display.BitmapInt32;

/**
 * ...
 * @author Adrien Fischer
 */
class DataFrameSprite implements haxe.Public
{
	var image : String;
	
	#if neko
	var color : BitmapInt32;
	#elseif flash
	var color: UInt;
	#else
	var color: Int;
	#end
	
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
		image = StringTools.replace(image, '\\', '/');
		
		#if neko
		color = {rgb: Std.parseInt( source.node.color.innerData ), a: 0xff}; // TODO
		#else
		color = Std.parseInt(source.node.color.innerData);
		#end
		
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
