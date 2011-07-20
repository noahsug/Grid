package gridgame.entity.moving
{
	import gridgame.Currency;
	import gridgame.entity.Entity;
	import gridgame.entity.block.BlockBuilder;
	import gridgame.entity.block.BlockFactory;
	import gridgame.entity.block.Supplier;
	import gridgame.entity.block.Wall;
	import gridgame.level.Level;
	import gridgame.level.Space;
	
	import org.flixel.*;
	
	public class Player extends MovingEntity
	{
		[Embed(source="./assets/player2.png")] private var PlayerImg:Class;
		[Embed(source="./assets/blood.png")] private static var BloodImg:Class;
		
		private static const Speed:Number = 50;
		private static const Origin:FlxPoint = new FlxPoint(0, 0);
		
		private var _bloodEmitter: FlxEmitter;
		private var _currency: Currency;		
		private var _space: Space;		
		private var _canBuild: Boolean;
		private var _blockBuilder:BlockBuilder;		
		
		
		public function Player()
		{
			super(PlayerImg);			
			_canBuild = true;
			movementBehavior = new AugmentedMovementBehavior(this);
			movementBehavior.setSpeed(Speed);
			
			_bloodEmitter = new FlxEmitter();
			_bloodEmitter.makeParticles(BloodImg, 50, 0, false, 0);
			_bloodEmitter.setRotation(0, 0);
			_bloodEmitter.setXSpeed(-100, 100);
			_bloodEmitter.setYSpeed(-100, 100);
			_bloodEmitter.setSize(width, height);
		}
		
		public function setBlockBuilder(blockBuilder:BlockBuilder):void
		{
			_blockBuilder = blockBuilder;
		}
		
		public function get bloodEmitter():FlxEmitter { return _bloodEmitter; }
		
		public override function update():void
		{			
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
		
		public override function kill():void
		{
			_bloodEmitter.at(this);
			_bloodEmitter.start(false, .3, .005, 0);
			FlxG.shake(0.01, 100);
			freeze(100);
			alive = false;
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
	}
}