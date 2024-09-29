package Logging::Logger;

use v5.38;

use Console::AnsiColor qw(
    $BOLD
    $BRIGHT_BLUE
    $BRIGHT_CYAN
    $BRIGHT_GREEN
    $BRIGHT_MAGENTA
    $BRIGHT_RED
    $BRIGHT_YELLOW
    $RESET

    set_color
);
use Data::Dumper;

require Exporter;
our @ISA    = 'Exporter';
our @EXPORT = qw(
    NONE
    DEBUG
    ERROR
    INFO
    WARNING
    TRACE
);

use constant {
  NONE    => 0,
  ERROR   => 1,
  WARNING => 2,
  INFO    => 3,
  DEBUG   => 4,
  TRACE   => 5,
};

my %MESSAGE_LEVELS = (
  none    => NONE,
  error   => ERROR,
  warning => WARNING,
  info    => INFO,
  debug   => DEBUG,
  trace   => TRACE,
);

{
  # %MESSAGE_LEVELS only has string keys so far. Add corresponding integer keys
  # so we can look up the value by either integer value or name.
  foreach my $level (values %MESSAGE_LEVELS) {
    $MESSAGE_LEVELS{$level} = $level;
  }
}

# Message Colors
my %MESSAGE_COLORS = (
  ERROR()   => "${BRIGHT_RED         }${BOLD}  error${RESET}",
  WARNING() => "${BRIGHT_YELLOW      }${BOLD}warning${RESET}",
  INFO()    => "${BRIGHT_BLUE        }${BOLD}   info${RESET}",
  DEBUG()   => "${BRIGHT_CYAN        }${BOLD}  debug${RESET}",
  TRACE()   => "${\( set_color(207) )}${BOLD}  trace${RESET}",
);

sub new {
  my ($class, $message_level) = @_;
  return bless { message_level => $message_level // INFO }, $class;
}

sub set_message_level {
  my ($self, $value) = @_;
  my $message_level = $MESSAGE_LEVELS{$value};
  if (!$message_level) {
    die "$message_level is not a valid message level.";
  }
  $self->{message_level} = $message_level;
}

sub is_error_enabled {
  my ($self) = @_;
  return $self->{message_level} >= ERROR;
}

sub is_warning_enabled {
  my ($self) = @_;
  return $self->{message_level} >= WARNING;
}

sub is_info_enabled {
  my ($self) = @_;
  return $self->{message_level} >= INFO;
}

sub is_debug_enabled {
  my ($self) = @_;
  return $self->{message_level} >= DEBUG;
}

sub is_trace_enabled {
  my ($self) = @_;
  return $self->{message_level} >= TRACE;
}

sub log {
  my ($self, $level, $message, $value) = @_;
  if ($level <= $self->{message_level}) {
    if ($level <= WARNING) {
      say STDERR "$MESSAGE_COLORS{$level} $message";
      print STDERR Dumper($value) if $value;
    } else {
      say STDOUT "$MESSAGE_COLORS{$level} $message";
      print STDOUT Dumper($value) if $value;
    }
  }
}

sub error {
  my ($self, $message, $value) = @_;
  if ($self->{message_level} >= ERROR) {
    say STDERR "$MESSAGE_COLORS{ERROR()} $message";
    print STDERR Dumper($value) if $value;
  }
}

sub warning {
  my ($self, $message, $value) = @_;
  if ($self->{message_level} >= WARNING) {
    say STDERR "$MESSAGE_COLORS{WARNING()} $message";
    print STDERR Dumper($value) if $value;
  }
}

sub info {
  my ($self, $message, $value) = @_;
  if ($self->{message_level} >= INFO) {
    say STDOUT "$MESSAGE_COLORS{INFO()} $message";
    print STDOUT Dumper($value) if $value;
  }
}

sub debug {
  my ($self, $message, $value) = @_;
  if ($self->{message_level} >= DEBUG) {
    say STDOUT "$MESSAGE_COLORS{DEBUG()} $message";
    print STDOUT Dumper($value) if $value;
  }
}

sub trace {
  my ($self, $message, $value) = @_;
  if ($self->{message_level} >= TRACE) {
    say STDOUT "$MESSAGE_COLORS{TRACE()} $message";
    print STDOUT Dumper($value) if $value;
  }
}

1;
