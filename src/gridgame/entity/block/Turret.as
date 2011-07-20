package gridgame.entity.block
{
import gridgame.entity.moving.Enemy;
import gridgame.level.Level;
import gridgame.level.LevelGenerator;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxControl;
import org.flixel.plugin.photonstorm.FlxWeapon;

public class Turret extends Block
{	
	[Embed(source="./assets/turret.png")] private var TurretImg:Class;
	
	private static var _bullets: FlxGroup = new FlxGroup();
	
	private static var Range: Number = 90;
	private static var BulletSpeed: Number = 80;
	private static var FireRate: Number = 1500; // in ms
	private static var Damage: Number = 10;
	
	private var _targets: FlxGroup;
	private var _weapon:FlxWeapon; 
	
	public function Turret()
	{
		super(TurretImg);
		_weapon = new FlxWeapon("lazer", this);
		_weapon.makePixelBullet(3, 2, 2, 0xffffffff, Level.TileSize / 2, Level.TileSize / 2);
		_weapon.setBulletSpeed(BulletSpeed);
		_weapon.setFireRate(FireRate);
		_weapon.setBulletLifeSpan(Range * 1000 / BulletSpeed);
		_bullets.add(_weapon.group);
	}	
	
	public static function bulletHit(bullet:FlxObject, enemy:FlxObject):void
	{
		bullet.kill();
		enemy.hurt(Damage);
	}
	
	public static function getBulletGroup(): FlxGroup
	{
		return _bullets;
	}
	
	public function setTargets(targets: FlxGroup):void
	{
		_targets = targets;
	}
	
	public function getBullets():FlxGroup
	{
		return _weapon.group;
	}
	
	public override function update():void
	{
		if (_weapon.canFire())
		{
			var i:uint = 0;
			var enemy:Enemy;
			while(i < _targets.length)
			{
				enemy = _targets.members[i++] as Enemy;
				if((enemy != null) && enemy.exists && enemy.visible)
				{
					if (inRange(enemy))
					{
						_weapon.fireAtTarget(enemy);
					}
				}
			}
		}
	}
	
	private function inRange(enemy:Enemy):Boolean
	{
		return FlxU.getDistance(enemy.midpoint, midpoint) < Range;
	}
}
}