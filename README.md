# Nhaccuatui CLI

Simple CLI for nhaccuatui.com.

![s1](https://cloud.githubusercontent.com/assets/2282642/26551907/fe819b3a-44ae-11e7-9f84-8fae4568fbb1.png)

![s2](https://cloud.githubusercontent.com/assets/2282642/26551910/02d0251c-44af-11e7-83a0-6b6841b1de51.png)

## Usage

```elixir
nct search "song name"
nct top-vn # => top 10 Vietnamese songs
nct top-us # => top 10 US-UK songs
nct top-kr # => top 10 Korea songs
nct play url # => play the song with the url

# more to be update
```

## TODO

* [x] Simple search
* [x] Get top song by countries
* Download song
* and more functionalities
* [x] Improve the UI output in terminal
* Add test

## Installation

Download this file https://github.com/kimquy/nhaccuatui_cli/blob/master/nct
and put it into executable folder.

```shell
cd ~
curl -O https://github.com/kimquy/nhaccuatui_cli/blob/master/nct
cp ./nct /usr/local/bin
```
