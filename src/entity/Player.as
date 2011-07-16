package entity
{
	import entity.movement.FreeGridMovementBehavior;
	import entity.movement.MovementBehavior;
	
	import org.flixel.*;
	
	public class Player extends Entity
	{
		[Embed(source="./assets/player2.png")] private var PlayerImg:Class;
		
		private static const Speed:Number = 50;
		private static const Origin:FlxPoint = new FlxPoint(0, 0);
		private static const KeyBufferTime:Number = .1;
		
		private var _heldBlock:Entity = null;
		private var _movementBehavior:FreeGridMovementBehavior;
		
		public function Player()
		{
			super(PlayerImg);
			_movementBehavior = new FreeGridMovementBehavior(this);
			_movementBehavior.setSpeed(Speed);			
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
			handleTileMoving();
		}
		
		public function moveToCenter():void
		{
			var space:Space = _level.getClosestOpenSpace(FlxG.width / 2, FlxG.height / 2);
			setPosition(space.position.x, space.position.y);
		}
		
		private function handleTileMoving():void
		{		
			if (FlxG.keys.justPressed("SPACE"))
			{			
				var _destination:FlxPoint = _point;
				_destination.x = position.x + Level.TileSize * _movementBehavior.direction.x;	
				_destination.y = position.y + Level.TileSize * _movementBehavior.direction.y;
				if (_level.isOutOfBounds(_destination)) return;				
				var space:Space = _level.getClosestSpace(_destination);
				
				if (_heldBlock == null && space.allowCollisions)
				{
					pickUpBlock(space);
				}
				else if (_heldBlock != null) 
				{
					if (space.allowCollisions)
						upgradeBlock(space);
					else
						putDownBlock(space);
				}
			}
		}
		
		// --- helper functions -

		private function upgradeBlock(space:Space):void
		{
			// TODO
		}
		
		private function pickUpBlock(space:Space):void
		{		
			_heldBlock = space.block;
			_heldBlock.visible = false;
			space.block = null;
		}
		
		private function putDownBlock(space:Space):void
		{			
			space.block = _heldBlock;		
			space.block.visible = true;
			_heldBlock = null;
		}				
	}
}