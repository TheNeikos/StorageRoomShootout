package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class DamageArea extends FlxSprite
{
	public static var DAMAGE_AREAS:FlxTypedGroup<DamageArea> = new FlxTypedGroup();

	public var damage:Float;

	var lifetime:Float;
	var seenEnemies:Map<FlxSprite, Float> = new Map();
	var damageCooldown:Float;

	public var onDamage:(enemy:FlxSprite) -> Void;

	public static function createNew(lifetime:Float, dmg:Float, cooldown:Float, shape:FlxSprite):DamageArea
	{
		var area:DamageArea = DAMAGE_AREAS.recycle(DamageArea, function()
		{
			return new DamageArea();
		});
		area.revive();
		area.lifetime = lifetime;
		area.damage = dmg;
		area.angle = shape.angle;
		area.setShape(shape);
		area.damageCooldown = cooldown;
		area.seenEnemies = new Map();
		area.onDamage = null;

		return area;
	}

	public function new(?shape:FlxSprite)
	{
		super(0, 0);
		if (shape != null)
		{
			setShape(shape);
		}
		makeGraphic(16, 16);
		moves = false;
		// solid = false;
	}

	function setShape(shape:FlxSprite)
	{
		x = shape.x;
		y = shape.y;
		angle = shape.angle;
		loadGraphicFromSprite(shape);
		frame = shape.frame;
		shape.destroy();
	}

	override function update(elapsed:Float)
	{
		if (lifetime <= 0)
		{
			kill();
		}
		else
		{
			lifetime -= elapsed;
		}

		for (enemyTime in seenEnemies.keyValueIterator())
		{
			enemyTime.value += elapsed;

			if (enemyTime.value > damageCooldown)
			{
				seenEnemies.remove(enemyTime.key);
			}
		}

		super.update(elapsed);
	}

	public function doDamageTo(enemy:FlxSprite)
	{
		if (seenEnemies.get(enemy) == null)
		{
			enemy.hurt(damage);
			seenEnemies.set(enemy, 0);

			if (onDamage != null)
			{
				onDamage(enemy);
			}
		}
	}
}
