package gridgame.entity.block
{
import gridgame.Currency;
import gridgame.level.Space;

import org.flixel.FlxG;
import org.flixel.FlxGroup;

public class BlockBuilder
{
	[Embed(source="./assets/wall_dust.png")] private var WallDustImg:Class;
	[Embed(source="./assets/turret_dust.png")] private var TurretDustImg:Class;
	[Embed(source="./assets/supplier_dust.png")] private var SupplierDustImg:Class;
	
	private static const WallBuildTime:Number = .3;
	private static const TurretBuildTime:Number = .6;
	private static const SupplierBuildTime:Number = .9;
		
	private var _emitterGroup:FlxGroup;
	private var _currency:Currency;
	private var _buildTime: Number;
	private var _isBuilding: Boolean;
	private var _space: Space;
	
	private var _blockPropertiesArray: Array;
	private var _blockPropertiesIndex: int;	
	
	public function BlockBuilder()
	{		
		_blockPropertiesArray = new Array();		
		_blockPropertiesArray.push(new BlockProperties(Wall, WallDustImg, WallBuildTime));
		_blockPropertiesArray.push(new BlockProperties(Turret, TurretDustImg, TurretBuildTime));
		_blockPropertiesArray.push(new BlockProperties(Supplier, SupplierDustImg, SupplierBuildTime));
		
		_emitterGroup = new FlxGroup();	
		for each(var blockProperties:BlockProperties in _blockPropertiesArray)
		{
			_emitterGroup.add(blockProperties.emitter);
		}
		
		_blockPropertiesIndex = 0;
		_buildTime = 0;
		_isBuilding = false;
	}
	
	public function get emitterGroup():FlxGroup
	{
		return _emitterGroup;
	}
	
	public function setCurrency(currency:Currency):void
	{	
		_currency = currency;
	}
	
	public function update(space:Space, hasMoved:Boolean):void
	{
		_space = space;
		var wasBuilding:Boolean = _isBuilding;
		
		var spaceOpen:Boolean = space && !space.block;
		_isBuilding = FlxG.keys.SPACE && !hasMoved && ((spaceOpen && _currency.canAfford(Wall)) || _blockPropertiesIndex > 0);
		
		if (!wasBuilding && !_isBuilding) 
			return;
		
		if (!wasBuilding && _isBuilding)
		{				
			beginBuilding();
			return;
		}
		
		updateBuildingMaterialIndex();
		
		if (_isBuilding)
			_buildTime += FlxG.elapsed;
		else
			stopBuilding();					
	}
	
	private function updateBuildingMaterialIndex():void
	{
		if (_buildTime > blockProperties.buildTime)
		{
			if (!_currency.canAfford(blockProperties.block))
			{
				_buildTime = blockProperties.buildTime;
				return;
			}
			
			_space.removeBlock();
			_space.block = BlockFactory.makeBlock(blockProperties.block);
			_currency.buy(blockProperties.block);
			
			blockProperties.emitter.on = false;
			_blockPropertiesIndex++;
			
			if (_blockPropertiesIndex == _blockPropertiesArray.length)
				_isBuilding = false;								
			else
				startEmitter();
		}		
	}
	
	private function stopBuilding():void
	{
		if (blockProperties) blockProperties.emitter.on = false;
		_blockPropertiesIndex = 0;
		_buildTime = 0;			
	}
	
	private function beginBuilding():void
	{
		startEmitter();
	}
	
	private function get blockProperties():BlockProperties
	{
		if (_blockPropertiesIndex < 0) return null;
		return _blockPropertiesArray[_blockPropertiesIndex];
	}
		
	protected function startEmitter():void
	{
		blockProperties.emitter.x = _space.x;
		blockProperties.emitter.y = _space.y;
		blockProperties.emitter.start(false, .05, .01);
	}
}
}
import gridgame.level.Level;

import org.flixel.FlxEmitter;

class BlockProperties
{
	public var buildTime: Number;
	public var block: Class;
	public var emitter: FlxEmitter;
	
	public function BlockProperties(block:Class, Img:Class, buildTime:Number)
	{
		this.block = block;
		this.buildTime = buildTime;
		
		emitter = new FlxEmitter();
		emitter.makeParticles(Img, 10, 0, false, 0);
		emitter.setXSpeed(-200, 200);
		emitter.setYSpeed(-200, 200);
		emitter.setRotation(0, 0);
		emitter.setSize(Level.TileSize, Level.TileSize);
	}		
}