package flixel.util;

#if FLX_REPLACE_FLX_SAVE

import flixel.FlxG;
import save.ChromaSave;

class FlxSaveWrapper
{
    
    // FlxSave-style dynamic data
    public var data(default, null):Dynamic;
    public var name(get, never):String;
    public var path(get, never):String;
    public var isBound(get, never):Bool;

    private var chromaSave:ChromaSave;
    private var saveKey:String;

    public function new(saveName:String = "flixel", ?_ignoredPath:String)
    {
        saveKey = saveName;

        if (FlxG.chromaSave == null)
        {
            trace("Warning: ChromaSave not initialized yet!");
            return;
        }

        // create or get the save
        chromaSave = FlxG.chromaSave.createSave(saveName);

        // reference the parsed JSON directly
        if (chromaSave.json == null)
            chromaSave.json = {}; // empty object if nothing loaded

        data = chromaSave.json;
    }
    public static function validate(str:String):String
    {
        return str;
    }

    public function mergeDataFrom(name:String, ?path:String, ?overwrite:Bool = false, ?eraseSave:Bool = true, ?minFileSize:Int = 0):Bool
    {
        flush();
        return true;
    }

    /** Bind a save (just points to the ChromaSave json) */
    public function bind(saveName:String, ?_ignoredPath:String):Bool
    {
        saveKey = saveName;

        if (FlxG.chromaSave == null)
            return false;

        chromaSave = FlxG.chromaSave.createSave(saveName);

        if (chromaSave.json == null)
            chromaSave.json = {};

        data = chromaSave.json;
        return true;
    }

    /** Flush changes back to ChromaSave */
    public function flush(minFileSize:Int = 0):Bool
    {
        if (chromaSave != null)
        {
            chromaSave.save(); // your ChromaSave.save() should serialize `json` to disk
            return true;
        }
        return false;
    }

    /** Erase the save */
    public function erase():Bool
    {
        if (chromaSave != null)
        {
            chromaSave.json = {}; // reset to empty Dynamic object
            data = chromaSave.json;
            chromaSave.save();
            return true;
        }
        return false;
    }

    /** Destroy references */
    public function destroy():Void
    {
        chromaSave = null;
        data = null;
    }

    /** Compatibility stubs for FlxSave methods you may want */
    public function isEmpty():Bool
    {
        return chromaSave == null || Reflect.fields(chromaSave.json).length == 0;
    }

    inline function get_name() return saveKey;
    inline function get_path() return null;
    inline function get_isBound() return chromaSave != null;
}

#end
