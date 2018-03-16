[![Build Status](https://travis-ci.org/dcutting/Muck.svg?branch=master)](https://travis-ci.org/dcutting/Muck) [![Coverage Status](https://coveralls.io/repos/github/dcutting/Muck/badge.svg?branch=master)](https://coveralls.io/github/dcutting/Muck?branch=master)

# Muck

Muck analyses dependencies between "components" in your Swift projects.

You can specify what constitutes a "component" using the granularity option you provide. By default this is `module` meaning each Swift module will be considered a separate component. If you only have a single module (as is common), you can change this to `folder`, `file`, or `type` depending on how organised your source code is.

Some of the reports are about "cleanliness" in the sense defined by Uncle Bob in his [Clean Architecture](https://www.amazon.co.uk/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164) book. You can use Muck to find how far your components deviate from the main sequence.

## Running Muck

```
OVERVIEW: A dependency analyser for Swift projects

USAGE: muck <options>

OPTIONS:
  --granularity, -g
                    How to group components [type|file|folder|module] (defaults to module)
  --ignoreExterns, -i
                    Ignore dependencies external to specified modules
  --modules, -m     The modules to analyse (required)
  --project, -p     The Xcode project (specify either workspace or project but not both)
  --reports, -r     One or more reports to produce on stdout [decl|dep|dotdep|compclean|sysclean] (defaults to all)
  --scheme, -s      The Xcode scheme (required if workspace is specified)
  --target, -t      The Xcode target (permitted if project is specified)
  --verbose, -v     Verbose logging
  --workspace, -w   The Xcode workspace (specify either workspace or project but not both)
  --help            Display available options
```

You need to provide an Xcode workspace or project and the scheme you want to build for analysis. You also need to provide the list of Swift modules making up your project. In simple cases where you're building everything into a single app, this will probably just be the name of your app, but in cases where you have divided your code into separate frameworks, you'll need to include the names of those too.

Muck will then build your project and output some reports.

## Common scenarios

**You've got a simple iOS app with all your code organised into folders**

```
muck -p MyApp.xcodeproj -s MyApp -m MyApp -i -g folder
```

**You have all your code in one folder**

Muck is less useful in this case since it will have to consider each file to be a component which can be a bit noisy:

```
muck -p MyApp.xcodeproj -s MyApp -m MyApp -i -g file
```

**You have a complex project with many separate frameworks**

```
muck -w MyApp.xcworkspace -s MyApp -m MyApp Entity Network Service Utility Wireframe -i -g module
```

**You want to see a visualisation of the dependencies**

Muck can output a Graphviz `dot` format report which you can visualise with `dot`. This requires [Graphviz](http://brewformulas.org/Graphviz) to be installed.

```
muck -p MyApp.xcodeproj -s MyApp -m MyApp -i -g folder -r dotdep | dot -Tpdf -o deps.pdf
```
