package blue.lego.components {
    import com.flashartofwar.fcss.enum.CSSProperties;

    import flash.events.Event;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextLineMetrics;

    import reflex.events.RenderEvent;

    public class Label extends LegoBlock {
        public static const TEXT_CHANGE:String = "textChange";
        RenderEvent.registerPhase(TEXT_CHANGE, 0x90); // before measure


        protected var _styleSheet:StyleSheet;
        protected var textField:TextField = new TextField();
        protected var _textTransform:String = CSSProperties.NONE;
        protected var _textAlign:String = CSSProperties.LEFT;

        protected var proxyTextFormat:TextFormat = new TextFormat();

        public function get instance():TextField
        {
            return textField;
        }

        public function get textTransform():String
        {
            return _textTransform;
        }

        public function set leading(value:Number):void
        {
            proxyTextFormat.leading = value;
            invalidate();
        }

        public function set textTransform(value:String):void
        {
            _textTransform = validateTextTransform(value);
        }

        /**
         *
         * @param value
         *
         */
        public function set textAlign(value:String):void
        {
            _textAlign = value;
        }

        /**
         *

         *
         */
        public function get textFieldWidth():Number
        {
            return textField.width;
        }

        /**
         *
         * @param value
         *
         */
        public function set textFieldWidth(value:Number):void
        {
            textField.width = value;
            updateDefaultSize();
        }

        /**
         *

         *
         */
        public function get textFieldHeight():Number
        {
            return textField.height;
        }

        /**
         *
         * @param value
         *
         */
        public function set textFieldHeight(value:Number):void
        {
            textField.height = value;
        }

        /**
         *

         *
         */
        public function get autoSize():String
        {
            return textField.autoSize;
        }

        /**
         *
         * @param value
         *
         */
        public function set autoSize(value:String):void
        {
            textField.autoSize = validateAutoSize(value);
        }

        /**
         *

         *
         */
        public function get antiAliasType():String
        {
            return textField.antiAliasType;
        }

        /**
         *
         * @param value
         *
         */
        public function set antiAliasType(value:String):void
        {
            textField.antiAliasType = validateAntiAliasType(value);
        }

        /**
         *

         *
         */
        public function get condenseWhite():Boolean
        {
            return textField.condenseWhite;
        }

        /**
         *
         * @param value
         *
         */
        public function set condenseWhite(value:Boolean):void
        {
            textField.condenseWhite = value;
        }

        /**
         *

         *
         */
        public function get defaultTextFormat():TextFormat
        {
            return textField.defaultTextFormat;
        }

        /**
         *
         * @param value
         *
         */
        public function set defaultTextFormat(value:TextFormat):void
        {
            textField.defaultTextFormat = value;
        }

        /**
         *

         *
         */
        public function get embedFonts():Boolean
        {
            return textField.embedFonts;
        }

        /**
         *
         * @param value
         *
         */
        public function set embedFonts(value:Boolean):void
        {
            textField.embedFonts = value;
        }

        /**
         *

         *
         */
        public function get gridFitType():String
        {
            return textField.gridFitType;
        }

        /**
         *
         * @param value
         *
         */
        public function set gridFitType(value:String):void
        {
            textField.gridFitType = value;
        }

        /**
         *
         * @param value
         *
         */
        public function set htmlText(value:String):void
        {
            if (_styleSheet)
                textField.styleSheet = _styleSheet;
            textField.htmlText = transformText(value);
        }

        /**
         *

         *
         */
        public function get htmlText():String
        {
            return textField.htmlText;
        }

        /**
         int
         */
        public function    get length():int
        {
            return textField.length;
        }

        /**
         *

         *
         */
        public function get multiline():Boolean
        {
            return textField.multiline;
        }

        /**
         *
         * @param value
         *
         */
        public function set multiline(value:Boolean):void
        {
            textField.multiline = value;
        }

        /**
         *

         *
         */
        public function get wordWrap():Boolean
        {
            return textField.wordWrap;
        }

        /**
         *
         * @param value
         *
         */
        public function set wordWrap(value:Boolean):void
        {
            textField.wordWrap = value;
        }

        /**
         *

         *
         */
        public function get selectable():Boolean
        {
            return textField.selectable;
        }

        /**
         *
         * @param value
         *
         */
        public function set selectable(value:Boolean):void
        {
            textField.selectable = value;
        }

        /**
         *

         *
         */
        public function get sharpness():Number
        {
            return textField.sharpness;
        }

        /**
         *
         * @param value
         *
         */
        public function set sharpness(value:Number):void
        {
            textField.sharpness = value;
        }

        /**
         *

         *
         */
        public function get styleSheet():StyleSheet
        {
            return _styleSheet;
        }

        /**
         *
         * @param value
         *
         */
        public function set styleSheet(value:StyleSheet):void
        {
            _styleSheet = value;
        }

        /**
         *

         *
         */
        public function get text():String
        {
            return textField.text;
        }

        /**
         *
         * @param value
         *
         */
        public function set text(value:String):void
        {
            textField.text = transformText(value);
            RenderEvent.invalidate(this, TEXT_CHANGE);

        }


        private function onChange(event:Event):void
        {
            RenderEvent.invalidate(this, TEXT_CHANGE);
        }

        protected function updateDefaultSize():void
        {
            block.defaultWidth = Math.ceil(textField.textWidth) + 4; // gutter is 2px all around
            block.defaultHeight = Math.ceil(textField.textHeight) + 4;
            //scrollH = 0;
        }


        /**
         *

         *
         */
        public function get thickness():Number
        {
            return textField.thickness;
        }

        /**
         *
         * @param value
         *
         */
        public function set thickness(value:Number):void
        {
            textField.thickness = value;
        }

        public function getLineMetrics(lineNumber:int):TextLineMetrics
        {
            return textField.getLineMetrics(lineNumber);
        }

        /**
         * <p>This represents align on a TextFormat.</p>
         * @param value
         *
         */
        public function set textFieldAlign(value:String):void
        {
            proxyTextFormat.align = value;
        }

        public function set fontFace(value:String):void
        {
            font = value;
        }

        public function set fontSize(value:Number):void
        {
            size = value;
        }

        public function set font(value:String):void
        {
            proxyTextFormat.font = value;
            invalidate();
        }

        public function set blockIndent(value:Object):void
        {
            proxyTextFormat.blockIndent = value;
            invalidate();
        }

        public function set bold(value:Boolean):void
        {
            proxyTextFormat.bold = value;
            invalidate();
        }

        public function set bullet(value:Object):void
        {
            proxyTextFormat.bullet = value;
            invalidate();
        }

        public function set color(value:uint):void
        {
            proxyTextFormat.color = value;
            invalidate();
        }

        public function set size(value:Number):void
        {
            proxyTextFormat.size = value;
            invalidate();
        }

        public function set letterSpacing(value:Number):void
        {
            proxyTextFormat.letterSpacing = value;
            invalidate();
        }

        /**
         *
         * @param config
         *
         */
        public function Label()
        {
            super();
        }

        /**
         *
         * @param config
         *
         */
        override protected function init():void
        {
            //TODO do we really need a listener for every change text?

            super.init();
            preStyle();
            draw();
        }

        protected function preStyle():void
        {
            addListeners();
            addChild(textField);

            textField.selectable = false;
            textField.autoSize = "left";
        }

        override protected function draw():void
        {
            proxyTextFormat.align = _textAlign;

            // Hacked, but there has to be a better way.
            textField.defaultTextFormat = proxyTextFormat;

            textField.setTextFormat(proxyTextFormat);

            updateDefaultSize();

            super.draw();


            //block.invalidate();
        }

        /**
         *
         *
         */
        protected function addListeners():void
        {
            textField.addEventListener(Event.CHANGE, onTextChange);
        }

        /**
         *
         * @param format
         * @param beginIndex
         * @param endIndex
         *
         */
        public function setTextFormat(format:TextFormat, beginIndex:int = - 1, endIndex:int = - 1):void
        {
            textField.setTextFormat(format, beginIndex, endIndex);
        }

        /**
         *
         * @param event
         *
         */
        protected function onTextChange(event:Event):void
        {
            event.stopPropagation();
            updateDefaultSize();
            dispatchEvent(new Event(Event.CHANGE, true));
        }

        /**
         *
         * @param value

         *
         */
        public static function validateAntiAliasType(value:String):String
        {
            switch (value)
            {
                case CSSProperties.ADVANCED:
                    return value;
                    break;
                default:
                    return CSSProperties.NORMAL;
                    break;
            }

            // IntelliJ was not happy that this method didn't have a return, it's a feature not a bug
            return null;
        }

        /**
         *
         * @param value

         *
         */
        public static function validateAutoSize(value:String):String
        {
            switch (value)
            {
                case CSSProperties.LEFT:
                case CSSProperties.RIGHT:
                case CSSProperties.CENTER:
                    return value;
                    break;
                default:
                    return CSSProperties.NONE;
                    break;
            }

            // IntelliJ was not happy that this method didn't have a return, it's a feature not a bug
            return null;
        }

        public static function validateTextTransform(value:String):String
        {
            switch (value)
            {
                case CSSProperties.UPPERCASE:
                case CSSProperties.LOWERCASE:
                    return value;
                    break;
                default:
                    return CSSProperties.NONE;
            }

            // IntelliJ was not happy that this method didn't have a return, it's a feature not a bug
            return null;
        }

        protected function transformText(value:String):String
        {
            switch (_textTransform)
            {
                case CSSProperties.UPPERCASE:
                    return value.toUpperCase();
                    break;
                case CSSProperties.LOWERCASE:
                    return value.toLowerCase();
                    break;
                default:
                    return value;
            }

            // IntelliJ was not happy that this method didn't have a return, it's a feature not a bug
            return null;
        }
    }
}