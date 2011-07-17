package gridgame.entity.block
{

public class Wall extends Block
{
	[Embed(source="./assets/wall.png")] private var WallImg:Class;
	
	public function Wall()
	{
		super(WallImg);
	}		
}
}