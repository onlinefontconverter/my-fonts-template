# Hello world docker action

This action prints "Hello World" or "Hello" + the name of a person to greet to the log.

## Inputs

## `fonts_dir`

**Required** The name of the person to greet. Default `"World"`.

## `github_token`

**Required** The name of the person to greet. Default `"World"`.

## Outputs

## `time`

The time we greeted you.

## Example usage

uses: actions/hello-world-docker-action@v1
with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  fonts_dir: 'fonts'
