package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import weapons.Weapon;

class WeaponDrop extends FlxSprite
{
	public static var WEAPON_DROPS:FlxTypedGroup<WeaponDrop> = new FlxTypedGroup();

	public var weapon(get, default):Weapon;

	public static function createNew(x:Float, y:Float, weapon:Weapon):WeaponDrop
	{
		var area:WeaponDrop = WEAPON_DROPS.recycle(WeaponDrop, function()
		{
			return new WeaponDrop(x, y, weapon);
		});
		area.reset(x, y);
		area.weapon = weapon;

		return area;
	}

	public function new(x:Float, y:Float, weapon:Weapon)
	{
		super(x, y);
		this.weapon = weapon;

		loadGraphicFromSprite(weapon.icon);
		frame = weapon.icon.frame;
	}

	public function get_weapon():Weapon
	{
		return weapon;
	}
}
