package blue.lego.components {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;

    /**
     * @author Jesse Freeman aka @theFlashBum | http://jessefreeman.com
     *
     * Simple ImageDisplay class which allows you to point to a src url.
     *
     * This example uses TweenLite to fade it up when loaded but you can
     * easily remove that logic if you don't need it.
     *
     * Usage:
     * var image:ImageDisplay = new ImageDisplay();
     * image.width = "400";// this will auto scale the image to the correct aspect ration when it loads
     * addChild(image);
     * image.src = "http://developerartofwar.com/wp-content/themes/flashartofwar/images/header.gif"
     */
    public class ImageBlock extends LegoBlock {

        protected var loader:Loader = new Loader();
        protected var image:Bitmap;
        protected var _keepAspect:Boolean = true;
        protected var _width:Number;
        protected var _height:Number;
        protected var display:Sprite = new Sprite();

        public function ImageBlock() {
            init();
        }

        override public function get width():Number {
            return _width;
        }

        override public function set width(value:Number):void {
            _width = value;
        }

        override public function get height():Number {
            return _height;
        }

        override public function set height(value:Number):void {
            _height = value;
        }

        public function set src(url:String):void
        {
            addEventListeners(loader.contentLoaderInfo);
            loader.load(new URLRequest(url));
        }


        public function resize(w:Number, h:Number, keepAspect:Boolean = true):void
        {
            _width = w;
            _height = h;
            _keepAspect = keepAspect;
            resizeImage(image);
        }

        override protected function init():void
        {
            super.init();
            addChild(display);
        }

        protected function addEventListeners(target:LoaderInfo):void {
            target.addEventListener(Event.COMPLETE, onLoad);
            target.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }

        protected function removeEventListeners(target:LoaderInfo):void {
            target.removeEventListener(Event.COMPLETE, onLoad);
            target.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        }

        protected function onSecurityError(event:SecurityErrorEvent):void {
            // Errors are bad
        }

        protected function onIOError(event:IOErrorEvent):void {
            // Errors are bad
        }

        protected function onLoad(event:Event):void {
            removeEventListeners(LoaderInfo(event.target));
            displayBitmap(Bitmap(event.target.content));
            dispatchEvent(event.clone());
        }

        protected function displayBitmap(image:Bitmap):void {
            this.image = image;
            if (isNaN(_width))
                _width = image.width;

            if (isNaN(_height))
                _height = image.height;

            resizeImage(image);

            //image.alpha = 0;

            display.addChild(image);
        }

        private function resizeImage(target:Bitmap):void {
            if (_keepAspect) {

                var targetWidth:Number = target.width;
                var targetHeight:Number = target.height;

                var sw:Number = _width;
                var sh:Number = _height;
                var tw:Number = targetWidth;
                var th:Number = targetHeight;

                var si:Number;
                //
                if (sw > sh) {
                    si = sw / tw;
                    if (th * si > sh)
                        si = sh / th;
                } else {
                    si = sh / th;
                    if (tw * si > sw)
                        si = sw / tw;
                }

                var wn:Number = tw * si;
                var hn:Number = th * si;

                target.width = wn;
                target.height = hn;
            } else {
                target.width = _width;
                target.height = _height;
            }
        }

        public function clear():void
        {

        }
    }
}