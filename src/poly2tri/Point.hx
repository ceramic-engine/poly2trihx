package poly2tri;

class Point 
{
    public var id:Int;

    public var x:Float;
    public var y:Float;

    /// The edges this point constitutes an upper ending point
    #if (haxe_ver >= 3)
    public var edge_list(get, null):Array<Edge>;
    #else
    public var edge_list(get_edge_list, null):Array<Edge>;
    #end

    public function new(x:Float, y:Float)
    {
        this.x = x;
        this.y = y;

        id = C_ID;
        C_ID++;

    }

    inline public function reset(x:Float, y:Float):Void {
        
        this.x = x;
        this.y = y;
        var edge_list = this.edge_list;
        if (edge_list.length > 0)
            Pool.setArrayLength(edge_list, 0);

    }

    inline function get_edge_list() 
    {
        if (edge_list==null) edge_list = Pool.getEdgeArray();
        return edge_list;
    }



    inline public function equals(that:Point):Bool 
    {
        return (this.x == that.x) && (this.y == that.y);
    }

    inline public static function sortPoints(points:Array<Point>) 
    {
        SortPoints.sort(points);
    }

    inline public static function cmpPoints(l:Point,r:Point)
    {
        return @:privateAccess SortPoints.cmp(l, r);
    }

    public function toString() 
    {
        return "Point(" + x + ", " + y + ")";
    }

    public static var C_ID = 0;




}

