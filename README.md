Attila
===========

_A Test design and test case generator tool._  
[Homepage](https://github.com/famished-tiger/Attila)

### What is Attila? ###
For the moment being, very little since the __Attila__ project is still in early inception.

### Vision ###
Make __Attila__ a test design tool that is also able to generate executable test cases.  

With __Attila__ a tester should be able to model the system under test (SUT) with:  
* Domain testing (i.e. test variables/factors and their equivalence classes),  
* Use case scenarios

In addition to a representation of the SUT, Attila will also allow the tester to: 
* Specify test data generation rules (e.g. pick tester-defined representative values or produce 
 'randomized' data).  
* Determine the test case generation strategy (e.g. all-pairs).  
* Use text templates for the generation of the 

### FAQ ###
_Q_: Yet another test tool?  
_A_: __Attila__  won't replace your favourite test tool. The purpose of __Attila__ is to help in the
generation of test scripts that are similar to each other. Instead of writing down a large family
of test scenarios that are basically "variations on the same theme", let do a program compute
these variations for you. In short, __Attila__ will be a test case generator.

_Q_: Aren't there other test case generators in the Galaxy?  
_A_: Yes. [TODO: provide links]. However, there are much less numerous than genuine test tools. 
A number of them are pretty expensive and most test case generators have no test script generation
capabilities (i.e. to them, a test case is limited to a set of values assigned to test variables).
 

_Q_: What kind of tests could Attila generate?  
_A_: __Attila__ will be focused on functional (blackbox) system testing. Specialized tests such
performance or security won't be targeted in __Attila__.

_Q_: In what programming language will __Attila__ be written?  
_A:_ In Ruby. There are chances that specific parts to be implemented in the [Picat language](http://www.picat-lang.org/).


_Q_: As a tester, should I need to know Ruby or Picat?  
_A_: No since most of the input will be done via a DSL (Domain Specific Language).
In other words, testers will enter their model and commands in a syntax that is designed
specifically for testers. 

_Q_: Can I use __Attila__ to test systems that are written in other languages?  
_A_: Yes. __Attila__ is technology and language neutral. __Attila__ will generate test scenarios
as text files. Any test tool that supports test scenarios in text format could be a potential target
for __Attila__.

_Q_: Why the name Attila?  
_A_: There are at least two stories. 

According to a first account: Attila was named so because it was 
the fearsome enemy of software defects (remember Attila the Hun -the Scourge of God-).

On the other hand, there is a rumour telling that the name stems from the right-recursive acronym: 
__ATTILA__ - _A_dvanced _T_es_TI_ng too_L_ _A_ttila


Copyright
---------
Copyright (c) 2013, Dimitri Geshef. 
__Attila__ is released under the MIT License see [LICENSE.txt](https://github.com/famished-tiger/Attila/blob/master/LICENSE.txt) for details.