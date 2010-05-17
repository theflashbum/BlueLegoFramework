package blue.lego.layouts.algorithms {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    import reflex.layout.ILayoutAlgorithm;

    public class AbstractStackAlgorithm implements ILayoutAlgorithm {

        public static const VERTICAL:String = "y";
        public static const HORIZONTAL:String = "x";

        private const WIDTH:String = "width";
        private const HEIGHT:String = "height";

        private var dirProp:String = HORIZONTAL;
        private var sizeProp:String = WIDTH;

        protected function set direction(value:String):void
        {
            switch (value)
            {
                case VERTICAL:
                    dirProp = VERTICAL;
                    sizeProp = HEIGHT;
                    break;
                default:
                    dirProp = HORIZONTAL;
                    sizeProp = WIDTH;
                    break;
            }
        }

        public function AbstractStackAlgorithm(self:AbstractStackAlgorithm) {
            if (self != this)
            {
                throw new Error("AbstractStackAlgorithm cannot be directly Instantiated");
            }
        }

        public function measure(target:DisplayObjectContainer):void {
            return;
        }

        public function layout(target:DisplayObjectContainer):void {
            var total:int = target.numChildren;
            var i:int;
            var nextCoord:Number = 0;
            var currentInstance:DisplayObject;

            for (i = 0; i < total; i ++)
            {
                currentInstance = target.getChildAt(i);
                currentInstance[dirProp] = nextCoord;

                nextCoord += currentInstance[sizeProp];
            }
        }
    }
}