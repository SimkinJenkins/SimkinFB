package net.interalia.structures {
	import com.etnia.graphics.gallery.IThumbnail;
	import com.etnia.graphics.gallery.IThumbnailData;
	import com.etnia.graphics.gallery.Thumbnail;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class AlbumData extends OwnableObjectData implements IThumbnailData {

		protected var _count:Number;
		protected var _coverPhoto:String = "";
		protected var _description:String = "";
		protected var _link:String = "";
		protected var _location:String = "";
		protected var _privacy:String = "";
		protected var _type:String = "";
		protected var _coverDetail:PhotoData;
		protected var _photos:Object;

		public function get thumbnailURL():String {
			if(_coverDetail && _coverDetail.thumbData) {
				return _coverDetail.thumbData.source
			}
			return "";
		}

		public function get URL():String {return _coverDetail.thumbData.source}
		public function get thumbnail():DisplayObject {return new Sprite();}
		public function set data($value:Object):void {}
		public function set thumbnail($value:DisplayObject):void {}
		public function set thumbnailURL($value:String):void {}
		public function set URL($value:String):void {}

		public function set coverDetail($value:PhotoData):void {
			_coverDetail = $value;
		}

		public function get coverDetail():PhotoData {
			return _coverDetail;
		}

		public function get coverPhoto():String {
			return _coverPhoto;
		}

		public function get photoCount():Number {
			return _count;
		}

		public function get type():String {
			return _type;
		}
		
		public function AlbumData($data:Object) {
			super($data);
			if($data.aid) {
				_ID = $data.aid;
			}
			setPhotoCount($data);
			_coverPhoto = $data.cover_photo;
			if($data.cover_pid) {
				_coverPhoto = $data.cover_pid;
			}
			_description = $data.description;
			_link = $data.link;
			_location = $data.location;
			_privacy = $data.privacy;
			_type = $data.type;
		}

		protected function setPhotoCount($data:Object):void {
			_count = $data.count;
			if($data.size) {
				_count = $data.size;
			}
			if($data.photo_count) {
				_count = $data.photo_count;
			}
		}

	}
}