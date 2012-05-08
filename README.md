HxSpriter
=========

Haxe port of the spriterAS3 library by [Abel Toy](http://abeltoy.com/projects/spriterAS3)

Version 0.9

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

Flixel (flash, cpp)
------

```bash
var spriter : FlxSpriter = new FlxSpriter('BetaFormatHero.SCML', 100, 300);
spriter.playAnimation('idle_healthy');
add(spriter);
```

HaxePunk (flash)
--------

```bash
var spriter : HxpSpriterGraphic = new HxpSpriter('BetaFormatHero.SCML', 100, 300);
spriter.playAnimation('idle_healthy');
addGraphic( spriter );
```

Classic way (flash, cpp)
-------

```bash
var spriter : BitmapSpriter = new BitmapSpriter('BetaFormatHero.SCML', true, true, 100, 300);
spriter.playAnimation('idle_healthy');
addChild(spriter);
```
