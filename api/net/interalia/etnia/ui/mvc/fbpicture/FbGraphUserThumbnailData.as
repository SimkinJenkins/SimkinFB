package net.interalia.etnia.ui.mvc.fbpicture {
	import com.etnia.graphics.gallery.IThumbnailData;
	
	import flash.display.DisplayObject;
	
	public class FbGraphUserThumbnailData extends Object implements IThumbnailData {
		protected var _user:Object;
		protected var _thumbnail:DisplayObject;
		
		public function FbGraphUserThumbnailData($user:Object) {
			_user = $user;
		}
		
		public function set ID($ID:String):void	{}
		
		public function get ID():String {
			return _user.uid;
		}
		
		public function set imageName($imageName:String):void{}
		
		public function get imageName():String {
			return _user.first_name;
		}
		
		public function set thumbnailURL($value:String):void{}
		
		public function get thumbnailURL():String {
			return _user.pic_square;
		}
		
		public function set URL($value:String):void {}
		
		public function get URL():String {
			return _user.pic_square;
		}
		
		public function set data($data:Object):void	{}
		
		public function set thumbnail($value:DisplayObject):void {
			_thumbnail = $value;
		}
		
		public function get thumbnail():DisplayObject {
			return _thumbnail;
		}
		
		public function get user():Object {
			return _user;
		}
		
	}
}