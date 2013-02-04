alias jsontest {
  var %url = http://api.twitter.com/1/statuses/show/152074025408004096.json
  var %json = {"mydata":"myvalue","mynumbers":[1,2,3,5],"mystuff":{"otherdata":{"2":"4","6":"blah"}}}

  var %user = $json(%url,user,screen_name)
  var %tweet = $json(%url,text)
  msg $active Twitter: @ $+ %user $+ : %tweet

}

alias testtoken {
  var %test $tokenize(32,test the tokenizer again,1)
  echo %test
}

alias isTwitterURL {
  if ($1-) {
    if (twitter.com/ isin $1- && (/status/ isin $1- || /statuses/ isin $1-)) {
      return 1
    }
    else {
      return 0
    }
  }
}
alias getTweet {
  if (%tweetflood == 1) {
    ;;echo -a Flood detected, ignoring request.
    return
  }
  else {
    set %tweetflood 1
  }

  .timer 1 5 /resetTweetFlood
  var %regex = (https?://twitter.com/(\#\!/)?\w+/(status|statuses)/\d+)
  var %temp  = $regex($1-, %regex)
  var %url = $regml(1)
  var %id = 0

  var %four = $wildtok(%url,*,4,47)
  var %five $wildtok(%url,*,5,47)
  if (%four == status || %four == statuses) {
    %id = $wildtok(%url,*,5,47)
  }
  if (%id == 0 && (%five  == status || %five == statuses)) {
    %id = $wildtok(%url,*,6,47)
  }
  if (%id == 0 || $len(%id) < 1) {
    msg # Invalid tweet URL
    return
  }

  var %jsonURL = http://api.twitter.com/1/statuses/show/ $+ %id $+ .json

  ;; Variables to output
  var %user = $json(%jsonURL,user,screen_name)
  var %tweet = $json(%jsonURL,text)

  ;; Send the message to the channel
  msg # Twitter: @ $+ %user $+ : $replace(%tweet,$chr(10),$chr(32))


}
alias resetTweetFlood {
  set %tweetflood 0
  ;;echo -a Tweet flooding reset.
}
on *:TEXT:*:#: {
  if ($isTwitterURL($1) == 1) {
    $getTweet($1)
  }
}
