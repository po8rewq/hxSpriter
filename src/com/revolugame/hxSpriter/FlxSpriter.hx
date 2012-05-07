package com.revolugame.hxSpriter;

import flash.geom.Point;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

import org.flixel.tileSheetManager.TileSheetManager;

import nme.display.Tilesheet;

import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BitmapData;

/**
 * Flixel implementation of Spriter
 * @author Adrien Fischer
 */
class FlxSpriter extends FlxSprite
{
	var _character : DataSpriterCharacter;
	
	var _propertiesChanged : Bool;
		
	var _blittingRenderer : BlittingRenderer;
	
	var _offsetX : Float;
	var _offsetY : Float;
	
	/**
	 * @param pData : XML file name
	 */
	public function new(pData: String, ?pX: Float = 0, ?pY: Float = 0)
	{
		super(pX, pY);
		
		antialiasing = true;
		_propertiesChanged = false;
		
		_character = new DataSpriterCharacter( pData, onCharacterChangeFrame);
		_blittingRenderer = new BlittingRenderer();
	}
	
	/**
	 * Updates the animation.
	 */
	public override function update():Void 
	{	
		super.update();
		
		_character.update(FlxG.elapsed);
		
		if(_propertiesChanged)
		{
			onCharacterChangeFrame();
			_propertiesChanged = false;
		}
	}
	
	private function onCharacterChangeFrame():Void 
	{
		var frame : DataFrame = _character.frame;
		
		_offsetX = frame.x;
		_offsetY = frame.y;
		
		_blittingRenderer.updateFrame(frame, antialiasing);
	}
	
	/**
	 * Called by game loop, renders current frame of animation to the screen.
	 */
	override public function draw():Void 
	{
		if(_flickerTimer != 0)
		{
			_flicker = !_flicker;
			if(_flicker)
				return;
		}
			
		if(cameras == null)
			cameras = FlxG.cameras;
		
		var camera:FlxCamera;
		var i : Int = 0;
		var l : Int = cameras.length;
		
		while(i < l)
		{
			camera = cameras[i++];
			
			if(!onScreen(camera))
				continue;
				
			_point.x = _offsetX + x - Math.floor(camera.scroll.x * scrollFactor.x);
			_point.y = _offsetY + y - Math.floor(camera.scroll.y * scrollFactor.y);
			
			#if flash
			_point.x += (_point.x > 0) ? 0.0000001 : -0.0000001;
			_point.y += (_point.y > 0) ? 0.0000001 : -0.0000001;
			
			_flashPoint.x = _point.x;
			_flashPoint.y = _point.y;
			camera.buffer.copyPixels(_blittingRenderer.buffer, _blittingRenderer.buffer.rect, _flashPoint, null, null, true);
			
			#elseif (cpp || neko)
			for(bufferData in _blittingRenderer.buffer)
			{
				var newData : Array<Float> = bufferData.data.copy();
				newData[0] += Math.floor(_point.x) + origin.x; //_point.x;
				newData[1] += Math.floor(_point.y) + origin.y; //_point.y;

				camera._canvas.graphics.drawTiles(bufferData.tilesheet, newData, true, bufferData.flags);
			}
			#end
				
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(camera);
		}
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
	
}