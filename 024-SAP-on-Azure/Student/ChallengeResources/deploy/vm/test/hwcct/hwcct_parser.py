'''
********************************************************************************
* Output of Results for 16M blocksize                                                            *
********************************************************************************


Results of Initial Write Test
=============================

Throughput Test:
----------------

   Trigger time:...................0.000178999 s   (Throughput: 2.86033e+07 MB/s)
   Asynchronous submit time:.......    1.219 s   (Throughput:     4200.13 MB/s)
   Synchronous submit time:........        0 s   (Throughput:           0 MB/s)
   I/O time:.......................   63.136 s   (Throughput:     81.0947 MB/s)
   Ratio trigger time to I/O time:.2.83514e-06

Latency Test:
-------------

   I/O time:.......................  68.0579 s   (Throughput:       75.23 MB/s)
   Latency:........................   212680 us


Results of Overwrite Test
=========================

Throughput Test:
----------------

   Trigger time:...................   0.0002 s   (Throughput:    2.56e+07 MB/s)
   Asynchronous submit time:.......   1.4758 s   (Throughput:      3469.3 MB/s)
   Synchronous submit time:........        0 s   (Throughput:           0 MB/s)
   I/O time:.......................  61.8264 s   (Throughput:     82.8124 MB/s)
   Ratio trigger time to I/O time:.3.23486e-06

Latency Test:
-------------

   I/O time:.......................  65.7086 s   (Throughput:     77.9197 MB/s)
   Latency:........................   205339 us


Results of Read Test
====================

Throughput Test:
----------------

   Trigger time:................... 0.000213 s   (Throughput: 2.40375e+07 MB/s)
   Asynchronous submit time:....... 0.743856 s   (Throughput:     6883.05 MB/s)
   Synchronous submit time:........        0 s   (Throughput:           0 MB/s)
   I/O time:.......................  40.2785 s   (Throughput:     127.114 MB/s)
   Ratio trigger time to I/O time:.5.28817e-06

Latency Test:
-------------

   I/O time:.......................  52.8839 s   (Throughput:     96.8157 MB/s)
   Latency:........................   165262 us



'''
import argparse
import json

global test_count
test_count = 0
hwcct_test = {}
hwcct_test["test"]={}
#hwcct_test["write"]=[]
#hwcct_test["read"]=[]
def test_blockParser(testName,line,f,testCase):
    testCase[testName] = {}
    line = skip_until(line, "Throughput Test", f)
    line = skip_until(line, "   I/O time", f)
    throughput = line.split("Throughput:")[1]
    throughput = throughput.split("MB/s")[0]
    throughput = throughput.strip()
    testCase[testName]["Throughput"] = {}
    testCase[testName]["Throughput"]["Value"] = throughput
    testCase[testName]["Throughput"]["Unit"] = "MB/s"
    line = skip_until(line, "Latency Test", f)
    line = skip_until(line, "   Latency", f)
    latency = line.strip()
    latency = latency.split(" ",1)[1]
    latency = latency.strip("us")
    latency = latency.strip()
    testCase[testName]["Latency"] = {}
    testCase[testName]["Latency"]["Value"] = latency
    testCase[testName]["Latency"]["Unit"] = "us"
    #hwcct_test["test"].append(testCase)
    return line

def skip_until(string, untilString, f_iter):
    while not string.startswith(untilString):
        string = next(f_iter)
    return string

def parseDISKTest(logfile, outputfile):
    with open(logfile) as f:
        for line in f:
            if line.startswith("***"):
                #skip one line and then capture the test name
                line = skip_until(line,"* Output",f)
                test_case = {}
                blocksize = line.split("for")[1]
                blocksize = 'B'+blocksize.split(" ")[1]
                test_case[blocksize] = {}
                #skip until line starts with Results
                line = skip_until(line,"Results",f)
                #Initial write test
                if line.startswith("Results of Initial Write Test"):
                    line = test_blockParser("InitialWriteTest",line,f,test_case[blocksize])
                #Overwrite test
                #skip until line starts with Results
                line = skip_until(line,"Results",f)
                if line.startswith("Results of Overwrite Test"):
                    line = test_blockParser("OverwriteTest",line,f,test_case[blocksize])
                #Read test
                line = skip_until(line,"Results",f)
                if line.startswith("Results of Read Test"):
                    line = test_blockParser("ReadTest",line,f,test_case[blocksize])
                hwcct_test["test"][blocksize]=test_case[blocksize]
    with open(outputfile, 'w') as outfile:
        json.dump(hwcct_test,outfile)

def main():
    print("This is a HWCCT DISK IO test parser")
    parser = argparse.ArgumentParser(description='Process ')
    parser.add_argument('-l', "--log", required=True, help='hwcct I/O test output files ')
    parser.add_argument('-o', "--output", required=True, help='write the parsed result to this file ')
    args = parser.parse_args()
    parseDISKTest(args.log, args.output)

if __name__=='__main__':
    main()
