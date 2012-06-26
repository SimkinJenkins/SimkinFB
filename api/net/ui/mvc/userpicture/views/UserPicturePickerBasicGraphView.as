package net.ui.mvc.userpicture.views {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.interfaces.IView;
	import com.ui.controllers.mvc.userpicture.BasicFileReferenceView;
	import com.ui.controllers.mvc.userpicture.UserPicturePickerStates;
	import com.ui.controllers.mvc.views.BasicFormView;
	import com.ui.controllers.mvc.webcam.BasicWebcamView;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.ui.mvc.fbpicture.BasicFBGraphPicturePickerView;
	import net.ui.mvc.userpicture.UserPicturePickerGraphModel;

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