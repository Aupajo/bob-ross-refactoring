# Bob Ross Refactoring

Inside this repository, you'll find a `Painting` class that needs refactoring. To help you, a set of tests have been included that let you know the Painting class is working correctly. Your job is to refactor the `Painting` class while keeping the tests passing. You are free to introduce new classes, files, and make changes to Painting's API as you see fit. Submit a pull request to showcase your refactoring!

This repository assumes you have Ruby 2.3+ and has no other dependencies.

To run the tests:

    ruby painting_spec.rb

If you don't have Ruby 2.3+, you can adjust the `render` test to outdent the `ART` heredoc:

```ruby
  @painting.render.must_equal <<-ART
..☁️...☁️...
...☁️.🌲....
...🌲..🌊...
....🗻...🌊.
..🌊...🌲...
ART
```
