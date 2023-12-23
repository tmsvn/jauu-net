---
title: "Unjoyous OO Python"
date: 2010-06-26T17:38:13+02:00
draft: false
---

Today I spend some hours to complete a python project. Because the project
should expandable and manageable the functionality is splitted into classes,
packages and so on - python best practices.


But, as long as I program with python I don't understand why this language is
so hyped! Several years back I wanted to leave Perl as the scripting language
of choice (sometimes I still use Perl). As far as I remember I looked at Python
and Ruby and finally I decided to use Ruby. Nowadays, When I reexamine this
decision I must say that this decision was absolutely right!


There are several Python characteristics that bother me currently:


* no really clean object oriented design. Under the hood Python and Ruby are closer together then it seems but Python integrates a lot of extension that make this OO design not visible - why? Ruby on the other hand goes another way: it provides a clean OO interface and do a lot that this OO interface is usable. Why must the OO design artificial hidden from the programmer?
* classes are expandable: with ruby I can add or remove class methods at runtime or even modify already existing class methods. A really great feature which is really handy in some circumstances - where is this feature in python?


Sure, I am no python hacker but from the programmer experience the ruby interface seems quite more matured and cleaner.



```
666.factorial
NoMethodError: undefined method `factorial' for 666:Fixnum
class Fixnum
 def factorial
 (1..self).inject { |a,b| a \* b }
 end
end
23.factorial
25852016738884976640000

```

