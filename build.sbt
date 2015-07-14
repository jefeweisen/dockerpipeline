sbtVersion := "0.13.5"

sbtPlugin := true

scalaVersion := "2.11.5"

val aipipelineVersion = "1.3.0-SNAPSHOT"
val awsJavaSdk = ("com.amazonaws" % "aws-java-sdk" % "1.8.9.1" 
    exclude ("commons-logging", "commons-logging") 
    exclude("org.slf4j","log4j-over-slf4j") 
    exclude ("org.slf4j", "jcl-over-slf4j")
    exclude("org.slf4j","slf4j-log4j12"))

val sparkCore = ("org.apache.spark" %% "spark-core" % "1.2.2" 
//    exclude("org.slf4j","log4j-over-slf4j") 
    exclude("org.mortbay.jetty", "servlet-api") 
    exclude("commons-beanutils", "commons-beanutils-core") 
    exclude("commons-collections", "commons-collections")  
//    exclude("commons-logging", "commons-logging") 
    exclude("com.esotericsoftware.minlog", "minlog") 
//    exclude("com.codahale.metrics", "metrics-core")  
    exclude("org.slf4j","slf4j-log4j12") 
    exclude("org.apache.hadoop","hadoop-yarn-common") 
    exclude("javax.activation", "activation") 
    excludeAll (
    	ExclusionRule(organization = "org.slf4j", name = "jcl-over-slf4j")
    ))

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "2.2.4" % "test",
  ("org.allenai" %% "pipeline-core" % aipipelineVersion withSources()
      exclude("org.slf4j", "log4j-over-slf4j")
      exclude("org.slf4j", "slf4j-log4j12")
      exclude("org.slf4j", "jcl-over-slf4j")
  ),
  ("org.allenai" %% "pipeline-contrib" % aipipelineVersion withSources()
      exclude("org.slf4j", "log4j-over-slf4j")
      exclude("org.slf4j", "slf4j-log4j12")
      exclude("org.slf4j", "jcl-over-slf4j")
  ),
  awsJavaSdk,
  sparkCore,
  "io.spray" %%  "spray-json" % "1.3.1"
)

// Declare to SBT we want to send .jar to docker during "packageBin"
publishArtifact in (Compile, packageBin) := true

mainClass in assembly := Some("org.allenai.pipeline.examples.CountWordsAndLinesPipeline")

assemblyOutputPath in assembly ~= { defaultPath =>
  file("./dockerbuild") / "dockerpipeline.jar"
}

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case "package-info.class" => MergeStrategy.last
    case "plugin.properties" => MergeStrategy.last
    case x => old(x)
  }
}

// Persuade intellij that it wants to send a .jar to docker.
// (Tested for use after importing build.sbt)
val setupIntellijTask = TaskKey[Unit]("setupIntellij", "hack: intellij sends jar artifact to docker")

setupIntellijTask <<= (baseDirectory, target, fullClasspath in Compile, packageBin in Compile, resources in Compile, streams) map {
  (baseDir, targetDir, cp, jar, res, s) => {
    Util1.copy((baseDir / "config" / "dockerpipeline_jar.xml"), (baseDir / ".idea" / "artifacts"))
  }
}
