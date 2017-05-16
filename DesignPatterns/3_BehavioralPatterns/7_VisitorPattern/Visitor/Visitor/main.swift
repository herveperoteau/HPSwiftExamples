
let shapes = ShapeCollection()

let areaVisitor = AreaVisitor()
shapes.accept(areaVisitor)

print("Area: \(areaVisitor.totalArea)")
print("---")

let edgeVisitor = EdgesVisitor()
shapes.accept(edgeVisitor)

print("Edges: \(edgeVisitor.totalEdges)")
