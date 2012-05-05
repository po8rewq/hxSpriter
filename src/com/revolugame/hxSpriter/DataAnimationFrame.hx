/*******************************************************************************
 * Copyright (c) 2012 by Adrien Fischer.
 * This content is released under the MIT License.
 * For questions mail me at adrien[at]revolugame[dot]com
 ******************************************************************************/

package com.revolugame.hxSpriter;

import haxe.xml.Fast;

/**
 * ...
 * @author adrien
 */
class DataAnimationFrame implements haxe.Public
{
	var name : String;
	var duration : Float;
	
	public function new (source: Fast) 
	{
		name = source.node.name.innerData;
		duration = Std.parseFloat(source.node.duration.innerData) / 100;
	}		

}
