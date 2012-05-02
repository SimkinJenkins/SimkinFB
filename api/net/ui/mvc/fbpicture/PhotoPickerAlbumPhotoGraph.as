package net.interalia.etnia.ui.mvc.fbpicture
{
	import com.etnia.graphics.gallery.IThumbnailData;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class PhotoPickerAlbumPhotoGraph extends Dictionary implements IThumbnailData {
		
		protected var _thumbnail:DisplayObject;
		
		protected var _data:Dictionary;
		
		public function PhotoPickerAlbumPhotoGraph($photo:Dictionary) {
			super();
			_data.aid = $photo.aid;
			_data.caption = $photo.caption;
			_data.created = $photo.created;
			_data.link = $photo.link;
			_data.owner = $photo.owner;
			_data.pid = $photo.pid;
			_data.src = $photo.src;
			_data.src_big = $photo.src_big;
			_data.src_small = $photo.src_small;
		}
		
		public function set ID($ID:String):void {
			
		}
		
		public function get ID():String {
			return _data.pid;
		}
		
		public function set imageName($imageName:String):void {}
		
		public function get imageName():String {
			return _data.caption;
		}
		
		public function set thumbnailURL($value:String):void {}
		
		public function get thumbnailURL():String {
			return _data.src_small;
		}
		
		public function set URL($value:String):void {}
		
		public function get URL():String {
			return _data.src_big;
		}
		
		public function set data($data:Object):void {}
		
		public function set thumbnail($value:DisplayObject):void {
			_thumbnail = $value;
		}
		
		public function get thumbnail():DisplayObject {
			return _thumbnail;
		}
		
	}
}