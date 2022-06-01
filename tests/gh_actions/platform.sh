if [ -z "${PLATFORM:-}" ]; then
  PLATFORM=$RUNNER_OS;
fi

if [ "$PLATFORM" == "macOS" ]; then
  PLATFORM="macosx";
fi

if [ "$PLATFORM" == "Linux" ]; then
  PLATFORM="linux";
fi

if [ -z "$PLATFORM" ]; then
  if [ "$(uname)" == "Linux" ]; then
    PLATFORM="linux";
  else
    PLATFORM="macosx";
  fi;
fi
