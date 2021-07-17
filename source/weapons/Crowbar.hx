package weapons;

import entities.DamageArea;
import entities.Zombie;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Crowbar extends Weapon
{
	public function new()
	{
		var icon = new FlxSprite().loadGraphic(AssetPaths.entities__png, true, 16, 16);
		icon.frame = icon.frames.getByIndex(5 * 16);
		super(icon, Melee);
		damage = 5;
		speed = 300;
		shotCooldown = 0.4;
	}

	override function doShoot(origin:FlxPoint, angle:Float)
	{
		var center = FlxPoint.weak(origin.x, origin.y).subtract(8, 8);
		var newPos = FlxPoint.weak(center.x, center.y + 10).rotate(center, angle + 180);
		var shape = new FlxSprite(newPos.x, newPos.y).loadGraphic(AssetPaths.entities__png, true, 16, 16);
		shape.frame = shape.frames.getByIndex(4 * 16);
		shape.angle = angle;
		// var vertices = [
		// FlxPoint.weak(3, 0),
		// FlxPoint.weak(0, 16),
		// FlxPoint.weak(24, 16),
		// FlxPoint.weak(21, 0),
		// ];
		//
		// shape.drawPolygon(vertices, FlxColor.TRANSPARENT);

		var damageArea = DamageArea.createNew(0.03, damage, 1, shape);
		damageArea.onDamage = function(enemy:FlxSprite)
		{
			if (enemy is Zombie)
			{
				enemy.velocity.copyFrom(FlxPoint.weak(0, -1).rotate(FlxPoint.weak(), angle).scale(75));

				cast(enemy, Zombie).stun(0.5);
			}
		};
	}
}
