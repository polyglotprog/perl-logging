package Test::Logging::Logger;

use v5.38;
use lib './lib';
use lib './t';

use Logging::Logger;

use Test::More tests => 2;
use Test::IO;

my ($expected, $stdout, $stderr);

#
# Trace with Dumped Value
#
sub trace_with_dumped_value {
  my $logger = Logging::Logger->new(TRACE);

  my $value = { troubleshoot => { me => 'please' } };
  $logger->log(TRACE, "This is trace with dumped value:", $value);
}

$expected = <<~EXPECTED;
    \x1b\[38;5;207m\x1b\[1m  trace\x1b\[0m This is trace with dumped value:
    \$VAR1 = {
              'troubleshoot' => {
                                  'me' => 'please'
                                }
            };
    EXPECTED

subtest 'Trace with dumped value' => sub {
  output_is(\&trace_with_dumped_value, $expected, 'stdout and stderr');
  stdout_is(\&trace_with_dumped_value, $expected, 'stdout only');
  stderr_is(\&trace_with_dumped_value, '', 'stderr only');
};


#
# Logging Levels
#
sub logging_levels {
  my $logger = Logging::Logger->new(TRACE);

  $logger->log(TRACE,   'This is trace.');
  $logger->log(DEBUG,   'This is debug.');
  $logger->log(INFO,    'This is info.');
  $logger->log(WARNING, 'This is warning.');
  $logger->log(ERROR,   'This is error.');
}

$expected = <<~EXPECTED;
    \x1b\[38;5;207m\x1b\[1m  trace\x1b\[0m This is trace.
    \x1b\[96m\x1b\[1m  debug\x1b\[0m This is debug.
    \x1b\[94m\x1b\[1m   info\x1b\[0m This is info.
    \x1b\[93m\x1b\[1mwarning\x1b\[0m This is warning.
    \x1b\[91m\x1b\[1m  error\x1b\[0m This is error.
    EXPECTED
$stdout = <<~EXPECTED;
    \x1b\[38;5;207m\x1b\[1m  trace\x1b\[0m This is trace.
    \x1b\[96m\x1b\[1m  debug\x1b\[0m This is debug.
    \x1b\[94m\x1b\[1m   info\x1b\[0m This is info.
    EXPECTED
$stderr = <<~EXPECTED;
    \x1b\[93m\x1b\[1mwarning\x1b\[0m This is warning.
    \x1b\[91m\x1b\[1m  error\x1b\[0m This is error.
    EXPECTED

subtest 'Logging levels' => sub {
  output_is(\&logging_levels, $expected, 'stdout and stderr');
  stdout_is(\&logging_levels, $stdout, 'stdout only');
  stderr_is(\&logging_levels, $stderr, 'stderr only');
};
