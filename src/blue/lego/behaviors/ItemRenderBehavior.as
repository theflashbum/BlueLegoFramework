package blue.lego.behaviors {
    import blue.lego.components.IStyleable;

    import flash.display.InteractiveObject;

    import mx.core.IMXMLObject;

    import reflex.behaviors.Behavior;

    public class ItemRenderBehavior extends Behavior implements IMXMLObject{

        private var _target:InteractiveObject;
        private var _itemTemplate:Class;

        public function set item(value:Class):void
        {
            _itemTemplate = value;
        }
        public function ItemRenderBehavior() {
            super();
        }

        [Bindable]
        [Binding(target="target.data")]
        public function set data(value:Array):void
        {
            renderItems(value)
        }

        private function renderItems(value:Array):void {
            var total:int = value.length;
            var i:int;

            for (i = 0; i < total; i++)
            {
                createItem(i);
            }
        }

        private function createItem(i:int):void {
            //TODO add logic to creat item    
        }

        [Bindable]
        override public function get target():InteractiveObject {
            return _target as InteractiveObject;
        }

        override public function set target(value:InteractiveObject):void {

            if (value)
            {
                if (value.hasOwnProperty("data") && value["data"] is Array)
                {
                    _target = value;
                }
                else
                {
                    throw new Error("ItemRenderBehavior can only be added to classes that has Data");
                }
            }
        }

        public function initialized(document:Object, id:String):void {
        }
    }
}