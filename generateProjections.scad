// 8.9      x 5.9       x 5.7       in (max build size)
// 226.06   x 149.86    x 144.78    mm (max build size)
// 230      x 160       x 150       mm (subracting box size)

length = 230;
width = 160;
height = 150;
layerThickness = 0;
layerNumber = 0;
stlFile = "";

BoxPoints = [
    [-115, -80,   0], // 0
    [ 115, -80,   0], // 1
    [ 115,  80,   0], // 2
    [-115,  80,   0], // 3
    [-115, -80, 150], // 4
    [ 115, -80, 150], // 5
    [ 115,  80, 150], // 6
    [-115,  80, 150]  // 7
];

BoxFaces = [
    [0,1,2,3],
    [4,5,1,0],
    [7,6,5,4],
    [5,6,2,1],
    [6,7,3,2],
    [7,4,0,3],
];

difference() {
    import(stlFile, convexity=10);
    translate([0, 0, layerNumber * layerThickness])
        polyhedron(BoxPoints, BoxFaces);
}
