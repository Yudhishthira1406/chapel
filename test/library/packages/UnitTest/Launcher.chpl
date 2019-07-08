/*
  This launcher will be used to run the test files and catch the halts.
  You can set whether or not to descend recursively into 
  subdirectories (defaults to true) using `--subdir`
*/
module Launcher {
  use FileSystem;
  use Spawn;
  use Path;
  use TestResult;
  use Help;
  config const subdir = true;
  config const keepExec = false;

  proc main(args: [] string) {
    var dirs: [1..0] string,
        files: [1..0] string;
    var hadInvalidFile = false;
    var programName = args[0];
    for a in args[1..] {
      if a == "-h" || a == "--help" {
        writeln("Usage: ", programName, " <options> filename [filenames] directoryname [directorynames]");
        printUsage();
        exit(1); // returning 1 from main is also an option
      }
      else {
        try! {
          if isFile(a) {
            files.push_back(a);
          }
          else if isDir(a) {
            dirs.push_back(a);
          }
          else {
            writeln("[Error: ",a," is not a valid file or directory]");
            hadInvalidFile = true;
          }
        }
      }
    }

    if hadInvalidFile && files.size == 0 && dirs.size == 0 {
      exit(2);
    }

    if files.size == 0 && dirs.size == 0 {
      dirs.push_back(".");
    }
    
    var result =  new TestResult();

    for tests in files {
      try {
        testFile(tests, result);
      }
      catch e {
        writeln("Caught an Exception in Running Test File: ", tests);
        writeln(e);
      }
    }

    for dir in dirs {
      try {
        testDirectory(dir, result);
      }
      catch e {
        writeln("Caught an Exception in Running Test Directory: ", dir);
        writeln(e);
      }
    }
      
    result.printErrors();
    writeln(result.separator2);
    result.printResult();
  }

  pragma "no doc"
  /*Docs: Todo*/
  proc runAndLog(executable,fileName, ref result,skipId = 0) throws {
    var separator1 = result.separator1,
        separator2 = result.separator2;
    var testName: string,
        flavour: string,
        line: string,
        tempString: string;
    var curIndex = 0;
    var sep1Found = false,
        haltOccured = false;
    
    var exec = spawn(["./"+executable,"--skipId",skipId:string,"--numLocales",
              numLocales:string], stdout = PIPE, stderr = PIPE); //Executing the file
    //std output pipe
    while exec.stdout.readline(line) {
      if line.strip() == separator1 then sep1Found = true;
      else if line.strip() == separator2 && sep1Found {
        select flavour {
          when "ERROR" do result.addError(testName, tempString);
          when "FAIL" do result.addFailure(testName, tempString);
          when "SKIPPED" do result.addSkip(testName,tempString);
        }
        tempString = "";
        sep1Found = false;
      }
      else if sep1Found then tempString+=line;
      else {
        var temp = line.strip().split(":");
        if temp[1].strip().endsWith("]") {
          var strSplit = temp[1].strip().split("]");
          var testNameIndex = strSplit[1].split("[");
          testName = fileName+": "+testNameIndex[1];
          curIndex = testNameIndex[2]: int;
          result.startTest();
          if temp.size > 1 {
            flavour = temp[2].strip();
            if flavour == "OK" then result.addSuccess(testName);
          }
          tempString = "";
        }  
      }
    }
    //this is to check the error
    if exec.stderr.readline(line) { 
      tempString = line;
      while exec.stderr.readline(line) do tempString+=line;
      if testName!="" {
        result.addError(testName,tempString);
        haltOccured =  true;
      }
    }
    exec.wait();//wait till the subprocess is complete
    if haltOccured then runAndLog(executable, fileName, result, curIndex);
  }

  pragma "no doc"
  /*Docs: Todo*/
  proc testFile(file, ref result) throws {
    var fileName = basename(file);
    if fileName.endsWith(".chpl") {
      var line: string;
      var compErr = false;
      var tempName = fileName.split(".chpl");
      var executable = tempName[1];
      if isFile(executable) {
        FileSystem.remove(executable);
      }
      var sub = spawn(["chpl",file,"-o",executable,"-M."],stderr = PIPE); //Compiling the file
      if sub.stderr.readline(line) {
        writeln(line);
        compErr = true;
      }
      sub.wait();
      if !compErr {
        runAndLog(executable,fileName,result);
        if !keepExec {
          FileSystem.remove(executable);
        }
      }
      else {
        writeln("Compilation Error in ",fileName);
        writeln("Possible Reasons can be passing a non-test function to UnitTest.runTest()");
      }
    }
  }

  pragma "no doc"
  /*Docs: Todo*/
  proc testDirectory(dir, ref result) throws {
    for file in findfiles(startdir = dir, recursive = subdir) {
      testFile(file, result);
    }
  }
}