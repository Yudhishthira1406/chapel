record Coord {
  var x: int;
  var y: int;
  var z: int;
}

var D: domain(Coord);

var c1: Coord = new Coord(0, 0, 1);
var c2: Coord = new Coord(0, 1, 0);
var c3: Coord = new Coord(1, 0, 0);

D += c1;
D += c2;
D += c3;

var Name: [D] string;

Name(c1) = "z basis coordinate";
Name(c2) = "y basis coordinate";
Name(c3) = "x basis coordinate";

for coord in D {
  writeln("coord ", coord, " is called ", Name(coord));
}
