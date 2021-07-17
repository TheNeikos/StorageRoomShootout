package weapons;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Pistol extends Weapon
{
	public function new()
	{
		var icon = new FlxSprite().loadGraphic(AssetPaths.entities__png, true, 16, 16);
		icon.frame = icon.frames.getByIndex(5 * 16 + 1);
		super(icon, Pistols);
		damage = 7;
		speed = 500;
		shotCooldown = 0.3;
	}
}