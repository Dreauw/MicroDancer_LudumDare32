package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.FP;
	import utils.Audio;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Explosion extends Entity
	{
		
		public function Explosion() 
		{
			super(0, 0);
			this.graphic = new Image(Assets.EXPLOSION);
			(this.graphic as Image).originX = (this.graphic as Image).width / 2;
			(this.graphic as Image).originY = (this.graphic as Image).height / 2;
			this.layer = 6;
			Audio.registerSound("explosion1", "3,,0.0697,,0.272,0.2031,,-0.4315,,,,,,,,,,,1,,,0.1588,,0.5");
			Audio.registerSound("explosion2", "3,,0.0173,,0.1636,0.3675,,-0.3756,,,,,,,,,,,1,,,0.1048,,0.5");
		}
		
		public function init(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
			(this.graphic as Image).alpha = 0.8;
			(this.graphic as Image).scale = 1;
			Audio.playSound(FP.choose("explosion1", "explosion2"));
		}
		
		
		override public function update():void 
		{
			super.update();
			(this.graphic as Image).alpha -= FP.elapsed * 10;
			(this.graphic as Image).scale += FP.elapsed * 10;
			
			if ((this.graphic as Image).alpha <= 0) {
				world.recycle(this);
			}
		}
		
	}

}