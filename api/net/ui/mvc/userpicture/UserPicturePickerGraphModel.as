package net.ui.mvc.userpicture {

	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.models.BasicModel;
	import com.ui.controllers.mvc.userpicture.BasicFileReferenceModel;
	import com.ui.controllers.mvc.webcam.BasicWebcamModel;
	
	import flash.display.DisplayObject;
	
	import net.ui.mvc.fbpicture.FacebookGraphPhotoPickerModel;

	public class UserPicturePickerGraphModel extends BasicModel implements IModel {

		protected var _selectedType:String;
		protected var _userFileModel:BasicFileReferenceModel;
		protected var _webcamPicModel:BasicWebcamModel;
		protected var _fbPicModel:FacebookGraphPhotoPickerModel;
		protected var _selectFileController:IFormController;
		protected var _userImage:DisplayObject;
		protected var _userPhotos:Array;
		
		public function get userPhotos():Array {
			return _userPhotos;
		}
		
		public function set userPhotos($value:Array):void {
			_userPhotos = $value;
		}
		
		public function get userImage():DisplayObject {
			return _userImage;
		}
		
		public function set userImage($value:DisplayObject):void {
			_userImage = $value;
		}
		
		public function get selectFileController():IFormController {
			return _selectFileController;
		}
		
		public function set selectFileController($value:IFormController):void {
			_selectFileController = $value;
		}
		
		public function get fbPicModel():FacebookGraphPhotoPickerModel {
			return _fbPicModel;
		}
		
		public function set fbPicModel($value:FacebookGraphPhotoPickerModel):void {
			_fbPicModel = $value;
		}
		
		public function get webcamPicModel():BasicWebcamModel {
			return _webcamPicModel;
		}
		
		public function set webcamPicModel($value:BasicWebcamModel):void {
			_webcamPicModel = $value;
		}
		
		public function get userFileModel():BasicFileReferenceModel {
			return _userFileModel;
		}
		
		public function set userFileModel($value:BasicFileReferenceModel):void {
			_userFileModel = $value;
		}
		
		public function get selectedType():String {
			return _selectedType;
		}
		
		public function set selectedType($value:String):void {
			_selectedType = $value;
		}
		
		public function UserPicturePickerGraphModel() {
			super();
		}

	}
}