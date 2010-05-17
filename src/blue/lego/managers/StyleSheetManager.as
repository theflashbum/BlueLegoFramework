package blue.lego.managers {
    import com.flashartofwar.fcss.styles.IStyle;
    import com.flashartofwar.fcss.stylesheets.IStyleSheet;
    import com.flashartofwar.fcss.stylesheets.IStyleSheetCollection;
    import com.flashartofwar.fcss.stylesheets.StyleSheetCollection;

    public class StyleSheetManager implements IStyleSheetCollection {

        protected var _collection:IStyleSheetCollection;

        public function StyleSheetManager() {
            // I do nothing
        }

        public function get collection():IStyleSheetCollection {
            return _collection ? _collection : new StyleSheetCollection;
        }

        public function set collection(value:IStyleSheetCollection):void {
            _collection = value;
        }

        public function get baseStyleSheet():IStyleSheet {
            return collection.baseStyleSheet;
        }

        public function getStyleSheet(name:String):IStyleSheet {
            return collection.getStyleSheet(name);
        }

        public function addStyleSheet(sheet:IStyleSheet, name:String = null):IStyleSheet {
            return collection.addStyleSheet(sheet, name);
        }

        public function removeStyleSheet(name:String):IStyleSheet {
            return collection.removeStyleSheet(name);
        }

        public function get totalStyleSheets():Number {
            return collection.totalStyleSheets;
        }

        public function get name():String {
            return collection.name;
        }

        public function set name(name:String):void {
            collection.name = name
        }

        public function parseCSS(CSSText:String, compressText:Boolean = true):IStyleSheet {
            return collection.parseCSS(CSSText, compressText);
        }

        public function clear():void {
            collection.clear();
        }

        public function get styleNames():Array {
            return collection.styleNames;
        }

        public function newStyle(name:String, style:IStyle):void {
        }

        public function getStyle(... styleName):IStyle {
            return collection.getStyle.apply(this, styleNames);
        }

        public function hasStyle(name:String):Boolean {
            return collection.hasStyle(name);
        }

        public function relatedStyles(name:String):Array {
            return collection.relatedStyles(name);
        }

        public function styleLookup(styleName:String, getRelated:Boolean = true):IStyle {
            return collection.styleLookup(styleName, getRelated);
        }

        public function toString():String
        {
            return collection.toString();
        }
    }
}