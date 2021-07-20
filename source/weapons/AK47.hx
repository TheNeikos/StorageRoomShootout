package weapons;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class AK47 extends Weapon
{
	var shotSound:FlxSound;

	public function new()
	{
		var icon = new FlxSprite().loadGraphic(AssetPaths.entities__png, true, 16, 16);
		icon.frame = icon.frames.getByIndex(5 * 16 + 3);
		super(icon, Heavy);
		damage = 8;
		speed = 600;
		shotCooldown = 0.12;
		shotSound = FlxG.sound.load(AssetPaths.gunshot__ogg);
	}

	override function createBullet(origin:FlxPoint, angle:Float, num:Int):Bullet
	{
		angle += FlxG.random.int(-5, 5);
		return super.createBullet(origin, angle, num);
	}

	override function doShoot(origin:FlxPoint, angle:Float)
	{
		super.doShoot(origin, angle);
		shotSound.play(true);
	}
}
