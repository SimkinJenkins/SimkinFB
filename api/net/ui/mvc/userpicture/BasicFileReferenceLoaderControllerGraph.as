package net.interalia.etnia.ui.mvc.userpicture {
	import net.interalia.etnia.ui.mvc.interfaces.IModel;

	public class BasicFileReferenceLoaderControllerGraph extends BasicFileReferenceControllerGraph {
		public function BasicFileReferenceLoaderControllerGraph($model:IModel) {
			super($model);
		}
		
		override protected function addClickHandler():void {
			if(!fileReferenceModel.terms) {
				_model.setError(BasicFileReferenceStates.TERMS_ERROR);
				return;
			}
			try {
				_fileReference.load(); 
				_model.setState(BasicFileReferenceStates.LOADING_FILE);
			} catch ($error:Error) {
				trace($error);
				_model.setError(BasicFileReferenceStates.UPLOAD_ERROR, $error.toString());
			}
		}
	}
}