package levels;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import ldtk.Layer_IntGrid;

class LevelHelper
{
	public static function createColliderFromIntGrid(grid:Layer_IntGrid, collisionValue:Int):FlxGroup
	{
		var group = new FlxGroup();

		for (x in 0...grid.cWid)
			for (y in 0...grid.cHei)
			{
				var tile = grid.getInt(x, y);

				if (tile != collisionValue)
					continue;

				trace(tile);

				var rect = new FlxObject();
				rect.x = x * grid.gridSize;
				rect.y = y * grid.gridSize;

				rect.immovable = true;

				group.add(rect);
			}

		return group;
	}
}
