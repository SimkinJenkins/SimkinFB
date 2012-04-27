package net.interalia.etnia.ui.mvc.userpicture.views {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.interalia.etnia.ui.mvc.BasicFormStates;
	import net.interalia.etnia.ui.mvc.fbpicture.BasicFBGraphPicturePickerView;
	import net.interalia.etnia.ui.mvc.interfaces.IController;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	import net.interalia.etnia.ui.mvc.interfaces.IView;
	import net.interalia.etnia.ui.mvc.userpicture.BasicFileReferenceView;
	import net.interalia.etnia.ui.mvc.userpicture.UserPicturePickerGraphModel;
	import net.interalia.etnia.ui.mvc.userpicture.UserPicturePickerStates;
	import net.interalia.etnia.ui.mvc.views.BasicFormView;
	import net.interalia.etnia.ui.mvc.webcam.BasicWebcamView;

	
	public class UserPicturePickerBasicGraphView extends BasicFormView implements IView {
		protected var _fbPicButton:SimpleButton;
		protected var _webCamPicButton:SimpleButton;
		protected var _userFilePicButton:SimpleButton;
		protected var _currentSubView:IView;
		
		protected function get userPickerModel():UserPicturePickerGraphModel {
			return _model as UserPicturePickerGraphModel;
		}
		
		protected function get fbPictureButton():InteractiveObject {
			return _fbPicButton;
		}
		
		protected function get webCamPicButton():InteractiveObject {
			return _webCamPicButton;
		}
		
		protected function get userFilePicButton():InteractiveObject {
			return _userFilePicButton;
		}
		
		public function UserPicturePickerBasicGraphView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			super($model, $controller, $graphic);
		}
		
		override protected function initGraphic():void {
			super.initGraphic();
			_fbPicButton = getButton("Elige una foto de FB", 100, 100);
			_userFilePicButton = getButton("Elige una foto de tu PC", 100, 120);
			_webCamPicButton = getButton("Usa tu webcam", 100, 140);
			_cancelButton = getButton("Cancelar", 100, 160);
		}
		
		override protected function stateUpdate($event:Event):void {
			switch(_model.currentState) {
				case UserPicturePickerStates.HOME:				showMenu();				break;
				case UserPicturePickerStates.USER_FILE_MODE:	setUserPickerView();	break;
				case UserPicturePickerStates.WEB_CAM_MODE:		setWebcamPictureView();	break;
				case UserPicturePickerStates.FB_PICTURE_MODE:	setFBPicPickerView();	break;
			}
			dispatchEvent(new Event(_model.currentState));
			super.stateUpdate($event);
		}
		
		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case fbPictureButton:	return UserPicturePickerStates.FB_PICTURE_MODE;
				case webCamPicButton:	return UserPicturePickerStates.WEB_CAM_MODE;
				case userFilePicButton:	return UserPicturePickerStates.USER_FILE_MODE;
				case cancelButton:		return BasicFormStates.ON_CANCEL_BTN;
			}
			return "";
		}
		
		protected function showMenu($show:Boolean = true):void {
			addElement(fbPictureButton, $show);
			addElement(userFilePicButton, $show);
			addElement(webCamPicButton, $show);
			addElement(cancelButton, $show);
		}
		
		protected function setUserPickerView():void {
			addView(new BasicFileReferenceView(userPickerModel.userFileModel,
				userPickerModel.selectFileController));
		}
		
		protected function setWebcamPictureView():void {
			addView(new BasicWebcamView(userPickerModel.webcamPicModel,
				userPickerModel.selectFileController));
		}
		
		protected function setFBPicPickerView():void {
			addView(new BasicFBGraphPicturePickerView(userPickerModel.fbPicModel,
				userPickerModel.selectFileController));
		}
		
		protected function addView($view:IView):IView {
			showMenu(false);
			addElement($view as DisplayObject);
			_currentSubView = $view;
			return $view;
		}
		
	}
}