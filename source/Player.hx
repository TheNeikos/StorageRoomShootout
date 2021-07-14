package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import lime.math.Vector2;
import weapons.Bullet;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		drag.x = drag.y = 2000;
		solid = true;

		animation.add("walk", [0], 6, true);
		animation.play("walk");

		origin.set(8.5, 10.5);
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		shoot();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up = false;
		var down = false;
		var left = false;
		var right = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		var direction = new Vector2();

		if (up)
		{
			direction.y -= 1;
		}
		if (down)
		{
			direction.y += 1;
		}
		if (left)
		{
			direction.x -= 1;
		}
		if (right)
		{
			direction.x += 1;
		}

		direction.normalize(1);
		direction.x *= SPEED;
		direction.y *= SPEED;

		if (direction.length > 0)
		{
			velocity.set(direction.x, direction.y);
		}

		var mousePosition = FlxG.mouse.getWorldPosition();

		var position:FlxPoint = getMidpoint().subtract(mousePosition.x, mousePosition.y);

		angle = Math.atan2(position.y, position.x) * 180 / Math.PI - 90;
	}

	function shoot()
	{
		if (FlxG.mouse.justPressed)
		{
			var bullet_pos = getMidpoint().add(0, -10).rotate(getMidpoint(), angle);

			Bullet.createNew(bullet_pos.x, bullet_pos.y, 700, angle);
		}
	}
}
