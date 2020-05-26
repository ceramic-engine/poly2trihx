package poly2tri;

class EdgeEvent 
{
    public var constrained_edge:Edge = null;
    public var right:Bool = false;

    public function new() 
    {

    }

    inline public function clear() {
        constrained_edge = null;
        right = false;
    }
}
