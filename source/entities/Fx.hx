package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class Fx extends FlxTypedGroup<TimedSprite>
{
	public static var FX:Fx = new Fx();

	public function new()
	{
		super(0);
	}

	static function getSprite():TimedSprite
	{
		return FX.recycle(TimedSprite, () ->
		{
			var sprite = new TimedSprite(0, 0, 20);
			sprite.loadGraphic(AssetPaths.entities__png, true, 16, 16);
			sprite.offset.set(8, 8);
			return sprite;
		});
	}

	public static function blood(pos:FlxPoint)
	{
		var sprite = getSprite();
		sprite.setLifetime(20);
		sprite.reset(pos.x, pos.y);
		var blood = [
			3 * 16 + 12,
			3 * 16 + 13,
			3 * 16 + 14,
			3 * 16 + 15,
			4 * 16 + 12,
			4 * 16 + 13,
			4 * 16 + 14,
			4 * 16 + 15
		];
		FlxG.random.shuffle(blood);
		sprite.frame = sprite.frames.getByIndex(blood[0]);
		sprite.angle = FlxG.random.float(0, 360);
		pos.putWeak();
	}

	public static function zombieBody(pos:FlxPoint)
	{
		var sprite = getSprite();
		sprite.setLifetime(20);
		sprite.reset(pos.x, pos.y);
		var bodies = [3 * 16 + 8, 3 * 16 + 9, 3 * 16 + 10, 3 * 16 + 11];
		FlxG.random.shuffle(bodies);
		sprite.frame = sprite.frames.getByIndex(bodies[0]);
		sprite.angle = FlxG.random.float(0, 360);
		pos.putWeak();
	}
}
