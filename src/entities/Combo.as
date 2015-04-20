package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Combo extends Entity
	{	
		private const KEY_SIZE:int = 20;
		
		private var combo:Array;
		private var imgs:Array = new Array();
		private var cursor:int = -1;
		private var scale:Number;
		private var margin:int = 5;
		private var parent:Entity;
		private var resetTimer:Number = 0;
		
		public var dynamicKeys:Boolean = true;
		private var lastNote:Array = new Array();
		
		public function Combo(combo:Array, scale:Number, margin:int = 5, parent:Entity = null, dynamicKeys:Boolean = true) 
		{
			super(50, 50);
			this.dynamicKeys = dynamicKeys;
			this.parent = parent;
			this.margin = margin;
			this.combo = combo;
			var img:Image;
			this.scale = scale;
			var rect:Rectangle = new Rectangle(0, 0, KEY_SIZE, KEY_SIZE);
			for (var i:int = 0; i < combo.length; ++i) {
				rect.x = combo[i] * KEY_SIZE;
				img = new Image(Assets.KEYS, rect);
				img.x = i * (KEY_SIZE * scale + margin);
				img.scale = scale;
				imgs.push(img);
				this.addGraphic(img);
			}
			setHitbox(combo.length * (KEY_SIZE * scale + margin) - margin, KEY_SIZE * scale);
			this.type = "combo";
			this.layer = 8;
		}
		
		public function onFocus():void {
			if (cursor == -1) {
				setCursor(0);
			}
		}
		
		override public function update():void 
		{
			super.update();
			if (resetTimer > 0) {
				resetTimer -= FP.elapsed;
				if (resetTimer <= 0) {
					setCursor(0);
				}
			}
		}
		
		public function setCursor(ncursor:int): void {
			if (!dynamicKeys) {
				this.cursor = ncursor;
				return;
			}
			if (cursor >= 0) {
				var pkey:Image = (imgs[cursor] as Image);
				pkey.scale = scale;
				pkey.y = 0;
				pkey.x = cursor * (KEY_SIZE * scale + margin);
			}
			this.cursor = ncursor;
			var ckey:Image = (imgs[cursor] as Image);
			ckey.scale = scale + 0.3;
			ckey.y = -5;
			ckey.x -= Math.abs(KEY_SIZE * ckey.scale - ckey.width) / 2;
			resetTimer = 2;
		}
		
		
		public function onNotePlayed(note:int):Boolean {
			if (parent != null && parent is Skill) {
				if (lastNote.length == 4) {
					lastNote.shift();
				}
				
				lastNote.push(note);
				if (String(lastNote) == String(combo)) {
					if ((parent as Skill).canBeCast()) {
						(parent as Skill).onCast();
					} else {
						setCursor(0);
						return false;
					}
					return true;
				}
			}
			
			if (cursor == -1) cursor = 0;
			if (combo[cursor] == note) {
				if (cursor + 1 == combo.length) {
					if (parent != null) {
						if (parent is Destroyable) {
							(parent as Destroyable).onDestruction();
						}
					}
					setCursor(0);
					return true;
				}
				setCursor((cursor + 1) % combo.length);
			} else {
				setCursor(0);
			}
			return false;
		}
		
		
		public function getParent() : Entity {
			return parent;
		}
	}

}