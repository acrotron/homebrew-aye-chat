class AyeChat < Formula
  desc "AI-powered terminal workspace"
  homepage "https://ayechat.ai"
  url "https://files.pythonhosted.org/packages/source/a/ayechat/ayechat-0.31.0.tar.gz"
  sha256 "2bcf872105e53256962b568a74242ee77c40a022edea478f91d4684edd0336f7"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create virtualenv structure during install phase
    # The actual pip install happens in post_install to avoid dylib relocation
    system "python3.12", "-m", "venv", libexec
    # Write a wrapper script that will call the real aye binary after post_install
    (bin/"aye").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/aye" "$@"
    EOS
  end

  def post_install
    # Install packages in post_install to bypass Homebrew's dylib relocation
    # which fails on native Python extensions like orjson
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install", "ayechat==#{version}"
  end

  test do
    system bin/"aye", "--version"
  end
end
