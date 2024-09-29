package Test::IO;

use v5.38;

use Test::Builder;

require Exporter;
our @ISA    = 'Exporter';
our @EXPORT = qw(
    output_is
    stderr_is
    stdout_is
);

sub output_is {
  my ($block, $expected, $name) = @_;
  my $got = capture_output($block);

  my $test = Test::Builder->new;
  $test->is_eq($got, $expected, $name // '');
}

sub stdout_is {
  my ($block, $expected, $name) = @_;
  my $got = capture_stdout($block);

  my $test = Test::Builder->new;
  $test->is_eq($got, $expected, $name // '');
}

sub stderr_is {
  my ($block, $expected, $name) = @_;
  my $got = capture_stderr($block);

  my $test = Test::Builder->new;
  $test->is_eq($got, $expected, $name // '');
}

sub capture_output {
  my ($block) = (@_);
  my $output = '';

  do {
    local *STDOUT;
    local *STDERR = *STDOUT;

    open STDOUT, '>', \$output;
    $block->();

    return $output;
  }
}

sub capture_stdout {
  my ($block) = (@_);
  my $output = '';

  do {
    local *STDOUT;

    open STDOUT, '>', \$output;
    $block->();

    return $output;
  }
}

sub capture_stderr {
  my ($block) = (@_);
  my $output = '';

  do {
    local *STDERR;

    open STDERR, '>', \$output;
    $block->();

    return $output;
  }
}

1;
