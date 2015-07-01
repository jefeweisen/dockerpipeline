import sbt._
import Keys._

object Util1 {
  def copy(finder: PathFinder, dst: File) = {
    IO.copy(finder.get map {f => (f, dst / f.getName)})
  }
}

