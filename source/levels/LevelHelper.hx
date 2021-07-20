package levels;

import flixel.tile.FlxTilemap;
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

		tileMap.loadMapFrom2DArray(data, AssetPaths.tiles__png, 16, 16);
		tileMap.visible = false;

		return tileMap;
	}
}
