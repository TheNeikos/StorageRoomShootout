package weapons;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Pistol extends Weapon
{
	var shotSound:FlxSound;

	public function new()
	{
		var icon = new FlxSprite().loadGraphic(AssetPaths.entities__png, true, 16, 16);
		icon.frame = icon.frames.getByIndex(5 * 16 + 1);
		super(icon, Pistols);
		damage = 7;
		speed = 500;
		shotCooldown = 0.3;
		shotSound = FlxG.sound.load(AssetPaths.gunshot__ogg);
	}

	override function doShoot(origin:FlxPoint, angle:Float)
	{
		super.doShoot(origin, angle);
		shotSound.play(true);
	}
}
