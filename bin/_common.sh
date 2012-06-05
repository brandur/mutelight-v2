target="$1"

if [ "$target" == "" ]; then
  echo "usage: $0 TARGET"
  exit 1
fi

# Handle a '.' at the end of target for completion convenience
target=${target%.}

if [ ! -f "$target.rb" ]; then
  echo "need $target.rb (attributes)"
  exit 1
fi

if [ ! -f "$target.md" ]; then
  echo "need $target.md (content)"
  exit 1
fi

if [ "$MUTELIGHT_HOST" == "" ]; then
  echo "must set MUTELIGHT_HOST"
  exit 1
fi

if [ "$MUTELIGHT_HTTP_API_KEY" == "" ]; then
  echo "must set MUTELIGHT_HTTP_API_KEY"
  exit 1
fi

path=$(cd $(dirname "$target"); pwd)
type=${path##*/}
slug=${target##*/}
#echo "type: $type slug: $slug"

if [ "$type" == "" ]; then
  echo "couldn't infer TYPE from TARGET"
  exit 1
fi

if [ "$slug" == "" ]; then
  echo "couldn't infer SLUG from TARGET"
  exit 1
fi
