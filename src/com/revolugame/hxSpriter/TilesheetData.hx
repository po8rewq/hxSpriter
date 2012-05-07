package com.revolugame.hxSpriter;

#if (cpp || neko)
import nme.display.Tilesheet;

/**
 * ...
 * @author Adrien Fischer
 */
class TilesheetData 
{
	public var tilesheet : Tilesheet;
	
	/** Drawing data */
	public var data : Array<Float>;
	
	/** Drawing flags */
	public var flags:Int;
	
	public function new (pTilesheet: Tilesheet, pFlags: Int, pData: Array<Float>) 
	{
		tilesheet = pTilesheet;
		flags = pFlags;
		data = pData;
	}		

}
#end