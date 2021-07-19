package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import weapons.AK47;
import weapons.Pistol;
import weapons.Shotgun;

class Crate extends FlxSprite
{
	var drops:Array<Enum_WeaponTypes>;

	public function new(x:Float, y:Float, drops:Array<Enum_WeaponTypes>)
	{
		super(x, y);
		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		frame = frames.getByIndex(11 * 16);
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
					{
						WeaponDrop.createNew(x, y, new Shotgun());
					};
				case AK47:
					{
						WeaponDrop.createNew(x, y, new AK47());
					};
			}
		}
	}
}
