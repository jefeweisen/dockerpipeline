sbtVersion := "0.13.5"

sbtPlugin := true

scalaVersion := "2.11.5"

val aipipelineVersion = "1.3.0-SNAPSHOT"

val awsJavaSdk = "com.amazonaws" % "aws-java-sdk" % "1.8.9.1"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "2.2.4" % "test",
  "org.allenai" %% "pipeline-core" % aipipelineVersion withSources() excludeAll (
    ExclusionRule(organization = "org.slf4j", name = "jcl-over-slf4j")
  ),
  awsJavaSdk,
  "io.spray" %%  "spray-json" % "1.3.1"
)

// Declare to SBT we want to send .jar to docker during "packageBin"
publishArtifact in (Compile, packageBin) := true

mainClass in assembly := Some("org.allenai.pipeline.examples.CountWordsAndLinesPipeline")

assemblyOutputPath in assembly ~= { defaultPath =>
  file("./dockerbuild") / "dockerpipeline.jar"
}

// Persuade intellij that it wants to send a .jar to docker.
// (Tested for use after importing build.sbt)
val setupIntellijTask = TaskKey[Unit]("setupIntellij", "hack: intellij sends jar artifact to docker")

setupIntellijTask <<= (baseDirectory, target, fullClasspath in Compile, packageBin in Compile, resources in Compile, streams) map {
  (baseDir, targetDir, cp, jar, res, s) => {
    Util1.copy((baseDir / "config" / "dockerpipeline_jar.xml"), (baseDir / ".idea" / "artifacts"))
  }
}
