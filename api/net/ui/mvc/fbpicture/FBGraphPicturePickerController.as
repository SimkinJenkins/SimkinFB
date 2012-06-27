package net.ui.mvc.fbpicture {

	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	
	import flash.events.Event;
	
	import net.structures.AlbumData;
	import net.structures.PhotoData;

	public class FBGraphPicturePickerController extends BasicFriendsFBGraphPicturePickerController implements IFormController {

		public function FBGraphPicturePickerController($model:IModel) {
			super($model);
		}

		override protected function setCurrentCoverData($result:Object):void {
			(fbPPModel.albums[fbPPModel.currentCover] as AlbumData).coverDetail = new PhotoData($result);
			_model.setState(BasicFBPicturePickerStates.ALBUM_DATA_LOADED);
		}

	}
}