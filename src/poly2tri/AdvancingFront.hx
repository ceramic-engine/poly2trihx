package poly2tri;

class AdvancingFront
{
    public var head:Node;
    public var tail:Node;
    public var search_node:Node;

    public function new(head:Node, tail:Node) 
    {
        reset(head, tail);
    }

    inline public function reset(head:Node, tail:Node) {
        this.search_node = this.head = head;
        this.tail = tail;
    }

    inline public function locateNode(x:Float):Node 
    {
        var node:Node = this.search_node;
        var result:Node = null;

        if (x < node.value) 
        {
            while ((node = node.prev) != null) 
            {
                if (x >= node.value) 
                {
                    this.search_node = node;
                    result = node;
                    break;
                }
            }
        }
        else 
        {
            while ((node = node.next) != null) 
            {
                if (x < node.value) 
                {
                    this.search_node = node.prev;
                    result = node.prev;
                    break;
                }
            }
        }
        
        return result;
    }

    inline public function locatePoint(point:Point):Node 
    {
        var px:Float = point.x;
        //var node:* = this.FindSearchNode(px);
        var node:Node = this.search_node;
        var nx:Float = node.point.x;

        if (px == nx) 
        {
            if (!point.equals(node.point)) 
            {
                // We might have two nodes with same x value for a short time
                if (point.equals(node.prev.point)) 
                {
                    node = node.prev;
                }
                else if (point.equals(node.next.point)) 
                {
                    node = node.next;
                } 
                else 
                {
                    throw 'Invalid AdvancingFront.locatePoint call!';
                }
            }
        } 
        else if (px < nx) 
        {
            while ((node = node.prev) != null)
                if (point.equals(node.point)) break;
        } 
        else 
        {
            while ((node = node.next) != null) 
                if (point.equals(node.point)) break;
        }

        if (node != null) this.search_node = node;
        return node;

    }
}