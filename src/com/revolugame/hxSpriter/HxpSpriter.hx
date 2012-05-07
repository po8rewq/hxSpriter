package com.revolugame.hxSpriter;

import flash.geom.Point;
import flash.display.BitmapData;

import com.haxepunk.Graphic;
import com.haxepunk.HXP;

/**
 * HaxePunk implementation of Spriter
 * @author Adrien Fischer [http://revolugame.com]
 */
class HxpSpriterGraphic extends Graphic
{
	var _character : DataSpriterCharacter;
	var _blittingRenderer : BlittingRenderer;
	
	var _smooth:Bool;
	var _propertiesChanged : Bool;	
	var _offsetX : Float;
	var _offsetY : Float;

	public function new(pData: String, ?pX: Float = 0, ?pY: Float = 0)
	{
		super();
		x = pX;
		y = pY;
		
		_propertiesChanged = false;
		_smooth = true;
		
		_character = new DataSpriterCharacter(pData, onCharacterChangeFrame);
		_blittingRenderer = new BlittingRenderer();
		
		active = true;
	}
	
	/**
	 * Updates the graphic.
	 */
	public override function update():Void
	{
		super.update();
		
		_character.update(HXP.elapsed);
			
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
		
		_blittingRenderer.updateFrame(frame, _smooth);
	}
	
	/**
	 * Renders the graphic to a BitmapData. Used by FlashPunk to render the graphics to the screen.
	 * 
	 * @param	target	The BitmapData where the graphic will be rendered.
	 * @param	point	The position to draw the graphic.
	 * @param	camera	The camera offset.
	 */
	public override function render(target:BitmapData, point:Point, camera:Point):Void
	{
		_point.x = _offsetX + x + point.x - camera.x * scrollX;
		_point.y = _offsetY + y + point.y - camera.y * scrollY;
		#if flash
		if(_blittingRenderer.buffer !=  null)
			target.copyPixels(_blittingRenderer.buffer, _blittingRenderer.buffer.rect, _point, null, null, true);
		#elseif (cpp || neko)
		
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
}