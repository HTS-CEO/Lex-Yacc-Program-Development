# Compiler Project - Lexical and Syntax Analysis

## Features
- Character/digit identification
- Email validation
- Basic C/C++ syntax analysis

## Installation
```bash
sudo apt-get install flex bison gcc
flex compiler.l
gcc lex.yy.c -o compiler -lfl
./compiler

compiler.l        # Main Lex/Flex file
compiler.y        # Yacc/Bison grammar (optional)
test.c            # Sample input file

Input: Hello123
Output:
Letter: H
Letter: e
Letter: l
Letter: l
Letter: o
Digit: 1
Digit: 2
Digit: 3

Input: user@domain.com
Output: Valid email: user@domain.com

Input: @invalid.com
Output: Invalid email: @invalid.com

This version:
1. Uses clean markdown formatting
2. Includes all essential sections
3. Has proper code blocks for commands
4. Provides quick copy-paste functionality
5. Maintains good readability on GitHub/GitLab

Simply copy this entire snippet and paste it into a new `README.md` file in your project directory.
