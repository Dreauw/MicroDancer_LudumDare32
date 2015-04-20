package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import utils.ComboGenerator;
	import utils.Assets;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Skill extends Entity
	{
		public var combo:Combo;
		private var iconHeight:Number = 14;
		
		public function Skill(world:World, x:Number, label:String, pattern:Array, i:int = 0) {
			super(x, 0);
			//this.graphic = new Text(label, 0, 0, {size: 8, color:0x222222});
			this.graphic = new Image(Assets.ICONS, new Rectangle(14 * i, 0, 14, 14));
			(this.graphic as Image).alpha = 0.5;
			this.layer = 10;
			this.combo = new Combo(pattern, 0.5, 2, this, false);
			combo.type = "skillCombo";
			this.combo.x = this.x + (this.graphic as Image).width + 2;
			this.combo.y = this.y + 2;
			this.graphic.scrollX = this.combo.graphic.scrollX = 0;
			ComboGenerator.getInstance().registerCombo(pattern);
			world.add(combo);
		}
		
		public function canBeCast():Boolean {
			return iconHeight >= 14;
		}
		
		
		public function onCast():void {
			iconHeight = (this.graphic as Image).clipRect.height = 0;
			(this.graphic as Image).updateBuffer(true);
		}
		
		
		override public function update():void 
		{
			super.update();
			if (iconHeight < 14) {
				iconHeight += FP.elapsed * 2;
				var nheight:int = Math.floor(iconHeight);
				if ((this.graphic as Image).clipRect.height != nheight) {
					(this.graphic as Image).clipRect.height = nheight;
					(this.graphic as Image).updateBuffer(true);
				}
			}
		}
		
	}

}