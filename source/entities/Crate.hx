package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import weapons.AK47;
import weapons.Pistol;
import weapons.Shotgun;

class Crate extends FlxSprite
{
	var drops:Array<Enum_WeaponTypes>;
	var base:Int;

	public function new(x:Float, y:Float, drops:Array<Enum_WeaponTypes>)
	{
		super(x, y);
		loadGraphic(AssetPaths.entities__png, true, 16, 16);
		var crateTypes = [10 * 16, 11 * 16, 12 * 16, 13 * 16];
		FlxG.random.shuffle(crateTypes);
		base = crateTypes[0];
		frame = frames.getByIndex(base);
		animation.add("die", [for (i in 0...5) base + i + 4], 20, false);
		solid = true;
		immovable = true;
		animation.play("idle");
		health = 30;
		this.drops = drops;
	}

	override function hurt(Damage:Float)
	{
		health = health - Damage;

		if (health < 25)
			frame = frames.getByIndex(base + 1);
		if (health < 15)
			frame = frames.getByIndex(base + 2);
		if (health < 7)
			frame = frames.getByIndex(base + 3);

		if (health <= 0)
		{
			solid = false;
			animation.play("die");
			animation.finishCallback = (_) -> active = false;
			drop();
		}
	}

	function drop()
	{
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
