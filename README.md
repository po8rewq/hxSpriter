hxSpriter
=========

Haxe port of the spriterAS3 library by [Abel Toy](http://abeltoy.com/projects/spriterAS3)

Version 0.1 
By [Adrien Fischer](http://revolugame.com)


Quick Install Guide
-------------------

You need NME to use this library.


Getting Started Guide
---------------------

In your NME file, all Spriter's ressources must be in the sprites directory.

```bash
<assets path="path/to/the/sprites/directory" rename="sprites" />
```

Flixel
------

```bash
var spriter : FlxSpriter = new FlxSpriter('sprites/BetaFormatHero.SCML', 200, 300);
add(spriter);
spriter.playAnimation('idle_healthy');

spriter = new FlxSpriter('sprites/BetaFormatHero.SCML', 400, 300);
add(spriter);
spriter.playAnimation("walk");
```

HaxePunk
--------

