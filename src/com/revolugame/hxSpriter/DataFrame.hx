package com.revolugame.hxSpriter;

import haxe.xml.Fast;

/**
 * ...
 * @author adrien
 */
class DataFrame implements haxe.Public
{
	private static var _frameSizeCache:Hash<DataRectangle> = new Hash();

	var name : String;
	var sprites : List<DataFrameSprite>;
		
	var width : Int;
	var height : Int;
	var x : Int;
	var y : Int;
	
	public function new (pSource: Fast) 
	{	
		name = pSource.node.name.innerData;
		
		width = 0;
		height = 0;
		
		var rect : DataRectangle;
		var cached : Bool = false;
		if(_frameSizeCache.exists(name) )
		{
			rect = _frameSizeCache.get(name);
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
				
			cached = true;
		}
		
		sprites = new List();
		var sprite : Fast;
		if(cached)
		{
			for(sprite in pSource.nodes.sprite)
				sprites.add(new DataFrameSprite(sprite));
		}
		else
		{
			rect = new DataRectangle();
			var s : DataFrameSprite;
			for(sprite in pSource.nodes.sprite)
			{
				s = new DataFrameSprite(sprite);
				determineBoundingBox(s, rect);
					
				if( Math.isNaN(x) || x > rect.x) 
					x = rect.x;
					
				if( Math.isNaN(x) || y > rect.y) 
					y = rect.y;
					
				if (width < rect.width) width = rect.width;
				if (height < rect.height) height = rect.height;
					
				sprites.add(s);
			}
			_frameSizeCache.set(name, new DataRectangle(x, y, width, height) );
			rect = null;
		}
	}
	
	private function determineBoundingBox(sprite: DataFrameSprite, rect: DataRectangle):Void
	{
		var theta:Float = sprite.angle;
		var ct:Float = Math.cos(theta * 0.017453292519943295);
		var st:Float = Math.sin(theta * 0.017453292519943295);
			
		var x1:Float = sprite.x;
		var y1:Float = sprite.y;
		var x2:Float = sprite.x + sprite.width;
		var y2:Float = sprite.y + sprite.height;
			
		var x1prim:Float = x1 * ct - y1 * st;
		var y1prim:Float = x1 * st + y1 * ct;
		 
		var x12prim:Float = x1 * ct - y2 * st;
		var y12prim:Float = x1 * st + y2 * ct;
		 
		var x2prim:Float = x2 * ct - y2 * st;
		var y2prim:Float = x2 * st + y2 * ct;
		 
		var x21prim:Float = x2 * ct - y1 * st;
		var y21prim:Float = x2 * st + y1 * ct;        
		 
		var rx1:Float = Math.min( Math.min(x1prim, x2prim), Math.min(x12prim, x21prim) );
		var ry1:Float = Math.min( Math.min(y1prim, y2prim), Math.min(y12prim, y21prim) );
		 
		var rx2:Float = Math.max( Math.max(x1prim, x2prim), Math.max(x12prim, x21prim) );
		var ry2:Float = Math.max( Math.max(y1prim, y2prim), Math.max(y12prim, y21prim) );
			
		rect.x = Math.floor(rx1);
		rect.y = Math.floor(ry1);
		rect.width = Math.ceil(rx2 - rx1);
		rect.height = Math.ceil(ry2 - ry1);
			
		if (sprite.xflip) rect.x -= rect.width;
		if (sprite.yflip) rect.y -= rect.height;
	}

}
