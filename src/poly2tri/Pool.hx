package poly2tri;

class Pool {

    public static var enabled:Bool = true;

    public static function recycleAll():Void {
        pointArrayIndex = 0;
    }

    public static function clearAll():Void {
        pointArrayIndex = 0;
        pointArrayPool = [];
    }

    static var pointArrayIndex:Int = 0;
    static var pointArrayPool:Array<Array<Point>> = [];

    public static function getPointArray():Array<Point> {
        if (enabled) {
            if (pointArrayIndex == pointArrayPool.length) {
                // Create
                var val:Array<Point> = [];
                pointArrayIndex++;
                pointArrayPool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = pointArrayPool[pointArrayIndex];
                if (val.length > 0) {
                    setArrayLength(val, 0);
                }
                pointArrayIndex++;
                return val;
            }
        }
        else {
            return [];
        }
    }

    static var triangleArrayIndex:Int = 0;
    static var triangleArrayPool:Array<Array<Triangle>> = [];

    public static function getTriangleArray():Array<Triangle> {
        if (enabled) {
            if (triangleArrayIndex == triangleArrayPool.length) {
                // Create
                var val:Array<Triangle> = [];
                triangleArrayIndex++;
                triangleArrayPool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = triangleArrayPool[triangleArrayIndex];
                if (val.length > 0) {
                    setArrayLength(val, 0);
                }
                triangleArrayIndex++;
                return val;
            }
        }
        else {
            return [];
        }
    }

    static var edgeArrayIndex:Int = 0;
    static var edgeArrayPool:Array<Array<Edge>> = [];

    public static function getEdgeArray():Array<Edge> {
        if (enabled) {
            if (edgeArrayIndex == edgeArrayPool.length) {
                // Create
                var val:Array<Edge> = [];
                edgeArrayIndex++;
                edgeArrayPool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = edgeArrayPool[edgeArrayIndex];
                if (val.length > 0) {
                    setArrayLength(val, 0);
                }
                edgeArrayIndex++;
                return val;
            }
        }
        else {
            return [];
        }
    }

    static var edgeIndex:Int = 0;
    static var edgePool:Array<Edge> = [];

    public static function getEdge(p1:Point, p2:Point):Edge {
        if (enabled) {
            if (edgeIndex == edgePool.length) {
                // Create
                var val:Edge = new Edge(p1, p2);
                edgeIndex++;
                edgePool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = edgePool[edgeIndex];
                val.reset(p1, p2);
                edgeIndex++;
                return val;
            }
        }
        else {
            return new Edge(p1, p2);
        }
    }

    static var pointIndex:Int = 0;
    static var pointPool:Array<Point> = [];

    public static function getPoint(x:Float, y:Float):Point {
        if (enabled) {
            if (pointIndex == pointPool.length) {
                // Create
                var val:Point = new Point(x, y);
                pointIndex++;
                pointPool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = pointPool[pointIndex];
                val.reset(x, y);
                pointIndex++;
                return val;
            }
        }
        else {
            return new Point(x, y);
        }
    }

    static var triangleIndex:Int = 0;
    static var trianglePool:Array<Triangle> = [];

    public static function getTriangle(p1:Point, p2:Point, p3:Point, fixOrientation = false, checkOrientation = true):Triangle {
        if (enabled) {
            if (triangleIndex == trianglePool.length) {
                // Create
                var val:Triangle = new Triangle(p1, p2, p3, fixOrientation, checkOrientation);
                triangleIndex++;
                trianglePool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = trianglePool[triangleIndex];
                val.reset(p1, p2, p3, fixOrientation, checkOrientation);
                triangleIndex++;
                return val;
            }
        }
        else {
            return new Triangle(p1, p2, p3, fixOrientation, checkOrientation);
        }
    }

    static var nodeIndex:Int = 0;
    static var nodePool:Array<Node> = [];

    public static function getNode(point:Point, triangle:Triangle = null):Node {
        if (enabled) {
            if (nodeIndex == nodePool.length) {
                // Create
                var val:Node = new Node(point, triangle);
                nodeIndex++;
                nodePool.push(val);
                return val;
            }
            else {
                // Reuse
                var val = nodePool[nodeIndex];
                val.reset(point, triangle);
                nodeIndex++;
                return val;
            }
        }
        else {
            return new Node(point, triangle);
        }
    }

    inline public static function setArrayLength<T>(array:Array<T>, length:Int):Void {

        if (array.length != length) {
#if cpp
            untyped array.__SetSize(length);
#else
            if (array.length > length) {
                array.splice(length, array.length - length);
            }
            else {
                var dArray:Array<Dynamic> = array;
                dArray[length - 1] = null;
            }
#end
        }
    }

}