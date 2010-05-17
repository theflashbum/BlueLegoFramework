package blue.lego.components {

    import com.flashartofwar.fboxmodel.decorators.BackgroundColorDecorator;
    import com.flashartofwar.fboxmodel.decorators.BackgroundImageDecorator;
    import com.flashartofwar.fcss.utils.TypeHelperUtil;
    import com.flashartofwar.fspritesheets.sheets.ISpriteSheet;
    import com.flashartofwar.fspritesheets.sprites.FSprite;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    import flight.events.PropertyEvent;
    import flight.observers.PropertyChange;

    import reflex.behaviors.CompositeBehavior;
    import reflex.behaviors.IBehavior;
    import reflex.display.Container;
    import reflex.layout.Layout;

    public class LegoBlock extends Container implements IStyleable {

        protected static const URL:String = "url";
        protected static const DECAL:String = "decal";

        protected var DELIMITER:String = " ";
        private var _styleID:String;
        private var _styleClass:String;
        private var _state:String;
        private var _data:Object;
        protected var backgroundColorDecorator:BackgroundColorDecorator;
        protected var backgroundImageDecorator:BackgroundImageDecorator;
        private var _behaviors:CompositeBehavior;

        //
        protected var _bgImageLoader:Loader;
        protected var cachedBackgroundImages:Dictionary = new Dictionary(true);
        protected var backgroundImageSource:String;
        protected var activeSprite:FSprite;
        protected var _spriteSheet:ISpriteSheet;
        protected var _backgroundImageBitmap:Bitmap;

        public function LegoBlock()
        {
            _behaviors = new CompositeBehavior(this);

            createBoxModelDecorators(graphics);
            PropertyChange.addHook(this, "skin", this, setTarget);
        }

        [Bindable]
        public function set spriteSheet(value:ISpriteSheet):void
        {
            _spriteSheet = value;
        }

        [Bindable(event="backgroundColorChange")]
        public function get backgroundColor():uint
        {
            return backgroundColorDecorator.color;
        }

        [Bindable(event="backgroundImageBitmapChange")]
        public function set backgroundImageBitmap(value:Bitmap):void
        {
            _backgroundImageBitmap = value;
            sampleBackground(_backgroundImageBitmap);
        }

        public function get backgroundImageBitmap():Bitmap
        {
            return _backgroundImageBitmap;
        }

        public function backgroundImageBitmapData(value:BitmapData):void
        {

        }

        public function set backgroundColor(value:uint):void
        {
            if (backgroundColorDecorator.color == value) {
                return;
            }

            backgroundColorDecorator.color = PropertyEvent.change(this, "backgroundColor", backgroundColorDecorator.color, value);
            if (isNaN(backgroundColorDecorator.color)) {
                removeEventListener(Layout.LAYOUT, onRender);
            } else {
                addEventListener(Layout.LAYOUT, onRender);
                draw();
            }
            PropertyEvent.dispatch(this);
        }

        [Bindable(event="backgroundColorAlphaChange")]
        public function get backgroundColorAlpha():Number
        {
            return backgroundColorDecorator.alpha;
        }

        public function set backgroundColorAlpha(value:Number):void
        {
            if (backgroundColorDecorator.alpha == value) {
                return;
            }

            backgroundColorDecorator.alpha = PropertyEvent.change(this, "backgroundColorAlpha", backgroundColorDecorator.alpha, value);
            if (isNaN(backgroundColorDecorator.alpha)) {
                removeEventListener(Layout.LAYOUT, onRender);
            } else {
                addEventListener(Layout.LAYOUT, onRender);
                draw();
            }
            PropertyEvent.dispatch(this);
        }


        /**
         * Scale9Grid of the background image
         * @return Rectangle
         */
        public function get backgroundScale9Grid():Rectangle
        {
            return backgroundImageDecorator.scale9Grid;
        }

        /**
         * @private
         */
        public function set backgroundScale9Grid(backgroundScale9Grid:Rectangle):void
        {
            backgroundImageDecorator.scale9Grid = backgroundScale9Grid;

        }

        /**
         * The repeat settings for the background image
         * @return String
         */
        public function get backgroundRepeat():String
        {
            return backgroundImageDecorator.repeat;
        }

        /**
         * @private
         */
        public function set backgroundRepeat(backgroundRepeat:String):void
        {
            backgroundImageDecorator.repeat = backgroundRepeat;
            invalidate();
        }

        private function createBoxModelDecorators(graphics:Graphics):void
        {
            backgroundColorDecorator = new BackgroundColorDecorator(graphics);
            backgroundImageDecorator = new BackgroundImageDecorator(graphics);
        }

        /**
         * @private
         */
        public function set backgroundPosition(value:String):void
        {
            var split:Array = value.split(DELIMITER, 2);

            backgroundPositionX = Number(split[0]);
            backgroundPositionY = Number(split[1]);
        }


        /**
         * The Box Model background x position
         * @return Number
         */
        public function get backgroundPositionX():Number
        {
            return backgroundImageDecorator.imagePositionX;
        }

        /**
         * @private
         */
        public function set backgroundPositionX(backgroundPositionX:Number):void
        {
            backgroundImageDecorator.imagePositionX = backgroundPositionX;

        }

        /**
         * The Box Model background y position
         * @return Number
         */
        public function get backgroundPositionY():Number
        {
            return backgroundImageDecorator.imagePositionY;
        }

        /**
         * @private
         */
        public function set backgroundPositionY(backgroundPositionY:Number):void
        {
            backgroundImageDecorator.imagePositionY = backgroundPositionY;

        }

        public function set backgroundImage(value:String):void
        {
            if (value == "none")
            {
                clearBackgroundImage();
            }
            else
            {
                var request:Object = TypeHelperUtil.splitTypeFromSource(value);
                var type:String = request.type;
                var source:String = request.source;

                switch (type)
                {
                    /*case ASSET:
                     //TODO call asset manager
                     var asset:Loader = assetManager.getAsset( source );
                     sampleBackground( asset.content as Bitmap );
                     break;
                     */
                    case DECAL:

                        if(!_spriteSheet)
                            throw new Error("No Sprite Sheet is set!");

                        if(activeSprite)
                        {
                            removeSpriteListeners(activeSprite);
                            activeSprite = null;
                        }
                            
                        activeSprite = _spriteSheet.getDecal(source);
                        addSpriteListeners(activeSprite);

                        sampleBackground(activeSprite);
                        break;
                    case URL: default:
                    loadBackgroundImage(new URLRequest(source));
                    break;
                }

            }

            invalidate();
        }

        protected function removeSpriteListeners(target:IEventDispatcher):void {
            target.removeEventListener(Event.CHANGE, onSpriteChange);    
        }

        protected function addSpriteListeners(target:IEventDispatcher):void {
            target.addEventListener(Event.CHANGE, onSpriteChange);
        }

        protected function onSpriteChange(event:Event):void {
            sampleBackground(event.target as FSprite);
        }

        /**
         *
         * @param type
         * @param source
         *
         */
        protected function loadBackgroundImage(request:URLRequest):Loader
        {
            //TODO set this to string and use TypeHelperUtil splitTypeFromSource instead.

            if (!cachedBackgroundImages[request.url])
            {
                _bgImageLoader = new Loader();

                backgroundImageSource = request.url;

                addBGLoaderListeners(_bgImageLoader.contentLoaderInfo);
                _bgImageLoader.load(request);

                return _bgImageLoader;
            }
            else
            {
                //TODO this may need to be cleaned up
                sampleBackground(cachedBackgroundImages[request.url]);
                return null;
            }


        }

        /**
         * <p>This is called when a BG Image is loaded. It attaches the BG Image's
         *    BitmapData to the _backgroundImageContainer. If 9 Slice data was
         *    supplied it will put the BitmapData into a ScaleBitmap class, apply
         *    the 9 slice values to allow undistorted stretching of the supplied
         *    BG Image.</p>
         */
        protected function onBGImageLoad(e:Event):void
        {
            var info:LoaderInfo = e.target as LoaderInfo;
            var loader:Loader = info.loader;
            var tempBitmap:Bitmap = Bitmap(loader.content);

            if (backgroundImageSource)
                cachedBackgroundImages[backgroundImageSource] = tempBitmap;

            if (_bgImageLoader)
                if (_bgImageLoader.contentLoaderInfo)
                    removeBGLoaderListeners(_bgImageLoader.contentLoaderInfo);

            sampleBackground(tempBitmap);
        }

        /**
         *
         * @param tempBitmap
         *
         */
        protected function sampleBackground(tempBitmap:Bitmap):void
        {
            backgroundImageDecorator.imageBitmap = tempBitmap;
            _bgImageLoader = null;
            invalidate();
        }

        /**
         * <p>attaches listeners to LoaderInfo. This is used to streamline the
         * repetitive adding of listeners in the preload process.</p>
         */
        protected function addBGLoaderListeners(target:LoaderInfo):void
        {
            target.addEventListener(Event.COMPLETE, onBGImageLoad);
            target.addEventListener(IOErrorEvent.IO_ERROR, ioError);
        }

        /**
         * <p>removes listeners to LoaderInfo. This is used to streamline the
         * remove of listeners from the preload process and frees up memory.</p>
         */
        internal function removeBGLoaderListeners(target:LoaderInfo):void
        {
            target.removeEventListener(Event.COMPLETE, onBGImageLoad);
            target.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
            backgroundImageSource = null;
        }


        /**
         * <p>Called when a file can not be loaded. It automatically triggers
         * the next preload.</p>
         */
        internal function ioError(event:IOErrorEvent):void
        {
            //throw new IllegalOperationError("ERROR: Could not load background image.");
        }

        public function clearBackgroundImage():void
        {
            if (_bgImageLoader)
            {
                try
                {
                    _bgImageLoader.close();
                }
                catch(error:Error)
                {
                    trace("Bg Image Loader could not be closed");
                }
                removeBGLoaderListeners(_bgImageLoader.contentLoaderInfo);
                _bgImageLoader = null;
            }
            //TODO This was clearBackgroundImage and was changed to clearBackground, may be to aggressive
            invalidate();
        }

        [Bindable]
        public function get state():String
        {
            return _state;
        }

        public function set state(value:String):void
        {
            var change:PropertyChange = PropertyChange.begin();
            _state = change.add(this, "state", _state, value);
            change.commit();
        }


        [Bindable]
        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            var change:PropertyChange = PropertyChange.begin();
            _data = change.add(this, "data", _data, value);
            change.commit();
        }


        [ArrayElementType("reflex.behaviors.IBehavior")]
        /**
         * A dynamic object or hash map of behavior objects. <code>behaviors</code>
         * is effectively read-only, but setting either an IBehavior or array of
         * IBehavior to this property will add those behaviors to the <code>behaviors</code>
         * object/map.
         *
         * To set behaviors in MXML:
         * &lt;Component...&gt;
         *   &lt;behaviors&gt;
         *     &lt;SelectBehavior/&gt;
         *     &lt;ButtonBehavior/&gt;
         *   &lt;/behaviors&gt;
         * &lt;/Component&gt;
         */
        public function get behaviors():*
        {
            return _behaviors;
        }

        public function set behaviors(value:*):void
        {
            var change:PropertyChange = PropertyChange.begin();
            value = change.add(this, "behaviors", _behaviors, value);
            _behaviors.clear();
            if (value is Array) {
                _behaviors.add(value);
            } else if (value is IBehavior) {
                _behaviors.add([value]);
            }
            change.commit();
        }

        protected function setTarget(oldValue:*, newValue:*):void
        {
            if (oldValue != null) {
                oldValue.target = null;
            }

            if (newValue != null) {
                newValue.target = this;
            }
        }

        override protected function constructChildren():void
        {
            // load skin from CSS, etc
        }

        public function get styleID():String {
            return _styleID;
        }

        public function get styleClass():String {
            return _styleClass;
        }

        public function set styleID(value:String):void {
            _styleID = value;
        }

        public function set styleClass(value:String):void {
            _styleClass = value;
        }

        override protected function draw():void
        {
            drawBackground();
        }

        /**
         *
         *
         */
        protected function drawBackground():void
        {
            graphics.clear();

            backgroundColorDecorator.width = displayWidth;
            backgroundColorDecorator.height = displayHeight;
            backgroundColorDecorator.draw();

            backgroundImageDecorator.offsetX = 0;
            backgroundImageDecorator.offsetY = 0;
            backgroundImageDecorator.width = displayWidth;
            backgroundImageDecorator.height = displayHeight;
            backgroundImageDecorator.draw();
        }

        protected function onRender(event:Event):void
        {
            draw();
        }
    }
}