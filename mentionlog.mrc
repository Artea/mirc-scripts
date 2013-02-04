raw *:* {
  ;;echo @debug $1-
}
*:TEXT:*:#:{
  if ($me isin $1-) {
    if ($window(@nicklogger)) echo @nicklogger [ $+ $timestamp $+ ] - $chan < $+ $nick.pnick $+ > $1-
  }
}
ON *:START: {
  if (!$window(@nicklogger)) window @nicklogger
}

alias nicklog {
  if (!$window(@nicklogger)) window @nicklogger
}
