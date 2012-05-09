package com.revolugame.hxSpriter;

#if flash
import flash.display.Bitmap;
import flash.display.BitmapData;
import nme.geom.ColorTransform;
#elseif (cpp || neko)
import nme.display.Tilesheet;
#end

import flash.display.Sprite;
import flash.events.Event;
import nme.Lib;


/**
 * Classic implementation of Spriter
 * @author Adrien Fischer [http://revolugame.com]
 */
class BitmapSpriter extends Sprite 
{
	var _character : DataSpriterCharacter;
	
	var _propertiesChanged : Bool;	
	public var smooth(default, setSmooth):Bool;	
	var _last : Int;
		
	#if flash
	var _bitmap : Bitmap;
	#elseif(cpp || neko)
	var _canvas : Sprite;
	#end
	
	var _blittingRenderer : BlittingRenderer;

    /**
     * 
     * @param pData : SCML file name
     * @param pX pY : initial position
     * @param pAutoUpdate
     */
	public function new(pData: String, ?pX: Float = 0, ?pY: Float = 0, ?pAutoUpdate: Bool = false)
	{
		super();
		
		x = pX;
		y = pY;
		
		_character = new DataSpriterCharacter(pData, onCharacterChangeFrame);
		
		if(pAutoUpdate)
    		addEventListener(Event.ENTER_FRAME, update);
			
		#if flash
		_bitmap = new Bitmap();
		addChild(_bitmap);
		#elseif(cpp || neko)
		_canvas = new Sprite();
		addChild(_canvas);
		#end
		
		_blittingRenderer = new BlittingRenderer();
			
		_last = Lib.getTimer();
		smooth = true;
	}
	
	/**
	 * Used to update the animation
	 */
	public function update(?pEvt:Event):Void 
	{
		var _time : Int = Lib.getTimer();
		var elapsed : Float = (_time - _last) * 0.001;
		if (elapsed > 0.0333) elapsed = 0.0333;
		_character.update(elapsed);
		_last = _time;
			
		if (_propertiesChanged)
		{
			onCharacterChangeFrame();
			_propertiesChanged = false;
		}
	}
	
	private function onCharacterChangeFrame():Void
	{
		var frame:DataFrame = _character.frame;
			
		_blittingRenderer.updateFrame(frame, smooth);
		
		#if flash
		_bitmap.x = frame.x;
		_bitmap.y = frame.y;
		
		_bitmap.bitmapData = _blittingRenderer.buffer;
		
		#elseif (cpp || neko)
		_canvas.graphics.clear();
		for(bufferData in _blittingRenderer.buffer)
		{
			var newData : Array<Float> = bufferData.data.copy();
			newData[0] += frame.x;
			newData[1] += frame.y;
			
			_canvas.graphics.drawTiles(bufferData.tilesheet, newData, true, bufferData.flags);
		}
		#end
	}
		
	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play, as specified in the Spriter File.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @param	frame		Frame of the animation to start from, if restarted.
	 */
	public function playAnimation(pName:String, ?pReset:Bool = false, ?pFrame:Int = 0):Void
	{
		_character.play(pName, pReset, pFrame);
	}
		
	/**
	 * If the animation images should be drawn transformed with pixel smoothing.
	 * This will affect drawing performance, but look less pixelly.
	 */
	public function setSmooth(value:Bool):Bool
	{
		_propertiesChanged = true;
		smooth = value;
		#if flash
		_bitmap.smoothing = smooth;
		#end
		return value;
	}
}
