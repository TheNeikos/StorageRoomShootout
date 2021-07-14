package;

import entities.Crate;
import entities.EnemySpawner;
import entities.Zombie;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import levels.LevelHelper;
import weapons.Bullet;

class PlayState extends FlxState
{
	var player:Player;
	var levels:LevelProject;
	var mapCollision:FlxGroup;
	var obstacleCollision:FlxTypedGroup<Crate>;
	var enemySpawners:FlxTypedGroup<EnemySpawner>;
	var enemies:FlxTypedGroup<Zombie>;

	override public function create()
	{
		super.create();
		player = new Player(20, 20);
		loadMap();

		add(Bullet.BULLETS);
		add(Bullet.BULLET_SPARKLES);

		add(player);

		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT);
		FlxG.camera.zoom = 2;
	}

	function loadMap()
	{
		levels = new LevelProject();
		var spriteGroup = new FlxSpriteGroup();
		var current_level = levels.all_levels.Level_0;

		current_level.l_Background_Data.render(spriteGroup);
		current_level.l_Details.render(spriteGroup);
		spriteGroup.forEach(function(sprite)
		{
			sprite.width = 16;
			sprite.height = 16;
		});
		add(spriteGroup);

		mapCollision = LevelHelper.createColliderFromIntGrid(current_level.l_Background_Data, 1);
		add(mapCollision);

		obstacleCollision = new FlxTypedGroup();
		add(obstacleCollision);

		for (crate in current_level.l_Entities.all_Crate)
		{
			var crateEntity = new Crate(crate.cx * current_level.l_Entities.cWid, crate.cy * current_level.l_Entities.cHei);
			// add(crateEntity);
			obstacleCollision.add(crateEntity);
		}

		enemies = new FlxTypedGroup();
		enemySpawners = new FlxTypedGroup();
		add(enemySpawners);
		add(enemies);

		for (enemySpawn in current_level.l_Entities.all_Enemy_Spawn)
		{
			var spawnerEntity = new EnemySpawner(enemySpawn.cx * current_level.l_Entities.cWid, enemySpawn.cy * current_level.l_Entities.cHei,
				enemySpawn.f_Direction, enemies);
			enemySpawners.add(spawnerEntity);
		}

		for (l_player in current_level.l_Entities.all_Player)
		{
			player.x = l_player.cx * current_level.l_Entities.cWid;
			player.y = l_player.cy * current_level.l_Entities.cHei;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		enemies.forEachAlive(checkEnemyVision);

		// Player collides with the map
		FlxG.collide(mapCollision, player);

		// Player collides with obstacle
		FlxG.collide(obstacleCollision, player);

		// Obstacles collide with map
		FlxG.collide(mapCollision, obstacleCollision);

		// Enemies collide with map
		FlxG.collide(mapCollision, enemies);
		FlxG.collide(obstacleCollision, enemies);
		FlxG.collide(enemies, enemies);

		// Bullets collide with map
		FlxG.collide(Bullet.BULLETS, mapCollision, bulletHit);
		FlxG.collide(Bullet.BULLETS, obstacleCollision, bulletHit);

		FlxG.collide(Bullet.BULLET_SPARKLES, mapCollision);
		FlxG.collide(Bullet.BULLET_SPARKLES, obstacleCollision);
	}

	function bulletHit(bullet:Bullet, map:FlxObject)
	{
		bullet.kill();
	}

	function checkEnemyVision(enemy:Zombie)
	{
		if (true)
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}
}
