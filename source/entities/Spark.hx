package entities;

import flixel.effects.particles.FlxParticle;

class Spark extends FlxParticle
{
	override function update(elapsed:Float)
	{
		angle = Math.atan2(velocity.y, velocity.x) * 180 / Math.PI + 90;
		super.update(elapsed);
	}
}
