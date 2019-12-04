# Advent of Code 2019 solved with Elixir

So [Advent of Code](https://adventofcode.com/) is back, and this year I thought I’d take the opportunity to stretch my coding legs on a language that makes me uncomfortable: [Elixir](https://elixir-lang.org/).

I’ve used Elixir only once, a few years ago, for a tiny [Phoenix](https://www.phoenixframework.org/)-based API. The language’s bizarre elegance intrigued me; its lack of common programming features like `for` and `while` loops is offset by pattern-matching, pipelines, and immutability. I haven’t written enough Elixir code to become comfortable with these strange new tools, but they’re foreign enough to be interesting—and who knows what [unknown unknowns](https://en.wikipedia.org/wiki/There_are_known_knowns) are lurking beyond my horizon?

Anyway, I’m hoping that a month of floundering with Elixir will expand my mental framework of what programming actually means (like Ruby, Clojure, and functional programming did). So, onward to the code:

## Instructions

Really simple, actually (assuming that Elixir is [installed on your system](https://elixir-lang.org/install.html)):

1. Solving the day’s problem:

    `elixir day-01.exs`

2. Running tests:

    `elixir -r day-01.exs day-01-test.exs`

## What I Learned

### Day 1:

  In certain situations, [`Stream.iterate/2`](https://hexdocs.pm/elixir/Stream.html#iterate/2) can be [a concise alternative to recursion or reduction](https://github.com/zacwasielewski/adventofcode-2019-elixir/blob/master/day-01/day-01.exs#L20), especially combined with [`Enum.take_while/2`](https://hexdocs.pm/elixir/Enum.html#take_while/2).

### Day 2:

  Destructuring and pattern-matching are [powerful](https://github.com/zacwasielewski/adventofcode-2019-elixir/blob/bdb126c91325329b2e4c73eed1d90663d2b86e94/day-02/day-02.exs#L58). Pipes eliminate the mess of nested function calls. I’m finding myself defining way fewer intermediate variables, which reduces the mental overload of having to [name things](https://quotesondesign.com/phil-karlton/). Elixir just seems designed to eliminate syntactical clutter.

### Day 3:

  I guess I’ve used languages with first-class functions before, but never really noticed or took advantage of it. So I can’t believe [this](https://github.com/zacwasielewski/adventofcode-2019-elixir/blob/master/day-03/day-03.exs#L28) actually works!

### Day 4:

  Functions can be imported from other modules, and then called without their Module prefix. In this regard, but also generally, I’m surprised by [how intuitive Elixir’s scoping seems](https://thepugautomatic.com/2015/11/elixir-scoping/).