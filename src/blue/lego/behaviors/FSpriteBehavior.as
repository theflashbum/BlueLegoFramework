package blue.lego.behaviors {

    import com.flashartofwar.fspritesheets.sprites.FSprite;

    import com.flashartofwar.fspritesheets.sprites.IFSprite;

    import flash.display.Bitmap;
    import flash.display.InteractiveObject;

    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import reflex.behaviors.Behavior;

    public class FSpriteBehavior extends Behavior {
        private var activeSprite:IFSprite;

        public function FSpriteBehavior(target:InteractiveObject = null) {
            super(target);
        }

        [Bindable]
        [Binding(target="target.backgroundImageBitmap")]
        public function set backgroundImageBitmap(value:Bitmap):void
        {
            if(value is IFSprite)
            {
                if(activeSprite)
                {
                    removeSpriteListeners(activeSprite);
                    activeSprite = null;
                }

                activeSprite = value as IFSprite;
                addSpriteListeners(activeSprite);
            }
        }

        protected function removeSpriteListeners(target:IEventDispatcher):void {
            target.removeEventListener(Event.CHANGE, onSpriteChange);
        }

        protected function addSpriteListeners(target:IEventDispatcher):void {
            target.addEventListener(Event.CHANGE, onSpriteChange);
        }

        protected function onSpriteChange(event:Event):void {
            if(target.hasOwnProperty("backgroundImageBitmapData"));
            target["backgroundImageBitmapData"] = activeSprite.bitmapData.clone();
        }
        
    }
}