package blue.lego.behaviors {

    import blue.lego.components.IStyleable;

    import com.flashartofwar.fcss.applicators.IApplicator;
    import com.flashartofwar.fcss.applicators.StyleApplicator;
    import com.flashartofwar.fcss.enum.CSSProperties;
    import com.flashartofwar.fcss.styles.IStyle;
    import com.flashartofwar.fcss.stylesheets.IStyleSheet;

    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import mx.core.IMXMLObject;

    import reflex.behaviors.Behavior;
    import reflex.behaviors.IBehavior;

    public class StyleBehavior extends Behavior implements IMXMLObject {

        public static const DEFAULT:String = "default";

        public static const UP:String = "up";

        protected static const ID_DELIMITER:String = " ";

        protected var _className:String;

        protected var _id:String;

        private var _defaultStyleNames:Array;

        protected var _styleSheet:IStyleSheet;

        protected var stateSelectorCache:Array = new Array();

        protected var cachedProperties:Dictionary = new Dictionary(true);

        //TODO Is there a better place to create this applicator so it is not expensive to inject a new instance
        protected var _applicator:IApplicator = new StyleApplicator();

        protected var _target:IStyleable;


        public function StyleBehavior(target:InteractiveObject = null) {
            super(target);
        }

        [Bindable]
        [Binding(target="target.state")]
        public function set state(value:String):void
        {
            trace("Apply State", value);
            applyDefaultStyle(value);
        }

        public function get state():String
        {
            return "defult";
        }

        public function set defaultState(value:String):void
        {
            applyDefaultStyle(value);
        }

        [Bindable]
        override public function get target():InteractiveObject {
            return _target as InteractiveObject;
        }

        override public function set target(value:InteractiveObject):void {

            if (value)
            {
                if (value is IStyleable)
                {
                    _target = value as IStyleable;
                    parseStyleNames(_target.styleID, _target.styleClass);
                }
                else
                {
                    throw new Error("StyleBehavior can only be added to classes that implement IApplyStyleBehavior");
                }
            }
        }

        public function set className(value:String):void {
            _className = value;
        }

        public function set styleID(value:String):void {
            _id = value;
        }

        /**
         * <p>This returns the ID used to find it's id style name. This id
         * does not include the "#" sign which is automatically added when a
         * style is requested.</p>
         *
         * @return string
         */
        public function get styleID():String
        {
            return _id;
        }

        /**
         *    <p>This will reapply the default styles the class started with.</p>
         */

        public function get defaultStyleNames():Array
        {
            return _defaultStyleNames.slice();
        }

        public function set defaultStyleNames(value:Array):void
        {
            _defaultStyleNames = value;
        }

        public function get styleSheet():IStyleSheet
        {
            return _styleSheet;
        }

        public function set styleSheet(value:IStyleSheet):void
        {
            trace("StyleSheet");
            _styleSheet = value;

            // I HATE IoC
            if (_applicator)
                applyDefaultStyle();
        }

        public function set applicator(value:Class):void
        {
            trace("Set Applicator");
            var tmpClass:IApplicator = new value();
            if (tmpClass is IApplicator) {
                _applicator = IApplicator(tmpClass);

                // I HATE IoC
                if (_styleSheet)
                    applyDefaultStyle();
            }

        }

        public function applyDefaultStyle(pseudoSelector:String = null):void
        {
            trace("ApplyDefaultStyle", pseudoSelector);
            var style:IStyle;

            if (pseudoSelector != null)
            {
                style = getPseudoSelector(pseudoSelector);
            }
            else
            {
                style = _styleSheet.getStyle.apply(null, defaultStyleNames);
            }

            if (style.styleName != CSSProperties.DEFAULT_STYLE_NAME)
                applyStyle(style);
        }

        /**
         * <p>This applies a supplied style to the class. It uses the
         * StyleApplierUtil to automatically convert the style's property
         * values to the correct type and apply them.</p>
         *
         * <p>Any public property can be configured by a style. If property
         * requires custom type conversion you will need to register that with
         * the StyleApplierUtil before calling this method. See the StyleApplierUtil
         * documentation for help on how to do that.</p>
         * @param style
         */
        public function applyStyle(style:IStyle):void
        {
            _applicator.applyStyle(target, style);
        }

        /**
         * <p>Returns the Class name of the ApplyStyleBehvior's target instance.
         * This class name does not include the "." sign which is automatically
         * added when a style is requested.</p>
         *
         * @return string
         */
        public function get className():String
        {

            if (!_className)
            {
                _className = getQualifiedClassName(target).split("::").pop();
            }
            return _className;
        }


        /**
         *
         * @param id
         */
        protected function parseStyleNames(styleID:String, styleClass:String = null):void
        {

            if (styleClass != null)
            {
                _defaultStyleNames = styleClass.replace(/ /g, " .").split(" ");
                _defaultStyleNames[0] = "." + _defaultStyleNames[0];
            }
            else
            {
                _defaultStyleNames = [];
            }

            // clean up styles
            _defaultStyleNames.unshift(className);

            _id = styleID;
            _defaultStyleNames.push("#" + _id);
        }

        public function getPseudoSelector(state:String):IStyle
        {

            if (! stateSelectorCache[state])
            {
                var pseudoSelector:String = "";

                // Just restore default style if no state is provided
                if ((state != UP) && (state != DEFAULT))
                {
                    pseudoSelector = ":" + state;
                }

                var selectorNames:Array = defaultStyleNames;

                var total:Number = selectorNames.length;

                for (var i:int = 0; i < total; i ++)
                {
                    selectorNames[i] = selectorNames[i] += pseudoSelector;
                }

                // Cache Selector names
                stateSelectorCache[state] = selectorNames;
            }

            // create unique id for selector name
            var selectorNamesID:String = stateSelectorCache[state].toString();
            var tempStyle:IStyle;

            if (cachedProperties[selectorNamesID])
            {
                tempStyle = cachedProperties[selectorNamesID].clone();
            }
            else
            {
                tempStyle = _styleSheet.getStyle.apply(null, stateSelectorCache[state]);
                cachedProperties[selectorNamesID] = tempStyle;
            }

            return tempStyle;
        }

        public function initialized(document:Object, id:String):void {
            trace("Style Behavior initialize");
        }
    }
}