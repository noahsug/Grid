package gridgame 
{
	import gridgame.entity.Enemy;
	import gridgame.entity.Player;
	import gridgame.entity.block.BlockBuilder;
	import gridgame.entity.block.BlockFactory;
	import gridgame.level.Level;
	
	import org.flixel.*;
		
	public class PlayState extends FlxState
	{
		private var _level: Level;
		private var _player: Player; 
		private var _enemies: FlxGroup; 
		private var _movingEntities: FlxGroup;
		private var _currencyText: FlxText;
		private var _currency: Currency;
		private var _blockBuilder: BlockBuilder;
		private var _blocks: FlxGroup;
				
		public override function create():void 
		{
			_currency = new Currency();
									
			_level = new Level();
			add(_level);
			
			BlockFactory.setCurrency(_currency);		
			add(BlockFactory.getBlockGroup());
			
			_blockBuilder = new BlockBuilder();
			_blockBuilder.setCurrency(_currency);			
			
			_player = new Player();
			_player.setLevel(_level);
			_player.setCurrency(_currency);
			_player.setBlockBuilder(_blockBuilder);			
			_player.moveToCenter();
			
			_enemies = new FlxGroup();
			
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
			add(_movingEntities);
			
			add(_blockBuilder.emitterGroup);
			
			_currencyText = new FlxText(0, 0, FlxG.width, "left");
			_currencyText.setFormat(null, 8, 0xffffff, null, 0x111111);	
			add(_currencyText);
		}
		
		public override function update():void
		{
			super.update();			
			FlxG.collide(_level, _movingEntities);
			
			if (_currency.isDirty) 
			{
				_currency.isDirty = false;
				_currencyText.text = "blocks: " + _currency.value;
			}
		}
	}
}