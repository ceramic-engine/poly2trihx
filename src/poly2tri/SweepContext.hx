package poly2tri;

class SweepContext 
{
    public var triangles:Array<Triangle>;
    public var points:Array<Point>;
    public var edge_list:Array<Edge>;

    public var front:AdvancingFront;
    public var head:Point;
    public var tail:Point;

    public var basin:Basin;
    public var edge_event:EdgeEvent;



    public function new()
    {
        triangles = Pool.getTriangleArray();
        points = Pool.getPointArray();
        edge_list = Pool.getEdgeArray();

        basin = new Basin();
        edge_event = new EdgeEvent();

    }

    public function reset() {

        triangles = Pool.getTriangleArray();
        points = Pool.getPointArray();
        edge_list = Pool.getEdgeArray();

        basin.clear();
        edge_event.clear();



    }


    inline function addPoints(points:Array<Point>) 
    {
        for (i in 0...points.length)
        {
            this.points.push( points[i] );
        }
    }



    inline public function addPolyline(polyline:Array<Point>) 
    {
        initEdges(polyline);
        addPoints(polyline);
    }




    inline function initEdges(polyline:Array<Point>) 
    {

        for (n in 0...polyline.length) 
        {

            var nx = polyline[(n + 1) % polyline.length]; 
            edge_list.push ( Pool.getEdge(polyline[n], nx) );
                                    
        }
    }


    inline public function initTriangulation()
    {
        //OPT
        var xmin = points[0].x;
        var xmax = points[0].x;
        var ymin = points[0].y;
        var ymax = points[0].y;

        // Calculate bounds
        for (i in 0...points.length) 
        {
            var p = points[i];
            if (p.x > xmax) xmax = p.x;
            if (p.x < xmin) xmin = p.x;
            if (p.y > ymax) ymax = p.y;
            if (p.y < ymin) ymin = p.y;
        }

        var dx = Constants.kAlpha * (xmax - xmin);
        var dy = Constants.kAlpha * (ymax - ymin);

        this.head = Pool.getPoint(xmax + dx, ymin - dy);
        this.tail = Pool.getPoint(xmin - dy, ymin - dy);


        // Sort points along y-axis
        Point.sortPoints(points);

    }

    inline public function locateNode(point:Point):Node 
    {
        return this.front.locateNode(point.x);
    }

    inline public function createAdvancingFront()
    {
        // Initial triangle
        var triangle = Pool.getTriangle(points[0], this.tail, this.head);

        var head = Pool.getNode( triangle.points[1], triangle );
        var middle = Pool.getNode( triangle.points[0], triangle );
        var tail = Pool.getNode( triangle.points[2] );

        if (this.front == null) {
            this.front = new AdvancingFront(head, tail);
        }
        else {
            this.front.reset(head, tail);
        }

        head.next   = middle;
        middle.next = tail;
        middle.prev = head;
        tail.prev   = middle;

    }

    inline public function removeNode(node:Node) 
    {
        // do nothing
    }

    inline public function mapTriangleToNodes(triangle:Triangle) 
    {
        for (n in 0...3) 
        {
            if (triangle.neighbors[n] == null) 
            {
                var neighbor = this.front.locatePoint(triangle.pointCW(triangle.points[n]));
                if (neighbor != null) neighbor.triangle = triangle;
            }
        }
    }

    static var _tmpArray:Array<Triangle> = [];

    public function meshClean(t:Triangle)
    {
        var tmp = _tmpArray;
        Pool.setArrayLength(tmp, 0);
        tmp.push(t);
        while( true ) {
            var t = tmp.pop();
            if( t == null ) break;
            if( t.interior ) continue;
            t.interior = true;
            this.triangles.push(t);
            for (n in 0...3)
                if (!t.constrained_edge[n])
                    tmp.push(t.neighbors[n]);
        }
    }
}