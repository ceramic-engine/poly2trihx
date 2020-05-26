package poly2tri;


class Basin 
{
    public var left_node:Node;
    public var bottom_node:Node;
    public var right_node:Node;
    public var width:Float;
    public var left_highest:Bool;
    
    public function new() 
    {
        clear();
    }

    inline public function clear() 
    {

        this.left_node    = null ;
        this.bottom_node  = null ;
        this.right_node   = null ;
        this.width        = 0.0  ;
        this.left_highest = false;
    }

}