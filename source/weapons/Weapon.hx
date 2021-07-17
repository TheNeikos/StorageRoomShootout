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
	var count:Float = 1;
	var pattern:Int->Int->Float->Float->Float->FlxPoint = function(count, i, x, y, angle)
	{
		return new FlxPoint(x, y);
	};

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
		Bullet.createNew(origin.x, origin.y, speed, angle, damage);
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
