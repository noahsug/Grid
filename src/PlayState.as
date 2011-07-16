package 
{
	import entity.Enemy;
	import entity.Entity;
	import entity.Player;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;
		
	public class PlayState extends FlxState
	{
		private var _level:Level;
		private var _player:Player; 
		private var _enemies:FlxGroup; 
		private var _movingEntities:FlxGroup;
		private var _blocks:FlxGroup;
		
		public override function create():void 
		{				
			_blocks = new FlxGroup();			
			_level = new Level(_blocks);
			add(_level);			
			
			_player = new Player();
			_player.setLevel(_level);
			_player.moveToCenter();			
			add(_player);
			
			_enemies = new FlxGroup();			
			add(_enemies);
			
			var enemy:Enemy = new Enemy();			
			enemy.followTarget(_player);
			enemy.setLevel(_level);
			_enemies.add(enemy);
			
			enemy = new Enemy();
			enemy.setPosition(_level.width - Level.TileSize, _level.height - Level.TileSize);
			enemy.followTarget(_player);
			enemy.setLevel(_level);
			_enemies.add(enemy);
			
			_movingEntities = new FlxGroup();
			_movingEntities.add(_enemies);
			_movingEntities.add(_player);
			
			add(_blocks);
		}

		public override function update():void
		{
			super.update();			
			FlxG.collide(_level, _movingEntities);
		}
	}
}