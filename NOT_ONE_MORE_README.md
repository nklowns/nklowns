![GitHub followers](https://img.shields.io/github/followers/nklowns?label=follow&style=social)
![Readme visitors](https://visitor-badge.glitch.me/badge?page_id=nklowns.nklowns&left_text=View)
[![Website](https://img.shields.io/badge/Website-blue.svg?&style=flat-square&logo=Google-Chrome&logoColor=white)](https://cloudlessv.netlify.app/)

## 🎯 For geeks, statistics

![](https://github-readme-stats.vercel.app/api?username=nklowns&show_icons=true)

[![](https://github-readme-stats.vercel.app/api/top-langs/?username=nklowns)](https://github.com/anuraghazra/github-readme-stats)

## 🗂️ Project Highlights

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=nklowns&repo=nklowns)](https://github.com/nklowns/nklowns)
[![Portfolio Card](https://github-readme-stats.vercel.app/api/pin/?username=nklowns&repo=portfolio-netlify)](https://github.com/nklowns/portfolio-netlify)


## Useful Pwsh Commands

### ffmpeg recursive converter
Use a filetype to iliterate on ffmpeg, in the example below is searching for `*.mkv` and converting to `.mp4`
```ps1
Get-ChildItem *.mkv -Recurse | ForEach-Object { ffmpeg -i "$($_.FullName)"-y -c:a aac -c:v libx264 -movflags +faststart -crf 28 -preset faster -tune film "$([io.path]::ChangeExtension($_.FullName, '.mp4'))" }
```
<details>
<summary>Breakdown command, click to expand!</summary>

Usage of [x264](https://www.lambdatest.com/web-technologies/mpeg4) refers to better compability compared to [x265](https://www.lambdatest.com/web-technologies/hevc)

Input file is the fullname with path
```ps1 
ffmpeg -i "$($_.FullName)"
```
The `-y` used to force the overwrite of existing files. you can remove the option -y if you want to be asked if to overwrite a file with the same name.

The `-c:a aac` used to encode audio to aac

The `-c:v libx264` used to encode video to hvec:264x

The `-movflags +faststart` Fast start is for internet streaming as it puts header at the begining of the file.

The `-crf 28` For x264, sane values are between 18 and 28. The default is 23. the lower, the higher the bitrate. for more info look <br>
Here! (https://slhck.info/video/2017/02/24/crf-guide.html)

The `-preset faster` Using fast saves about 10% encoding time, faster 25%. ultrafast will save 55% at the expense of much lower quality. <br>
`-preset veryslow` gives you the best tradeoff x264 can offer, by spending more CPU time searching for ways to represent more detail per bit. Compared to medium, veryslow requires 280% of the original encoding time, with only minimal improvements over slower in terms of quality. <br>

If you're encoding once to keep the result for a long time, and/or serve it up over the internet, use `-preset veryslow`. Or at least `-preset medium`. You pay the CPU cost once, and reap the savings in file size (for a given quality) repeatedly. Going from medium to slow, the time needed increases by about 40%. Going to slower instead would result in about 100% more time needed.

The `-tune film` intended for high-bitrate/high-quality movie content. Lower deblocking is used here. for more info look <br>
here! (https://superuser.com/a/564404)

The output file is defined as Fullname with path and an optional extension modification.
```ps1
"$([io.path]::ChangeExtension($_.FullName, '.mp4'))"
```

Replace the code above with this to keep the file extension.
```ps1
"$($_.FullName)"
```

</details>


