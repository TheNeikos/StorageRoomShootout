package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class EnemySpawner extends FlxSprite
{
	var enemyPool:FlxTypedGroup<Zombie>;
	var nextSpawn:Float;
	var direction:levels.LevelProject.Enum_Direction;
	var maxAmount:Int;

	public function new(x:Float, y:Float, dir:levels.LevelProject.Enum_Direction, pool:FlxTypedGroup<Zombie>, max:Int)
	{
		super(x, y);
		enemyPool = pool;
		direction = dir;
		maxAmount = max;

		loadGraphic(AssetPaths.tiles__png, true, 16, 16);
		animation.add("idle", [5 * 16 + 5], 1, true);
		solid = true;
		immovable = true;
		animation.play("idle");
		nextSpawn = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (nextSpawn <= 0)
		{
			var new_position = getSpawnPosition().add(x, y);
			var enemy:Zombie = enemyPool.recycle(Zombie, function()
			{
				return new Zombie(x + new_position.x, y + new_position.y);
			});

			enemy.reset(new_position.x, new_position.y);

			nextSpawn = FlxG.random.int(5, 8);
			maxAmount -= 1;
		}
		else if (maxAmount > 0)
		{
			nextSpawn -= elapsed;
		}
	}

	function getSpawnPosition()
	{
		return switch (direction)
		{
			case Up: new FlxPoint(0, -width);
			case Down: new FlxPoint(0, width);
			case Left: new FlxPoint(-width, 0);
			case Right: new FlxPoint(width, 0);
		};
	}
}
