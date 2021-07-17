package;

import entities.Crate;
import entities.DamageArea;
import entities.EnemySpawner;
import entities.WeaponDrop;
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
import weapons.Crowbar;

class PlayState extends FlxState
{
	var player:Player;
	var levels:LevelProject;
	var mapCollision:FlxTilemap;
	var crateCollision:FlxTypedGroup<Crate>;
	var enemySpawners:FlxTypedGroup<EnemySpawner>;
	var enemies:FlxTypedGroup<Zombie>;
	var hud:HUD;

	override public function create()
	{
		super.create();

		// FlxG.debugger.drawDebug = true;

		player = new Player(20, 20);
		player.addWeapon(new Crowbar());
		loadMap();

		add(Bullet.BULLETS);
		add(Bullet.BULLET_SPARKLES);

		add(DamageArea.DAMAGE_AREAS);

		add(WeaponDrop.WEAPON_DROPS);

		add(player);
		hud = new HUD();
		add(hud);

		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT, 1);
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

		crateCollision = new FlxTypedGroup();
		add(crateCollision);

		var gridWidth = 16;
		var gridHeight = 16;

		for (crate in current_level.l_Entities.all_Crate)
		{
			var crateEntity = new Crate(crate.cx * gridWidth, crate.cy * gridHeight, crate.f_WeaponDrops);
			crateCollision.add(crateEntity);
		}

		enemies = new FlxTypedGroup();
		enemySpawners = new FlxTypedGroup();
		add(enemySpawners);
		add(enemies);

		for (enemySpawn in current_level.l_Entities.all_Enemy_Spawn)
		{
			var spawnerEntity = new EnemySpawner(enemySpawn.cx * gridWidth, enemySpawn.cy * gridHeight, enemySpawn.f_Direction, enemies,
				enemySpawn.f_SpawnCount);
			enemySpawners.add(spawnerEntity);
		}

		for (l_player in current_level.l_Entities.all_Player)
		{
			player.x = l_player.cx * gridWidth;
			player.y = l_player.cy * gridHeight;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		enemies.forEachAlive(checkEnemyVision);

		// Player collides with the map
		FlxG.collide(mapCollision, player);

		// Player collides with obstacle
		FlxG.collide(crateCollision, player);

		// Obstacles collide with map
		FlxG.collide(mapCollision, crateCollision);

		// Enemies collide with map
		FlxG.collide(mapCollision, enemies);
		FlxG.collide(crateCollision, enemies);
		FlxG.collide(enemies, enemies);

		// Bullets collide with map
		FlxG.collide(Bullet.BULLETS, mapCollision, bulletHit);

		// Bullets hits crates
		FlxG.collide(Bullet.BULLETS, crateCollision, bulletHitObstacle);

		// Bullets hit enemies
		FlxG.collide(Bullet.BULLETS, enemies, bulletHitEnemy);

		FlxG.collide(Bullet.BULLET_SPARKLES, mapCollision);
		FlxG.collide(Bullet.BULLET_SPARKLES, crateCollision);

		FlxG.overlap(DamageArea.DAMAGE_AREAS, enemies, enemiesHitDamageArea);
		FlxG.overlap(DamageArea.DAMAGE_AREAS, crateCollision, crateHitDamageArea);

		FlxG.overlap(player, WeaponDrop.WEAPON_DROPS, playerPickWeaponDrop);
	}

	function bulletHit(bullet:Bullet, map:FlxObject)
	{
		bullet.kill();
	}

	function bulletHitEnemy(bullet:Bullet, enemy:Zombie)
	{
		enemy.hurt(bullet.get_damage());
		bullet.kill();
	}

	function bulletHitObstacle(bullet:Bullet, crate:Crate)
	{
		crate.hurt(bullet.get_damage());
		bullet.kill();
	}

	function checkEnemyVision(enemy:Zombie)
	{
		if (mapCollision.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	function enemiesHitDamageArea(area:DamageArea, enemy:Zombie)
	{
		area.doDamageTo(enemy);
	}

	function crateHitDamageArea(area:DamageArea, crate:Crate)
	{
		area.doDamageTo(crate);
	}

	function playerPickWeaponDrop(player:Player, weapon_drop:WeaponDrop)
	{
		player.addWeapon(weapon_drop.weapon);
		weapon_drop.kill();
	}
}
