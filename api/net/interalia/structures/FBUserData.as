package net.interalia.structures {

	import com.etnia.graphics.gallery.IThumbnailData;

	import flash.display.DisplayObject;

	public class FBUserData extends IDData implements IThumbnailData {

		public function set thumbnailURL($value:String):void {}
		public function set URL($value:String):void {}
		public function set data($data:Object):void {}
		public function set thumbnail($value:DisplayObject):void {}
		public function get thumbnail():DisplayObject {return null;}

		public function get thumbnailURL():String {
			return "https://graph.facebook.com/" + _ID + "/picture";
		}
		
		public function get URL():String {
			return "https://graph.facebook.com/" + _ID + "/picture?type=large";
		}

		public function FBUserData($data:Object) {
			super($data);
		}

	}
}