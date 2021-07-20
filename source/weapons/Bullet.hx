package weapons;

import entities.Spark;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.helpers.FlxBounds;

class Bullet extends FlxSprite
{
	public static var BULLETS:FlxTypedGroup<Bullet> = new FlxTypedGroup();
	public static var BULLET_SPARKLES:FlxTypedGroup<FlxEmitter> = new FlxTypedGroup();

	public var onDamage:FlxTypedSignal<FlxSprite->Void> = new FlxTypedSignal<FlxSprite->Void>();

	var damage(get, default):Float;

	public static function createNew(x:Float, y:Float, speed:Float, angle:Float, dmg:Float):Bullet
	{
		var bullet:Bullet = BULLETS.recycle(Bullet, function()
		{
			return new Bullet(x, y);
		});
		bullet.reset(x, y);
		bullet.angle = angle;
		bullet.damage = dmg;
		bullet.onDamage.removeAll();

		var direction = new FlxVector(0, -speed);
		direction.rotateByDegrees(angle);
		bullet.velocity.set(direction.x, direction.y);

		return bullet;
	}

	private function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		frame = frames.getByIndex(4 * 16 + 1);
		offset = new FlxPoint(8, 8);
		height = 2;
		width = 2;

		solid = true;
	}

	override function kill()
	{
		var emitter:FlxEmitter = BULLET_SPARKLES.recycle(null, function()
		{
			var emitter = new FlxEmitter(x, y, 5);
			for (_ in 0...5)
			{
				var part = new Spark();
				part.makeGraphic(1, 3, FlxColor.fromInt(0xDDFFFF00));
				part.drag.x = part.drag.y = 3000;
				part.elasticityRange.set(0.3, 0.6);
				emitter.add(part);
			}

			emitter.allowCollisions = FlxObject.ANY;

			return emitter;
		});
		emitter.x = x;
		emitter.y = y;
		// emitter.launchAngle = new FlxBounds();
		emitter.angle.start = new FlxBounds(180 + angle - 30 - 5, 180 + angle - 30 + 5);
		emitter.angle.end = new FlxBounds(180 + angle + 30 - 5, 180 + angle + 30 + 5);
		emitter.lifespan.min = 0.05;
		emitter.lifespan.max = 0.1;
		emitter.speed.start = new FlxBounds(250.0, 300);
		emitter.speed.end = new FlxBounds(300.0, 560);
		emitter.color.set(FlxColor.fromInt(0xFFCCCC00), null, FlxColor.fromInt(0xFFFFFF00), null);
		emitter.start();

		super.kill();
	}

	public function get_damage():Float
	{
		return damage;
	}

	public function dealDamageTo(enemy:FlxSprite)
	{
		enemy.hurt(damage);

		onDamage.dispatch(enemy);
	}
}
