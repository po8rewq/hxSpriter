package com.revolugame.hxSpriter;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;

/**
 * ...
 * @author adrien
 */
class BlittingRenderer 
{
	public var buffer 		: BitmapData;
	var _matrix 			: Matrix;
	var _colorTransform 	: ColorTransform;
	var _point 				: Point;
	
	public function new () 
	{
		_matrix = new Matrix();
		_colorTransform = new ColorTransform();
		_point = new Point();
	}
	
	public function updateFrame(frame: DataFrame, smooth: Bool):Void
	{
		var sprites : List<DataFrameSprite> = frame.sprites;
		
		var offsetX : Float = frame.x;
		var offsetY : Float = frame.y;
		
		buffer = new BitmapData( Std.int(frame.width - offsetX), Std.int(frame.height - offsetY), true, 0);
		
		var x : Float = 0; 
		var y : Float = 0; 
		var angle : Float = 0; 
		var scaleX : Float = 1; 
		var scaleY : Float = 1;
		var color : Int = 0;
		var img : BitmapData;
		
		var sprite : DataFrameSprite;
		for(sprite in sprites)
		{
			img = nme.Assets.getBitmapData(sprite.image);
			
			x = sprite.x - offsetX;
			y = sprite.y - offsetY;
				
			color = sprite.color; // TODO NME
			_colorTransform.redMultiplier = (color >> 16 & 0xFF) / 255;
			_colorTransform.blueMultiplier = (color >> 8 & 0xFF) / 255;
			_colorTransform.greenMultiplier = (color & 0xFF) / 255;
			_colorTransform.alphaMultiplier = sprite.opacity;
			
			angle = -sprite.angle;
				
			scaleX = sprite.width / img.width;
			scaleY = sprite.height / img.height;
				
			if (sprite.xflip) scaleX = -scaleX;
			if (sprite.yflip) scaleY = -scaleY;
				
			if (sprite.color != 0xFFFFFF || _colorTransform.alphaMultiplier != 1 || angle != 0 || scaleX != 1 || scaleY != 1)
			{
				_matrix.b = _matrix.c = 0;
				_matrix.a = scaleX;
				_matrix.d = scaleY;
				if (angle != 0) _matrix.rotate(angle * 0.017453292519943295);
				_matrix.tx = x;
				_matrix.ty = y;
				buffer.draw(img, _matrix, _colorTransform, null, null, smooth);
			}
			else
			{
				_point.x = x;
				_point.y = y;
					
				buffer.copyPixels(img, img.rect, _point, null, null, true);
			}
		}
	}

}
