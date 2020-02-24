## Maven

Maven is the most popular build tool for Java apps. What it does:

- Manages dependencies by downloading libraries from repositories
- Compiles the code, runs the tests
- Distributes your own binaries to remote repositories
- ... basically you can ask it to do anything

Maven is often compared to other tools especially to Ant and Gradle. The best thing about Maven comparing to these
tools (especially to Ant) is that it strives for standardization which is good for several important reasons:

- Projects don't differ that much with regards to building process. It's easy for people to change the projects as
  they have the same structures, phases and share most of the plugins.
- Tools (like IDE, CI Servers) can easily recognize Maven Projects and import them. Both IntelliJ and Eclipse can
  recognize a Maven project and thus it becomes IDE-independent

With Ant and Gradle every time you enter a project there is its own custom set of scripts.

# Step 1 - Getting Acquainted

- Read about dependencies and transitive dependencies [[1](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)]
  > There are two types of Maven dependencies: (a) Direct: dependencies defined in pom.xml file under the <dependencies/> section. (b) Transitive: dependencies that are dependencies of direct dependencies.
- Learn what Super POM is and what Effective POM is [[1](https://books.sonatype.com/mvnref-book/reference/pom-relationships-sect-pom.html#ex-super-pom)]
  > POM: Project Object Model. The POM file we declare in our maven project is called **the Simplest POM**. All simplest POM files has been inherits from another file named **Super POM**, similar as all java files inherited from java.lang.object file. There are set of default configurations declared in the default POM which we can change in out Simplest POM. **Effective POM** is the merged version of the Super POM & Simplest POM.
- Read about `packaging` and create a project with one module that has `packaging=war` [[1](http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)]
  > **packaging** is one of the phase of **default** **_maven build lifecycle_**. There are three built-in lifecycles:  
  > a) default: there are couple of **build phases/stages** for the default lifecycle: (**VCTPVID**)  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i) **validate** - validate the project is correct and all necessary information is available  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ii) **compile** - compile the source code of the project  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iii) **test** - test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; iv) **package** - take the compiled code and package it in its distributable format, such as a JAR.  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v) **verify** - run any checks on results of integration tests to ensure quality criteria are met  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vi) **install** - install the package into the local repository, for use as a dependency in other projects locally  
  > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vii) **deploy** - done in the build environment, copies the final package to the remote repository for sharing with other developers and projects.  
  > b) clean,  
  > c) site
  >
  > A particular type of packagin (by defining `<package>` in POM file) can effect build lifecycle of a project. Each type of packaging(`jar`, `war`, `ear`, `rar`, `ejb`, `pom` etc) can contains a list of **plugin goals** to bind to a particular phase. If we want to add additional custom goals into our build phases, other than the default goals, we can define those into the `<build<pluginManagement><plugins><plugin>` section of the POM file.
- HOW ABOUT KNOWING `PLUGIN GOALS` / [PLUGIN BINDINGS](http://maven.apache.org/ref/3.6.3/maven-core/default-bindings.html)?
- Add a dependency `org.testng:testng:6.10`
- Add any Java class to your `src/main/java` and an XML file to your `src/main/resources`. And do the same in
  `src/test/xxx` dirs.
- After `mvn test-compile` find where in `target/` dir your classes and resources ended up
- After `mvn package` unpack your JAR file from `target/` dir and find where your classes and resources are

_Check yourself_. You must be able to:

- Run `mvn install` successfully
- List all the dependencies that your project has (including transitives) with one command
- Explore Effective POM and find all the default sections that were applied to your project. Even those that you didn't
  explicitly write.

_Tip_: dependency tree and Effective POM are the most important diagnostic tools that you need. Every time there is
an issue these 2 tools are there to help. Your IDE probably has means to generate both of them - try to find the
shortcuts, you'll need this often.

# Step 2 - Lifecycle, phases, plugins

- Learn what Plugins are and what is a `goal` ([link](./articles/maven-plugins.md))
- Read and learn what is a lifecycle and which lifecycles Maven has. Explore which phases each of the lifecycle has.
  ([link](./articles/maven-lifecycles-n-phases.md))
- Declare `maven-surefire-plugin` and bind its `test` goal to a `test` phase
- Explore files
  [default-bindings.xml](https://github.com/apache/maven/blob/master/maven-core/src/main/resources/META-INF/plexus/default-bindings.xml) and
  [components.xml](https://github.com/apache/maven/blob/master/maven-core/src/test/resources/META-INF/plexus/components.xml) -
  these files contain default plugins
- Ensure that what you see in `default-bindings.xml` is what's listed in your Effective POM

_Check yourself_. You must be able to:

- Find a connection between packaging and the default plugins that are declared for it
- Find packaging and its configuration in `default-bindings.xml`
- Inspect in console which plugins and executions are run during `mvn install`. Does this match to what you see in
  Effective POM?

_Pro_: Note that `maven-compiler-plugin` is declared with `default-compile` execution for `packaging=war`. You inherit
it, but can you cancel it in your POM? Hint: you can, but find out how.

# Step 3 - Debugging

- Create a unit test with `assertTrue(true)` statement. Put a breakpoint on this line. Find a way to debug the tests
  that are run by `maven-surefire-plugin` (hint: look for info about forks in Surefire).
- Run `mvn install` and pick any random line in the output. Find the source code that prints the output (could be
  Maven core parts or one of plugins). Debug (`mvnDebug` utility that comes with Maven) should help with this.
- Think: given some code writes something into console, what would be a systematic way of finding which class/method
  does this?

_Tip_: How does Remote Debugging work? This is a client-server interaction where server (JVM that's debugged)
communicates with the client (IDE) sending the information like current line of code executed in every thread,
variables, etc. Client (IDE) can ask the server to stop the execution of the program and receive some alternatives
commands. Note, that if the binary that you debug is built not from the code that you look at - the lines of code won't
match and the IDE won't stop at the places where you would expect but will stop at lines with JavaDocs for instance.
So make sure your binary was built from the sources at hand.

_Tip_: Often if we don't understand how things work instead of googling and guessing it's much (much!) easier to read
the source code of the tool. If the code is not simple - debugging becomes a real life saver. Have it as a habit to work
with the sources of the tools instead of googling - you'll have a much better grip on the technologies.

# Step 4 - Inheritance and Aggregation

- Create 3 modules - 1 is parent and the other 2 are included as `<modules>`. Child1 needs to have Child2 as a
  dependency.
- Read about reactor in Maven
- Play with `<parent>` tag - what difference does it make?
- Find a way to override dependencies and plugins in child modules
- Research mvn flags like `-pl`, `-am`, `-amd`

_Check yourself_. You must be able to:

- Explain the difference between Inheritance and Aggregation in Maven.
- Invoke phases and plugins against one child but not the other
- Explain what does "reactor" term mean in Maven

# Step 5 - Advanced Dependencies

- Read about `dependencyManagement`
- Find out which scopes can a dependency have ([link](./articles/maven-scopes.md))
- Come up with examples of libs for each of the scopes (explore SLF4J, Lombok as some interesting examples)
- Get acquainted with classifiers and types - last parts of dependency coordinates
- Find your local maven repository, learn which phase and plugin delivers the artifacts there
- Read about maven repositories and what plugin and phase deploy artifacts there
- Deploy artifacts of the project to the local maven repo on file system (not install, but deploy)

_Check yourself_. You must be able to:

- Override a version of transitive dependency
- Install and deploy multiple artifacts built from _single_ maven module

# Puzzles

There is a problematic test in branch `puzzle-nBZyIqbL` - it passes in IDE and when you run `mvn test`. But strangely
it fails when `mvn package` is run. Figure out why.
