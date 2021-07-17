package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import lime.math.Vector2;
import weapons.Weapon;
import weapons.WeaponInventory;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;

	var weapons:WeaponInventory = new WeaponInventory();

	var activeWeapon(default, set):Weapon;

	public var onActiveWeaponChange:Weapon->Void;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		drag.x = drag.y = 2000;
		solid = true;

		animation.add("walk", [for (i in 0...8) i], 6, true);
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		activeWeapon.update(elapsed);
		shoot();
		switchWeapon();
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
			animation.play("walk");
		}
		else
		{
			animation.stop();
		}

		var mousePosition = FlxG.mouse.getWorldPosition();

		var position:FlxPoint = getMidpoint().subtract(mousePosition.x, mousePosition.y);

		angle = Math.atan2(position.y, position.x) * 180 / Math.PI - 90;
	}

	function shoot()
	{
		if (FlxG.mouse.pressed)
		{
			if (activeWeapon != null)
			{
				activeWeapon.shoot(getMidpoint(), angle);
			}
		}
	}

	function switchWeapon()
	{
		if (FlxG.mouse.wheel != 0)
		{
			if (FlxG.mouse.wheel > 0)
			{
				activeWeapon = weapons.nextWeapon();
			}
			if (FlxG.mouse.wheel < 0)
			{
				activeWeapon = weapons.prevWeapon();
			}
		}
	}

	public function addWeapon(weapon:Weapon)
	{
		activeWeapon = weapons.addWeapon(weapon);
	}

	function set_activeWeapon(value:Weapon):Weapon
	{
		if (onActiveWeaponChange != null)
			onActiveWeaponChange(value);
		return activeWeapon = value;
	}
}
