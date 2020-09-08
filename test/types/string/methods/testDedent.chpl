/* Test string.dedent() */

var testStrings = [

  // 0 Common use-case
  """0a
     0b
     0c""".dedent(),

  // 1 Newlines before/after
  """
  1a
  1b
  1c""".dedent(),

  // 2 Note there is trailing whitespace in this example:
  """  
  2a
    
  2b
  2c""".dedent(),

  // 3 Remove 4 columns of indentation (there are 5 columns before b and c)
  """3a
     3b
     3c""".dedent(columns=4),

  // 4 removing (up to) 10 columns (ignoring first line though)
  """ 4a
        4b
         4c
          4d
           4e""".dedent(columns=10),


  // 5 Don't ignore the indentation level of the first line
  """5a
     5b
     5c""".dedent(ignoreFirst=false),

  // 6 Mixing tabs and whitespace
  """6a
    6b
  		6c
  	 6d
   	6e""".dedent(),

  // 7
  """
      7a
    7b
  7c
    7d
      7e""".dedent(),

  // 8
  """ 8a
      8b
      8c""".dedent(),

  // 9 - ignoreFirst test
  """ 9a
      9b
      9c""".dedent(ignoreFirst=false),

  // 10 ignoreFirst + columns test
  """ 10a
      10b
      10c""".dedent(ignoreFirst=false, columns=2),

  // 11
  """ 11a
      11b
      11c""".dedent(ignoreFirst=true, columns=2),

  // 12
  """ 12a
        12b
         12c
          12d
           12e""".dedent(),

  // 13
  """      13a
          13b
         13c
        13d
       13e""".dedent(),

  // 14
  """
   14a
    14b
 14c""".dedent(),

  // 15 Empty lines
  """
  15a

  15b
  15c""".dedent(),

  // 16 Note there is trailing white space in this string
  """
  16a
 
  16b
  16c""".dedent(),

  // 17 Note there is trailing white space in this string
  """
  17a
  
  17b
  17c""".dedent(columns=2),


  // 18 - Ignore tabs when columns>0
  """
   18a
  	18b
  		18c""".dedent(ignoreFirst=false, columns=3),

  // 19 - no-op
  "19a 19b".dedent(ignoreFirst=false),


  ];


// Test driver loop
for i in testStrings.indices {
  writeln(testStrings[i]);
  writeln('---');
}
