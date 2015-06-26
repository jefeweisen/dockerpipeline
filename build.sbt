sbtVersion := "0.13.5"

sbtPlugin := true

scalaVersion := "2.11.5"

val aipipelineVersion = "1.3.0-SNAPSHOT"

val awsJavaSdk = "com.amazonaws" % "aws-java-sdk" % "1.8.9.1"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "2.2.4" % "test",
  "org.allenai" %% "pipeline-core" % aipipelineVersion withSources(),
  "org.allenai" %% "pipeline-contrib" % aipipelineVersion withSources(),
  awsJavaSdk,
  "io.spray" %%  "spray-json" % "1.3.1"
)
