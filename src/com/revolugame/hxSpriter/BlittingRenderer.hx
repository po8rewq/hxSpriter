package com.revolugame.hxSpriter;

import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.BitmapInt32;

#if flash
import nme.geom.ColorTransform;
import nme.geom.Matrix;
#end
import nme.geom.Point;

#if (cpp || neko)
import nme.display.Tilesheet;		
import nme.display.Graphics;	
import flash.geom.Rectangle;
#end

/**
 * ...
 * @author adrien
 */
class BlittingRenderer 
{
	#if flash
	public var buffer 	: BitmapData;
	#elseif(cpp || neko)
	public var buffer : Array<TilesheetData>;
	#end
	
	public function new () 
	{
		
	}
	
	public function updateFrame(frame: DataFrame, smooth: Bool):Void
	{
		var sprites : List<DataFrameSprite> = frame.sprites;
		
		var offsetX : Float = frame.x;
		var offsetY : Float = frame.y;
		
		#if flash
		buffer = new BitmapData( Std.int(frame.width - offsetX), Std.int(frame.height - offsetY), true, 0);
		#elseif (cpp || neko)
		buffer = new Array();
		#end
		
		var x : Float = 0; 
		var y : Float = 0; 
		var angle : Float = 0; 
		var scaleX : Float = 1; 
		var scaleY : Float = 1;
		var img : BitmapData;
		
		var point : Point = new Point();
		var color : Int = 0;
		
		#if flash
		var matrix : Matrix = new Matrix();
		#elseif (cpp || neko)
		var tilesheetData : TilesheetData;
		var tilesheet : Tilesheet;
		var flags : Int = 0; //Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.RGB | Tilesheet.TILE_ALPHA;
		var data : Array<Float>;
		#end
		
		var sprite : DataFrameSprite;
		for(sprite in sprites)
		{
			img = nme.Assets.getBitmapData( 'sprites/' + sprite.image );
			
			x = sprite.x - offsetX;
			y = sprite.y - offsetY;
			
			color = sprite.color;
				
			#if flash
			var colorTransform : ColorTransform = new ColorTransform();
			colorTransform.redMultiplier = (color >> 16 & 0xFF) / 255;
			colorTransform.blueMultiplier = (color >> 8 & 0xFF) / 255;
			colorTransform.greenMultiplier = (color & 0xFF) / 255;
			colorTransform.alphaMultiplier = sprite.opacity;
			#elseif(cpp || neko)
			var red : Int = Math.round( (color >> 16 & 0xFF) / 255 );
			var green : Int = Math.round( (color >> 8 & 0xFF) / 255 );
			var blue : Int = Math.round( (color & 0xFF) / 255 );
			#end
			
			angle = sprite.angle;
			
			scaleX = sprite.width / img.width;
			scaleY = sprite.height / img.height;
				
			if (sprite.xflip) scaleX = -scaleX;
			if (sprite.yflip) scaleY = -scaleY;
			
			#if flash
			if (sprite.color != 0xFFFFFF || sprite.opacity != 1 || angle != 0 || scaleX != 1 || scaleY != 1)
			{
				matrix.b = matrix.c = 0;
				matrix.a = scaleX;
				matrix.d = scaleY;
			
				if (angle != 0) 
					matrix.rotate(angle * 0.017453292519943295 * -1); // much faster than Math.PI / 180
					
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
			#elseif (cpp || neko)			
			flags = 0;
			
			tilesheet = new Tilesheet(img);
			tilesheet.addTileRect(new Rectangle(0,0,img.width,img.height));
			
			data = new Array();
			data[0] = x;
			data[1] = y;
			data[2] = 0;
				
			// Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_RGB | Tilesheet.TILE_ALPHA
			if( scaleX != 1 || scaleY != 1 )
			{
				flags |= Tilesheet.TILE_SCALE;
				data.push( Math.min(scaleX, scaleY) );
			}
				
			if( angle != 0 )
			{
				flags |= Tilesheet.TILE_ROTATION;
				data.push(angle * 0.017453292519943295);
			}
				
			if( sprite.color != 0xFFFFFF )
			{
				flags |= Tilesheet.TILE_RGB;
				data.push(red);
				data.push(green);
				data.push(blue);
			}
				
			if( sprite.opacity != 1 )
			{
				flags |= Tilesheet.TILE_ALPHA;
				data.push( sprite.opacity );
			}
			
			tilesheetData = new TilesheetData(tilesheet, flags, data);
			buffer.push( tilesheetData );
			#end
		}
	}
	
	#if (cpp || neko)
	public function getBitmapData():BitmapData
	{
		return null;
	}
	#end

} 
