package gridgame 
{
	import gridgame.entity.Entity;
	import gridgame.entity.block.BlockBuilder;
	import gridgame.entity.block.BlockFactory;
	import gridgame.entity.block.Turret;
	import gridgame.entity.moving.Enemy;
	import gridgame.entity.moving.EnemySpawner;
	import gridgame.entity.moving.MovingEntity;
	import gridgame.entity.moving.Player;
	import gridgame.level.Level;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;
		
	public class PlayState extends FlxState
	{
		private var _level: Level;
		private var _player: Player; 
		private var _movingEntities: FlxGroup;
		private var _currencyText: FlxText;
		private var _currency: Currency;
		private var _blockBuilder: BlockBuilder;
		private var _blocks: FlxGroup;
		private var _enemySpawner: EnemySpawner;
		
		public override function create():void
		{
			_currency = new Currency();
									
			_enemySpawner = new EnemySpawner();
			
			_level = new Level();
			add(_level);						
			
			BlockFactory.setCurrency(_currency);
			BlockFactory.setLevel(_level);
			BlockFactory.setTargets(_enemySpawner.enemyGroup);
			add(BlockFactory.getBlockGroup());
			
			_blockBuilder = new BlockBuilder();
			_blockBuilder.setCurrency(_currency);			
			
			_player = new Player();
			_player.setLevel(_level);
			_player.setCurrency(_currency);
			_player.setBlockBuilder(_blockBuilder);			
			_player.moveToCenter();
						
			_enemySpawner.setLevel(_level);
			_enemySpawner.setTarget(_player);
			add(_enemySpawner);
			
			_movingEntities = new FlxGroup();
			_movingEntities.add(_enemySpawner.enemyGroup);
			_movingEntities.add(_player);
			add(_movingEntities);
			
			add(Turret.getBulletGroup());
			add(_blockBuilder.emitterGroup);
			add(_player.bloodEmitter);
			
			_currencyText = new FlxText(0, 0, FlxG.width, "left");
			_currencyText.setFormat(null, 8, 0xffffff, null, 0x111111);	
			add(_currencyText);
		}
		
		public override function update():void
		{
			super.update();			
			FlxG.collide(_movingEntities, _level, MovingEntity.levelHit);
			
			FlxG.overlap(Turret.getBulletGroup(), _enemySpawner.enemyGroup, Turret.bulletHit);
			
			FlxG.overlap(_enemySpawner.enemyGroup, _player, Enemy.targetHit);
			
			if (_currency.isDirty) 
			{
				_currency.isDirty = false;
				_currencyText.text = "$" + _currency.value;
			}
		}
	}
}