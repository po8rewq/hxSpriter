package com.revolugame.hxSpriter;

/**
 * ...
 * @author Adrien Fischer
 */
class DataRectangle implements haxe.Public
{
	var x : Int;
	var y : Int;
	var width : Int;
	var height : Int;
	
	public function new (?pX: Int = 0, ?pY: Int = 0, ?pWidth: Int = 0, ?pHeight:Int = 0)
	{
		x = pX;
		y = pY;
		width = pWidth;
		height = pHeight;
	}		

}
