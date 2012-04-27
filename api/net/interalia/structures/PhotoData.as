package net.interalia.structures {
	import com.etnia.graphics.gallery.IThumbnailData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class PhotoData extends OwnableObjectData implements IThumbnailData {

		protected var _graphic:GraphicData;
		protected var _position:uint;
		protected var _sizes:Array;
		protected var _tags:Array;
		protected var _link:String;

		public function get thumbnailURL():String {
			if(_graphic) {
				return _graphic.source
			}
			return "";
		}

		public function get URL():String {return _graphic.source}
		public function get thumbnail():DisplayObject {return new Sprite();}
		public function set data($value:Object):void {}
		public function set thumbnail($value:DisplayObject):void {}
		public function set thumbnailURL($value:String):void {}
		public function set URL($value:String):void {}

		public function get graphicData():GraphicData {
			return _graphic;
		}

		public function get link():String {
			return _link;
		}

		public function get thumbData():SimpleGraphicData {
			if(_sizes) {
				return _sizes[2];
			}
			return _graphic;
		}

		public function PhotoData($data:Object) {
			super($data);
			_graphic = new GraphicData($data);
			_position = $data.position;
			if($data.link) {
				_link = $data.link;
			}
			if($data.images) {
				_sizes = new Array();
				for(var i:uint = 0; i < $data.images.length; i++) {
					_sizes.push(new SimpleGraphicData($data.images[i]));
				}
			}
			if($data.tags) {
				_tags = $data.tags.data;
			}
		}

	}

}