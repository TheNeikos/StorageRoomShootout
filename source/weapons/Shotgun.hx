package weapons;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Shotgun extends Weapon
{
	public function new()
	{
		var icon = new FlxSprite().loadGraphic(AssetPaths.entities__png, true, 16, 16);
		icon.frame = icon.frames.getByIndex(5 * 16 + 2);
		super(icon, Heavy);
		damage = 6;
		speed = 500;
		shotCooldown = 1;
		count = 5;
	}

	override function createBullet(origin:FlxPoint, angle:Float, num:Int):Bullet
	{
		angle -= 30 / 2;
		angle += 30 / (count - 1) * num;
		return super.createBullet(origin, angle, count);
	}
}
