package net.ui.mvc.fbpicture {

	import com.graphics.gallery.IThumbnailData;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class ThumbnailAlbumDataGraph extends Object implements IThumbnailData {
		
		protected var _coverData:Dictionary;
		protected var _thumbnail:DisplayObject;
		
		public function ThumbnailAlbumDataGraph($albums:Dictionary) {
			super();
			
			
			_coverData.aid = $albums.aid;
			_coverData.cover_pid = $albums.cover_pid;
			_coverData.created = $albums.created;
			_coverData.description = $albums.description;
			_coverData.link = $albums.link;
			_coverData.location = $albums.location;
			_coverData.modified = $albums.modified;
			_coverData.name = $albums.name;
			_coverData.owner = $albums.owner;
			_coverData.size = $albums.size;
			_coverData.visible = $albums.visible;
			
		}
		
		public function set ID($ID:String):void	{}
		
		public function get ID():String	{return _coverData.aid;}
		
		public function set imageName($imageName:String):void{}
		
		public function get imageName():String{return _coverData.name;}
		
		public function set thumbnailURL($value:String):void{}
		
		public function get thumbnailURL():String {
			return _coverData ? _coverData.src_big : "";
		}
		
		public function set URL($value:String):void	{}
		
		public function get URL():String{return _coverData.link;}
		
		public function set data($data:Object):void	{}
		
		public function set thumbnail($value:DisplayObject):void {
			_thumbnail = $value;
		}
		
		public function get thumbnail():DisplayObject {
			return _thumbnail;
		}
		
		public function set coverData($coverdata:Dictionary):void {
			_coverData = $coverdata;
		}
		
		public function get coverData():Dictionary {
			return _coverData;
		}
		
	}
}