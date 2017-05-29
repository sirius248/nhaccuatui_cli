# Nhaccuatui CLI

Simple CLI for nhaccuatui.com.

![s1](https://cloud.githubusercontent.com/assets/2282642/26551907/fe819b3a-44ae-11e7-9f84-8fae4568fbb1.png)

![s2](https://cloud.githubusercontent.com/assets/2282642/26551910/02d0251c-44af-11e7-83a0-6b6841b1de51.png)

![s3](https://cloud.githubusercontent.com/assets/2282642/26557030/ad6ded60-44c8-11e7-81a5-7926b59b77f4.png)

## Usage

```elixir
nct search "song name"
nct top-vn # => top 10 Vietnamese songs
nct top-us # => top 10 US-UK songs
nct top-kr # => top 10 Korea songs
nct play url # => play the song with the url

# => will download the song to local storage
# if out option is missed then the path will be current working directory
nct download url --out=path

# more to be update
```

## Requirement

The program require your machine need to have Ruby programming language and this gem `selenium-webdriver` in order to the download functionality to work.

## TODO

* [x] Simple search
* [x] Get top song by countries
* [x] Download song
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
