package weapons;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import weapons.WeaponInventory.WeaponCategory;

abstract class Weapon
{
	var nextShot:Float;
	var shotCooldown:Float = 1;
	var damage:Float = 5;
	var speed:Float = 250;
	var count:Int = 1;
	var knockback:Float = 50;

	public var icon(get, null):FlxSprite;

	var category:WeaponCategory;

	public function new(icon:FlxSprite, category:WeaponCategory)
	{
		this.icon = icon;
		this.category = category;
	}

	public function update(delta:Float)
	{
		if (nextShot > 0)
			nextShot -= delta;
	}

	public function shoot(origin:FlxPoint, angle:Float):Void
	{
		if (nextShot > 0)
		{
			return;
		}

		nextShot = shotCooldown;

		doShoot(origin, angle);
	}

	function doShoot(origin:FlxPoint, angle:Float)
	{
		for (i in 0...count)
		{
			createBullet(origin, angle, i);
		}
	}

	function createBullet(origin:FlxPoint, angle:Float, count:Int):Bullet
	{
		return Bullet.createNew(origin.x, origin.y, speed, angle, damage);
	}

	public function getCategory():WeaponCategory
	{
		return category;
	}

	function get_icon():FlxSprite
	{
		return icon;
	}
}
