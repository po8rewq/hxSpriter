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
	var _loop : Bool;
	
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
        if(_frameIndex >= _frames.length && !_loop) return;
	
		_elapsed += pElapsed;
		
		if(_elapsed > frame.duration)
		{
			_elapsed -= frame.duration;
			++_frameIndex;
			if (_frameIndex >= _frames.length) 
			{
			    if(_loop) _frameIndex = 0;
			    else return;
			}
			frame = _frames[_frameIndex];				
			_onChangeFrame();
		}
	}
	
	public function reset(pNewFrame:Int, pLoop:Bool):Void
	{
	    _loop = pLoop;
		_frameIndex = pNewFrame;
		_elapsed = 0;
		frame = _frames[_frameIndex];
	}

}
