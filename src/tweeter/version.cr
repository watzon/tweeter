module Tweeter::Version
  extend self

  def major
    0
  end

  def minor
    1
  end

  def patch
    0
  end

  def pre
    nil
  end

  def to_h
    {
      "major" => major,
      "minor" => minor,
      "patch" => patch,
      "pre"   => pre,
    }
  end

  def to_a
    [major, minor, patch, pre].compact
  end

  def to_s
    to_a.join(".")
  end
end
