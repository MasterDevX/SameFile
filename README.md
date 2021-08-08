# SameFile
This tool can be used to easily find duplicate files on your disk and save info about them to file.
## How it works
SameFile does not care about file names and extensions, the only thing matters here is files' content. The tool recursively walks over user-specified directory and uses ```md5sum``` from ```coreutils``` to calculate MD5 of each file found. Equal MD5 sums of two or more files means equal content of these files. Those are called duplicates. SameFile finds duplicate files on your disk and writes their paths to the text file.
## Requirements
- bash
- coreutils
## Installation
- Download ```SameFile.sh``` file from this repository
- Run ```chmod +x SameFile.sh``` to make it executable
## Usage
You can retrieve usage info anytime using ```--help```:
```
$ ./SameFile.sh --help
SameFile v1.0 by MasterDevX
Made in Ukraine

Usage:
./SameFile.sh <path> <output>

path   - Derectory to analyze.
output - Output file with results.

```
#### Example of usage
```
$ ./SameFile.sh /home/user/Documents/ duplicates.txt
```
The command above will search for duplicate files in ```/home/user/Documents/```. If SameFile will find any, it will create file ```duplicates.txt``` and save search results there.
#### Example of generated results file
```
1. c3b356ffe522cfcf9098641d3733922e [ 9,1M ]
    /home/user/Documents/Records/Video.mp4
    /home/user/Documents/SD/Video.mp4
    /home/user/Documents/August 2021/VID_0232.mp4

2. c88663bc1853d2cfa69d1ccb3371cc31 [ 4,6M ]
    /home/user/Documents/Charts/12.png
    /home/user/Documents/Archives/Charts/Archived_12.png

```
You can see that SameFile has generated text file containing enumerated list of all duplicate files in given directory. The header of each list entry has MD5 sum of duplicate file and it's size, below are paths to identical files.
