package;

import dn.Bresenham;
import entities.Crate;
import entities.DamageArea;
import entities.EnemySpawner;
import entities.Fx;
import entities.WeaponDrop;
import entities.Zombie;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import levels.LevelHelper;
import weapons.Bullet;
import weapons.Crowbar;

class PlayState extends FlxState
{
	var player:Player;
	var levels:LevelProject;
	var mapCollision:FlxTilemap;
	var mapRender:FlxTypedSpriteGroup<FlxSprite>;
	var crateCollision:FlxTypedGroup<Crate>;
	var enemySpawners:FlxTypedGroup<EnemySpawner>;
	var enemies:FlxTypedGroup<Zombie>;
	var hud:HUD;
	var uiCamera:FlxCamera;
	var fogOfWar:FlxTilemap;
	var current_level:LevelProject_Level;

	override public function create()
	{
		super.create();

		// FlxG.debugger.drawDebug = true;

		player = new Player(20, 20);
		loadMap();

		add(mapRender);
		add(Fx.FX);
		add(mapCollision);
		add(crateCollision);
		add(enemySpawners);
		add(enemies);

		add(Bullet.BULLETS);
		add(Bullet.BULLET_SPARKLES);

		add(DamageArea.DAMAGE_AREAS);

		add(WeaponDrop.WEAPON_DROPS);

		add(player);

		add(fogOfWar);

		uiCamera = new FlxCamera(Std.int(FlxG.camera.x), Std.int(FlxG.camera.x), FlxG.camera.width, FlxG.camera.height, 0);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(uiCamera, false);
		hud = new HUD(uiCamera);
		add(hud);

		player.onActiveWeaponChange.add(weapon -> hud.updateActiveWeapon(weapon));

		player.addWeapon(new Crowbar());

		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT, 1);
		FlxG.camera.zoom = 5;
	}

	function loadMap()
	{
		levels = new LevelProject();
		mapRender = new FlxSpriteGroup();
		current_level = levels.all_levels.Level_0;

		current_level.l_Background_Data.render(mapRender);
		current_level.l_Details.render(mapRender);
		mapRender.forEach(function(sprite)
		{
			sprite.width = 16;
			sprite.height = 16;
		});

		mapCollision = LevelHelper.createColliderFromIntGrid(current_level.l_Background_Data, 1);

		crateCollision = new FlxTypedGroup();

		var gridWidth = 16;
		var gridHeight = 16;

		for (crate in current_level.l_Entities.all_Crate)
		{
			var crateEntity = new Crate(crate.cx * gridWidth, crate.cy * gridHeight, crate.f_WeaponDrops);
			crateCollision.add(crateEntity);
		}

		enemies = new FlxTypedGroup();
		enemySpawners = new FlxTypedGroup();

		for (enemySpawn in current_level.l_Entities.all_Enemy_Spawn)
		{
			var spawnerEntity = new EnemySpawner(enemySpawn.cx * gridWidth, enemySpawn.cy * gridHeight, enemySpawn.f_Direction, enemies,
				enemySpawn.f_EnemyCount);
			enemySpawners.add(spawnerEntity);
		}

		for (l_player in current_level.l_Entities.all_Player)
		{
			player.x = l_player.cx * gridWidth;
			player.y = l_player.cy * gridHeight;
		}

		fogOfWar = new FlxTilemap();
		fogOfWar.setCustomTileMappings([11 * 16, 11 * 16 + 1], null, [[11 * 16], [11 * 16 + 1, 11 * 16 + 2]]);
		fogOfWar.loadMapFrom2DArray([
			for (_ in 0...current_level.l_Background_Data.cHei) [
				for (_ in 0...current_level.l_Background_Data.cWid)
					0
			]

		], AssetPaths.tiles__png, 16, 16);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

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
		FlxG.overlap(Bullet.BULLETS, crateCollision, bulletHitObstacle);

		// Bullets hit enemies
		FlxG.overlap(Bullet.BULLETS, enemies, bulletHitEnemy);

		FlxG.collide(Bullet.BULLET_SPARKLES, mapCollision);
		FlxG.collide(Bullet.BULLET_SPARKLES, crateCollision);

		FlxG.overlap(DamageArea.DAMAGE_AREAS, enemies, enemiesHitDamageArea);
		FlxG.overlap(DamageArea.DAMAGE_AREAS, crateCollision, crateHitDamageArea);

		FlxG.overlap(player, WeaponDrop.WEAPON_DROPS, playerPickWeaponDrop);

		enemies.forEachAlive(checkEnemyVision);
		updateView();
	}

	function bulletHit(bullet:Bullet, map:FlxObject)
	{
		bullet.kill();
	}

	function bulletHitEnemy(bullet:Bullet, enemy:Zombie)
	{
		bullet.dealDamageTo(enemy);
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

	function updateView()
	{
		var plyMidpoint = player.getMidpoint();
		var plyTilePos = player.getMidpoint().scale(1 / 16);

		Bresenham.iterateDisc(Std.int(plyMidpoint.x / 16), Std.int(plyMidpoint.y / 16), 9, (x, y) ->
		{
			fogOfWar.setTile(x, y, 11 * 16, true);
		});

		var radius = 6;

		Bresenham.iterateDisc(Std.int(plyMidpoint.x / 16), Std.int(plyMidpoint.y / 16), radius, (x, y) ->
		{
			var result = FlxPoint.get(x, y);
			var tiles:Array<Int> = Bresenham.getThinLine(Std.int(plyMidpoint.x / 16), Std.int(plyMidpoint.y / 16), x, y, true)
				.map((pos) -> mapCollision.getTile(pos.x, pos.y));

			var firstWall = tiles.indexOf(1);

			if (firstWall != -1)
			{
				if (firstWall < tiles.length - 2 || tiles.indexOf(0, firstWall) != -1)
					return;
			}

			fogOfWar.setTile(Std.int(Math.fround(result.x)), Std.int(Math.fround(result.y)), 15 * 16 + 15, true);
		});

		Bresenham.iterateCircle(Std.int(plyTilePos.x), Std.int(plyTilePos.y), radius, (x, y) ->
		{
			if (!Bresenham.checkThinLine(Std.int(plyTilePos.x), Std.int(plyTilePos.y), x, y, (x, y) -> mapCollision.getTile(x, y) == 0))
				return;

			fogOfWar.setTile(x, y, 11 * 16 + 1, true);
		});
	}
}
