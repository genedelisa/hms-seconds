//
//  SPArguments.swift
//  hms-seconds
//
//  Created by Gene De Lisa on 11/27/19.
//  Copyright © 2019 Gene De Lisa. All rights reserved.
//

import Foundation

import TSCUtility
import TSCBasic
//import func TSCLibc.exit

// the old name
//import SPMUtility

struct TSCArgumentParser {
    
    // The first argument is always the executable, drop it
    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    // let executable = ProcessInfo.processInfo.arguments.first!
    // let exe = CommandLine.arguments.first!
    
    // commandName is the executable name complete with path.
    // do the lastcomponent cha cha if you want to use it here.
    // let parser = ArgumentParser(commandName: CommandLine.arguments.first!,
    
    let parser = ArgumentParser(commandName: "hms-seconds",
                                usage: "[options] H:M:S",
                                overview: "Convert time in H:M:S format to seconds",
                                seeAlso: "time")
    // Mark: The arguments
    // var inputstring: OptionArgument<String>
    var verbose: OptionArgument<Bool>
    
    var po: PositionalArgument<String>
    
    init() {
        
        po = parser.add(positional: "H:M:S input string",
                        kind: String.self,
                        optional: false,
                        usage: "e.g. 1:2:3 or 01:02:03",
                        completion: ShellCompletion.none)
        
        // options are always optional
        //        inputstring = parser.add(option: "--hms",
        //                                 shortName: "-s",
        //                                 kind: String.self,
        //                                 //optional: false,
        //                                 usage: "The input h:m:s string",
        //                                 completion: ShellCompletion.none)
        
        verbose  = parser.add(option: "--verbose",
                              shortName: "-v",
                              kind: Bool.self,
                              usage: "Be unduly prolix in the output")
    }
    
    func processArguments(arguments: ArgumentParser.Result) {
        if let hms = arguments.get(po) {
            if let v = arguments.get(verbose) {
                let frob = HMS2Seconds(hms: hms, isVerbose: v)
                let seconds = frob.hmsToSeconds()
                print("\(seconds)")
            } else {
                let frob = HMS2Seconds(hms: hms, isVerbose: false)
                let seconds = frob.hmsToSeconds()
                print("\(seconds)")
            }
        }
        // a non-optional positional argument will throw an Error if not specified
        // so I'm not doing this:
        //        if let hms = arguments.get(inputstring) {
        //            if let v = arguments.get(verbose) {
        //                let frob = HMS2Seconds(hms: hms, isVerbose: v)
        //                let seconds = frob.hmsToSeconds()
        //                print("\(seconds)")
        //            } else {
        //                let frob = HMS2Seconds(hms: hms, isVerbose: false)
        //                let seconds = frob.hmsToSeconds()
        //                print("\(seconds)")
        //            }
        //        } else {
        //            print("Yo, input a string already")
        //            exit(EXIT_FAILURE)
        //        }
    }
    
    func crack() {
        do {
            let parsedArguments = try parser.parse(arguments)
            processArguments(arguments: parsedArguments)
        } catch ArgumentParserError.expectedValue(let value) {
            print("Missing value for argument \(value).")
            exit(EXIT_FAILURE)
        } catch ArgumentParserError.expectedArguments(let parser, let stringArray) {
            //            print("Parser: \(parser) Missing arguments: \(stringArray.joined()).")
            print("Missing argument[s]: \(stringArray.joined()).")
            //stdoutStream is in TSCBasic
            parser.printUsage(on: stdoutStream)
            exit(EXIT_FAILURE)
        } catch let error as ArgumentParserError {
            print("ArgumentParserError: \(error.description)")
            exit(EXIT_FAILURE)
        } catch let error {
            print("error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }
    }
}
