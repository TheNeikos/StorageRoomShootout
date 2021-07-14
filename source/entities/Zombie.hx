package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

class Zombie extends FlxSprite
{
	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	var speed:Float;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		var animStart = 16;
		animation.add("walk", [
			animStart,
			animStart + 1,
			animStart + 2,
			animStart + 3,
			animStart + 4,
			animStart + 5,
			animStart + 6,
			animStart + 7
		], 12, true);
		solid = true;
		animation.play("walk");

		brain = new FSM(idle);
		idleTimer = 0;
		playerPosition = FlxPoint.get();
		speed = 140;
	}

	override function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		brain.activeState = idle;
		idleTimer = 0;
	}

	function idle(elapsed:Float)
	{
		if (seesPlayer)
		{
			brain.activeState = chase;
		}
		else if (idleTimer <= 0)
		{
			if (FlxG.random.bool(1))
			{
				moveDirection = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				moveDirection = FlxG.random.int(0, 8) * 45;

				velocity.set(speed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), moveDirection);
			}
			idleTimer = FlxG.random.int(1, 4);
		}
		else
		{
			idleTimer -= elapsed;
		}
	}

	function chase(elapsed:Float)
	{
		if (!seesPlayer)
		{
			brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, playerPosition, speed);
		}
	}
}
