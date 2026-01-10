import save.ChromaSave;
import save.util.ChromaConverter;

typedef FlxChromaSaveSoundData =
{
	@:optional var volume:Float;
	@:optional var mute:Bool;
}

class FlxChromaSaveManager
{
    public var saves:Map<String, ChromaSave> = new Map();

    public inline static function getSoundData(volume:Float, mute:Bool):FlxChromaSaveSoundData
        return {
			volume: volume;
			mute: mute;
	    };


    public static inline function getSlotString(saveName:String, slot:Int):String
        return 
        #if FLX_USE_SAVE_SLOTS
        '${saveName}_${slot}'
        #else
        save
        #end;

    public function createSave(save:String, slot:Int = 0):ChromaSave
    {
        save = getSlotString(save, slot);

        var curSave = new ChromaSave(save);

        saves.set(save, curSave);

        return curSave;
    }

    public function setField(save:String, key:String, v:Dynamic, slot:Int = 0):Void
    {
        save = getSlotString(save, slot);

        saves.get(save).set(key, v);
    }

    public function getField(save:String, key:String, slot:Int = 0):Dynamic
    {
        save = getSlotString(save, slot);

        return saves.get(save).get(key);
    }
}