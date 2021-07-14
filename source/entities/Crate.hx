package entities;

import flixel.FlxSprite;

class Crate extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.tiles__png, true, 16, 16);
		animation.add("idle", [5 * 16 + 2 - 1], 1, true);
		solid = true;
		immovable = true;
		animation.play("idle");
	}
}
