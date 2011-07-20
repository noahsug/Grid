package gridgame.entity.moving
{
import gridgame.entity.Entity;
import gridgame.level.Level;
import gridgame.level.Space;

import org.flixel.FlxBasic;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

public class EnemySpawner extends FlxBasic
{
	private static const SpawnRate:Number = 2.5;
	private static const MinSpawnRate:Number = .05;
	private static const SpawnRateDecay:Number = .99;
	
	public var enemyGroup: FlxGroup;
	private var _level: Level;
	private var _target: Entity;
	private var _spawnCooldown:Number;
	private var _point: FlxPoint;
	private var _spawnRate: Number;

	public function EnemySpawner()
	{		
		enemyGroup = new FlxGroup();
		_spawnCooldown = 0;
		_spawnRate = SpawnRate;
	}
	
	public function setLevel(level:Level):void
	{
		_level = level;
	}
	
	public function setTarget(target:Entity):void
	{
		_target = target;
	}
	
	public override function update():void
	{
		_spawnRate *= (1 - (1 - SpawnRateDecay) * FlxG.elapsed);
		if (_spawnRate < MinSpawnRate) _spawnRate = MinSpawnRate			
		
		_spawnCooldown -= FlxG.elapsed;
		if (_spawnCooldown < 0) 
		{
			spawnEnemy();
			_spawnCooldown = _spawnRate;
		}
	}
	
	private function spawnEnemy():void
	{
		var enemy: Enemy = new Enemy();
		enemy.position = getRandomEdgePosition();
		enemy.followTarget(_target);
		enemy.setLevel(_level);
		enemyGroup.add(enemy);
	}
	
	private function getRandomEdgePosition():FlxPoint
	{
		var rand:Number = FlxG.random();
		var space: Space;
		var x:int, y:int;
		var i:int;
		if (rand < .5) // spawn top or bottom
		{
			if (rand < .25) // spawn top
				y = 0;
			else // spawn bottom 
			{
				y = _level.heightInTiles - 1;
				rand -= .25;
			}
			x = rand * 4 * _level.widthInTiles;
			for (i = 0; i < _level.widthInTiles; i++)
			{
				space = _level.getSpace(x, y);
				if (!space.allowCollisions) return space.position;
				x += i;
				if (x >= _level.widthInTiles) x = 0;
			}
		}
		else // spawn right or left
		{
			rand -= .5;
			if (rand < .25) // spawn left
				x = 0;			
			else // spawn right
			{
				x = _level.widthInTiles - 1;
				rand -= .25;
			}
			y = rand * 4 * _level.heightInTiles;
			for (i = 0; i < _level.heightInTiles; i++)
			{
				space = _level.getSpace(x, y);
				if (!space.allowCollisions) return space.position;
				y += i;
				if (y >= _level.heightInTiles) y = 0;
			}
		}
		return getRandomEdgePosition(); // entire edge is blocked, try again
	}
}
}