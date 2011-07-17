package gridgame.entity
{
	import gridgame.Currency;
	import gridgame.entity.block.BlockBuilder;
	import gridgame.entity.block.BlockFactory;
	import gridgame.entity.block.Supplier;
	import gridgame.entity.block.Wall;
	import gridgame.entity.movement.FreeGridMovementBehavior;
	import gridgame.entity.movement.MovementBehavior;
	import gridgame.level.Level;
	import gridgame.level.Space;
	
	import org.flixel.*;
	
	public class Player extends Entity
	{
		[Embed(source="./assets/player2.png")] private var PlayerImg:Class;
		
		private static const Speed:Number = 50;
		private static const Origin:FlxPoint = new FlxPoint(0, 0);
		
		private var _currency: Currency;
		private var _movementBehavior: FreeGridMovementBehavior;
		
		private var _space: Space;		
		private var _canBuild: Boolean;
		private var _blockBuilder:BlockBuilder;
		
		public function Player()
		{
			super(PlayerImg);			
			_canBuild = true;
			_movementBehavior = new FreeGridMovementBehavior(this);
			_movementBehavior.setSpeed(Speed);			
		}
		
		public function setBlockBuilder(blockBuilder:BlockBuilder):void
		{
			_blockBuilder = blockBuilder;
		}
		
		public override function setLevel(level:Level):void
		{
			super.setLevel(level);
			_movementBehavior.setLevel(_level);
		}
		
		public override function update():void
		{						
			_movementBehavior.update();			
			super.update();	
			handleBuilding();
			handleDestorying();			
		}
						
		public function moveToCenter():void
		{
			var space:Space = _level.getClosestOpenSpace(FlxG.width / 2, FlxG.height / 2);
			setPosition(space.position.x, space.position.y);
		}
		
		public function setCurrency(currency:Currency):void
		{
			_currency = currency;
		}
		
		private function handleBuilding():void
		{		
			if (_canBuild)
			{
				var hasMoved:Boolean = velocity.x != 0 || velocity.y != 0;
				_blockBuilder.update(getSpaceInFront(), hasMoved);
			}
		}
		
		private function handleDestorying():void
		{		
			if (FlxG.keys.justPressed("SPACE"))
			{			
				_space = getSpaceInFront();
				if (_space && _space.block) 
				{
					destroyBlock();
				}
			}
			
			if (!_canBuild && FlxG.keys.justReleased("SPACE"))
			{
				_canBuild = true;
			}
		}
		
		private function destroyBlock():void
		{
			_space.removeBlock();
			_canBuild = false;
			_currency.value++;
		}
		
		private function getSpaceInFront():Space 
		{
			var _destination:FlxPoint = _point;
			_destination.x = position.x + Level.TileSize * _movementBehavior.direction.x;
			_destination.y = position.y + Level.TileSize * _movementBehavior.direction.y;
			if (_level.isOutOfBounds(_destination)) return null;				
			return _level.getClosestSpace(_destination);
		}
	}
}