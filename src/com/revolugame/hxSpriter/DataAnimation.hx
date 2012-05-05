package com.revolugame.hxSpriter;

import haxe.xml.Fast;

/**
 * ...
 * @author adrien
 */
class DataAnimation 
{
	public var name(default, null) : String;
	var _frames : Array<DataAnimationFrame>;
	
	public var frame : DataAnimationFrame;
	var _frameIndex : Int;
	var _elapsed : Float;
	
	var _onChangeFrame : Void->Void;
	
	public function new (pSource: Fast, pOnChangeFrame: Void->Void) 
	{
		name = pSource.node.name.innerData;
		_elapsed = 0;
		_frameIndex = 0;
		
		_frames = new Array();
		
		var node : Fast;
		for(node in pSource.nodes.frame)
			_frames.push( new DataAnimationFrame(node) );
		
		_onChangeFrame = pOnChangeFrame;
	}
	
	public function update(pElapsed : Float):Void
	{
		_elapsed += pElapsed;
		
		if(_elapsed > frame.duration)
		{
			_elapsed -= frame.duration;
			++_frameIndex;
			if (_frameIndex >= _frames.length) _frameIndex = 0;
			frame = _frames[_frameIndex];
				
			_onChangeFrame();
		}
	}
	
	public function reset(pNewFrame:Int):Void
	{
		_frameIndex = pNewFrame;
		_elapsed = 0;
		frame = _frames[_frameIndex];
	}

}