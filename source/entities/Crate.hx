package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import weapons.Pistol;

class Crate extends FlxSprite
{
	var drops:Array<Enum_WeaponTypes>;

	public function new(x:Float, y:Float, drops:Array<Enum_WeaponTypes>)
	{
		super(x, y);
		loadGraphic(AssetPaths.tiles__png, true, 16, 16);
		animation.add("idle", [5 * 16 + 2 - 1], 1, true);
		animation.add("idle", [5 * 16 + 2 - 1], 1, true);
		solid = true;
		immovable = true;
		animation.play("idle");
		health = 30;
		this.drops = drops;
	}

	override function kill()
	{
		super.kill();

		if (drops != null && drops.length > 0)
		{
			var drop = drops[FlxG.random.int(0, drops.length - 1)];
			switch (drop)
			{
				case Pistol:
					{
						WeaponDrop.createNew(x, y, new Pistol());
					};
				case Shotgun:
			}
		}
	}
}
