package 
{
	import entity.*;
	
	import org.flixel.*;
	
	public class Level extends FlxTilemap
	{
		[Embed(source="./assets/tiles.png")] private var ImgTiles:Class;
		
		public static const TileSize:int = 12;		
		private static const CollideIndex:int = 1;
		
		private var _blocks:FlxGroup;
		private var _spaces:Array; 
		private var _tx:int, _ty:int;
		
		public function Level(blocks:FlxGroup)
		{
			super();
			_blocks = blocks;
			
			var mapDataCsv:String = LevelGenerator.instance.generateLevel(
				FlxG.width / TileSize, FlxG.height / TileSize);
			loadMap(mapDataCsv, ImgTiles, TileSize, TileSize, FlxTilemap.OFF, 0, 0, CollideIndex);
			
			_spaces = new Array(widthInTiles * heightInTiles);
			for (var i:int = 0; i < _spaces.length; i++) 
			{
				var block:Entity = null;
				if (getTileByIndex(i) == 1) 
				{					
					block = _blocks.recycle(Wall) as Entity;
					block.revive();
					getPointFromIndex(i, _point);
					block.setPosition(_point.x, _point.y); 
					_blocks.add(block);
				}				
				_spaces[i] = new Space(this, i);
				_spaces[i].block = block;
			}
		}
		
		public function getPointFromIndex(i:int, point:FlxPoint=null):FlxPoint
		{
			if (point == null) 
				point = new FlxPoint();
			point.x = (i % widthInTiles) * TileSize;
			point.y = (int)(i / widthInTiles) * TileSize;
			return point;
		}
		
		public function getClosestSpace(pos:FlxPoint):Space
		{
			setTilePos(pos.x, pos.y);
			return getSpace(_tx, _ty);
		}

		public function getSpace(x:int, y:int):Space
		{
			return _spaces[_ty * widthInTiles + _tx];
		}
		
		public function isOutOfBounds(point:FlxPoint):Boolean 
		{
			return point.x < 0 || point.x >= width ||
				point.y < 0 || point.y >= height;
		}
		
		public function getClosestOpenSpace(x:Number, y:Number):Space
		{			
			setTilePos(x, y);
			var numTurns:int = 4;
			var totalDistance:int = 1;	
			var distance:int;
			var xDir:int, yDir:int;
			var space:Space = getSpace(_tx, _ty);
			
			while (space.allowCollisions)
			{								
				if (numTurns == 4)
				{
					_tx--;
					_ty--;
					totalDistance += 2;
					numTurns = distance = 0;
					xDir = 1;
					yDir = 0;
				}
				
				_tx += xDir;
				_ty += yDir;
				distance++;
				if (distance == totalDistance) {
					numTurns++;
					switch (numTurns)
					{
						case 1:
							xDir = 0;
							yDir = 1;
							break;
						case 2:
							xDir = -1;
							yDir = 1;
							break;
						case 3:
							xDir = 0;
							yDir = -1;
							break;
					}
				}
				space = getSpace(_tx, _ty);
			}
			
			return space;
		}	
		
		private function setTilePos(x:Number, y:Number):void 
		{
			_tx = x / TileSize;
			_ty = y / TileSize;
		}
	}
}