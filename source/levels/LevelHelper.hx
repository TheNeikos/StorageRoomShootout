package levels;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import ldtk.Layer_AutoLayer.AutoTile;
import ldtk.Layer_IntGrid;

class LevelHelper
{
	public static function createColliderFromIntGrid(grid:Layer_IntGrid, collisionValue:Int):FlxTilemap
	{
		var tileMap = new FlxTilemap();
		var data = [];

		for (y in 0...grid.cHei)
		{
			var line = [];
			for (x in 0...grid.cWid)
			{
				var tile = grid.getInt(x, y);

				if (tile != collisionValue)
				{
					line.push(0);
				}
				else
				{
					line.push(collisionValue);
				}
			}
			data.push(line);
		}

		tileMap.loadMapFrom2DArray(data, AssetPaths.tiles__png, 16, 16, FlxTilemapAutoTiling.OFF);
		tileMap.visible = false;

		return tileMap;
	}
}
