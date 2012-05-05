package com.revolugame.hxSpriter;

import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.BitmapInt32;

import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.display.Tilesheet;

/**
 * ...
 * @author adrien
 */
class BlittingRenderer 
{
	public var buffer 	: BitmapData;
	
	public function new () 
	{
		
	}
	
	public function updateFrame(frame: DataFrame, smooth: Bool):Void
	{
		var sprites : List<DataFrameSprite> = frame.sprites;
		
		var offsetX : Float = frame.x;
		var offsetY : Float = frame.y;
		
		//#if flash
		buffer = new BitmapData( Std.int(frame.width - offsetX), Std.int(frame.height - offsetY), true, 0);
		#if (cpp || neko)
		canvas = new Sprite();
		#end
		
		var x : Float = 0; 
		var y : Float = 0; 
		var angle : Float = 0; 
		var scaleX : Float = 1; 
		var scaleY : Float = 1;
		var color : Int = 0;
		var img : BitmapData;
		
		var point : Point = new Point();
		var matrix : Matrix = new Matrix();
		
		var sprite : DataFrameSprite;
		for(sprite in sprites)
		{
			img = nme.Assets.getBitmapData( 'sprites/' + sprite.image );
			
			x = sprite.x - offsetX;
			y = sprite.y - offsetY;
				
			color = sprite.color;
			
//			#if flash
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.redMultiplier = (color >> 16 & 0xFF) / 255;
			colorTransform.blueMultiplier = (color >> 8 & 0xFF) / 255;
			colorTransform.greenMultiplier = (color & 0xFF) / 255;
			colorTransform.alphaMultiplier = sprite.opacity;
//			#end
			
			angle = -sprite.angle;
			
			scaleX = sprite.width / img.width;
			scaleY = sprite.height / img.height;
				
			if (sprite.xflip) scaleX = -scaleX;
			if (sprite.yflip) scaleY = -scaleY;
				
			if (sprite.color != 0xFFFFFF || sprite.opacity != 1 || angle != 0 || scaleX != 1 || scaleY != 1)
			{
				matrix.b = matrix.c = 0;
				matrix.a = scaleX;
				matrix.d = scaleY;
			
				if (angle != 0) 
					matrix.rotate(angle * 0.017453292519943295);
					
				matrix.tx = x;
				matrix.ty = y;
				
				buffer.draw(img, matrix, colorTransform, null, null, smooth);
			}
			else
			{
				point.x = x;
				point.y = y;
				buffer.copyPixels(img, img.rect, point, null, null, true);
			}
		}
	}

} 