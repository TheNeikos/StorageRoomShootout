package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;

class Zombie extends FlxSprite
{
	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	var speed:Float;
	var stunTimer:Float;
	var zombieDeathSound:FlxSound;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		var animStart = 16;
		animation.add("walk", [
			for (i in 0...8)
				animStart + i
		], 12, true);
		solid = true;
		animation.play("walk");

		brain = new FSM(idle);
		idleTimer = 0;
		playerPosition = FlxPoint.get();
		speed = 20;
		health = 20;
		zombieDeathSound = FlxG.sound.load(AssetPaths.zombie_death__ogg);
	}

	override function update(elapsed:Float)
	{
		if (stunTimer <= 0)
		{
			angle = Math.atan2(velocity.y, velocity.x) * 180 / Math.PI + 90;
		}

		zombieDeathSound.proximity(x, y, FlxG.camera.target, FlxG.width * 0.6);

		brain.update(elapsed);
		super.update(elapsed);
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		brain.activeState = idle;
		idleTimer = 0;
		health = 20;
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

	public function stun(time:Float)
	{
		brain.activeState = stunned;
		stunTimer = time;
	}

	function stunned(elapsed:Float)
	{
		stunTimer -= elapsed;

		if (stunTimer <= 0)
		{
			brain.activeState = idle;
		}
	}

	override function hurt(Damage:Float)
	{
		super.hurt(Damage);
		Fx.blood(getMidpoint());
	}

	override function kill()
	{
		super.kill();

		zombieDeathSound.play();
		Fx.zombieBody(getMidpoint());
	}
}
