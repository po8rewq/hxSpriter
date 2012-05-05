package com.revolugame.hxSpriter;

import flash.geom.Point;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxObject;

/**
 * Flixel implementation of Spriter
 * @author Adrien Fischer
 */
class FlxSpriter extends FlxObject
{
	var _character : DataSpriterCharacter;
	
	/**
	 * If the animation images should be drawn transformed with pixel smoothing.
	 * This will affect drawing performance, but look less pixelly.
	 */
	public var antialiasing(default, setAntialiasing) : Bool;
	
	var _propertiesChanged : Bool;
		
	var _blittingRenderer : BlittingRenderer;
	var _offsetX:Float;
	var _offsetY:Float;
	
	#if flash
	var _flashPoint : Point;
	#end
	
	/**
	 * @param pData : nom du fichier XML
	 */
	public function new(pData: String, ?pX: Float = 0, ?pY: Float = 0)
	{
		super(pX, pY);
		
		antialiasing = true;
		_propertiesChanged = false;
		
		#if flash
		_flashPoint = new Point();
		#end
		
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
				
			_point.x = _offsetX + x - Std.int(camera.scroll.x * scrollFactor.x);
			_point.y = _offsetY + y - Std.int(camera.scroll.y * scrollFactor.y);
			_point.x += (_point.x > 0) ? 0.0000001 : -0.0000001;
			_point.y += (_point.y > 0) ? 0.0000001 : -0.0000001;
			
			#if flash
			_flashPoint.x = _point.x;
			_flashPoint.y = _point.y;
			camera.buffer.copyPixels(_blittingRenderer.buffer, _blittingRenderer.buffer.rect, _flashPoint, null, null, true);
			#else 
			
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
			
	public function setAntialiasing(value:Bool):Bool
	{
		antialiasing = value;
		_propertiesChanged = true;
		return value;
	}

}