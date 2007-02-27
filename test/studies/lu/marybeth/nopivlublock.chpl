// Block LU without pivoting.
// Magic square of dimension 10, permuted according to
// Matlab's p matrix for LU (so it doesn't need pivoting),
// is used as test matrix A.

param n = 10;
param blk = 5;

const AD = [1..n,1..n];
var A: [AD] real;

initA(A);

writeln("Unfactored Matrix:");
writeln(A);

for jblk in [1..n] by blk {
  var low = jblk;
  var hi = if (jblk + blk-1) <= n then jblk+blk-1 else n;
  for k in [low..hi] {
    if (A(k,k) != 0.0) { 
      for i in [k+1..n] {
        A(i,k) = A(i,k)/A(k,k);
      }
    }
    for i in [k+1..n] {
      for j in [k+1..hi] {
        A(i,j) -= A(i,k)*A(k,j);
      }
    }
  }
  if (hi < n) {
    for j in [1..n-hi] {
      for k in [1..blk] {
        if (A(low + k-1,hi + j) != 0.0) {
          for i in [k+1..blk] {
            A(low+i-1,hi+j) = A(low+i-1,hi+j) - A(low+k-1,hi+j)*A(low+i-1,low+k-1);
          }
        }
      }
    }
    for i in [hi+1..n] {
      for j in [hi+1..n] {
        for k in [low..hi] {
          A(i,j) -= A(i,k)*A(k,j);
        }
      }
    }
  }
}
writeln();
writeln("Factored Matrix:");
writeln(A);

def initA(A){

// Create full permutation matrix to permute A.
// Very expensive, but easy way to permute the matrix
// so that pivoting isn't needed.

var P, temp: [A.dom] real;

A(1,1) = 92.0;
A(1,2) = 99.0;
A(1,3) = 1.0;
A(1,4) = 8.0;
A(1,5) = 15.0;
A(1,6) = 67.0;
A(1,7) = 74.0;
A(1,8) = 51.0;
A(1,9) = 58.0;
A(1,10) = 40.0;

A(2,1) = 98.0;
A(2,2) = 80.0; 
A(2,3) = 7.0;
A(2,4) = 14.0;
A(2,5) = 16.0;
A(2,6) = 73.0;
A(2,7) = 55.0;
A(2,8) = 57.0;
A(2,9) = 64.0;
A(2,10) = 41.0;

A(3,1) = 4.0;
A(3,2) = 81.0;
A(3,3) = 88.0;
A(3,4) = 20.0;
A(3,5) = 22.0;
A(3,6) = 54.0;
A(3,7) = 56.0;
A(3,8) = 63.0;
A(3,9) = 70.0;
A(3,10) = 47.0;

A(4,1) = 85.0;
A(4,2) = 87.0;
A(4,3) = 19.0;
A(4,4) = 21.0;
A(4,5) = 3.0;
A(4,6) = 60.0;
A(4,7) = 62.0;
A(4,8) = 69.0;
A(4,9) = 71.0;
A(4,10) = 28.0;

A(5,1) = 86.0;
A(5,2) = 93.0;
A(5,3) = 25.0;
A(5,4) = 2.0;
A(5,5) = 9.0;
A(5,6) = 61.0;
A(5,7) = 68.0;
A(5,8) = 75.0;
A(5,9) = 52.0;
A(5,10) = 34.0;

A(6,1) = 17.0;
A(6,2) = 24.0;
A(6,3) = 76.0;
A(6,4) = 83.0;
A(6,5) = 90.0;
A(6,6) = 42.0;
A(6,7) = 49.0;
A(6,8) = 26.0;
A(6,9) = 33.0;
A(6,10) = 65.0;

A(7,1) = 23.0;
A(7,2) = 5.0;
A(7,3) = 82.0;
A(7,4) = 89.0;
A(7,5) = 91.0;
A(7,6) = 48.0;
A(7,7) = 30.0;
A(7,8) = 32.0;
A(7,9) = 39.0;
A(7,10) = 66.0;

A(8,1) = 79.0;
A(8,2) = 6.0;
A(8,3) = 13.0;
A(8,4) = 95.0;
A(8,5) = 97.0;
A(8,6) = 29.0;
A(8,7) = 31.0;
A(8,8) = 38.0;
A(8,9) = 45.0;
A(8,10) = 72.0;

A(9,1) = 10.0;
A(9,2) = 12.0;
A(9,3) = 94.0;
A(9,4) = 96.0;
A(9,5) = 78.0;
A(9,6) = 35.0;
A(9,7) = 37.0;
A(9,8) = 44.0;
A(9,9) = 46.0;
A(9,10) = 53.0;

A(10,1) = 11.0;
A(10,2) = 18.0;
A(10,3) = 100.0;
A(10,4) = 77.0;
A(10,5) = 84.0;
A(10,6) = 36.0;
A(10,7) = 43.0;
A(10,8) = 50.0;
A(10,9) = 27.0;
A(10,10) = 59.0;

P = 0.0;
P(1,2) = 1.0;
P(2,3) = 1.0;
P(3,7) = 1.0;
P(4,8) = 1.0;
P(5,9) = 1.0;
P(6,5) = 1.0;
P(7,1) = 1.0;
P(8,4) = 1.0;
P(9,10) = 1.0;
P(10,6) = 1.0;

temp = 0.0;
const i = 1..10;
for i in [1..10] {
  for j in [1..10] {
    for k in [1..10] {
      temp(i,j) = temp(i,j) + P(i,k)*A(k,j);
    }
  }
}
A = temp;
}
