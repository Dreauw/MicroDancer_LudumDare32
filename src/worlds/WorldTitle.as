package worlds 
{
	import entities.Conveyor;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import utils.Assets;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class WorldTitle extends World
	{
		private var img:Text;
		private var imgEnt:Entity;
		private var elapsed:Number = 0;
		
		public function WorldTitle() 
		{
			super();
			add(new Conveyor());
			addGraphic(new Backdrop(Assets.BACKGROUND, true, false), 0);
			var title:Text = new Text("Micro Dancer", 0, 10,  {outlineColor:0x333333, outlineSize:1} );
			//title.filters = [new DropShadowFilter()];
			title.scrollX = title.scrollY = 0;
			addGraphic(title);
			img = new Text("Click to start", 0, 0, {outlineColor:0x333333, outlineSize:1});//new Image(Assets.SPRITESHEET_DOC, new Rectangle(175, 0, 20, 53));
			title.originX = img.width / 2;
			img.originX = img.width / 2;
			img.originY = img.height / 2;
			img.scrollX = img.scrollY = 0;
			title.x = img.x = (FP.screen.width / FP.screen.scale) / 2;
			img.y = (FP.screen.height / FP.screen.scale) / 2 + 30;
			
			imgEnt = addGraphic(img, 50);
			
		}
		
		override public function update():void 
		{
			super.update();
			elapsed += FP.elapsed;
			FP.camera.x += FP.elapsed * 15;
			
			img.angle = (Math.sin(elapsed * 2)) * FP.DEG * 0.1;
			img.scale = (2 + Math.sin(elapsed * 4) * 0.5);
			
			if (Input.mousePressed) {
				FP.world = new WorldGame();
			}
		}
		
	}

}