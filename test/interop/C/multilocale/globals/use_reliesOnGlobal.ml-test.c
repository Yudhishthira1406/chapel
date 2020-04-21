// This test currently fails sporadically. whatIsGlobal() reads a global that is
// uninitialized. Globals are not default-value-initialized in multilocale runs
// because they are just wide pointers to heap. See "library-init" version of
// this test for the "correct" version of this.

#include "lib/reliesOnGlobal.h"

// Test of calling an exported Chapel library that relies on a global.
int main(int argc, char* argv[]) {
  // Initialize the Chapel runtime and standard modules
  chpl_library_init(argc, argv);

  // Call the function
  whatIsGlobal();

  // Shutdown the Chapel runtime and standard modules
  chpl_library_finalize();

  return 0;
}
