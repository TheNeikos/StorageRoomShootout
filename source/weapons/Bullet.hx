package weapons;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.helpers.FlxBounds;
import haxe.Timer;

class Bullet extends FlxSprite
{
	public static var BULLETS:FlxTypedGroup<Bullet> = new FlxTypedGroup();
	public static var BULLET_SPARKLES:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup();

	public static function createNew(x:Float, y:Float, speed:Float, angle:Float):Bullet
	{
		var bullet:Bullet = BULLETS.recycle(Bullet, function()
		{
			return new Bullet(x, y);
		});
		bullet.revive();
		bullet.x = x;
		bullet.y = y;
		bullet.angle = angle;

		var direction = new FlxVector(0, -speed);
		direction.rotateByDegrees(angle);
		bullet.velocity.set(direction.x, direction.y);

		return bullet;
	}

	private function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		// makeGraphic(4, 4, FlxColor.YELLOW);
		animation.add("idle", [4 * 16 + 2 - 1], 1, true);
		offset = new FlxPoint(5, 5);
		height = 3;
		width = 3;

		solid = true;
		animation.play("idle");
	}

	override function kill()
	{
		// var emitter:FlxEmitter = BULLET_SPARKLES.recycle(null, function()
		// {
		// 	var emitter = new FlxEmitter(x, y, 5);
		// 	for (_ in 0...5)
		// 	{
		// 		var part = new FlxParticle();
		// 		part.makeGraphic(1, 5, FlxColor.fromInt(0xCC777700));
		// 		part.drag.x = part.drag.y = 3000;
		// 		emitter.add(part);
		// 	}

		// 	emitter.allowCollisions = FlxObject.ANY;

		// 	return emitter;
		// });
		// emitter.revive();
		// emitter.x = x;
		// emitter.y = y;
		// // emitter.launchAngle = new FlxBounds();
		// emitter.angle.start = new FlxBounds(180 + angle - 30 - 5, 180 + angle - 30 + 5);
		// emitter.angle.end = new FlxBounds(180 + angle + 30 - 5, 180 + angle + 30 + 5);
		// emitter.lifespan.min = 0.05;
		// emitter.lifespan.max = 0.1;
		// emitter.speed.start = new FlxBounds(250.0, 300);
		// emitter.speed.end = new FlxBounds(300.0, 560);
		// emitter.start();

		super.kill();
	}
}
