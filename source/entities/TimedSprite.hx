package entities;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class TimedSprite extends FlxSprite
{
	var lifeTime:Float;

	public function new(x:Float, y:Float, lifeTime:Float)
	{
		super(x, y);

		this.lifeTime = lifeTime;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lifeTime > 0)
			lifeTime -= elapsed;

		if (lifeTime <= 0)
			FlxTween.tween(this, {alpha: 0}, 0.2, {
				onComplete: (_) -> kill(),
			});
	}

	public function setLifetime(lifeTime:Float)
	{
		this.lifeTime = lifeTime;
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		alpha = 1;
	}
}
