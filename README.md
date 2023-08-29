## Prerequisites

The development, written in the λProlog programming language, via
[Teyjus](https://github.com/teyjus/teyjus/), goes with the submitted paper "Property-Based Testing by Elaborating Proof Outlines."

## Repository structure

The files in this folder were used by the authors to develop the examples and counterexamples in the paper.  The latex sources of the paper draw code from the following three sources.

- sect5/ dir with code for random generation and subsuming sect 4.
- sect6.*  Single mod file for the Church Rosser case study
- sect7.*  Single mod file for testing via linear logic

The reader who is interested in testing the examples in the paper will find those various files and examples better organized in the following directory.

- one/ working dir for all the above w/o repetitions, but slightly different from paper.  In particular, llinterp/llcheck is used also with both Horn clause and hereditary Harrop formulas (see the discussion on page 25).

## Running the tests examples and counterexamples

To compile and link all the code using the Teyjus implementation of λProlog, simply type "make" in the directory one/.  Then use the commands

> tjsim harness

to try the sample queries.  These queries can be found in the files lists.mod, cr.mod, and counter.mod on commented lines that contain the symbol "?-".

