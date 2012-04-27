package net.interalia.structures {
	import net.interalia.interfaces.IOwnableObjectData;

	public class OwnableObjectData extends IDData implements IOwnableObjectData {

		protected var _createdTime:String = "";
		protected var _from:IDData;
		protected var _updatedTime:String = "";
		protected var _objectID:String = "";
		protected var _likeCount:uint = 0;
		protected var _commentCount:uint = 0;

		public function get owner():IDData {
			return _from;
		}

		public function get totalCount():uint {
			return _commentCount + _likeCount;
		}
		
		public function set commentCount($value:uint):void {
			_commentCount = $value;
		}
		
		public function get commentCount():uint {
			return _commentCount;
		}
		
		public function set likeCount($value:uint):void {
			_likeCount = $value;
		}
		
		public function get likeCount():uint {
			return _likeCount;
		}

		public function get created():String {
			return _createdTime;
		}

		public function OwnableObjectData($data:Object) {
			super($data);
			_createdTime = String($data.created_time);
			if($data.created) {
				_createdTime = String($data.created);
			}
			_updatedTime = $data.updated_time;
			_from = new IDData($data);
			if($data.owner) {
				_from.ID = $data.owner;
			}
			_objectID = $data.object_id;
		}
	}
}