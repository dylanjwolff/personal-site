module ProjectsMD exposing (bachelorThesis, deployerFixture)

deployerFixture : String
deployerFixture = """
### Deployer Fixture
---

Maven plugin that automatically spins up application dependencies in Kubernetes
for system-level tests and then tears down cleanly once the tests are run
"""

bachelorThesis : String
bachelorThesis = """
### Distributed Mutational File Fuzzer

Used the WinAppDbg library in Python to write a mutational fuzzer for Windows
applications. Scraped media files from various websites and did a 14 hour run
against VLC media player with 4 computers * 2-4 processes per computer, finding
~4 bugs (from unique instruction pointers). Did an informal analysis of the
impact of various fuzzing parameters on the ability of the fuzzer to find these
bugs 
"""
