package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState, 2));
		FlxG.scaleMode = new PixelPerfectScaleMode();
	}
}
