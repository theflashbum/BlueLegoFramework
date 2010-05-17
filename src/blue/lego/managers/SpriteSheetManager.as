/**
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: SpriteSheet.as</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 *
 * <p>Revisions<br/>
 *     2.0  Initial version Jan 7, 2009<br>
 *
 *     2.1  Decal Group Update Jun 6, 2009
 *
 *     Added support to parse out Decal Groups from XML:
 *
 *     Example:
 *
 *     <decal_group name="photo_texture_set_1">
 *        <decal name="photo_texture_set_1" x="0" y="0" w="500" h="332" sheet="photo_texture_set_1"/>
 *        <decal name="photo_mask_set_1" x="0" y="0" w="500" h="332" sheet="photo_mask_set_1"/>
 *        <decal name="photo_edges_mask_set_1" x="0" y="0" w="500" h="332" sheet="photo_edges_mask_set_1"/>
 *    </decal_group>
 *
 *  This will now create a DecalGroup to reference collectiosn of Decals.
 *
 *  You can also access a DecalGroup by calling getDecalGroup, it will return a
 *  dictionary of Decals with each decal's name as the key.
 *
 *  Also added new public property decalNames array to see all of the Decals
 *  registered in the DecalSheetManager.
 *
 * </p>
 *
 */

package blue.lego.managers
{
    import com.flashartofwar.fbootstrap.events.LoaderManagerEvent;
    import com.flashartofwar.fbootstrap.managers.BitmapLoaderManager;
    import com.flashartofwar.fspritesheets.sheets.ISpriteSheet;
    import com.flashartofwar.fspritesheets.sheets.SpriteSheet;
    import com.flashartofwar.fspritesheets.sprites.FSprite;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;
    import flash.system.LoaderContext;
    import flash.utils.Dictionary;

    /**
     * @author jessefreeman
     */
    public class SpriteSheetManager extends EventDispatcher implements ISpriteSheet
    {

        protected var sheetCollection:Dictionary = new Dictionary(true);
        protected var decalLookup:Dictionary = new Dictionary(true);
        protected var loadManager:BitmapLoaderManager = new BitmapLoaderManager();
        protected var sourceSheetLookup:Array = new Array();
        protected var sheetSrcBaseUrl:String;
        protected var sheetSourceLookup:Array = new Array();
        protected var decalGroups:Dictionary = new Dictionary(true);
        protected var decalGroupNames:Array = new Array();
        public var decalNames:Array = new Array();
        public var loaderContext:LoaderContext;

        public function SpriteSheetManager():void
        {
            loadManager.addEventListener(LoaderManagerEvent.LOADED, onLoaderComplete);
            loadManager.addEventListener(LoaderManagerEvent.PRELOAD_NEXT, redispatchEvent);
            loadManager.addEventListener(LoaderManagerEvent.PRELOAD_DONE, redispatchEvent);
            loadManager.addEventListener(LoaderManagerEvent.PROGRESS, redispatchEvent);
        }

        protected function onLoaderComplete(event:LoaderManagerEvent):void
        {
            var file:String = event.data.fileName;

            if (sourceSheetLookup[file])
            {
                var bmd:Bitmap = Bitmap(loadManager.loadedReference[file]);
                var sheet:SpriteSheet = sheetCollection[sourceSheetLookup[ file]];
                sheet.loaded = true;
                sheet.bitmapData = bmd.bitmapData.clone();
            }
        }

        protected function redispatchEvent(event:LoaderManagerEvent):void
        {
            event.stopPropagation();
            dispatchEvent(new LoaderManagerEvent(event.type, event.data, event.bubbles, event.cancelable));
        }

        public function parseXML(xml:XML):void
        {
            sheetSrcBaseUrl = xml.sheets.@baseURL;

            parseSheetXMLList(xml.sheets.*);
            parseDecalList(xml.decals.*);
        }

        /**
         * @private
         * @param list
         *
         */
        protected function parseSheetXMLList(list:XMLList):void
        {
            var preloadList:Array = new Array();

            var sheet:XML;
            for each(sheet in list)
            {
                var tempW:Number = sheet.hasOwnProperty("@w") ? Number(sheet.@w) : 1;
                var tempH:Number = sheet.hasOwnProperty("@h") ? Number(sheet.@h) : 1;
                var preload:Boolean = sheet.hasOwnProperty("@preload") ? ((sheet.@preload == "true") ? true : false) : false;

                newSheet(sheet.@name, tempW, tempH, sheetSrcBaseUrl + sheet.@src, preload);
                if (preload)
                    preloadList.push(sheetSrcBaseUrl + sheet.@src);
            }

            if (preloadList.length == 0)
            {
                dispatchEvent(new LoaderManagerEvent(LoaderManagerEvent.PRELOAD_DONE, null, true, true));
            }
            else
            {
                loadManager.addToQueue(preloadList);
            }
        }

        /**
         * @private
         * @param list
         *
         */
        protected function parseDecalList(list:XMLList, groupName:String = null):void
        {
            var spriteData:XML;
            for each(spriteData in list)
            {
                parseDecal(spriteData, groupName);
            }
        }

        /**
         *
         *
         */
        protected function parseDecal(data:XML, groupName:String = null):void
        {
            var name:String = data.@name;

            if (data.children().length() > 0 && ! (groupName))
            {
                decalGroups[name] = new Array();
                decalGroupNames.push(name);
                parseDecalList(data.children(), name);
            }
            else
            {
                var tempX:Number = data.hasOwnProperty("@x") ? Number(data.@x) : 0;
                var tempY:Number = data.hasOwnProperty("@y") ? Number(data.@y) : 0;
                var tempW:Number = data.hasOwnProperty("@w") ? Number(data.@w) : 1;
                var tempH:Number = data.hasOwnProperty("@h") ? Number(data.@h) : 1;
                newDecal(name, data.@sheet, tempX, tempY, tempW, tempH);

                if (groupName)
                    decalGroups[groupName].push(name);
            }
        }

        /**
         *
         *
         */
        public function newSheet(name:String, width:Number, height:Number, sourceURL:String, preload:Boolean, defaultColor:uint = 0x000000, pixelSnapping:String = "auto", smoothing:Boolean = false):void
        {
            var bmd:BitmapData = new BitmapData(width, height, false, defaultColor);

            var sheet:SpriteSheet = new SpriteSheet(bmd, pixelSnapping, smoothing);

            sheetCollection[name] = sheet;
            sourceSheetLookup[sourceURL] = name;
            sheetSourceLookup[name] = sourceURL;
        }

        public function getSheet(sheetName:String):SpriteSheet
        {
            trace("com.flashartofwar.camo.sheets.DecalSheetManager.getSheet(", sheetName, ")");
            // Check to make sure the sheet has loaded bitmapdata
            var source:String = sheetSourceLookup[sheetName];

            if (! loadManager.loadedReference[source])
            {
                loadManager.load(source, (loaderContext) ? loaderContext : null);
            }
            return sheetCollection[ sheetName ];
        }

        public function deleteSheet(sheetName:String):Boolean
        {
            var sheet:SpriteSheet = sheetCollection[sheetName];
            var success:Boolean = sheet.clear();

            if (success)
            {
                var source:String = sheetSourceLookup[sheetName];
                delete sheetCollection[sheetName];
                delete sourceSheetLookup[source];
                delete loadManager.loadedReference[source];
                delete sheetSourceLookup[sheetName];
            }
            else
            {
                success = false;
            }

            return success;
        }

        public function newDecal(name:String, sheetName:String, x:Number, y:Number, width:Number, height:Number, scale9Rect:Rectangle = null):void
        {
            var sheet:SpriteSheet = sheetCollection[sheetName];
            if (sheet)
            {
                sheet.registerDecal(name, new Rectangle(x, y, width, height), scale9Rect);
                decalLookup[ name ] = sheetName;
                decalNames.push(name);
            }
        }

        /**
         *
         * @param decalName
         */
        public function getDecal(decalName:String, pixelSnapping:String = "auto", smoothing:Boolean = false):FSprite
        {
            try
            {
                var sheet:String = decalLookup[decalName];

                return getSheet(sheet).getDecal(decalName, pixelSnapping, smoothing);
            }
            catch (error:Error)
            {
                trace("Unable to get decal", decalName, " - Error:", error);
            }
            return null;
        }

        /**
         *
         *
         */
        public function getDecalGroup(groupName:String, pixelSnapping:String = "auto", smoothing:Boolean = false):Dictionary
        {

            var collection:Dictionary = new Dictionary(true);

            for each (var decalName:String in decalGroups[groupName])
            {
                try
                {
                    collection[decalName] = getDecal(decalName, pixelSnapping, smoothing);
                }
                catch (error:Error)
                {
                    trace("Unable to add decal", decalName, "to Decal Collection", error);
                }
            }
            return collection;
        }

        /**
         *
         *
         */
        public function deleteDecal(decalName:String):Boolean
        {
            var sheetName:String = decalLookup[ decalName];
            var sheet:SpriteSheet = sheetCollection[sheetName];
            var success:Boolean = sheet.deleteDecal(decalName);

            if (success)
                delete decalLookup[decalName];
            else
                success = false;

            return success;
        }

        public function get loaded():Boolean {
            throw new Error("'loaded' is not implemented in SpriteSheetManager");
            return false;
        }

        public function sample(name:String, smoothing:Boolean = false):BitmapData {
            throw new Error("'sample' is not implemented in SpriteSheetManager");
            return null;
        }

        public function clear():Boolean {
            throw new Error("'clear' is not implemented in SpriteSheetManager");
            return false;
        }

        public function registerDecal(name:String, rectangle:Rectangle, scale9Rect:Rectangle = null):void {
            throw new Error("'registerDecal' is not implemented in SpriteSheetManager");
        }
    }
}
