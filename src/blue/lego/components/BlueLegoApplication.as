package blue.lego.components{
    import blue.lego.managers.SpriteSheetManager;

    import com.flashartofwar.fbootstrap.BootStrap;
    import com.flashartofwar.fbootstrap.events.BootstrapEvent;
    import com.flashartofwar.fbootstrap.managers.ResourceManager;
    import com.flashartofwar.fbootstrap.managers.SingletonManager;

    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.ui.ContextMenu;

    public class BlueLegoApplication extends LegoBlock {

        protected var _onCompleteHandler:Function;
        private var bootstrap:BootStrap = SingletonManager.getClassReference(BootStrap);
        protected var _configURL:String;
        protected var resourceManager:ResourceManager = SingletonManager.getClassReference(ResourceManager);

        public function BlueLegoApplication() {
            if (stage == null) {
                return;
            }

            contextMenu = new ContextMenu();
            contextMenu.hideBuiltInItems();
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
            onStageResize(null);
        }

        private function onStageResize(event:Event):void
        {
            block.width = stage.stageWidth;
            block.height = stage.stageHeight;
        }

        public function set onCompleteHandler(value:Function):void
        {
            _onCompleteHandler = value;
        }

        override protected function init():void
        {
            configureBootstrap();
            super.init();
        }

        private function configureBootstrap():void {
            bootstrap.addEventListener(BootstrapEvent.COMPLETE, onBootStrapComplete);
            bootstrap.loadConfig(_configURL);
        }

        protected function onBootStrapComplete(event:Event):void
        {
            configureDecalSheets();

            if (_onCompleteHandler) _onCompleteHandler();
            _onCompleteHandler = null;
        }

        private function configureDecalSheets():void {
            var decalSheet:SpriteSheetManager = SingletonManager.getClassReference(SpriteSheetManager);
            decalSheet.parseXML(XML(resourceManager.getResource("xml/decalsheet.xml")));
        }

        public function set configURL(value:String):void {
            _configURL = value;
        }
    }
}