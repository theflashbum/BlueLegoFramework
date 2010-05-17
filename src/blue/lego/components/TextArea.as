package blue.lego.components {
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;

    public class TextArea extends Label {
        //protected var scroller : ScrollBar;

        public function TextArea()
        {
            super();
        }

        /**
         *

         *
         */
        public function    get alwaysShowSelection():Boolean
        {
            return textField.alwaysShowSelection;
        }

        /**
         *
         * @param value
         *
         */
        public function set alwaysShowSelection(value:Boolean):void
        {
            textField.alwaysShowSelection = value;
        }

        /**
         int
         */
        public function    get bottomScrollV():int
        {
            return textField.bottomScrollV;
        }

        /**
         int
         */
        public function    get caretIndex():int
        {
            return textField.caretIndex;
        }

        /**
         int
         */
        public function    get maxChars():int
        {
            return textField.maxChars;
        }

        /**
         * @private
         */
        public function set maxChars(value:int):void
        {
            textField.maxChars = value;
        }

        /**
         int
         */
        public function    get maxScrollH():int
        {
            return textField.maxScrollH;
        }

        /**
         int
         */
        public function    get maxScrollV():int
        {
            return textField.maxScrollV;
        }

        /**
         Boolean
         */
        public function    get mouseWheelEnabled():Boolean
        {
            return textField.mouseWheelEnabled;
        }

        /**
         * @private
         */
        public function set mouseWheelEnabled(value:Boolean):void
        {
            textField.mouseWheelEnabled = value;
        }

        /**
         int
         */
        public function    get numLines():int
        {
            return textField.numLines;
        }

        /**
         String
         */
        public function    get restrict():String
        {
            return textField.restrict;
        }

        /**
         * @private
         */
        public function set restrict(value:String):void
        {
            textField.restrict = value;
        }

        /**
         int
         */
        public function    get scrollH():int
        {
            return textField.scrollH;
        }

        /**
         * @private
         */
        public function set scrollH(value:int):void
        {
            textField.scrollH = value;
        }

        /**
         int
         */
        public function    get scrollV():int
        {
            return textField.scrollV;
        }

        /**
         * @private
         */
        public function set scrollV(value:int):void
        {
            textField.scrollV = value;
        }

        /**
         int
         */
        public function    get selectionBeginIndex():int
        {
            return textField.selectionBeginIndex;
        }

        /**
         int
         */
        public function    get selectionEndIndex():int
        {
            return textField.selectionEndIndex;
        }

        /**
         Number
         */
        public function    get textHeight():Number
        {
            return textField.textHeight;
        }

        /**
         Number
         */
        public function    get textWidth():Number
        {
            return textField.textWidth;
        }

        /**
         Boolean
         */
        public function    get useRichTextClipboard():Boolean
        {
            return textField.useRichTextClipboard;
        }

        /**
         * @private
         */
        public function set useRichTextClipboard(value:Boolean):void
        {
            textField.useRichTextClipboard = value;
        }

        public function appendText(newText:String):void
        {
            textField.appendText(newText);
        }

        public function getLineLength(lineIndex:int):int
        {
            return textField.getLineLength(lineIndex);
        }

        public function getLineOffset(lineIndex:int):int
        {
            return textField.getLineOffset(lineIndex);
        }

        public function getLineText(lineIndex:int):String
        {
            return textField.getLineText(lineIndex);
        }

        override public function set leading(value:Number):void
        {
            proxyTextFormat.leading = value;
        }

        override public function set text(value:String):void
        {
            super.text = value;
            //updateScroller( );
        }

        override public function set htmlText(value:String):void
        {
            super.htmlText = value;
            //updateScroller( );
        }

        override protected function preStyle():void
        {
            applyDefaultProperties();
            super.preStyle();
        }

        protected function applyDefaultProperties():void
        {
            textField.type = TextFieldType.DYNAMIC;
            textField.autoSize = TextFieldAutoSize.NONE;
            textField.selectable = false;
            textField.multiline = true;
            textField.wordWrap = true;
            textField.background = false;
        }

        /*override protected function activateOverflowScroll() : void
         {
         scroller = new ScrollBar( id + "ScrollBar", null, display, overflow, true );
         display.addEventListener(MouseEvent.MOUSE_WHEEL, checkWheel);

         $addChild( scroller );

         updateScroller( );
         }

         private function checkWheel(e:MouseEvent):void {
         scroller.scroll(e.delta*5);
         }

         protected function updateScroller() : void
         {
         alignScrollBar( );
         resizeScrollBar( );
         }

         protected function resizeScrollBar() : void
         {
         if(scroller)
         scroller.setHeight( maskShape.height );
         }

         protected function alignScrollBar() : void
         {
         if(scroller)
         {
         switch(scroller.align)
         {
         case(Direction.LEFT):
         scroller.x = display.x - (scroller.width + scroller.marginRight);
         break;
         case(Direction.RIGHT):
         default:
         trace( scroller.marginLeft );
         scroller.x = display.width + scroller.marginLeft;
         break;
         }
         }
         }*/
    }
}